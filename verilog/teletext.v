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
    //   Teletext characters are displayed from a 12x20 grid.
    //   The ROM characters have two background rows, and then are displayed with 2 background pixels on the left, and then 10 pixels from the ROM
    //   The ROM is actually 5x9, and it is doubled to 10x18
    //   Doubling without smoothing can be achieved be true doubling
    //   
    //   A simple smoothing can be performed for a pixel depending on its NSEW neighbors:
    //   
    //     |NN|
    //     |NN|
    //   WW|ab|EE
    //   WW|cd|EE
    //     |SS|
    //     |SS|
    //   
    //   a is filled if the pixel is filled itself, or if N&W
    //   b is filled if the pixel is filled itself, or if N&E
    //   c is filled if the pixel is filled itself, or if S&W
    //   d is filled if the pixel is filled itself, or if S&E
    //   
    //   Hence one would get:
    //   ..|**|**|**|..|
    //   ..|**|**|**|..|
    //   ---------------
    //   **|..|..|**|**|
    //   **|..|..|**|**|
    //   ---------------
    //   ..|**|..|..|**|
    //   ..|**|..|..|**|
    //   
    //   smoothed to:
    //   ..|**|**|**|..|
    //   .*|**|**|**|*.|
    //   ---------------
    //   **|*.|.*|**|**|
    //   **|*.|..|**|**|
    //   ---------------
    //   .*|**|..|.*|**|
    //   ..|**|..|..|**|
    //   
    //   Or, without intervening lines:
    //   ..******..
    //   ..******..
    //   **....****
    //   **....****
    //   ..**....**
    //   ..**....**
    //   
    //   smoothed to:
    //   ..******..
    //   .********.
    //   ***..*****
    //   ***...****
    //   .***...***
    //   ..**....**
    //   
    //   So for even scanlines ('a' and 'b') the smoother needs row n and row n-1.
    //   a is set if n[x] or n[x-left]&(n-1)[x]
    //   b is set if n[x] or n[x-right]&(n-1)[x]
    //   
    //   For odd scanlines ('c' and 'd') the smoother needs row n and row n+1.
    //   c is set if n[x] or n[x-left]&(n+1)[x]
    //   d is set if n[x] or n[x-right]&(n+1)[x]
    //   
    //   This method has the unfortunate impact of smoothing two crossing lines, such as a plus:
    //   ....**....     ....**....
    //   ....**....     ....**....
    //   ....**....     ....**....
    //   ....**....     ...****...
    //   **********     **********
    //   **********     **********
    //   ....**....     ...****...
    //   ....**....     ....**....
    //   ....**....     ....**....
    //   ....**....     ....**....
    //   
    //   Hence a better smoothing can be performed for a pixel depending on all its neighbors:
    //   
    //   NW|NN|NE
    //     |NN|
    //   WW|ab|EE
    //   WW|cd|EE
    //     |SS|
    //   SW|SS|SE
    //   
    //   a is filled if the pixel is filled itself, or if (N&W) but not NW
    //   b is filled if the pixel is filled itself, or if (N&E) but not NE
    //   c is filled if the pixel is filled itself, or if (S&W) but not SW
    //   d is filled if the pixel is filled itself, or if (S&E) but not SE
    //   
    //   Hence one would get:
    //   ..|**|**|**|..|
    //   ..|**|**|**|..|
    //   ---------------
    //   **|..|..|**|**|
    //   **|..|..|**|**|
    //   ---------------
    //   ..|**|..|..|**|
    //   ..|**|..|..|**|
    //   
    //   smoothed to:
    //   ..|**|**|**|..|
    //   .*|**|**|**|..|
    //   ---------------
    //   **|*.|..|**|**|
    //   **|*.|..|**|**|
    //   ---------------
    //   .*|**|..|..|**|
    //   ..|**|..|..|**|
    //   
    //   Or, without intervening lines:
    //   ..******..
    //   ..******..
    //   **....****
    //   **....****
    //   ..**....**
    //   ..**....**
    //   
    //   smoothed to:
    //   ..******..
    //   .*******..
    //   ***...****
    //   ***...****
    //   .***....**
    //   ..**....**
    //   
    //   So for even scanlines ('a' and 'b') the smoother needs row n and row n-1.
    //   a is set if n[x] or (n[x-left]&(n-1)[x]) &~ (n-1)[x-left]
    //   b is set if n[x] or (n[x-right]&(n-1)[x]) &~ (n-1)[x-right]
    //   
    //   For odd scanlines ('c' and 'd') the smoother needs row n and row n+1.
    //   c is set if n[x] or (n[x-left]&(n+1)[x]) &~ (n+1)[x-left]
    //   d is set if n[x] or (n[x-right]&(n+1)[x]) &~ (n+1)[x-left]
    //   
    //   Graphics characters are 6 blobs on a 6x10 grid (contiguous, separated):
    //   000111 .00.11
    //   000111 .00.11
    //   000111 ......
    //   222333 .22.33
    //   222333 .22.33
    //   222333 .22.33
    //   222333 ......
    //   444555 .44.55
    //   444555 .44.55
    //   444555 ......
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

    rom_access__select,
    rom_access__address,
    pixels__valid,
    pixels__red,
    pixels__green,
    pixels__blue,
    pixels__last_scanline
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
    input reset_n;

    //b Outputs
        //   Teletext ROM access
    output rom_access__select;
    output [6:0]rom_access__address;
        //   Output pixels, two clock ticks delayed from clk in
    output pixels__valid;
    output [11:0]pixels__red;
    output [11:0]pixels__green;
    output [11:0]pixels__blue;
    output pixels__last_scanline;

// output components here

    //b Output combinatorials
        //   Output pixels, two clock ticks delayed from clk in
    reg pixels__valid;
    reg [11:0]pixels__red;
    reg [11:0]pixels__green;
    reg [11:0]pixels__blue;
    reg pixels__last_scanline;

    //b Output nets

    //b Internal and output registers
    reg [2:0]output_state__character_state__background_color;
    reg [2:0]output_state__character_state__foreground_color;
    reg output_state__character_state__held_character;
    reg output_state__character_state__flashing;
    reg output_state__character_state__text_mode;
    reg output_state__character_state__contiguous_graphics;
    reg output_state__character_state__dbl_height;
    reg output_state__character_state__hold_graphics;
    reg output_state__character_state__reset_held_graphics;
    reg [11:0]output_state__held_graphics_data;
    reg [2:0]output_state__colors[11:0];
    reg output_state__valid;
    reg teletext_state__character__valid;
    reg [6:0]teletext_state__character__character;
    reg [2:0]teletext_state__character_state__background_color;
    reg [2:0]teletext_state__character_state__foreground_color;
    reg teletext_state__character_state__held_character;
    reg teletext_state__character_state__flashing;
    reg teletext_state__character_state__text_mode;
    reg teletext_state__character_state__contiguous_graphics;
    reg teletext_state__character_state__dbl_height;
    reg teletext_state__character_state__hold_graphics;
    reg teletext_state__character_state__reset_held_graphics;
    reg teletext_state__row_contains_dbl_height;
    reg teletext_state__last_row_contained_dbl_height;
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
    reg load_state__character__valid;
    reg [6:0]load_state__character__character;
    reg rom_access__select;
    reg [6:0]rom_access__address;

    //b Internal combinatorials
    reg [9:0]pixel_combs__rom_scanline_data;
    reg [11:0]pixel_combs__graphics_data;
    reg [11:0]pixel_combs__smoothed_scanline_data;
    reg [4:0]pixel_combs__diagonal_0;
    reg [4:0]pixel_combs__diagonal_1;
    reg [4:0]pixel_combs__diagonal_2;
    reg [4:0]pixel_combs__diagonal_3;
    reg [2:0]teletext_combs__next_character_state__background_color;
    reg [2:0]teletext_combs__next_character_state__foreground_color;
    reg teletext_combs__next_character_state__held_character;
    reg teletext_combs__next_character_state__flashing;
    reg teletext_combs__next_character_state__text_mode;
    reg teletext_combs__next_character_state__contiguous_graphics;
    reg teletext_combs__next_character_state__dbl_height;
    reg teletext_combs__next_character_state__hold_graphics;
    reg teletext_combs__next_character_state__reset_held_graphics;
    reg [2:0]teletext_combs__current_character_state__background_color;
    reg [2:0]teletext_combs__current_character_state__foreground_color;
    reg teletext_combs__current_character_state__held_character;
    reg teletext_combs__current_character_state__flashing;
    reg teletext_combs__current_character_state__text_mode;
    reg teletext_combs__current_character_state__contiguous_graphics;
    reg teletext_combs__current_character_state__dbl_height;
    reg teletext_combs__current_character_state__hold_graphics;
    reg teletext_combs__current_character_state__reset_held_graphics;
    reg teletext_combs__can_be_replaced_with_hold;
    reg [4:0]teletext_combs__pixel_scanline;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b scanline_and_loading clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : scanline_and_loading__code
        if (reset_n==1'b0)
        begin
            load_state__character__valid <= 1'h0;
            load_state__character__character <= 7'h0;
            rom_access__select <= 1'h0;
            rom_access__address <= 7'h0;
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
            load_state__character__valid <= character__valid;
            load_state__character__character <= character__character;
            rom_access__select <= 1'h0;
            if ((character__valid!=1'h0))
            begin
                rom_access__select <= 1'h1;
                rom_access__address <= character__character;
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
            if ((load_state__character__valid!=1'h0))
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

    //b teletext_control_decode__comb combinatorial process
        //   
        //       Decode the 'load_state' character if a control character; handle the state of the line (colors, graphics, etc)
        //       
    always @ ( * )//teletext_control_decode__comb
    begin: teletext_control_decode__comb_code
    reg [2:0]teletext_combs__next_character_state__background_color__var;
    reg [2:0]teletext_combs__next_character_state__foreground_color__var;
    reg teletext_combs__next_character_state__flashing__var;
    reg teletext_combs__next_character_state__text_mode__var;
    reg teletext_combs__next_character_state__contiguous_graphics__var;
    reg teletext_combs__next_character_state__dbl_height__var;
    reg teletext_combs__next_character_state__hold_graphics__var;
    reg [2:0]teletext_combs__current_character_state__background_color__var;
    reg teletext_combs__current_character_state__flashing__var;
    reg teletext_combs__current_character_state__contiguous_graphics__var;
    reg teletext_combs__current_character_state__dbl_height__var;
    reg teletext_combs__current_character_state__hold_graphics__var;
    reg teletext_combs__current_character_state__reset_held_graphics__var;
    reg teletext_combs__can_be_replaced_with_hold__var;
    reg [4:0]teletext_combs__pixel_scanline__var;
        teletext_combs__next_character_state__background_color__var = teletext_state__character_state__background_color;
        teletext_combs__next_character_state__foreground_color__var = teletext_state__character_state__foreground_color;
        teletext_combs__next_character_state__held_character = teletext_state__character_state__held_character;
        teletext_combs__next_character_state__flashing__var = teletext_state__character_state__flashing;
        teletext_combs__next_character_state__text_mode__var = teletext_state__character_state__text_mode;
        teletext_combs__next_character_state__contiguous_graphics__var = teletext_state__character_state__contiguous_graphics;
        teletext_combs__next_character_state__dbl_height__var = teletext_state__character_state__dbl_height;
        teletext_combs__next_character_state__hold_graphics__var = teletext_state__character_state__hold_graphics;
        teletext_combs__next_character_state__reset_held_graphics = teletext_state__character_state__reset_held_graphics;
        teletext_combs__current_character_state__background_color__var = teletext_state__character_state__background_color;
        teletext_combs__current_character_state__foreground_color = teletext_state__character_state__foreground_color;
        teletext_combs__current_character_state__held_character = teletext_state__character_state__held_character;
        teletext_combs__current_character_state__flashing__var = teletext_state__character_state__flashing;
        teletext_combs__current_character_state__text_mode = teletext_state__character_state__text_mode;
        teletext_combs__current_character_state__contiguous_graphics__var = teletext_state__character_state__contiguous_graphics;
        teletext_combs__current_character_state__dbl_height__var = teletext_state__character_state__dbl_height;
        teletext_combs__current_character_state__hold_graphics__var = teletext_state__character_state__hold_graphics;
        teletext_combs__current_character_state__reset_held_graphics__var = teletext_state__character_state__reset_held_graphics;
        teletext_combs__can_be_replaced_with_hold__var = 1'h1;
        teletext_combs__current_character_state__reset_held_graphics__var = 1'h0;
        case (load_state__character__character) //synopsys parallel_case
        7'h0: // req 1
            begin
            teletext_combs__can_be_replaced_with_hold__var = 1'h1;
            end
        7'h1: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h1;
            teletext_combs__current_character_state__hold_graphics__var = 1'h0;
            teletext_combs__next_character_state__hold_graphics__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h2: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h1;
            teletext_combs__current_character_state__hold_graphics__var = 1'h0;
            teletext_combs__next_character_state__hold_graphics__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h3: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h1;
            teletext_combs__current_character_state__hold_graphics__var = 1'h0;
            teletext_combs__next_character_state__hold_graphics__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h4: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h1;
            teletext_combs__current_character_state__hold_graphics__var = 1'h0;
            teletext_combs__next_character_state__hold_graphics__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h5: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h1;
            teletext_combs__current_character_state__hold_graphics__var = 1'h0;
            teletext_combs__next_character_state__hold_graphics__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h6: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h1;
            teletext_combs__current_character_state__hold_graphics__var = 1'h0;
            teletext_combs__next_character_state__hold_graphics__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h7: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h1;
            teletext_combs__current_character_state__hold_graphics__var = 1'h0;
            teletext_combs__next_character_state__hold_graphics__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = !(teletext_state__character_state__text_mode!=1'h0);
            end
        7'h8: // req 1
            begin
            teletext_combs__next_character_state__flashing__var = 1'h1;
            end
        7'h9: // req 1
            begin
            teletext_combs__current_character_state__flashing__var = 1'h0;
            teletext_combs__next_character_state__flashing__var = 1'h0;
            end
        7'h11: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h12: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h13: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h14: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h15: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h16: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'h17: // req 1
            begin
            teletext_combs__next_character_state__foreground_color__var = load_state__character__character[2:0];
            teletext_combs__next_character_state__text_mode__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = teletext_state__character_state__text_mode;
            end
        7'hc: // req 1
            begin
            teletext_combs__current_character_state__dbl_height__var = 1'h0;
            teletext_combs__next_character_state__dbl_height__var = 1'h0;
            teletext_combs__current_character_state__reset_held_graphics__var = 1'h1;
            end
        7'hd: // req 1
            begin
            teletext_combs__current_character_state__reset_held_graphics__var = 1'h1;
            teletext_combs__next_character_state__dbl_height__var = 1'h1;
            end
        7'h19: // req 1
            begin
            teletext_combs__current_character_state__contiguous_graphics__var = 1'h1;
            teletext_combs__next_character_state__contiguous_graphics__var = 1'h1;
            end
        7'h1a: // req 1
            begin
            teletext_combs__current_character_state__contiguous_graphics__var = 1'h0;
            teletext_combs__next_character_state__contiguous_graphics__var = 1'h0;
            end
        7'h1c: // req 1
            begin
            teletext_combs__current_character_state__background_color__var = 3'h0;
            teletext_combs__next_character_state__background_color__var = 3'h0;
            end
        7'h1d: // req 1
            begin
            teletext_combs__current_character_state__background_color__var = teletext_state__character_state__foreground_color;
            teletext_combs__next_character_state__background_color__var = teletext_state__character_state__foreground_color;
            end
        7'h1e: // req 1
            begin
            teletext_combs__current_character_state__hold_graphics__var = 1'h1;
            teletext_combs__next_character_state__hold_graphics__var = 1'h1;
            end
        7'h1f: // req 1
            begin
            teletext_combs__next_character_state__hold_graphics__var = 1'h0;
            end
        default: // req 1
            begin
            teletext_combs__can_be_replaced_with_hold__var = 1'h0;
            end
        endcase
        teletext_combs__pixel_scanline__var = timing_state__scanline;
        if ((teletext_state__character_state__dbl_height!=1'h0))
        begin
            teletext_combs__pixel_scanline__var = {1'h0,timing_state__scanline[4:1]};
            if ((teletext_state__last_row_contained_dbl_height!=1'h0))
            begin
                teletext_combs__pixel_scanline__var = (teletext_combs__pixel_scanline__var+5'ha);
            end //if
        end //if
        teletext_combs__next_character_state__background_color = teletext_combs__next_character_state__background_color__var;
        teletext_combs__next_character_state__foreground_color = teletext_combs__next_character_state__foreground_color__var;
        teletext_combs__next_character_state__flashing = teletext_combs__next_character_state__flashing__var;
        teletext_combs__next_character_state__text_mode = teletext_combs__next_character_state__text_mode__var;
        teletext_combs__next_character_state__contiguous_graphics = teletext_combs__next_character_state__contiguous_graphics__var;
        teletext_combs__next_character_state__dbl_height = teletext_combs__next_character_state__dbl_height__var;
        teletext_combs__next_character_state__hold_graphics = teletext_combs__next_character_state__hold_graphics__var;
        teletext_combs__current_character_state__background_color = teletext_combs__current_character_state__background_color__var;
        teletext_combs__current_character_state__flashing = teletext_combs__current_character_state__flashing__var;
        teletext_combs__current_character_state__contiguous_graphics = teletext_combs__current_character_state__contiguous_graphics__var;
        teletext_combs__current_character_state__dbl_height = teletext_combs__current_character_state__dbl_height__var;
        teletext_combs__current_character_state__hold_graphics = teletext_combs__current_character_state__hold_graphics__var;
        teletext_combs__current_character_state__reset_held_graphics = teletext_combs__current_character_state__reset_held_graphics__var;
        teletext_combs__can_be_replaced_with_hold = teletext_combs__can_be_replaced_with_hold__var;
        teletext_combs__pixel_scanline = teletext_combs__pixel_scanline__var;
    end //always

    //b teletext_control_decode__posedge_clk_active_low_reset_n clock process
        //   
        //       Decode the 'load_state' character if a control character; handle the state of the line (colors, graphics, etc)
        //       
    always @( posedge clk or negedge reset_n)
    begin : teletext_control_decode__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            teletext_state__character__valid <= 1'h0;
            teletext_state__character__character <= 7'h0;
            teletext_state__character_state__background_color <= 3'h0;
            teletext_state__character_state__foreground_color <= 3'h0;
            teletext_state__character_state__held_character <= 1'h0;
            teletext_state__character_state__flashing <= 1'h0;
            teletext_state__character_state__text_mode <= 1'h0;
            teletext_state__character_state__contiguous_graphics <= 1'h0;
            teletext_state__character_state__dbl_height <= 1'h0;
            teletext_state__character_state__hold_graphics <= 1'h0;
            teletext_state__character_state__reset_held_graphics <= 1'h0;
            teletext_state__row_contains_dbl_height <= 1'h0;
            teletext_state__last_row_contained_dbl_height <= 1'h0;
        end
        else if (clk__enable)
        begin
            teletext_state__character__valid <= 1'h0;
            if ((load_state__character__valid!=1'h0))
            begin
                teletext_state__character__valid <= load_state__character__valid;
                teletext_state__character__character <= load_state__character__character;
                teletext_state__character_state__background_color <= teletext_combs__next_character_state__background_color;
                teletext_state__character_state__foreground_color <= teletext_combs__next_character_state__foreground_color;
                teletext_state__character_state__held_character <= teletext_combs__next_character_state__held_character;
                teletext_state__character_state__flashing <= teletext_combs__next_character_state__flashing;
                teletext_state__character_state__text_mode <= teletext_combs__next_character_state__text_mode;
                teletext_state__character_state__contiguous_graphics <= teletext_combs__next_character_state__contiguous_graphics;
                teletext_state__character_state__dbl_height <= teletext_combs__next_character_state__dbl_height;
                teletext_state__character_state__hold_graphics <= teletext_combs__next_character_state__hold_graphics;
                teletext_state__character_state__reset_held_graphics <= teletext_combs__next_character_state__reset_held_graphics;
                if ((teletext_combs__current_character_state__dbl_height!=1'h0))
                begin
                    teletext_state__row_contains_dbl_height <= 1'h1;
                end //if
            end //if
            if ((timing_state__timings__end_of_scanline!=1'h0))
            begin
                teletext_state__character_state__background_color <= 3'h0;
                teletext_state__character_state__foreground_color <= 3'h7;
                teletext_state__character_state__held_character <= 1'h0;
                teletext_state__character_state__flashing <= 1'h0;
                teletext_state__character_state__dbl_height <= 1'h0;
                teletext_state__character_state__text_mode <= 1'h1;
                teletext_state__character_state__hold_graphics <= 1'h0;
                teletext_state__character_state__contiguous_graphics <= 1'h1;
            end //if
            if (((timing_state__timings__end_of_scanline!=1'h0)&&(timing_state__last_scanline!=1'h0)))
            begin
                teletext_state__last_row_contained_dbl_height <= (teletext_state__row_contains_dbl_height ^ teletext_state__last_row_contained_dbl_height);
                teletext_state__row_contains_dbl_height <= 1'h0;
            end //if
            if ((timing_state__timings__restart_frame!=1'h0))
            begin
                teletext_state__last_row_contained_dbl_height <= 1'h0;
                teletext_state__row_contains_dbl_height <= 1'h0;
            end //if
        end //if
    end //always

    //b character_rom_and_pixel_generation__comb combinatorial process
        //   
        //       
    always @ ( * )//character_rom_and_pixel_generation__comb
    begin: character_rom_and_pixel_generation__comb_code
    reg [9:0]pixel_combs__rom_scanline_data__var;
    reg [4:0]pixel_combs__diagonal_0__var;
    reg [4:0]pixel_combs__diagonal_1__var;
    reg [4:0]pixel_combs__diagonal_2__var;
    reg [4:0]pixel_combs__diagonal_3__var;
    reg [11:0]pixel_combs__smoothed_scanline_data__var;
    reg [11:0]pixel_combs__graphics_data__var;
        case (teletext_combs__pixel_scanline[4:1]) //synopsys parallel_case
        4'h0: // req 1
            begin
            pixel_combs__rom_scanline_data__var = {rom_data[4:0],5'h0};
            end
        4'h1: // req 1
            begin
            pixel_combs__rom_scanline_data__var = rom_data[9:0];
            end
        4'h2: // req 1
            begin
            pixel_combs__rom_scanline_data__var = rom_data[14:5];
            end
        4'h3: // req 1
            begin
            pixel_combs__rom_scanline_data__var = rom_data[19:10];
            end
        4'h4: // req 1
            begin
            pixel_combs__rom_scanline_data__var = rom_data[24:15];
            end
        4'h5: // req 1
            begin
            pixel_combs__rom_scanline_data__var = rom_data[29:20];
            end
        4'h6: // req 1
            begin
            pixel_combs__rom_scanline_data__var = rom_data[34:25];
            end
        4'h7: // req 1
            begin
            pixel_combs__rom_scanline_data__var = rom_data[39:30];
            end
        4'h8: // req 1
            begin
            pixel_combs__rom_scanline_data__var = rom_data[44:35];
            end
        default: // req 1
            begin
            pixel_combs__rom_scanline_data__var = {5'h0,rom_data[44:40]};
            end
        endcase
        pixel_combs__diagonal_0__var = (pixel_combs__rom_scanline_data__var[9:5] & {pixel_combs__rom_scanline_data__var[3:0],1'h0});
        pixel_combs__diagonal_1__var = (pixel_combs__rom_scanline_data__var[9:5] & {1'h0,pixel_combs__rom_scanline_data__var[4:1]});
        pixel_combs__diagonal_2__var = (pixel_combs__rom_scanline_data__var[4:0] & {pixel_combs__rom_scanline_data__var[8:5],1'h0});
        pixel_combs__diagonal_3__var = (pixel_combs__rom_scanline_data__var[4:0] & {1'h0,pixel_combs__rom_scanline_data__var[9:6]});
        pixel_combs__diagonal_0__var = (pixel_combs__diagonal_0__var & ~{pixel_combs__rom_scanline_data__var[8:5],1'h0});
        pixel_combs__diagonal_1__var = (pixel_combs__diagonal_1__var & ~{1'h0,pixel_combs__rom_scanline_data__var[9:6]});
        pixel_combs__diagonal_2__var = (pixel_combs__diagonal_2__var & ~{pixel_combs__rom_scanline_data__var[3:0],1'h0});
        pixel_combs__diagonal_3__var = (pixel_combs__diagonal_3__var & ~{1'h0,pixel_combs__rom_scanline_data__var[4:1]});
        if (!(teletext_combs__pixel_scanline[0]!=1'h0))
        begin
            pixel_combs__smoothed_scanline_data__var = {{{{{{{{{{2'h0,(pixel_combs__rom_scanline_data__var[4] | pixel_combs__diagonal_1__var[4])},(pixel_combs__rom_scanline_data__var[4] | pixel_combs__diagonal_0__var[4])},(pixel_combs__rom_scanline_data__var[3] | pixel_combs__diagonal_1__var[3])},(pixel_combs__rom_scanline_data__var[3] | pixel_combs__diagonal_0__var[3])},(pixel_combs__rom_scanline_data__var[2] | pixel_combs__diagonal_1__var[2])},(pixel_combs__rom_scanline_data__var[2] | pixel_combs__diagonal_0__var[2])},(pixel_combs__rom_scanline_data__var[1] | pixel_combs__diagonal_1__var[1])},(pixel_combs__rom_scanline_data__var[1] | pixel_combs__diagonal_0__var[1])},(pixel_combs__rom_scanline_data__var[0] | pixel_combs__diagonal_1__var[0])},(pixel_combs__rom_scanline_data__var[0] | pixel_combs__diagonal_0__var[0])};
        end //if
        else
        
        begin
            pixel_combs__smoothed_scanline_data__var = {{{{{{{{{{2'h0,(pixel_combs__rom_scanline_data__var[9] | pixel_combs__diagonal_3__var[4])},(pixel_combs__rom_scanline_data__var[9] | pixel_combs__diagonal_2__var[4])},(pixel_combs__rom_scanline_data__var[8] | pixel_combs__diagonal_3__var[3])},(pixel_combs__rom_scanline_data__var[8] | pixel_combs__diagonal_2__var[3])},(pixel_combs__rom_scanline_data__var[7] | pixel_combs__diagonal_3__var[2])},(pixel_combs__rom_scanline_data__var[7] | pixel_combs__diagonal_2__var[2])},(pixel_combs__rom_scanline_data__var[6] | pixel_combs__diagonal_3__var[1])},(pixel_combs__rom_scanline_data__var[6] | pixel_combs__diagonal_2__var[1])},(pixel_combs__rom_scanline_data__var[5] | pixel_combs__diagonal_3__var[0])},(pixel_combs__rom_scanline_data__var[5] | pixel_combs__diagonal_2__var[0])};
        end //else
        if (!(timing_state__timings__smoothe!=1'h0))
        begin
            pixel_combs__smoothed_scanline_data__var = {{{{{{{{{{2'h0,pixel_combs__rom_scanline_data__var[4]},pixel_combs__rom_scanline_data__var[4]},pixel_combs__rom_scanline_data__var[3]},pixel_combs__rom_scanline_data__var[3]},pixel_combs__rom_scanline_data__var[2]},pixel_combs__rom_scanline_data__var[2]},pixel_combs__rom_scanline_data__var[1]},pixel_combs__rom_scanline_data__var[1]},pixel_combs__rom_scanline_data__var[0]},pixel_combs__rom_scanline_data__var[0]};
        end //if
        pixel_combs__graphics_data__var = 12'h0;
        case (teletext_combs__pixel_scanline[4:1]) //synopsys parallel_case
        4'h0: // req 1
            begin
            pixel_combs__graphics_data__var = (((teletext_state__character__character[0]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[1]!=1'h0)?12'h3f:12'h0));
            end
        4'h1: // req 1
            begin
            pixel_combs__graphics_data__var = (((teletext_state__character__character[0]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[1]!=1'h0)?12'h3f:12'h0));
            end
        4'h2: // req 1
            begin
            pixel_combs__graphics_data__var = (((teletext_state__character__character[0]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[1]!=1'h0)?12'h3f:12'h0));
            end
        4'h7: // req 1
            begin
            pixel_combs__graphics_data__var = (((teletext_state__character__character[4]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[6]!=1'h0)?12'h3f:12'h0));
            end
        4'h8: // req 1
            begin
            pixel_combs__graphics_data__var = (((teletext_state__character__character[4]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[6]!=1'h0)?12'h3f:12'h0));
            end
        4'h9: // req 1
            begin
            pixel_combs__graphics_data__var = (((teletext_state__character__character[4]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[6]!=1'h0)?12'h3f:12'h0));
            end
        default: // req 1
            begin
            pixel_combs__graphics_data__var = (((teletext_state__character__character[2]!=1'h0)?12'hfc0:12'h0) | ((teletext_state__character__character[3]!=1'h0)?12'h3f:12'h0));
            end
        endcase
        if (!(output_state__character_state__contiguous_graphics!=1'h0))
        begin
            pixel_combs__graphics_data__var[11:10] = 2'h0;
            pixel_combs__graphics_data__var[5:4] = 2'h0;
            case (teletext_combs__pixel_scanline[4:1]) //synopsys parallel_case
            4'h2: // req 1
                begin
                pixel_combs__graphics_data__var = 12'h0;
                end
            4'h6: // req 1
                begin
                pixel_combs__graphics_data__var = 12'h0;
                end
            4'h9: // req 1
                begin
                pixel_combs__graphics_data__var = 12'h0;
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
        if (!(output_state__character_state__text_mode!=1'h0))
        begin
            if ((teletext_state__character__character[5]!=1'h0))
            begin
                pixel_combs__smoothed_scanline_data__var = pixel_combs__graphics_data__var;
            end //if
        end //if
        if (((output_state__character_state__hold_graphics!=1'h0)&&(teletext_state__character__character[6:5]==2'h0)))
        begin
            pixel_combs__smoothed_scanline_data__var = output_state__held_graphics_data;
        end //if
        pixel_combs__rom_scanline_data = pixel_combs__rom_scanline_data__var;
        pixel_combs__diagonal_0 = pixel_combs__diagonal_0__var;
        pixel_combs__diagonal_1 = pixel_combs__diagonal_1__var;
        pixel_combs__diagonal_2 = pixel_combs__diagonal_2__var;
        pixel_combs__diagonal_3 = pixel_combs__diagonal_3__var;
        pixel_combs__smoothed_scanline_data = pixel_combs__smoothed_scanline_data__var;
        pixel_combs__graphics_data = pixel_combs__graphics_data__var;
    end //always

    //b character_rom_and_pixel_generation__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : character_rom_and_pixel_generation__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            output_state__held_graphics_data <= 12'h0;
        end
        else if (clk__enable)
        begin
            if (!(output_state__character_state__text_mode!=1'h0))
            begin
                if ((teletext_state__character__character[5]!=1'h0))
                begin
                    output_state__held_graphics_data <= pixel_combs__graphics_data;
                end //if
            end //if
            if ((timing_state__timings__end_of_scanline!=1'h0))
            begin
                output_state__held_graphics_data <= 12'h0;
            end //if
            if ((output_state__character_state__reset_held_graphics!=1'h0))
            begin
                output_state__held_graphics_data <= 12'h0;
            end //if
        end //if
    end //always

    //b character_pixel_generation__comb combinatorial process
        //   
        //       Get two scanlines - current and next (next of 0 if none)
        //       
    always @ ( * )//character_pixel_generation__comb
    begin: character_pixel_generation__comb_code
    reg [11:0]pixels__red__var;
    reg [11:0]pixels__blue__var;
    reg [11:0]pixels__green__var;
        pixels__red__var = 12'h0;
        pixels__blue__var = 12'h0;
        pixels__green__var = 12'h0;
        pixels__red__var[0] = output_state__colors[0][0];
        pixels__green__var[0] = output_state__colors[0][1];
        pixels__blue__var[0] = output_state__colors[0][2];
        pixels__red__var[1] = output_state__colors[1][0];
        pixels__green__var[1] = output_state__colors[1][1];
        pixels__blue__var[1] = output_state__colors[1][2];
        pixels__red__var[2] = output_state__colors[2][0];
        pixels__green__var[2] = output_state__colors[2][1];
        pixels__blue__var[2] = output_state__colors[2][2];
        pixels__red__var[3] = output_state__colors[3][0];
        pixels__green__var[3] = output_state__colors[3][1];
        pixels__blue__var[3] = output_state__colors[3][2];
        pixels__red__var[4] = output_state__colors[4][0];
        pixels__green__var[4] = output_state__colors[4][1];
        pixels__blue__var[4] = output_state__colors[4][2];
        pixels__red__var[5] = output_state__colors[5][0];
        pixels__green__var[5] = output_state__colors[5][1];
        pixels__blue__var[5] = output_state__colors[5][2];
        pixels__red__var[6] = output_state__colors[6][0];
        pixels__green__var[6] = output_state__colors[6][1];
        pixels__blue__var[6] = output_state__colors[6][2];
        pixels__red__var[7] = output_state__colors[7][0];
        pixels__green__var[7] = output_state__colors[7][1];
        pixels__blue__var[7] = output_state__colors[7][2];
        pixels__red__var[8] = output_state__colors[8][0];
        pixels__green__var[8] = output_state__colors[8][1];
        pixels__blue__var[8] = output_state__colors[8][2];
        pixels__red__var[9] = output_state__colors[9][0];
        pixels__green__var[9] = output_state__colors[9][1];
        pixels__blue__var[9] = output_state__colors[9][2];
        pixels__red__var[10] = output_state__colors[10][0];
        pixels__green__var[10] = output_state__colors[10][1];
        pixels__blue__var[10] = output_state__colors[10][2];
        pixels__red__var[11] = output_state__colors[11][0];
        pixels__green__var[11] = output_state__colors[11][1];
        pixels__blue__var[11] = output_state__colors[11][2];
        pixels__valid = output_state__valid;
        pixels__last_scanline = timing_state__last_scanline;
        pixels__red = pixels__red__var;
        pixels__blue = pixels__blue__var;
        pixels__green = pixels__green__var;
    end //always

    //b character_pixel_generation__posedge_clk_active_low_reset_n clock process
        //   
        //       Get two scanlines - current and next (next of 0 if none)
        //       
    always @( posedge clk or negedge reset_n)
    begin : character_pixel_generation__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            output_state__character_state__background_color <= 3'h0;
            output_state__character_state__foreground_color <= 3'h0;
            output_state__character_state__held_character <= 1'h0;
            output_state__character_state__flashing <= 1'h0;
            output_state__character_state__text_mode <= 1'h0;
            output_state__character_state__contiguous_graphics <= 1'h0;
            output_state__character_state__dbl_height <= 1'h0;
            output_state__character_state__hold_graphics <= 1'h0;
            output_state__character_state__reset_held_graphics <= 1'h0;
            output_state__valid <= 1'h0;
            output_state__colors[0] <= 3'h0;
            output_state__colors[1] <= 3'h0;
            output_state__colors[2] <= 3'h0;
            output_state__colors[3] <= 3'h0;
            output_state__colors[4] <= 3'h0;
            output_state__colors[5] <= 3'h0;
            output_state__colors[6] <= 3'h0;
            output_state__colors[7] <= 3'h0;
            output_state__colors[8] <= 3'h0;
            output_state__colors[9] <= 3'h0;
            output_state__colors[10] <= 3'h0;
            output_state__colors[11] <= 3'h0;
        end
        else if (clk__enable)
        begin
            output_state__character_state__background_color <= teletext_combs__current_character_state__background_color;
            output_state__character_state__foreground_color <= teletext_combs__current_character_state__foreground_color;
            output_state__character_state__held_character <= teletext_combs__current_character_state__held_character;
            output_state__character_state__flashing <= teletext_combs__current_character_state__flashing;
            output_state__character_state__text_mode <= teletext_combs__current_character_state__text_mode;
            output_state__character_state__contiguous_graphics <= teletext_combs__current_character_state__contiguous_graphics;
            output_state__character_state__dbl_height <= teletext_combs__current_character_state__dbl_height;
            output_state__character_state__hold_graphics <= teletext_combs__current_character_state__hold_graphics;
            output_state__character_state__reset_held_graphics <= teletext_combs__current_character_state__reset_held_graphics;
            output_state__valid <= teletext_state__character__valid;
            output_state__colors[0] <= ((pixel_combs__smoothed_scanline_data[0]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
            output_state__colors[1] <= ((pixel_combs__smoothed_scanline_data[1]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
            output_state__colors[2] <= ((pixel_combs__smoothed_scanline_data[2]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
            output_state__colors[3] <= ((pixel_combs__smoothed_scanline_data[3]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
            output_state__colors[4] <= ((pixel_combs__smoothed_scanline_data[4]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
            output_state__colors[5] <= ((pixel_combs__smoothed_scanline_data[5]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
            output_state__colors[6] <= ((pixel_combs__smoothed_scanline_data[6]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
            output_state__colors[7] <= ((pixel_combs__smoothed_scanline_data[7]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
            output_state__colors[8] <= ((pixel_combs__smoothed_scanline_data[8]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
            output_state__colors[9] <= ((pixel_combs__smoothed_scanline_data[9]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
            output_state__colors[10] <= ((pixel_combs__smoothed_scanline_data[10]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
            output_state__colors[11] <= ((pixel_combs__smoothed_scanline_data[11]!=1'h0)?output_state__character_state__foreground_color:output_state__character_state__background_color);
        end //if
    end //always

endmodule // teletext
