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

//a Module apb_target_de1_cl_inputs
    //   
    //   This module provides an APB target to get the status of inputs for the
    //   Cambridge University DE1-SOC daughterboard.
    //   
    //   The CL DE1-SOC daughterboard contains a joystick, a diamond of four
    //   buttons, two rotary dials, and apparently a temperature alarm and
    //   touchpanel intrerrupt (the latter two I have not used as yet).
    //   
    //   Two registers are provided. The first is the state register,
    //   
    //   Bits     | Meaning
    //   ---------|---------
    //   31       | Inputs changed since last read of state
    //   5;26     | zero
    //   25       | temperature alarm
    //   24       | touchpanel interrupt
    //   6;18     | zero
    //   17       | right rotary dial is pressed in
    //   16       | left rotary dial is pressed in
    //   3;13     | zero
    //   12       | joystick is being pressed
    //   11       | joystick is being pushed right
    //   10       | joystick is being pushed left
    //   9        | joystick is being pushed down
    //   8        | joystick is being pushed up
    //   4;4      | zero
    //   3        | diamond y (top black button) is being pressed
    //   2        | diamond x (left blue button) is being pressed
    //   1        | diamond b (right red button) is being pressed
    //   0        | diamond a (bottom green button) is being pressed
    //   
    //   The second register relates just to the rotary dials; the hardware
    //   keeps track of directional impulses to provide an 8-bit 'rotary value'
    //   for each dial.
    //   
    //   Bits     | Meaning
    //   ---------|---------
    //   31       | Inputs changed since last read of state
    //   13;18     | zero
    //   17       | right rotary dial is pressed in
    //   16       | left rotary dial is pressed in
    //   8;8      | right rotary dial position (decremented on anticlockwise, incremented on clockwise)
    //   8;0      | left rotary dial position (decremented on anticlockwise, incremented on clockwise)
    //   
module apb_target_de1_cl_inputs
(
    clk,
    clk__enable,

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
    apb_request__paddr,
    apb_request__penable,
    apb_request__psel,
    apb_request__pwrite,
    apb_request__pwdata,
    reset_n,

    apb_response__prdata,
    apb_response__pready,
    apb_response__perr
);

    //b Clocks
        //   System clock
    input clk;
    input clk__enable;

    //b Inputs
    input user_inputs__updated_switches;
    input user_inputs__diamond__a;
    input user_inputs__diamond__b;
    input user_inputs__diamond__x;
    input user_inputs__diamond__y;
    input user_inputs__joystick__u;
    input user_inputs__joystick__d;
    input user_inputs__joystick__l;
    input user_inputs__joystick__r;
    input user_inputs__joystick__c;
    input user_inputs__left_dial__pressed;
    input user_inputs__left_dial__direction;
    input user_inputs__left_dial__direction_pulse;
    input user_inputs__right_dial__pressed;
    input user_inputs__right_dial__direction;
    input user_inputs__right_dial__direction_pulse;
    input user_inputs__touchpanel_irq;
    input user_inputs__temperature_alarm;
        //   APB request
    input [31:0]apb_request__paddr;
    input apb_request__penable;
    input apb_request__psel;
    input apb_request__pwrite;
    input [31:0]apb_request__pwdata;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   APB response
    output [31:0]apb_response__prdata;
    output apb_response__pready;
    output apb_response__perr;

// output components here

    //b Output combinatorials
        //   APB response
    reg [31:0]apb_response__prdata;
    reg apb_response__pready;
    reg apb_response__perr;

    //b Output nets

    //b Internal and output registers
    reg input_state__user_inputs__updated_switches;
    reg input_state__user_inputs__diamond__a;
    reg input_state__user_inputs__diamond__b;
    reg input_state__user_inputs__diamond__x;
    reg input_state__user_inputs__diamond__y;
    reg input_state__user_inputs__joystick__u;
    reg input_state__user_inputs__joystick__d;
    reg input_state__user_inputs__joystick__l;
    reg input_state__user_inputs__joystick__r;
    reg input_state__user_inputs__joystick__c;
    reg input_state__user_inputs__left_dial__pressed;
    reg input_state__user_inputs__left_dial__direction;
    reg input_state__user_inputs__left_dial__direction_pulse;
    reg input_state__user_inputs__right_dial__pressed;
    reg input_state__user_inputs__right_dial__direction;
    reg input_state__user_inputs__right_dial__direction_pulse;
    reg input_state__user_inputs__touchpanel_irq;
    reg input_state__user_inputs__temperature_alarm;
    reg input_state__inputs_changed;
    reg [7:0]input_state__left_dial_position;
    reg [7:0]input_state__right_dial_position;
        //   Access being performed by APB
    reg [2:0]access;

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b apb_interface_logic__comb combinatorial process
        //   
        //       The APB interface is decoded to @a access when @p psel is asserted
        //       and @p penable is deasserted - this is the first cycle of an APB
        //       access. This permits the access type to be registered, so that the
        //       APB @p prdata can be driven from registers, and so that writes
        //       will occur correctly when @p penable is asserted.
        //   
        //       The APB read data @p prdata can then be generated based on @a
        //       access.
        //       
    always @ ( * )//apb_interface_logic__comb
    begin: apb_interface_logic__comb_code
    reg [31:0]apb_response__prdata__var;
    reg apb_response__pready__var;
        apb_response__prdata__var = 32'h0;
        apb_response__pready__var = 1'h0;
        apb_response__perr = 1'h0;
        apb_response__pready__var = 1'h1;
        case (access) //synopsys parallel_case
        3'h1: // req 1
            begin
            apb_response__prdata__var = {{{{{{{{{{{{{{{{{input_state__inputs_changed,5'h0},input_state__user_inputs__temperature_alarm},input_state__user_inputs__touchpanel_irq},6'h0},input_state__user_inputs__right_dial__pressed},input_state__user_inputs__left_dial__pressed},3'h0},input_state__user_inputs__joystick__c},input_state__user_inputs__joystick__r},input_state__user_inputs__joystick__l},input_state__user_inputs__joystick__d},input_state__user_inputs__joystick__u},4'h0},input_state__user_inputs__diamond__y},input_state__user_inputs__diamond__x},input_state__user_inputs__diamond__b},input_state__user_inputs__diamond__a};
            end
        3'h2: // req 1
            begin
            apb_response__prdata__var = {{{{{input_state__inputs_changed,13'h0},input_state__user_inputs__right_dial__pressed},input_state__user_inputs__left_dial__pressed},input_state__right_dial_position},input_state__left_dial_position};
            end
        //synopsys  translate_off
        //pragma coverage off
        //synopsys  translate_on
        default:
            begin
            //Need a default case to make Cadence Lint happy, even though this is not a full case
            end
        //synopsys  translate_off
        //pragma coverage on
        //synopsys  translate_on
        endcase
        apb_response__prdata = apb_response__prdata__var;
        apb_response__pready = apb_response__pready__var;
    end //always

    //b apb_interface_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The APB interface is decoded to @a access when @p psel is asserted
        //       and @p penable is deasserted - this is the first cycle of an APB
        //       access. This permits the access type to be registered, so that the
        //       APB @p prdata can be driven from registers, and so that writes
        //       will occur correctly when @p penable is asserted.
        //   
        //       The APB read data @p prdata can then be generated based on @a
        //       access.
        //       
    always @( posedge clk or negedge reset_n)
    begin : apb_interface_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            access <= 3'h0;
        end
        else if (clk__enable)
        begin
            access <= 3'h0;
            case (apb_request__paddr[2:0]) //synopsys parallel_case
            3'h0: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h0:3'h1);
                end
            3'h1: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h0:3'h2);
                end
            //synopsys  translate_off
            //pragma coverage off
            //synopsys  translate_on
            default:
                begin
                //Need a default case to make Cadence Lint happy, even though this is not a full case
                end
            //synopsys  translate_off
            //pragma coverage on
            //synopsys  translate_on
            endcase
            if ((!(apb_request__psel!=1'h0)||(apb_request__penable!=1'h0)))
            begin
                access <= 3'h0;
            end //if
        end //if
    end //always

    //b input_logic clock process
        //   
        //       The input state logic is relatively simple.
        //   
        //       The current @a user_inputs are recorded on @a
        //       input_state.user_inputs. When a change is detected, @a
        //       inputs_changed is asserted; this is only cleared on a read of the
        //       state register.
        //   
        //       The rotary dial's positions are updated when the @a
        //       direction_pulse asserts, using the appropriate @a dial_direction
        //       to indicate whether to increment or decrement.
        //       
    always @( posedge clk or negedge reset_n)
    begin : input_logic__code
        if (reset_n==1'b0)
        begin
            input_state__inputs_changed <= 1'h0;
            input_state__user_inputs__updated_switches <= 1'h0;
            input_state__user_inputs__diamond__a <= 1'h0;
            input_state__user_inputs__diamond__b <= 1'h0;
            input_state__user_inputs__diamond__x <= 1'h0;
            input_state__user_inputs__diamond__y <= 1'h0;
            input_state__user_inputs__joystick__u <= 1'h0;
            input_state__user_inputs__joystick__d <= 1'h0;
            input_state__user_inputs__joystick__l <= 1'h0;
            input_state__user_inputs__joystick__r <= 1'h0;
            input_state__user_inputs__joystick__c <= 1'h0;
            input_state__user_inputs__left_dial__pressed <= 1'h0;
            input_state__user_inputs__left_dial__direction <= 1'h0;
            input_state__user_inputs__left_dial__direction_pulse <= 1'h0;
            input_state__user_inputs__right_dial__pressed <= 1'h0;
            input_state__user_inputs__right_dial__direction <= 1'h0;
            input_state__user_inputs__right_dial__direction_pulse <= 1'h0;
            input_state__user_inputs__touchpanel_irq <= 1'h0;
            input_state__user_inputs__temperature_alarm <= 1'h0;
            input_state__left_dial_position <= 8'h0;
            input_state__right_dial_position <= 8'h0;
        end
        else if (clk__enable)
        begin
            if ((access==3'h1))
            begin
                input_state__inputs_changed <= 1'h0;
            end //if
            input_state__user_inputs__updated_switches <= user_inputs__updated_switches;
            input_state__user_inputs__diamond__a <= user_inputs__diamond__a;
            input_state__user_inputs__diamond__b <= user_inputs__diamond__b;
            input_state__user_inputs__diamond__x <= user_inputs__diamond__x;
            input_state__user_inputs__diamond__y <= user_inputs__diamond__y;
            input_state__user_inputs__joystick__u <= user_inputs__joystick__u;
            input_state__user_inputs__joystick__d <= user_inputs__joystick__d;
            input_state__user_inputs__joystick__l <= user_inputs__joystick__l;
            input_state__user_inputs__joystick__r <= user_inputs__joystick__r;
            input_state__user_inputs__joystick__c <= user_inputs__joystick__c;
            input_state__user_inputs__left_dial__pressed <= user_inputs__left_dial__pressed;
            input_state__user_inputs__left_dial__direction <= user_inputs__left_dial__direction;
            input_state__user_inputs__left_dial__direction_pulse <= user_inputs__left_dial__direction_pulse;
            input_state__user_inputs__right_dial__pressed <= user_inputs__right_dial__pressed;
            input_state__user_inputs__right_dial__direction <= user_inputs__right_dial__direction;
            input_state__user_inputs__right_dial__direction_pulse <= user_inputs__right_dial__direction_pulse;
            input_state__user_inputs__touchpanel_irq <= user_inputs__touchpanel_irq;
            input_state__user_inputs__temperature_alarm <= user_inputs__temperature_alarm;
            if ((input_state__user_inputs__left_dial__direction_pulse!=1'h0))
            begin
                input_state__inputs_changed <= 1'h1;
                if ((input_state__user_inputs__left_dial__direction!=1'h0))
                begin
                    input_state__left_dial_position <= (input_state__left_dial_position-8'h1);
                end //if
                else
                
                begin
                    input_state__left_dial_position <= (input_state__left_dial_position+8'h1);
                end //else
            end //if
            if ((input_state__user_inputs__right_dial__direction_pulse!=1'h0))
            begin
                input_state__inputs_changed <= 1'h1;
                if ((input_state__user_inputs__right_dial__direction!=1'h0))
                begin
                    input_state__right_dial_position <= (input_state__right_dial_position-8'h1);
                end //if
                else
                
                begin
                    input_state__right_dial_position <= (input_state__right_dial_position+8'h1);
                end //else
            end //if
            if ((user_inputs__diamond__a!=input_state__user_inputs__diamond__a))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__diamond__b!=input_state__user_inputs__diamond__b))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__diamond__x!=input_state__user_inputs__diamond__x))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__diamond__y!=input_state__user_inputs__diamond__y))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__joystick__u!=input_state__user_inputs__joystick__u))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__joystick__d!=input_state__user_inputs__joystick__d))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__joystick__l!=input_state__user_inputs__joystick__l))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__joystick__r!=input_state__user_inputs__joystick__r))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__joystick__c!=input_state__user_inputs__joystick__c))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__left_dial__pressed!=input_state__user_inputs__left_dial__pressed))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__right_dial__pressed!=input_state__user_inputs__right_dial__pressed))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__touchpanel_irq!=input_state__user_inputs__touchpanel_irq))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
            if ((user_inputs__temperature_alarm!=input_state__user_inputs__temperature_alarm))
            begin
                input_state__inputs_changed <= 1'h1;
            end //if
        end //if
    end //always

endmodule // apb_target_de1_cl_inputs
