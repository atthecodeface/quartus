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

//a Module framebuffer
    //   
    //   This is a module that takes SRAM writes into a
    //   framebuffer, and includes a mapping to a dual-port SRAM (write on
    //   one side, read on the other), where the video side drives out
    //   vsync, hsync, data enable and pixel data.
    //   
    //   The video side is asynchronous to the SRAM write side.
    //   
    //   The video output side has a programmable horizontal period that
    //   starts with hsync high for one clock, and then has a programmable
    //   back porch, followed by a programmable number of pixels (with data
    //   out enabled only if on the correct vertical portion of the display),
    //   followed by a programmable front porch, repeating.
    //   
    //   The video output side has a programmable vertical period that is in
    //   units of horizontal period; it starts with vsync high for one
    //   horizontal period, and then has a programmable front porch,
    //   followed by a programmable number of displayed lined, followed by a
    //   programmable front porch, repeating.
    //   
    //   The video output start at a programmable base address in SRAM;
    //   moving down a line adds a programmable amount to the address in
    //   SRAM.
    //   
    //   The framebuffer uses a @a framebuffer_timing module to generate video
    //   sync signals and other controls.
    //   
    //   The module generates output pixel data from a shift register and a
    //   data buffer that fill from an internal dual-port SRAM, using the video
    //   timing.
    //   
    //   The SRAM is filled with SRAM write requests, using a different clock
    //   to the video generation.
    //   
module framebuffer
(
    video_clk,
    video_clk__enable,
    sram_clk,
    sram_clk__enable,
    csr_clk,
    csr_clk__enable,

    csr_select,
    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    display_sram_write__valid,
    display_sram_write__id,
    display_sram_write__read_not_write,
    display_sram_write__byte_enable,
    display_sram_write__address,
    display_sram_write__write_data,
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
    input [15:0]csr_select;
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
    input display_sram_write__valid;
    input [3:0]display_sram_write__id;
    input display_sram_write__read_not_write;
    input [7:0]display_sram_write__byte_enable;
    input [31:0]display_sram_write__address;
    input [63:0]display_sram_write__write_data;
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
        //   Pixel state, in the video clock domain, to generate the pixel data out
    reg [4:0]pixel_state__num_valid;
    reg [13:0]pixel_state__sram_address;
    reg [13:0]pixel_state__sram_address_line_start;
    reg pixel_state__data_buffer_full;
    reg pixel_state__load_data_buffer;
    reg [15:0]pixel_state__shift__red;
    reg [15:0]pixel_state__shift__green;
    reg [15:0]pixel_state__shift__blue;
    reg [15:0]pixel_state__data_buffer__red;
    reg [15:0]pixel_state__data_buffer__green;
    reg [15:0]pixel_state__data_buffer__blue;
    reg [7:0]pixel_state__red;
    reg [7:0]pixel_state__green;
    reg [7:0]pixel_state__blue;
        //   State in the SRAM clock domain - the SRAM write to be performed
    reg sram_state__write_request__valid;
    reg [3:0]sram_state__write_request__id;
    reg sram_state__write_request__read_not_write;
    reg [7:0]sram_state__write_request__byte_enable;
    reg [31:0]sram_state__write_request__address;
    reg [63:0]sram_state__write_request__write_data;
        //   Control/status registers local to this module
    reg [15:0]csrs__sram_base_address;
    reg [15:0]csrs__sram_words_per_line;
    reg csrs__down_sample_x;

    //b Internal combinatorials
        //   Combinatorial decode of the pixel state
    reg [7:0]pixel_combs__red;
    reg [7:0]pixel_combs__green;
    reg [7:0]pixel_combs__blue;
    reg [4:0]pixel_combs__next_num_valid;
    reg [13:0]pixel_combs__sram_address_next_line;
    reg pixel_combs__load_shift_register;
    reg pixel_combs__sram_request;
        //   CSR read data from this module
    reg [31:0]csr_read_data;

    //b Internal nets
        //   Data read from the framebuffer; currently always intepreted as bundle(16 blue, 16 green, 16 red)
    wire [47:0]pixel_read_data;
        //   Video timing syncs and controls
    wire video_timing__v_sync;
    wire video_timing__h_sync;
    wire video_timing__will_h_sync;
    wire video_timing__v_displaying;
    wire video_timing__display_required;
    wire video_timing__will_display_enable;
    wire video_timing__display_enable;
    wire video_timing__v_frame_last_line;
        //   CSR access for this module
    wire csr_access__valid;
    wire csr_access__read_not_write;
    wire [15:0]csr_access__address;
    wire [31:0]csr_access__data;
        //   Pipelined CSR response interface to control the module
    wire csr_response_local__acknowledge;
    wire csr_response_local__read_data_valid;
    wire csr_response_local__read_data_error;
    wire [31:0]csr_response_local__read_data;
        //   Pipelined CSR response interface to control the module
    wire csr_response_timing__acknowledge;
    wire csr_response_timing__read_data_valid;
    wire csr_response_timing__read_data_error;
    wire [31:0]csr_response_timing__read_data;

    //b Clock gating module instances
    //b Module instances
    framebuffer_timing ftiming(
        .video_clk(video_clk),
        .video_clk__enable(1'b1),
        .csr_clk(csr_clk),
        .csr_clk__enable(1'b1),
        .csr_select({csr_select[15:1],1'h0}),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .reset_n(reset_n),
        .csr_response__read_data(            csr_response_timing__read_data),
        .csr_response__read_data_error(            csr_response_timing__read_data_error),
        .csr_response__read_data_valid(            csr_response_timing__read_data_valid),
        .csr_response__acknowledge(            csr_response_timing__acknowledge),
        .video_timing__v_frame_last_line(            video_timing__v_frame_last_line),
        .video_timing__display_enable(            video_timing__display_enable),
        .video_timing__will_display_enable(            video_timing__will_display_enable),
        .video_timing__display_required(            video_timing__display_required),
        .video_timing__v_displaying(            video_timing__v_displaying),
        .video_timing__will_h_sync(            video_timing__will_h_sync),
        .video_timing__h_sync(            video_timing__h_sync),
        .video_timing__v_sync(            video_timing__v_sync)         );
    se_sram_mrw_2_16384x48 display(
        .sram_clock_1(video_clk),
        .sram_clock_1__enable(1'b1),
        .sram_clock_0(sram_clk),
        .sram_clock_0__enable(1'b1),
        .write_data_1(48'h0),
        .address_1(pixel_state__sram_address[13:0]),
        .read_not_write_1(1'h1),
        .select_1(pixel_combs__sram_request),
        .write_data_0(sram_state__write_request__write_data[47:0]),
        .address_0(sram_state__write_request__address[13:0]),
        .read_not_write_0(1'h0),
        .select_0(sram_state__write_request__valid),
        .data_out_1(            pixel_read_data)         );
    csr_target_csr csri(
        .clk(csr_clk),
        .clk__enable(1'b1),
        .csr_select({csr_select[15:1],1'h1}),
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
        .csr_response__read_data(            csr_response_local__read_data),
        .csr_response__read_data_error(            csr_response_local__read_data_error),
        .csr_response__read_data_valid(            csr_response_local__read_data_valid),
        .csr_response__acknowledge(            csr_response_local__acknowledge)         );
    //b pixel_data_logic__comb combinatorial process
        //   
        //       The framebuffer timing is handled by a subomdule; this generates
        //       sync and other timing signals.
        //   
        //       The pixel data buffer is cleared after the display portion of a
        //       scanline, and loaded for scanlines that are being displayed
        //       whenever it is empty.
        //   
        //       The pixel data shift register is copied from the pixel data buffer
        //       when it empties, and shifts down when pixels are to be displayed.
        //   
        //       The pixel data buffer is loaded from an SRAM, which returns data
        //       in the cycle after request. Hence the SRAM is read only when the
        //       pixel data buffer is empty _and_ the SRAM is not being read; this
        //       requires a minimum back porch time of about 3 clock ticks, and a
        //       maximum data consumption rate of one SRAM word every 3 clock
        //       ticks. Faster than this and the mechanism here does not keep
        //       up. This is not an issue currently as the maximum data consumption
        //       rate is with down-samping by a factor of 2 - hence 8 ticks between
        //       shift register emptying.
        //       
    always @ ( * )//pixel_data_logic__comb
    begin: pixel_data_logic__comb_code
    reg [4:0]pixel_combs__next_num_valid__var;
    reg [7:0]pixel_combs__red__var;
    reg [7:0]pixel_combs__green__var;
    reg [7:0]pixel_combs__blue__var;
        pixel_combs__next_num_valid__var = (pixel_state__num_valid-5'h1);
        if ((csrs__down_sample_x!=1'h0))
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
        pixel_combs__sram_request = ((video_timing__v_displaying!=1'h0)&&!((pixel_state__data_buffer_full!=1'h0)||(pixel_state__load_data_buffer!=1'h0)));
        pixel_combs__red__var = 8'h0;
        pixel_combs__green__var = 8'h0;
        pixel_combs__blue__var = 8'h0;
        if ((pixel_state__shift__red[15]!=1'h0))
        begin
            pixel_combs__red__var = 8'hff;
        end //if
        if ((pixel_state__shift__green[15]!=1'h0))
        begin
            pixel_combs__green__var = 8'hff;
        end //if
        if ((pixel_state__shift__blue[15]!=1'h0))
        begin
            pixel_combs__blue__var = 8'hff;
        end //if
        pixel_combs__next_num_valid = pixel_combs__next_num_valid__var;
        pixel_combs__red = pixel_combs__red__var;
        pixel_combs__green = pixel_combs__green__var;
        pixel_combs__blue = pixel_combs__blue__var;
    end //always

    //b pixel_data_logic__posedge_video_clk_active_low_reset_n clock process
        //   
        //       The framebuffer timing is handled by a subomdule; this generates
        //       sync and other timing signals.
        //   
        //       The pixel data buffer is cleared after the display portion of a
        //       scanline, and loaded for scanlines that are being displayed
        //       whenever it is empty.
        //   
        //       The pixel data shift register is copied from the pixel data buffer
        //       when it empties, and shifts down when pixels are to be displayed.
        //   
        //       The pixel data buffer is loaded from an SRAM, which returns data
        //       in the cycle after request. Hence the SRAM is read only when the
        //       pixel data buffer is empty _and_ the SRAM is not being read; this
        //       requires a minimum back porch time of about 3 clock ticks, and a
        //       maximum data consumption rate of one SRAM word every 3 clock
        //       ticks. Faster than this and the mechanism here does not keep
        //       up. This is not an issue currently as the maximum data consumption
        //       rate is with down-samping by a factor of 2 - hence 8 ticks between
        //       shift register emptying.
        //       
    always @( posedge video_clk or negedge reset_n)
    begin : pixel_data_logic__posedge_video_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            pixel_state__load_data_buffer <= 1'h0;
            pixel_state__shift__red <= 16'h0;
            pixel_state__shift__green <= 16'h0;
            pixel_state__shift__blue <= 16'h0;
            pixel_state__num_valid <= 5'h0;
            pixel_state__red <= 8'h0;
            pixel_state__green <= 8'h0;
            pixel_state__blue <= 8'h0;
            pixel_state__data_buffer_full <= 1'h0;
            pixel_state__data_buffer__red <= 16'h0;
            pixel_state__data_buffer__green <= 16'h0;
            pixel_state__data_buffer__blue <= 16'h0;
            pixel_state__sram_address <= 14'h0;
            pixel_state__sram_address_line_start <= 14'h0;
        end
        else if (video_clk__enable)
        begin
            pixel_state__load_data_buffer <= pixel_combs__sram_request;
            if ((video_timing__will_display_enable!=1'h0))
            begin
                pixel_state__shift__red[15:1] <= pixel_state__shift__red[14:0];
                pixel_state__shift__green[15:1] <= pixel_state__shift__green[14:0];
                pixel_state__shift__blue[15:1] <= pixel_state__shift__blue[14:0];
                if ((csrs__down_sample_x!=1'h0))
                begin
                    pixel_state__shift__red[15:2] <= pixel_state__shift__red[13:0];
                    pixel_state__shift__green[15:2] <= pixel_state__shift__green[13:0];
                    pixel_state__shift__blue[15:2] <= pixel_state__shift__blue[13:0];
                end //if
                pixel_state__num_valid <= pixel_combs__next_num_valid;
                pixel_state__red <= pixel_combs__red;
                pixel_state__green <= pixel_combs__green;
                pixel_state__blue <= pixel_combs__blue;
            end //if
            if ((pixel_combs__load_shift_register!=1'h0))
            begin
                pixel_state__shift__red <= pixel_state__data_buffer__red;
                pixel_state__shift__green <= pixel_state__data_buffer__green;
                pixel_state__shift__blue <= pixel_state__data_buffer__blue;
                pixel_state__data_buffer_full <= 1'h0;
                pixel_state__num_valid <= 5'h10;
            end //if
            if ((pixel_state__load_data_buffer!=1'h0))
            begin
                pixel_state__data_buffer__red <= pixel_read_data[15:0];
                pixel_state__data_buffer__green <= pixel_read_data[31:16];
                pixel_state__data_buffer__blue <= pixel_read_data[47:32];
                pixel_state__data_buffer_full <= 1'h1;
                pixel_state__sram_address <= (pixel_state__sram_address+14'h1);
            end //if
            if ((video_timing__will_h_sync!=1'h0))
            begin
                pixel_state__data_buffer_full <= 1'h0;
                pixel_state__num_valid <= 5'h0;
                if ((video_timing__v_displaying!=1'h0))
                begin
                    pixel_state__sram_address <= pixel_combs__sram_address_next_line;
                    pixel_state__sram_address_line_start <= pixel_combs__sram_address_next_line;
                end //if
                if ((video_timing__v_sync!=1'h0))
                begin
                    pixel_state__sram_address <= csrs__sram_base_address[13:0];
                    pixel_state__sram_address_line_start <= csrs__sram_base_address[13:0];
                end //if
            end //if
        end //if
    end //always

    //b video_bus_out combinatorial process
        //   
        //       The CSR responses can be combined with wire-OR; since these are
        //       lightweight modules there is no need to register the response for
        //       timing purposes.
        //   
        //       The video output signals come in part from the pixel state and
        //       from the framebuffer timing module.
        //       
    always @ ( * )//video_bus_out
    begin: video_bus_out__comb_code
    reg csr_response__acknowledge__var;
    reg csr_response__read_data_valid__var;
    reg csr_response__read_data_error__var;
    reg [31:0]csr_response__read_data__var;
        csr_response__acknowledge__var = csr_response_timing__acknowledge;
        csr_response__read_data_valid__var = csr_response_timing__read_data_valid;
        csr_response__read_data_error__var = csr_response_timing__read_data_error;
        csr_response__read_data__var = csr_response_timing__read_data;
        csr_response__acknowledge__var = csr_response__acknowledge__var | csr_response_local__acknowledge;
        csr_response__read_data_valid__var = csr_response__read_data_valid__var | csr_response_local__read_data_valid;
        csr_response__read_data_error__var = csr_response__read_data_error__var | csr_response_local__read_data_error;
        csr_response__read_data__var = csr_response__read_data__var | csr_response_local__read_data;
        video_bus__vsync = video_timing__v_sync;
        video_bus__hsync = video_timing__h_sync;
        video_bus__display_enable = video_timing__display_enable;
        video_bus__red = pixel_state__red;
        video_bus__green = pixel_state__green;
        video_bus__blue = pixel_state__blue;
        csr_response__acknowledge = csr_response__acknowledge__var;
        csr_response__read_data_valid = csr_response__read_data_valid__var;
        csr_response__read_data_error = csr_response__read_data_error__var;
        csr_response__read_data = csr_response__read_data__var;
    end //always

    //b sram_write_logic clock process
        //   
        //       Take the SRAM write bus, register it, then write in the data
        //       
    always @( posedge sram_clk or negedge reset_n)
    begin : sram_write_logic__code
        if (reset_n==1'b0)
        begin
            sram_state__write_request__valid <= 1'h0;
            sram_state__write_request__id <= 4'h0;
            sram_state__write_request__read_not_write <= 1'h0;
            sram_state__write_request__byte_enable <= 8'h0;
            sram_state__write_request__address <= 32'h0;
            sram_state__write_request__write_data <= 64'h0;
        end
        else if (sram_clk__enable)
        begin
            sram_state__write_request__valid <= 1'h0;
            if ((display_sram_write__valid!=1'h0))
            begin
                sram_state__write_request__valid <= display_sram_write__valid;
                sram_state__write_request__id <= display_sram_write__id;
                sram_state__write_request__read_not_write <= display_sram_write__read_not_write;
                sram_state__write_request__byte_enable <= display_sram_write__byte_enable;
                sram_state__write_request__address <= display_sram_write__address;
                sram_state__write_request__write_data <= display_sram_write__write_data;
            end //if
        end //if
    end //always

    //b csr_interface_logic__comb combinatorial process
        //   
        //       Basic read-write control status registers, using a CSR target
        //       interface and CSR access.
        //       
    always @ ( * )//csr_interface_logic__comb
    begin: csr_interface_logic__comb_code
    reg [31:0]csr_read_data__var;
        csr_read_data__var = 32'h0;
        case (csr_access__address[3:0]) //synopsys parallel_case
        4'h0: // req 1
            begin
            csr_read_data__var = {16'h0,csrs__sram_base_address};
            end
        4'h1: // req 1
            begin
            csr_read_data__var = {{15'h0,csrs__down_sample_x},csrs__sram_words_per_line};
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
        //       Basic read-write control status registers, using a CSR target
        //       interface and CSR access.
        //       
    always @( posedge csr_clk or negedge reset_n)
    begin : csr_interface_logic__posedge_csr_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            csrs__sram_base_address <= 16'h0;
            csrs__sram_words_per_line <= 16'h0;
            csrs__sram_words_per_line <= 16'h28;
            csrs__down_sample_x <= 1'h0;
            csrs__down_sample_x <= 1'h1;
        end
        else if (csr_clk__enable)
        begin
            csrs__sram_base_address <= csrs__sram_base_address;
            csrs__sram_words_per_line <= csrs__sram_words_per_line;
            csrs__down_sample_x <= csrs__down_sample_x;
            case (csr_access__address[3:0]) //synopsys parallel_case
            4'h0: // req 1
                begin
                if (((csr_access__valid!=1'h0)&&!(csr_access__read_not_write!=1'h0)))
                begin
                    csrs__sram_base_address <= csr_access__data[15:0];
                end //if
                end
            4'h1: // req 1
                begin
                if (((csr_access__valid!=1'h0)&&!(csr_access__read_not_write!=1'h0)))
                begin
                    csrs__down_sample_x <= csr_access__data[16];
                    csrs__sram_words_per_line <= csr_access__data[15:0];
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

endmodule // framebuffer
