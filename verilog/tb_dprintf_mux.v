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

//a Module tb_dprintf_mux
module tb_dprintf_mux
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
    reg req_3__valid;
    reg [15:0]req_3__address;
    reg [63:0]req_3__data_0;
    reg [63:0]req_3__data_1;
    reg [63:0]req_3__data_2;
    reg [63:0]req_3__data_3;
    reg req_2__valid;
    reg [15:0]req_2__address;
    reg [63:0]req_2__data_0;
    reg [63:0]req_2__data_1;
    reg req_1__valid;
    reg [15:0]req_1__address;
    reg [63:0]req_1__data_0;
    reg [63:0]req_1__data_1;
    reg req_0__valid;
    reg [15:0]req_0__address;
    reg [63:0]req_0__data_0;
    reg [63:0]req_0__data_1;
    reg req_012b__valid;
    reg [15:0]req_012b__address;
    reg [63:0]req_012b__data_0;
    reg [63:0]req_012b__data_1;
    reg [63:0]req_012b__data_2;
    reg [63:0]req_012b__data_3;

    //b Internal nets
    wire dprintf_byte__valid;
    wire [7:0]dprintf_byte__data;
    wire [15:0]dprintf_byte__address;
    wire ack_0123;
    wire ack_012;
    wire ack_01;
    wire ack_3;
    wire ack_2;
    wire ack_1;
    wire ack_0;
    wire req_0123__valid;
    wire [15:0]req_0123__address;
    wire [63:0]req_0123__data_0;
    wire [63:0]req_0123__data_1;
    wire [63:0]req_0123__data_2;
    wire [63:0]req_0123__data_3;
    wire req_012__valid;
    wire [15:0]req_012__address;
    wire [63:0]req_012__data_0;
    wire [63:0]req_012__data_1;
    wire req_01__valid;
    wire [15:0]req_01__address;
    wire [63:0]req_01__data_0;
    wire [63:0]req_01__data_1;
    wire [3:0]reqs;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .dprintf_byte__address(dprintf_byte__address),
        .dprintf_byte__data(dprintf_byte__data),
        .dprintf_byte__valid(dprintf_byte__valid),
        .acks({{{ack_3,ack_2},ack_1},ack_0}),
        .reqs(            reqs)         );
    dprintf_2_mux mux01(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(ack_01),
        .req_b__data_1(req_1__data_1),
        .req_b__data_0(req_1__data_0),
        .req_b__address(req_1__address),
        .req_b__valid(req_1__valid),
        .req_a__data_1(req_0__data_1),
        .req_a__data_0(req_0__data_0),
        .req_a__address(req_0__address),
        .req_a__valid(req_0__valid),
        .reset_n(reset_n),
        .req__data_1(            req_01__data_1),
        .req__data_0(            req_01__data_0),
        .req__address(            req_01__address),
        .req__valid(            req_01__valid),
        .ack_b(            ack_1),
        .ack_a(            ack_0)         );
    dprintf_2_mux mux012(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(ack_012),
        .req_b__data_1(req_2__data_1),
        .req_b__data_0(req_2__data_0),
        .req_b__address(req_2__address),
        .req_b__valid(req_2__valid),
        .req_a__data_1(req_01__data_1),
        .req_a__data_0(req_01__data_0),
        .req_a__address(req_01__address),
        .req_a__valid(req_01__valid),
        .reset_n(reset_n),
        .req__data_1(            req_012__data_1),
        .req__data_0(            req_012__data_0),
        .req__address(            req_012__address),
        .req__valid(            req_012__valid),
        .ack_b(            ack_2),
        .ack_a(            ack_01)         );
    dprintf_4_mux mux013(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(ack_0123),
        .req_b__data_3(req_3__data_3),
        .req_b__data_2(req_3__data_2),
        .req_b__data_1(req_3__data_1),
        .req_b__data_0(req_3__data_0),
        .req_b__address(req_3__address),
        .req_b__valid(req_3__valid),
        .req_a__data_3(req_012b__data_3),
        .req_a__data_2(req_012b__data_2),
        .req_a__data_1(req_012b__data_1),
        .req_a__data_0(req_012b__data_0),
        .req_a__address(req_012b__address),
        .req_a__valid(req_012b__valid),
        .reset_n(reset_n),
        .req__data_3(            req_0123__data_3),
        .req__data_2(            req_0123__data_2),
        .req__data_1(            req_0123__data_1),
        .req__data_0(            req_0123__data_0),
        .req__address(            req_0123__address),
        .req__valid(            req_0123__valid),
        .ack_b(            ack_3),
        .ack_a(            ack_012)         );
    dprintf dut(
        .clk(clk),
        .clk__enable(1'b1),
        .dprintf_req__data_3(req_0123__data_3),
        .dprintf_req__data_2(req_0123__data_2),
        .dprintf_req__data_1(req_0123__data_1),
        .dprintf_req__data_0(req_0123__data_0),
        .dprintf_req__address(req_0123__address),
        .dprintf_req__valid(req_0123__valid),
        .reset_n(reset_n),
        .dprintf_byte__address(            dprintf_byte__address),
        .dprintf_byte__data(            dprintf_byte__data),
        .dprintf_byte__valid(            dprintf_byte__valid),
        .dprintf_ack(            ack_0123)         );
    //b instantiations combinatorial process
    always @ ( * )//instantiations
    begin: instantiations__comb_code
        req_0__valid = reqs[0];
        req_0__address = 16'h1010;
        req_0__data_0 = 64'h4142434445464748;
        req_0__data_1 = 64'h83dead83beefff00;
        req_1__valid = reqs[1];
        req_1__address = 16'h2010;
        req_1__data_0 = 64'h20ff000000000000;
        req_1__data_1 = 64'h0;
        req_2__valid = reqs[2];
        req_2__address = 16'h3010;
        req_2__data_0 = 64'h22ff000000000000;
        req_2__data_1 = 64'h0;
        req_3__valid = reqs[3];
        req_3__address = 16'h4010;
        req_3__data_0 = 64'h3300000000000000;
        req_3__data_1 = 64'h0;
        req_3__data_2 = 64'h3400000000000000;
        req_3__data_3 = 64'h35;
        req_012b__valid = req_012__valid;
        req_012b__address = req_012__address;
        req_012b__data_0 = req_012__data_0;
        req_012b__data_1 = req_012__data_1;
        req_012b__data_2 = 64'hffffffffffffffff;
        req_012b__data_3 = 64'hffffffffffffffff;
    end //always

endmodule // tb_dprintf_mux
