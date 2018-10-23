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

//a Module riscv_i32_pipeline_control
module riscv_i32_pipeline_control
(
    clk,
    clk__enable,

    trace__instr_valid,
    trace__instr_pc,
    trace__instruction__mode,
    trace__instruction__data,
    trace__rfw_retire,
    trace__rfw_data_valid,
    trace__rfw_rd,
    trace__rfw_data,
    trace__branch_taken,
    trace__branch_target,
    trace__trap,
    riscv_config__i32c,
    riscv_config__e32,
    riscv_config__i32m,
    riscv_config__i32m_fuse,
    riscv_config__coproc_disable,
    riscv_config__unaligned_mem,
    pipeline_fetch_data__valid,
    pipeline_fetch_data__pc,
    pipeline_fetch_data__data,
    pipeline_fetch_data__dec_flush_pipeline,
    pipeline_fetch_data__dec_predicted_branch,
    pipeline_fetch_data__dec_pc_if_mispredicted,
    pipeline_response__decode__valid,
    pipeline_response__decode__decode_blocked,
    pipeline_response__decode__branch_target,
    pipeline_response__decode__idecode__rs1,
    pipeline_response__decode__idecode__rs1_valid,
    pipeline_response__decode__idecode__rs2,
    pipeline_response__decode__idecode__rs2_valid,
    pipeline_response__decode__idecode__rd,
    pipeline_response__decode__idecode__rd_written,
    pipeline_response__decode__idecode__csr_access__access_cancelled,
    pipeline_response__decode__idecode__csr_access__access,
    pipeline_response__decode__idecode__csr_access__address,
    pipeline_response__decode__idecode__csr_access__write_data,
    pipeline_response__decode__idecode__immediate,
    pipeline_response__decode__idecode__immediate_shift,
    pipeline_response__decode__idecode__immediate_valid,
    pipeline_response__decode__idecode__op,
    pipeline_response__decode__idecode__subop,
    pipeline_response__decode__idecode__requires_machine_mode,
    pipeline_response__decode__idecode__memory_read_unsigned,
    pipeline_response__decode__idecode__memory_width,
    pipeline_response__decode__idecode__illegal,
    pipeline_response__decode__idecode__illegal_pc,
    pipeline_response__decode__idecode__is_compressed,
    pipeline_response__decode__idecode__ext__dummy,
    pipeline_response__decode__enable_branch_prediction,
    pipeline_response__exec__valid,
    pipeline_response__exec__cannot_start,
    pipeline_response__exec__cannot_complete,
    pipeline_response__exec__interrupt_ack,
    pipeline_response__exec__branch_taken,
    pipeline_response__exec__trap__valid,
    pipeline_response__exec__trap__to_mode,
    pipeline_response__exec__trap__cause,
    pipeline_response__exec__trap__pc,
    pipeline_response__exec__trap__value,
    pipeline_response__exec__trap__mret,
    pipeline_response__exec__trap__vector,
    pipeline_response__exec__is_compressed,
    pipeline_response__exec__instruction__mode,
    pipeline_response__exec__instruction__data,
    pipeline_response__exec__rs1,
    pipeline_response__exec__rs2,
    pipeline_response__exec__pc,
    pipeline_response__exec__predicted_branch,
    pipeline_response__exec__pc_if_mispredicted,
    pipeline_response__rfw__valid,
    pipeline_response__rfw__rd_written,
    pipeline_response__rfw__rd,
    pipeline_response__rfw__data,
    csrs__cycles,
    csrs__instret,
    csrs__time,
    csrs__mscratch,
    csrs__mepc,
    csrs__mcause,
    csrs__mtval,
    csrs__mtvec__base,
    csrs__mtvec__vectored,
    csrs__mstatus__sd,
    csrs__mstatus__tsr,
    csrs__mstatus__tw,
    csrs__mstatus__tvm,
    csrs__mstatus__mxr,
    csrs__mstatus__sum,
    csrs__mstatus__mprv,
    csrs__mstatus__xs,
    csrs__mstatus__fs,
    csrs__mstatus__mpp,
    csrs__mstatus__spp,
    csrs__mstatus__mpie,
    csrs__mstatus__spie,
    csrs__mstatus__upie,
    csrs__mstatus__mie,
    csrs__mstatus__sie,
    csrs__mstatus__uie,
    csrs__mip__meip,
    csrs__mip__seip,
    csrs__mip__ueip,
    csrs__mip__seip_sw,
    csrs__mip__ueip_sw,
    csrs__mip__mtip,
    csrs__mip__stip,
    csrs__mip__utip,
    csrs__mip__msip,
    csrs__mip__ssip,
    csrs__mip__usip,
    csrs__mie__meip,
    csrs__mie__seip,
    csrs__mie__ueip,
    csrs__mie__mtip,
    csrs__mie__stip,
    csrs__mie__utip,
    csrs__mie__msip,
    csrs__mie__ssip,
    csrs__mie__usip,
    reset_n,

    pipeline_control__valid,
    pipeline_control__debug,
    pipeline_control__fetch_action,
    pipeline_control__decode_pc,
    pipeline_control__mode,
    pipeline_control__error,
    pipeline_control__tag,
    pipeline_control__interrupt_req,
    pipeline_control__interrupt_number,
    pipeline_control__interrupt_to_mode
);

    //b Clocks
    input clk;
    input clk__enable;

    //b Inputs
    input trace__instr_valid;
    input [31:0]trace__instr_pc;
    input [2:0]trace__instruction__mode;
    input [31:0]trace__instruction__data;
    input trace__rfw_retire;
    input trace__rfw_data_valid;
    input [4:0]trace__rfw_rd;
    input [31:0]trace__rfw_data;
    input trace__branch_taken;
    input [31:0]trace__branch_target;
    input trace__trap;
    input riscv_config__i32c;
    input riscv_config__e32;
    input riscv_config__i32m;
    input riscv_config__i32m_fuse;
    input riscv_config__coproc_disable;
    input riscv_config__unaligned_mem;
    input pipeline_fetch_data__valid;
    input [31:0]pipeline_fetch_data__pc;
    input [31:0]pipeline_fetch_data__data;
    input pipeline_fetch_data__dec_flush_pipeline;
    input pipeline_fetch_data__dec_predicted_branch;
    input [31:0]pipeline_fetch_data__dec_pc_if_mispredicted;
    input pipeline_response__decode__valid;
    input pipeline_response__decode__decode_blocked;
    input [31:0]pipeline_response__decode__branch_target;
    input [4:0]pipeline_response__decode__idecode__rs1;
    input pipeline_response__decode__idecode__rs1_valid;
    input [4:0]pipeline_response__decode__idecode__rs2;
    input pipeline_response__decode__idecode__rs2_valid;
    input [4:0]pipeline_response__decode__idecode__rd;
    input pipeline_response__decode__idecode__rd_written;
    input pipeline_response__decode__idecode__csr_access__access_cancelled;
    input [2:0]pipeline_response__decode__idecode__csr_access__access;
    input [11:0]pipeline_response__decode__idecode__csr_access__address;
    input [31:0]pipeline_response__decode__idecode__csr_access__write_data;
    input [31:0]pipeline_response__decode__idecode__immediate;
    input [4:0]pipeline_response__decode__idecode__immediate_shift;
    input pipeline_response__decode__idecode__immediate_valid;
    input [3:0]pipeline_response__decode__idecode__op;
    input [3:0]pipeline_response__decode__idecode__subop;
    input pipeline_response__decode__idecode__requires_machine_mode;
    input pipeline_response__decode__idecode__memory_read_unsigned;
    input [1:0]pipeline_response__decode__idecode__memory_width;
    input pipeline_response__decode__idecode__illegal;
    input pipeline_response__decode__idecode__illegal_pc;
    input pipeline_response__decode__idecode__is_compressed;
    input pipeline_response__decode__idecode__ext__dummy;
    input pipeline_response__decode__enable_branch_prediction;
    input pipeline_response__exec__valid;
    input pipeline_response__exec__cannot_start;
    input pipeline_response__exec__cannot_complete;
    input pipeline_response__exec__interrupt_ack;
    input pipeline_response__exec__branch_taken;
    input pipeline_response__exec__trap__valid;
    input [2:0]pipeline_response__exec__trap__to_mode;
    input [4:0]pipeline_response__exec__trap__cause;
    input [31:0]pipeline_response__exec__trap__pc;
    input [31:0]pipeline_response__exec__trap__value;
    input pipeline_response__exec__trap__mret;
    input pipeline_response__exec__trap__vector;
    input pipeline_response__exec__is_compressed;
    input [2:0]pipeline_response__exec__instruction__mode;
    input [31:0]pipeline_response__exec__instruction__data;
    input [31:0]pipeline_response__exec__rs1;
    input [31:0]pipeline_response__exec__rs2;
    input [31:0]pipeline_response__exec__pc;
    input pipeline_response__exec__predicted_branch;
    input [31:0]pipeline_response__exec__pc_if_mispredicted;
    input pipeline_response__rfw__valid;
    input pipeline_response__rfw__rd_written;
    input [4:0]pipeline_response__rfw__rd;
    input [31:0]pipeline_response__rfw__data;
    input [63:0]csrs__cycles;
    input [63:0]csrs__instret;
    input [63:0]csrs__time;
    input [31:0]csrs__mscratch;
    input [31:0]csrs__mepc;
    input [31:0]csrs__mcause;
    input [31:0]csrs__mtval;
    input [29:0]csrs__mtvec__base;
    input csrs__mtvec__vectored;
    input csrs__mstatus__sd;
    input csrs__mstatus__tsr;
    input csrs__mstatus__tw;
    input csrs__mstatus__tvm;
    input csrs__mstatus__mxr;
    input csrs__mstatus__sum;
    input csrs__mstatus__mprv;
    input [1:0]csrs__mstatus__xs;
    input [1:0]csrs__mstatus__fs;
    input [1:0]csrs__mstatus__mpp;
    input csrs__mstatus__spp;
    input csrs__mstatus__mpie;
    input csrs__mstatus__spie;
    input csrs__mstatus__upie;
    input csrs__mstatus__mie;
    input csrs__mstatus__sie;
    input csrs__mstatus__uie;
    input csrs__mip__meip;
    input csrs__mip__seip;
    input csrs__mip__ueip;
    input csrs__mip__seip_sw;
    input csrs__mip__ueip_sw;
    input csrs__mip__mtip;
    input csrs__mip__stip;
    input csrs__mip__utip;
    input csrs__mip__msip;
    input csrs__mip__ssip;
    input csrs__mip__usip;
    input csrs__mie__meip;
    input csrs__mie__seip;
    input csrs__mie__ueip;
    input csrs__mie__mtip;
    input csrs__mie__stip;
    input csrs__mie__utip;
    input csrs__mie__msip;
    input csrs__mie__ssip;
    input csrs__mie__usip;
    input reset_n;

    //b Outputs
    output pipeline_control__valid;
    output pipeline_control__debug;
    output [1:0]pipeline_control__fetch_action;
    output [31:0]pipeline_control__decode_pc;
    output [2:0]pipeline_control__mode;
    output pipeline_control__error;
    output [1:0]pipeline_control__tag;
    output pipeline_control__interrupt_req;
    output [3:0]pipeline_control__interrupt_number;
    output [2:0]pipeline_control__interrupt_to_mode;

// output components here

    //b Output combinatorials
    reg pipeline_control__valid;
    reg pipeline_control__debug;
    reg [1:0]pipeline_control__fetch_action;
    reg [31:0]pipeline_control__decode_pc;
    reg [2:0]pipeline_control__mode;
    reg pipeline_control__error;
    reg [1:0]pipeline_control__tag;
    reg pipeline_control__interrupt_req;
    reg [3:0]pipeline_control__interrupt_number;
    reg [2:0]pipeline_control__interrupt_to_mode;

    //b Output nets

    //b Internal and output registers
    reg [1:0]ifetch_state__state;
    reg ifetch_state__running;
    reg [31:0]ifetch_state__pc;

    //b Internal combinatorials
    reg [1:0]ifetch_combs__fetch_action;
    reg ifetch_combs__interrupt_req;
    reg [3:0]ifetch_combs__interrupt_number;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b pipeline_control_logic__comb combinatorial process
        //   
        //       The instruction fetch request derives from the
        //       decode/execute stage (the instruction address that is required
        //       next) and presents that to the outside world.
        //   
        //       This request may be for any 16-bit aligned address, and two
        //       successive 16-bit words from that request must be presented,
        //       aligned to bit 0.
        //   
        //       If the decode/execute stage is invalid (i.e. it does not have a
        //       valid instruction to decode) then the current PC is requested.
        //       
    always @ ( * )//pipeline_control_logic__comb
    begin: pipeline_control_logic__comb_code
    reg ifetch_combs__interrupt_req__var;
    reg [3:0]ifetch_combs__interrupt_number__var;
    reg [1:0]ifetch_combs__fetch_action__var;
    reg pipeline_control__valid__var;
    reg [1:0]pipeline_control__fetch_action__var;
    reg [31:0]pipeline_control__decode_pc__var;
    reg [2:0]pipeline_control__mode__var;
    reg pipeline_control__interrupt_req__var;
    reg [3:0]pipeline_control__interrupt_number__var;
    reg [2:0]pipeline_control__interrupt_to_mode__var;
        ifetch_combs__interrupt_req__var = 1'h0;
        ifetch_combs__interrupt_number__var = 4'h0;
        if (((csrs__mip__mtip & csrs__mie__mtip)!=1'h0))
        begin
            ifetch_combs__interrupt_req__var = csrs__mstatus__mie;
            ifetch_combs__interrupt_number__var = 4'h7;
        end //if
        if (((csrs__mip__msip & csrs__mie__msip)!=1'h0))
        begin
            ifetch_combs__interrupt_req__var = csrs__mstatus__mie;
            ifetch_combs__interrupt_number__var = 4'h3;
        end //if
        if (((csrs__mip__meip & csrs__mie__meip)!=1'h0))
        begin
            ifetch_combs__interrupt_req__var = csrs__mstatus__mie;
            ifetch_combs__interrupt_number__var = 4'hb;
        end //if
        ifetch_combs__fetch_action__var = 2'h0;
        case (ifetch_state__state) //synopsys parallel_case
        2'h0: // req 1
            begin
            end
        2'h1: // req 1
            begin
            ifetch_combs__fetch_action__var = 2'h1;
            end
        2'h2: // req 1
            begin
            ifetch_combs__fetch_action__var = 2'h2;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:riscv_i32_pipeline_control:pipeline_control_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        pipeline_control__valid__var = 1'h0;
        pipeline_control__debug = 1'h0;
        pipeline_control__fetch_action__var = 2'h0;
        pipeline_control__decode_pc__var = 32'h0;
        pipeline_control__mode__var = 3'h0;
        pipeline_control__error = 1'h0;
        pipeline_control__tag = 2'h0;
        pipeline_control__interrupt_req__var = 1'h0;
        pipeline_control__interrupt_number__var = 4'h0;
        pipeline_control__interrupt_to_mode__var = 3'h0;
        pipeline_control__valid__var = 1'h1;
        pipeline_control__decode_pc__var = ifetch_state__pc;
        pipeline_control__fetch_action__var = ifetch_combs__fetch_action__var;
        pipeline_control__mode__var = 3'h3;
        pipeline_control__interrupt_req__var = ifetch_combs__interrupt_req__var;
        pipeline_control__interrupt_number__var = ifetch_combs__interrupt_number__var;
        pipeline_control__interrupt_to_mode__var = 3'h3;
        ifetch_combs__interrupt_req = ifetch_combs__interrupt_req__var;
        ifetch_combs__interrupt_number = ifetch_combs__interrupt_number__var;
        ifetch_combs__fetch_action = ifetch_combs__fetch_action__var;
        pipeline_control__valid = pipeline_control__valid__var;
        pipeline_control__fetch_action = pipeline_control__fetch_action__var;
        pipeline_control__decode_pc = pipeline_control__decode_pc__var;
        pipeline_control__mode = pipeline_control__mode__var;
        pipeline_control__interrupt_req = pipeline_control__interrupt_req__var;
        pipeline_control__interrupt_number = pipeline_control__interrupt_number__var;
        pipeline_control__interrupt_to_mode = pipeline_control__interrupt_to_mode__var;
    end //always

    //b pipeline_control_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The instruction fetch request derives from the
        //       decode/execute stage (the instruction address that is required
        //       next) and presents that to the outside world.
        //   
        //       This request may be for any 16-bit aligned address, and two
        //       successive 16-bit words from that request must be presented,
        //       aligned to bit 0.
        //   
        //       If the decode/execute stage is invalid (i.e. it does not have a
        //       valid instruction to decode) then the current PC is requested.
        //       
    always @( posedge clk or negedge reset_n)
    begin : pipeline_control_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            ifetch_state__running <= 1'h0;
            ifetch_state__pc <= 32'h0;
            ifetch_state__state <= 2'h0;
            ifetch_state__state <= 2'h0;
        end
        else if (clk__enable)
        begin
            if (!(ifetch_state__running!=1'h0))
            begin
                ifetch_state__running <= 1'h1;
                ifetch_state__pc <= 32'h0;
            end //if
            case (ifetch_state__state) //synopsys parallel_case
            2'h0: // req 1
                begin
                if ((ifetch_state__running!=1'h0))
                begin
                    ifetch_state__state <= 2'h1;
                end //if
                end
            2'h1: // req 1
                begin
                if ((pipeline_fetch_data__valid!=1'h0))
                begin
                    ifetch_state__state <= 2'h2;
                end //if
                end
            2'h2: // req 1
                begin
                if (((pipeline_fetch_data__valid!=1'h0)&&!(pipeline_response__decode__decode_blocked!=1'h0)))
                begin
                    ifetch_state__pc <= pipeline_fetch_data__pc;
                end //if
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:riscv_i32_pipeline_control:pipeline_control_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
    end //always

endmodule // riscv_i32_pipeline_control
