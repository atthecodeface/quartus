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

//a Module saa5050
    //   
    //   Teletext characters are displayed from a 12x20 grid.
    //   The ROM characters have two background rows, and then are displayed with 2 background pixels on the left, and then 10 pixels from the ROM
    //   The ROM is actually 5x9, and it is doubled to 10x18
    //   Doubling without smoothing can be achieved be true doubling
    //   Doubling with smoothing is done on intervening lines:
    //   
    //   The ROM A is:
    //   ..*..
    //   .*.*.
    //   *...*
    //   *...*
    //   *****
    //   *...*
    //   *...*
    //   .....
    //   .....
    //   
    //   So a non-smoothed A is
    //   ....**....
    //   ....**....
    //   ..**..**..
    //   ..**..**..
    //   **......**
    //   **......**
    //   **......**
    //   **......**
    //   **********
    //   **********
    //   **......**
    //   **......**
    //   **......**
    //   **......**
    //   ..........
    //   ..........
    //   ..........
    //   ..........
    //   
    //   ..*..
    //   .*.*.
    //   *...*
    //   *...*
    //   *****
    //   *...*
    //   *...*
    //   .....
    //   .....
    //   
    //   The smoothing is only to smoothe diagonals.
    //   So the centroids are added on diagonals (baseline requirement...)
    //   In fact, one can add 2x2 blobs on the diagonals:
    //   
    //   A smoothed A is then:
    //   ....**....
    //   ...****...
    //   ..******..
    //   .***..***.
    //   ***....***
    //   **......**
    //   **......**
    //   **......**
    //   **********
    //   **********
    //   **......**
    //   **......**
    //   **......**
    //   **......**
    //   ..........
    //   ..........
    //   ..........
    //   ..........
    //   
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
    //   The BBC micro seems to use 19 rows per character, but in practice (since it is interlaced sync and video) it will use 10 in each field, and CRS will be set for even fields
    //   
    //   
    //   
module saa5050
(
    clk_2MHz,
    clk_2MHz__enable,

    host_sram_request__valid,
    host_sram_request__read_enable,
    host_sram_request__write_enable,
    host_sram_request__select,
    host_sram_request__address,
    host_sram_request__write_data,
    po,
    de,
    lose,
    bcs_n,
    crs,
    dew,
    glr,
    dlim,
    data_in,
    data_n,
    superimpose_n,
    reset_n,
    clk_1MHz_enable,

    blan,
    blue,
    green,
    red,
    tlc_n
);

    //b Clocks
        //   Supposedly 6MHz pixel clock (TR6), except we use 2MHz and deliver 3 pixels per tick; rising edge should be coincident with clk_1MHz edges
    input clk_2MHz;
    input clk_2MHz__enable;

    //b Inputs
        //   Write only, writes on clk_2MHz rising, acknowledge must be handled by supermodule
    input host_sram_request__valid;
    input host_sram_request__read_enable;
    input host_sram_request__write_enable;
    input [7:0]host_sram_request__select;
    input [23:0]host_sram_request__address;
    input [63:0]host_sram_request__write_data;
        //   Picture on
    input po;
        //   Display enable
    input de;
        //   Load output shift register enable - must be low before start of character data in a scanline, rising with (or one tick earlier?) the data; changes off falling F1, rising clk_1MHz
    input lose;
        //   Assert (low) to enable double-height characters (?) 
    input bcs_n;
        //   Character rounding select - drive high on even interlace fields to enable use of rounded character data (kinda indicates 'half line')
    input crs;
        //   Data entry window - used to determine flashing rate and resets the ROM decoders - can be tied to vsync
    input dew;
        //   General line reset - can be tied to hsync - assert once per line before data comes in
    input glr;
        //   clocks serial data in somehow (datasheet is dreadful...)
    input dlim;
        //   Parallel data in
    input [6:0]data_in;
        //   Serial data in, not implemented
    input data_n;
        //   Not implemented
    input superimpose_n;
    input reset_n;
        //   Clock enable high for clk_2MHz when the SAA's 1MHz would normally tick
    input clk_1MHz_enable;

    //b Outputs
    output blan;
    output [5:0]blue;
    output [5:0]green;
    output [5:0]red;
        //   Asserted (low) when double-height characters occur (?) 
    output tlc_n;

// output components here

    //b Output combinatorials
    reg blan;
    reg [5:0]blue;
    reg [5:0]green;
    reg [5:0]red;
        //   Asserted (low) when double-height characters occur (?) 
    reg tlc_n;

    //b Output nets

    //b Internal and output registers
    reg [5:0]hexpixel_state__pixels;
    reg [2:0]hexpixel_state__character_state__background_color;
    reg [2:0]hexpixel_state__character_state__foreground_color;
    reg hexpixel_state__character_state__held_character;
    reg hexpixel_state__character_state__flashing;
    reg hexpixel_state__character_state__text_mode;
    reg hexpixel_state__character_state__contiguous_graphics;
    reg hexpixel_state__character_state__dbl_height;
    reg hexpixel_state__character_state__hold_graphics;
    reg pixel_state__character_data_toggle;
    reg pixel_state__end_of_scanline;
    reg pixel_state__end_of_row;
    reg pixel_state__end_of_field;
    reg [2:0]pixel_state__character_state__background_color;
    reg [2:0]pixel_state__character_state__foreground_color;
    reg pixel_state__character_state__held_character;
    reg pixel_state__character_state__flashing;
    reg pixel_state__character_state__text_mode;
    reg pixel_state__character_state__contiguous_graphics;
    reg pixel_state__character_state__dbl_height;
    reg pixel_state__character_state__hold_graphics;
    reg [6:0]pixel_state__character_data;
    reg [1:0]pixel_state__hexpixel_of_character;
    reg pixel_state__row_contains_dbl_height;
    reg pixel_state__last_row_contained_dbl_height;
    reg load_state__last_lose;
    reg [6:0]load_state__character_data;
    reg load_state__character_data_toggle;
    reg [3:0]load_state__scanline;
    reg load_state__end_of_scanline;
    reg load_state__end_of_row;
    reg load_state__end_of_field;
    reg [5:0]load_state__flashing_counter;
    reg load_state__flash_on;

    //b Internal combinatorials
    reg [2:0]hexpixel_colors[5:0];
    reg pixel__new_character;
    reg pixel__end_of_scanline;
    reg pixel__end_of_row;
    reg pixel__end_of_field;
    reg [2:0]pixel__next_character_state__background_color;
    reg [2:0]pixel__next_character_state__foreground_color;
    reg pixel__next_character_state__held_character;
    reg pixel__next_character_state__flashing;
    reg pixel__next_character_state__text_mode;
    reg pixel__next_character_state__contiguous_graphics;
    reg pixel__next_character_state__dbl_height;
    reg pixel__next_character_state__hold_graphics;
    reg [2:0]pixel__current_character_state__background_color;
    reg [2:0]pixel__current_character_state__foreground_color;
    reg pixel__current_character_state__held_character;
    reg pixel__current_character_state__flashing;
    reg pixel__current_character_state__text_mode;
    reg pixel__current_character_state__contiguous_graphics;
    reg pixel__current_character_state__dbl_height;
    reg pixel__current_character_state__hold_graphics;
    reg pixel__can_be_replaced_with_hold;
    reg pixel__reset_held_graphics;
    reg [9:0]pixel__rom_scanline_data;
    reg [6:0]pixel__character_data;
    reg [11:0]pixel__smoothed_scanline_data;

    //b Internal nets
    wire [63:0]pixel_rom_data;

    //b Clock gating module instances
    //b Module instances
    se_sram_srw_128x64 character_rom(
        .sram_clock(clk_2MHz),
        .sram_clock__enable(1'b1),
        .write_data(host_sram_request__write_data),
        .address((((host_sram_request__valid!=1'h0)&&(host_sram_request__select==8'h14))?host_sram_request__address[6:0]:load_state__character_data)),
        .write_enable(((host_sram_request__write_enable!=1'h0)&&(host_sram_request__select==8'h14))),
        .read_not_write(!(host_sram_request__write_enable!=1'h0)),
        .select(1'h1),
        .data_out(            pixel_rom_data)         );
    //b scanline_and_loading clock process
        //   
        //       
    always @( posedge clk_2MHz or negedge reset_n)
    begin : scanline_and_loading__code
        if (reset_n==1'b0)
        begin
            load_state__last_lose <= 1'h0;
            load_state__character_data <= 7'h0;
            load_state__character_data_toggle <= 1'h0;
            load_state__end_of_scanline <= 1'h0;
            load_state__scanline <= 4'h0;
            load_state__end_of_row <= 1'h0;
            load_state__end_of_field <= 1'h0;
            load_state__flashing_counter <= 6'h0;
            load_state__flash_on <= 1'h0;
        end
        else if (clk_2MHz__enable)
        begin
            load_state__last_lose <= lose;
            if ((lose!=1'h0))
            begin
                load_state__character_data <= data_in;
                load_state__character_data_toggle <= !(load_state__character_data_toggle!=1'h0);
            end //if
            load_state__end_of_scanline <= 1'h0;
            if (((load_state__last_lose!=1'h0)&&!(lose!=1'h0)))
            begin
                load_state__character_data <= 7'h0;
                load_state__character_data_toggle <= !(load_state__character_data_toggle!=1'h0);
                load_state__scanline <= (load_state__scanline+4'h1);
                load_state__end_of_scanline <= 1'h1;
                if ((load_state__scanline==4'h9))
                begin
                    load_state__end_of_row <= 1'h1;
                end //if
            end //if
            if ((dew!=1'h0))
            begin
                load_state__end_of_row <= 1'h1;
                load_state__end_of_field <= 1'h1;
            end //if
            if ((load_state__end_of_row!=1'h0))
            begin
                load_state__scanline <= 4'h0;
                load_state__character_data_toggle <= 1'h0;
                load_state__end_of_row <= 1'h0;
            end //if
            if ((load_state__end_of_field!=1'h0))
            begin
                load_state__flashing_counter <= (load_state__flashing_counter+6'h1);
                if ((load_state__flashing_counter==6'ha))
                begin
                    load_state__flash_on <= 1'h1;
                end //if
                if ((load_state__flashing_counter==6'h28))
                begin
                    load_state__flashing_counter <= 6'h0;
                    load_state__flash_on <= 1'h0;
                end //if
                load_state__end_of_field <= 1'h0;
            end //if
            if (!(clk_1MHz_enable!=1'h0))
            begin
                load_state__last_lose <= load_state__last_lose;
                load_state__character_data <= load_state__character_data;
                load_state__character_data_toggle <= load_state__character_data_toggle;
                load_state__scanline <= load_state__scanline;
                load_state__end_of_scanline <= load_state__end_of_scanline;
                load_state__end_of_row <= load_state__end_of_row;
                load_state__end_of_field <= load_state__end_of_field;
                load_state__flashing_counter <= load_state__flashing_counter;
                load_state__flash_on <= load_state__flash_on;
            end //if
        end //if
    end //always

    //b character_rom_and_control_decode__comb combinatorial process
        //   
        //       
    always @ ( * )//character_rom_and_control_decode__comb
    begin: character_rom_and_control_decode__comb_code
    reg [2:0]pixel__next_character_state__background_color__var;
    reg [2:0]pixel__next_character_state__foreground_color__var;
    reg pixel__next_character_state__flashing__var;
    reg pixel__next_character_state__text_mode__var;
    reg pixel__next_character_state__contiguous_graphics__var;
    reg pixel__next_character_state__dbl_height__var;
    reg pixel__next_character_state__hold_graphics__var;
    reg [2:0]pixel__current_character_state__background_color__var;
    reg pixel__current_character_state__flashing__var;
    reg pixel__current_character_state__contiguous_graphics__var;
    reg pixel__current_character_state__dbl_height__var;
    reg pixel__can_be_replaced_with_hold__var;
        pixel__next_character_state__background_color__var = pixel_state__character_state__background_color;
        pixel__next_character_state__foreground_color__var = pixel_state__character_state__foreground_color;
        pixel__next_character_state__held_character = pixel_state__character_state__held_character;
        pixel__next_character_state__flashing__var = pixel_state__character_state__flashing;
        pixel__next_character_state__text_mode__var = pixel_state__character_state__text_mode;
        pixel__next_character_state__contiguous_graphics__var = pixel_state__character_state__contiguous_graphics;
        pixel__next_character_state__dbl_height__var = pixel_state__character_state__dbl_height;
        pixel__next_character_state__hold_graphics__var = pixel_state__character_state__hold_graphics;
        pixel__current_character_state__background_color__var = pixel_state__character_state__background_color;
        pixel__current_character_state__foreground_color = pixel_state__character_state__foreground_color;
        pixel__current_character_state__held_character = pixel_state__character_state__held_character;
        pixel__current_character_state__flashing__var = pixel_state__character_state__flashing;
        pixel__current_character_state__text_mode = pixel_state__character_state__text_mode;
        pixel__current_character_state__contiguous_graphics__var = pixel_state__character_state__contiguous_graphics;
        pixel__current_character_state__dbl_height__var = pixel_state__character_state__dbl_height;
        pixel__current_character_state__hold_graphics = pixel_state__character_state__hold_graphics;
        pixel__can_be_replaced_with_hold__var = 1'h1;
        pixel__reset_held_graphics = 1'h0;
        case (load_state__character_data) //synopsys parallel_case
        7'h0: // req 1
            begin
            pixel__can_be_replaced_with_hold__var = 1'h1;
            end
        7'h1: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h1;
            end
        7'h2: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h1;
            end
        7'h3: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h1;
            end
        7'h4: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h1;
            end
        7'h5: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h1;
            end
        7'h6: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h1;
            end
        7'h7: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h1;
            end
        7'h8: // req 1
            begin
            pixel__next_character_state__flashing__var = 1'h1;
            end
        7'h9: // req 1
            begin
            pixel__current_character_state__flashing__var = 1'h0;
            pixel__next_character_state__flashing__var = 1'h0;
            end
        7'h11: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h0;
            end
        7'h12: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h0;
            end
        7'h13: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h0;
            end
        7'h14: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h0;
            end
        7'h15: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h0;
            end
        7'h16: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h0;
            end
        7'h17: // req 1
            begin
            pixel__next_character_state__foreground_color__var = load_state__character_data[2:0];
            pixel__next_character_state__text_mode__var = 1'h0;
            end
        7'hc: // req 1
            begin
            pixel__current_character_state__dbl_height__var = 1'h0;
            pixel__next_character_state__dbl_height__var = 1'h0;
            end
        7'hd: // req 1
            begin
            pixel__next_character_state__dbl_height__var = 1'h1;
            end
        7'h19: // req 1
            begin
            pixel__current_character_state__contiguous_graphics__var = 1'h1;
            pixel__next_character_state__contiguous_graphics__var = 1'h1;
            end
        7'h1a: // req 1
            begin
            pixel__current_character_state__contiguous_graphics__var = 1'h0;
            pixel__next_character_state__contiguous_graphics__var = 1'h0;
            end
        7'h1c: // req 1
            begin
            pixel__current_character_state__background_color__var = 3'h0;
            pixel__next_character_state__background_color__var = 3'h0;
            end
        7'h1d: // req 1
            begin
            pixel__current_character_state__background_color__var = pixel_state__character_state__foreground_color;
            pixel__next_character_state__background_color__var = pixel_state__character_state__foreground_color;
            end
        7'h1e: // req 1
            begin
            pixel__next_character_state__hold_graphics__var = 1'h1;
            pixel__next_character_state__hold_graphics__var = 1'h1;
            end
        7'h1f: // req 1
            begin
            pixel__next_character_state__hold_graphics__var = 1'h0;
            end
        default: // req 1
            begin
            pixel__can_be_replaced_with_hold__var = 1'h0;
            end
        endcase
        pixel__new_character = (pixel_state__character_data_toggle!=load_state__character_data_toggle);
        pixel__end_of_scanline = (!(pixel_state__end_of_scanline!=1'h0)&&(load_state__end_of_scanline!=1'h0));
        pixel__end_of_row = (!(pixel_state__end_of_row!=1'h0)&&(load_state__end_of_row!=1'h0));
        pixel__end_of_field = (!(pixel_state__end_of_field!=1'h0)&&(load_state__end_of_field!=1'h0));
        pixel__next_character_state__background_color = pixel__next_character_state__background_color__var;
        pixel__next_character_state__foreground_color = pixel__next_character_state__foreground_color__var;
        pixel__next_character_state__flashing = pixel__next_character_state__flashing__var;
        pixel__next_character_state__text_mode = pixel__next_character_state__text_mode__var;
        pixel__next_character_state__contiguous_graphics = pixel__next_character_state__contiguous_graphics__var;
        pixel__next_character_state__dbl_height = pixel__next_character_state__dbl_height__var;
        pixel__next_character_state__hold_graphics = pixel__next_character_state__hold_graphics__var;
        pixel__current_character_state__background_color = pixel__current_character_state__background_color__var;
        pixel__current_character_state__flashing = pixel__current_character_state__flashing__var;
        pixel__current_character_state__contiguous_graphics = pixel__current_character_state__contiguous_graphics__var;
        pixel__current_character_state__dbl_height = pixel__current_character_state__dbl_height__var;
        pixel__can_be_replaced_with_hold = pixel__can_be_replaced_with_hold__var;
    end //always

    //b character_rom_and_control_decode__posedge_clk_2MHz_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk_2MHz or negedge reset_n)
    begin : character_rom_and_control_decode__posedge_clk_2MHz_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            pixel_state__character_data <= 7'h0;
            pixel_state__character_data_toggle <= 1'h0;
            pixel_state__end_of_scanline <= 1'h0;
            pixel_state__end_of_row <= 1'h0;
            pixel_state__end_of_field <= 1'h0;
            pixel_state__hexpixel_of_character <= 2'h0;
            pixel_state__character_state__background_color <= 3'h0;
            pixel_state__character_state__foreground_color <= 3'h0;
            pixel_state__character_state__held_character <= 1'h0;
            pixel_state__character_state__flashing <= 1'h0;
            pixel_state__character_state__text_mode <= 1'h0;
            pixel_state__character_state__contiguous_graphics <= 1'h0;
            pixel_state__character_state__dbl_height <= 1'h0;
            pixel_state__character_state__hold_graphics <= 1'h0;
            pixel_state__row_contains_dbl_height <= 1'h0;
            pixel_state__last_row_contained_dbl_height <= 1'h0;
        end
        else if (clk_2MHz__enable)
        begin
            pixel_state__character_data <= load_state__character_data;
            pixel_state__character_data_toggle <= load_state__character_data_toggle;
            pixel_state__end_of_scanline <= load_state__end_of_scanline;
            pixel_state__end_of_row <= load_state__end_of_row;
            pixel_state__end_of_field <= load_state__end_of_field;
            pixel_state__hexpixel_of_character <= (pixel_state__hexpixel_of_character+2'h1);
            if ((pixel__new_character!=1'h0))
            begin
                pixel_state__character_state__background_color <= pixel__next_character_state__background_color;
                pixel_state__character_state__foreground_color <= pixel__next_character_state__foreground_color;
                pixel_state__character_state__held_character <= pixel__next_character_state__held_character;
                pixel_state__character_state__flashing <= pixel__next_character_state__flashing;
                pixel_state__character_state__text_mode <= pixel__next_character_state__text_mode;
                pixel_state__character_state__contiguous_graphics <= pixel__next_character_state__contiguous_graphics;
                pixel_state__character_state__dbl_height <= pixel__next_character_state__dbl_height;
                pixel_state__character_state__hold_graphics <= pixel__next_character_state__hold_graphics;
                pixel_state__hexpixel_of_character <= 2'h0;
                if ((pixel__current_character_state__dbl_height!=1'h0))
                begin
                    pixel_state__row_contains_dbl_height <= 1'h1;
                end //if
            end //if
            if ((pixel__end_of_scanline!=1'h0))
            begin
                pixel_state__character_state__background_color <= 3'h0;
                pixel_state__character_state__foreground_color <= 3'h7;
                pixel_state__character_state__held_character <= 1'h0;
                pixel_state__character_state__flashing <= 1'h0;
                pixel_state__character_state__text_mode <= 1'h1;
                pixel_state__character_state__contiguous_graphics <= 1'h1;
            end //if
            if ((pixel__end_of_row!=1'h0))
            begin
                pixel_state__last_row_contained_dbl_height <= pixel_state__row_contains_dbl_height;
                pixel_state__row_contains_dbl_height <= 1'h0;
            end //if
            if ((pixel__end_of_field!=1'h0))
            begin
                pixel_state__last_row_contained_dbl_height <= 1'h0;
                pixel_state__row_contains_dbl_height <= 1'h0;
            end //if
        end //if
    end //always

    //b character_pixel_generation__comb combinatorial process
        //   
        //       Get two scanlines - current and next (next of 0 if none)
        //       
    always @ ( * )//character_pixel_generation__comb
    begin: character_pixel_generation__comb_code
    reg [9:0]pixel__rom_scanline_data__var;
    reg [11:0]pixel__smoothed_scanline_data__var;
        case (load_state__scanline) //synopsys parallel_case
        4'h0: // req 1
            begin
            pixel__rom_scanline_data__var = {pixel_rom_data[4:0],5'h0};
            end
        4'h1: // req 1
            begin
            pixel__rom_scanline_data__var = pixel_rom_data[9:0];
            end
        4'h2: // req 1
            begin
            pixel__rom_scanline_data__var = pixel_rom_data[14:5];
            end
        4'h3: // req 1
            begin
            pixel__rom_scanline_data__var = pixel_rom_data[19:10];
            end
        4'h4: // req 1
            begin
            pixel__rom_scanline_data__var = pixel_rom_data[24:15];
            end
        4'h5: // req 1
            begin
            pixel__rom_scanline_data__var = pixel_rom_data[29:20];
            end
        4'h6: // req 1
            begin
            pixel__rom_scanline_data__var = pixel_rom_data[34:25];
            end
        4'h7: // req 1
            begin
            pixel__rom_scanline_data__var = pixel_rom_data[39:30];
            end
        4'h8: // req 1
            begin
            pixel__rom_scanline_data__var = pixel_rom_data[44:35];
            end
        default: // req 1
            begin
            pixel__rom_scanline_data__var = {5'h0,pixel_rom_data[39:35]};
            end
        endcase
        pixel__smoothed_scanline_data__var = {{{{{{{{{{2'h0,pixel__rom_scanline_data__var[4]},pixel__rom_scanline_data__var[4]},pixel__rom_scanline_data__var[3]},pixel__rom_scanline_data__var[3]},pixel__rom_scanline_data__var[2]},pixel__rom_scanline_data__var[2]},pixel__rom_scanline_data__var[1]},pixel__rom_scanline_data__var[1]},pixel__rom_scanline_data__var[0]},pixel__rom_scanline_data__var[0]};
        pixel__character_data = pixel_state__character_data;
        if (!(pixel__current_character_state__text_mode!=1'h0))
        begin
            if ((((load_state__scanline==4'h0)||(load_state__scanline==4'h1))||(load_state__scanline==4'h2)))
            begin
                pixel__smoothed_scanline_data__var = (((pixel__character_data[0]!=1'h0)?12'hfc0:12'h0) | ((pixel__character_data[1]!=1'h0)?12'h3f:12'h0));
            end //if
            else
            
            begin
                if ((((load_state__scanline==4'h7)||(load_state__scanline==4'h8))||(load_state__scanline==4'h9)))
                begin
                    pixel__smoothed_scanline_data__var = (((pixel__character_data[4]!=1'h0)?12'hfc0:12'h0) | ((pixel__character_data[6]!=1'h0)?12'h3f:12'h0));
                end //if
                else
                
                begin
                    pixel__smoothed_scanline_data__var = (((pixel__character_data[2]!=1'h0)?12'hfc0:12'h0) | ((pixel__character_data[3]!=1'h0)?12'h3f:12'h0));
                end //else
            end //else
            if (!(pixel__current_character_state__contiguous_graphics!=1'h0))
            begin
                pixel__smoothed_scanline_data__var[11:10] = 2'h0;
                pixel__smoothed_scanline_data__var[5:4] = 2'h0;
                if ((((load_state__scanline==4'h2)||(load_state__scanline==4'h6))||(load_state__scanline==4'h9)))
                begin
                    pixel__smoothed_scanline_data__var = 12'h0;
                end //if
            end //if
        end //if
        pixel__rom_scanline_data = pixel__rom_scanline_data__var;
        pixel__smoothed_scanline_data = pixel__smoothed_scanline_data__var;
    end //always

    //b character_pixel_generation__posedge_clk_2MHz_active_low_reset_n clock process
        //   
        //       Get two scanlines - current and next (next of 0 if none)
        //       
    always @( posedge clk_2MHz or negedge reset_n)
    begin : character_pixel_generation__posedge_clk_2MHz_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            hexpixel_state__pixels <= 6'h0;
            hexpixel_state__character_state__background_color <= 3'h0;
            hexpixel_state__character_state__foreground_color <= 3'h0;
            hexpixel_state__character_state__held_character <= 1'h0;
            hexpixel_state__character_state__flashing <= 1'h0;
            hexpixel_state__character_state__text_mode <= 1'h0;
            hexpixel_state__character_state__contiguous_graphics <= 1'h0;
            hexpixel_state__character_state__dbl_height <= 1'h0;
            hexpixel_state__character_state__hold_graphics <= 1'h0;
        end
        else if (clk_2MHz__enable)
        begin
            hexpixel_state__pixels <= pixel__smoothed_scanline_data[5:0];
            case (pixel_state__hexpixel_of_character) //synopsys parallel_case
            2'h0: // req 1
                begin
                hexpixel_state__pixels <= pixel__smoothed_scanline_data[11:6];
                end
            2'h1: // req 1
                begin
                hexpixel_state__pixels <= pixel__smoothed_scanline_data[5:0];
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
            hexpixel_state__character_state__background_color <= pixel__current_character_state__background_color;
            hexpixel_state__character_state__foreground_color <= pixel__current_character_state__foreground_color;
            hexpixel_state__character_state__held_character <= pixel__current_character_state__held_character;
            hexpixel_state__character_state__flashing <= pixel__current_character_state__flashing;
            hexpixel_state__character_state__text_mode <= pixel__current_character_state__text_mode;
            hexpixel_state__character_state__contiguous_graphics <= pixel__current_character_state__contiguous_graphics;
            hexpixel_state__character_state__dbl_height <= pixel__current_character_state__dbl_height;
            hexpixel_state__character_state__hold_graphics <= pixel__current_character_state__hold_graphics;
        end //if
    end //always

    //b outputs_from_hexpixel combinatorial process
        //   
        //       
    always @ ( * )//outputs_from_hexpixel
    begin: outputs_from_hexpixel__comb_code
    reg [5:0]red__var;
    reg [5:0]blue__var;
    reg [5:0]green__var;
    reg [2:0]hexpixel_colors__var[5:0];
        red__var = 6'h0;
        blue__var = 6'h0;
        green__var = 6'h0;
        hexpixel_colors__var[0] = ((hexpixel_state__pixels[0]!=1'h0)?hexpixel_state__character_state__foreground_color:hexpixel_state__character_state__background_color);
        hexpixel_colors__var[1] = ((hexpixel_state__pixels[1]!=1'h0)?hexpixel_state__character_state__foreground_color:hexpixel_state__character_state__background_color);
        hexpixel_colors__var[2] = ((hexpixel_state__pixels[2]!=1'h0)?hexpixel_state__character_state__foreground_color:hexpixel_state__character_state__background_color);
        hexpixel_colors__var[3] = ((hexpixel_state__pixels[3]!=1'h0)?hexpixel_state__character_state__foreground_color:hexpixel_state__character_state__background_color);
        hexpixel_colors__var[4] = ((hexpixel_state__pixels[4]!=1'h0)?hexpixel_state__character_state__foreground_color:hexpixel_state__character_state__background_color);
        hexpixel_colors__var[5] = ((hexpixel_state__pixels[5]!=1'h0)?hexpixel_state__character_state__foreground_color:hexpixel_state__character_state__background_color);
        red__var[0] = hexpixel_colors__var[0][0];
        green__var[0] = hexpixel_colors__var[0][1];
        blue__var[0] = hexpixel_colors__var[0][2];
        red__var[1] = hexpixel_colors__var[1][0];
        green__var[1] = hexpixel_colors__var[1][1];
        blue__var[1] = hexpixel_colors__var[1][2];
        red__var[2] = hexpixel_colors__var[2][0];
        green__var[2] = hexpixel_colors__var[2][1];
        blue__var[2] = hexpixel_colors__var[2][2];
        red__var[3] = hexpixel_colors__var[3][0];
        green__var[3] = hexpixel_colors__var[3][1];
        blue__var[3] = hexpixel_colors__var[3][2];
        red__var[4] = hexpixel_colors__var[4][0];
        green__var[4] = hexpixel_colors__var[4][1];
        blue__var[4] = hexpixel_colors__var[4][2];
        red__var[5] = hexpixel_colors__var[5][0];
        green__var[5] = hexpixel_colors__var[5][1];
        blue__var[5] = hexpixel_colors__var[5][2];
        blan = 1'h0;
        tlc_n = 1'h0;
        red = red__var;
        blue = blue__var;
        green = green__var;
        begin:__set__hexpixel_colors__iter integer __iter; for (__iter=0; __iter<6; __iter=__iter+1) hexpixel_colors[__iter] = hexpixel_colors__var[__iter]; end
    end //always

endmodule // saa5050
