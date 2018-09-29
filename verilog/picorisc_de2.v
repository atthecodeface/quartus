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

//a Module picorisc_de2
module picorisc_de2
(
    de2_vga_clock,
    de2_vga_clock__enable,
    de2_audio_bclk,
    de2_audio_bclk__enable,
    clk,
    clk__enable,

    de2_uart_in__rxd,
    de2_uart_in__rts,
    de2_vga_reset_n,
    de2_ps2b_in__data,
    de2_ps2b_in__clk,
    de2_ps2_in__data,
    de2_ps2_in__clk,
    de2_inputs__keys,
    de2_inputs__switches,
    de2_audio_adc__data,
    de2_audio_adc__lrc,
    reset_n,

    de2_uart_out__txd,
    de2_uart_out__cts,
    de2_vga__vs,
    de2_vga__hs,
    de2_vga__blank_n,
    de2_vga__sync_n,
    de2_vga__red,
    de2_vga__green,
    de2_vga__blue,
    de2_ps2b_out__data,
    de2_ps2b_out__clk,
    de2_ps2_out__data,
    de2_ps2_out__clk,
    de2_lcd__backlight,
    de2_lcd__on,
    de2_lcd__rs,
    de2_lcd__read_write,
    de2_lcd__enable,
    de2_lcd__data,
    de2_leds__ledg,
    de2_leds__ledr,
    de2_leds__h0,
    de2_leds__h1,
    de2_leds__h2,
    de2_leds__h3,
    de2_leds__h4,
    de2_leds__h5,
    de2_leds__h6,
    de2_leds__h7,
    de2_i2c__sclk,
    de2_i2c__sdat,
    de2_eep_i2c__sclk,
    de2_eep_i2c__sdat,
    de2_audio_dac__data,
    de2_audio_dac__lrc
);

    //b Clocks
    input de2_vga_clock;
    input de2_vga_clock__enable;
    input de2_audio_bclk;
    input de2_audio_bclk__enable;
    input clk;
    input clk__enable;

    //b Inputs
    input de2_uart_in__rxd;
    input de2_uart_in__rts;
    input de2_vga_reset_n;
    input de2_ps2b_in__data;
    input de2_ps2b_in__clk;
    input de2_ps2_in__data;
    input de2_ps2_in__clk;
    input [3:0]de2_inputs__keys;
    input [17:0]de2_inputs__switches;
    input de2_audio_adc__data;
    input de2_audio_adc__lrc;
    input reset_n;

    //b Outputs
    output de2_uart_out__txd;
    output de2_uart_out__cts;
    output de2_vga__vs;
    output de2_vga__hs;
    output de2_vga__blank_n;
    output de2_vga__sync_n;
    output [9:0]de2_vga__red;
    output [9:0]de2_vga__green;
    output [9:0]de2_vga__blue;
    output de2_ps2b_out__data;
    output de2_ps2b_out__clk;
    output de2_ps2_out__data;
    output de2_ps2_out__clk;
    output de2_lcd__backlight;
    output de2_lcd__on;
    output de2_lcd__rs;
    output de2_lcd__read_write;
    output de2_lcd__enable;
    output [7:0]de2_lcd__data;
    output [9:0]de2_leds__ledg;
    output [17:0]de2_leds__ledr;
    output [6:0]de2_leds__h0;
    output [6:0]de2_leds__h1;
    output [6:0]de2_leds__h2;
    output [6:0]de2_leds__h3;
    output [6:0]de2_leds__h4;
    output [6:0]de2_leds__h5;
    output [6:0]de2_leds__h6;
    output [6:0]de2_leds__h7;
    output de2_i2c__sclk;
    output de2_i2c__sdat;
    output de2_eep_i2c__sclk;
    output de2_eep_i2c__sdat;
    output de2_audio_dac__data;
    output de2_audio_dac__lrc;

// output components here

    //b Output combinatorials
    reg de2_uart_out__txd;
    reg de2_uart_out__cts;
    reg de2_vga__vs;
    reg de2_vga__hs;
    reg de2_vga__blank_n;
    reg de2_vga__sync_n;
    reg [9:0]de2_vga__red;
    reg [9:0]de2_vga__green;
    reg [9:0]de2_vga__blue;
    reg de2_ps2b_out__data;
    reg de2_ps2b_out__clk;
    reg de2_ps2_out__data;
    reg de2_ps2_out__clk;
    reg de2_lcd__backlight;
    reg de2_lcd__on;
    reg de2_lcd__rs;
    reg de2_lcd__read_write;
    reg de2_lcd__enable;
    reg [7:0]de2_lcd__data;
    reg [9:0]de2_leds__ledg;
    reg [17:0]de2_leds__ledr;
    reg [6:0]de2_leds__h0;
    reg [6:0]de2_leds__h1;
    reg [6:0]de2_leds__h2;
    reg [6:0]de2_leds__h3;
    reg [6:0]de2_leds__h4;
    reg [6:0]de2_leds__h5;
    reg [6:0]de2_leds__h6;
    reg [6:0]de2_leds__h7;
    reg de2_i2c__sclk;
    reg de2_i2c__sdat;
    reg de2_eep_i2c__sclk;
    reg de2_eep_i2c__sdat;
    reg de2_audio_dac__data;
    reg de2_audio_dac__lrc;

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b tieoffs combinatorial process
    always @ ( * )//tieoffs
    begin: tieoffs__comb_code
        de2_audio_dac__data = 1'h0;
        de2_audio_dac__lrc = 1'h0;
        de2_eep_i2c__sclk = 1'h1;
        de2_eep_i2c__sdat = 1'h1;
        de2_i2c__sclk = 1'h1;
        de2_i2c__sdat = 1'h1;
        de2_leds__ledg = 10'h0;
        de2_leds__ledr = 18'h0;
        de2_leds__h0 = 7'h0;
        de2_leds__h1 = 7'h0;
        de2_leds__h2 = 7'h0;
        de2_leds__h3 = 7'h0;
        de2_leds__h4 = 7'h0;
        de2_leds__h5 = 7'h0;
        de2_leds__h6 = 7'h0;
        de2_leds__h7 = 7'h0;
        de2_lcd__backlight = 1'h0;
        de2_lcd__on = 1'h0;
        de2_lcd__rs = 1'h0;
        de2_lcd__read_write = 1'h0;
        de2_lcd__enable = 1'h0;
        de2_lcd__data = 8'h0;
        de2_vga__vs = 1'h0;
        de2_vga__hs = 1'h0;
        de2_vga__blank_n = 1'h0;
        de2_vga__sync_n = 1'h0;
        de2_vga__red = 10'h0;
        de2_vga__green = 10'h0;
        de2_vga__blue = 10'h0;
        de2_uart_out__txd = 1'h0;
        de2_uart_out__cts = 1'h0;
        de2_ps2_out__data = 1'h0;
        de2_ps2_out__clk = 1'h0;
        de2_ps2b_out__data = 1'h0;
        de2_ps2b_out__clk = 1'h0;
    end //always

endmodule // picorisc_de2
