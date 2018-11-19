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

//a Module apb_target_rv_timer
    //   
    //   RISC-V compatible timer with an APB interface.
    //   
    //   This is a monotonically increasing 64-bit timer with a 64-bit comparator.
    //   
    //   The timer has a fractional component to permit, for example, a
    //   'nanosecond' timer that is clocked at, say, 600MHz; in this case the
    //   timer is ticked every 1.666ns, and so an addition in each cycle of
    //   0xa to a 4-bit fractional component and a 1 integer component. The
    //   timer_control has, therfore, a fixed-point adder value with a 4-digit
    //   fractional component.
    //   
    //   However, this would actually lead to a timer that would be only 99.61% accurate.
    //   
    //   Hence a further subfraction capability is supported; this permits a
    //   further 1/16th of a nanosecond (or whatever the timer unit is) to be
    //   added for M out of every N cycles.
    //   
    //   In the case of 600MHz a bonus 1/16th should be added for 2 out of
    //   every 3 cycles. This is set using a bonus_subfraction_numer of 0 and a
    //   bonus_subfraction_denom of 2 (meaning for 2 out of every 3 cycles add
    //   a further 1/16th).
    //   
    //   Hence every three cycles the timer will have 0x1.b, 0x1.b, 0x1.a
    //   added to it - hence the timer will have gone up by an integer value of
    //   5ns, which is correct for 3 600MHz clock cycles.
    //   
    //   If the control values are tied off to zero then the extra fractional
    //   logic will be optimized out.
    //   
    //   Some example values for 1ns timer values:
    //   
    //   Clock  | Period    | Adder (Int/fraction) | Subfraction Numer/Denom
    //   -------|-----------|----------------------|------------------------
    //   1GHz   |    1ns    |      1 / 0x0         |    0 / 0
    //   800MHz |  1.25ns   |      1 / 0x4         |    0 / 0
    //   600MHz |  1.66ns   |      1 / 0xa         |    0 / 2
    //   
    //   The period should be:
    //   
    //     * subfraction numer/denum=0/x: (Int + fraction/16)
    //   
    //     * subfraction numer/denum=M/N: (Int + (fraction+(N-M-1)/N)/16) 
    //   
    //   
module apb_target_rv_timer
(
    clk,
    clk__enable,

    apb_request__paddr,
    apb_request__penable,
    apb_request__psel,
    apb_request__pwrite,
    apb_request__pwdata,
    timer_control__reset_counter,
    timer_control__enable_counter,
    timer_control__block_writes,
    timer_control__bonus_subfraction_numer,
    timer_control__bonus_subfraction_denom,
    timer_control__fractional_adder,
    timer_control__integer_adder,
    reset_n,

    timer_value__irq,
    timer_value__value,
    apb_response__prdata,
    apb_response__pready,
    apb_response__perr
);

    //b Clocks
        //   System clock
    input clk;
    input clk__enable;

    //b Inputs
        //   APB request
    input [31:0]apb_request__paddr;
    input apb_request__penable;
    input apb_request__psel;
    input apb_request__pwrite;
    input [31:0]apb_request__pwdata;
        //   Control of the timer
    input timer_control__reset_counter;
    input timer_control__enable_counter;
    input timer_control__block_writes;
    input [7:0]timer_control__bonus_subfraction_numer;
    input [7:0]timer_control__bonus_subfraction_denom;
    input [3:0]timer_control__fractional_adder;
    input [7:0]timer_control__integer_adder;
        //   Active low reset
    input reset_n;

    //b Outputs
    output timer_value__irq;
    output [63:0]timer_value__value;
        //   APB response
    output [31:0]apb_response__prdata;
    output apb_response__pready;
    output apb_response__perr;

// output components here

    //b Output combinatorials
    reg timer_value__irq;
    reg [63:0]timer_value__value;
        //   APB response
    reg [31:0]apb_response__prdata;
    reg apb_response__pready;
    reg apb_response__perr;

    //b Output nets

    //b Internal and output registers
        //   State of the timer and comparator
    reg [7:0]timer_state__bonus_subfraction_step;
    reg timer_state__fractional_bonus;
    reg [3:0]timer_state__fraction;
    reg [31:0]timer_state__timer_lower;
    reg [31:0]timer_state__timer_upper;
    reg [31:0]timer_state__comparator_lower;
    reg [31:0]timer_state__comparator_upper;
    reg timer_state__upper_eq;
    reg timer_state__upper_ge;
    reg timer_state__lower_eq;
    reg timer_state__lower_ge;
    reg timer_state__comparator_exceeded;
        //   Access being performed by APB
    reg [3:0]access;

    //b Internal combinatorials
        //   Combinatorial decode of timer state and controls
    reg [32:0]timer_combs__lower_t_minus_c;
    reg [32:0]timer_combs__upper_t_minus_c;
    reg [4:0]timer_combs__fractional_sum;
    reg [32:0]timer_combs__lower_sum;
    reg [31:0]timer_combs__upper_sum;

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
        4'h3: // req 1
            begin
            apb_response__prdata__var = timer_state__timer_lower;
            end
        4'h4: // req 1
            begin
            apb_response__prdata__var = timer_state__timer_upper;
            end
        4'h7: // req 1
            begin
            apb_response__prdata__var = timer_state__comparator_lower;
            end
        4'h8: // req 1
            begin
            apb_response__prdata__var = timer_state__comparator_upper;
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
            access <= 4'h0;
        end
        else if (clk__enable)
        begin
            access <= 4'h0;
            case (apb_request__paddr[3:0]) //synopsys parallel_case
            4'h0: // req 1
                begin
                access <= (((apb_request__pwrite!=1'h0)&&!(timer_control__block_writes!=1'h0))?4'h1:4'h3);
                end
            4'h1: // req 1
                begin
                access <= (((apb_request__pwrite!=1'h0)&&!(timer_control__block_writes!=1'h0))?4'h2:4'h4);
                end
            4'h2: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?4'h5:4'h7);
                end
            4'h3: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?4'h6:4'h8);
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
                access <= 4'h0;
            end //if
        end //if
    end //always

    //b timer_logic__comb combinatorial process
        //   
        //       The @a timer value can be reset or it may count on a tick, or it
        //       may just hold its value. Furthermore, it may be writable (the
        //       RISC-V spec seems to require this, but it defeats the purpose of a
        //       global clock if there are many of these in a system that are not
        //       at the same global value).
        //   
        //       The comparison logic operates over two clock ticks. In the first
        //       clock tick the upper and lower halves are subtracted to provide
        //       'greater-or-equal' comparisons and 'equality' comparison; these
        //       bits are recorded, and in a second clock tick they are combined
        //       and a result is generated and registered.
        //   
        //       The timer update logic adds the integer and fractional increments
        //       to the timer value, with an optional carry (@a fractional_bonus)
        //       in that is generated and registered on the previous cycle. This
        //       bonus is one for @a bonus_subfraction_numer out of @a
        //       bonus_subfraction_denom.
        //   
        //       
    always @ ( * )//timer_logic__comb
    begin: timer_logic__comb_code
    reg [31:0]timer_combs__upper_sum__var;
        timer_combs__lower_t_minus_c = ({1'h0,timer_state__timer_lower}-{1'h0,timer_state__comparator_lower});
        timer_combs__upper_t_minus_c = ({1'h0,timer_state__timer_upper}-{1'h0,timer_state__comparator_upper});
        timer_combs__fractional_sum = (({1'h0,timer_state__fraction}+{1'h0,timer_control__fractional_adder})+((timer_state__fractional_bonus!=1'h0)?64'h1:64'h0));
        timer_combs__lower_sum = (({1'h0,timer_state__timer_lower}+{25'h0,timer_control__integer_adder})+((timer_combs__fractional_sum[4]!=1'h0)?64'h1:64'h0));
        timer_combs__upper_sum__var = timer_state__timer_upper;
        if ((timer_combs__lower_sum[32]!=1'h0))
        begin
            timer_combs__upper_sum__var = (timer_state__timer_upper+32'h1);
        end //if
        timer_value__irq = timer_state__comparator_exceeded;
        timer_value__value = {timer_state__timer_upper,timer_state__timer_lower};
        timer_combs__upper_sum = timer_combs__upper_sum__var;
    end //always

    //b timer_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The @a timer value can be reset or it may count on a tick, or it
        //       may just hold its value. Furthermore, it may be writable (the
        //       RISC-V spec seems to require this, but it defeats the purpose of a
        //       global clock if there are many of these in a system that are not
        //       at the same global value).
        //   
        //       The comparison logic operates over two clock ticks. In the first
        //       clock tick the upper and lower halves are subtracted to provide
        //       'greater-or-equal' comparisons and 'equality' comparison; these
        //       bits are recorded, and in a second clock tick they are combined
        //       and a result is generated and registered.
        //   
        //       The timer update logic adds the integer and fractional increments
        //       to the timer value, with an optional carry (@a fractional_bonus)
        //       in that is generated and registered on the previous cycle. This
        //       bonus is one for @a bonus_subfraction_numer out of @a
        //       bonus_subfraction_denom.
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : timer_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            timer_state__upper_ge <= 1'h0;
            timer_state__upper_eq <= 1'h0;
            timer_state__lower_ge <= 1'h0;
            timer_state__lower_eq <= 1'h0;
            timer_state__comparator_exceeded <= 1'h0;
            timer_state__bonus_subfraction_step <= 8'h0;
            timer_state__fractional_bonus <= 1'h0;
            timer_state__fraction <= 4'h0;
            timer_state__timer_lower <= 32'h0;
            timer_state__timer_upper <= 32'h0;
            timer_state__comparator_lower <= 32'h0;
            timer_state__comparator_upper <= 32'h0;
        end
        else if (clk__enable)
        begin
            timer_state__upper_ge <= !(timer_combs__upper_t_minus_c[32]!=1'h0);
            timer_state__upper_eq <= (timer_combs__upper_t_minus_c==33'h0);
            timer_state__lower_ge <= !(timer_combs__lower_t_minus_c[32]!=1'h0);
            timer_state__lower_eq <= (timer_combs__lower_t_minus_c==33'h0);
            timer_state__comparator_exceeded <= 1'h0;
            if ((timer_state__upper_eq!=1'h0))
            begin
                timer_state__comparator_exceeded <= ((timer_state__lower_ge!=1'h0)&&!(timer_state__lower_eq!=1'h0));
            end //if
            else
            
            begin
                if ((timer_state__upper_ge!=1'h0))
                begin
                    timer_state__comparator_exceeded <= 1'h1;
                end //if
            end //else
            if ((timer_control__enable_counter!=1'h0))
            begin
                if ((timer_control__bonus_subfraction_denom==8'h0))
                begin
                    timer_state__bonus_subfraction_step <= 8'h0;
                    timer_state__fractional_bonus <= 1'h0;
                end //if
                else
                
                begin
                    timer_state__bonus_subfraction_step <= (timer_state__bonus_subfraction_step+8'h1);
                    if ((timer_state__bonus_subfraction_step>=timer_control__bonus_subfraction_denom))
                    begin
                        timer_state__bonus_subfraction_step <= 8'h0;
                    end //if
                    timer_state__fractional_bonus <= 1'h0;
                    if ((timer_state__bonus_subfraction_step>timer_control__bonus_subfraction_numer))
                    begin
                        timer_state__fractional_bonus <= 1'h1;
                    end //if
                end //else
                timer_state__fraction <= timer_combs__fractional_sum[3:0];
                timer_state__timer_lower <= timer_combs__lower_sum[31:0];
                timer_state__timer_upper <= timer_combs__upper_sum;
            end //if
            if ((timer_control__reset_counter!=1'h0))
            begin
                timer_state__bonus_subfraction_step <= 8'h0;
                timer_state__fractional_bonus <= 1'h0;
                timer_state__fraction <= 4'h0;
                timer_state__timer_lower <= 32'h0;
                timer_state__timer_upper <= 32'h0;
            end //if
            if ((access==4'h1))
            begin
                timer_state__timer_lower <= apb_request__pwdata;
                timer_state__fraction <= 4'h0;
            end //if
            if ((access==4'h2))
            begin
                timer_state__timer_upper <= apb_request__pwdata;
            end //if
            if ((access==4'h5))
            begin
                timer_state__comparator_lower <= apb_request__pwdata;
            end //if
            if ((access==4'h6))
            begin
                timer_state__comparator_upper <= apb_request__pwdata;
            end //if
        end //if
    end //always

endmodule // apb_target_rv_timer
