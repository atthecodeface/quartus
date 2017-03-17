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

//a Module ps2_host
    //   
    //   As a PS2 host, to receive data from the slave (the first target for the design), the module:
    //   
    //   1. Looks for clock falling
    //   2. If data is low, then assume this is a start bit. Set timeout timer.
    //   3. Wait for clock falling. Clock in data bit 0
    //   4. Wait for clock falling. Clock in data bit 1
    //   5. Wait for clock falling. Clock in data bit 2
    //   6. Wait for clock falling. Clock in data bit 3
    //   7. Wait for clock falling. Clock in data bit 4
    //   8. Wait for clock falling. Clock in data bit 5
    //   9. Wait for clock falling. Clock in data bit 6
    //   10. Wait for clock falling. Clock in data bit 7
    //   11. Wait for clock falling. Clock in parity bit.
    //   12. Wait for clock falling. Clock in stop bit.
    //   13. Wait for clock high.
    //   14. Validate data (stop bit 1, parity correct)
    //   
    //   If a timeout timer expires, which could happen if the framing is bad, then an abort can be taken.
    //   
module ps2_host
(
    clk,
    clk__enable,

    divider,
    ps2_in__data,
    ps2_in__clk,
    reset_n,

    ps2_rx_data__valid,
    ps2_rx_data__data,
    ps2_rx_data__parity_error,
    ps2_rx_data__protocol_error,
    ps2_rx_data__timeout,
    ps2_out__data,
    ps2_out__clk
);

    //b Clocks
        //   Clock
    input clk;
    input clk__enable;
    wire slow_clk; // Gated version of clock 'clk' enabled by 'clk_enable'
    wire slow_clk__enable;

    //b Inputs
        //   Clock divider input to generate approx 3us from @p clk
    input [15:0]divider;
        //   Pin values from the outside
    input ps2_in__data;
    input ps2_in__clk;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   PS2 receive data from the device, in parallel
    output ps2_rx_data__valid;
    output [7:0]ps2_rx_data__data;
    output ps2_rx_data__parity_error;
    output ps2_rx_data__protocol_error;
    output ps2_rx_data__timeout;
        //   Pin values to drive - 1 means float high, 0 means pull low
    output ps2_out__data;
    output ps2_out__clk;

// output components here

    //b Output combinatorials
        //   PS2 receive data from the device, in parallel
    reg ps2_rx_data__valid;
    reg [7:0]ps2_rx_data__data;
    reg ps2_rx_data__parity_error;
    reg ps2_rx_data__protocol_error;
    reg ps2_rx_data__timeout;
        //   Pin values to drive - 1 means float high, 0 means pull low
    reg ps2_out__data;
    reg ps2_out__clk;

    //b Output nets

    //b Internal and output registers
        //   State of the PS2 decoder
    reg [2:0]receive_state__fsm_state;
    reg [11:0]receive_state__timeout;
    reg [3:0]receive_state__bits_left;
    reg [9:0]receive_state__shift_register;
    reg receive_state__result__valid;
    reg receive_state__result__protocol_error;
    reg receive_state__result__parity_error;
    reg receive_state__result__timeout;
        //   PS2 input state logic
    reg ps2_input_state__data;
    reg ps2_input_state__last_data;
    reg ps2_input_state__clk;
    reg ps2_input_state__last_clk;
        //   High speed clock state - just the clock divider
    reg [15:0]clock_state__counter;

    //b Internal combinatorials
        //   Combinatorial decode of PS2 decoder and state
    reg receive_combs__parity_error;
    reg [3:0]receive_combs__action;
        //   PS2 combinatorials; clock falling, rising
    reg ps2_input_combs__rising_clk;
    reg ps2_input_combs__falling_clk;
        //   High speed clock combinatorials - clock gate for slow logic
    reg clock_combs__clk_enable;
    reg clk_enable;

    //b Internal nets

    //b Clock gating module instances
    assign slow_clk__enable = (clk__enable && clk_enable);
    //b Module instances
    //b clock_divider_logic__comb combinatorial process
        //   
        //       Simple clock divider resetting to the 'divider' input.  This
        //       should generate a clock enable every 3us or so; hence for a 50MHz
        //       clock, the @p divider should be set to roughly 150.
        //       
    always @ ( * )//clock_divider_logic__comb
    begin: clock_divider_logic__comb_code
    reg clock_combs__clk_enable__var;
        clock_combs__clk_enable__var = 1'h0;
        if ((clock_state__counter==16'h0))
        begin
            clock_combs__clk_enable__var = 1'h1;
        end //if
        clk_enable = clock_combs__clk_enable__var;
        clock_combs__clk_enable = clock_combs__clk_enable__var;
    end //always

    //b clock_divider_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       Simple clock divider resetting to the 'divider' input.  This
        //       should generate a clock enable every 3us or so; hence for a 50MHz
        //       clock, the @p divider should be set to roughly 150.
        //       
    always @( posedge clk or negedge reset_n)
    begin : clock_divider_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            clock_state__counter <= 16'h0;
        end
        else if (clk__enable)
        begin
            clock_state__counter <= (clock_state__counter-16'h1);
            if ((clock_state__counter==16'h0))
            begin
                clock_state__counter <= divider;
            end //if
        end //if
    end //always

    //b pin_logic__comb combinatorial process
        //   
        //       Capture the pin inputs, and determine if the clock is falling or rising.
        //   
        //       The PS2 outputs are not required (as yet) - keyboard work without it
        //       
    always @ ( * )//pin_logic__comb
    begin: pin_logic__comb_code
        ps2_input_combs__falling_clk = (!(ps2_input_state__clk!=1'h0) & ps2_input_state__last_clk);
        ps2_input_combs__rising_clk = (ps2_input_state__clk & !(ps2_input_state__last_clk!=1'h0));
        ps2_out__data = 1'h1;
        ps2_out__clk = 1'h1;
    end //always

    //b pin_logic__posedge_slow_clk_active_low_reset_n clock process
        //   
        //       Capture the pin inputs, and determine if the clock is falling or rising.
        //   
        //       The PS2 outputs are not required (as yet) - keyboard work without it
        //       
    always @( posedge clk or negedge reset_n)
    begin : pin_logic__posedge_slow_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            ps2_input_state__data <= 1'h0;
            ps2_input_state__clk <= 1'h0;
            ps2_input_state__last_data <= 1'h0;
            ps2_input_state__last_clk <= 1'h0;
        end
        else if (slow_clk__enable)
        begin
            ps2_input_state__data <= ps2_in__data;
            ps2_input_state__clk <= ps2_in__clk;
            ps2_input_state__last_data <= ps2_input_state__data;
            ps2_input_state__last_clk <= ps2_input_state__clk;
        end //if
    end //always

    //b receive_logic__comb combinatorial process
        //   
        //       Determine the parity of the shift register, and parity error - if
        //       the parity is invalid odd parity.
        //   
        //       The receiver action depends on the FSM state, and the PS2 input
        //       (clock rising/falling, data high/low).  The PS2 stream starts with
        //       a start bit - data low with clock falling. Data is then on
        //       successive clock falling pulses, until the shift register is full
        //       (i.e. 10 bits are shifted in). This should then include eight data
        //       bits, a parity bit, and a high stop bit. Hence the receive action
        //       will be start, clock rising in bit, clock falling to capture data,
        //       and clock rising at end of last bit; these, plus possibilities for
        //       protocol error and timeout error.
        //   
        //       Depending on the action, update the state machine, timeout, shift_register and bits_left
        //       
    always @ ( * )//receive_logic__comb
    begin: receive_logic__comb_code
    reg receive_combs__parity_error__var;
    reg [3:0]receive_combs__action__var;
        receive_combs__parity_error__var = 1'h1;
        if ((receive_state__shift_register[0]!=1'h0))
        begin
            receive_combs__parity_error__var = !(receive_combs__parity_error__var!=1'h0);
        end //if
        if ((receive_state__shift_register[1]!=1'h0))
        begin
            receive_combs__parity_error__var = !(receive_combs__parity_error__var!=1'h0);
        end //if
        if ((receive_state__shift_register[2]!=1'h0))
        begin
            receive_combs__parity_error__var = !(receive_combs__parity_error__var!=1'h0);
        end //if
        if ((receive_state__shift_register[3]!=1'h0))
        begin
            receive_combs__parity_error__var = !(receive_combs__parity_error__var!=1'h0);
        end //if
        if ((receive_state__shift_register[4]!=1'h0))
        begin
            receive_combs__parity_error__var = !(receive_combs__parity_error__var!=1'h0);
        end //if
        if ((receive_state__shift_register[5]!=1'h0))
        begin
            receive_combs__parity_error__var = !(receive_combs__parity_error__var!=1'h0);
        end //if
        if ((receive_state__shift_register[6]!=1'h0))
        begin
            receive_combs__parity_error__var = !(receive_combs__parity_error__var!=1'h0);
        end //if
        if ((receive_state__shift_register[7]!=1'h0))
        begin
            receive_combs__parity_error__var = !(receive_combs__parity_error__var!=1'h0);
        end //if
        if ((receive_state__shift_register[8]!=1'h0))
        begin
            receive_combs__parity_error__var = !(receive_combs__parity_error__var!=1'h0);
        end //if
        receive_combs__action__var = 4'h0;
        case (receive_state__fsm_state) //synopsys parallel_case
        3'h0: // req 1
            begin
            if ((ps2_input_combs__falling_clk!=1'h0))
            begin
                receive_combs__action__var = 4'h1;
                if ((ps2_input_state__data!=1'h0))
                begin
                    receive_combs__action__var = 4'h7;
                end //if
            end //if
            end
        3'h1: // req 1
            begin
            if ((ps2_input_combs__rising_clk!=1'h0))
            begin
                receive_combs__action__var = 4'h3;
                if ((receive_state__bits_left==4'h0))
                begin
                    receive_combs__action__var = 4'h2;
                    if (!(ps2_input_state__data!=1'h0))
                    begin
                        receive_combs__action__var = 4'h7;
                    end //if
                end //if
            end //if
            end
        3'h2: // req 1
            begin
            if ((ps2_input_combs__falling_clk!=1'h0))
            begin
                receive_combs__action__var = 4'h4;
            end //if
            end
        3'h4: // req 1
            begin
            receive_combs__action__var = 4'h5;
            end
        3'h3: // req 1
            begin
            receive_combs__action__var = 4'h6;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:ps2_host:receive_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        if ((receive_state__timeout==12'h1))
        begin
            receive_combs__action__var = 4'h8;
        end //if
        ps2_rx_data__valid = (receive_state__result__valid & clock_combs__clk_enable);
        ps2_rx_data__data = receive_state__shift_register[7:0];
        ps2_rx_data__parity_error = receive_state__result__parity_error;
        ps2_rx_data__protocol_error = receive_state__result__protocol_error;
        ps2_rx_data__timeout = receive_state__result__timeout;
        receive_combs__parity_error = receive_combs__parity_error__var;
        receive_combs__action = receive_combs__action__var;
    end //always

    //b receive_logic__posedge_slow_clk_active_low_reset_n clock process
        //   
        //       Determine the parity of the shift register, and parity error - if
        //       the parity is invalid odd parity.
        //   
        //       The receiver action depends on the FSM state, and the PS2 input
        //       (clock rising/falling, data high/low).  The PS2 stream starts with
        //       a start bit - data low with clock falling. Data is then on
        //       successive clock falling pulses, until the shift register is full
        //       (i.e. 10 bits are shifted in). This should then include eight data
        //       bits, a parity bit, and a high stop bit. Hence the receive action
        //       will be start, clock rising in bit, clock falling to capture data,
        //       and clock rising at end of last bit; these, plus possibilities for
        //       protocol error and timeout error.
        //   
        //       Depending on the action, update the state machine, timeout, shift_register and bits_left
        //       
    always @( posedge clk or negedge reset_n)
    begin : receive_logic__posedge_slow_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            receive_state__timeout <= 12'h0;
            receive_state__bits_left <= 4'h0;
            receive_state__fsm_state <= 3'h0;
            receive_state__shift_register <= 10'h0;
            receive_state__result__valid <= 1'h0;
            receive_state__result__protocol_error <= 1'h0;
            receive_state__result__parity_error <= 1'h0;
            receive_state__result__timeout <= 1'h0;
        end
        else if (slow_clk__enable)
        begin
            if ((receive_state__timeout>12'h0))
            begin
                receive_state__timeout <= (receive_state__timeout-12'h1);
            end //if
            if ((receive_state__fsm_state==3'h0))
            begin
                receive_state__timeout <= 12'h0;
            end //if
            case (receive_combs__action) //synopsys parallel_case
            4'h1: // req 1
                begin
                receive_state__timeout <= 12'h3e8;
                receive_state__bits_left <= 4'ha;
                receive_state__fsm_state <= 3'h1;
                end
            4'h3: // req 1
                begin
                receive_state__fsm_state <= 3'h2;
                end
            4'h4: // req 1
                begin
                receive_state__shift_register <= {ps2_input_state__data,receive_state__shift_register[9:1]};
                receive_state__bits_left <= (receive_state__bits_left-4'h1);
                receive_state__fsm_state <= 3'h1;
                end
            4'h2: // req 1
                begin
                receive_state__fsm_state <= 3'h0;
                end
            4'h7: // req 1
                begin
                receive_state__fsm_state <= 3'h3;
                end
            4'h8: // req 1
                begin
                receive_state__fsm_state <= 3'h4;
                end
            4'h6: // req 1
                begin
                receive_state__fsm_state <= 3'h0;
                end
            4'h5: // req 1
                begin
                receive_state__fsm_state <= 3'h0;
                end
            4'h0: // req 1
                begin
                receive_state__fsm_state <= receive_state__fsm_state;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:ps2_host:receive_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            receive_state__result__valid <= 1'h0;
            if ((receive_combs__action==4'h6))
            begin
                receive_state__result__valid <= 1'h0;
                receive_state__result__protocol_error <= 1'h0;
                receive_state__result__parity_error <= 1'h0;
                receive_state__result__timeout <= 1'h0;
                receive_state__result__valid <= 1'h1;
                receive_state__result__protocol_error <= 1'h1;
            end //if
            if ((receive_combs__action==4'h5))
            begin
                receive_state__result__valid <= 1'h0;
                receive_state__result__protocol_error <= 1'h0;
                receive_state__result__parity_error <= 1'h0;
                receive_state__result__timeout <= 1'h0;
                receive_state__result__valid <= 1'h1;
                receive_state__result__timeout <= 1'h1;
            end //if
            if ((receive_combs__action==4'h2))
            begin
                receive_state__result__valid <= 1'h0;
                receive_state__result__protocol_error <= 1'h0;
                receive_state__result__parity_error <= 1'h0;
                receive_state__result__timeout <= 1'h0;
                receive_state__result__valid <= 1'h1;
                receive_state__result__parity_error <= receive_combs__parity_error;
            end //if
        end //if
    end //always

endmodule // ps2_host
