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

//a Module framebuffer_teletext
    //   
    //   
module framebuffer_teletext
(
    video_clk,
    video_clk__enable,
    sram_clk,
    sram_clk__enable,
    csr_clk,
    csr_clk__enable,

    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    csr_select_in,
    display_sram_write__enable,
    display_sram_write__data,
    display_sram_write__address,
    reset_n,

    csr_response__acknowledge,
    csr_response__read_data_valid,
    csr_response__read_data_error,
    csr_response__read_data,
    video_bus__vsync,
    video_bus__hsync,
    video_bus__display_enable,
    video_bus__red,
    video_bus__green,
    video_bus__blue
);

    //b Clocks
        //   Video clock, used to generate vsync, hsync, data out, etc
    input video_clk;
    input video_clk__enable;
        //   SRAM write clock, with frame buffer data
    input sram_clk;
    input sram_clk__enable;
        //   Clock for CSR reads/writes
    input csr_clk;
    input csr_clk__enable;

    //b Inputs
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
    input [15:0]csr_select_in;
    input display_sram_write__enable;
    input [47:0]display_sram_write__data;
    input [15:0]display_sram_write__address;
    input reset_n;

    //b Outputs
    output csr_response__acknowledge;
    output csr_response__read_data_valid;
    output csr_response__read_data_error;
    output [31:0]csr_response__read_data;
    output video_bus__vsync;
    output video_bus__hsync;
    output video_bus__display_enable;
    output [7:0]video_bus__red;
    output [7:0]video_bus__green;
    output [7:0]video_bus__blue;

// output components here

    //b Output combinatorials
    reg csr_response__acknowledge;
    reg csr_response__read_data_valid;
    reg csr_response__read_data_error;
    reg [31:0]csr_response__read_data;
    reg video_bus__vsync;
    reg video_bus__hsync;
    reg video_bus__display_enable;
    reg [7:0]video_bus__red;
    reg [7:0]video_bus__green;
    reg [7:0]video_bus__blue;

    //b Output nets

    //b Internal and output registers
    reg [4:0]pixel_state__num_valid;
    reg [13:0]pixel_state__sram_address;
    reg [13:0]pixel_state__sram_address_line_start;
    reg pixel_state__reading_sram;
    reg pixel_state__data_buffer_full;
    reg pixel_state__request_outstanding;
    reg [11:0]pixel_state__shift__red;
    reg [11:0]pixel_state__shift__green;
    reg [11:0]pixel_state__shift__blue;
    reg [11:0]pixel_state__data_buffer__red;
    reg [11:0]pixel_state__data_buffer__green;
    reg [11:0]pixel_state__data_buffer__blue;
    reg [7:0]video_state__red;
    reg [7:0]video_state__green;
    reg [7:0]video_state__blue;
    reg tt_timings__restart_frame;
    reg tt_timings__end_of_scanline;
    reg tt_timings__first_scanline_of_row;
    reg tt_timings__smoothe;
    reg [1:0]tt_timings__interpolate_vertical;
    reg sram_state__write_request__enable;
    reg [47:0]sram_state__write_request__data;
    reg [15:0]sram_state__write_request__address;
    reg [15:0]csrs__sram_base_address;
    reg [15:0]csrs__sram_words_per_line;
    reg [15:0]csr_select;

    //b Internal combinatorials
    reg [7:0]pixel_combs__red;
    reg [7:0]pixel_combs__green;
    reg [7:0]pixel_combs__blue;
    reg [4:0]pixel_combs__next_num_valid;
    reg [13:0]pixel_combs__sram_address_next_line;
    reg pixel_combs__load_shift_register;
    reg pixel_combs__sram_request;
    reg pixel_combs__tt_char__valid;
    reg [6:0]pixel_combs__tt_char__character;
    reg [31:0]csr_read_data;

    //b Internal nets
    wire [7:0]pixel_read_data;
    wire tt_pixels__valid;
    wire [11:0]tt_pixels__red;
    wire [11:0]tt_pixels__green;
    wire [11:0]tt_pixels__blue;
    wire tt_pixels__last_scanline;
    wire [44:0]tt_rom_data;
    wire tt_rom_access__select;
    wire [6:0]tt_rom_access__address;
    wire video_timing__v_sync;
    wire video_timing__h_sync;
    wire video_timing__will_h_sync;
    wire video_timing__v_displaying;
    wire video_timing__display_required;
    wire video_timing__will_display_enable;
    wire video_timing__display_enable;
    wire video_timing__v_frame_last_line;
    wire csr_access__valid;
    wire csr_access__read_not_write;
    wire [15:0]csr_access__address;
    wire [31:0]csr_access__data;
        //   Pipelined CSR response interface to control the module
    wire timing_csr_response__acknowledge;
    wire timing_csr_response__read_data_valid;
    wire timing_csr_response__read_data_error;
    wire [31:0]timing_csr_response__read_data;
    wire local_csr_response__acknowledge;
    wire local_csr_response__read_data_valid;
    wire local_csr_response__read_data_error;
    wire [31:0]local_csr_response__read_data;

    //b Clock gating module instances
    //b Module instances
    se_sram_mrw_2_16384x8 display(
        .sram_clock_1(video_clk),
        .sram_clock_1__enable(1'b1),
        .sram_clock_0(sram_clk),
        .sram_clock_0__enable(1'b1),
        .write_data_1(8'h0),
        .address_1(pixel_state__sram_address[13:0]),
        .read_not_write_1(1'h1),
        .select_1(pixel_combs__sram_request),
        .write_data_0(sram_state__write_request__data[7:0]),
        .address_0(sram_state__write_request__address[13:0]),
        .read_not_write_0(1'h0),
        .select_0(((sram_state__write_request__enable!=1'h0)&&(sram_state__write_request__address[15:14]==2'h0))),
        .data_out_1(            pixel_read_data)         );
    teletext tt(
        .clk(video_clk),
        .clk__enable(1'b1),
        .rom_data(tt_rom_data),
        .timings__interpolate_vertical(tt_timings__interpolate_vertical),
        .timings__smoothe(tt_timings__smoothe),
        .timings__first_scanline_of_row(tt_timings__first_scanline_of_row),
        .timings__end_of_scanline(tt_timings__end_of_scanline),
        .timings__restart_frame(tt_timings__restart_frame),
        .character__character(pixel_combs__tt_char__character),
        .character__valid(pixel_combs__tt_char__valid),
        .reset_n(reset_n),
        .pixels__last_scanline(            tt_pixels__last_scanline),
        .pixels__blue(            tt_pixels__blue),
        .pixels__green(            tt_pixels__green),
        .pixels__red(            tt_pixels__red),
        .pixels__valid(            tt_pixels__valid),
        .rom_access__address(            tt_rom_access__address),
        .rom_access__select(            tt_rom_access__select)         );
    se_sram_srw_128x45 character_rom(
        .sram_clock(video_clk),
        .sram_clock__enable(1'b1),
        .write_data(45'h0),
        .address(tt_rom_access__address),
        .read_not_write(1'h1),
        .select(tt_rom_access__select),
        .data_out(            tt_rom_data)         );
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
        .csr_response__read_data(            local_csr_response__read_data),
        .csr_response__read_data_error(            local_csr_response__read_data_error),
        .csr_response__read_data_valid(            local_csr_response__read_data_valid),
        .csr_response__acknowledge(            local_csr_response__acknowledge)         );
    framebuffer_timing fbt(
        .video_clk(video_clk),
        .video_clk__enable(1'b1),
        .csr_clk(csr_clk),
        .csr_clk__enable(1'b1),
        .csr_select((csr_select+16'h1)),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .reset_n(reset_n),
        .csr_response__read_data(            timing_csr_response__read_data),
        .csr_response__read_data_error(            timing_csr_response__read_data_error),
        .csr_response__read_data_valid(            timing_csr_response__read_data_valid),
        .csr_response__acknowledge(            timing_csr_response__acknowledge),
        .video_timing__v_frame_last_line(            video_timing__v_frame_last_line),
        .video_timing__display_enable(            video_timing__display_enable),
        .video_timing__will_display_enable(            video_timing__will_display_enable),
        .video_timing__display_required(            video_timing__display_required),
        .video_timing__v_displaying(            video_timing__v_displaying),
        .video_timing__will_h_sync(            video_timing__will_h_sync),
        .video_timing__h_sync(            video_timing__h_sync),
        .video_timing__v_sync(            video_timing__v_sync)         );
    //b video_bus_out__comb combinatorial process
        //   
        //       
    always @ ( * )//video_bus_out__comb
    begin: video_bus_out__comb_code
        video_bus__vsync = video_timing__v_sync;
        video_bus__hsync = video_timing__h_sync;
        video_bus__display_enable = video_timing__display_enable;
        video_bus__red = video_state__red;
        video_bus__green = video_state__green;
        video_bus__blue = video_state__blue;
    end //always

    //b video_bus_out__posedge_video_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge video_clk or negedge reset_n)
    begin : video_bus_out__posedge_video_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            video_state__red <= 8'h0;
            video_state__green <= 8'h0;
            video_state__blue <= 8'h0;
        end
        else if (video_clk__enable)
        begin
            if ((video_timing__will_display_enable!=1'h0))
            begin
                video_state__red <= pixel_combs__red;
                video_state__green <= pixel_combs__green;
                video_state__blue <= pixel_combs__blue;
            end //if
        end //if
    end //always

    //b pixel_data_logic__comb combinatorial process
        //   
        //       The pixel data shift register is consumed on
        //       'video_timing.will_display_pixels' When it becomes empty, it
        //       attempts to load from the pixel buffer.
        //   
        //       The pixel data buffer
        //       
    always @ ( * )//pixel_data_logic__comb
    begin: pixel_data_logic__comb_code
    reg [4:0]pixel_combs__next_num_valid__var;
    reg [7:0]pixel_combs__red__var;
    reg [7:0]pixel_combs__green__var;
    reg [7:0]pixel_combs__blue__var;
        pixel_combs__next_num_valid__var = (pixel_state__num_valid-5'h1);
        if ((1'h0!=64'h0))
        begin
            pixel_combs__next_num_valid__var = (pixel_state__num_valid-5'h2);
        end //if
        if ((pixel_state__num_valid==5'h0))
        begin
            pixel_combs__next_num_valid__var = 5'h0;
        end //if
        if (!(video_timing__will_display_enable!=1'h0))
        begin
            pixel_combs__next_num_valid__var = pixel_state__num_valid;
        end //if
        pixel_combs__sram_address_next_line = (pixel_state__sram_address_line_start+csrs__sram_words_per_line[13:0]);
        pixel_combs__load_shift_register = ((pixel_state__data_buffer_full!=1'h0)&&(pixel_combs__next_num_valid__var==5'h0));
        pixel_combs__sram_request = ((((video_timing__v_displaying!=1'h0)&&!(video_timing__h_sync!=1'h0))&&!(pixel_state__data_buffer_full!=1'h0))&&!(pixel_state__request_outstanding!=1'h0));
        pixel_combs__red__var = 8'h0;
        pixel_combs__green__var = 8'h0;
        pixel_combs__blue__var = 8'h0;
        if ((pixel_state__shift__red[11]!=1'h0))
        begin
            pixel_combs__red__var = 8'hff;
        end //if
        if ((pixel_state__shift__green[11]!=1'h0))
        begin
            pixel_combs__green__var = 8'hff;
        end //if
        if ((pixel_state__shift__blue[11]!=1'h0))
        begin
            pixel_combs__blue__var = 8'hff;
        end //if
        pixel_combs__tt_char__valid = pixel_state__reading_sram;
        pixel_combs__tt_char__character = pixel_read_data[6:0];
        pixel_combs__next_num_valid = pixel_combs__next_num_valid__var;
        pixel_combs__red = pixel_combs__red__var;
        pixel_combs__green = pixel_combs__green__var;
        pixel_combs__blue = pixel_combs__blue__var;
    end //always

    //b pixel_data_logic__posedge_video_clk_active_low_reset_n clock process
        //   
        //       The pixel data shift register is consumed on
        //       'video_timing.will_display_pixels' When it becomes empty, it
        //       attempts to load from the pixel buffer.
        //   
        //       The pixel data buffer
        //       
    always @( posedge video_clk or negedge reset_n)
    begin : pixel_data_logic__posedge_video_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            pixel_state__reading_sram <= 1'h0;
            pixel_state__request_outstanding <= 1'h0;
            pixel_state__shift__red <= 12'h0;
            pixel_state__shift__green <= 12'h0;
            pixel_state__shift__blue <= 12'h0;
            pixel_state__num_valid <= 5'h0;
            pixel_state__data_buffer_full <= 1'h0;
            pixel_state__data_buffer__red <= 12'h0;
            pixel_state__data_buffer__green <= 12'h0;
            pixel_state__data_buffer__blue <= 12'h0;
            pixel_state__sram_address <= 14'h0;
            pixel_state__sram_address_line_start <= 14'h0;
        end
        else if (video_clk__enable)
        begin
            pixel_state__reading_sram <= 1'h0;
            if ((pixel_combs__sram_request!=1'h0))
            begin
                pixel_state__request_outstanding <= 1'h1;
                pixel_state__reading_sram <= 1'h1;
            end //if
            if ((tt_pixels__valid!=1'h0))
            begin
                pixel_state__request_outstanding <= 1'h0;
            end //if
            if ((video_timing__will_display_enable!=1'h0))
            begin
                pixel_state__shift__red[11:1] <= pixel_state__shift__red[10:0];
                pixel_state__shift__green[11:1] <= pixel_state__shift__green[10:0];
                pixel_state__shift__blue[11:1] <= pixel_state__shift__blue[10:0];
                if ((1'h0!=64'h0))
                begin
                    pixel_state__shift__red[11:2] <= pixel_state__shift__red[9:0];
                    pixel_state__shift__green[11:2] <= pixel_state__shift__green[9:0];
                    pixel_state__shift__blue[11:2] <= pixel_state__shift__blue[9:0];
                end //if
                pixel_state__num_valid <= pixel_combs__next_num_valid;
            end //if
            if ((pixel_combs__load_shift_register!=1'h0))
            begin
                pixel_state__shift__red <= pixel_state__data_buffer__red;
                pixel_state__shift__green <= pixel_state__data_buffer__green;
                pixel_state__shift__blue <= pixel_state__data_buffer__blue;
                pixel_state__data_buffer_full <= 1'h0;
                pixel_state__num_valid <= 5'hc;
            end //if
            if ((tt_pixels__valid!=1'h0))
            begin
                pixel_state__data_buffer__red <= tt_pixels__red;
                pixel_state__data_buffer__green <= tt_pixels__green;
                pixel_state__data_buffer__blue <= tt_pixels__blue;
                pixel_state__data_buffer_full <= 1'h1;
                pixel_state__sram_address <= (pixel_state__sram_address+14'h1);
            end //if
            if ((video_timing__will_h_sync!=1'h0))
            begin
                pixel_state__data_buffer_full <= 1'h0;
                pixel_state__num_valid <= 5'h0;
                if ((video_timing__v_displaying!=1'h0))
                begin
                    pixel_state__sram_address <= pixel_state__sram_address_line_start;
                    pixel_state__sram_address_line_start <= pixel_state__sram_address_line_start;
                    if ((tt_pixels__last_scanline!=1'h0))
                    begin
                        pixel_state__sram_address <= pixel_combs__sram_address_next_line;
                        pixel_state__sram_address_line_start <= pixel_combs__sram_address_next_line;
                    end //if
                end //if
                if ((video_timing__v_frame_last_line!=1'h0))
                begin
                    pixel_state__sram_address <= csrs__sram_base_address[13:0];
                    pixel_state__sram_address_line_start <= csrs__sram_base_address[13:0];
                end //if
            end //if
        end //if
    end //always

    //b sram_write_logic clock process
        //   
        //       Take the SRAM write bus, register it, then write in the data
        //       
    always @( posedge sram_clk or negedge reset_n)
    begin : sram_write_logic__code
        if (reset_n==1'b0)
        begin
            sram_state__write_request__enable <= 1'h0;
            sram_state__write_request__data <= 48'h0;
            sram_state__write_request__address <= 16'h0;
        end
        else if (sram_clk__enable)
        begin
            sram_state__write_request__enable <= 1'h0;
            if ((display_sram_write__enable!=1'h0))
            begin
                sram_state__write_request__enable <= display_sram_write__enable;
                sram_state__write_request__data <= display_sram_write__data;
                sram_state__write_request__address <= display_sram_write__address;
            end //if
        end //if
    end //always

    //b teletext_logic clock process
        //   
        //       
    always @( posedge video_clk or negedge reset_n)
    begin : teletext_logic__code
        if (reset_n==1'b0)
        begin
            tt_timings__interpolate_vertical <= 2'h0;
            tt_timings__first_scanline_of_row <= 1'h0;
            tt_timings__end_of_scanline <= 1'h0;
            tt_timings__restart_frame <= 1'h0;
            tt_timings__smoothe <= 1'h0;
        end
        else if (video_clk__enable)
        begin
            tt_timings__interpolate_vertical <= 2'h1;
            tt_timings__first_scanline_of_row <= 1'h0;
            tt_timings__end_of_scanline <= video_timing__h_sync;
            tt_timings__restart_frame <= video_timing__v_sync;
            tt_timings__smoothe <= 1'h1;
        end //if
    end //always

    //b csr_interface_logic__comb combinatorial process
        //   
        //       Basic CSRS - it should all be writable...
        //       
    always @ ( * )//csr_interface_logic__comb
    begin: csr_interface_logic__comb_code
    reg csr_response__acknowledge__var;
    reg csr_response__read_data_valid__var;
    reg csr_response__read_data_error__var;
    reg [31:0]csr_response__read_data__var;
        csr_response__acknowledge__var = local_csr_response__acknowledge;
        csr_response__read_data_valid__var = local_csr_response__read_data_valid;
        csr_response__read_data_error__var = local_csr_response__read_data_error;
        csr_response__read_data__var = local_csr_response__read_data;
        csr_response__acknowledge__var = csr_response__acknowledge__var | timing_csr_response__acknowledge;
        csr_response__read_data_valid__var = csr_response__read_data_valid__var | timing_csr_response__read_data_valid;
        csr_response__read_data_error__var = csr_response__read_data_error__var | timing_csr_response__read_data_error;
        csr_response__read_data__var = csr_response__read_data__var | timing_csr_response__read_data;
        csr_read_data = 32'h0;
        csr_response__acknowledge = csr_response__acknowledge__var;
        csr_response__read_data_valid = csr_response__read_data_valid__var;
        csr_response__read_data_error = csr_response__read_data_error__var;
        csr_response__read_data = csr_response__read_data__var;
    end //always

    //b csr_interface_logic__posedge_csr_clk_active_low_reset_n clock process
        //   
        //       Basic CSRS - it should all be writable...
        //       
    always @( posedge csr_clk or negedge reset_n)
    begin : csr_interface_logic__posedge_csr_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            csr_select <= 16'h4;
            csrs__sram_base_address <= 16'h0;
            csrs__sram_words_per_line <= 16'h0;
            csrs__sram_words_per_line <= 16'h28;
        end
        else if (csr_clk__enable)
        begin
            if ((csr_select_in!=16'h0))
            begin
                csr_select <= csr_select_in;
            end //if
            csrs__sram_base_address <= csrs__sram_base_address;
            csrs__sram_words_per_line <= csrs__sram_words_per_line;
            if (((csr_access__valid!=1'h0)&&!(csr_access__read_not_write!=1'h0)))
            begin
                case (csr_access__address[3:0]) //synopsys parallel_case
                4'h0: // req 1
                    begin
                    csrs__sram_base_address <= csr_access__data[15:0];
                    end
                4'h1: // req 1
                    begin
                    csrs__sram_words_per_line <= csr_access__data[15:0];
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

endmodule // framebuffer_teletext
