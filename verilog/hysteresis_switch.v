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

//a Module hysteresis_switch
    //   
    //    * CDL implementation of a module that takes an input signal and
    //    * notionally keeps a count of cycles that the input is low, and
    //    * cycles that the input is high; using these counters it makes a
    //    * decision on the real value of the output, using hysteresis.
    //    *
    //    * Since infinite history is not sensible and the counters cannot run
    //    * indefinitely without overflow anyway, the counters divide by 2 on a
    //    * configurable divider (effectively filtering the input stream).
    //    *
    //    * The two notional counters are @a cycles_low and @a cycles_high.
    //    *
    //    * To switch to a 'high' output from a current 'low' output requires
    //    * the @a cycles_high - @a cycles_low to be greater than half of the
    //    * filter period.
    //    *
    //    * To switch to a 'low' output from a current 'high' output requires
    //    * the @a cycles_high - @a cycles_low to be less than minus half of the
    //    * filter period.
    //    *
    //    * Hence a n+1 bit difference would need to be maintained for
    //    * @a cycles_high and @a cycles_low. This difference would increase by 1
    //    * if the input is high, and decrease by 1 if the input is low.
    //    *
    //    * Hence an actual implementation can maintain an up/down counter
    //    * @a cycles_diff, which is divided by 2 every filter period, and which
    //    * is incremented on input of 1, and decremented on input of 0.
    //    *
    //    * When the output is low and the @a cycles_diff is > half the filter
    //    * period the output shifts to high.
    //    *
    //    * When the output is high and the @a cycles_diff is < -half the filter
    //    * period the output shifts to low.
    //   
module hysteresis_switch
(
    clk,
    clk__enable,

    filter_level,
    filter_period,
    input_value,
    clk_enable,
    reset_n,

    output_value
);

    //b Clocks
        //   Clock for the module
    input clk;
    input clk__enable;
    wire slow_clk; // Gated version of clock 'clk' enabled by 'clk_enable'
    wire slow_clk__enable;

    //b Inputs
        //   Value to exceed to switch output levels - the larger the value, the larger the hysteresis; must be less than 2*filter_period
    input [15:0]filter_level;
        //   Period over which to filter the input - the larger the value, the longer it takes to switch, but the more glitches are removed
    input [15:0]filter_period;
        //   Input pin level, to apply hysteresis to
    input input_value;
        //   Assert to enable the internal clock; this permits I/O switches to easily use a slower clock
    input clk_enable;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Output level, after hysteresis
    output output_value;

// output components here

    //b Output combinatorials
        //   Output level, after hysteresis
    reg output_value;

    //b Output nets

    //b Internal and output registers
        //   Hysteresis state
    reg hysteresis_state__output_level;
    reg [15:0]hysteresis_state__cycles_diff;
    reg [15:0]hysteresis_state__period_counter;

    //b Internal combinatorials
        //   Combinatorial decode of the hysteresis state
    reg hysteresis_combs__period_expired;
    reg [15:0]hysteresis_combs__cycles_diff_div_two;
    reg [15:0]hysteresis_combs__next_cycles_diff;
    reg [16:0]hysteresis_combs__switch_adder;
    reg [16:0]hysteresis_combs__switch_level;
    reg hysteresis_combs__toggle_output_level;

    //b Internal nets

    //b Clock gating module instances
    assign slow_clk__enable = (clk__enable && clk_enable);
    //b Module instances
    //b hysteresis_logic__comb combinatorial process
        //   
        //       Count the filter period and divide the adder by 2 (signed
        //       division) every time it expires, incrementing it if the input is
        //       high, decrementing it if the input is low.
        //   
        //       Compare the adder to filter_level (appropriately +/-, based on
        //       the output level). If the adder has gone beyond the hysteresis
        //       level (e.g. output_level low, and adder > filter_level ), then
        //       toggle the output_level.
        //       
    always @ ( * )//hysteresis_logic__comb
    begin: hysteresis_logic__comb_code
    reg [15:0]hysteresis_combs__next_cycles_diff__var;
    reg [16:0]hysteresis_combs__switch_adder__var;
    reg hysteresis_combs__toggle_output_level__var;
        hysteresis_combs__period_expired = (hysteresis_state__period_counter==16'h0);
        hysteresis_combs__cycles_diff_div_two = {hysteresis_state__cycles_diff[15],hysteresis_state__cycles_diff[15:1]};
        if ((input_value!=1'h0))
        begin
            hysteresis_combs__next_cycles_diff__var = (((hysteresis_combs__period_expired!=1'h0)?hysteresis_combs__cycles_diff_div_two:hysteresis_state__cycles_diff)+16'h1);
        end //if
        else
        
        begin
            hysteresis_combs__next_cycles_diff__var = (((hysteresis_combs__period_expired!=1'h0)?hysteresis_combs__cycles_diff_div_two:hysteresis_state__cycles_diff)-16'h1);
        end //else
        hysteresis_combs__switch_adder__var = {1'h0,filter_level};
        if (!(hysteresis_state__output_level!=1'h0))
        begin
            hysteresis_combs__switch_adder__var = {1'h1,~filter_level};
        end //if
        hysteresis_combs__switch_level = (hysteresis_combs__switch_adder__var+{hysteresis_state__cycles_diff[15],hysteresis_state__cycles_diff});
        hysteresis_combs__toggle_output_level__var = 1'h0;
        if ((hysteresis_combs__switch_level[16]==hysteresis_state__output_level))
        begin
            hysteresis_combs__toggle_output_level__var = 1'h1;
        end //if
        output_value = hysteresis_state__output_level;
        hysteresis_combs__next_cycles_diff = hysteresis_combs__next_cycles_diff__var;
        hysteresis_combs__switch_adder = hysteresis_combs__switch_adder__var;
        hysteresis_combs__toggle_output_level = hysteresis_combs__toggle_output_level__var;
    end //always

    //b hysteresis_logic__posedge_slow_clk_active_low_reset_n clock process
        //   
        //       Count the filter period and divide the adder by 2 (signed
        //       division) every time it expires, incrementing it if the input is
        //       high, decrementing it if the input is low.
        //   
        //       Compare the adder to filter_level (appropriately +/-, based on
        //       the output level). If the adder has gone beyond the hysteresis
        //       level (e.g. output_level low, and adder > filter_level ), then
        //       toggle the output_level.
        //       
    always @( posedge clk or negedge reset_n)
    begin : hysteresis_logic__posedge_slow_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            hysteresis_state__period_counter <= 16'h0;
            hysteresis_state__cycles_diff <= 16'h0;
            hysteresis_state__output_level <= 1'h0;
        end
        else if (slow_clk__enable)
        begin
            hysteresis_state__period_counter <= (hysteresis_state__period_counter-16'h1);
            if ((hysteresis_combs__period_expired!=1'h0))
            begin
                hysteresis_state__period_counter <= filter_period;
            end //if
            hysteresis_state__cycles_diff <= hysteresis_combs__next_cycles_diff;
            hysteresis_state__output_level <= (hysteresis_state__output_level ^ hysteresis_combs__toggle_output_level);
        end //if
    end //always

endmodule // hysteresis_switch
