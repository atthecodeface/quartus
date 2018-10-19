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
    de2_sdr_clk,
    de2_sdr_clk__enable,
    de2_vga_clk,
    de2_vga_clk__enable,
    de2_td_clk,
    de2_td_clk__enable,
    de2_audio_bclk,
    de2_audio_bclk__enable,
    clk,
    clk__enable,

    de2_gpio_in__gpio_0,
    de2_gpio_in__gpio_1,
    de2_flash_in__dq,
    de2_sram_in__dq,
    de2_sdr_in__dq,
    de2_vga_reset_n,
    de2_uart_in__rxd,
    de2_uart_in__rts,
    de2_td__hs,
    de2_td__vs,
    de2_td__data,
    de2_ps2_in__data,
    de2_ps2_in__clk,
    de2_inputs__keys,
    de2_inputs__switches,
    de2_inputs__irda_rxd,
    de2_i2c_in__sclk,
    de2_i2c_in__sdat,
    de2_audio_adc__data,
    de2_audio_adc__lrc,
    reset_n,

    de2_flash_out__reset_n,
    de2_flash_out__ce_n,
    de2_flash_out__oe_n,
    de2_flash_out__we_n,
    de2_flash_out__addr,
    de2_flash_out__dq,
    de2_flash_out__dqe,
    de2_sram_out__ce_n,
    de2_sram_out__oe_n,
    de2_sram_out__we_n,
    de2_sram_out__be_n,
    de2_sram_out__addr,
    de2_sram_out__dq,
    de2_sram_out__dqe,
    de2_sdr_out__cke,
    de2_sdr_out__cs_n,
    de2_sdr_out__ras_n,
    de2_sdr_out__cas_n,
    de2_sdr_out__we_n,
    de2_sdr_out__ba,
    de2_sdr_out__addr,
    de2_sdr_out__dq,
    de2_sdr_out__dqm,
    de2_sdr_out__dqe,
    de2_vga__vs,
    de2_vga__hs,
    de2_vga__blank_n,
    de2_vga__sync_n,
    de2_vga__red,
    de2_vga__green,
    de2_vga__blue,
    de2_uart_out__txd,
    de2_uart_out__cts,
    de2_td_reset_n,
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
    de2_i2c_out__sclk,
    de2_i2c_out__sdat,
    de2_audio_dac__data,
    de2_audio_dac__lrc
);

    //b Clocks
    input de2_sdr_clk;
    input de2_sdr_clk__enable;
    input de2_vga_clk;
    input de2_vga_clk__enable;
    input de2_td_clk;
    input de2_td_clk__enable;
    input de2_audio_bclk;
    input de2_audio_bclk__enable;
    input clk;
    input clk__enable;

    //b Inputs
    input [17:0]de2_gpio_in__gpio_0;
    input [17:0]de2_gpio_in__gpio_1;
    input [7:0]de2_flash_in__dq;
    input [15:0]de2_sram_in__dq;
    input [15:0]de2_sdr_in__dq;
    input de2_vga_reset_n;
    input de2_uart_in__rxd;
    input de2_uart_in__rts;
    input de2_td__hs;
    input de2_td__vs;
    input [7:0]de2_td__data;
    input de2_ps2_in__data;
    input de2_ps2_in__clk;
    input [3:0]de2_inputs__keys;
    input [17:0]de2_inputs__switches;
    input de2_inputs__irda_rxd;
    input de2_i2c_in__sclk;
    input de2_i2c_in__sdat;
    input de2_audio_adc__data;
    input de2_audio_adc__lrc;
    input reset_n;

    //b Outputs
    output de2_flash_out__reset_n;
    output de2_flash_out__ce_n;
    output de2_flash_out__oe_n;
    output de2_flash_out__we_n;
    output [21:0]de2_flash_out__addr;
    output [7:0]de2_flash_out__dq;
    output de2_flash_out__dqe;
    output de2_sram_out__ce_n;
    output de2_sram_out__oe_n;
    output de2_sram_out__we_n;
    output [1:0]de2_sram_out__be_n;
    output [11:0]de2_sram_out__addr;
    output [15:0]de2_sram_out__dq;
    output de2_sram_out__dqe;
    output de2_sdr_out__cke;
    output de2_sdr_out__cs_n;
    output de2_sdr_out__ras_n;
    output de2_sdr_out__cas_n;
    output de2_sdr_out__we_n;
    output [1:0]de2_sdr_out__ba;
    output [11:0]de2_sdr_out__addr;
    output [15:0]de2_sdr_out__dq;
    output [1:0]de2_sdr_out__dqm;
    output de2_sdr_out__dqe;
    output de2_vga__vs;
    output de2_vga__hs;
    output de2_vga__blank_n;
    output de2_vga__sync_n;
    output [9:0]de2_vga__red;
    output [9:0]de2_vga__green;
    output [9:0]de2_vga__blue;
    output de2_uart_out__txd;
    output de2_uart_out__cts;
    output de2_td_reset_n;
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
    output de2_i2c_out__sclk;
    output de2_i2c_out__sdat;
    output de2_audio_dac__data;
    output de2_audio_dac__lrc;

// output components here

    //b Output combinatorials
    reg de2_flash_out__reset_n;
    reg de2_flash_out__ce_n;
    reg de2_flash_out__oe_n;
    reg de2_flash_out__we_n;
    reg [21:0]de2_flash_out__addr;
    reg [7:0]de2_flash_out__dq;
    reg de2_flash_out__dqe;
    reg de2_sram_out__ce_n;
    reg de2_sram_out__oe_n;
    reg de2_sram_out__we_n;
    reg [1:0]de2_sram_out__be_n;
    reg [11:0]de2_sram_out__addr;
    reg [15:0]de2_sram_out__dq;
    reg de2_sram_out__dqe;
    reg de2_sdr_out__cke;
    reg de2_sdr_out__cs_n;
    reg de2_sdr_out__ras_n;
    reg de2_sdr_out__cas_n;
    reg de2_sdr_out__we_n;
    reg [1:0]de2_sdr_out__ba;
    reg [11:0]de2_sdr_out__addr;
    reg [15:0]de2_sdr_out__dq;
    reg [1:0]de2_sdr_out__dqm;
    reg de2_sdr_out__dqe;
    reg de2_vga__vs;
    reg de2_vga__hs;
    reg de2_vga__blank_n;
    reg de2_vga__sync_n;
    reg [9:0]de2_vga__red;
    reg [9:0]de2_vga__green;
    reg [9:0]de2_vga__blue;
    reg de2_uart_out__txd;
    reg de2_uart_out__cts;
    reg de2_td_reset_n;
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
    reg de2_i2c_out__sclk;
    reg de2_i2c_out__sdat;
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
        de2_i2c_out__sclk = 1'h1;
        de2_i2c_out__sdat = 1'h1;
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
        de2_td_reset_n = 1'h0;
        de2_sdr_out__cke = 1'h0;
        de2_sdr_out__cs_n = 1'h0;
        de2_sdr_out__ras_n = 1'h0;
        de2_sdr_out__cas_n = 1'h0;
        de2_sdr_out__we_n = 1'h0;
        de2_sdr_out__ba = 2'h0;
        de2_sdr_out__addr = 12'h0;
        de2_sdr_out__dq = 16'h0;
        de2_sdr_out__dqm = 2'h0;
        de2_sdr_out__dqe = 1'h0;
        de2_sram_out__ce_n = 1'h0;
        de2_sram_out__oe_n = 1'h0;
        de2_sram_out__we_n = 1'h0;
        de2_sram_out__be_n = 2'h0;
        de2_sram_out__addr = 12'h0;
        de2_sram_out__dq = 16'h0;
        de2_sram_out__dqe = 1'h0;
        de2_flash_out__reset_n = 1'h0;
        de2_flash_out__ce_n = 1'h0;
        de2_flash_out__oe_n = 1'h0;
        de2_flash_out__we_n = 1'h0;
        de2_flash_out__addr = 22'h0;
        de2_flash_out__dq = 8'h0;
        de2_flash_out__dqe = 1'h0;
    end //always

endmodule // picorisc_de2
