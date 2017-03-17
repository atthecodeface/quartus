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

//a Module tb_picoriscv
module tb_picoriscv
(
    clk,
    clk__enable,

    reset_n

);

    //b Clocks
    input clk;
    input clk__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials
    reg [63:0]keyboard__keys_low;

    //b Internal nets
    wire csr_response__acknowledge;
    wire csr_response__read_data_valid;
    wire csr_response__read_data_error;
    wire [31:0]csr_response__read_data;
    wire csr_request__valid;
    wire csr_request__read_not_write;
    wire [15:0]csr_request__select;
    wire [15:0]csr_request__address;
    wire [31:0]csr_request__data;
    wire [31:0]th_apb_response__prdata;
    wire th_apb_response__pready;
    wire th_apb_response__perr;
    wire [31:0]th_apb_request__paddr;
    wire th_apb_request__penable;
    wire th_apb_request__psel;
    wire th_apb_request__pwrite;
    wire [31:0]th_apb_request__pwdata;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .apb_response__perr(th_apb_response__perr),
        .apb_response__pready(th_apb_response__pready),
        .apb_response__prdata(th_apb_response__prdata),
        .apb_request__pwdata(            th_apb_request__pwdata),
        .apb_request__pwrite(            th_apb_request__pwrite),
        .apb_request__psel(            th_apb_request__psel),
        .apb_request__penable(            th_apb_request__penable),
        .apb_request__paddr(            th_apb_request__paddr)         );
    csr_master_apb master(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_response__read_data(csr_response__read_data),
        .csr_response__read_data_error(csr_response__read_data_error),
        .csr_response__read_data_valid(csr_response__read_data_valid),
        .csr_response__acknowledge(csr_response__acknowledge),
        .apb_request__pwdata(th_apb_request__pwdata),
        .apb_request__pwrite(th_apb_request__pwrite),
        .apb_request__psel(th_apb_request__psel),
        .apb_request__penable(th_apb_request__penable),
        .apb_request__paddr(th_apb_request__paddr),
        .reset_n(reset_n),
        .csr_request__data(            csr_request__data),
        .csr_request__address(            csr_request__address),
        .csr_request__select(            csr_request__select),
        .csr_request__read_not_write(            csr_request__read_not_write),
        .csr_request__valid(            csr_request__valid),
        .apb_response__perr(            th_apb_response__perr),
        .apb_response__pready(            th_apb_response__pready),
        .apb_response__prdata(            th_apb_response__prdata)         );
    picoriscv dut(
        .video_clk(clk),
        .video_clk__enable(1'b1),
        .clk(clk),
        .clk__enable(1'b1),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .keyboard__keys_low(keyboard__keys_low),
        .video_reset_n(reset_n),
        .reset_n(reset_n),
        .csr_response__read_data(            csr_response__read_data),
        .csr_response__read_data_error(            csr_response__read_data_error),
        .csr_response__read_data_valid(            csr_response__read_data_valid),
        .csr_response__acknowledge(            csr_response__acknowledge)         );
    //b riscv_instance combinatorial process
    always @ ( * )//riscv_instance
    begin: riscv_instance__comb_code
        keyboard__keys_low = 64'h0;
    end //always

endmodule // tb_picoriscv
