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

//a Module teletext
    //   
    //   This is an implementaion of the core of a presentation level 1.0
    //   teletext decoder, for arbitrary sized teletext output displays.
    //   
    //   The output is supplied at 12 pixels per clock (one character width)
    //   The input is a byte of per clock of character data.
    //   
    //   The implementation does not currently support double width or
    //   double size characters - they are not presentation level 1.0 features.
    //   
    //   Teletext characters are displayed from a 12x20 grid. The ROM
    //   characters have two background rows, and then are displayed with 2
    //   background pixels on the left, and then 10 pixels from the ROM The ROM
    //   is actually 5x9, and it is doubled to 10x18.
    //   
    //   The type of pixel doubling is controlled with the @a timings input. It
    //   can be pure doubling, or smoothed. Some outputs may not want to use
    //   the doubling, for which the best approach is to request only even
    //   scanlines (in the @a timings) and to not smoothe, and then to select
    //   alternate pixel color values from the output bus.
    //   
    //   ### Doubling
    //   
    //   Doubling without smoothing can be achieved be true doubling of pixels
    //   
    //   A simple smoothing can be performed for a pixel depending on its NSEW neighbors:
    //   
    //   
    //         |NN|
    //         |NN|
    //       WW|ab|EE
    //       WW|cd|EE
    //         |SS|
    //         |SS|
    //   
    //   * a is filled if the pixel is filled itself, or if N&W
    //   
    //   * b is filled if the pixel is filled itself, or if N&E
    //   
    //   * c is filled if the pixel is filled itself, or if S&W
    //   
    //   * d is filled if the pixel is filled itself, or if S&E
    //   
    //   Hence one would get:
    //   
    //       |..|**|**|**|..|
    //       |..|**|**|**|..|
    //       |---------------
    //       |**|..|..|**|**|
    //       |**|..|..|**|**|
    //       |---------------
    //       |..|**|..|..|**|
    //       |..|**|..|..|**|
    //   
    //   smoothed to:
    //   
    //       |..|**|**|**|..|
    //       |.*|**|**|**|*.|
    //       |---------------
    //       |**|*.|.*|**|**|
    //       |**|*.|..|**|**|
    //       |---------------
    //       |.*|**|..|.*|**|
    //       |..|**|..|..|**|
    //   
    //   Or, without intervening lines:
    //   
    //       |..******..|
    //       |..******..|
    //       |**....****|
    //       |**....****|
    //       |..**....**|
    //       |..**....**|
    //   
    //   smoothed to:
    //   
    //       |..******..|
    //       |.********.|
    //       |***..*****|
    //       |***...****|
    //       |.***...***|
    //       |..**....**|
    //   
    //   So for even scanlines ('a' and 'b') the smoother needs row n and row n-1.
    //   
    //   * a is set if n[x] or n[x-left]&(n-1)[x]
    //   
    //   * b is set if n[x] or n[x-right]&(n-1)[x]
    //   
    //   For odd scanlines ('c' and 'd') the smoother needs row n and row n+1.
    //   
    //   * c is set if n[x] or n[x-left]&(n+1)[x]
    //   
    //   * d is set if n[x] or n[x-right]&(n+1)[x]
    //   
    //   This method has the unfortunate impact of smoothing two crossing lines, such as a plus:
    //   
    //       |....**....|     |....**....|
    //       |....**....|     |....**....|
    //       |....**....|     |....**....|
    //       |....**....|     |...****...|
    //       |**********|     |**********|
    //       |**********|     |**********|
    //       |....**....|     |...****...|
    //       |....**....|     |....**....|
    //       |....**....|     |....**....|
    //       |....**....|     |....**....|
    //   
    //   
    //   Hence a better smoothing can be performed for a pixel depending on all its neighbors:
    //   
    //       |NW|NN|NE|
    //       |  |NN|  |
    //       |WW|ab|EE|
    //       |WW|cd|EE|
    //       |  |SS|  |
    //       |SW|SS|SE|
    //   
    //   * a is filled if the pixel is filled itself, or if (N&W) but not NW
    //   
    //   * b is filled if the pixel is filled itself, or if (N&E) but not NE
    //   
    //   * c is filled if the pixel is filled itself, or if (S&W) but not SW
    //   
    //   * d is filled if the pixel is filled itself, or if (S&E) but not SE
    //   
    //   Hence one would get:
    //   
    //       |..|**|**|**|..|
    //       |..|**|**|**|..|
    //       |---------------
    //       |**|..|..|**|**|
    //       |**|..|..|**|**|
    //       |---------------
    //       |..|**|..|..|**|
    //       |..|**|..|..|**|
    //   
    //   smoothed to:
    //   
    //       |..|**|**|**|..|
    //       |.*|**|**|**|..|
    //       |---------------
    //       |**|*.|..|**|**|
    //       |**|*.|..|**|**|
    //       |---------------
    //       |.*|**|..|..|**|
    //       |..|**|..|..|**|
    //   
    //   Or, without intervening lines:
    //   
    //       |..******..|
    //       |..******..|
    //       |**....****|
    //       |**....****|
    //       |..**....**|
    //       |..**....**|
    //   
    //   smoothed to:
    //   
    //       |..******..|
    //       |.*******..|
    //       |***...****|
    //       |***...****|
    //       |.***....**|
    //       |..**....**|
    //   
    //   So for even scanlines ('a' and 'b') the smoother needs row n and row n-1.
    //   
    //   *a is set if n[x] or (n[x-left]&(n-1)[x]) &~ (n-1)[x-left]
    //   
    //   *b is set if n[x] or (n[x-right]&(n-1)[x]) &~ (n-1)[x-right]
    //   
    //   For odd scanlines ('c' and 'd') the smoother needs row n and row n+1.
    //   
    //   *c is set if n[x] or (n[x-left]&(n+1)[x]) &~ (n+1)[x-left]
    //   
    //   *d is set if n[x] or (n[x-right]&(n+1)[x]) &~ (n+1)[x-left]
    //   
    //   
    //   ## Graphics
    //   Graphics characters are 6 blobs on a 6x10 grid (contiguous, separated):
    //   
    //       |000111| |.00.11|
    //       |000111| |.00.11|
    //       |000111| |......|
    //       |222333| |.22.33|
    //       |222333| |.22.33|
    //       |222333| |.22.33|
    //       |222333| |......|
    //       |444555| |.44.55|
    //       |444555| |.44.55|
    //       |444555| |......|
    //   
    //   
module teletext
(
    clk,
    clk__enable,

    rom_data,
    timings__restart_frame,
    timings__end_of_scanline,
    timings__first_scanline_of_row,
    timings__smoothe,
    timings__interpolate_vertical,
    character__valid,
    character__character,
    reset_n,

    pixels__valid,
    pixels__red,
    pixels__green,
    pixels__blue,
    pixels__last_scanline,
    rom_access__select,
    rom_access__address
);

    //b Clocks
        //   Character clock
    input clk;
    input clk__enable;

    //b Inputs
        //   Teletext ROM data, valid in cycle after rom_access
    input [44:0]rom_data;
        //   Timings for the scanline, row, etc
    input timings__restart_frame;
    input timings__end_of_scanline;
    input timings__first_scanline_of_row;
    input timings__smoothe;
    input [1:0]timings__interpolate_vertical;
        //   Parallel character data in, with valid signal
    input character__valid;
    input [6:0]character__character;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Output pixels, three clock ticks delayed from valid data in
    output pixels__valid;
    output [11:0]pixels__red;
    output [11:0]pixels__green;
    output [11:0]pixels__blue;
    output pixels__last_scanline;
        //   Teletext ROM access, registered output
    output rom_access__select;
    output [6:0]rom_access__address;

// output components here

    //b Output combinatorials
        //   Output pixels, three clock ticks delayed from valid data in
    reg pixels__valid;
    reg [11:0]pixels__red;
    reg [11:0]pixels__green;
    reg [11:0]pixels__blue;
    reg pixels__last_scanline;
        //   Teletext ROM access, registered output
    reg rom_access__select;
    reg [6:0]rom_access__address;

    //b Output nets

    //b Internal and output registers
        //   State from which the pixels are generated; registered data from the @a teletext_combs
    reg [9:0]pixel_state__rom_scanline_data;
    reg pixel_state__character__valid;
    reg [6:0]pixel_state__character__character;
    reg [2:0]pixel_state__character_state__background_color;
    reg [2:0]pixel_state__character_state__foreground_color;
    reg pixel_state__character_state__flashing;
    reg pixel_state__character_state__text_mode;
    reg pixel_state__character_state__contiguous_graphics;
    reg pixel_state__character_state__double_height;
    reg pixel_state__character_state__hold_graphics_mode;
    reg pixel_state__character_state__reset_held_graphics;
    reg [4:0]pixel_state__pixel_scanline;
    reg [11:0]pixel_state__graphics_data;
    reg pixel_state__use_graphics_data;
    reg [11:0]pixel_state__held_graphics_data;
        //   Teletext character state and graphics decode, one cycle later than @a character_buffer
    reg teletext_state__character__valid;
    reg [6:0]teletext_state__character__character;
    reg [2:0]teletext_state__character_state__background_color;
    reg [2:0]teletext_state__character_state__foreground_color;
    reg teletext_state__character_state__flashing;
    reg teletext_state__character_state__text_mode;
    reg teletext_state__character_state__contiguous_graphics;
    reg teletext_state__character_state__double_height;
    reg teletext_state__character_state__hold_graphics_mode;
    reg teletext_state__character_state__reset_held_graphics;
    reg teletext_state__row_contains_double_height;
    reg teletext_state__last_row_was_double_height_top;
    reg [4:0]teletext_state__pixel_scanline;
        //   Character buffer to hold data while presenting ROM access
    reg character_buffer__valid;
    reg [6:0]character_buffer__character;
        //   Record of which scanline and flashing, and so on; valid throughout a scanline
    reg [4:0]timing_state__scanline;
    reg timing_state__last_scanline;
    reg timing_state__timings__restart_frame;
    reg timing_state__timings__end_of_scanline;
    reg timing_state__timings__first_scanline_of_row;
    reg timing_state__timings__smoothe;
    reg [1:0]timing_state__timings__interpolate_vertical;
    reg [5:0]timing_state__flashing_counter;
    reg timing_state__flash_on;
    reg timing_state__scanline_displayed;

    //b Internal combinatorials
        //   Decode of @a pixel_state to generate output pixels
    reg [4:0]pixel_combs__diagonal_0;
    reg [4:0]pixel_combs__diagonal_1;
    reg [4:0]pixel_combs__diagonal_2;
    reg [4:0]pixel_combs__diagonal_3;
    reg [11:0]pixel_combs__smoothed_scanline_data;
        //   Decode of the teletext state - determines graphics mode, colors, etc, and graphics character scanline data
    reg [2:0]teletext_combs__set_at_character_state__background_color;
    reg [2:0]teletext_combs__set_at_character_state__foreground_color;
    reg teletext_combs__set_at_character_state__flashing;
    reg teletext_combs__set_at_character_state__text_mode;
    reg teletext_combs__set_at_character_state__contiguous_graphics;
    reg teletext_combs__set_at_character_state__double_height;
    reg teletext_combs__set_at_character_state__hold_graphics_mode;
    reg teletext_combs__set_at_character_state__reset_held_graphics;
    reg [2:0]teletext_combs__set_after_character_state__background_color;
    reg [2:0]teletext_combs__set_after_character_state__foreground_color;
    reg teletext_combs__set_after_character_state__flashing;
    reg teletext_combs__set_after_character_state__text_mode;
    reg teletext_combs__set_after_character_state__contiguous_graphics;
    reg teletext_combs__set_after_character_state__double_height;
    reg teletext_combs__set_after_character_state__hold_graphics_mode;
    reg teletext_combs__set_after_character_state__reset_held_graphics;
    reg [11:0]teletext_combs__graphics_data;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b scanline_and_loading__comb combinatorial process
        //   
        //       First stage of the teletext pipeline.
        //   
        //       The character ROM controls are driven from a registered version of
        //       the input character. The ROM is therefore read while the
        //       @a teletext_combs are being evaluated, and the ROM data can be stored
        //       and be valid with the @a pixel_state.
        //   
        //       The timing logic maintains a @a scanline register, which is which
        //       of the twenty scanlines of the teletext character is to be
        //       presented. It also maintains a flashing count, which indicates
        //       whether flashing pixels should be foreground or background color.
        //   
        //       The scanline is always even for an even scanlines display - used
        //       for even fields of an interlaced display; for odd scanlines
        //       display, used in the odd fields of an interlace display, the
        //       scanline will always be odd. For non-interlaced displays the
        //       scanline increments by 1.
        //   
        //       If no characters are displayed on a scanline then the scanline
        //       counter is not updated - hence on the blank lines from the start
        //       of a field to the start of text, the scanline does not change, and
        //       so the first character row will be displayed correctly with the
        //       top scanline.
        //       
    always @ ( * )//scanline_and_loading__comb
    begin: scanline_and_loading__comb_code
        rom_access__select = character_buffer__valid;
        rom_access__address = character_buffer__character;
    end //always

    //b scanline_and_loading__posedge_clk_active_low_reset_n clock process
        //   
        //       First stage of the teletext pipeline.
        //   
        //       The character ROM controls are driven from a registered version of
        //       the input character. The ROM is therefore read while the
        //       @a teletext_combs are being evaluated, and the ROM data can be stored
        //       and be valid with the @a pixel_state.
        //   
        //       The timing logic maintains a @a scanline register, which is which
        //       of the twenty scanlines of the teletext character is to be
        //       presented. It also maintains a flashing count, which indicates
        //       whether flashing pixels should be foreground or background color.
        //   
        //       The scanline is always even for an even scanlines display - used
        //       for even fields of an interlaced display; for odd scanlines
        //       display, used in the odd fields of an interlace display, the
        //       scanline will always be odd. For non-interlaced displays the
        //       scanline increments by 1.
        //   
        //       If no characters are displayed on a scanline then the scanline
        //       counter is not updated - hence on the blank lines from the start
        //       of a field to the start of text, the scanline does not change, and
        //       so the first character row will be displayed correctly with the
        //       top scanline.
        //       
    always @( posedge clk or negedge reset_n)
    begin : scanline_and_loading__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            character_buffer__valid <= 1'h0;
            character_buffer__character <= 7'h0;
            timing_state__timings__restart_frame <= 1'h0;
            timing_state__timings__end_of_scanline <= 1'h0;
            timing_state__timings__first_scanline_of_row <= 1'h0;
            timing_state__timings__smoothe <= 1'h0;
            timing_state__timings__interpolate_vertical <= 2'h0;
            timing_state__scanline <= 5'h0;
            timing_state__last_scanline <= 1'h0;
            timing_state__scanline_displayed <= 1'h0;
            timing_state__flashing_counter <= 6'h0;
            timing_state__flash_on <= 1'h0;
        end
        else if (clk__enable)
        begin
            character_buffer__valid <= 1'h0;
            if ((character__valid!=1'h0))
            begin
                character_buffer__valid <= character__valid;
                character_buffer__character <= character__character;
            end //if
            timing_state__timings__restart_frame <= timings__restart_frame;
            timing_state__timings__end_of_scanline <= timings__end_of_scanline;
            timing_state__timings__first_scanline_of_row <= timings__first_scanline_of_row;
            timing_state__timings__smoothe <= timings__smoothe;
            timing_state__timings__interpolate_vertical <= timings__interpolate_vertical;
            timing_state__scanline <= (timing_state__scanline+5'h2);
            if ((timing_state__timings__interpolate_vertical==2'h0))
            begin
                timing_state__scanline <= (timing_state__scanline+5'h1);
            end //if
            if (((timing_state__last_scanline!=1'h0)||(timings__first_scanline_of_row!=1'h0)))
            begin
                timing_state__scanline <= 5'h0;
            end //if
            timing_state__last_scanline <= 1'h0;
            if ((timing_state__scanline==5'h13))
            begin
                timing_state__last_scanline <= 1'h1;
            end //if
            if (((timing_state__scanline==5'h12)&&(timing_state__timings__interpolate_vertical==2'h1)))
            begin
                timing_state__last_scanline <= 1'h1;
            end //if
            if ((!(timings__first_scanline_of_row!=1'h0)&&!(timings__end_of_scanline!=1'h0)))
            begin
                timing_state__scanline <= timing_state__scanline;
            end //if
            if (!(timing_state__scanline_displayed!=1'h0))
            begin
                timing_state__scanline <= timing_state__scanline;
            end //if
            if ((timing_state__timings__interpolate_vertical==2'h2))
            begin
                timing_state__scanline[0] <= 1'h1;
            end //if
            if ((timing_state__timings__interpolate_vertical==2'h1))
            begin
                timing_state__scanline[0] <= 1'h0;
            end //if
            if ((timings__end_of_scanline!=1'h0))
            begin
                timing_state__scanline_displayed <= 1'h0;
            end //if
            if ((teletext_state__character__valid!=1'h0))
            begin
                timing_state__scanline_displayed <= 1'h1;
            end //if
            if ((timings__restart_frame!=1'h0))
            begin
                timing_state__scanline_displayed <= 1'h0;
                timing_state__scanline <= 5'h0;
                timing_state__flashing_counter <= (timing_state__flashing_counter+6'h1);
                if ((timing_state__flashing_counter==6'ha))
                begin
                    timing_state__flash_on <= 1'h1;
                end //if
                if ((timing_state__flashing_counter==6'h28))
                begin
                    timing_state__flashing_counter <= 6'h0;
                    timing_state__flash_on <= 1'h0;
                end //if
            end //if
        end //if
    end //always

    //b teletext_state_logic clock process
        //   
        //       State at the end of the second stage of the teletext pipeline.
        //   
        //       Determine the scanline of the character to display, and maintain
        //       the teletext state for the characters as the row is analyzed.
        //       
    always @( posedge clk or negedge reset_n)
    begin : teletext_state_logic__code
        if (reset_n==1'b0)
        begin
            teletext_state__character__valid <= 1'h0;
            teletext_state__character__character <= 7'h0;
            teletext_state__pixel_scanline <= 5'h0;
            teletext_state__character_state__background_color <= 3'h0;
            teletext_state__character_state__foreground_color <= 3'h0;
            teletext_state__character_state__flashing <= 1'h0;
            teletext_state__character_state__text_mode <= 1'h0;
            teletext_state__character_state__contiguous_graphics <= 1'h0;
            teletext_state__character_state__double_height <= 1'h0;
            teletext_state__character_state__hold_graphics_mode <= 1'h0;
            teletext_state__character_state__reset_held_graphics <= 1'h0;
            teletext_state__row_contains_double_height <= 1'h0;
            teletext_state__last_row_was_double_height_top <= 1'h0;
        end
        else if (clk__enable)
        begin
            teletext_state__character__valid <= 1'h0;
            if ((character_buffer__valid!=1'h0))
            begin
                teletext_state__character__valid <= character_buffer__valid;
                teletext_state__character__character <= character_buffer__character;
            end //if
            teletext_state__pixel_scanline <= timing_state__scanline;
            if ((teletext_state__character_state__double_height!=1'h0))
            begin
                teletext_state__pixel_scanline <= {1'h0,timing_state__scanline[4:1]};
                if ((teletext_state__last_row_was_double_height_top!=1'h0))
                begin
                    teletext_state__pixel_scanline <= ({1'h0,timing_state__scanline[4:1]}+5'ha);
                end //if
            end //if
            if ((teletext_state__character__valid!=1'h0))
            begin
                teletext_state__character_state__background_color <= teletext_combs__set_after_character_state__background_color;
                teletext_state__character_state__foreground_color <= teletext_combs__set_after_character_state__foreground_color;
                teletext_state__character_state__flashing <= teletext_combs__set_after_character_state__flashing;
                teletext_state__character_state__text_mode <= teletext_combs__set_after_character_state__text_mode;
                teletext_state__character_state__contiguous_graphics <= teletext_combs__set_after_character_state__contiguous_graphics;
                teletext_state__character_state__double_height <= teletext_combs__set_after_character_state__double_height;
                teletext_state__character_state__hold_graphics_mode <= teletext_combs__set_after_character_state__hold_graphics_mode;
                teletext_state__character_state__reset_held_graphics <= teletext_combs__set_after_character_state__reset_held_graphics;
                if ((teletext_combs__set_at_character_state__double_height!=1'h0))
                begin
                    teletext_state__row_contains_double_height <= 1'h1;
                end //if
            end //if
            if ((timing_state__timings__end_of_scanline!=1'h0))
            begin
                teletext_state__character_state__background_color <= 3'h0;
                teletext_state__character_state__foreground_color <= 3'h7;
                teletext_state__character_state__flashing <= 1'h0;
                teletext_state__character_state__double_height <= 1'h0;
                teletext_state__character_state__text_mode <= 1'h1;
                teletext_state__character_state__hold_graphics_mode <= 1'h0;
                teletext_state__character_state__contiguous_graphics <= 1'h1;
            end //if
            if (((timing_state__timings__end_of_scanline!=1'h0)&&(timing_state__last_scanline!=1'h0)))
            begin
                teletext_state__last_row_was_double_height_top <= (teletext_state__row_contains_double_height ^ teletext_state__last_row_was_double_height_top);
                teletext_state__row_contains_double_height <= 1'h0;
            end //if
            if ((timing_state__timings__restart_frame!=1'h0))
            begin
                teletext_state__last_row_was_double_height_top <= 1'h0;
                teletext_state__row_contains_double_height <= 1'h0;
            end //if
        end //if
    end //always

    //b teletext_control_decode combinatorial process
        //   
        //       This is the hard work between the state at the end of stage 2 of
        //       the pipeline (@a teletext_state) and the end of stage 3 of the
        //       pipeline (@a pixel_state).
        //   
        //       The logic decodes the teletext state to determine the next
        //       teletext character state; the 'set-at' teletext info is stored in
        //       @a pixel_state, the 'set-after' is stored back in @a
        //       teletext_state.  Set-at is the notion that, for example, a 'stop
        //       flashing' code effects the pixels displayed for that code (it is
        //       set-at). Set-after is the notion that, for example, a 'red text'
        //       code only effects the following characters (as being in text mode,
        //       foreground color red).
        //   
        //       The graphics data that a character represents is also created;
        //       this will only be used if a graphics character is to be presented,
        //       but its generation parallels the ROM reading of the character
        //       scanline data so they are valid at the same time.
        //       
        //       This work is performed while the ROM data (for text characters) is
        //       being read.
        //       
    always @ ( * )//teletext_control_decode
    begin: teletext_control_decode__comb_code
    reg [2:0]teletext_combs__set_after_character_state__background_color__var;
    reg [2:0]teletext_combs__set_after_character_state__foreground_color__var;
    reg teletext_combs__set_after_character_state__flashing__var;
    reg teletext_combs__set_after_character_state__text_mode__var;
    reg teletext_combs__set_after_character_state__contiguous_graphics__var;
    reg teletext_combs__set_after_character_state__double_height__var;
    reg teletext_combs__set_after_character_state__hold_graphics_mode__var;
    reg teletext_combs__set_after_character_state__reset_held_graphics__var;
    reg [2:0]teletext_combs__set_at_character_state__background_color__var;
    reg teletext_combs__set_at_character_state__flashing__var;
    reg teletext_combs__set_at_character_state__contiguous_graphics__var;
    reg teletext_combs__set_at_character_state__double_height__var;
    reg teletext_combs__set_at_character_state__hold_graphics_mode__var;
    reg teletext_combs__set_at_character_state__reset_held_graphics__var;
    reg [11:0]teletext_combs__graphics_data__var;
        teletext_combs__set_after_character_state__background_color__var = teletext_state__character_state__background_color;
        teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character_state__foreground_color;
        teletext_combs__set_after_character_state__flashing__var = teletext_state__character_state__flashing;
        teletext_combs__set_after_character_state__text_mode__var = teletext_state__character_state__text_mode;
        teletext_combs__set_after_character_state__contiguous_graphics__var = teletext_state__character_state__contiguous_graphics;
        teletext_combs__set_after_character_state__double_height__var = teletext_state__character_state__double_height;
        teletext_combs__set_after_character_state__hold_graphics_mode__var = teletext_state__character_state__hold_graphics_mode;
        teletext_combs__set_after_character_state__reset_held_graphics__var = teletext_state__character_state__reset_held_graphics;
        teletext_combs__set_at_character_state__background_color__var = teletext_state__character_state__background_color;
        teletext_combs__set_at_character_state__foreground_color = teletext_state__character_state__foreground_color;
        teletext_combs__set_at_character_state__flashing__var = teletext_state__character_state__flashing;
        teletext_combs__set_at_character_state__text_mode = teletext_state__character_state__text_mode;
        teletext_combs__set_at_character_state__contiguous_graphics__var = teletext_state__character_state__contiguous_graphics;
        teletext_combs__set_at_character_state__double_height__var = teletext_state__character_state__double_height;
        teletext_combs__set_at_character_state__hold_graphics_mode__var = teletext_state__character_state__hold_graphics_mode;
        teletext_combs__set_at_character_state__reset_held_graphics__var = teletext_state__character_state__reset_held_graphics;
        teletext_combs__set_at_character_state__reset_held_graphics__var = 1'h0;
        teletext_combs__set_after_character_state__reset_held_graphics__var = 1'h0;
        case (teletext_state__character__character) //synopsys parallel_case
        7'h0: // req 1
            begin
            teletext_combs__set_at_character_state__reset_held_graphics__var = 1'h0;
            end
        7'h1: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h1;
            teletext_combs__set_after_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h2: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h1;
            teletext_combs__set_after_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h3: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h1;
            teletext_combs__set_after_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h4: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h1;
            teletext_combs__set_after_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h5: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h1;
            teletext_combs__set_after_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h6: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h1;
            teletext_combs__set_after_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h7: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h1;
            teletext_combs__set_after_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__hold_graphics_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h8: // req 1
            begin
            teletext_combs__set_after_character_state__flashing__var = 1'h1;
            end
        7'h9: // req 1
            begin
            teletext_combs__set_at_character_state__flashing__var = 1'h0;
            teletext_combs__set_after_character_state__flashing__var = 1'h0;
            end
        7'h11: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h12: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h13: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h14: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h15: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h16: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h17: // req 1
            begin
            teletext_combs__set_after_character_state__foreground_color__var = teletext_state__character__character[2:0];
            teletext_combs__set_after_character_state__text_mode__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'hc: // req 1
            begin
            teletext_combs__set_at_character_state__double_height__var = 1'h0;
            teletext_combs__set_after_character_state__double_height__var = 1'h0;
            teletext_combs__set_at_character_state__reset_held_graphics__var = 1'h1;
            end
        7'hd: // req 1
            begin
            teletext_combs__set_at_character_state__reset_held_graphics__var = 1'h1;
            teletext_combs__set_after_character_state__double_height__var = 1'h1;
            end
        7'h19: // req 1
            begin
            teletext_combs__set_at_character_state__contiguous_graphics__var = 1'h1;
            teletext_combs__set_after_character_state__contiguous_graphics__var = 1'h1;
            end
        7'h1a: // req 1
            begin
            teletext_combs__set_at_character_state__contiguous_graphics__var = 1'h0;
            teletext_combs__set_after_character_state__contiguous_graphics__var = 1'h0;
            end
        7'h1c: // req 1
            begin
            teletext_combs__set_at_character_state__background_color__var = 3'h0;
            teletext_combs__set_after_character_state__background_color__var = 3'h0;
            end
        7'h1d: // req 1
            begin
            teletext_combs__set_at_character_state__background_color__var = teletext_state__character_state__foreground_color;
            teletext_combs__set_after_character_state__background_color__var = teletext_state__character_state__foreground_color;
            end
        7'h1e: // req 1
            begin
            teletext_combs__set_at_character_state__hold_graphics_mode__var = 1'h1;
            teletext_combs__set_after_character_state__hold_graphics_mode__var = 1'h1;
            end
        7'h1f: // req 1
            begin
            teletext_combs__set_after_character_state__hold_graphics_mode__var = 1'h0;
            end
        7'ha: // req 1
            begin
            teletext_combs__set_at_character_state__reset_held_graphics__var = 1'h0;
            end
        7'hb: // req 1
            begin
            teletext_combs__set_at_character_state__reset_held_graphics__var = 1'h0;
            end
        7'he: // req 1
            begin
            teletext_combs__set_at_character_state__reset_held_graphics__var = 1'h0;
            end
        7'hf: // req 1
            begin
            teletext_combs__set_at_character_state__reset_held_graphics__var = 1'h0;
            end
        7'h10: // req 1
            begin
            teletext_combs__set_at_character_state__reset_held_graphics__var = 1'h0;
            end
        7'h18: // req 1
            begin
            teletext_combs__set_at_character_state__reset_held_graphics__var = 1'h0;
            end
        7'h1b: // req 1
            begin
            teletext_combs__set_at_character_state__reset_held_graphics__var = 1'h0;
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
        teletext_combs__graphics_data__var = 12'h0;
        case (teletext_state__pixel_scanline[4:1]) //synopsys parallel_case
        4'h0: // req 1
            begin
            teletext_combs__graphics_data__var = (((teletext_state__character__character[0]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[1]!=1'h0)?12'h3f:12'h0));
            end
        4'h1: // req 1
            begin
            teletext_combs__graphics_data__var = (((teletext_state__character__character[0]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[1]!=1'h0)?12'h3f:12'h0));
            end
        4'h2: // req 1
            begin
            teletext_combs__graphics_data__var = (((teletext_state__character__character[0]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[1]!=1'h0)?12'h3f:12'h0));
            end
        4'h7: // req 1
            begin
            teletext_combs__graphics_data__var = (((teletext_state__character__character[4]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[6]!=1'h0)?12'h3f:12'h0));
            end
        4'h8: // req 1
            begin
            teletext_combs__graphics_data__var = (((teletext_state__character__character[4]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[6]!=1'h0)?12'h3f:12'h0));
            end
        4'h9: // req 1
            begin
            teletext_combs__graphics_data__var = (((teletext_state__character__character[4]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[6]!=1'h0)?12'h3f:12'h0));
            end
        default: // req 1
            begin
            teletext_combs__graphics_data__var = (((teletext_state__character__character[2]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[3]!=1'h0)?12'h3f:12'h0));
            end
        endcase
        if (!(teletext_state__character_state__contiguous_graphics!=1'h0))
        begin
            teletext_combs__graphics_data__var[11:10] = 2'h0;
            teletext_combs__graphics_data__var[5:4] = 2'h0;
            case (teletext_state__pixel_scanline[4:1]) //synopsys parallel_case
            4'h2: // req 1
                begin
                teletext_combs__graphics_data__var = 12'h0;
                end
            4'h6: // req 1
                begin
                teletext_combs__graphics_data__var = 12'h0;
                end
            4'h9: // req 1
                begin
                teletext_combs__graphics_data__var = 12'h0;
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
        teletext_combs__set_after_character_state__background_color = teletext_combs__set_after_character_state__background_color__var;
        teletext_combs__set_after_character_state__foreground_color = teletext_combs__set_after_character_state__foreground_color__var;
        teletext_combs__set_after_character_state__flashing = teletext_combs__set_after_character_state__flashing__var;
        teletext_combs__set_after_character_state__text_mode = teletext_combs__set_after_character_state__text_mode__var;
        teletext_combs__set_after_character_state__contiguous_graphics = teletext_combs__set_after_character_state__contiguous_graphics__var;
        teletext_combs__set_after_character_state__double_height = teletext_combs__set_after_character_state__double_height__var;
        teletext_combs__set_after_character_state__hold_graphics_mode = teletext_combs__set_after_character_state__hold_graphics_mode__var;
        teletext_combs__set_after_character_state__reset_held_graphics = teletext_combs__set_after_character_state__reset_held_graphics__var;
        teletext_combs__set_at_character_state__background_color = teletext_combs__set_at_character_state__background_color__var;
        teletext_combs__set_at_character_state__flashing = teletext_combs__set_at_character_state__flashing__var;
        teletext_combs__set_at_character_state__contiguous_graphics = teletext_combs__set_at_character_state__contiguous_graphics__var;
        teletext_combs__set_at_character_state__double_height = teletext_combs__set_at_character_state__double_height__var;
        teletext_combs__set_at_character_state__hold_graphics_mode = teletext_combs__set_at_character_state__hold_graphics_mode__var;
        teletext_combs__set_at_character_state__reset_held_graphics = teletext_combs__set_at_character_state__reset_held_graphics__var;
        teletext_combs__graphics_data = teletext_combs__graphics_data__var;
    end //always

    //b pixel_state_logic clock process
        //   
        //       Register the required scanlines of the character ROM, and store
        //       the appropriate graphics data to be used (if graphics is to be
        //       used instead of the text scanline data).
        //   
        //       Also, determine which color should be used as foreground - if
        //       flashing and the flash counter indicates 'flash off', then the
        //       background color replaces the foreground color in the state.
        //       
    always @( posedge clk or negedge reset_n)
    begin : pixel_state_logic__code
        if (reset_n==1'b0)
        begin
            pixel_state__rom_scanline_data <= 10'h0;
            pixel_state__pixel_scanline <= 5'h0;
            pixel_state__graphics_data <= 12'h0;
            pixel_state__use_graphics_data <= 1'h0;
            pixel_state__held_graphics_data <= 12'h0;
            pixel_state__character__valid <= 1'h0;
            pixel_state__character__character <= 7'h0;
            pixel_state__character_state__background_color <= 3'h0;
            pixel_state__character_state__foreground_color <= 3'h0;
            pixel_state__character_state__flashing <= 1'h0;
            pixel_state__character_state__text_mode <= 1'h0;
            pixel_state__character_state__contiguous_graphics <= 1'h0;
            pixel_state__character_state__double_height <= 1'h0;
            pixel_state__character_state__hold_graphics_mode <= 1'h0;
            pixel_state__character_state__reset_held_graphics <= 1'h0;
        end
        else if (clk__enable)
        begin
            case (teletext_state__pixel_scanline[4:1]) //synopsys parallel_case
            4'h0: // req 1
                begin
                pixel_state__rom_scanline_data <= {rom_data[4:0],5'h0};
                end
            4'h1: // req 1
                begin
                pixel_state__rom_scanline_data <= rom_data[9:0];
                end
            4'h2: // req 1
                begin
                pixel_state__rom_scanline_data <= rom_data[14:5];
                end
            4'h3: // req 1
                begin
                pixel_state__rom_scanline_data <= rom_data[19:10];
                end
            4'h4: // req 1
                begin
                pixel_state__rom_scanline_data <= rom_data[24:15];
                end
            4'h5: // req 1
                begin
                pixel_state__rom_scanline_data <= rom_data[29:20];
                end
            4'h6: // req 1
                begin
                pixel_state__rom_scanline_data <= rom_data[34:25];
                end
            4'h7: // req 1
                begin
                pixel_state__rom_scanline_data <= rom_data[39:30];
                end
            4'h8: // req 1
                begin
                pixel_state__rom_scanline_data <= rom_data[44:35];
                end
            default: // req 1
                begin
                pixel_state__rom_scanline_data <= {5'h0,rom_data[44:40]};
                end
            endcase
            pixel_state__pixel_scanline <= teletext_state__pixel_scanline;
            pixel_state__graphics_data <= teletext_combs__graphics_data;
            pixel_state__use_graphics_data <= 1'h1;
            case (teletext_state__character__character[6:5]) //synopsys parallel_case
            2'h0: // req 1
                begin
                pixel_state__use_graphics_data <= 1'h1;
                pixel_state__graphics_data <= 12'h0;
                if (((teletext_combs__set_at_character_state__hold_graphics_mode!=1'h0)&&!(teletext_combs__set_at_character_state__reset_held_graphics!=1'h0)))
                begin
                    pixel_state__graphics_data <= pixel_state__held_graphics_data;
                end //if
                end
            2'h2: // req 1
                begin
                pixel_state__use_graphics_data <= 1'h0;
                end
            default: // req 1
                begin
                if ((teletext_state__character_state__text_mode!=1'h0))
                begin
                    pixel_state__use_graphics_data <= 1'h0;
                end //if
                end
            endcase
            if (!(teletext_state__character_state__text_mode!=1'h0))
            begin
                if ((teletext_state__character__character[5]!=1'h0))
                begin
                    pixel_state__held_graphics_data <= teletext_combs__graphics_data;
                end //if
            end //if
            if ((timing_state__timings__end_of_scanline!=1'h0))
            begin
                pixel_state__held_graphics_data <= 12'h0;
            end //if
            if ((teletext_combs__set_at_character_state__reset_held_graphics!=1'h0))
            begin
                pixel_state__held_graphics_data <= 12'h0;
            end //if
            pixel_state__character__valid <= teletext_state__character__valid;
            pixel_state__character__character <= teletext_state__character__character;
            if (!(teletext_state__character__valid!=1'h0))
            begin
                pixel_state__rom_scanline_data <= pixel_state__rom_scanline_data;
                pixel_state__character__valid <= pixel_state__character__valid;
                pixel_state__character__character <= pixel_state__character__character;
                pixel_state__character_state__background_color <= pixel_state__character_state__background_color;
                pixel_state__character_state__foreground_color <= pixel_state__character_state__foreground_color;
                pixel_state__character_state__flashing <= pixel_state__character_state__flashing;
                pixel_state__character_state__text_mode <= pixel_state__character_state__text_mode;
                pixel_state__character_state__contiguous_graphics <= pixel_state__character_state__contiguous_graphics;
                pixel_state__character_state__double_height <= pixel_state__character_state__double_height;
                pixel_state__character_state__hold_graphics_mode <= pixel_state__character_state__hold_graphics_mode;
                pixel_state__character_state__reset_held_graphics <= pixel_state__character_state__reset_held_graphics;
                pixel_state__pixel_scanline <= pixel_state__pixel_scanline;
                pixel_state__graphics_data <= pixel_state__graphics_data;
                pixel_state__use_graphics_data <= pixel_state__use_graphics_data;
                pixel_state__held_graphics_data <= pixel_state__held_graphics_data;
                pixel_state__character__valid <= 1'h0;
            end //if
            pixel_state__character_state__background_color <= teletext_combs__set_at_character_state__background_color;
            pixel_state__character_state__foreground_color <= teletext_combs__set_at_character_state__foreground_color;
            pixel_state__character_state__flashing <= teletext_combs__set_at_character_state__flashing;
            pixel_state__character_state__text_mode <= teletext_combs__set_at_character_state__text_mode;
            pixel_state__character_state__contiguous_graphics <= teletext_combs__set_at_character_state__contiguous_graphics;
            pixel_state__character_state__double_height <= teletext_combs__set_at_character_state__double_height;
            pixel_state__character_state__hold_graphics_mode <= teletext_combs__set_at_character_state__hold_graphics_mode;
            pixel_state__character_state__reset_held_graphics <= teletext_combs__set_at_character_state__reset_held_graphics;
            if ((!(timing_state__flash_on!=1'h0)&&(teletext_combs__set_at_character_state__flashing!=1'h0)))
            begin
                pixel_state__character_state__foreground_color <= teletext_combs__set_at_character_state__background_color;
            end //if
        end //if
    end //always

    //b pixel_comb_logic combinatorial process
        //   
        //       Smoothe the register scanline data, and select either that data or
        //       the graphics data, as determined in the previous cycle and stored
        //       in @a pixel_state.
        //       
    always @ ( * )//pixel_comb_logic
    begin: pixel_comb_logic__comb_code
    reg [4:0]pixel_combs__diagonal_0__var;
    reg [4:0]pixel_combs__diagonal_1__var;
    reg [4:0]pixel_combs__diagonal_2__var;
    reg [4:0]pixel_combs__diagonal_3__var;
    reg [11:0]pixel_combs__smoothed_scanline_data__var;
        pixel_combs__diagonal_0__var = (pixel_state__rom_scanline_data[9:5] & {pixel_state__rom_scanline_data[3:0],1'h0});
        pixel_combs__diagonal_1__var = (pixel_state__rom_scanline_data[9:5] & {1'h0,pixel_state__rom_scanline_data[4:1]});
        pixel_combs__diagonal_2__var = (pixel_state__rom_scanline_data[4:0] & {pixel_state__rom_scanline_data[8:5],1'h0});
        pixel_combs__diagonal_3__var = (pixel_state__rom_scanline_data[4:0] & {1'h0,pixel_state__rom_scanline_data[9:6]});
        pixel_combs__diagonal_0__var = (pixel_combs__diagonal_0__var & ~{pixel_state__rom_scanline_data[8:5],1'h0});
        pixel_combs__diagonal_1__var = (pixel_combs__diagonal_1__var & ~{1'h0,pixel_state__rom_scanline_data[9:6]});
        pixel_combs__diagonal_2__var = (pixel_combs__diagonal_2__var & ~{pixel_state__rom_scanline_data[3:0],1'h0});
        pixel_combs__diagonal_3__var = (pixel_combs__diagonal_3__var & ~{1'h0,pixel_state__rom_scanline_data[4:1]});
        if (!(pixel_state__pixel_scanline[0]!=1'h0))
        begin
            pixel_combs__smoothed_scanline_data__var = {{{{{{{{{{2'h0,(pixel_state__rom_scanline_data[4] | pixel_combs__diagonal_1__var[4])},(pixel_state__rom_scanline_data[4] | pixel_combs__diagonal_0__var[4])},(pixel_state__rom_scanline_data[3] | pixel_combs__diagonal_1__var[3])},(pixel_state__rom_scanline_data[3] | pixel_combs__diagonal_0__var[3])},(pixel_state__rom_scanline_data[2] | pixel_combs__diagonal_1__var[2])},(pixel_state__rom_scanline_data[2] | pixel_combs__diagonal_0__var[2])},(pixel_state__rom_scanline_data[1] | pixel_combs__diagonal_1__var[1])},(pixel_state__rom_scanline_data[1] | pixel_combs__diagonal_0__var[1])},(pixel_state__rom_scanline_data[0] | pixel_combs__diagonal_1__var[0])},(pixel_state__rom_scanline_data[0] | pixel_combs__diagonal_0__var[0])};
        end //if
        else
        
        begin
            pixel_combs__smoothed_scanline_data__var = {{{{{{{{{{2'h0,(pixel_state__rom_scanline_data[9] | pixel_combs__diagonal_3__var[4])},(pixel_state__rom_scanline_data[9] | pixel_combs__diagonal_2__var[4])},(pixel_state__rom_scanline_data[8] | pixel_combs__diagonal_3__var[3])},(pixel_state__rom_scanline_data[8] | pixel_combs__diagonal_2__var[3])},(pixel_state__rom_scanline_data[7] | pixel_combs__diagonal_3__var[2])},(pixel_state__rom_scanline_data[7] | pixel_combs__diagonal_2__var[2])},(pixel_state__rom_scanline_data[6] | pixel_combs__diagonal_3__var[1])},(pixel_state__rom_scanline_data[6] | pixel_combs__diagonal_2__var[1])},(pixel_state__rom_scanline_data[5] | pixel_combs__diagonal_3__var[0])},(pixel_state__rom_scanline_data[5] | pixel_combs__diagonal_2__var[0])};
        end //else
        if (!(timing_state__timings__smoothe!=1'h0))
        begin
            pixel_combs__smoothed_scanline_data__var = {{{{{{{{{{2'h0,pixel_state__rom_scanline_data[4]},pixel_state__rom_scanline_data[4]},pixel_state__rom_scanline_data[3]},pixel_state__rom_scanline_data[3]},pixel_state__rom_scanline_data[2]},pixel_state__rom_scanline_data[2]},pixel_state__rom_scanline_data[1]},pixel_state__rom_scanline_data[1]},pixel_state__rom_scanline_data[0]},pixel_state__rom_scanline_data[0]};
        end //if
        if ((pixel_state__use_graphics_data!=1'h0))
        begin
            pixel_combs__smoothed_scanline_data__var = pixel_state__graphics_data;
        end //if
        pixel_combs__diagonal_0 = pixel_combs__diagonal_0__var;
        pixel_combs__diagonal_1 = pixel_combs__diagonal_1__var;
        pixel_combs__diagonal_2 = pixel_combs__diagonal_2__var;
        pixel_combs__diagonal_3 = pixel_combs__diagonal_3__var;
        pixel_combs__smoothed_scanline_data = pixel_combs__smoothed_scanline_data__var;
    end //always

    //b output_pixel_selection combinatorial process
        //   
        //       Generate output pixels by selecting the foreground or background
        //       color, based on either the character data or the graphics data
        //       which is presented as @a pixel_combs.smoothed_scanline_data.
        //   
        //       For flashing colors the foreground_color should have already been
        //       changed (if flash off) to match the background color, so no need
        //       to account for flashing here.
        //       
    always @ ( * )//output_pixel_selection
    begin: output_pixel_selection__comb_code
    reg [11:0]pixels__red__var;
    reg [11:0]pixels__blue__var;
    reg [11:0]pixels__green__var;
        pixels__red__var = 12'h0;
        pixels__blue__var = 12'h0;
        pixels__green__var = 12'h0;
        pixels__red__var[0] = pixel_state__character_state__background_color[0];
        pixels__green__var[0] = pixel_state__character_state__background_color[1];
        pixels__blue__var[0] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[0]!=1'h0))
        begin
            pixels__red__var[0] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[0] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[0] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__red__var[1] = pixel_state__character_state__background_color[0];
        pixels__green__var[1] = pixel_state__character_state__background_color[1];
        pixels__blue__var[1] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[1]!=1'h0))
        begin
            pixels__red__var[1] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[1] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[1] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__red__var[2] = pixel_state__character_state__background_color[0];
        pixels__green__var[2] = pixel_state__character_state__background_color[1];
        pixels__blue__var[2] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[2]!=1'h0))
        begin
            pixels__red__var[2] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[2] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[2] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__red__var[3] = pixel_state__character_state__background_color[0];
        pixels__green__var[3] = pixel_state__character_state__background_color[1];
        pixels__blue__var[3] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[3]!=1'h0))
        begin
            pixels__red__var[3] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[3] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[3] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__red__var[4] = pixel_state__character_state__background_color[0];
        pixels__green__var[4] = pixel_state__character_state__background_color[1];
        pixels__blue__var[4] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[4]!=1'h0))
        begin
            pixels__red__var[4] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[4] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[4] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__red__var[5] = pixel_state__character_state__background_color[0];
        pixels__green__var[5] = pixel_state__character_state__background_color[1];
        pixels__blue__var[5] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[5]!=1'h0))
        begin
            pixels__red__var[5] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[5] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[5] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__red__var[6] = pixel_state__character_state__background_color[0];
        pixels__green__var[6] = pixel_state__character_state__background_color[1];
        pixels__blue__var[6] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[6]!=1'h0))
        begin
            pixels__red__var[6] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[6] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[6] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__red__var[7] = pixel_state__character_state__background_color[0];
        pixels__green__var[7] = pixel_state__character_state__background_color[1];
        pixels__blue__var[7] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[7]!=1'h0))
        begin
            pixels__red__var[7] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[7] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[7] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__red__var[8] = pixel_state__character_state__background_color[0];
        pixels__green__var[8] = pixel_state__character_state__background_color[1];
        pixels__blue__var[8] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[8]!=1'h0))
        begin
            pixels__red__var[8] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[8] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[8] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__red__var[9] = pixel_state__character_state__background_color[0];
        pixels__green__var[9] = pixel_state__character_state__background_color[1];
        pixels__blue__var[9] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[9]!=1'h0))
        begin
            pixels__red__var[9] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[9] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[9] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__red__var[10] = pixel_state__character_state__background_color[0];
        pixels__green__var[10] = pixel_state__character_state__background_color[1];
        pixels__blue__var[10] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[10]!=1'h0))
        begin
            pixels__red__var[10] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[10] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[10] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__red__var[11] = pixel_state__character_state__background_color[0];
        pixels__green__var[11] = pixel_state__character_state__background_color[1];
        pixels__blue__var[11] = pixel_state__character_state__background_color[2];
        if ((pixel_combs__smoothed_scanline_data[11]!=1'h0))
        begin
            pixels__red__var[11] = pixel_state__character_state__foreground_color[0];
            pixels__green__var[11] = pixel_state__character_state__foreground_color[1];
            pixels__blue__var[11] = pixel_state__character_state__foreground_color[2];
        end //if
        pixels__valid = pixel_state__character__valid;
        pixels__last_scanline = timing_state__last_scanline;
        pixels__red = pixels__red__var;
        pixels__blue = pixels__blue__var;
        pixels__green = pixels__green__var;
    end //always

endmodule // teletext
