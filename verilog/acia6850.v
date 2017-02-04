//a Note: created by CDL 1.4 - do not hand edit without recognizing it will be out of sync with the source
// Output mode 0 (VMOD=1, standard verilog=0)
// Verilog option comb reg suffix '__var'
// Verilog option include_displays 0
// Verilog option include_assertions 1
// Verilog option sv_assertions 0
// Verilog option assert delay string '<NULL>'
// Verilog option include_coverage 0
// Verilog option clock_gate_module_instance_type 'clock_gate_module'
// Verilog option clock_gate_module_instance_extra_ports ''

//a Module acia6850
module acia6850
(
    clk,

    dcd,
    rxd,
    cts,
    rx_clk,
    tx_clk,
    data_in,
    address,
    chip_select_n,
    chip_select,
    read_not_write,
    reset_n,

    rts,
    txd,
    irq_n,
    data_out
);

    //b Clocks
        //   Clock that rises when the 'enable' of the 6850 completes - but a real clock for this model
    input clk;

    //b Inputs
    input dcd;
    input rxd;
    input cts;
        //   Clock used for receive data - must be really about at most quarter the speed of clk
    input rx_clk;
        //   Clock used for transmit data - must be really about at most quarter the speed of clk
    input tx_clk;
        //   Data in (from CPU)
    input [7:0]data_in;
        //   Changes during phase 1 (phi[0] high) with address to read or write
    input address;
        //   Active low chip select
    input chip_select_n;
        //   Active high chip select
    input [1:0]chip_select;
        //   Indicates a read transaction if asserted and chip selected
    input read_not_write;
    input reset_n;

    //b Outputs
    output rts;
    output txd;
        //   Active low interrupt
    output irq_n;
        //   Read data out (to CPU)
    output [7:0]data_out;

// output components here

    //b Output combinatorials
    reg rts;
    reg txd;
        //   Active low interrupt
    reg irq_n;
        //   Read data out (to CPU)
    reg [7:0]data_out;

    //b Output nets

    //b Internal and output registers
    reg [7:0]receive_data;
    reg receive_status__data_register_full;
    reg receive_status__parity_error;
    reg receive_status__framing_error;
    reg receive_status__overrun;
    reg receive_status__overrun_pending;
    reg receive_status__dcd;
    reg receive_status__dcd_acknowledged;
    reg receive_status__cts;
    reg [2:0]rx_if_state__fsm_state;
    reg rx_if_state__last_rx_clk;
    reg rx_if_state__clk_edge_detected;
    reg [6:0]rx_if_state__divide;
    reg [1:0]rx_if_state__stop_bits_remaining;
    reg [3:0]rx_if_state__data_parity_bits_remaining;
    reg [8:0]rx_if_state__shift_register;
    reg rx_if_state__framing_error;
    reg rx_if_state__complete;
    reg [1:0]tx_if_state__fsm_state;
    reg tx_if_state__last_tx_clk;
    reg tx_if_state__clk_edge_detected;
    reg [6:0]tx_if_state__divide;
    reg [3:0]tx_if_state__bits_remaining;
    reg [9:0]transmit_shift_register;
    reg [7:0]transmit_data;
    reg transmit_if__data_register_full;
    reg transmit_if__overrun;
    reg transmit_if__dcd;
    reg transmit_if__cts;
    reg transmit_status__data_register_empty;
    reg [1:0]control__counter_divide_select;
    reg [2:0]control__word_select;
    reg [1:0]control__tx_ctl;
    reg control__rx_int_en;

    //b Internal combinatorials
    reg master_reset;
    reg receive_irq;
    reg rx_if__divide_complete;
    reg [7:0]rx_if__data;
    reg rx_if__data_odd_parity;
    reg rx_if__parity_bit;
    reg rx_if__parity_error;
    reg rx_if__last_data_bit;
    reg rx_if__last_stop_bit;
    reg [3:0]rx_if__bit_action;
    reg rx_if__ready;
    reg tx_if__divide_complete;
    reg tx_if__data_odd_parity;
    reg tx_if__last_bit;
    reg [3:0]tx_if__bits_required;
    reg [9:0]tx_if__shift_register_from_data;
    reg [3:0]tx_if__bit_action;
    reg [1:0]write_action;
    reg [1:0]read_action;
    reg rxtx__bits;
    reg rxtx__stop;
    reg [1:0]rxtx__parity;
    reg chip_selected;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b transmit_logic__comb combinatorial process
        //   
        //       Transmit bits are driven out with a clock of x1, x16 or x64.
        //       For x1, the transmit data bitstream is changed on every clock
        //       For x16, the transmit data bitstream is changed on every 16th clock
        //       For x64, the transmit data bitstream is changed on every 64th clock
        //   
        //       The state machine is:
        //       wait_for_data -> transmit_data
        //       transmit_data -> if divider ready then shift out bit -> stop if last_stop_bit
        //       last_stop_bit -> if divider ready then if data ready -> transmit data, else -> wait_for_data
        //   
        //       The data is shifted out of the shift register based on 'bit_action'
        //       The shift register is loaded on 'bit_action_load', in wait_for_data or last_stop_bit
        //       
    always @( //transmit_logic__comb
        transmit_data or
        rxtx__bits or
        rxtx__parity or
        rxtx__stop or
        control__counter_divide_select or
        tx_if_state__divide or
        tx_if_state__bits_remaining or
        tx_if_state__fsm_state or
        transmit_status__data_register_empty or
        transmit_shift_register or
        master_reset )
    begin: transmit_logic__comb_code
    reg tx_if__data_odd_parity__var;
    reg [9:0]tx_if__shift_register_from_data__var;
    reg [3:0]tx_if__bits_required__var;
    reg tx_if__divide_complete__var;
    reg [3:0]tx_if__bit_action__var;
    reg txd__var;
        tx_if__data_odd_parity__var = transmit_data[7];
        if ((rxtx__bits==1'h0))
        begin
            tx_if__data_odd_parity__var = 1'h0;
        end //if
        if ((transmit_data[0]!=1'h0))
        begin
            tx_if__data_odd_parity__var = (tx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((transmit_data[1]!=1'h0))
        begin
            tx_if__data_odd_parity__var = (tx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((transmit_data[2]!=1'h0))
        begin
            tx_if__data_odd_parity__var = (tx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((transmit_data[3]!=1'h0))
        begin
            tx_if__data_odd_parity__var = (tx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((transmit_data[4]!=1'h0))
        begin
            tx_if__data_odd_parity__var = (tx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((transmit_data[5]!=1'h0))
        begin
            tx_if__data_odd_parity__var = (tx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((transmit_data[6]!=1'h0))
        begin
            tx_if__data_odd_parity__var = (tx_if__data_odd_parity__var ^ 1'h1);
        end //if
        tx_if__shift_register_from_data__var = {{1'h1,transmit_data},1'h0};
        if (((rxtx__bits==1'h0)&&(rxtx__parity==2'h1)))
        begin
            tx_if__shift_register_from_data__var[8] = !(tx_if__data_odd_parity__var!=1'h0);
        end //if
        if (((rxtx__bits==1'h0)&&(rxtx__parity==2'h0)))
        begin
            tx_if__shift_register_from_data__var[8] = tx_if__data_odd_parity__var;
        end //if
        if (((rxtx__bits==1'h1)&&(rxtx__parity==2'h1)))
        begin
            tx_if__shift_register_from_data__var[9] = !(tx_if__data_odd_parity__var!=1'h0);
        end //if
        if (((rxtx__bits==1'h1)&&(rxtx__parity==2'h0)))
        begin
            tx_if__shift_register_from_data__var[9] = tx_if__data_odd_parity__var;
        end //if
        tx_if__bits_required__var = 4'ha;
        if (((rxtx__bits==1'h0)&&(rxtx__stop==1'h0)))
        begin
            tx_if__bits_required__var = 4'h9;
        end //if
        if (((rxtx__bits==1'h1)&&(rxtx__parity==2'h2)))
        begin
            tx_if__bits_required__var = 4'h9;
        end //if
        tx_if__divide_complete__var = 1'h0;
        case (control__counter_divide_select) //synopsys parallel_case
        2'h0: // req 1
            begin
            tx_if__divide_complete__var = 1'h1;
            end
        2'h1: // req 1
            begin
            tx_if__divide_complete__var = tx_if_state__divide[4];
            end
        2'h2: // req 1
            begin
            tx_if__divide_complete__var = tx_if_state__divide[6];
            end
        default: // req 1
            begin
            tx_if__divide_complete__var = 1'h0;
            end
        endcase
        tx_if__last_bit = (tx_if_state__bits_remaining==4'h0);
        tx_if__bit_action__var = 4'h0;
        case (tx_if_state__fsm_state) //synopsys parallel_case
        2'h0: // req 1
            begin
            tx_if__bit_action__var = 4'h0;
            if (!(transmit_status__data_register_empty!=1'h0))
            begin
                tx_if__bit_action__var = 4'h2;
            end //if
            end
        2'h1: // req 1
            begin
            if ((tx_if__divide_complete__var!=1'h0))
            begin
                tx_if__bit_action__var = 4'h3;
            end //if
            end
        2'h2: // req 1
            begin
            if ((tx_if__divide_complete__var!=1'h0))
            begin
                if (!(transmit_status__data_register_empty!=1'h0))
                begin
                    tx_if__bit_action__var = 4'h2;
                end //if
            end //if
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:acia6850:transmit_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        rts = 1'h0;
        txd__var = 1'h1;
        if ((tx_if_state__fsm_state==2'h1))
        begin
            txd__var = transmit_shift_register[0];
        end //if
        if ((master_reset!=1'h0))
        begin
            txd__var = 1'h1;
        end //if
        tx_if__data_odd_parity = tx_if__data_odd_parity__var;
        tx_if__shift_register_from_data = tx_if__shift_register_from_data__var;
        tx_if__bits_required = tx_if__bits_required__var;
        tx_if__divide_complete = tx_if__divide_complete__var;
        tx_if__bit_action = tx_if__bit_action__var;
        txd = txd__var;
    end //always

    //b transmit_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       Transmit bits are driven out with a clock of x1, x16 or x64.
        //       For x1, the transmit data bitstream is changed on every clock
        //       For x16, the transmit data bitstream is changed on every 16th clock
        //       For x64, the transmit data bitstream is changed on every 64th clock
        //   
        //       The state machine is:
        //       wait_for_data -> transmit_data
        //       transmit_data -> if divider ready then shift out bit -> stop if last_stop_bit
        //       last_stop_bit -> if divider ready then if data ready -> transmit data, else -> wait_for_data
        //   
        //       The data is shifted out of the shift register based on 'bit_action'
        //       The shift register is loaded on 'bit_action_load', in wait_for_data or last_stop_bit
        //       
    always @( posedge clk or negedge reset_n)
    begin : transmit_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            tx_if_state__divide <= 7'h0;
            tx_if_state__fsm_state <= 2'h0;
            transmit_shift_register <= 10'h0;
            tx_if_state__bits_remaining <= 4'h0;
            tx_if_state__last_tx_clk <= 1'h0;
            tx_if_state__clk_edge_detected <= 1'h0;
            transmit_if__data_register_full <= 1'h0;
            transmit_if__overrun <= 1'h0;
            transmit_if__dcd <= 1'h0;
            transmit_if__cts <= 1'h0;
        end
        else
        begin
            case (tx_if_state__fsm_state) //synopsys parallel_case
            2'h0: // req 1
                begin
                tx_if_state__divide <= 7'h0;
                if (!(transmit_status__data_register_empty!=1'h0))
                begin
                    tx_if_state__fsm_state <= 2'h1;
                end //if
                end
            2'h1: // req 1
                begin
                tx_if_state__divide <= (tx_if_state__divide+7'h1);
                if ((tx_if__divide_complete!=1'h0))
                begin
                    tx_if_state__divide <= 7'h0;
                    if ((tx_if__last_bit!=1'h0))
                    begin
                        tx_if_state__fsm_state <= 2'h2;
                    end //if
                end //if
                end
            2'h2: // req 1
                begin
                tx_if_state__divide <= (tx_if_state__divide+7'h1);
                if ((tx_if__divide_complete!=1'h0))
                begin
                    tx_if_state__divide <= 7'h0;
                    if (!(transmit_status__data_register_empty!=1'h0))
                    begin
                        tx_if_state__fsm_state <= 2'h1;
                    end //if
                end //if
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:acia6850:transmit_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            case (tx_if__bit_action) //synopsys parallel_case
            4'h0: // req 1
                begin
                transmit_shift_register <= transmit_shift_register;
                end
            4'h2: // req 1
                begin
                tx_if_state__bits_remaining <= tx_if__bits_required;
                transmit_shift_register <= tx_if__shift_register_from_data;
                end
            4'h3: // req 1
                begin
                tx_if_state__bits_remaining <= (tx_if_state__bits_remaining-4'h1);
                transmit_shift_register <= {1'h1,transmit_shift_register[9:1]};
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:acia6850:transmit_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            if (!(tx_if_state__clk_edge_detected!=1'h0))
            begin
                tx_if_state__fsm_state <= tx_if_state__fsm_state;
                tx_if_state__last_tx_clk <= tx_if_state__last_tx_clk;
                tx_if_state__clk_edge_detected <= tx_if_state__clk_edge_detected;
                tx_if_state__divide <= tx_if_state__divide;
                tx_if_state__bits_remaining <= tx_if_state__bits_remaining;
            end //if
            tx_if_state__last_tx_clk <= tx_clk;
            tx_if_state__clk_edge_detected <= ((tx_clk!=1'h0)&&!(tx_if_state__last_tx_clk!=1'h0));
            if ((master_reset!=1'h0))
            begin
                tx_if_state__fsm_state <= 2'h0;
                transmit_if__data_register_full <= 1'h0;
                transmit_if__overrun <= 1'h0;
                transmit_if__dcd <= 1'h0;
                transmit_if__cts <= 1'h0;
            end //if
        end //if
    end //always

    //b receive_logic__comb combinatorial process
        //   
        //       Receive bits are read with a clock of x1, x16 or x64.
        //       For x1, the receive data bitstream is every rxd data input value
        //       For x16, the receive data bitstream is every 16th rxd data input value after 8 successive low input values
        //       For x64, the receive data bitstream is every 64th rxd data input value after 32 successive low input values
        //   
        //       The state machine is:
        //       wait_for_start and rxd low -> wait_for_middle (if not x1) or data bit (if x1)
        //       wait_for_middle and waited long enough -> data bit
        //       data bit -> if divider ready then shift in bit, -> stop bit if last bit
        //       stop bit -> if divider ready then check stop bit (else framing error) -> wait_for_start if complete
        //       framing_error -> wait_for_start - get here if start bit does not complete, or stop bit is not 1
        //   
        //       The data is shifted in to the shift register based on 'bit_action'
        //       The shift register is ready when either 'complete' or 'framing error' is set.
        //   
        //       At the point 'complete' is set the shift register data can be made ready - checking parity as required
        //       
    always @( //receive_logic__comb
        control__counter_divide_select or
        rx_if_state__divide or
        rx_if_state__data_parity_bits_remaining or
        rx_if_state__stop_bits_remaining or
        rx_if_state__fsm_state or
        rx_if_state__shift_register or
        rxtx__parity or
        rxtx__bits or
        rx_if_state__framing_error or
        rx_if_state__complete or
        receive_status__dcd or
        receive_status__data_register_full or
        receive_status__overrun or
        control__rx_int_en )
    begin: receive_logic__comb_code
    reg rx_if__divide_complete__var;
    reg [3:0]rx_if__bit_action__var;
    reg [7:0]rx_if__data__var;
    reg rx_if__data_odd_parity__var;
    reg rx_if__parity_error__var;
    reg rx_if__ready__var;
    reg receive_irq__var;
        rx_if__divide_complete__var = 1'h0;
        case (control__counter_divide_select) //synopsys parallel_case
        2'h0: // req 1
            begin
            rx_if__divide_complete__var = 1'h1;
            end
        2'h1: // req 1
            begin
            rx_if__divide_complete__var = rx_if_state__divide[4];
            end
        2'h2: // req 1
            begin
            rx_if__divide_complete__var = rx_if_state__divide[6];
            end
        default: // req 1
            begin
            rx_if__divide_complete__var = 1'h0;
            end
        endcase
        rx_if__last_data_bit = (rx_if_state__data_parity_bits_remaining==4'h0);
        rx_if__last_stop_bit = (rx_if_state__stop_bits_remaining==2'h0);
        rx_if__bit_action__var = 4'h0;
        case (rx_if_state__fsm_state) //synopsys parallel_case
        3'h0: // req 1
            begin
            rx_if__bit_action__var = 4'h1;
            end
        3'h1: // req 1
            begin
            end
        3'h2: // req 1
            begin
            if ((rx_if__divide_complete__var!=1'h0))
            begin
                rx_if__bit_action__var = 4'h3;
                if ((rx_if__last_data_bit!=1'h0))
                begin
                    rx_if__bit_action__var = 4'h4;
                end //if
            end //if
            end
        3'h3: // req 1
            begin
            if ((rx_if__divide_complete__var!=1'h0))
            begin
                rx_if__bit_action__var = 4'h4;
                if ((rx_if__last_stop_bit!=1'h0))
                begin
                    rx_if__bit_action__var = 4'h6;
                end //if
            end //if
            end
        3'h4: // req 1
            begin
            rx_if__bit_action__var = 4'h5;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:acia6850:receive_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        rx_if__data__var = rx_if_state__shift_register[7:0];
        rx_if__parity_bit = rx_if_state__shift_register[8];
        if ((rxtx__parity==2'h2))
        begin
            rx_if__data__var = rx_if_state__shift_register[8:1];
        end //if
        if ((rxtx__bits==1'h0))
        begin
            rx_if__data__var = {1'h0,rx_if_state__shift_register[7:1]};
        end //if
        rx_if__data_odd_parity__var = 1'h0;
        if ((rx_if__data__var[0]!=1'h0))
        begin
            rx_if__data_odd_parity__var = (rx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((rx_if__data__var[1]!=1'h0))
        begin
            rx_if__data_odd_parity__var = (rx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((rx_if__data__var[2]!=1'h0))
        begin
            rx_if__data_odd_parity__var = (rx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((rx_if__data__var[3]!=1'h0))
        begin
            rx_if__data_odd_parity__var = (rx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((rx_if__data__var[4]!=1'h0))
        begin
            rx_if__data_odd_parity__var = (rx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((rx_if__data__var[5]!=1'h0))
        begin
            rx_if__data_odd_parity__var = (rx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((rx_if__data__var[6]!=1'h0))
        begin
            rx_if__data_odd_parity__var = (rx_if__data_odd_parity__var ^ 1'h1);
        end //if
        if ((rx_if__data__var[7]!=1'h0))
        begin
            rx_if__data_odd_parity__var = (rx_if__data_odd_parity__var ^ 1'h1);
        end //if
        rx_if__parity_error__var = 1'h0;
        if (((rxtx__parity==2'h0)&&(rx_if__data_odd_parity__var==rx_if__parity_bit)))
        begin
            rx_if__parity_error__var = 1'h1;
        end //if
        if (((rxtx__parity==2'h1)&&(rx_if__data_odd_parity__var!=rx_if__parity_bit)))
        begin
            rx_if__parity_error__var = 1'h1;
        end //if
        rx_if__ready__var = 1'h0;
        if ((rx_if_state__framing_error!=1'h0))
        begin
            rx_if__ready__var = 1'h1;
        end //if
        if ((rx_if_state__complete!=1'h0))
        begin
            rx_if__ready__var = 1'h1;
        end //if
        receive_irq__var = (((receive_status__dcd!=1'h0)||(receive_status__data_register_full!=1'h0))||(receive_status__overrun!=1'h0));
        if (!(control__rx_int_en!=1'h0))
        begin
            receive_irq__var = 1'h0;
        end //if
        rx_if__divide_complete = rx_if__divide_complete__var;
        rx_if__bit_action = rx_if__bit_action__var;
        rx_if__data = rx_if__data__var;
        rx_if__data_odd_parity = rx_if__data_odd_parity__var;
        rx_if__parity_error = rx_if__parity_error__var;
        rx_if__ready = rx_if__ready__var;
        receive_irq = receive_irq__var;
    end //always

    //b receive_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       Receive bits are read with a clock of x1, x16 or x64.
        //       For x1, the receive data bitstream is every rxd data input value
        //       For x16, the receive data bitstream is every 16th rxd data input value after 8 successive low input values
        //       For x64, the receive data bitstream is every 64th rxd data input value after 32 successive low input values
        //   
        //       The state machine is:
        //       wait_for_start and rxd low -> wait_for_middle (if not x1) or data bit (if x1)
        //       wait_for_middle and waited long enough -> data bit
        //       data bit -> if divider ready then shift in bit, -> stop bit if last bit
        //       stop bit -> if divider ready then check stop bit (else framing error) -> wait_for_start if complete
        //       framing_error -> wait_for_start - get here if start bit does not complete, or stop bit is not 1
        //   
        //       The data is shifted in to the shift register based on 'bit_action'
        //       The shift register is ready when either 'complete' or 'framing error' is set.
        //   
        //       At the point 'complete' is set the shift register data can be made ready - checking parity as required
        //       
    always @( posedge clk or negedge reset_n)
    begin : receive_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            rx_if_state__divide <= 7'h0;
            rx_if_state__fsm_state <= 3'h0;
            rx_if_state__shift_register <= 9'h0;
            rx_if_state__data_parity_bits_remaining <= 4'h0;
            rx_if_state__stop_bits_remaining <= 2'h0;
            rx_if_state__framing_error <= 1'h0;
            rx_if_state__complete <= 1'h0;
            rx_if_state__last_rx_clk <= 1'h0;
            rx_if_state__clk_edge_detected <= 1'h0;
            receive_status__data_register_full <= 1'h0;
            receive_status__parity_error <= 1'h0;
            receive_status__framing_error <= 1'h0;
            receive_status__overrun <= 1'h0;
            receive_status__overrun_pending <= 1'h0;
            receive_status__dcd <= 1'h0;
            receive_status__dcd_acknowledged <= 1'h0;
            receive_status__cts <= 1'h0;
            receive_data <= 8'h0;
        end
        else
        begin
            case (rx_if_state__fsm_state) //synopsys parallel_case
            3'h0: // req 1
                begin
                rx_if_state__divide <= 7'h0;
                rx_if_state__fsm_state <= 3'h1;
                if ((rx_if__divide_complete!=1'h0))
                begin
                    rx_if_state__fsm_state <= 3'h2;
                end //if
                if ((rxd!=1'h0))
                begin
                    rx_if_state__fsm_state <= 3'h0;
                end //if
                end
            3'h1: // req 1
                begin
                rx_if_state__divide <= (rx_if_state__divide+7'h2);
                if ((rx_if__divide_complete!=1'h0))
                begin
                    rx_if_state__divide <= 7'h0;
                    rx_if_state__fsm_state <= 3'h2;
                end //if
                if ((rxd!=1'h0))
                begin
                    rx_if_state__fsm_state <= 3'h4;
                end //if
                end
            3'h2: // req 1
                begin
                rx_if_state__divide <= (rx_if_state__divide+7'h1);
                if ((rx_if__divide_complete!=1'h0))
                begin
                    rx_if_state__divide <= 7'h0;
                    if ((rx_if__last_data_bit!=1'h0))
                    begin
                        rx_if_state__fsm_state <= 3'h3;
                    end //if
                end //if
                end
            3'h3: // req 1
                begin
                rx_if_state__divide <= (rx_if_state__divide+7'h1);
                if ((rx_if__divide_complete!=1'h0))
                begin
                    rx_if_state__divide <= 7'h0;
                    if ((rx_if__last_stop_bit!=1'h0))
                    begin
                        rx_if_state__fsm_state <= 3'h0;
                    end //if
                end //if
                if (!(rxd!=1'h0))
                begin
                    rx_if_state__fsm_state <= 3'h4;
                end //if
                end
            3'h4: // req 1
                begin
                rx_if_state__fsm_state <= 3'h0;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:acia6850:receive_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            case (rx_if__bit_action) //synopsys parallel_case
            4'h1: // req 1
                begin
                rx_if_state__shift_register <= 9'h0;
                rx_if_state__data_parity_bits_remaining <= 4'h0;
                rx_if_state__stop_bits_remaining <= 2'h0;
                end
            4'h3: // req 1
                begin
                rx_if_state__shift_register <= {rxd,rx_if_state__shift_register[8:1]};
                rx_if_state__data_parity_bits_remaining <= (rx_if_state__data_parity_bits_remaining-4'h1);
                end
            4'h4: // req 1
                begin
                rx_if_state__stop_bits_remaining <= (rx_if_state__stop_bits_remaining-2'h1);
                end
            4'h5: // req 1
                begin
                rx_if_state__framing_error <= 1'h1;
                end
            4'h6: // req 1
                begin
                rx_if_state__complete <= 1'h1;
                end
            4'h0: // req 1
                begin
                rx_if_state__shift_register <= rx_if_state__shift_register;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:acia6850:receive_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            if (!(rx_if_state__clk_edge_detected!=1'h0))
            begin
                rx_if_state__fsm_state <= rx_if_state__fsm_state;
                rx_if_state__last_rx_clk <= rx_if_state__last_rx_clk;
                rx_if_state__clk_edge_detected <= rx_if_state__clk_edge_detected;
                rx_if_state__divide <= rx_if_state__divide;
                rx_if_state__stop_bits_remaining <= rx_if_state__stop_bits_remaining;
                rx_if_state__data_parity_bits_remaining <= rx_if_state__data_parity_bits_remaining;
                rx_if_state__shift_register <= rx_if_state__shift_register;
                rx_if_state__framing_error <= rx_if_state__framing_error;
                rx_if_state__complete <= rx_if_state__complete;
                rx_if_state__complete <= 1'h0;
                rx_if_state__framing_error <= 1'h0;
            end //if
            rx_if_state__last_rx_clk <= rx_clk;
            rx_if_state__clk_edge_detected <= ((rx_clk!=1'h0)&&!(rx_if_state__last_rx_clk!=1'h0));
            receive_status__data_register_full <= receive_status__data_register_full;
            receive_status__parity_error <= receive_status__parity_error;
            receive_status__framing_error <= receive_status__framing_error;
            receive_status__overrun <= receive_status__overrun;
            receive_status__overrun_pending <= receive_status__overrun_pending;
            receive_status__dcd <= receive_status__dcd;
            receive_status__dcd_acknowledged <= receive_status__dcd_acknowledged;
            receive_status__cts <= receive_status__cts;
            if ((read_action==2'h1))
            begin
                receive_status__data_register_full <= 1'h0;
                receive_status__overrun <= 1'h0;
            end //if
            receive_status__cts <= cts;
            receive_status__dcd <= dcd;
            if ((rx_if_state__framing_error!=1'h0))
            begin
                receive_status__framing_error <= 1'h1;
            end //if
            if ((rx_if_state__complete!=1'h0))
            begin
                if (!(receive_status__data_register_full!=1'h0))
                begin
                    receive_status__data_register_full <= 1'h1;
                    receive_status__overrun <= receive_status__overrun_pending;
                    receive_status__parity_error <= rx_if__parity_error;
                    receive_data <= rx_if__data;
                    receive_status__overrun_pending <= 1'h0;
                end //if
                else
                
                begin
                    receive_status__overrun_pending <= 1'h1;
                end //else
            end //if
            if ((master_reset!=1'h0))
            begin
                rx_if_state__fsm_state <= 3'h0;
                receive_status__data_register_full <= 1'h0;
                receive_status__parity_error <= 1'h0;
                receive_status__framing_error <= 1'h0;
                receive_status__overrun <= 1'h0;
                receive_status__overrun_pending <= 1'h0;
                receive_status__dcd <= 1'h0;
                receive_status__dcd_acknowledged <= 1'h0;
                receive_status__cts <= 1'h0;
            end //if
        end //if
    end //always

    //b control_register_logic__comb combinatorial process
        //   
        //       The control register is write-only on the bus
        //   
        //       It contains the counter divide register, data bits / stop bits / parity configuration,
        //       rts control and transmit interrupt generation, and receive interrupt enable.
        //       
    always @( //control_register_logic__comb
        control__word_select or
        control__counter_divide_select or
        receive_irq )
    begin: control_register_logic__comb_code
    reg rxtx__bits__var;
    reg rxtx__stop__var;
    reg [1:0]rxtx__parity__var;
    reg irq_n__var;
        rxtx__bits__var = 1'h0;
        rxtx__stop__var = 1'h1;
        rxtx__parity__var = 2'h1;
        case (control__word_select) //synopsys parallel_case
        3'h0: // req 1
            begin
            rxtx__bits__var = 1'h0;
            rxtx__stop__var = 1'h1;
            rxtx__parity__var = 2'h1;
            end
        3'h1: // req 1
            begin
            rxtx__bits__var = 1'h0;
            rxtx__stop__var = 1'h1;
            rxtx__parity__var = 2'h0;
            end
        3'h2: // req 1
            begin
            rxtx__bits__var = 1'h0;
            rxtx__stop__var = 1'h0;
            rxtx__parity__var = 2'h1;
            end
        3'h3: // req 1
            begin
            rxtx__bits__var = 1'h0;
            rxtx__stop__var = 1'h0;
            rxtx__parity__var = 2'h0;
            end
        3'h4: // req 1
            begin
            rxtx__bits__var = 1'h1;
            rxtx__stop__var = 1'h1;
            rxtx__parity__var = 2'h2;
            end
        3'h5: // req 1
            begin
            rxtx__bits__var = 1'h1;
            rxtx__stop__var = 1'h0;
            rxtx__parity__var = 2'h2;
            end
        3'h6: // req 1
            begin
            rxtx__bits__var = 1'h1;
            rxtx__stop__var = 1'h0;
            rxtx__parity__var = 2'h1;
            end
        3'h7: // req 1
            begin
            rxtx__bits__var = 1'h1;
            rxtx__stop__var = 1'h0;
            rxtx__parity__var = 2'h0;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:acia6850:control_register_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        master_reset = (control__counter_divide_select==2'h3);
        irq_n__var = 1'h1;
        if ((receive_irq!=1'h0))
        begin
            irq_n__var = 1'h0;
        end //if
        rxtx__bits = rxtx__bits__var;
        rxtx__stop = rxtx__stop__var;
        rxtx__parity = rxtx__parity__var;
        irq_n = irq_n__var;
    end //always

    //b control_register_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The control register is write-only on the bus
        //   
        //       It contains the counter divide register, data bits / stop bits / parity configuration,
        //       rts control and transmit interrupt generation, and receive interrupt enable.
        //       
    always @( posedge clk or negedge reset_n)
    begin : control_register_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            control__counter_divide_select <= 2'h0;
            control__word_select <= 3'h0;
            control__tx_ctl <= 2'h0;
            control__rx_int_en <= 1'h0;
        end
        else
        begin
            if ((write_action==2'h2))
            begin
                control__counter_divide_select <= data_in[1:0];
                control__word_select <= data_in[4:2];
                control__tx_ctl <= data_in[6:5];
                control__rx_int_en <= data_in[7];
            end //if
        end //if
    end //always

    //b read_write_interface__comb combinatorial process
    always @( //read_write_interface__comb
        chip_select_n or
        chip_select or
        address or
        receive_irq or
        receive_status__parity_error or
        receive_status__overrun or
        receive_status__framing_error or
        receive_status__cts or
        receive_status__dcd or
        transmit_status__data_register_empty or
        receive_status__data_register_full or
        receive_data or
        read_not_write )
    begin: read_write_interface__comb_code
    reg [7:0]data_out__var;
    reg [1:0]read_action__var;
    reg [1:0]write_action__var;
        chip_selected = (!(chip_select_n!=1'h0)&&(chip_select==2'h3));
        data_out__var = 8'hff;
        read_action__var = 2'h0;
        write_action__var = 2'h0;
        if ((chip_selected!=1'h0))
        begin
            case (address) //synopsys parallel_case
            1'h0: // req 1
                begin
                data_out__var = {{{{{{{receive_irq,receive_status__parity_error},receive_status__overrun},receive_status__framing_error},receive_status__cts},receive_status__dcd},transmit_status__data_register_empty},receive_status__data_register_full};
                read_action__var = 2'h2;
                write_action__var = 2'h2;
                end
            1'h1: // req 1
                begin
                data_out__var = receive_data;
                read_action__var = 2'h1;
                write_action__var = 2'h1;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:acia6850:read_write_interface: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
        if (!(read_not_write!=1'h0))
        begin
            data_out__var = 8'hff;
            read_action__var = 2'h0;
        end //if
        else
        
        begin
            write_action__var = 2'h0;
        end //else
        data_out = data_out__var;
        read_action = read_action__var;
        write_action = write_action__var;
    end //always

    //b read_write_interface__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : read_write_interface__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            transmit_status__data_register_empty <= 1'h0;
            transmit_data <= 8'h0;
        end
        else
        begin
            if ((tx_if__bit_action==4'h2))
            begin
                transmit_status__data_register_empty <= 1'h1;
            end //if
            if ((write_action==2'h1))
            begin
                transmit_status__data_register_empty <= 1'h0;
                transmit_data <= data_in;
            end //if
        end //if
    end //always

endmodule // acia6850
