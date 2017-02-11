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

//a Module tb_de1_cl_controls
module tb_de1_cl_controls
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
    wire [7:0]sr_divider;
    wire user_inputs__updated_switches;
    wire user_inputs__diamond__a;
    wire user_inputs__diamond__b;
    wire user_inputs__diamond__x;
    wire user_inputs__diamond__y;
    wire user_inputs__joystick__u;
    wire user_inputs__joystick__d;
    wire user_inputs__joystick__l;
    wire user_inputs__joystick__r;
    wire user_inputs__joystick__c;
    wire user_inputs__left_dial__pressed;
    wire user_inputs__left_dial__direction;
    wire user_inputs__left_dial__direction_pulse;
    wire user_inputs__right_dial__pressed;
    wire user_inputs__right_dial__direction;
    wire user_inputs__right_dial__direction_pulse;
    wire user_inputs__touchpanel_irq;
    wire user_inputs__temperature_alarm;
    wire inputs_status__sr_data;
    wire inputs_status__left_rotary__direction_pin;
    wire inputs_status__left_rotary__transition_pin;
    wire inputs_status__right_rotary__direction_pin;
    wire inputs_status__right_rotary__transition_pin;
    wire inputs_control__sr_clock;
    wire inputs_control__sr_shift;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .user_inputs__temperature_alarm(user_inputs__temperature_alarm),
        .user_inputs__touchpanel_irq(user_inputs__touchpanel_irq),
        .user_inputs__right_dial__direction_pulse(user_inputs__right_dial__direction_pulse),
        .user_inputs__right_dial__direction(user_inputs__right_dial__direction),
        .user_inputs__right_dial__pressed(user_inputs__right_dial__pressed),
        .user_inputs__left_dial__direction_pulse(user_inputs__left_dial__direction_pulse),
        .user_inputs__left_dial__direction(user_inputs__left_dial__direction),
        .user_inputs__left_dial__pressed(user_inputs__left_dial__pressed),
        .user_inputs__joystick__c(user_inputs__joystick__c),
        .user_inputs__joystick__r(user_inputs__joystick__r),
        .user_inputs__joystick__l(user_inputs__joystick__l),
        .user_inputs__joystick__d(user_inputs__joystick__d),
        .user_inputs__joystick__u(user_inputs__joystick__u),
        .user_inputs__diamond__y(user_inputs__diamond__y),
        .user_inputs__diamond__x(user_inputs__diamond__x),
        .user_inputs__diamond__b(user_inputs__diamond__b),
        .user_inputs__diamond__a(user_inputs__diamond__a),
        .user_inputs__updated_switches(user_inputs__updated_switches),
        .inputs_control__sr_shift(inputs_control__sr_shift),
        .inputs_control__sr_clock(inputs_control__sr_clock),
        .inputs_status__right_rotary__transition_pin(            inputs_status__right_rotary__transition_pin),
        .inputs_status__right_rotary__direction_pin(            inputs_status__right_rotary__direction_pin),
        .inputs_status__left_rotary__transition_pin(            inputs_status__left_rotary__transition_pin),
        .inputs_status__left_rotary__direction_pin(            inputs_status__left_rotary__direction_pin),
        .inputs_status__sr_data(            inputs_status__sr_data),
        .sr_divider(            sr_divider)         );
    de1_cl_controls controls(
        .clk(clk),
        .clk__enable(1'b1),
        .inputs_status__right_rotary__transition_pin(inputs_status__right_rotary__transition_pin),
        .inputs_status__right_rotary__direction_pin(inputs_status__right_rotary__direction_pin),
        .inputs_status__left_rotary__transition_pin(inputs_status__left_rotary__transition_pin),
        .inputs_status__left_rotary__direction_pin(inputs_status__left_rotary__direction_pin),
        .inputs_status__sr_data(inputs_status__sr_data),
        .sr_divider(sr_divider),
        .reset_n(reset_n),
        .user_inputs__temperature_alarm(            user_inputs__temperature_alarm),
        .user_inputs__touchpanel_irq(            user_inputs__touchpanel_irq),
        .user_inputs__right_dial__direction_pulse(            user_inputs__right_dial__direction_pulse),
        .user_inputs__right_dial__direction(            user_inputs__right_dial__direction),
        .user_inputs__right_dial__pressed(            user_inputs__right_dial__pressed),
        .user_inputs__left_dial__direction_pulse(            user_inputs__left_dial__direction_pulse),
        .user_inputs__left_dial__direction(            user_inputs__left_dial__direction),
        .user_inputs__left_dial__pressed(            user_inputs__left_dial__pressed),
        .user_inputs__joystick__c(            user_inputs__joystick__c),
        .user_inputs__joystick__r(            user_inputs__joystick__r),
        .user_inputs__joystick__l(            user_inputs__joystick__l),
        .user_inputs__joystick__d(            user_inputs__joystick__d),
        .user_inputs__joystick__u(            user_inputs__joystick__u),
        .user_inputs__diamond__y(            user_inputs__diamond__y),
        .user_inputs__diamond__x(            user_inputs__diamond__x),
        .user_inputs__diamond__b(            user_inputs__diamond__b),
        .user_inputs__diamond__a(            user_inputs__diamond__a),
        .user_inputs__updated_switches(            user_inputs__updated_switches),
        .inputs_control__sr_shift(            inputs_control__sr_shift),
        .inputs_control__sr_clock(            inputs_control__sr_clock)         );
endmodule // tb_de1_cl_controls
