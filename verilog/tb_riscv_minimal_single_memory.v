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

//a Module tb_riscv_minimal_single_memory
module tb_riscv_minimal_single_memory
(
    clk,
    clk__enable,

    reset_n

);

    //b Clocks
    input clk;
    input clk__enable;
    wire riscv_clk; // Gated version of clock 'clk' enabled by 'riscv_clk_enable'
    wire riscv_clk__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg riscv_clk_high;
    reg [31:0]read_data_reg;
    reg [2:0]riscv_clock_phase;

    //b Internal combinatorials
    reg [2:0]riscv_clock_action;
    reg riscv_clk_enable;
    reg [31:0]mem_access_req__address;
    reg [3:0]mem_access_req__byte_enable;
    reg mem_access_req__write_enable;
    reg mem_access_req__read_enable;
    reg [31:0]mem_access_req__write_data;
    reg imem_access_resp__wait;
    reg [31:0]imem_access_resp__read_data;
    reg dmem_access_resp__wait;
    reg [31:0]dmem_access_resp__read_data;

    //b Internal nets
    wire [31:0]mem_read_data;
    wire [31:0]imem_access_req__address;
    wire [3:0]imem_access_req__byte_enable;
    wire imem_access_req__write_enable;
    wire imem_access_req__read_enable;
    wire [31:0]imem_access_req__write_data;
    wire [31:0]dmem_access_req__address;
    wire [3:0]dmem_access_req__byte_enable;
    wire dmem_access_req__write_enable;
    wire dmem_access_req__read_enable;
    wire [31:0]dmem_access_req__write_data;

    //b Clock gating module instances
    assign riscv_clk__enable = (clk__enable && riscv_clk_enable);
    //b Module instances
    se_sram_srw_16384x32_we8 mem(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(mem_access_req__write_data),
        .address(mem_access_req__address[15:2]),
        .write_enable(((mem_access_req__write_enable!=1'h0)?mem_access_req__byte_enable:4'h0)),
        .read_not_write(mem_access_req__read_enable),
        .select(((mem_access_req__read_enable!=1'h0)||(mem_access_req__write_enable!=1'h0))),
        .data_out(            mem_read_data)         );
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .a(1'h0)         );
    riscv_minimal dut(
        .clk(clk),
        .clk__enable(riscv_clk__enable),
        .imem_access_resp__read_data(imem_access_resp__read_data),
        .imem_access_resp__wait(imem_access_resp__wait),
        .dmem_access_resp__read_data(dmem_access_resp__read_data),
        .dmem_access_resp__wait(dmem_access_resp__wait),
        .reset_n(reset_n),
        .imem_access_req__write_data(            imem_access_req__write_data),
        .imem_access_req__read_enable(            imem_access_req__read_enable),
        .imem_access_req__write_enable(            imem_access_req__write_enable),
        .imem_access_req__byte_enable(            imem_access_req__byte_enable),
        .imem_access_req__address(            imem_access_req__address),
        .dmem_access_req__write_data(            dmem_access_req__write_data),
        .dmem_access_req__read_enable(            dmem_access_req__read_enable),
        .dmem_access_req__write_enable(            dmem_access_req__write_enable),
        .dmem_access_req__byte_enable(            dmem_access_req__byte_enable),
        .dmem_access_req__address(            dmem_access_req__address)         );
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
    reg riscv_clk_enable__var;
        riscv_clock_action__var = 3'h0;
        case (riscv_clock_phase) //synopsys parallel_case
        3'h0: // req 1
            begin
            case ({{imem_access_req__read_enable,dmem_access_req__read_enable},dmem_access_req__write_enable}) //synopsys parallel_case
            3'h0: // req 1
                begin
                riscv_clock_action__var = 3'h1;
                end
            3'h4: // req 1
                begin
                riscv_clock_action__var = 3'h2;
                end
            3'h5: // req 1
                begin
                riscv_clock_action__var = 3'h4;
                end
            3'h1: // req 1
                begin
                riscv_clock_action__var = 3'h4;
                end
            default: // req 1
                begin
                riscv_clock_action__var = 3'h3;
                end
            endcase
            end
        3'h2: // req 1
            begin
            riscv_clock_action__var = 3'h0;
            if ((imem_access_req__read_enable!=1'h0))
            begin
                riscv_clock_action__var = 3'h2;
            end //if
            end
        3'h1: // req 1
            begin
            riscv_clock_action__var = 3'h2;
            end
        3'h3: // req 1
            begin
            riscv_clock_action__var = 3'h0;
            end
        3'h4: // req 1
            begin
            riscv_clock_action__var = 3'h0;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:tb_riscv_minimal_single_memory:clock_control: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        riscv_clk_enable__var = 1'h0;
        case (riscv_clock_action__var) //synopsys parallel_case
        3'h1: // req 1
            begin
            end
        3'h0: // req 1
            begin
            riscv_clk_enable__var = 1'h1;
            end
        3'h2: // req 1
            begin
            end
        3'h3: // req 1
            begin
            end
        3'h4: // req 1
            begin
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:tb_riscv_minimal_single_memory:clock_control: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        riscv_clock_action = riscv_clock_action__var;
        riscv_clk_enable = riscv_clk_enable__var;
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
            riscv_clock_phase <= 3'h0;
            riscv_clk_high <= 1'h0;
        end
        else if (clk__enable)
        begin
            case (riscv_clock_action) //synopsys parallel_case
            3'h1: // req 1
                begin
                riscv_clock_phase <= 3'h4;
                end
            3'h0: // req 1
                begin
                riscv_clock_phase <= 3'h0;
                end
            3'h2: // req 1
                begin
                riscv_clock_phase <= 3'h3;
                end
            3'h3: // req 1
                begin
                riscv_clock_phase <= 3'h1;
                end
            3'h4: // req 1
                begin
                riscv_clock_phase <= 3'h2;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:tb_riscv_minimal_single_memory:clock_control: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            riscv_clk_high <= riscv_clk_enable;
        end //if
    end //always

    //b srams__comb combinatorial process
    always @ ( * )//srams__comb
    begin: srams__comb_code
    reg [31:0]mem_access_req__address__var;
    reg [3:0]mem_access_req__byte_enable__var;
    reg mem_access_req__write_enable__var;
    reg mem_access_req__read_enable__var;
    reg [31:0]mem_access_req__write_data__var;
        mem_access_req__address__var = 32'h0;
        mem_access_req__byte_enable__var = 4'h0;
        mem_access_req__write_enable__var = 1'h0;
        mem_access_req__read_enable__var = 1'h0;
        mem_access_req__write_data__var = 32'h0;
        mem_access_req__address__var = dmem_access_req__address;
        mem_access_req__byte_enable__var = dmem_access_req__byte_enable;
        mem_access_req__write_data__var = dmem_access_req__write_data;
        case (riscv_clock_action) //synopsys parallel_case
        3'h3: // req 1
            begin
            mem_access_req__read_enable__var = 1'h1;
            mem_access_req__address__var = dmem_access_req__address;
            end
        3'h4: // req 1
            begin
            mem_access_req__write_enable__var = 1'h1;
            mem_access_req__byte_enable__var = dmem_access_req__byte_enable;
            mem_access_req__address__var = dmem_access_req__address;
            mem_access_req__write_data__var = dmem_access_req__write_data;
            end
        3'h2: // req 1
            begin
            mem_access_req__read_enable__var = imem_access_req__read_enable;
            mem_access_req__address__var = imem_access_req__address;
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
        imem_access_resp__wait = 1'h0;
        dmem_access_resp__wait = 1'h0;
        imem_access_resp__read_data = mem_read_data;
        dmem_access_resp__read_data = read_data_reg;
        mem_access_req__address = mem_access_req__address__var;
        mem_access_req__byte_enable = mem_access_req__byte_enable__var;
        mem_access_req__write_enable = mem_access_req__write_enable__var;
        mem_access_req__read_enable = mem_access_req__read_enable__var;
        mem_access_req__write_data = mem_access_req__write_data__var;
    end //always

    //b srams__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : srams__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            read_data_reg <= 32'h0;
        end
        else if (clk__enable)
        begin
            if ((riscv_clock_phase==3'h1))
            begin
                read_data_reg <= mem_read_data;
            end //if
        end //if
    end //always

endmodule // tb_riscv_minimal_single_memory
