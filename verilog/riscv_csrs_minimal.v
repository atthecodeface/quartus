//a Note: created by CDL 1.4 - do not hand edit without recognizing it will be out of sync with the source
// Output mode 0 (VMOD=1, standard verilog=0)
// Verilog option comb reg suffix '__var'
// Verilog option include_displays 0
// Verilog option include_assertions 1
// Verilog option sv_assertions 0
// Verilog option assert delay string '<NULL>'
// Verilog option include_coverage 0
// Verilog option clock_gate_module_instance_type 'banana'
// Verilog option clock_gate_module_instance_extra_ports ''
// Verilog option use_always_at_star 1
// Verilog option clocks_must_have_enables 1

//a Module riscv_csrs_minimal
    //   
    //   This module implements a minimal set of RISC-V CSRs, as per v2.1 (May
    //   2016) of the RISC-V instruction set manual user level ISA and v1.9.1
    //   of the privilege architecture (Nov 2016), with the exception that
    //   MTIME has been removed (as this seems to be the correct thing to do).
    //   
    //   The privilege specifcation (v1.10) indicates:
    //   
    //   * meip is read-only and is derived from the external irq in to this module
    //   
    //   * mtip is read-only, cleared by writing to the memory-mapped timer comparator
    //   
    //   * msip is read-write in a memory-mapped register somewhere
    //   
    //   Hence the irqs structure must provide these three signals
    //   
    //   
    //   Minimal CSRs as only machine mode and debug mode are supported.
    //   In debug mode every register access is supported.
    //   In machine mode then every register EXCEPT access to ??? is supported.
    //   
    //   Given machine mode is the only mode supported:
    //   
    //   * there are no SEI and UEI interrupt pins in to this module
    //   
    //   * SEIP and UEIP are not supported
    //   
    //   * STIP and UTIP are not supported
    //   
    //   * SSIP and USIP are not supported
    //   
    //   * mstatus.SIE and mstatus.UIE (and previous versions) are hardwired to 0
    //   
    //   * mstatus.SPP and mstatus.UPP are hardwired to 0
    //   
    //   The mip (machine interrupt pending register) therefore is:
    //   
    //   {20b0, MEIP, 3b0, MTIP, 3b0, MSIP, 3b0}
    //   
    //   The mie (machine interrupt enable register) is:
    //   
    //   {20b0, MEIE, 3b0, MTIE, 3b0, MSIE, 3b0}
    //   
    //   
    //   The instruction to the pipeline to request an interrupt (which is only
    //   taken if an instruction is in uncommitted in the execution stage) must be generated using the
    //   execution mode and the interrupt enable bits and the interrupt pending
    //   bits.
    //   
    //   Hence the 'take interrupt' is (mip & mie) != 0 && mstatus.MIE && (current mode >= machine mode) && (current mode != debug mode).
    //   
    //   The required priority order is:
    //   
    //   external interrupts, software interrupts, timer interrupts
    //   
    //   If an instruction has been committed then it may trap, and the trap
    //   will occur prior to an interrupt which happens after the commit
    //   point. In this case there will be a trap, and the trapped instruction
    //   will be fetched, and then an interrupt can be taken.
    //   
    //   When an interrupt is taken the following occurs:
    //   
    //   * MPP <= current execution mode (must be machine mode, as debug mode is not interruptible)
    //   
    //   * mstatus.MPIE <= mstatus.MIE
    //   
    //   Note that WFI should wait independent of mstatus.MIE for (mip & mie) != 0 (given machine mode only)
    //   In debug mode WFI should be a NOP.
    //   
    //   WFI may always be a NOP.
    //   
    //   
module riscv_csrs_minimal
(
    clk,
    clk__enable,

    csr_controls__exec_mode,
    csr_controls__retire,
    csr_controls__timer_inc,
    csr_controls__timer_clear,
    csr_controls__timer_load,
    csr_controls__timer_value,
    csr_controls__interrupt,
    csr_controls__trap,
    csr_controls__trap_cause,
    csr_controls__trap_pc,
    csr_controls__trap_value,
    csr_write_data,
    csr_access__access,
    csr_access__address,
    irqs__nmi,
    irqs__meip,
    irqs__seip,
    irqs__ueip,
    irqs__mtip,
    irqs__msip,
    irqs__time,
    reset_n,

    csrs__cycles,
    csrs__instret,
    csrs__time,
    csrs__mscratch,
    csrs__mepc,
    csrs__mcause,
    csrs__mtval,
    csrs__mtvec,
    csr_data__read_data,
    csr_data__take_interrupt,
    csr_data__interrupt_mode,
    csr_data__interrupt_cause,
    csr_data__illegal_access
);

    //b Clocks
        //   RISC-V clock
    input clk;
    input clk__enable;

    //b Inputs
        //   Control signals to update the CSRs
    input [2:0]csr_controls__exec_mode;
    input csr_controls__retire;
    input csr_controls__timer_inc;
    input csr_controls__timer_clear;
    input csr_controls__timer_load;
    input [63:0]csr_controls__timer_value;
    input csr_controls__interrupt;
    input csr_controls__trap;
    input [3:0]csr_controls__trap_cause;
    input [31:0]csr_controls__trap_pc;
    input [31:0]csr_controls__trap_value;
        //   Write data for the CSR access, later in the cycle than @csr_access possibly
    input [31:0]csr_write_data;
        //   RISC-V CSR access, combinatorially decoded
    input [2:0]csr_access__access;
    input [11:0]csr_access__address;
        //   Interrupts in to the CPU
    input irqs__nmi;
    input irqs__meip;
    input irqs__seip;
    input irqs__ueip;
    input irqs__mtip;
    input irqs__msip;
    input [63:0]irqs__time;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   CSR values
    output [63:0]csrs__cycles;
    output [63:0]csrs__instret;
    output [63:0]csrs__time;
    output [31:0]csrs__mscratch;
    output [31:0]csrs__mepc;
    output [31:0]csrs__mcause;
    output [31:0]csrs__mtval;
    output [31:0]csrs__mtvec;
        //   CSR respone (including read data), from the current @a csr_access
    output [31:0]csr_data__read_data;
    output csr_data__take_interrupt;
    output [2:0]csr_data__interrupt_mode;
    output [3:0]csr_data__interrupt_cause;
    output csr_data__illegal_access;

// output components here

    //b Output combinatorials
        //   CSR respone (including read data), from the current @a csr_access
    reg [31:0]csr_data__read_data;
    reg csr_data__take_interrupt;
    reg [2:0]csr_data__interrupt_mode;
    reg [3:0]csr_data__interrupt_cause;
    reg csr_data__illegal_access;

    //b Output nets

    //b Internal and output registers
    reg [63:0]csrs__cycles;
    reg [63:0]csrs__instret;
    reg [63:0]csrs__time;
    reg [31:0]csrs__mscratch;
    reg [31:0]csrs__mepc;
    reg [31:0]csrs__mcause;
    reg [31:0]csrs__mtval;
    reg [31:0]csrs__mtvec;

    //b Internal combinatorials
    reg csr_write__enable;
    reg [31:0]csr_write__data;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b csr_read_write combinatorial process
        //   
        //       CSR_ADDR_MSTATUS
        //       CSR_ADDR_MISA
        //       CSR_ADDR_MVENDORID
        //       CSR_ADDR_MARCHID
        //       CSR_ADDR_MIMPID
        //       CSR_ADDR_MHARTID
        //       
    always @ ( * )//csr_read_write
    begin: csr_read_write__comb_code
    reg [31:0]csr_data__read_data__var;
    reg csr_data__illegal_access__var;
    reg csr_write__enable__var;
    reg [31:0]csr_write__data__var;
        csr_data__read_data__var = 32'h0;
        csr_data__take_interrupt = 1'h0;
        csr_data__interrupt_mode = 3'h0;
        csr_data__interrupt_cause = 4'h0;
        csr_data__illegal_access__var = 1'h0;
        csr_data__illegal_access__var = 1'h1;
        case (csr_access__address) //synopsys parallel_case
        12'hc00: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__cycles[31:0];
            end
        12'hc80: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__cycles[63:32];
            end
        12'hb00: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__cycles[31:0];
            end
        12'hb80: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__cycles[63:32];
            end
        12'hc02: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__instret[31:0];
            end
        12'hc82: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__instret[63:32];
            end
        12'hb02: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__instret[31:0];
            end
        12'hb82: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__instret[63:32];
            end
        12'hc01: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__time[31:0];
            end
        12'hc81: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__time[63:32];
            end
        12'hf13: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = 32'h0;
            end
        12'hf14: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = 32'h0;
            end
        12'h301: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = 32'h0;
            end
        12'hf11: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = 32'h0;
            end
        12'h300: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = 32'h0;
            end
        12'h340: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__mscratch;
            end
        12'h341: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__mepc;
            end
        12'h342: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__mcause;
            end
        12'h343: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__mtval;
            end
        12'h305: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = csrs__mtvec;
            end
        12'h302: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = 32'h0;
            end
        12'h303: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = 32'h0;
            end
        12'h304: // req 1
            begin
            csr_data__illegal_access__var = 1'h0;
            csr_data__read_data__var = 32'h0;
            end
        //synopsys  translate_off
        //pragma coverage off
        //synopsys  translate_on
        default:
            begin
            //Need a default case to make Cadence Lint happy, even though this is not a full case
            end
        //synopsys  translate_off
        //pragma coverage on
        //synopsys  translate_on
        endcase
        csr_write__enable__var = 1'h0;
        csr_write__data__var = csr_write_data;
        case (csr_access__access) //synopsys parallel_case
        3'h1: // req 1
            begin
            csr_write__enable__var = 1'h1;
            end
        3'h3: // req 1
            begin
            csr_write__enable__var = 1'h1;
            end
        3'h6: // req 1
            begin
            csr_write__enable__var = 1'h1;
            csr_write__data__var = csr_write__data__var | csr_data__read_data__var;
            end
        3'h7: // req 1
            begin
            csr_write__enable__var = 1'h1;
            csr_write__data__var = (csr_data__read_data__var & ~csr_write_data);
            end
        //synopsys  translate_off
        //pragma coverage off
        //synopsys  translate_on
        default:
            begin
            //Need a default case to make Cadence Lint happy, even though this is not a full case
            end
        //synopsys  translate_off
        //pragma coverage on
        //synopsys  translate_on
        endcase
        csr_data__read_data = csr_data__read_data__var;
        csr_data__illegal_access = csr_data__illegal_access__var;
        csr_write__enable = csr_write__enable__var;
        csr_write__data = csr_write__data__var;
    end //always

    //b csr_state_update clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : csr_state_update__code
        if (reset_n==1'b0)
        begin
            csrs__time <= 64'h0;
            csrs__cycles <= 64'h0;
            csrs__instret <= 64'h0;
            csrs__mepc <= 32'h0;
            csrs__mtvec <= 32'h0;
            csrs__mtval <= 32'h0;
            csrs__mcause <= 32'h0;
            csrs__mscratch <= 32'h0;
        end
        else if (clk__enable)
        begin
            csrs__time <= irqs__time;
            csrs__cycles[31:0] <= (csrs__cycles[31:0]+32'h1);
            if ((csrs__cycles[31:0]==32'hffffffff))
            begin
                csrs__cycles[63:32] <= (csrs__cycles[63:32]+32'h1);
            end //if
            if (((csr_write__enable!=1'h0)&&(csr_access__address==12'hb00)))
            begin
                csrs__cycles[31:0] <= csr_write__data;
            end //if
            if (((csr_write__enable!=1'h0)&&(csr_access__address==12'hb80)))
            begin
                csrs__cycles[63:32] <= csr_write__data;
            end //if
            if ((csr_controls__retire!=1'h0))
            begin
                csrs__instret[31:0] <= (csrs__instret[31:0]+32'h1);
                if ((csrs__instret[31:0]==32'hffffffff))
                begin
                    csrs__instret[63:32] <= (csrs__instret[63:32]+32'h1);
                end //if
            end //if
            if (((csr_write__enable!=1'h0)&&(csr_access__address==12'hb02)))
            begin
                csrs__instret[31:0] <= csr_write__data;
            end //if
            if (((csr_write__enable!=1'h0)&&(csr_access__address==12'hb82)))
            begin
                csrs__instret[63:32] <= csr_write__data;
            end //if
            if (((csr_write__enable!=1'h0)&&(csr_access__address==12'h341)))
            begin
                csrs__mepc <= csr_write__data;
            end //if
            if ((csr_controls__trap!=1'h0))
            begin
                csrs__mepc <= csr_controls__trap_pc;
            end //if
            if (((csr_write__enable!=1'h0)&&(csr_access__address==12'h305)))
            begin
                csrs__mtvec <= csr_write__data;
            end //if
            if ((csr_controls__trap!=1'h0))
            begin
                csrs__mtval <= csr_controls__trap_value;
            end //if
            if (((csr_write__enable!=1'h0)&&(csr_access__address==12'h342)))
            begin
                csrs__mcause <= csr_write__data;
            end //if
            if ((csr_controls__trap!=1'h0))
            begin
                case (csr_controls__trap_cause) //synopsys parallel_case
                4'h0: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'h0};
                    end
                4'h1: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'h1};
                    end
                4'h2: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'h2};
                    end
                4'h3: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'h3};
                    end
                4'h4: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'h4};
                    end
                4'h5: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'h5};
                    end
                4'h6: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'h6};
                    end
                4'h7: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'h7};
                    end
                4'h8: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'h8};
                    end
                4'h9: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'h9};
                    end
                4'ha: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'ha};
                    end
                4'hb: // req 1
                    begin
                    csrs__mcause <= {24'h0,8'hb};
                    end
    //synopsys  translate_off
    //pragma coverage off
                default:
                    begin
                        if (1)
                        begin
                            $display("%t *********CDL ASSERTION FAILURE:riscv_csrs_minimal:csr_state_update: Full switch statement did not cover all values", $time);
                        end
                    end
    //pragma coverage on
    //synopsys  translate_on
                endcase
            end //if
            if (((csr_write__enable!=1'h0)&&(csr_access__address==12'h340)))
            begin
                csrs__mscratch <= csr_write__data;
            end //if
        end //if
    end //always

endmodule // riscv_csrs_minimal
