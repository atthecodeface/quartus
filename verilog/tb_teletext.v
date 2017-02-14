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

//a Module tb_teletext
module tb_teletext
(
    clk,
    clk__enable,

    reset_n

);

    //b Clocks
    input clk;
    input clk__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials

    //b Internal nets
    wire pixels__valid;
    wire [11:0]pixels__red;
    wire [11:0]pixels__green;
    wire [11:0]pixels__blue;
    wire pixels__last_scanline;
    wire [44:0]rom_data;
    wire rom_access__select;
    wire [6:0]rom_access__address;
    wire timings__restart_frame;
    wire timings__end_of_scanline;
    wire timings__first_scanline_of_row;
    wire timings__smoothe;
    wire [1:0]timings__interpolate_vertical;
    wire character__valid;
    wire [6:0]character__character;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .pixels__last_scanline(pixels__last_scanline),
        .pixels__blue(pixels__blue),
        .pixels__green(pixels__green),
        .pixels__red(pixels__red),
        .pixels__valid(pixels__valid),
        .timings__interpolate_vertical(            timings__interpolate_vertical),
        .timings__smoothe(            timings__smoothe),
        .timings__first_scanline_of_row(            timings__first_scanline_of_row),
        .timings__end_of_scanline(            timings__end_of_scanline),
        .timings__restart_frame(            timings__restart_frame),
        .character__character(            character__character),
        .character__valid(            character__valid)         );
    teletext tt(
        .clk(clk),
        .clk__enable(1'b1),
        .rom_data(rom_data),
        .timings__interpolate_vertical(timings__interpolate_vertical),
        .timings__smoothe(timings__smoothe),
        .timings__first_scanline_of_row(timings__first_scanline_of_row),
        .timings__end_of_scanline(timings__end_of_scanline),
        .timings__restart_frame(timings__restart_frame),
        .character__character(character__character),
        .character__valid(character__valid),
        .reset_n(reset_n),
        .pixels__last_scanline(            pixels__last_scanline),
        .pixels__blue(            pixels__blue),
        .pixels__green(            pixels__green),
        .pixels__red(            pixels__red),
        .pixels__valid(            pixels__valid),
        .rom_access__address(            rom_access__address),
        .rom_access__select(            rom_access__select)         );
    se_sram_srw_128x45 character_rom(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(45'h0),
        .address(rom_access__address),
        .read_not_write(1'h1),
        .select(rom_access__select),
        .data_out(            rom_data)         );
endmodule // tb_teletext
