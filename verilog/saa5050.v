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
    //   This module instantiates the @a teletext module to provide a teletext
    //   decoder that is compatible with the SAA5050 as it is used in the BBC
    //   microcomputer (i.e. some features of the chip are not supported, such
    //   as superimpose).
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
    wire clk_1MHz; // Gated version of clock 'clk_2MHz' enabled by 'clk_1MHz_enable'
    wire clk_1MHz__enable;

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
        //   General line reset, can be tied to hsync - assert once per line before data comes in
    input glr;
        //   Not implemented, clocks serial data in somehow
    input dlim;
        //   Parallel character data in
    input [6:0]data_in;
        //   Serial data in, not implemented
    input data_n;
        //   Not implemented
    input superimpose_n;
        //   Active low reset
    input reset_n;
        //   Clock enable high for clk_2MHz when the SAA's 1MHz would normally tick
    input clk_1MHz_enable;

    //b Outputs
        //   Not implemented
    output blan;
        //   Blue pixels out, 6 per 2MHz clock tick
    output [5:0]blue;
        //   Green pixels out, 6 per 2MHz clock tick
    output [5:0]green;
        //   Red pixels out, 6 per 2MHz clock tick
    output [5:0]red;
        //   Asserted (low) when double-height characters occur (?) 
    output tlc_n;

// output components here

    //b Output combinatorials
        //   Not implemented
    reg blan;
        //   Blue pixels out, 6 per 2MHz clock tick
    reg [5:0]blue;
        //   Green pixels out, 6 per 2MHz clock tick
    reg [5:0]green;
        //   Red pixels out, 6 per 2MHz clock tick
    reg [5:0]red;
        //   Asserted (low) when double-height characters occur (?) 
    reg tlc_n;

    //b Output nets

    //b Internal and output registers
        //   Pixel state
    reg pixel_state__last_valid;
        //   Load state, enabled by the clk_1MHz_enable
    reg load_state__last_glr;
    reg load_state__end_of_scanline;
    reg load_state__restart_frame;
    reg [1:0]load_state__interpolate_vertical;

    //b Internal combinatorials
        //   Timings for the scanline, row, etc
    reg tt_timings__restart_frame;
    reg tt_timings__end_of_scanline;
    reg tt_timings__first_scanline_of_row;
    reg tt_timings__smoothe;
    reg [1:0]tt_timings__interpolate_vertical;
        //   Parallel character data in to teletext module, with valid signal
    reg tt_character__valid;
    reg [6:0]tt_character__character;

    //b Internal nets
        //   Output pixels, two clock ticks delayed from clk in
    wire tt_pixels__valid;
    wire [11:0]tt_pixels__red;
    wire [11:0]tt_pixels__green;
    wire [11:0]tt_pixels__blue;
    wire tt_pixels__last_scanline;
        //   Teletext ROM access
    wire tt_rom_access__select;
    wire [6:0]tt_rom_access__address;
        //   Pixel ROM output data
    wire [63:0]pixel_rom_data;

    //b Clock gating module instances
    assign clk_1MHz__enable = (clk_2MHz__enable && clk_1MHz_enable);
    //b Module instances
    teletext tt(
        .clk(clk_2MHz),
        .clk__enable(1'b1),
        .rom_data(pixel_rom_data[44:0]),
        .timings__interpolate_vertical(tt_timings__interpolate_vertical),
        .timings__smoothe(tt_timings__smoothe),
        .timings__first_scanline_of_row(tt_timings__first_scanline_of_row),
        .timings__end_of_scanline(tt_timings__end_of_scanline),
        .timings__restart_frame(tt_timings__restart_frame),
        .character__character(tt_character__character),
        .character__valid(tt_character__valid),
        .reset_n(reset_n),
        .pixels__last_scanline(            tt_pixels__last_scanline),
        .pixels__blue(            tt_pixels__blue),
        .pixels__green(            tt_pixels__green),
        .pixels__red(            tt_pixels__red),
        .pixels__valid(            tt_pixels__valid),
        .rom_access__address(            tt_rom_access__address),
        .rom_access__select(            tt_rom_access__select)         );
    se_sram_srw_128x64 character_rom(
        .sram_clock(clk_2MHz),
        .sram_clock__enable(1'b1),
        .write_data(host_sram_request__write_data),
        .address((((host_sram_request__valid!=1'h0)&&(host_sram_request__select==8'h14))?host_sram_request__address[6:0]:tt_rom_access__address)),
        .write_enable(((host_sram_request__write_enable!=1'h0)&&(host_sram_request__select==8'h14))),
        .read_not_write(!(host_sram_request__write_enable!=1'h0)),
        .select(1'h1),
        .data_out(            pixel_rom_data)         );
    //b implementation__comb combinatorial process
        //   
        //       Maintain some @a load_state in the 1MHz 'domain', to determine
        //       when the frame and line complete; also, since the SAA5050 always
        //       rounds, use CRS to determine which way to interpolate.
        //   
        //       The @a load_state feeds the @a teletext module (with its character
        //       ROM), which does the hard work; it is run at 2MHz but with
        //       character data on every other clock tick.
        //   
        //       The @a teletext module delivers 12 pixels per 1MHz clock, and so 6
        //       of these are selected per 2MHz clock for the output.
        //   
        //       This leads to three 2MHz clock cycles between input data and
        //       output data.
        //       
    always @ ( * )//implementation__comb
    begin: implementation__comb_code
    reg [5:0]red__var;
    reg [5:0]blue__var;
    reg [5:0]green__var;
        tt_character__valid = (lose & clk_1MHz_enable);
        tt_character__character = data_in;
        tt_timings__restart_frame = load_state__restart_frame;
        tt_timings__end_of_scanline = load_state__end_of_scanline;
        tt_timings__first_scanline_of_row = 1'h0;
        tt_timings__smoothe = 1'h1;
        tt_timings__interpolate_vertical = load_state__interpolate_vertical;
        red__var = 6'h0;
        blue__var = 6'h0;
        green__var = 6'h0;
        if ((tt_pixels__valid!=1'h0))
        begin
            red__var = tt_pixels__red[11:6];
            green__var = tt_pixels__green[11:6];
            blue__var = tt_pixels__blue[11:6];
        end //if
        else
        
        begin
            if ((pixel_state__last_valid!=1'h0))
            begin
                red__var = tt_pixels__red[5:0];
                green__var = tt_pixels__green[5:0];
                blue__var = tt_pixels__blue[5:0];
            end //if
        end //else
        blan = 1'h0;
        tlc_n = 1'h0;
        red = red__var;
        blue = blue__var;
        green = green__var;
    end //always

    //b implementation__posedge_clk_2MHz_active_low_reset_n clock process
        //   
        //       Maintain some @a load_state in the 1MHz 'domain', to determine
        //       when the frame and line complete; also, since the SAA5050 always
        //       rounds, use CRS to determine which way to interpolate.
        //   
        //       The @a load_state feeds the @a teletext module (with its character
        //       ROM), which does the hard work; it is run at 2MHz but with
        //       character data on every other clock tick.
        //   
        //       The @a teletext module delivers 12 pixels per 1MHz clock, and so 6
        //       of these are selected per 2MHz clock for the output.
        //   
        //       This leads to three 2MHz clock cycles between input data and
        //       output data.
        //       
    always @( posedge clk_2MHz or negedge reset_n)
    begin : implementation__posedge_clk_2MHz_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            load_state__last_glr <= 1'h0;
            load_state__end_of_scanline <= 1'h0;
            load_state__restart_frame <= 1'h0;
            load_state__interpolate_vertical <= 2'h0;
            pixel_state__last_valid <= 1'h0;
        end
        else if (clk_2MHz__enable)
        begin
            load_state__last_glr <= glr;
            if ((clk_1MHz_enable!=1'h0))
            begin
                load_state__end_of_scanline <= 1'h0;
                load_state__restart_frame <= 1'h0;
            end //if
            if (((load_state__last_glr!=1'h0)&&!(glr!=1'h0)))
            begin
                load_state__end_of_scanline <= 1'h1;
            end //if
            if ((dew!=1'h0))
            begin
                load_state__interpolate_vertical <= ((crs!=1'h0)?2'h2:2'h1);
                load_state__restart_frame <= 1'h1;
            end //if
            pixel_state__last_valid <= tt_pixels__valid;
        end //if
    end //always

endmodule // saa5050
