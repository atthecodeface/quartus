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

//a Module apb_target_timer
    //   
    //   Simple timer with an APB interface.
    //   This is a monotonically increasing 31-bit timer with three 31-bit comparators.
    //   
    //   The timers are read/written through the APB interface with timer 0 at
    //   address 0, timer 1 at address 1, and so on. When a timer is written it
    //   writes the 31-bit @a comparator value and it clears the @a timer's @a
    //   equalled bit. When a timer is read it returns the @a comparator value
    //   (in bits [31;0]), and it returns the @a equalled status in bit [31] -
    //   while atomically clearing it.
    //   
    //   
module apb_target_timer
(
    clk,
    clk__enable,

    apb_request__paddr,
    apb_request__penable,
    apb_request__psel,
    apb_request__pwrite,
    apb_request__pwdata,
    reset_n,

    timer_equalled,
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
        //   Active low reset
    input reset_n;

    //b Outputs
        //   One output bit per timer, mirroring the three timer's @a equalled state
    output [2:0]timer_equalled;
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
        //   Three comparators with @a equalled status
    reg [30:0]timers__comparator[2:0];
    reg [2:0]timers__equalled;
        //   Timer counter value, autoincrementing
    reg [30:0]timer_value;
        //   Access being performed by APB
    reg [2:0]access;
    reg [2:0]timer_equalled;

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
        3'h3: // req 1
            begin
            apb_response__prdata__var = {1'h0,timer_value};
            end
        3'h2: // req 1
            begin
            if ((apb_request__paddr[1:0]==2'h0))
            begin
                apb_response__prdata__var = {timers__equalled[0],timers__comparator[0]};
            end //if
            if ((apb_request__paddr[1:0]==2'h1))
            begin
                apb_response__prdata__var = {timers__equalled[1],timers__comparator[1]};
            end //if
            if ((apb_request__paddr[1:0]==2'h2))
            begin
                apb_response__prdata__var = {timers__equalled[2],timers__comparator[2]};
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
            case (apb_request__paddr[3:0]) //synopsys parallel_case
            4'h0: // req 1
                begin
                access <= 3'h3;
                end
            4'h4: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h1:3'h2);
                end
            4'h5: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h1:3'h2);
                end
            4'h6: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h1:3'h2);
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

    //b timer_logic clock process
        //   
        //       The @a timer_value is incremented on every clock tick.  The three
        //       @a timers are compared with the @a timer_value, and if they are
        //       equal they the @a timers' @a equalled bit is set. Id the
        //       comparator is being read, then the @a equalled bit is cleared -
        //       with lower priority than the comparison. Finally, the @a timers
        //       can be written with a @a comparator value, which clears the @a
        //       equalled bit.
        //       
    always @( posedge clk or negedge reset_n)
    begin : timer_logic__code
        if (reset_n==1'b0)
        begin
            timer_value <= 31'h0;
            timer_equalled <= 3'h0;
            timers__equalled[0] <= 1'h0; // Should this be a bit vector?
            timers__equalled[1] <= 1'h0; // Should this be a bit vector?
            timers__equalled[2] <= 1'h0; // Should this be a bit vector?
            timers__comparator[0] <= 31'h0;
            timers__comparator[1] <= 31'h0;
            timers__comparator[2] <= 31'h0;
        end
        else if (clk__enable)
        begin
            timer_value <= (timer_value+31'h1);
            timer_equalled <= 3'h0;
            if (((access==3'h2)&&(apb_request__paddr[1:0]==2'h0)))
            begin
                timers__equalled[0] <= 1'h0;
            end //if
            if ((timers__comparator[0]==timer_value))
            begin
                timers__equalled[0] <= 1'h1;
            end //if
            if (((access==3'h1)&&(apb_request__paddr[1:0]==2'h0)))
            begin
                timers__equalled[0] <= 1'h0;
                timers__comparator[0] <= apb_request__pwdata[30:0];
            end //if
            timer_equalled[0] <= timers__equalled[0];
            if (((access==3'h2)&&(apb_request__paddr[1:0]==2'h1)))
            begin
                timers__equalled[1] <= 1'h0;
            end //if
            if ((timers__comparator[1]==timer_value))
            begin
                timers__equalled[1] <= 1'h1;
            end //if
            if (((access==3'h1)&&(apb_request__paddr[1:0]==2'h1)))
            begin
                timers__equalled[1] <= 1'h0;
                timers__comparator[1] <= apb_request__pwdata[30:0];
            end //if
            timer_equalled[1] <= timers__equalled[1];
            if (((access==3'h2)&&(apb_request__paddr[1:0]==2'h2)))
            begin
                timers__equalled[2] <= 1'h0;
            end //if
            if ((timers__comparator[2]==timer_value))
            begin
                timers__equalled[2] <= 1'h1;
            end //if
            if (((access==3'h1)&&(apb_request__paddr[1:0]==2'h2)))
            begin
                timers__equalled[2] <= 1'h0;
                timers__comparator[2] <= apb_request__pwdata[30:0];
            end //if
            timer_equalled[2] <= timers__equalled[2];
        end //if
    end //always

endmodule // apb_target_timer
