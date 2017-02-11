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

//a Module tb_led_ws2812_chain
module tb_led_ws2812_chain
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
    wire led_data_pin;
    wire led_data__valid;
    wire led_data__last;
    wire [7:0]led_data__red;
    wire [7:0]led_data__green;
    wire [7:0]led_data__blue;
    wire led_request__ready;
    wire led_request__first;
    wire [7:0]led_request__led_number;
    wire [7:0]divider_400ns;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .led_data_pin(led_data_pin),
        .led_request__led_number(led_request__led_number),
        .led_request__first(led_request__first),
        .led_request__ready(led_request__ready),
        .led_data__blue(            led_data__blue),
        .led_data__green(            led_data__green),
        .led_data__red(            led_data__red),
        .led_data__last(            led_data__last),
        .led_data__valid(            led_data__valid),
        .divider_400ns(            divider_400ns)         );
    led_ws2812_chain led_chain(
        .clk(clk),
        .clk__enable(1'b1),
        .led_data__blue(led_data__blue),
        .led_data__green(led_data__green),
        .led_data__red(led_data__red),
        .led_data__last(led_data__last),
        .led_data__valid(led_data__valid),
        .divider_400ns(divider_400ns),
        .reset_n(reset_n),
        .led_data_pin(            led_data_pin),
        .led_request__led_number(            led_request__led_number),
        .led_request__first(            led_request__first),
        .led_request__ready(            led_request__ready)         );
endmodule // tb_led_ws2812_chain
