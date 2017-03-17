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

//a Module tb_dprintf
module tb_dprintf
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

    //b Internal nets
    wire dprintf_byte__valid;
    wire [7:0]dprintf_byte__data;
    wire [15:0]dprintf_byte__address;
        //   Debug printf acknowledge
    wire dprintf_ack;
        //   Debug printf request
    wire dprintf_req__valid;
    wire [15:0]dprintf_req__address;
    wire [63:0]dprintf_req__data_0;
    wire [63:0]dprintf_req__data_1;
    wire [63:0]dprintf_req__data_2;
    wire [63:0]dprintf_req__data_3;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .dprintf_byte__address(dprintf_byte__address),
        .dprintf_byte__data(dprintf_byte__data),
        .dprintf_byte__valid(dprintf_byte__valid),
        .dprintf_ack(dprintf_ack),
        .dprintf_req__data_3(            dprintf_req__data_3),
        .dprintf_req__data_2(            dprintf_req__data_2),
        .dprintf_req__data_1(            dprintf_req__data_1),
        .dprintf_req__data_0(            dprintf_req__data_0),
        .dprintf_req__address(            dprintf_req__address),
        .dprintf_req__valid(            dprintf_req__valid)         );
    dprintf dut(
        .clk(clk),
        .clk__enable(1'b1),
        .dprintf_req__data_3(dprintf_req__data_3),
        .dprintf_req__data_2(dprintf_req__data_2),
        .dprintf_req__data_1(dprintf_req__data_1),
        .dprintf_req__data_0(dprintf_req__data_0),
        .dprintf_req__address(dprintf_req__address),
        .dprintf_req__valid(dprintf_req__valid),
        .reset_n(reset_n),
        .dprintf_byte__address(            dprintf_byte__address),
        .dprintf_byte__data(            dprintf_byte__data),
        .dprintf_byte__valid(            dprintf_byte__valid),
        .dprintf_ack(            dprintf_ack)         );
endmodule // tb_dprintf
