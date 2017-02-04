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

//a Module via6522
module via6522
(
    clk_io,
    clk,

    pb_in,
    cb2_in,
    cb1,
    pa_in,
    ca2_in,
    ca1,
    data_in,
    address,
    chip_select_n,
    chip_select,
    read_not_write,
    reset_n,

    pb_out,
    cb2_out,
    pa_out,
    ca2_out,
    irq_n,
    data_out
);

    //b Clocks
        //   1MHz clock rising when I/O should be captured - can be antiphase to clk
    input clk_io;
        //   1MHz clock rising when bus cycle finishes
    input clk;

    //b Inputs
        //   Port b data in
    input [7:0]pb_in;
        //   Port b control 2 in
    input cb2_in;
        //   Port b control 1 in
    input cb1;
        //   Port a data in
    input [7:0]pa_in;
        //   Port a control 2 in
    input ca2_in;
        //   Port a control 1 in
    input ca1;
        //   Data in (from CPU)
    input [7:0]data_in;
        //   Changes during phase 1 (phi[0] high) with address to read or write
    input [3:0]address;
        //   Active low chip select
    input chip_select_n;
        //   Active high chip select
    input chip_select;
        //   Indicates a read transaction if asserted and chip selected
    input read_not_write;
    input reset_n;

    //b Outputs
        //   Port b data out
    output [7:0]pb_out;
        //   Port b control 2 out
    output cb2_out;
        //   Port a data out
    output [7:0]pa_out;
        //   Port a control 2 out
    output ca2_out;
        //   Active low interrupt
    output irq_n;
        //   Read data out (to CPU)
    output [7:0]data_out;

// output components here

    //b Output combinatorials
        //   Port b data out
    reg [7:0]pb_out;
        //   Port b control 2 out
    reg cb2_out;
        //   Port a data out
    reg [7:0]pa_out;
        //   Port a control 2 out
    reg ca2_out;
        //   Active low interrupt
    reg irq_n;
        //   Read data out (to CPU)
    reg [7:0]data_out;

    //b Output nets

    //b Internal and output registers
    reg [7:0]shift_register;
    reg pb6_last_value;
    reg port_b__last_c1;
    reg port_b__last_c2;
    reg port_b__c2_out;
    reg [7:0]port_b__ddr;
    reg [7:0]port_b__outr;
    reg [7:0]port_b_inr;
    reg [7:0]port_a_inr;
    reg port_a__last_c1;
    reg port_a__last_c2;
    reg port_a__c2_out;
    reg [7:0]port_a__ddr;
    reg [7:0]port_a__outr;
    reg [7:0]timer2__latch__low;
    reg [7:0]timer2__latch__high;
    reg [7:0]timer2__counter__low;
    reg [7:0]timer2__counter__high;
    reg timer2__has_expired;
    reg [7:0]timer1__latch__low;
    reg [7:0]timer1__latch__high;
    reg [7:0]timer1__counter__low;
    reg [7:0]timer1__counter__high;
    reg timer1__has_expired;
    reg acr__pa_latch;
    reg acr__pb_latch;
    reg acr__timer_pb7;
    reg acr__timer_continuous;
    reg acr__timer_count_pulses;
    reg pcr__ca1_control;
    reg [2:0]pcr__ca2_control;
    reg pcr__cb1_control;
    reg [2:0]pcr__cb2_control;
    reg ifr__ca1;
    reg ifr__ca2;
    reg ifr__cb1;
    reg ifr__cb2;
    reg ifr__timer1;
    reg ifr__timer2;
    reg ifr__sr;
    reg ifr__irq;
    reg ier__ca1;
    reg ier__ca2;
    reg ier__cb1;
    reg ier__cb2;
    reg ier__timer1;
    reg ier__timer2;
    reg ier__sr;
    reg ier__irq;

    //b Internal combinatorials
    reg pb6_negedge;
    reg [3:0]write_action;
    reg [2:0]read_action;
    reg port_b_edges__c1;
    reg port_b_edges__c2;
    reg port_a_edges__c1;
    reg port_a_edges__c2;
    reg timer2_expired;
    reg timer1_expired;
    reg next_ifr__ca1;
    reg next_ifr__ca2;
    reg next_ifr__cb1;
    reg next_ifr__cb2;
    reg next_ifr__timer1;
    reg next_ifr__timer2;
    reg next_ifr__sr;
    reg next_ifr__irq;
    reg next_ier__ca1;
    reg next_ier__ca2;
    reg next_ier__cb1;
    reg next_ier__cb2;
    reg next_ier__timer1;
    reg next_ier__timer2;
    reg next_ier__sr;
    reg next_ier__irq;
    reg chip_selected;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b port_controls__comb combinatorial process
        //   
        //       Port control logic.
        //   
        //       control 2 output may be undriven (if the control pin is in one of the 4 'input' modes), or it may be tied high or low.
        //       Alternatively it may be in 'pulse' mode or 'handshake' mode
        //       In pulse mode it goes low for a single cycle when inr is read (port A only)
        //       In pulse mode it goes low for a single cycle when outr is written (port A only)
        //       Handshake goes low when inr is read (port A only), and pops high when the control 1 active edge occurs
        //       Handshake goes low when outr is written (ports A and B only), and pops high when the control 1 active edge occurs
        //       POSSIBLY: The handshakes and pulse changes are on 'rising phi2' as opposed to the general operation which is on 'falling phi2'
        //       BUT: seems not to be true for read handshake, and specsheet waveforms are dodgy for write handshake...
        //       
    always @( //port_controls__comb
        pcr__ca1_control or
        ca1 or
        port_a__last_c1 or
        pcr__ca2_control or
        ca2_in or
        port_a__last_c2 or
        pcr__cb1_control or
        cb1 or
        port_b__last_c1 or
        pcr__cb2_control or
        cb2_in or
        port_b__last_c2 or
        port_a__c2_out or
        port_b__c2_out )
    begin: port_controls__comb_code
    reg port_a_edges__c1__var;
    reg port_a_edges__c2__var;
    reg port_b_edges__c1__var;
    reg port_b_edges__c2__var;
    reg ca2_out__var;
    reg cb2_out__var;
        port_a_edges__c1__var = 1'h0;
        port_a_edges__c2__var = 1'h0;
        if ((pcr__ca1_control==1'h1))
        begin
            port_a_edges__c1__var = (!(ca1!=1'h0) & port_a__last_c1);
        end //if
        else
        
        begin
            port_a_edges__c1__var = (ca1 & !(port_a__last_c1!=1'h0));
        end //else
        case (pcr__ca2_control) //synopsys parallel_case
        3'h0: // req 1
            begin
            port_a_edges__c2__var = (!(ca2_in!=1'h0) & port_a__last_c2);
            end
        3'h1: // req 1
            begin
            port_a_edges__c2__var = (!(ca2_in!=1'h0) & port_a__last_c2);
            end
        3'h2: // req 1
            begin
            port_a_edges__c2__var = (ca2_in & !(port_a__last_c2!=1'h0));
            end
        3'h3: // req 1
            begin
            port_a_edges__c2__var = (ca2_in & !(port_a__last_c2!=1'h0));
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
        port_b_edges__c1__var = 1'h0;
        port_b_edges__c2__var = 1'h0;
        if ((pcr__cb1_control==1'h1))
        begin
            port_b_edges__c1__var = (!(cb1!=1'h0) & port_b__last_c1);
        end //if
        else
        
        begin
            port_b_edges__c1__var = (cb1 & !(port_b__last_c1!=1'h0));
        end //else
        case (pcr__cb2_control) //synopsys parallel_case
        3'h0: // req 1
            begin
            port_b_edges__c2__var = (!(cb2_in!=1'h0) & port_b__last_c2);
            end
        3'h1: // req 1
            begin
            port_b_edges__c2__var = (!(cb2_in!=1'h0) & port_b__last_c2);
            end
        3'h2: // req 1
            begin
            port_b_edges__c2__var = (cb2_in & !(port_b__last_c2!=1'h0));
            end
        3'h3: // req 1
            begin
            port_b_edges__c2__var = (cb2_in & !(port_b__last_c2!=1'h0));
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
        ca2_out__var = 1'h1;
        case (pcr__ca2_control) //synopsys parallel_case
        3'h4: // req 1
            begin
            ca2_out__var = port_a__c2_out;
            end
        3'h5: // req 1
            begin
            ca2_out__var = port_a__c2_out;
            end
        3'h7: // req 1
            begin
            ca2_out__var = port_a__c2_out;
            end
        3'h6: // req 1
            begin
            ca2_out__var = port_a__c2_out;
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
        cb2_out__var = 1'h1;
        case (pcr__cb2_control) //synopsys parallel_case
        3'h4: // req 1
            begin
            cb2_out__var = port_b__c2_out;
            end
        3'h5: // req 1
            begin
            cb2_out__var = port_b__c2_out;
            end
        3'h7: // req 1
            begin
            cb2_out__var = port_b__c2_out;
            end
        3'h6: // req 1
            begin
            cb2_out__var = port_b__c2_out;
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
        port_a_edges__c1 = port_a_edges__c1__var;
        port_a_edges__c2 = port_a_edges__c2__var;
        port_b_edges__c1 = port_b_edges__c1__var;
        port_b_edges__c2 = port_b_edges__c2__var;
        ca2_out = ca2_out__var;
        cb2_out = cb2_out__var;
    end //always

    //b port_controls__posedge_clk_active_low_reset_n clock process
        //   
        //       Port control logic.
        //   
        //       control 2 output may be undriven (if the control pin is in one of the 4 'input' modes), or it may be tied high or low.
        //       Alternatively it may be in 'pulse' mode or 'handshake' mode
        //       In pulse mode it goes low for a single cycle when inr is read (port A only)
        //       In pulse mode it goes low for a single cycle when outr is written (port A only)
        //       Handshake goes low when inr is read (port A only), and pops high when the control 1 active edge occurs
        //       Handshake goes low when outr is written (ports A and B only), and pops high when the control 1 active edge occurs
        //       POSSIBLY: The handshakes and pulse changes are on 'rising phi2' as opposed to the general operation which is on 'falling phi2'
        //       BUT: seems not to be true for read handshake, and specsheet waveforms are dodgy for write handshake...
        //       
    always @( posedge clk or negedge reset_n)
    begin : port_controls__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            port_a__last_c1 <= 1'h0;
            port_b__last_c1 <= 1'h0;
            port_a__last_c2 <= 1'h0;
            port_b__last_c2 <= 1'h0;
            port_a__c2_out <= 1'h0;
            port_b__c2_out <= 1'h0;
        end
        else
        begin
            port_a__last_c1 <= ca1;
            port_b__last_c1 <= cb1;
            port_a__last_c2 <= ca2_in;
            port_b__last_c2 <= cb2_in;
            case (pcr__ca2_control) //synopsys parallel_case
            3'h7: // req 1
                begin
                port_a__c2_out <= 1'h0;
                end
            3'h6: // req 1
                begin
                port_a__c2_out <= 1'h1;
                end
            3'h4: // req 1
                begin
                if ((port_a_edges__c1!=1'h0))
                begin
                    port_a__c2_out <= 1'h1;
                end //if
                if ((read_action==3'h1))
                begin
                    port_a__c2_out <= 1'h0;
                end //if
                if ((write_action==4'h1))
                begin
                    port_a__c2_out <= 1'h0;
                end //if
                end
            3'h5: // req 1
                begin
                port_a__c2_out <= 1'h1;
                if ((read_action==3'h1))
                begin
                    port_a__c2_out <= 1'h0;
                end //if
                if ((write_action==4'h1))
                begin
                    port_a__c2_out <= 1'h0;
                end //if
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
            case (pcr__cb2_control) //synopsys parallel_case
            3'h7: // req 1
                begin
                port_b__c2_out <= 1'h0;
                end
            3'h6: // req 1
                begin
                port_b__c2_out <= 1'h1;
                end
            3'h4: // req 1
                begin
                if ((port_b_edges__c1!=1'h0))
                begin
                    port_b__c2_out <= 1'h1;
                end //if
                if ((write_action==4'h2))
                begin
                    port_b__c2_out <= 1'h0;
                end //if
                end
            3'h5: // req 1
                begin
                port_b__c2_out <= 1'h1;
                if ((write_action==4'h2))
                begin
                    port_b__c2_out <= 1'h0;
                end //if
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
        end //if
    end //always

    //b port_data_logic__comb combinatorial process
        //   
        //       Port data logic.
        //   
        //       Port A latches the input pins on the 'active edge of CA1' or it presents a synchronized version of the pins.
        //   
        //       Port B latches the input pin signals for non-outputs, and the output data for outputs, on the 'active edge of CB1' or it presents a synchronized version of the pins.
        //   
        //       The original 6522 does not synchronize the inputs pins, but it is cleaner for simulation and modern design to do so.
        //       Because of this it might be that switching to 'active edge' on a real 6522 would present the last 'active edge' data, whereas this design will present the last cycle data.
        //       
    always @( //port_data_logic__comb
        port_a__ddr or
        port_a__outr or
        port_b__ddr or
        port_b__outr or
        pb6_last_value or
        port_b_inr )
    begin: port_data_logic__comb_code
    reg [7:0]pa_out__var;
    reg [7:0]pb_out__var;
        pa_out__var = ~port_a__ddr;
        pa_out__var = pa_out__var | (port_a__ddr & port_a__outr);
        pb_out__var = ~port_b__ddr;
        pb_out__var = pb_out__var | (port_b__ddr & port_b__outr);
        pb6_negedge = ((pb6_last_value!=1'h0)&&!(port_b_inr[6]!=1'h0));
        pa_out = pa_out__var;
        pb_out = pb_out__var;
    end //always

    //b port_data_logic__posedge_clk_io_active_low_reset_n clock process
        //   
        //       Port data logic.
        //   
        //       Port A latches the input pins on the 'active edge of CA1' or it presents a synchronized version of the pins.
        //   
        //       Port B latches the input pin signals for non-outputs, and the output data for outputs, on the 'active edge of CB1' or it presents a synchronized version of the pins.
        //   
        //       The original 6522 does not synchronize the inputs pins, but it is cleaner for simulation and modern design to do so.
        //       Because of this it might be that switching to 'active edge' on a real 6522 would present the last 'active edge' data, whereas this design will present the last cycle data.
        //       
    always @( posedge clk_io or negedge reset_n)
    begin : port_data_logic__posedge_clk_io_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            port_a_inr <= 8'h0;
            port_b_inr <= 8'h0;
        end
        else
        begin
            if (((port_a_edges__c1!=1'h0)||!(acr__pa_latch!=1'h0)))
            begin
                port_a_inr <= pa_in;
            end //if
            if (((port_b_edges__c1!=1'h0)||!(acr__pb_latch!=1'h0)))
            begin
                port_b_inr <= ((pb_in | port_b__ddr) & ~(port_b__ddr & port_b__outr));
            end //if
        end //if
    end //always

    //b port_data_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       Port data logic.
        //   
        //       Port A latches the input pins on the 'active edge of CA1' or it presents a synchronized version of the pins.
        //   
        //       Port B latches the input pin signals for non-outputs, and the output data for outputs, on the 'active edge of CB1' or it presents a synchronized version of the pins.
        //   
        //       The original 6522 does not synchronize the inputs pins, but it is cleaner for simulation and modern design to do so.
        //       Because of this it might be that switching to 'active edge' on a real 6522 would present the last 'active edge' data, whereas this design will present the last cycle data.
        //       
    always @( posedge clk or negedge reset_n)
    begin : port_data_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            port_a__outr <= 8'h0;
            port_a__ddr <= 8'h0;
            port_b__outr <= 8'h0;
            port_b__ddr <= 8'h0;
            pb6_last_value <= 1'h0;
        end
        else
        begin
            if (((write_action==4'h3)||(write_action==4'h1)))
            begin
                port_a__outr <= data_in;
            end //if
            if ((write_action==4'h4))
            begin
                port_a__ddr <= data_in;
            end //if
            if ((write_action==4'h2))
            begin
                port_b__outr <= data_in;
            end //if
            if ((write_action==4'h5))
            begin
                port_b__ddr <= data_in;
            end //if
            if (((port_b__ddr[7]!=1'h0)&&(acr__timer_pb7!=1'h0)))
            begin
                if ((timer1_expired!=1'h0))
                begin
                    port_b__outr[7] <= 1'h1;
                    if ((acr__timer_continuous!=1'h0))
                    begin
                        port_b__outr[7] <= ~port_b__outr[7];
                    end //if
                end //if
                if ((write_action==4'h8))
                begin
                    port_b__outr[7] <= 1'h0;
                end //if
            end //if
            pb6_last_value <= port_b_inr[6];
        end //if
    end //always

    //b timer_logic__comb combinatorial process
        //   
        //       Timers.
        //   
        //       The timers can be configured to be one-shot or free-running.
        //       The timers clock on every phi2 clock, except for timer 2 when it is in 'pb6 counting mode', where it clockes on negative edges of pb6
        //       Timer 1 can be made to toggle pb7 when it expires; pb7 is also cleared to low each time the counter is written (in this mode)
        //       This means that timer 1 expiring can be used to generate a width-controlled pulse on pb7.
        //   
        //       Each timer has a 16-bit down-counter that expires when it is at zero.
        //       In one-shot mode the timer can only expire once; the 'has_expired' signal has to be reset with a write to the timer counter.
        //   
        //       In continuous mode the timer never 'has expired'.
        //   
        //       The timers all generate interrupts when they expire (reach zero) and have not previously expired.
        //       
        //       
    always @( //timer_logic__comb
        timer1__counter__low or
        timer1__counter__high or
        timer1__has_expired or
        acr__timer_count_pulses or
        pb6_negedge or
        timer2__counter__low or
        timer2__counter__high or
        timer2__has_expired )
    begin: timer_logic__comb_code
    reg timer1_expired__var;
    reg timer2_expired__var;
        timer1_expired__var = 1'h0;
        if (((timer1__counter__low==8'h0)&&(timer1__counter__high==8'h0)))
        begin
            timer1_expired__var = !(timer1__has_expired!=1'h0);
        end //if
        timer2_expired__var = 1'h0;
        if ((!(acr__timer_count_pulses!=1'h0)||(pb6_negedge!=1'h0)))
        begin
            if (((timer2__counter__low==8'h0)&&(timer2__counter__high==8'h0)))
            begin
                timer2_expired__var = !(timer2__has_expired!=1'h0);
            end //if
        end //if
        timer1_expired = timer1_expired__var;
        timer2_expired = timer2_expired__var;
    end //always

    //b timer_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       Timers.
        //   
        //       The timers can be configured to be one-shot or free-running.
        //       The timers clock on every phi2 clock, except for timer 2 when it is in 'pb6 counting mode', where it clockes on negative edges of pb6
        //       Timer 1 can be made to toggle pb7 when it expires; pb7 is also cleared to low each time the counter is written (in this mode)
        //       This means that timer 1 expiring can be used to generate a width-controlled pulse on pb7.
        //   
        //       Each timer has a 16-bit down-counter that expires when it is at zero.
        //       In one-shot mode the timer can only expire once; the 'has_expired' signal has to be reset with a write to the timer counter.
        //   
        //       In continuous mode the timer never 'has expired'.
        //   
        //       The timers all generate interrupts when they expire (reach zero) and have not previously expired.
        //       
        //       
    always @( posedge clk or negedge reset_n)
    begin : timer_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            timer1__counter__low <= 8'hffffffffffffffff;
            timer1__counter__high <= 8'hffffffffffffffff;
            timer1__has_expired <= 1'hffffffffffffffff;
            timer1__latch__low <= 8'hffffffffffffffff;
            timer1__latch__high <= 8'hffffffffffffffff;
            timer1__latch__high <= 8'hfe;
            timer2__counter__low <= 8'h0;
            timer2__counter__high <= 8'h0;
            timer2__has_expired <= 1'h0;
            timer2__latch__low <= 8'h0;
            timer2__latch__high <= 8'h0;
        end
        else
        begin
            timer1__counter__low <= (timer1__counter__low-8'h1);
            timer1__counter__high <= (timer1__counter__high-((timer1__counter__low==8'h0)?64'h1:64'h0));
            if (((timer1__counter__low==8'hff)&&(timer1__counter__high==8'hff)))
            begin
                timer1__counter__low <= timer1__latch__low;
                timer1__counter__high <= timer1__latch__high;
            end //if
            if (((timer1__counter__low==8'h0)&&(timer1__counter__high==8'h0)))
            begin
                timer1__has_expired <= 1'h1;
                if ((acr__timer_continuous!=1'h0))
                begin
                    timer1__has_expired <= 1'h0;
                end //if
            end //if
            if ((write_action==4'h6))
            begin
                timer1__latch__low <= data_in;
            end //if
            if ((write_action==4'h7))
            begin
                timer1__latch__high <= data_in;
            end //if
            if ((write_action==4'h8))
            begin
                timer1__counter__low <= timer1__latch__low;
                timer1__counter__high <= data_in;
                timer1__has_expired <= 1'h0;
            end //if
            if ((!(acr__timer_count_pulses!=1'h0)||(pb6_negedge!=1'h0)))
            begin
                timer2__counter__low <= (timer2__counter__low-8'h1);
                timer2__counter__high <= (timer2__counter__high-((timer2__counter__low==8'h0)?64'h1:64'h0));
                if (((timer2__counter__low==8'h0)&&(timer2__counter__high==8'h0)))
                begin
                    timer2__has_expired <= 1'h1;
                end //if
            end //if
            if ((write_action==4'h9))
            begin
                timer2__latch__low <= data_in;
            end //if
            if ((write_action==4'ha))
            begin
                timer2__counter__low <= timer2__latch__low;
                timer2__counter__high <= data_in;
                timer2__has_expired <= 1'h0;
            end //if
            timer2__latch__high <= 8'h0;
        end //if
    end //always

    //b interrupt_logic__comb combinatorial process
        //   
        //       The interrupt enable register has bits set by a write to IER with data[7] set,
        //       in which case the respective bits of data[0..6] set the ier bits.
        //   
        //       The interrupt enable register has bits cleared by a write to IER with data[7] clear,
        //       in which case the respective bits of data[0..6] clear the ier bits.
        //   
        //       The interrupt flag register can have bits cleared by writing to the IFR, with 
        //       the respective bits of data[0..6] set forcing a clear.
        //   
        //       Port control lines can have their interrupts cleared by handshake reads and writes.
        //   
        //       Timers can be cleared by reading, or by writing the counter to start the timer.
        //       
    always @( //interrupt_logic__comb
        ier__ca1 or
        write_action or
        data_in or
        ier__ca2 or
        ier__cb1 or
        ier__cb2 or
        ier__timer1 or
        ier__timer2 or
        ier__sr or
        ier__irq or
        ifr__ca1 or
        read_action or
        port_a_edges__c1 or
        ifr__ca2 or
        pcr__ca2_control or
        port_a_edges__c2 or
        ifr__cb1 or
        port_b_edges__c1 or
        ifr__cb2 or
        pcr__cb2_control or
        port_b_edges__c2 or
        ifr__timer1 or
        timer1_expired or
        ifr__timer2 or
        timer2_expired or
        ifr__sr or
        ifr__irq )
    begin: interrupt_logic__comb_code
    reg next_ier__ca1__var;
    reg next_ier__ca2__var;
    reg next_ier__cb1__var;
    reg next_ier__cb2__var;
    reg next_ier__timer1__var;
    reg next_ier__timer2__var;
    reg next_ier__sr__var;
    reg next_ier__irq__var;
    reg next_ifr__ca1__var;
    reg next_ifr__ca2__var;
    reg next_ifr__cb1__var;
    reg next_ifr__cb2__var;
    reg next_ifr__timer1__var;
    reg next_ifr__timer2__var;
    reg next_ifr__sr__var;
    reg next_ifr__irq__var;
        next_ier__ca1__var = ier__ca1;
        next_ier__ca2__var = ier__ca2;
        next_ier__cb1__var = ier__cb1;
        next_ier__cb2__var = ier__cb2;
        next_ier__timer1__var = ier__timer1;
        next_ier__timer2__var = ier__timer2;
        next_ier__sr__var = ier__sr;
        next_ier__irq__var = ier__irq;
        next_ier__irq__var = 1'h1;
        if ((write_action==4'hb))
        begin
            if ((data_in[0]!=1'h0))
            begin
                next_ier__ca2__var = data_in[7];
            end //if
            if ((data_in[1]!=1'h0))
            begin
                next_ier__ca1__var = data_in[7];
            end //if
            if ((data_in[2]!=1'h0))
            begin
                next_ier__sr__var = data_in[7];
            end //if
            if ((data_in[3]!=1'h0))
            begin
                next_ier__cb2__var = data_in[7];
            end //if
            if ((data_in[4]!=1'h0))
            begin
                next_ier__cb1__var = data_in[7];
            end //if
            if ((data_in[5]!=1'h0))
            begin
                next_ier__timer2__var = data_in[7];
            end //if
            if ((data_in[6]!=1'h0))
            begin
                next_ier__timer1__var = data_in[7];
            end //if
        end //if
        next_ifr__ca1__var = ifr__ca1;
        next_ifr__ca2__var = ifr__ca2;
        next_ifr__cb1__var = ifr__cb1;
        next_ifr__cb2__var = ifr__cb2;
        next_ifr__timer1__var = ifr__timer1;
        next_ifr__timer2__var = ifr__timer2;
        next_ifr__sr__var = ifr__sr;
        next_ifr__irq__var = ifr__irq;
        if (((read_action==3'h1)||(write_action==4'h1)))
        begin
            next_ifr__ca1__var = 1'h0;
            case (pcr__ca2_control) //synopsys parallel_case
            3'h2: // req 1
                begin
                next_ifr__ca2__var = 1'h0;
                end
            3'h0: // req 1
                begin
                next_ifr__ca2__var = 1'h0;
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
        end //if
        if (((read_action==3'h2)||(write_action==4'h2)))
        begin
            next_ifr__cb1__var = 1'h0;
            case (pcr__cb2_control) //synopsys parallel_case
            3'h2: // req 1
                begin
                next_ifr__cb2__var = 1'h0;
                end
            3'h0: // req 1
                begin
                next_ifr__cb2__var = 1'h0;
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
        end //if
        if (((write_action==4'h8)||(read_action==3'h3)))
        begin
            next_ifr__timer1__var = 1'h0;
        end //if
        if (((write_action==4'ha)||(read_action==3'h4)))
        begin
            next_ifr__timer2__var = 1'h0;
        end //if
        if ((write_action==4'hc))
        begin
            if ((data_in[0]!=1'h0))
            begin
                next_ifr__ca2__var = 1'h0;
            end //if
            if ((data_in[1]!=1'h0))
            begin
                next_ifr__ca1__var = 1'h0;
            end //if
            if ((data_in[2]!=1'h0))
            begin
                next_ifr__sr__var = 1'h0;
            end //if
            if ((data_in[3]!=1'h0))
            begin
                next_ifr__cb2__var = 1'h0;
            end //if
            if ((data_in[4]!=1'h0))
            begin
                next_ifr__cb1__var = 1'h0;
            end //if
            if ((data_in[5]!=1'h0))
            begin
                next_ifr__timer2__var = 1'h0;
            end //if
            if ((data_in[6]!=1'h0))
            begin
                next_ifr__timer1__var = 1'h0;
            end //if
        end //if
        if ((port_a_edges__c1!=1'h0))
        begin
            next_ifr__ca1__var = 1'h1;
        end //if
        if ((port_a_edges__c2!=1'h0))
        begin
            next_ifr__ca2__var = 1'h1;
        end //if
        if ((port_b_edges__c1!=1'h0))
        begin
            next_ifr__cb1__var = 1'h1;
        end //if
        if ((port_b_edges__c2!=1'h0))
        begin
            next_ifr__cb2__var = 1'h1;
        end //if
        if ((timer1_expired!=1'h0))
        begin
            next_ifr__timer1__var = 1'h1;
        end //if
        if ((timer2_expired!=1'h0))
        begin
            next_ifr__timer2__var = 1'h1;
        end //if
        next_ifr__irq__var = 1'h0;
        if (((((((((next_ifr__ca1__var & next_ier__ca1__var)!=1'h0)||((next_ifr__ca2__var & next_ier__ca2__var)!=1'h0))||((next_ifr__cb1__var & next_ier__cb1__var)!=1'h0))||((next_ifr__cb2__var & next_ier__cb2__var)!=1'h0))||((next_ifr__timer1__var & next_ier__timer1__var)!=1'h0))||((next_ifr__timer2__var & next_ier__timer2__var)!=1'h0))||((next_ifr__sr__var & next_ier__sr__var)!=1'h0)))
        begin
            next_ifr__irq__var = 1'h1;
        end //if
        irq_n = !(ifr__irq!=1'h0);
        next_ier__ca1 = next_ier__ca1__var;
        next_ier__ca2 = next_ier__ca2__var;
        next_ier__cb1 = next_ier__cb1__var;
        next_ier__cb2 = next_ier__cb2__var;
        next_ier__timer1 = next_ier__timer1__var;
        next_ier__timer2 = next_ier__timer2__var;
        next_ier__sr = next_ier__sr__var;
        next_ier__irq = next_ier__irq__var;
        next_ifr__ca1 = next_ifr__ca1__var;
        next_ifr__ca2 = next_ifr__ca2__var;
        next_ifr__cb1 = next_ifr__cb1__var;
        next_ifr__cb2 = next_ifr__cb2__var;
        next_ifr__timer1 = next_ifr__timer1__var;
        next_ifr__timer2 = next_ifr__timer2__var;
        next_ifr__sr = next_ifr__sr__var;
        next_ifr__irq = next_ifr__irq__var;
    end //always

    //b interrupt_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The interrupt enable register has bits set by a write to IER with data[7] set,
        //       in which case the respective bits of data[0..6] set the ier bits.
        //   
        //       The interrupt enable register has bits cleared by a write to IER with data[7] clear,
        //       in which case the respective bits of data[0..6] clear the ier bits.
        //   
        //       The interrupt flag register can have bits cleared by writing to the IFR, with 
        //       the respective bits of data[0..6] set forcing a clear.
        //   
        //       Port control lines can have their interrupts cleared by handshake reads and writes.
        //   
        //       Timers can be cleared by reading, or by writing the counter to start the timer.
        //       
    always @( posedge clk or negedge reset_n)
    begin : interrupt_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            ifr__ca1 <= 1'h0;
            ifr__ca2 <= 1'h0;
            ifr__cb1 <= 1'h0;
            ifr__cb2 <= 1'h0;
            ifr__timer1 <= 1'h0;
            ifr__timer2 <= 1'h0;
            ifr__sr <= 1'h0;
            ifr__irq <= 1'h0;
            ier__ca1 <= 1'h0;
            ier__ca2 <= 1'h0;
            ier__cb1 <= 1'h0;
            ier__cb2 <= 1'h0;
            ier__timer1 <= 1'h0;
            ier__timer2 <= 1'h0;
            ier__sr <= 1'h0;
            ier__irq <= 1'h0;
        end
        else
        begin
            ifr__ca1 <= next_ifr__ca1;
            ifr__ca2 <= next_ifr__ca2;
            ifr__cb1 <= next_ifr__cb1;
            ifr__cb2 <= next_ifr__cb2;
            ifr__timer1 <= next_ifr__timer1;
            ifr__timer2 <= next_ifr__timer2;
            ifr__sr <= next_ifr__sr;
            ifr__irq <= next_ifr__irq;
            ier__ca1 <= next_ier__ca1;
            ier__ca2 <= next_ier__ca2;
            ier__cb1 <= next_ier__cb1;
            ier__cb2 <= next_ier__cb2;
            ier__timer1 <= next_ier__timer1;
            ier__timer2 <= next_ier__timer2;
            ier__sr <= next_ier__sr;
            ier__irq <= next_ier__irq;
        end //if
    end //always

    //b control_register_logic clock process
        //   Control registers
    always @( posedge clk or negedge reset_n)
    begin : control_register_logic__code
        if (reset_n==1'b0)
        begin
            shift_register <= 8'h0;
            pcr__cb2_control <= 3'h0;
            pcr__cb1_control <= 1'h0;
            pcr__ca2_control <= 3'h0;
            pcr__ca1_control <= 1'h0;
            acr__timer_pb7 <= 1'h0;
            acr__timer_continuous <= 1'h0;
            acr__timer_count_pulses <= 1'h0;
            acr__pb_latch <= 1'h0;
            acr__pa_latch <= 1'h0;
        end
        else
        begin
            shift_register <= 8'h0;
            if ((write_action==4'he))
            begin
                pcr__cb2_control <= data_in[7:5];
                pcr__cb1_control <= data_in[4];
                pcr__ca2_control <= data_in[3:1];
                pcr__ca1_control <= data_in[0];
            end //if
            if ((write_action==4'hf))
            begin
                acr__timer_pb7 <= data_in[7];
                acr__timer_continuous <= data_in[6];
                acr__timer_count_pulses <= data_in[5];
                acr__pb_latch <= data_in[1];
                acr__pa_latch <= data_in[0];
            end //if
        end //if
    end //always

    //b read_write_interface combinatorial process
    always @( //read_write_interface
        chip_select_n or
        chip_select or
        address or
        port_a_inr or
        port_b_inr or
        port_a__ddr or
        port_b__ddr or
        timer1__counter__low or
        timer1__counter__high or
        timer1__latch__low or
        timer1__latch__high or
        timer2__counter__low or
        timer2__counter__high or
        shift_register or
        acr__timer_pb7 or
        acr__timer_continuous or
        acr__timer_count_pulses or
        acr__pb_latch or
        acr__pa_latch or
        pcr__cb2_control or
        pcr__cb1_control or
        pcr__ca2_control or
        pcr__ca1_control or
        ifr__irq or
        ifr__timer1 or
        ifr__timer2 or
        ifr__cb1 or
        ifr__cb2 or
        ifr__sr or
        ifr__ca1 or
        ifr__ca2 or
        ier__irq or
        ier__timer1 or
        ier__timer2 or
        ier__cb1 or
        ier__cb2 or
        ier__sr or
        ier__ca1 or
        ier__ca2 or
        read_not_write )
    begin: read_write_interface__comb_code
    reg [7:0]data_out__var;
    reg [2:0]read_action__var;
    reg [3:0]write_action__var;
        chip_selected = (!(chip_select_n!=1'h0)&&(chip_select!=1'h0));
        data_out__var = 8'hff;
        read_action__var = 3'h0;
        write_action__var = 4'h0;
        if ((chip_selected!=1'h0))
        begin
            case (address) //synopsys parallel_case
            4'h1: // req 1
                begin
                data_out__var = port_a_inr;
                read_action__var = 3'h1;
                write_action__var = 4'h1;
                end
            4'h0: // req 1
                begin
                data_out__var = port_b_inr;
                read_action__var = 3'h2;
                write_action__var = 4'h2;
                end
            4'h3: // req 1
                begin
                data_out__var = port_a__ddr;
                write_action__var = 4'h4;
                end
            4'h2: // req 1
                begin
                data_out__var = port_b__ddr;
                write_action__var = 4'h5;
                end
            4'h4: // req 1
                begin
                data_out__var = timer1__counter__low;
                read_action__var = 3'h3;
                write_action__var = 4'h6;
                end
            4'h5: // req 1
                begin
                data_out__var = timer1__counter__high;
                write_action__var = 4'h8;
                end
            4'h6: // req 1
                begin
                data_out__var = timer1__latch__low;
                write_action__var = 4'h6;
                end
            4'h7: // req 1
                begin
                data_out__var = timer1__latch__high;
                write_action__var = 4'h7;
                end
            4'h8: // req 1
                begin
                data_out__var = timer2__counter__low;
                read_action__var = 3'h4;
                write_action__var = 4'h9;
                end
            4'h9: // req 1
                begin
                data_out__var = timer2__counter__high;
                write_action__var = 4'ha;
                end
            4'ha: // req 1
                begin
                data_out__var = shift_register;
                write_action__var = 4'hd;
                end
            4'hb: // req 1
                begin
                data_out__var = {{{{{acr__timer_pb7,acr__timer_continuous},acr__timer_count_pulses},3'h0},acr__pb_latch},acr__pa_latch};
                write_action__var = 4'hf;
                end
            4'hc: // req 1
                begin
                data_out__var = {{{pcr__cb2_control,pcr__cb1_control},pcr__ca2_control},pcr__ca1_control};
                write_action__var = 4'he;
                end
            4'hd: // req 1
                begin
                data_out__var = {{{{{{{ifr__irq,ifr__timer1},ifr__timer2},ifr__cb1},ifr__cb2},ifr__sr},ifr__ca1},ifr__ca2};
                write_action__var = 4'hc;
                end
            4'he: // req 1
                begin
                data_out__var = {{{{{{{ier__irq,ier__timer1},ier__timer2},ier__cb1},ier__cb2},ier__sr},ier__ca1},ier__ca2};
                write_action__var = 4'hb;
                end
            4'hf: // req 1
                begin
                data_out__var = port_a_inr;
                write_action__var = 4'h3;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:via6522:read_write_interface: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
        if (!(read_not_write!=1'h0))
        begin
            data_out__var = 8'hff;
            read_action__var = 3'h0;
        end //if
        else
        
        begin
            write_action__var = 4'h0;
        end //else
        data_out = data_out__var;
        read_action = read_action__var;
        write_action = write_action__var;
    end //always

endmodule // via6522
