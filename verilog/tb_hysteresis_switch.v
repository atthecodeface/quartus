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

//a Module tb_hysteresis_switch
module tb_hysteresis_switch
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
    wire [15:0]filter_level;
    wire [15:0]filter_period;
    wire output_value;
    wire input_value;
    wire clk_enable;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .output_value(output_value),
        .filter_level(            filter_level),
        .filter_period(            filter_period),
        .input_value(            input_value),
        .clk_enable(            clk_enable)         );
    hysteresis_switch hs(
        .clk(clk),
        .clk__enable(1'b1),
        .filter_level(filter_level),
        .filter_period(filter_period),
        .input_value(input_value),
        .clk_enable(clk_enable),
        .reset_n(reset_n),
        .output_value(            output_value)         );
endmodule // tb_hysteresis_switch
