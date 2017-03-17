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

//a Module framebuffer_timing
    //   
    //   This module generates v_sync, h_sync and display_enable for a
    //   framebuffer, using configurable timings.
    //   
module framebuffer_timing
(
    video_clk,
    video_clk__enable,
    csr_clk,
    csr_clk__enable,

    csr_select,
    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    reset_n,

    csr_response__acknowledge,
    csr_response__read_data_valid,
    csr_response__read_data_error,
    csr_response__read_data,
    video_timing__v_sync,
    video_timing__h_sync,
    video_timing__will_h_sync,
    video_timing__v_displaying,
    video_timing__display_required,
    video_timing__will_display_enable,
    video_timing__display_enable
);

    //b Clocks
        //   Video clock, used to generate vsync, hsync, data out, etc
    input video_clk;
    input video_clk__enable;
        //   Clock for CSR reads/writes
    input csr_clk;
    input csr_clk__enable;

    //b Inputs
        //   CSR select value to target this module on the CSR interface
    input [15:0]csr_select;
        //   Pipelined CSR request interface to control the module
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Pipelined CSR response interface to control the module
    output csr_response__acknowledge;
    output csr_response__read_data_valid;
    output csr_response__read_data_error;
    output [31:0]csr_response__read_data;
        //   Video timing outputs
    output video_timing__v_sync;
    output video_timing__h_sync;
    output video_timing__will_h_sync;
    output video_timing__v_displaying;
    output video_timing__display_required;
    output video_timing__will_display_enable;
    output video_timing__display_enable;

// output components here

    //b Output combinatorials
        //   Video timing outputs
    reg video_timing__v_sync;
    reg video_timing__h_sync;
    reg video_timing__will_h_sync;
    reg video_timing__v_displaying;
    reg video_timing__display_required;
    reg video_timing__will_display_enable;
    reg video_timing__display_enable;

    //b Output nets
        //   Pipelined CSR response interface to control the module
    wire csr_response__acknowledge;
    wire csr_response__read_data_valid;
    wire csr_response__read_data_error;
    wire [31:0]csr_response__read_data;

    //b Internal and output registers
        //   State of the video side; timing counters, state machines, and outputs
    reg video_state__h_sync;
    reg video_state__v_sync;
    reg video_state__display_enable;
    reg [1:0]video_state__h_state;
    reg [9:0]video_state__h_pixel;
    reg [1:0]video_state__v_state;
    reg [9:0]video_state__v_line;
    reg video_state__pixel_data_required;
        //   Control/status registers
    reg [9:0]csrs__h_back_porch;
    reg [9:0]csrs__h_display;
    reg [9:0]csrs__h_front_porch;
    reg [9:0]csrs__v_back_porch;
    reg [9:0]csrs__v_display;
    reg [9:0]csrs__v_front_porch;

    //b Internal combinatorials
        //   Combinatorial decode of the @a video_state
    reg video_combs__h_line_start;
    reg video_combs__h_line_end;
    reg video_combs__h_back_porch_end;
    reg video_combs__h_display_end;
    reg video_combs__h_will_be_displaying;
    reg video_combs__h_displaying;
    reg video_combs__v_frame_start;
    reg video_combs__v_back_porch_last_line;
    reg video_combs__v_display_last_line;
    reg video_combs__v_frame_last_line;
    reg video_combs__v_displaying;
    reg video_combs__will_display_pixels;
        //   Read data in response to the CSR access
    reg [31:0]csr_read_data;

    //b Internal nets
        //   The CSR access decoded by the @a csr_interface, to be handled by this module
    wire csr_access__valid;
    wire csr_access__read_not_write;
    wire [15:0]csr_access__address;
    wire [31:0]csr_access__data;

    //b Clock gating module instances
    //b Module instances
    csr_target_csr csri(
        .clk(csr_clk),
        .clk__enable(1'b1),
        .csr_select(csr_select),
        .csr_access_data(csr_read_data),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .reset_n(reset_n),
        .csr_access__data(            csr_access__data),
        .csr_access__address(            csr_access__address),
        .csr_access__read_not_write(            csr_access__read_not_write),
        .csr_access__valid(            csr_access__valid),
        .csr_response__read_data(            csr_response__read_data),
        .csr_response__read_data_error(            csr_response__read_data_error),
        .csr_response__read_data_valid(            csr_response__read_data_valid),
        .csr_response__acknowledge(            csr_response__acknowledge)         );
    //b video_timing_logic__comb combinatorial process
        //   
        //       The video timing logic is effectively a set of counters and comparators.
        //   
        //       A line starts at @a h_pixel 0 in back porch and increments the
        //       h_pixel, until the porch is completed when h_pixel is reset; it
        //       then goes through the display period until that completes,
        //       reseting h_pixel again; then the front porch is performed, at the
        //       end of which h_pixel is again reset, and the back porch starts
        //       again.
        //   
        //       This method is also used for the vertical timing, with a new line
        //       starting when the front porch completes.
        //   
        //       Hence the horizontal and vertical sides have three-state FSMs:
        //       back porch, display, front porch. The display is enabled if in the
        //       display state for both horizontal and vertical timing machines.
        //       
    always @ ( * )//video_timing_logic__comb
    begin: video_timing_logic__comb_code
        video_combs__h_line_start = video_state__h_sync;
        video_combs__h_back_porch_end = ((video_state__h_state==2'h0)&&(video_state__h_pixel==csrs__h_back_porch));
        video_combs__h_display_end = ((video_state__h_state==2'h1)&&(video_state__h_pixel==csrs__h_display));
        video_combs__h_line_end = ((video_state__h_state==2'h2)&&(video_state__h_pixel==csrs__h_front_porch));
        video_combs__h_displaying = (video_state__h_state==2'h1);
        video_combs__h_will_be_displaying = ((video_combs__h_back_porch_end!=1'h0)||((video_combs__h_displaying!=1'h0)&&!(video_combs__h_display_end!=1'h0)));
        video_combs__v_frame_start = ((video_state__v_sync!=1'h0)&&(video_state__h_sync!=1'h0));
        video_combs__v_back_porch_last_line = ((video_state__v_state==2'h0)&&(video_state__v_line==csrs__v_back_porch));
        video_combs__v_display_last_line = ((video_state__v_state==2'h1)&&(video_state__v_line==csrs__v_display));
        video_combs__v_frame_last_line = ((video_state__v_state==2'h2)&&(video_state__v_line==csrs__v_front_porch));
        video_combs__v_displaying = (video_state__v_state==2'h1);
        video_combs__will_display_pixels = ((video_combs__v_displaying!=1'h0)&&(video_combs__h_will_be_displaying!=1'h0));
    end //always

    //b video_timing_logic__posedge_video_clk_active_low_reset_n clock process
        //   
        //       The video timing logic is effectively a set of counters and comparators.
        //   
        //       A line starts at @a h_pixel 0 in back porch and increments the
        //       h_pixel, until the porch is completed when h_pixel is reset; it
        //       then goes through the display period until that completes,
        //       reseting h_pixel again; then the front porch is performed, at the
        //       end of which h_pixel is again reset, and the back porch starts
        //       again.
        //   
        //       This method is also used for the vertical timing, with a new line
        //       starting when the front porch completes.
        //   
        //       Hence the horizontal and vertical sides have three-state FSMs:
        //       back porch, display, front porch. The display is enabled if in the
        //       display state for both horizontal and vertical timing machines.
        //       
    always @( posedge video_clk or negedge reset_n)
    begin : video_timing_logic__posedge_video_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            video_state__display_enable <= 1'h0;
            video_state__h_pixel <= 10'h0;
            video_state__h_sync <= 1'h0;
            video_state__h_state <= 2'h0;
            video_state__pixel_data_required <= 1'h0;
            video_state__v_line <= 10'h0;
            video_state__v_sync <= 1'h0;
            video_state__v_state <= 2'h0;
        end
        else if (video_clk__enable)
        begin
            video_state__display_enable <= 1'h0;
            if ((video_combs__will_display_pixels!=1'h0))
            begin
                video_state__display_enable <= 1'h1;
            end //if
            video_state__h_pixel <= (video_state__h_pixel+10'h1);
            video_state__h_sync <= 1'h0;
            case (video_state__h_state) //synopsys parallel_case
            2'h0: // req 1
                begin
                if ((video_combs__h_back_porch_end!=1'h0))
                begin
                    video_state__h_pixel <= 10'h0;
                    video_state__h_state <= 2'h1;
                end //if
                end
            2'h1: // req 1
                begin
                if ((video_combs__h_display_end!=1'h0))
                begin
                    video_state__h_pixel <= 10'h0;
                    video_state__h_state <= 2'h2;
                    video_state__pixel_data_required <= 1'h0;
                end //if
                end
            2'h2: // req 1
                begin
                if ((video_combs__h_line_end!=1'h0))
                begin
                    video_state__h_pixel <= 10'h0;
                    video_state__h_state <= 2'h0;
                    video_state__h_sync <= 1'h1;
                    video_state__pixel_data_required <= ((video_combs__v_back_porch_last_line!=1'h0)||((video_combs__v_displaying!=1'h0)&&!(video_combs__v_display_last_line!=1'h0)));
                end //if
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:framebuffer_timing:video_timing_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            video_state__v_line <= (video_state__v_line+10'h1);
            video_state__v_sync <= 1'h0;
            case (video_state__v_state) //synopsys parallel_case
            2'h0: // req 1
                begin
                if ((video_combs__v_back_porch_last_line!=1'h0))
                begin
                    video_state__v_line <= 10'h0;
                    video_state__v_state <= 2'h1;
                end //if
                end
            2'h1: // req 1
                begin
                if ((video_combs__v_display_last_line!=1'h0))
                begin
                    video_state__v_line <= 10'h0;
                    video_state__v_state <= 2'h2;
                end //if
                end
            2'h2: // req 1
                begin
                if ((video_combs__v_frame_last_line!=1'h0))
                begin
                    video_state__v_line <= 10'h0;
                    video_state__v_state <= 2'h0;
                    video_state__v_sync <= 1'h1;
                end //if
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:framebuffer_timing:video_timing_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            if (!(video_combs__h_line_end!=1'h0))
            begin
                video_state__v_sync <= video_state__v_sync;
                video_state__v_line <= video_state__v_line;
                video_state__v_state <= video_state__v_state;
            end //if
        end //if
    end //always

    //b video_timings_out combinatorial process
        //   
        //       Drive the video timings out from the @a video_state to the @a video_timing port
        //       
    always @ ( * )//video_timings_out
    begin: video_timings_out__comb_code
        video_timing__v_sync = video_state__v_sync;
        video_timing__h_sync = video_state__h_sync;
        video_timing__will_h_sync = video_combs__h_line_end;
        video_timing__v_displaying = video_combs__v_displaying;
        video_timing__display_required = video_state__pixel_data_required;
        video_timing__display_enable = video_state__display_enable;
        video_timing__will_display_enable = video_combs__will_display_pixels;
    end //always

    //b csr_interface_logic__comb combinatorial process
        //   
        //       Logic to handle read/write of the timing CSRs through the
        //       pipelined CSR interface. @a csr_read_data is driven without caring
        //       about @a csr_access.valid, as the CSR interface will discard any
        //       data it does not use.
        //       
    always @ ( * )//csr_interface_logic__comb
    begin: csr_interface_logic__comb_code
    reg [31:0]csr_read_data__var;
        csr_read_data__var = 32'h0;
        case (csr_access__address[3:0]) //synopsys parallel_case
        4'h0: // req 1
            begin
            csr_read_data__var = {{{6'h0,csrs__v_display},6'h0},csrs__h_display};
            end
        4'h1: // req 1
            begin
            csr_read_data__var = {{{6'h0,csrs__h_back_porch},6'h0},csrs__h_front_porch};
            end
        4'h2: // req 1
            begin
            csr_read_data__var = {{{6'h0,csrs__v_back_porch},6'h0},csrs__v_front_porch};
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
        csr_read_data = csr_read_data__var;
    end //always

    //b csr_interface_logic__posedge_csr_clk_active_low_reset_n clock process
        //   
        //       Logic to handle read/write of the timing CSRs through the
        //       pipelined CSR interface. @a csr_read_data is driven without caring
        //       about @a csr_access.valid, as the CSR interface will discard any
        //       data it does not use.
        //       
    always @( posedge csr_clk or negedge reset_n)
    begin : csr_interface_logic__posedge_csr_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            csrs__h_back_porch <= 10'h0;
            csrs__h_back_porch <= 10'h27;
            csrs__h_display <= 10'h0;
            csrs__h_display <= 10'h1df;
            csrs__h_front_porch <= 10'h0;
            csrs__h_front_porch <= 10'h4;
            csrs__v_back_porch <= 10'h0;
            csrs__v_back_porch <= 10'h7;
            csrs__v_display <= 10'h0;
            csrs__v_display <= 10'h10f;
            csrs__v_front_porch <= 10'h0;
            csrs__v_front_porch <= 10'h7;
        end
        else if (csr_clk__enable)
        begin
            csrs__h_back_porch <= csrs__h_back_porch;
            csrs__h_display <= csrs__h_display;
            csrs__h_front_porch <= csrs__h_front_porch;
            csrs__v_back_porch <= csrs__v_back_porch;
            csrs__v_display <= csrs__v_display;
            csrs__v_front_porch <= csrs__v_front_porch;
            case (csr_access__address[3:0]) //synopsys parallel_case
            4'h0: // req 1
                begin
                if (((csr_access__valid!=1'h0)&&!(csr_access__read_not_write!=1'h0)))
                begin
                    csrs__h_display <= csr_access__data[9:0];
                    csrs__v_display <= csr_access__data[25:16];
                end //if
                end
            4'h1: // req 1
                begin
                if (((csr_access__valid!=1'h0)&&!(csr_access__read_not_write!=1'h0)))
                begin
                    csrs__h_back_porch <= csr_access__data[9:0];
                    csrs__h_front_porch <= csr_access__data[25:16];
                end //if
                end
            4'h2: // req 1
                begin
                if (((csr_access__valid!=1'h0)&&!(csr_access__read_not_write!=1'h0)))
                begin
                    csrs__v_back_porch <= csr_access__data[9:0];
                    csrs__v_front_porch <= csr_access__data[25:16];
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

endmodule // framebuffer_timing
