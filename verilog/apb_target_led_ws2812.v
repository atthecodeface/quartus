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

//a Module apb_target_led_ws2812
    //   
    //   
    //   
module apb_target_led_ws2812
(
    clk,
    clk__enable,

    divider_400ns_in,
    apb_request__paddr,
    apb_request__penable,
    apb_request__psel,
    apb_request__pwrite,
    apb_request__pwdata,
    reset_n,

    led_chain,
    apb_response__prdata,
    apb_response__pready,
    apb_response__perr
);

    //b Clocks
        //   System clock
    input clk;
    input clk__enable;

    //b Inputs
        //   Default value for divider_400ns
    input [7:0]divider_400ns_in;
        //   APB request
    input [31:0]apb_request__paddr;
    input apb_request__penable;
    input apb_request__psel;
    input apb_request__pwrite;
    input [31:0]apb_request__pwdata;
        //   Active low reset
    input reset_n;

    //b Outputs
    output led_chain;
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
    wire led_chain;

    //b Internal and output registers
    reg [7:0]leds__red[15:0];
    reg [7:0]leds__green[15:0];
    reg [7:0]leds__blue[15:0];
    reg [7:0]chain_state__divider_400ns;
    reg [3:0]chain_state__last_led;
        //   Access being performed by APB
    reg [2:0]access;

    //b Internal combinatorials
    reg led_data__valid;
    reg led_data__last;
    reg [7:0]led_data__red;
    reg [7:0]led_data__green;
    reg [7:0]led_data__blue;

    //b Internal nets
    wire led_request__ready;
    wire led_request__first;
    wire [7:0]led_request__led_number;

    //b Clock gating module instances
    //b Module instances
    led_ws2812_chain leds(
        .clk(clk),
        .clk__enable(1'b1),
        .led_data__blue(led_data__blue),
        .led_data__green(led_data__green),
        .led_data__red(led_data__red),
        .led_data__last(led_data__last),
        .led_data__valid(led_data__valid),
        .divider_400ns(chain_state__divider_400ns),
        .reset_n(reset_n),
        .led_chain(            led_chain),
        .led_request__led_number(            led_request__led_number),
        .led_request__first(            led_request__first),
        .led_request__ready(            led_request__ready)         );
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
        if ((access==3'h2))
        begin
            apb_response__prdata__var = {{{12'h0,chain_state__last_led},8'h0},chain_state__divider_400ns};
        end //if
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
            case ({apb_request__paddr[4],4'h0}) //synopsys parallel_case
            5'h0: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h1:3'h2);
                end
            5'h10: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h3:3'h0);
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

    //b timer_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//timer_logic__comb
    begin: timer_logic__comb_code
    reg led_data__valid__var;
    reg led_data__last__var;
    reg [7:0]led_data__red__var;
    reg [7:0]led_data__green__var;
    reg [7:0]led_data__blue__var;
        led_data__valid__var = 1'h0;
        led_data__last__var = 1'h0;
        led_data__red__var = 8'h0;
        led_data__green__var = 8'h0;
        led_data__blue__var = 8'h0;
        if ((led_request__ready!=1'h0))
        begin
            led_data__red__var = leds__red[led_request__led_number];
            led_data__green__var = leds__green[led_request__led_number];
            led_data__blue__var = leds__blue[led_request__led_number];
            led_data__valid__var = 1'h1;
            if ((led_request__led_number[3:0]==chain_state__last_led))
            begin
                led_data__last__var = 1'h1;
            end //if
        end //if
        led_data__valid = led_data__valid__var;
        led_data__last = led_data__last__var;
        led_data__red = led_data__red__var;
        led_data__green = led_data__green__var;
        led_data__blue = led_data__blue__var;
    end //always

    //b timer_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : timer_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            chain_state__divider_400ns <= 8'h0;
            chain_state__last_led <= 4'h0;
            leds__red[0] <= 8'h0;
            leds__red[1] <= 8'h0;
            leds__red[2] <= 8'h0;
            leds__red[3] <= 8'h0;
            leds__red[4] <= 8'h0;
            leds__red[5] <= 8'h0;
            leds__red[6] <= 8'h0;
            leds__red[7] <= 8'h0;
            leds__red[8] <= 8'h0;
            leds__red[9] <= 8'h0;
            leds__red[10] <= 8'h0;
            leds__red[11] <= 8'h0;
            leds__red[12] <= 8'h0;
            leds__red[13] <= 8'h0;
            leds__red[14] <= 8'h0;
            leds__red[15] <= 8'h0;
            leds__green[0] <= 8'h0;
            leds__green[1] <= 8'h0;
            leds__green[2] <= 8'h0;
            leds__green[3] <= 8'h0;
            leds__green[4] <= 8'h0;
            leds__green[5] <= 8'h0;
            leds__green[6] <= 8'h0;
            leds__green[7] <= 8'h0;
            leds__green[8] <= 8'h0;
            leds__green[9] <= 8'h0;
            leds__green[10] <= 8'h0;
            leds__green[11] <= 8'h0;
            leds__green[12] <= 8'h0;
            leds__green[13] <= 8'h0;
            leds__green[14] <= 8'h0;
            leds__green[15] <= 8'h0;
            leds__blue[0] <= 8'h0;
            leds__blue[1] <= 8'h0;
            leds__blue[2] <= 8'h0;
            leds__blue[3] <= 8'h0;
            leds__blue[4] <= 8'h0;
            leds__blue[5] <= 8'h0;
            leds__blue[6] <= 8'h0;
            leds__blue[7] <= 8'h0;
            leds__blue[8] <= 8'h0;
            leds__blue[9] <= 8'h0;
            leds__blue[10] <= 8'h0;
            leds__blue[11] <= 8'h0;
            leds__blue[12] <= 8'h0;
            leds__blue[13] <= 8'h0;
            leds__blue[14] <= 8'h0;
            leds__blue[15] <= 8'h0;
        end
        else if (clk__enable)
        begin
            if ((chain_state__divider_400ns==8'h0))
            begin
                chain_state__divider_400ns <= divider_400ns_in;
            end //if
            if ((access==3'h1))
            begin
                chain_state__divider_400ns <= apb_request__pwdata[7:0];
                chain_state__last_led <= apb_request__pwdata[19:16];
            end //if
            if ((access==3'h3))
            begin
                leds__red[apb_request__paddr[3:0]] <= apb_request__pwdata[7:0];
                leds__green[apb_request__paddr[3:0]] <= apb_request__pwdata[15:8];
                leds__blue[apb_request__paddr[3:0]] <= apb_request__pwdata[23:16];
            end //if
        end //if
    end //always

endmodule // apb_target_led_ws2812
