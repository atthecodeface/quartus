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

//a Module tb_riscv_minimal
module tb_riscv_minimal
(
    clk,
    clk__enable,

    reset_n

);

    //b Clocks
    input clk;
    input clk__enable;
    wire riscv_clk; // Gated version of clock 'clk' enabled by 'riscv_clk_low'
    wire riscv_clk__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg riscv_clk_low;
    reg riscv_clk_high;

    //b Internal combinatorials
    reg imem_access_resp__wait;
    reg [31:0]imem_access_resp__read_data;
    reg dmem_access_resp__wait;
    reg [31:0]dmem_access_resp__read_data;

    //b Internal nets
    wire [31:0]main_mem_read_data;
    wire [31:0]imem_mem_read_data;
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
    assign riscv_clk__enable = (clk__enable && riscv_clk_low);
    //b Module instances
    se_sram_srw_16384x32 imem(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(imem_access_req__write_data),
        .address(imem_access_req__address[15:2]),
        .write_enable(1'h1),
        .read_not_write(imem_access_req__read_enable),
        .select((((imem_access_req__read_enable!=1'h0)||(imem_access_req__write_enable!=1'h0)) & riscv_clk_high)),
        .data_out(            imem_mem_read_data)         );
    se_sram_srw_16384x32_we8 dmem(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(dmem_access_req__write_data),
        .address(dmem_access_req__address[15:2]),
        .write_enable(4'hf),
        .read_not_write(dmem_access_req__read_enable),
        .select((((dmem_access_req__read_enable!=1'h0)||(dmem_access_req__write_enable!=1'h0)) & riscv_clk_high)),
        .data_out(            main_mem_read_data)         );
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
    //b clock_divider clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : clock_divider__code
        if (reset_n==1'b0)
        begin
            riscv_clk_high <= 1'h0;
            riscv_clk_low <= 1'h0;
        end
        else if (clk__enable)
        begin
            riscv_clk_high <= !(riscv_clk_high!=1'h0);
            riscv_clk_low <= riscv_clk_high;
        end //if
    end //always

    //b srams combinatorial process
    always @ ( * )//srams
    begin: srams__comb_code
        imem_access_resp__wait = 1'h0;
        imem_access_resp__read_data = imem_mem_read_data;
        dmem_access_resp__wait = 1'h0;
        dmem_access_resp__read_data = main_mem_read_data;
    end //always

endmodule // tb_riscv_minimal
