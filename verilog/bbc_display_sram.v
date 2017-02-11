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

//a Module bbc_display_sram
    //   
    //   This module mimics a monitor attached to the BBC video output, generating a
    //   stream of SRAM write requests as pixels are driven by the video output signals.
    //   
    //   A regular video stream (from the BBC micro) runs at 2MHz with either 6 or 8 pixels per tick.
    //   On the BBC micro this is a pixel clock of either 16MHz or 12MHz.
    //   
    //   The 't_bbc_display' indicates 1, 2, 4, 6 or 8 pixels per clock - but the interpretation here
    //   is for either 6 or 8 - since 1, 2 and 4 'pixels per clock' is the internal BBC pixels, which have
    //   been replicated on the bus. This should probably be fixed rather than explained.
    //   
    //   The module is designed with a display input stage that manages vsync
    //   and hsync, and which then handles the 'back porch' for both vertical
    //   and horizontal blanking. The 'back porch' is the number of pixel
    //   clocks or scanlines that should not be captured following the
    //   detection of hsync/vsync respectively.
    //   
    //   The display input stage then combines the input pixel data with the
    //   blanking for back porches to produce a validated pixel stream for the
    //   second stage of the module. Coupled to this are restart frame/line
    //   indicators.
    //   
    //   For interlaced capture (which most monitors would be) the vsync will
    //   occur at different points in a line for even and odd fields. Even
    //   fields are SRAM addresses 0, 2, 4 (in 'line' terms), and odd fields
    //   are SRAM address 1, 3, 5 (again in 'line' terms). So the display input
    //   stage determines if a vsync corresponds to an odd or an even field.
    //   
    //   The second stage is the SRAM data collation stage.  This gathers the
    //   valid pixels from the display input stage into a shift register, and
    //   when 16 pixels are ready to be written they are passed to the SRAM
    //   write output stage. This SRAM data collation stage manages the SRAM
    //   addresses, resetting to the base address on a frame restart (plus a a
    //   single line of an odd field, interlaced), and incrementing the address
    //   on every write. A fixed number of SRAM writes is permitted per line
    //   (to set the captured display width). A fixed number of scanlines is
    //   permitted per frame (field).
    //   
    //   Note that at the end of a line, for interlaced frames, the SRAM
    //   address is moved down by a line too, so that even fields do write to
    //   even 'lines' in SRAM, and odd lines just to the odd 'lines'.
    //   
    //   
module bbc_display_sram
(
    clk,
    clk__enable,

    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    display__clock_enable,
    display__hsync,
    display__vsync,
    display__pixels_per_clock,
    display__red,
    display__green,
    display__blue,
    reset_n,

    csr_response__ack,
    csr_response__read_data_valid,
    csr_response__read_data,
    sram_write__enable,
    sram_write__data,
    sram_write__address
);

    //b Clocks
        //   Clock running at 2MHz
    input clk;
    input clk__enable;

    //b Inputs
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
    input display__clock_enable;
    input display__hsync;
    input display__vsync;
    input [2:0]display__pixels_per_clock;
    input [7:0]display__red;
    input [7:0]display__green;
    input [7:0]display__blue;
    input reset_n;

    //b Outputs
    output csr_response__ack;
    output csr_response__read_data_valid;
    output [31:0]csr_response__read_data;
    output sram_write__enable;
    output [47:0]sram_write__data;
    output [15:0]sram_write__address;

// output components here

    //b Output combinatorials
    reg sram_write__enable;
    reg [47:0]sram_write__data;
    reg [15:0]sram_write__address;

    //b Output nets
    wire csr_response__ack;
    wire csr_response__read_data_valid;
    wire [31:0]csr_response__read_data;

    //b Internal and output registers
    reg sram_state__write_enable;
    reg [15:0]sram_state__write_address;
    reg [47:0]sram_state__write_data;
    reg [15:0]sram_state__address;
    reg [9:0]sram_state__scanline_writes_left;
    reg [9:0]sram_state__scanlines_left;
    reg [3:0]sram_state__num_pixels_held_valid;
    reg [15:0]sram_state__pixels_held_valid_mask;
    reg [15:0]sram_state__pixels_held_red;
    reg [15:0]sram_state__pixels_held_green;
    reg [15:0]sram_state__pixels_held_blue;
    reg display_state__last_vsync;
    reg display_state__last_hsync;
    reg display_state__even_field;
    reg display_state__restart_line;
    reg display_state__last_field_was_even;
    reg display_state__interlaced;
    reg display_state__restart_frame_even_field;
    reg display_state__restart_frame_odd_field;
    reg [10:0]display_state__scanlines_since_vsync;
    reg [10:0]display_state__clocks_since_hsync;
    reg [10:0]display_state__clocks_wide;
    reg [10:0]display_state__x_back_porch;
    reg [10:0]display_state__pixel_x;
    reg [10:0]display_state__pixel_y;
    reg [3:0]display_state__num_pixels_to_add_valid;
    reg [7:0]display_state__pixels_to_add_red;
    reg [7:0]display_state__pixels_to_add_green;
    reg [7:0]display_state__pixels_to_add_blue;
    reg [10:0]csrs__h_back_porch;
    reg [10:0]csrs__v_back_porch;
    reg [15:0]csrs__sram_base_address;
    reg [15:0]csrs__sram_base_address_odd_fields;
    reg [9:0]csrs__sram_scanlines;
    reg [9:0]csrs__sram_writes_per_scanline;
    reg csrs__sram_interlace_in_same_buffer;

    //b Internal combinatorials
    reg [31:0]csr_read_data;
    reg sram_combs__write;
    reg [4:0]sram_combs__total_valid;
    reg [23:0]sram_combs__barrel_shift_red;
    reg [23:0]sram_combs__barrel_shift_green;
    reg [23:0]sram_combs__barrel_shift_blue;
    reg [23:0]sram_combs__shifted_red;
    reg [23:0]sram_combs__shifted_green;
    reg [23:0]sram_combs__shifted_blue;
    reg display_combs__hsync_detected;
    reg display_combs__vsync_detected;
    reg display_combs__vsync_late_in_line;
    reg [7:0]display_combs__pixels_valid_per_clock;
    reg [7:0]display_combs__pixels_valid_by_x;
    reg [7:0]display_combs__pixels_valid;
    reg [2:0]display_combs__new_pixels[7:0];

    //b Internal nets
    wire csr_access__valid;
    wire csr_access__read_not_write;
    wire [15:0]csr_access__address;
    wire [31:0]csr_access__data;

    //b Clock gating module instances
    //b Module instances
    bbc_csr_interface csri(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_select(16'h1),
        .csr_read_data(csr_read_data),
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
        .csr_response__read_data_valid(            csr_response__read_data_valid),
        .csr_response__ack(            csr_response__ack)         );
    //b display_input_state_control_logic__comb combinatorial process
        //   
        //       Manage display input signals to generate screen coordinates and pixel validity
        //       Possible should use display.clock_enable, which would enable a 1MHz pixel clock, although
        //       that is probably not necessary - and currently that signal is tied low...
        //       
    always @ ( * )//display_input_state_control_logic__comb
    begin: display_input_state_control_logic__comb_code
        display_combs__hsync_detected = ((display__hsync!=1'h0)&&!(display_state__last_hsync!=1'h0));
        display_combs__vsync_detected = ((display__vsync!=1'h0)&&!(display_state__last_vsync!=1'h0));
        display_combs__vsync_late_in_line = (display_state__clocks_since_hsync>{1'h0,display_state__clocks_wide[10:1]});
    end //always

    //b display_input_state_control_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       Manage display input signals to generate screen coordinates and pixel validity
        //       Possible should use display.clock_enable, which would enable a 1MHz pixel clock, although
        //       that is probably not necessary - and currently that signal is tied low...
        //       
    always @( posedge clk or negedge reset_n)
    begin : display_input_state_control_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            display_state__last_vsync <= 1'h0;
            display_state__last_hsync <= 1'h0;
            display_state__x_back_porch <= 11'h0;
            display_state__clocks_since_hsync <= 11'h0;
            display_state__restart_line <= 1'h0;
            display_state__restart_frame_even_field <= 1'h0;
            display_state__restart_frame_odd_field <= 1'h0;
            display_state__scanlines_since_vsync <= 11'h0;
            display_state__clocks_wide <= 11'h0;
            display_state__pixel_x <= 11'h0;
            display_state__pixel_y <= 11'h0;
            display_state__last_field_was_even <= 1'h0;
            display_state__even_field <= 1'h0;
            display_state__interlaced <= 1'h0;
        end
        else if (clk__enable)
        begin
            display_state__last_vsync <= display__vsync;
            display_state__last_hsync <= display__hsync;
            display_state__x_back_porch <= (display_state__x_back_porch+11'h8);
            display_state__clocks_since_hsync <= (display_state__clocks_since_hsync+11'h1);
            display_state__restart_line <= 1'h0;
            display_state__restart_frame_even_field <= 1'h0;
            display_state__restart_frame_odd_field <= 1'h0;
            if ((display_combs__hsync_detected!=1'h0))
            begin
                display_state__scanlines_since_vsync <= (display_state__scanlines_since_vsync+11'h1);
                display_state__clocks_wide <= display_state__clocks_since_hsync;
                display_state__clocks_since_hsync <= 11'h0;
                display_state__x_back_porch <= csrs__h_back_porch;
            end //if
            display_state__pixel_x <= (display_state__pixel_x+11'h1);
            if ((display_state__x_back_porch[10:3]==8'hff))
            begin
                display_state__pixel_x <= 11'h0;
            end //if
            if (((display_state__pixel_x+11'h8)==display_state__clocks_wide))
            begin
                if ((display_state__interlaced!=1'h0))
                begin
                    display_state__pixel_y <= (display_state__pixel_y+11'h2);
                end //if
                else
                
                begin
                    display_state__pixel_y <= (display_state__pixel_y+11'h1);
                end //else
                if (!(display_state__pixel_y[10]!=1'h0))
                begin
                    display_state__restart_line <= 1'h1;
                end //if
            end //if
            if ((display_combs__vsync_detected!=1'h0))
            begin
                display_state__scanlines_since_vsync <= 11'h0;
                display_state__last_field_was_even <= display_state__even_field;
                display_state__even_field <= display_combs__vsync_late_in_line;
                if ((display_state__even_field==display_state__last_field_was_even))
                begin
                    display_state__interlaced <= 1'h0;
                    display_state__restart_frame_even_field <= 1'h1;
                    display_state__pixel_y <= csrs__v_back_porch;
                end //if
                else
                
                begin
                    if ((display_combs__vsync_late_in_line!=1'h0))
                    begin
                        display_state__interlaced <= 1'h1;
                        display_state__restart_frame_even_field <= 1'h1;
                        display_state__pixel_y <= csrs__v_back_porch;
                    end //if
                    else
                    
                    begin
                        display_state__interlaced <= 1'h1;
                        display_state__pixel_y <= (csrs__v_back_porch+11'h1);
                        display_state__restart_frame_odd_field <= 1'h1;
                    end //else
                end //else
            end //if
        end //if
    end //always

    //b display_input_state2__comb combinatorial process
        //   
        //       Manage display input signals to generate screen coordinates and pixel validity
        //       Possible used display.clock_enable
        //       
    always @ ( * )//display_input_state2__comb
    begin: display_input_state2__comb_code
    reg [7:0]display_combs__pixels_valid_by_x__var;
    reg [7:0]display_combs__pixels_valid_per_clock__var;
    reg [7:0]display_combs__pixels_valid__var;
    reg [2:0]display_combs__new_pixels__var[7:0];
        case (display_state__pixel_x) //synopsys parallel_case
        11'hfffffffffffffff9: // req 1
            begin
            display_combs__pixels_valid_by_x__var = 8'h1;
            end
        11'hfffffffffffffffa: // req 1
            begin
            display_combs__pixels_valid_by_x__var = 8'h3;
            end
        11'hfffffffffffffffb: // req 1
            begin
            display_combs__pixels_valid_by_x__var = 8'h7;
            end
        11'hfffffffffffffffc: // req 1
            begin
            display_combs__pixels_valid_by_x__var = 8'hf;
            end
        11'hfffffffffffffffd: // req 1
            begin
            display_combs__pixels_valid_by_x__var = 8'h1f;
            end
        11'hfffffffffffffffe: // req 1
            begin
            display_combs__pixels_valid_by_x__var = 8'h3f;
            end
        11'hffffffffffffffff: // req 1
            begin
            display_combs__pixels_valid_by_x__var = 8'h7f;
            end
        default: // req 1
            begin
            display_combs__pixels_valid_by_x__var = 8'hff;
            if ((display_state__pixel_x[10]!=1'h0))
            begin
                display_combs__pixels_valid_by_x__var = 8'h0;
            end //if
            end
        endcase
        case (display__pixels_per_clock) //synopsys parallel_case
        3'h3: // req 1
            begin
            display_combs__pixels_valid_per_clock__var = 8'h3f;
            end
        default: // req 1
            begin
            display_combs__pixels_valid_per_clock__var = 8'hff;
            end
        endcase
        display_combs__pixels_valid__var = (display_combs__pixels_valid_per_clock__var & display_combs__pixels_valid_by_x__var);
        if ((((display_state__pixel_y[10]!=1'h0)||(display_combs__hsync_detected!=1'h0))||(display_combs__vsync_detected!=1'h0)))
        begin
            display_combs__pixels_valid__var = 8'h0;
        end //if
        display_combs__new_pixels__var[0] = {{display__blue[0],display__green[0]},display__red[0]};
        display_combs__new_pixels__var[1] = {{display__blue[1],display__green[1]},display__red[1]};
        display_combs__new_pixels__var[2] = {{display__blue[2],display__green[2]},display__red[2]};
        display_combs__new_pixels__var[3] = {{display__blue[3],display__green[3]},display__red[3]};
        display_combs__new_pixels__var[4] = {{display__blue[4],display__green[4]},display__red[4]};
        display_combs__new_pixels__var[5] = {{display__blue[5],display__green[5]},display__red[5]};
        display_combs__new_pixels__var[6] = {{display__blue[6],display__green[6]},display__red[6]};
        display_combs__new_pixels__var[7] = {{display__blue[7],display__green[7]},display__red[7]};
        display_combs__pixels_valid_by_x = display_combs__pixels_valid_by_x__var;
        display_combs__pixels_valid_per_clock = display_combs__pixels_valid_per_clock__var;
        display_combs__pixels_valid = display_combs__pixels_valid__var;
        begin:__set__display_combs__new_pixels__iter integer __iter; for (__iter=0; __iter<8; __iter=__iter+1) display_combs__new_pixels[__iter] = display_combs__new_pixels__var[__iter]; end
    end //always

    //b display_input_state2__posedge_clk_active_low_reset_n clock process
        //   
        //       Manage display input signals to generate screen coordinates and pixel validity
        //       Possible used display.clock_enable
        //       
    always @( posedge clk or negedge reset_n)
    begin : display_input_state2__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            display_state__num_pixels_to_add_valid <= 4'h0;
            display_state__pixels_to_add_red <= 8'h0;
            display_state__pixels_to_add_green <= 8'h0;
            display_state__pixels_to_add_blue <= 8'h0;
        end
        else if (clk__enable)
        begin
            display_state__num_pixels_to_add_valid <= 4'h0;
            if ((display_combs__pixels_valid[0]!=1'h0))
            begin
                display_state__num_pixels_to_add_valid <= 4'h1;
                display_state__pixels_to_add_red[7] <= display__red[0];
                display_state__pixels_to_add_green[7] <= display__green[0];
                display_state__pixels_to_add_blue[7] <= display__blue[0];
            end //if
            if ((display_combs__pixels_valid[1]!=1'h0))
            begin
                display_state__num_pixels_to_add_valid <= 4'h2;
                display_state__pixels_to_add_red[7:6] <= display__red[1:0];
                display_state__pixels_to_add_green[7:6] <= display__green[1:0];
                display_state__pixels_to_add_blue[7:6] <= display__blue[1:0];
            end //if
            if ((display_combs__pixels_valid[2]!=1'h0))
            begin
                display_state__num_pixels_to_add_valid <= 4'h3;
                display_state__pixels_to_add_red[7:5] <= display__red[2:0];
                display_state__pixels_to_add_green[7:5] <= display__green[2:0];
                display_state__pixels_to_add_blue[7:5] <= display__blue[2:0];
            end //if
            if ((display_combs__pixels_valid[3]!=1'h0))
            begin
                display_state__num_pixels_to_add_valid <= 4'h4;
                display_state__pixels_to_add_red[7:4] <= display__red[3:0];
                display_state__pixels_to_add_green[7:4] <= display__green[3:0];
                display_state__pixels_to_add_blue[7:4] <= display__blue[3:0];
            end //if
            if ((display_combs__pixels_valid[4]!=1'h0))
            begin
                display_state__num_pixels_to_add_valid <= 4'h5;
                display_state__pixels_to_add_red[7:3] <= display__red[4:0];
                display_state__pixels_to_add_green[7:3] <= display__green[4:0];
                display_state__pixels_to_add_blue[7:3] <= display__blue[4:0];
            end //if
            if ((display_combs__pixels_valid[5]!=1'h0))
            begin
                display_state__num_pixels_to_add_valid <= 4'h6;
                display_state__pixels_to_add_red[7:2] <= display__red[5:0];
                display_state__pixels_to_add_green[7:2] <= display__green[5:0];
                display_state__pixels_to_add_blue[7:2] <= display__blue[5:0];
            end //if
            if ((display_combs__pixels_valid[6]!=1'h0))
            begin
                display_state__num_pixels_to_add_valid <= 4'h7;
                display_state__pixels_to_add_red[7:1] <= display__red[6:0];
                display_state__pixels_to_add_green[7:1] <= display__green[6:0];
                display_state__pixels_to_add_blue[7:1] <= display__blue[6:0];
            end //if
            if ((display_combs__pixels_valid[7]!=1'h0))
            begin
                display_state__num_pixels_to_add_valid <= 4'h8;
                display_state__pixels_to_add_red[7:0] <= display__red[7:0];
                display_state__pixels_to_add_green[7:0] <= display__green[7:0];
                display_state__pixels_to_add_blue[7:0] <= display__blue[7:0];
            end //if
        end //if
    end //always

    //b sram_read_write__comb combinatorial process
        //   
        //       
    always @ ( * )//sram_read_write__comb
    begin: sram_read_write__comb_code
    reg [23:0]sram_combs__barrel_shift_red__var;
    reg [23:0]sram_combs__barrel_shift_green__var;
    reg [23:0]sram_combs__barrel_shift_blue__var;
    reg sram_combs__write__var;
        case (sram_state__num_pixels_held_valid) //synopsys parallel_case
        4'h0: // req 1
            begin
            sram_combs__barrel_shift_red__var = {display_state__pixels_to_add_red,16'h0};
            end
        4'h1: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{1'h0,display_state__pixels_to_add_red},15'h0};
            end
        4'h2: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{2'h0,display_state__pixels_to_add_red},14'h0};
            end
        4'h3: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{3'h0,display_state__pixels_to_add_red},13'h0};
            end
        4'h4: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{4'h0,display_state__pixels_to_add_red},12'h0};
            end
        4'h5: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{5'h0,display_state__pixels_to_add_red},11'h0};
            end
        4'h6: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{6'h0,display_state__pixels_to_add_red},10'h0};
            end
        4'h7: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{7'h0,display_state__pixels_to_add_red},9'h0};
            end
        4'h8: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{8'h0,display_state__pixels_to_add_red},8'h0};
            end
        4'h9: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{9'h0,display_state__pixels_to_add_red},7'h0};
            end
        4'ha: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{10'h0,display_state__pixels_to_add_red},6'h0};
            end
        4'hb: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{11'h0,display_state__pixels_to_add_red},5'h0};
            end
        4'hc: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{12'h0,display_state__pixels_to_add_red},4'h0};
            end
        4'hd: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{13'h0,display_state__pixels_to_add_red},3'h0};
            end
        4'he: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{14'h0,display_state__pixels_to_add_red},2'h0};
            end
        default: // req 1
            begin
            sram_combs__barrel_shift_red__var = {{15'h0,display_state__pixels_to_add_red},1'h0};
            end
        endcase
        case (sram_state__num_pixels_held_valid) //synopsys parallel_case
        4'h0: // req 1
            begin
            sram_combs__barrel_shift_green__var = {display_state__pixels_to_add_green,16'h0};
            end
        4'h1: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{1'h0,display_state__pixels_to_add_green},15'h0};
            end
        4'h2: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{2'h0,display_state__pixels_to_add_green},14'h0};
            end
        4'h3: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{3'h0,display_state__pixels_to_add_green},13'h0};
            end
        4'h4: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{4'h0,display_state__pixels_to_add_green},12'h0};
            end
        4'h5: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{5'h0,display_state__pixels_to_add_green},11'h0};
            end
        4'h6: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{6'h0,display_state__pixels_to_add_green},10'h0};
            end
        4'h7: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{7'h0,display_state__pixels_to_add_green},9'h0};
            end
        4'h8: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{8'h0,display_state__pixels_to_add_green},8'h0};
            end
        4'h9: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{9'h0,display_state__pixels_to_add_green},7'h0};
            end
        4'ha: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{10'h0,display_state__pixels_to_add_green},6'h0};
            end
        4'hb: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{11'h0,display_state__pixels_to_add_green},5'h0};
            end
        4'hc: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{12'h0,display_state__pixels_to_add_green},4'h0};
            end
        4'hd: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{13'h0,display_state__pixels_to_add_green},3'h0};
            end
        4'he: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{14'h0,display_state__pixels_to_add_green},2'h0};
            end
        default: // req 1
            begin
            sram_combs__barrel_shift_green__var = {{15'h0,display_state__pixels_to_add_green},1'h0};
            end
        endcase
        case (sram_state__num_pixels_held_valid) //synopsys parallel_case
        4'h0: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {display_state__pixels_to_add_blue,16'h0};
            end
        4'h1: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{1'h0,display_state__pixels_to_add_blue},15'h0};
            end
        4'h2: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{2'h0,display_state__pixels_to_add_blue},14'h0};
            end
        4'h3: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{3'h0,display_state__pixels_to_add_blue},13'h0};
            end
        4'h4: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{4'h0,display_state__pixels_to_add_blue},12'h0};
            end
        4'h5: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{5'h0,display_state__pixels_to_add_blue},11'h0};
            end
        4'h6: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{6'h0,display_state__pixels_to_add_blue},10'h0};
            end
        4'h7: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{7'h0,display_state__pixels_to_add_blue},9'h0};
            end
        4'h8: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{8'h0,display_state__pixels_to_add_blue},8'h0};
            end
        4'h9: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{9'h0,display_state__pixels_to_add_blue},7'h0};
            end
        4'ha: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{10'h0,display_state__pixels_to_add_blue},6'h0};
            end
        4'hb: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{11'h0,display_state__pixels_to_add_blue},5'h0};
            end
        4'hc: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{12'h0,display_state__pixels_to_add_blue},4'h0};
            end
        4'hd: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{13'h0,display_state__pixels_to_add_blue},3'h0};
            end
        4'he: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{14'h0,display_state__pixels_to_add_blue},2'h0};
            end
        default: // req 1
            begin
            sram_combs__barrel_shift_blue__var = {{15'h0,display_state__pixels_to_add_blue},1'h0};
            end
        endcase
        sram_combs__shifted_red = ({(sram_state__pixels_held_valid_mask & sram_state__pixels_held_red),8'h0} | sram_combs__barrel_shift_red__var);
        sram_combs__shifted_green = ({(sram_state__pixels_held_valid_mask & sram_state__pixels_held_green),8'h0} | sram_combs__barrel_shift_green__var);
        sram_combs__shifted_blue = ({(sram_state__pixels_held_valid_mask & sram_state__pixels_held_blue),8'h0} | sram_combs__barrel_shift_blue__var);
        sram_combs__total_valid = ({1'h0,sram_state__num_pixels_held_valid}+{1'h0,display_state__num_pixels_to_add_valid});
        sram_combs__write__var = 1'h0;
        if ((sram_combs__total_valid[4]!=1'h0))
        begin
            sram_combs__write__var = 1'h1;
        end //if
        else
        
        begin
        end //else
        sram_write__enable = sram_state__write_enable;
        sram_write__data = sram_state__write_data;
        sram_write__address = sram_state__write_address;
        sram_combs__barrel_shift_red = sram_combs__barrel_shift_red__var;
        sram_combs__barrel_shift_green = sram_combs__barrel_shift_green__var;
        sram_combs__barrel_shift_blue = sram_combs__barrel_shift_blue__var;
        sram_combs__write = sram_combs__write__var;
    end //always

    //b sram_read_write__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : sram_read_write__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            sram_state__pixels_held_red <= 16'h0;
            sram_state__pixels_held_green <= 16'h0;
            sram_state__pixels_held_blue <= 16'h0;
            sram_state__pixels_held_valid_mask <= 16'h0;
            sram_state__num_pixels_held_valid <= 4'h0;
            sram_state__write_data <= 48'h0;
            sram_state__write_enable <= 1'h0;
            sram_state__write_address <= 16'h0;
            sram_state__address <= 16'h0;
            sram_state__scanline_writes_left <= 10'h0;
            sram_state__scanlines_left <= 10'h0;
        end
        else if (clk__enable)
        begin
            if ((sram_combs__total_valid[4]!=1'h0))
            begin
                sram_state__pixels_held_red <= {sram_combs__shifted_red[7:0],8'h0};
                sram_state__pixels_held_green <= {sram_combs__shifted_green[7:0],8'h0};
                sram_state__pixels_held_blue <= {sram_combs__shifted_blue[7:0],8'h0};
            end //if
            else
            
            begin
                sram_state__pixels_held_red <= sram_combs__shifted_red[23:8];
                sram_state__pixels_held_green <= sram_combs__shifted_green[23:8];
                sram_state__pixels_held_blue <= sram_combs__shifted_blue[23:8];
            end //else
            case (sram_combs__total_valid[3:0]) //synopsys parallel_case
            4'h0: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'h0;
                end
            4'h1: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'h8000;
                end
            4'h2: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hc000;
                end
            4'h3: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'he000;
                end
            4'h4: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hf000;
                end
            4'h5: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hf800;
                end
            4'h6: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hfc00;
                end
            4'h7: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hfe00;
                end
            4'h8: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hff00;
                end
            4'h9: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hff80;
                end
            4'ha: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hffc0;
                end
            4'hb: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hffe0;
                end
            4'hc: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hfff0;
                end
            4'hd: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hfff8;
                end
            4'he: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hfffc;
                end
            4'hf: // req 1
                begin
                sram_state__pixels_held_valid_mask <= 16'hfffe;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:bbc_display_sram:sram_read_write: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            sram_state__num_pixels_held_valid <= sram_combs__total_valid[3:0];
            sram_state__write_data <= {{sram_combs__shifted_blue[23:8],sram_combs__shifted_green[23:8]},sram_combs__shifted_red[23:8]};
            sram_state__write_enable <= 1'h0;
            if ((sram_combs__write!=1'h0))
            begin
                if ((sram_state__scanline_writes_left!=10'h0))
                begin
                    sram_state__write_enable <= 1'h1;
                    sram_state__write_address <= sram_state__address;
                    sram_state__address <= (sram_state__address+16'h1);
                    sram_state__scanline_writes_left <= (sram_state__scanline_writes_left-10'h1);
                end //if
            end //if
            if ((display_state__restart_line!=1'h0))
            begin
                sram_state__scanline_writes_left <= csrs__sram_writes_per_scanline;
                sram_state__num_pixels_held_valid <= 4'h0;
                if ((sram_state__scanlines_left!=10'h0))
                begin
                    sram_state__scanlines_left <= (sram_state__scanlines_left-10'h1);
                end //if
                if ((display_state__interlaced!=1'h0))
                begin
                    if ((csrs__sram_interlace_in_same_buffer!=1'h0))
                    begin
                        sram_state__address <= (sram_state__address+{6'h0,csrs__sram_writes_per_scanline});
                    end //if
                    if ((sram_state__scanlines_left==10'h1))
                    begin
                        sram_state__scanlines_left <= 10'h0;
                    end //if
                    else
                    
                    begin
                        if ((sram_state__scanlines_left!=10'h0))
                        begin
                            sram_state__scanlines_left <= (sram_state__scanlines_left-10'h2);
                        end //if
                    end //else
                end //if
            end //if
            if (((display_state__restart_frame_even_field!=1'h0)||(display_state__restart_frame_odd_field!=1'h0)))
            begin
                sram_state__scanline_writes_left <= csrs__sram_writes_per_scanline;
                sram_state__num_pixels_held_valid <= 4'h0;
                sram_state__scanlines_left <= csrs__sram_scanlines;
                sram_state__address <= csrs__sram_base_address;
                if ((display_state__restart_frame_odd_field!=1'h0))
                begin
                    sram_state__address <= csrs__sram_base_address_odd_fields;
                end //if
            end //if
        end //if
    end //always

    //b control_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//control_logic__comb
    begin: control_logic__comb_code
        csr_read_data = 32'h0;
    end //always

    //b control_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : control_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            csrs__sram_base_address <= 16'h0;
            csrs__sram_base_address <= 16'h0;
            csrs__sram_base_address_odd_fields <= 16'h0;
            csrs__sram_base_address_odd_fields <= 16'h8000;
            csrs__sram_writes_per_scanline <= 10'h0;
            csrs__sram_writes_per_scanline <= 10'h28;
            csrs__sram_interlace_in_same_buffer <= 1'h0;
            csrs__sram_interlace_in_same_buffer <= 1'h0;
            csrs__sram_scanlines <= 10'h0;
            csrs__sram_scanlines <= 10'h1f4;
            csrs__h_back_porch <= 11'h0;
            csrs__h_back_porch <= 11'h6e8;
            csrs__v_back_porch <= 11'h0;
            csrs__v_back_porch <= 11'h7ba;
        end
        else if (clk__enable)
        begin
            if (((csr_access__valid!=1'h0)&&!(csr_access__read_not_write!=1'h0)))
            begin
                case (csr_access__address[3:0]) //synopsys parallel_case
                4'h0: // req 1
                    begin
                    csrs__sram_base_address <= csr_access__data[15:0];
                    csrs__sram_base_address_odd_fields <= csr_access__data[31:16];
                    end
                4'h1: // req 1
                    begin
                    csrs__sram_writes_per_scanline <= csr_access__data[9:0];
                    csrs__sram_interlace_in_same_buffer <= csr_access__data[15];
                    csrs__sram_scanlines <= csr_access__data[25:16];
                    end
                4'h2: // req 1
                    begin
                    csrs__h_back_porch <= csr_access__data[10:0];
                    csrs__v_back_porch <= csr_access__data[26:16];
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
        end //if
    end //always

endmodule // bbc_display_sram
