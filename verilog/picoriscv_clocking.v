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

//a Module picoriscv_clocking
    //   
    //   This module controls the clocking of a Pico-risc-V microcomputer
    //   
module picoriscv_clocking
(
    clk,
    clk__enable,

    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    clock_status__imem_request,
    clock_status__io_request,
    clock_status__io_ready,
    clock_status__dmem_read_enable,
    clock_status__dmem_write_enable,
    reset_n,

    csr_response__acknowledge,
    csr_response__read_data_valid,
    csr_response__read_data_error,
    csr_response__read_data,
    clock_control__riscv_clk_enable,
    clock_control__debug,
    mem_control__dmem_request,
    mem_control__ifetch_request,
    mem_control__dmem_set_reg,
    mem_control__ifetch_set_reg,
    mem_control__ifetch_use_reg,
    mem_control__io_enable
);

    //b Clocks
    input clk;
    input clk__enable;

    //b Inputs
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
    input clock_status__imem_request;
    input clock_status__io_request;
    input clock_status__io_ready;
    input clock_status__dmem_read_enable;
    input clock_status__dmem_write_enable;
    input reset_n;

    //b Outputs
    output csr_response__acknowledge;
    output csr_response__read_data_valid;
    output csr_response__read_data_error;
    output [31:0]csr_response__read_data;
    output clock_control__riscv_clk_enable;
    output [3:0]clock_control__debug;
    output mem_control__dmem_request;
    output mem_control__ifetch_request;
    output mem_control__dmem_set_reg;
    output mem_control__ifetch_set_reg;
    output mem_control__ifetch_use_reg;
    output mem_control__io_enable;

// output components here

    //b Output combinatorials
    reg clock_control__riscv_clk_enable;
    reg [3:0]clock_control__debug;
    reg mem_control__dmem_request;
    reg mem_control__ifetch_request;
    reg mem_control__dmem_set_reg;
    reg mem_control__ifetch_set_reg;
    reg mem_control__ifetch_use_reg;
    reg mem_control__io_enable;

    //b Output nets
    wire csr_response__acknowledge;
    wire csr_response__read_data_valid;
    wire csr_response__read_data_error;
    wire [31:0]csr_response__read_data;

    //b Internal and output registers
    reg io_access_enable;
    reg riscv_clk_high;
    reg [1:0]riscv_clock_phase;

    //b Internal combinatorials
    reg [31:0]csr_read_data;
    reg [2:0]riscv_clock_action;

    //b Internal nets
    wire csr_access__valid;
    wire csr_access__read_not_write;
    wire [15:0]csr_access__address;
    wire [31:0]csr_access__data;

    //b Clock gating module instances
    //b Module instances
    csr_target_csr csri(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_select(16'h0),
        .csr_access_data(csr_read_data),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .reset_n(reset_n),
        .csr_access__data(            csr_access__data),
        .csr_access__address(            csr_access__address),
        .csr_access__read_not_write(            csr_access__read_not_write),
        .csr_access__valid(            csr_access__valid),
        .csr_response__read_data(            csr_response__read_data),
        .csr_response__read_data_error(            csr_response__read_data_error),
        .csr_response__read_data_valid(            csr_response__read_data_valid),
        .csr_response__acknowledge(            csr_response__acknowledge)         );
    //b crst_target_logic combinatorial process
        //   
        //       
    always @ ( * )//crst_target_logic
    begin: crst_target_logic__comb_code
        csr_read_data = 32'h0;
    end //always

    //b clock_control__comb combinatorial process
        //   
        //       The clock control for a single SRAM implementation could be
        //       performed with three high speed clocks for each RISC-V
        //       clock. However, this is a slightly more sophisticated design.
        //   
        //       A minimal RISC-V clock cycle requires an instruction fetch and at
        //       most one of data read or data write.
        //   
        //       With a synchronous memory, a memory read must be presented to the
        //       SRAM at high speed clock cycle n-1 if the data is to be valid at
        //       the end of high speed clock cycle n.
        //   
        //       So if just an instruction fetch is required then a first high
        //       speed cycle is used to present the ifetch, and a second high speed
        //       cycle is the instruction being read. This is presented directly to
        //       the RISC-V core.
        //   
        //       So if an instruction fetch and data read are required then a first
        //       high speed cycle is used to present the data read, a second to
        //       present the ifetch and perform the data read - with the data out
        //       registered at the start of a third high speed cycle while the
        //       instruction being read. This is presented directly to the RISC-V
        //       core; the data read is presented from its stored register
        //   
        //       To ease implementation, and because the minimal RISC-V probably
        //       always requests an instruction fetch, if a data fetch only is
        //       requested then the flow follows as if an instruction fetch had
        //       been requested.
        //   
        //       So if an instruction fetch and data write are required then a
        //       first high speed cycle is used to present the data write, a second
        //       to present the ifetch and perform the data write, and a third high
        //       speed cycle while the instruction being read. This is presented
        //       directly to the RISC-V core.
        //       
    always @ ( * )//clock_control__comb
    begin: clock_control__comb_code
    reg [2:0]riscv_clock_action__var;
    reg clock_control__riscv_clk_enable__var;
    reg mem_control__dmem_request__var;
    reg mem_control__ifetch_request__var;
    reg mem_control__dmem_set_reg__var;
    reg mem_control__ifetch_set_reg__var;
    reg mem_control__ifetch_use_reg__var;
    reg mem_control__io_enable__var;
        riscv_clock_action__var = 3'h0;
        case (riscv_clock_phase) //synopsys parallel_case
        2'h0: // req 1
            begin
            case ({clock_status__imem_request,(clock_status__dmem_read_enable | clock_status__dmem_write_enable)}) //synopsys parallel_case
            2'h0: // req 1
                begin
                riscv_clock_action__var = 3'h1;
                end
            2'h2: // req 1
                begin
                riscv_clock_action__var = 3'h3;
                end
            2'h3: // req 1
                begin
                riscv_clock_action__var = 3'h4;
                end
            2'h1: // req 1
                begin
                riscv_clock_action__var = 3'h4;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:picoriscv_clocking:clock_control: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            end
        2'h1: // req 1
            begin
            riscv_clock_action__var = 3'h3;
            end
        2'h2: // req 1
            begin
            riscv_clock_action__var = 3'h0;
            if (((clock_status__io_request!=1'h0)&&!(clock_status__io_ready!=1'h0)))
            begin
                riscv_clock_action__var = 3'h2;
            end //if
            end
        2'h3: // req 1
            begin
            riscv_clock_action__var = 3'h0;
            if (((clock_status__io_request!=1'h0)&&!(clock_status__io_ready!=1'h0)))
            begin
                riscv_clock_action__var = 3'h1;
            end //if
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:picoriscv_clocking:clock_control: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        clock_control__riscv_clk_enable__var = 1'h0;
        mem_control__dmem_request__var = 1'h0;
        mem_control__ifetch_request__var = 1'h0;
        mem_control__dmem_set_reg__var = 1'h0;
        mem_control__ifetch_set_reg__var = 1'h0;
        mem_control__ifetch_use_reg__var = 1'h0;
        mem_control__io_enable__var = 1'h0;
        case (riscv_clock_action__var) //synopsys parallel_case
        3'h1: // req 1
            begin
            mem_control__ifetch_use_reg__var = 1'h1;
            end
        3'h2: // req 1
            begin
            mem_control__ifetch_set_reg__var = 1'h1;
            end
        3'h0: // req 1
            begin
            clock_control__riscv_clk_enable__var = 1'h1;
            end
        3'h3: // req 1
            begin
            mem_control__ifetch_request__var = 1'h1;
            end
        3'h4: // req 1
            begin
            mem_control__dmem_request__var = 1'h1;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:picoriscv_clocking:clock_control: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        clock_control__debug = 4'h0;
        mem_control__io_enable__var = io_access_enable;
        mem_control__dmem_set_reg__var = (riscv_clock_phase==2'h1);
        riscv_clock_action = riscv_clock_action__var;
        clock_control__riscv_clk_enable = clock_control__riscv_clk_enable__var;
        mem_control__dmem_request = mem_control__dmem_request__var;
        mem_control__ifetch_request = mem_control__ifetch_request__var;
        mem_control__dmem_set_reg = mem_control__dmem_set_reg__var;
        mem_control__ifetch_set_reg = mem_control__ifetch_set_reg__var;
        mem_control__ifetch_use_reg = mem_control__ifetch_use_reg__var;
        mem_control__io_enable = mem_control__io_enable__var;
    end //always

    //b clock_control__posedge_clk_active_low_reset_n clock process
        //   
        //       The clock control for a single SRAM implementation could be
        //       performed with three high speed clocks for each RISC-V
        //       clock. However, this is a slightly more sophisticated design.
        //   
        //       A minimal RISC-V clock cycle requires an instruction fetch and at
        //       most one of data read or data write.
        //   
        //       With a synchronous memory, a memory read must be presented to the
        //       SRAM at high speed clock cycle n-1 if the data is to be valid at
        //       the end of high speed clock cycle n.
        //   
        //       So if just an instruction fetch is required then a first high
        //       speed cycle is used to present the ifetch, and a second high speed
        //       cycle is the instruction being read. This is presented directly to
        //       the RISC-V core.
        //   
        //       So if an instruction fetch and data read are required then a first
        //       high speed cycle is used to present the data read, a second to
        //       present the ifetch and perform the data read - with the data out
        //       registered at the start of a third high speed cycle while the
        //       instruction being read. This is presented directly to the RISC-V
        //       core; the data read is presented from its stored register
        //   
        //       To ease implementation, and because the minimal RISC-V probably
        //       always requests an instruction fetch, if a data fetch only is
        //       requested then the flow follows as if an instruction fetch had
        //       been requested.
        //   
        //       So if an instruction fetch and data write are required then a
        //       first high speed cycle is used to present the data write, a second
        //       to present the ifetch and perform the data write, and a third high
        //       speed cycle while the instruction being read. This is presented
        //       directly to the RISC-V core.
        //       
    always @( posedge clk or negedge reset_n)
    begin : clock_control__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            riscv_clock_phase <= 2'h0;
            riscv_clk_high <= 1'h0;
            io_access_enable <= 1'h0;
        end
        else if (clk__enable)
        begin
            case (riscv_clock_action) //synopsys parallel_case
            3'h1: // req 1
                begin
                riscv_clock_phase <= 2'h3;
                end
            3'h2: // req 1
                begin
                riscv_clock_phase <= 2'h3;
                end
            3'h0: // req 1
                begin
                riscv_clock_phase <= 2'h0;
                end
            3'h3: // req 1
                begin
                riscv_clock_phase <= 2'h2;
                end
            3'h4: // req 1
                begin
                riscv_clock_phase <= 2'h1;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:picoriscv_clocking:clock_control: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            riscv_clk_high <= clock_control__riscv_clk_enable;
            if ((clock_control__riscv_clk_enable!=1'h0))
            begin
                io_access_enable <= 1'h1;
            end //if
            else
            
            begin
                if (((clock_status__io_request!=1'h0)&&(clock_status__io_ready!=1'h0)))
                begin
                    io_access_enable <= 1'h0;
                end //if
            end //else
        end //if
    end //always

endmodule // picoriscv_clocking
