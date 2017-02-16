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

//a Module de1_cl_controls
    //   
    //   This module manages the buttons and other controls on the Cambridge
    //   University Computer Laboratory DE1 daughterboard.
    //   
    //   A number of input switches are handled through a shift register, which is clocked using the input clock 'clk' divided down by the divider.
    //   This is handled by
    //   
    //   The rotary encoder switch '318-ENC130175F-12PS' available from Mouser has the following operation:
    //   
    //   Clockwise: B disconnects from C when A is disconnected from C
    //   
    //   Counter-clockwise: B connects to C when A is disconnected from C
    //   
    //   The CL daughterboard for the DE1 has a debounce RC network on the A
    //   and B pins, with a RC (probably) of 47us (high), so presumably the
    //   encoder is not optical :-).
    //   
    //   
module de1_cl_controls
(
    clk,
    clk__enable,

    sr_divider,
    inputs_status__sr_data,
    inputs_status__left_rotary__direction_pin,
    inputs_status__left_rotary__transition_pin,
    inputs_status__right_rotary__direction_pin,
    inputs_status__right_rotary__transition_pin,
    reset_n,

    user_inputs__updated_switches,
    user_inputs__diamond__a,
    user_inputs__diamond__b,
    user_inputs__diamond__x,
    user_inputs__diamond__y,
    user_inputs__joystick__u,
    user_inputs__joystick__d,
    user_inputs__joystick__l,
    user_inputs__joystick__r,
    user_inputs__joystick__c,
    user_inputs__left_dial__pressed,
    user_inputs__left_dial__direction,
    user_inputs__left_dial__direction_pulse,
    user_inputs__right_dial__pressed,
    user_inputs__right_dial__direction,
    user_inputs__right_dial__direction_pulse,
    user_inputs__touchpanel_irq,
    user_inputs__temperature_alarm,
    inputs_control__sr_clock,
    inputs_control__sr_shift
);

    //b Clocks
        //   system clock - not the shift register pin, something faster
    input clk;
    input clk__enable;

    //b Inputs
        //   clock divider to control speed of shift register
    input [7:0]sr_divider;
        //   Signals from the shift register, rotary encoders, etc on the DE1 CL daughterboard
    input inputs_status__sr_data;
    input inputs_status__left_rotary__direction_pin;
    input inputs_status__left_rotary__transition_pin;
    input inputs_status__right_rotary__direction_pin;
    input inputs_status__right_rotary__transition_pin;
        //   async reset
    input reset_n;

    //b Outputs
        //   
    output user_inputs__updated_switches;
    output user_inputs__diamond__a;
    output user_inputs__diamond__b;
    output user_inputs__diamond__x;
    output user_inputs__diamond__y;
    output user_inputs__joystick__u;
    output user_inputs__joystick__d;
    output user_inputs__joystick__l;
    output user_inputs__joystick__r;
    output user_inputs__joystick__c;
    output user_inputs__left_dial__pressed;
    output user_inputs__left_dial__direction;
    output user_inputs__left_dial__direction_pulse;
    output user_inputs__right_dial__pressed;
    output user_inputs__right_dial__direction;
    output user_inputs__right_dial__direction_pulse;
    output user_inputs__touchpanel_irq;
    output user_inputs__temperature_alarm;
        //   Signals to the shift register etc on the DE1 CL daughterboard
    output inputs_control__sr_clock;
    output inputs_control__sr_shift;

// output components here

    //b Output combinatorials
        //   Signals to the shift register etc on the DE1 CL daughterboard
    reg inputs_control__sr_clock;
    reg inputs_control__sr_shift;

    //b Output nets

    //b Internal and output registers
    reg [1:0]rotary_state__d_pin;
    reg [1:0]rotary_state__d_value;
    reg [7:0]rotary_state__d_count[1:0];
    reg [1:0]rotary_state__t_pin;
    reg [1:0]rotary_state__t_value;
    reg [7:0]rotary_state__t_count[1:0];
    reg [1:0]rotary_state__t_toggle;
    reg [1:0]rotary_state__direction;
    reg [1:0]rotary_state__direction_pulse;
    reg [7:0]sr_state__counter;
    reg [3:0]sr_state__num_bits_valid;
    reg [15:0]sr_state__shift_register;
    reg sr_state__sr_valid;
    reg sr_state__data;
    reg sr_state__sr_clock;
    reg sr_state__sr_shift;
    reg user_inputs__updated_switches;
    reg user_inputs__diamond__a;
    reg user_inputs__diamond__b;
    reg user_inputs__diamond__x;
    reg user_inputs__diamond__y;
    reg user_inputs__joystick__u;
    reg user_inputs__joystick__d;
    reg user_inputs__joystick__l;
    reg user_inputs__joystick__r;
    reg user_inputs__joystick__c;
    reg user_inputs__left_dial__pressed;
    reg user_inputs__left_dial__direction;
    reg user_inputs__left_dial__direction_pulse;
    reg user_inputs__right_dial__pressed;
    reg user_inputs__right_dial__direction;
    reg user_inputs__right_dial__direction_pulse;
    reg user_inputs__touchpanel_irq;
    reg user_inputs__temperature_alarm;

    //b Internal combinatorials
    reg [1:0]rotary_inputs__direction_pin;
    reg [1:0]rotary_inputs__transition_pin;
    reg sr_combs__sr_decode__diamond__a;
    reg sr_combs__sr_decode__diamond__b;
    reg sr_combs__sr_decode__diamond__x;
    reg sr_combs__sr_decode__diamond__y;
    reg sr_combs__sr_decode__touchpanel_irq;
    reg sr_combs__sr_decode__joystick__u;
    reg sr_combs__sr_decode__joystick__d;
    reg sr_combs__sr_decode__joystick__l;
    reg sr_combs__sr_decode__joystick__r;
    reg sr_combs__sr_decode__joystick__c;
    reg sr_combs__sr_decode__dialr_click;
    reg sr_combs__sr_decode__diall_click;
    reg sr_combs__sr_decode__temperature_alarm;
    reg sr_combs__sr_will_be_valid;
    reg sr_combs__counter_expired;
    reg sr_combs__falling_edge;
    reg sr_combs__rising_edge;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b inputs_control_logic combinatorial process
        //   
        //       Logic to drive the 'inputs_control' signals
        //       
    always @ ( * )//inputs_control_logic
    begin: inputs_control_logic__comb_code
        inputs_control__sr_clock = sr_state__sr_clock;
        inputs_control__sr_shift = sr_state__sr_shift;
    end //always

    //b shift_register_logic__comb combinatorial process
        //   
        //       The shift register runs continuously, performing a load of the
        //       LS165s when clock falls until the clock falls again (i.e. a whole
        //       clock period). During this clock the shift registers capture their
        //       data inputs and present the first data bit (Q7). So the first data
        //       bit is valid when 'load' is taken away (and turned in to 'shift').
        //   
        //       After a cycle with 'shift/nload' low, the following cycles will
        //       have it high. Since the data changes on rising clock, on the
        //       falling edge of clock following the first shift high the _second_
        //       bit will be presented - this is the original Q6 from the first
        //       LS165.
        //   
        //       This logic maintains a count of shift register bits that are
        //       valid, setting it to one when the first bit is captured at the end
        //       of 'shift' low. Then it keeps counting new bits until the shift
        //       register is valid - and during this cycle the 'shift/nload' is
        //       again held low, repeating the cycle.
        //   
        //       The rate of toggling the LS165 clock pin depends on a clock
        //       divider which is managed through 'counter'.
        //       
    always @ ( * )//shift_register_logic__comb
    begin: shift_register_logic__comb_code
        sr_combs__counter_expired = (sr_state__counter==8'h0);
        sr_combs__rising_edge = ((sr_combs__counter_expired!=1'h0)&&!(sr_state__sr_clock!=1'h0));
        sr_combs__falling_edge = ((sr_combs__counter_expired!=1'h0)&&(sr_state__sr_clock!=1'h0));
        sr_combs__sr_will_be_valid = ((sr_state__sr_shift!=1'h0)&&(sr_state__num_bits_valid==4'hf));
        sr_combs__sr_decode__diamond__b = sr_state__shift_register[0];
        sr_combs__sr_decode__diamond__a = sr_state__shift_register[1];
        sr_combs__sr_decode__diamond__y = sr_state__shift_register[2];
        sr_combs__sr_decode__diamond__x = sr_state__shift_register[3];
        sr_combs__sr_decode__touchpanel_irq = sr_state__shift_register[5];
        sr_combs__sr_decode__joystick__u = sr_state__shift_register[8];
        sr_combs__sr_decode__joystick__l = sr_state__shift_register[9];
        sr_combs__sr_decode__joystick__r = sr_state__shift_register[10];
        sr_combs__sr_decode__joystick__d = sr_state__shift_register[11];
        sr_combs__sr_decode__joystick__c = sr_state__shift_register[12];
        sr_combs__sr_decode__dialr_click = sr_state__shift_register[13];
        sr_combs__sr_decode__diall_click = sr_state__shift_register[14];
        sr_combs__sr_decode__temperature_alarm = sr_state__shift_register[15];
    end //always

    //b shift_register_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The shift register runs continuously, performing a load of the
        //       LS165s when clock falls until the clock falls again (i.e. a whole
        //       clock period). During this clock the shift registers capture their
        //       data inputs and present the first data bit (Q7). So the first data
        //       bit is valid when 'load' is taken away (and turned in to 'shift').
        //   
        //       After a cycle with 'shift/nload' low, the following cycles will
        //       have it high. Since the data changes on rising clock, on the
        //       falling edge of clock following the first shift high the _second_
        //       bit will be presented - this is the original Q6 from the first
        //       LS165.
        //   
        //       This logic maintains a count of shift register bits that are
        //       valid, setting it to one when the first bit is captured at the end
        //       of 'shift' low. Then it keeps counting new bits until the shift
        //       register is valid - and during this cycle the 'shift/nload' is
        //       again held low, repeating the cycle.
        //   
        //       The rate of toggling the LS165 clock pin depends on a clock
        //       divider which is managed through 'counter'.
        //       
    always @( posedge clk or negedge reset_n)
    begin : shift_register_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            sr_state__sr_valid <= 1'h0;
            sr_state__shift_register <= 16'h0;
            sr_state__num_bits_valid <= 4'h0;
            sr_state__sr_shift <= 1'h0;
            sr_state__counter <= 8'h0;
            sr_state__sr_clock <= 1'h0;
            sr_state__data <= 1'h0;
        end
        else if (clk__enable)
        begin
            sr_state__sr_valid <= 1'h0;
            if ((sr_combs__falling_edge!=1'h0))
            begin
                sr_state__sr_valid <= sr_combs__sr_will_be_valid;
                sr_state__shift_register <= {sr_state__shift_register[14:0],sr_state__data};
                if ((sr_state__sr_shift!=1'h0))
                begin
                    sr_state__num_bits_valid <= (sr_state__num_bits_valid+4'h1);
                end //if
                else
                
                begin
                    sr_state__num_bits_valid <= 4'h1;
                end //else
                if ((sr_combs__sr_will_be_valid!=1'h0))
                begin
                    sr_state__sr_shift <= 1'h0;
                end //if
                else
                
                begin
                    sr_state__sr_shift <= 1'h1;
                end //else
            end //if
            sr_state__counter <= (sr_state__counter-8'h1);
            if ((sr_combs__counter_expired!=1'h0))
            begin
                sr_state__counter <= sr_divider;
                sr_state__sr_clock <= !(sr_state__sr_clock!=1'h0);
            end //if
            sr_state__data <= inputs_status__sr_data;
        end //if
    end //always

    //b rotary_logic__comb combinatorial process
        //   
        //       The two rotary encoders are handled identically. A positive transition on
        //       the 'B' input is monitored, and when this occurs the rotary
        //       encoder has a valid pulse and the direction is given by the 'B'
        //       input.
        //       
    always @ ( * )//rotary_logic__comb
    begin: rotary_logic__comb_code
    reg [1:0]rotary_inputs__direction_pin__var;
    reg [1:0]rotary_inputs__transition_pin__var;
        rotary_inputs__direction_pin__var[0] = inputs_status__left_rotary__direction_pin;
        rotary_inputs__transition_pin__var[0] = inputs_status__left_rotary__transition_pin;
        rotary_inputs__direction_pin__var[1] = inputs_status__right_rotary__direction_pin;
        rotary_inputs__transition_pin__var[1] = inputs_status__right_rotary__transition_pin;
        rotary_inputs__direction_pin = rotary_inputs__direction_pin__var;
        rotary_inputs__transition_pin = rotary_inputs__transition_pin__var;
    end //always

    //b rotary_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The two rotary encoders are handled identically. A positive transition on
        //       the 'B' input is monitored, and when this occurs the rotary
        //       encoder has a valid pulse and the direction is given by the 'B'
        //       input.
        //       
    always @( posedge clk or negedge reset_n)
    begin : rotary_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            rotary_state__direction_pulse[0] <= 1'h0; // Should this be a bit vector?
            rotary_state__direction_pulse[1] <= 1'h0; // Should this be a bit vector?
            rotary_state__d_pin[0] <= 1'h0; // Should this be a bit vector?
            rotary_state__d_pin[1] <= 1'h0; // Should this be a bit vector?
            rotary_state__d_count[0] <= 8'h0;
            rotary_state__d_count[1] <= 8'h0;
            rotary_state__d_value[0] <= 1'h0; // Should this be a bit vector?
            rotary_state__d_value[1] <= 1'h0; // Should this be a bit vector?
            rotary_state__t_pin[0] <= 1'h0; // Should this be a bit vector?
            rotary_state__t_pin[1] <= 1'h0; // Should this be a bit vector?
            rotary_state__t_toggle[0] <= 1'h0; // Should this be a bit vector?
            rotary_state__t_toggle[1] <= 1'h0; // Should this be a bit vector?
            rotary_state__t_count[0] <= 8'h0;
            rotary_state__t_count[1] <= 8'h0;
            rotary_state__t_value[0] <= 1'h0; // Should this be a bit vector?
            rotary_state__t_value[1] <= 1'h0; // Should this be a bit vector?
            rotary_state__direction[0] <= 1'h0; // Should this be a bit vector?
            rotary_state__direction[1] <= 1'h0; // Should this be a bit vector?
        end
        else if (clk__enable)
        begin
            rotary_state__direction_pulse[0] <= 1'h0;
            if (((sr_combs__falling_edge!=1'h0)&&(sr_combs__sr_will_be_valid!=1'h0)))
            begin
                rotary_state__d_pin[0] <= rotary_inputs__direction_pin[0];
                if ((rotary_state__d_value[0]==rotary_state__d_pin[0]))
                begin
                    rotary_state__d_count[0] <= 8'h0;
                end //if
                else
                
                begin
                    if ((rotary_state__d_count[0]==8'h5))
                    begin
                        rotary_state__d_count[0] <= 8'h0;
                        rotary_state__d_value[0] <= rotary_state__d_pin[0];
                    end //if
                    else
                    
                    begin
                        rotary_state__d_count[0] <= (rotary_state__d_count[0]+8'h1);
                    end //else
                end //else
                rotary_state__t_pin[0] <= rotary_inputs__transition_pin[0];
                rotary_state__t_toggle[0] <= 1'h0;
                if ((rotary_state__t_value[0]==rotary_state__t_pin[0]))
                begin
                    rotary_state__t_count[0] <= 8'h0;
                end //if
                else
                
                begin
                    if ((rotary_state__t_count[0]==8'h5))
                    begin
                        rotary_state__t_count[0] <= 8'h0;
                        rotary_state__t_value[0] <= rotary_state__t_pin[0];
                        rotary_state__t_toggle[0] <= 1'h1;
                    end //if
                    else
                    
                    begin
                        rotary_state__t_count[0] <= (rotary_state__t_count[0]+8'h1);
                    end //else
                end //else
                if (((rotary_state__t_toggle[0]!=1'h0)&&!(rotary_state__t_value[0]!=1'h0)))
                begin
                    rotary_state__direction[0] <= !(rotary_state__d_value[0]!=1'h0);
                    rotary_state__direction_pulse[0] <= 1'h1;
                end //if
            end //if
            rotary_state__direction_pulse[1] <= 1'h0;
            if (((sr_combs__falling_edge!=1'h0)&&(sr_combs__sr_will_be_valid!=1'h0)))
            begin
                rotary_state__d_pin[1] <= rotary_inputs__direction_pin[1];
                if ((rotary_state__d_value[1]==rotary_state__d_pin[1]))
                begin
                    rotary_state__d_count[1] <= 8'h0;
                end //if
                else
                
                begin
                    if ((rotary_state__d_count[1]==8'h5))
                    begin
                        rotary_state__d_count[1] <= 8'h0;
                        rotary_state__d_value[1] <= rotary_state__d_pin[1];
                    end //if
                    else
                    
                    begin
                        rotary_state__d_count[1] <= (rotary_state__d_count[1]+8'h1);
                    end //else
                end //else
                rotary_state__t_pin[1] <= rotary_inputs__transition_pin[1];
                rotary_state__t_toggle[1] <= 1'h0;
                if ((rotary_state__t_value[1]==rotary_state__t_pin[1]))
                begin
                    rotary_state__t_count[1] <= 8'h0;
                end //if
                else
                
                begin
                    if ((rotary_state__t_count[1]==8'h5))
                    begin
                        rotary_state__t_count[1] <= 8'h0;
                        rotary_state__t_value[1] <= rotary_state__t_pin[1];
                        rotary_state__t_toggle[1] <= 1'h1;
                    end //if
                    else
                    
                    begin
                        rotary_state__t_count[1] <= (rotary_state__t_count[1]+8'h1);
                    end //else
                end //else
                if (((rotary_state__t_toggle[1]!=1'h0)&&!(rotary_state__t_value[1]!=1'h0)))
                begin
                    rotary_state__direction[1] <= !(rotary_state__d_value[1]!=1'h0);
                    rotary_state__direction_pulse[1] <= 1'h1;
                end //if
            end //if
        end //if
    end //always

    //b user_control_logic clock process
        //   
        //       Pull the shift register and rotary controls etc together
        //       
    always @( posedge clk or negedge reset_n)
    begin : user_control_logic__code
        if (reset_n==1'b0)
        begin
            user_inputs__updated_switches <= 1'h0;
            user_inputs__diamond__a <= 1'h0;
            user_inputs__diamond__b <= 1'h0;
            user_inputs__diamond__x <= 1'h0;
            user_inputs__diamond__y <= 1'h0;
            user_inputs__joystick__u <= 1'h0;
            user_inputs__joystick__d <= 1'h0;
            user_inputs__joystick__l <= 1'h0;
            user_inputs__joystick__r <= 1'h0;
            user_inputs__joystick__c <= 1'h0;
            user_inputs__touchpanel_irq <= 1'h0;
            user_inputs__temperature_alarm <= 1'h0;
            user_inputs__left_dial__pressed <= 1'h0;
            user_inputs__right_dial__pressed <= 1'h0;
            user_inputs__left_dial__direction_pulse <= 1'h0;
            user_inputs__left_dial__direction <= 1'h0;
            user_inputs__right_dial__direction_pulse <= 1'h0;
            user_inputs__right_dial__direction <= 1'h0;
        end
        else if (clk__enable)
        begin
            user_inputs__updated_switches <= sr_state__sr_valid;
            if ((sr_state__sr_valid!=1'h0))
            begin
                user_inputs__diamond__a <= sr_combs__sr_decode__diamond__a;
                user_inputs__diamond__b <= sr_combs__sr_decode__diamond__b;
                user_inputs__diamond__x <= sr_combs__sr_decode__diamond__x;
                user_inputs__diamond__y <= sr_combs__sr_decode__diamond__y;
                user_inputs__joystick__u <= sr_combs__sr_decode__joystick__u;
                user_inputs__joystick__d <= sr_combs__sr_decode__joystick__d;
                user_inputs__joystick__l <= sr_combs__sr_decode__joystick__l;
                user_inputs__joystick__r <= sr_combs__sr_decode__joystick__r;
                user_inputs__joystick__c <= sr_combs__sr_decode__joystick__c;
                user_inputs__touchpanel_irq <= sr_combs__sr_decode__touchpanel_irq;
                user_inputs__temperature_alarm <= sr_combs__sr_decode__temperature_alarm;
                user_inputs__left_dial__pressed <= sr_combs__sr_decode__diall_click;
                user_inputs__right_dial__pressed <= sr_combs__sr_decode__dialr_click;
            end //if
            user_inputs__left_dial__direction_pulse <= rotary_state__direction_pulse[0];
            user_inputs__left_dial__direction <= rotary_state__direction[0];
            user_inputs__right_dial__direction_pulse <= rotary_state__direction_pulse[1];
            user_inputs__right_dial__direction <= rotary_state__direction[1];
        end //if
    end //always

endmodule // de1_cl_controls
