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

//a Module tb_input_devices
module tb_input_devices
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
    wire ps2_key__valid;
    wire ps2_key__extended;
    wire ps2_key__release;
    wire [7:0]ps2_key__key_number;
    wire [15:0]divider;
    wire ps2_rx_data__valid;
    wire [7:0]ps2_rx_data__data;
    wire ps2_rx_data__parity_error;
    wire ps2_rx_data__protocol_error;
    wire ps2_rx_data__timeout;
    wire ps2_out__data;
    wire ps2_out__clk;
    wire ps2_in__data;
    wire ps2_in__clk;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .ps2_key__key_number(ps2_key__key_number),
        .ps2_key__release(ps2_key__release),
        .ps2_key__extended(ps2_key__extended),
        .ps2_key__valid(ps2_key__valid),
        .ps2_rx_data__timeout(ps2_rx_data__timeout),
        .ps2_rx_data__protocol_error(ps2_rx_data__protocol_error),
        .ps2_rx_data__parity_error(ps2_rx_data__parity_error),
        .ps2_rx_data__data(ps2_rx_data__data),
        .ps2_rx_data__valid(ps2_rx_data__valid),
        .ps2_in__clk(ps2_out__clk),
        .ps2_in__data(ps2_out__data),
        .divider(            divider),
        .ps2_out__clk(            ps2_in__clk),
        .ps2_out__data(            ps2_in__data)         );
    ps2_host ps2(
        .clk(clk),
        .clk__enable(1'b1),
        .divider(divider),
        .ps2_in__clk(ps2_in__clk),
        .ps2_in__data(ps2_in__data),
        .reset_n(reset_n),
        .ps2_rx_data__timeout(            ps2_rx_data__timeout),
        .ps2_rx_data__protocol_error(            ps2_rx_data__protocol_error),
        .ps2_rx_data__parity_error(            ps2_rx_data__parity_error),
        .ps2_rx_data__data(            ps2_rx_data__data),
        .ps2_rx_data__valid(            ps2_rx_data__valid),
        .ps2_out__clk(            ps2_out__clk),
        .ps2_out__data(            ps2_out__data)         );
    ps2_host_keyboard key_decode(
        .clk(clk),
        .clk__enable(1'b1),
        .ps2_rx_data__timeout(ps2_rx_data__timeout),
        .ps2_rx_data__protocol_error(ps2_rx_data__protocol_error),
        .ps2_rx_data__parity_error(ps2_rx_data__parity_error),
        .ps2_rx_data__data(ps2_rx_data__data),
        .ps2_rx_data__valid(ps2_rx_data__valid),
        .reset_n(reset_n),
        .ps2_key__key_number(            ps2_key__key_number),
        .ps2_key__release(            ps2_key__release),
        .ps2_key__extended(            ps2_key__extended),
        .ps2_key__valid(            ps2_key__valid)         );
endmodule // tb_input_devices
