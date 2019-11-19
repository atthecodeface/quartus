module pll_video (
		input  wire  refclk,   //  refclk.clk
		input  wire  rst,      //   reset.reset
		output wire  outclk_0, // outclk0.clk
		output wire  locked_0,    //  locked.export
		output wire  outclk_1, // outclk0.clk
		output wire  locked_1    //  locked.export
	);

   wire [1:0]        outclk;
   wire              locked;
   
   assign outclk_0 = outclk[0];
   assign outclk_1 = outclk[1];
   assign locked_0 = locked;
   assign locked_1 = locked;
   
	altera_pll #(
		.fractional_vco_multiplier("false"),
		.reference_clock_frequency("50.0 MHz"),
		.operation_mode("direct"),
		.number_of_clocks(2),
		.output_clock_frequency0("9.000000 MHz"),
		.output_clock_frequency1("27 MHz"),
		.pll_type("Auto"),
		.pll_subtype("Auto")
	) altera_pll_i (
		.rst	(rst),
		.outclk	(outclk),
		.locked	(locked),
		.refclk	(refclk)
	);

endmodule
module de2_project ( clk_50,

                     de2_aud__xck, de2_aud__bclk, de2_aud__adc_dat, de2_aud__adc_lrc, de2_aud__dac_dat, de2_aud__dac_lrc,

                     de2_i2c__sclk, de2_i2c__sdat,

                     de2_hex0, de2_hex1,de2_hex2, de2_hex3, de2_hex4, de2_hex5, de2_hex6, de2_hex7,
                     de2_keys, de2_switches, de2_ledg, de2_ledr,

                     de2_irda__rxd,
                     de2_irda__txd,

                     de2_lcd__enable, de2_lcd__rs, de2_lcd__read_write, de2_lcd__data,
                     de2_lcd__on, de2_lcd__backlight,

                     de2_ps2_dat, de2_ps2_clk,

                     de2_sma_clkin, // de2_sma_clkout,

                     //de2_sd__clk, de2_sd__cmd, de2_sd__wp_n, de2_sd__data,

                     de2_td__clk27, de2_td__data, de2_td__hs, de2_td__reset_n, de2_td__vs,

                     de2_uart__txd, de2_uart__rxd, // de2_uart__cts, de2_uart__rts,

                     de2_vga__b, de2_vga__blank_n, de2_vga__clk, de2_vga__g, de2_vga__hs, de2_vga__r, de2_vga__sync_n, de2_vga__vs,

                     de2_sdr__clk, de2_sdr__cke, de2_sdr__cs_n,
                     de2_sdr__ras_n, de2_sdr__cas_n, de2_sdr__we_n,
                     de2_sdr__addr, de2_sdr__ba,
                     de2_sdr__dq, de2_sdr__dqm,

                     de2_sram__ce_n, de2_sram__oe_n, de2_sram__we_n,
                     de2_sram__lb_n, de2_sram__ub_n,
                     de2_sram__addr, de2_sram__dq,

                     de2_flash__reset_n,
                     de2_flash__ce_n, de2_flash__oe_n, de2_flash__we_n,
                     // de2_flash__wp_n, de2_flash__ready,
                     de2_flash__addr, de2_flash__dq,

                     de2_gpio_0,
                     de2_gpio_1

                     );
   input clk_50;

   output  de2_aud__xck;
   inout   de2_aud__bclk;
   input   de2_aud__adc_dat;
   inout   de2_aud__adc_lrc;
   output  de2_aud__dac_dat;
   inout   de2_aud__dac_lrc;

   output  de2_i2c__sclk;
   inout   de2_i2c__sdat;

   output [6:0]  de2_hex0;
   output [6:0]  de2_hex1;
   output [6:0]  de2_hex2;
   output [6:0]  de2_hex3;
   output [6:0]  de2_hex4;
   output [6:0]  de2_hex5;
   output [6:0]  de2_hex6;
   output [6:0]  de2_hex7;
   input  [3:0]   de2_keys;
   input  [17:0]  de2_switches;
   output [8:0]   de2_ledg;
   output [17:0]  de2_ledr;

   input         de2_irda__rxd;
   output        de2_irda__txd;

   output        de2_lcd__enable;
   output        de2_lcd__rs;
   output        de2_lcd__read_write;
   output [7:0]  de2_lcd__data;
   output        de2_lcd__on;
   output        de2_lcd__backlight;

   inout       de2_ps2_clk;
   inout       de2_ps2_dat;

   input       de2_sma_clkin;
   
   //output        de2_sd__clk;
   //inout         de2_sd__cmd;
   //inout         de2_sd__wp_n;
   //inout [3:0]   de2_sd__data;

   input        de2_td__clk27;
   input [7:0]  de2_td__data;
   input        de2_td__hs;
   output       de2_td__reset_n;
   input        de2_td__vs;

   output       de2_uart__txd;
   input        de2_uart__rxd;
   //output       de2_uart__cts;
   //input        de2_uart__rts;

   output       de2_vga__blank_n;
   output       de2_vga__clk;
   output [9:0] de2_vga__b;
   output [9:0] de2_vga__g;
   output [9:0] de2_vga__r;
   output       de2_vga__hs;
   output       de2_vga__sync_n;
   output       de2_vga__vs;
   
   output        de2_sdr__clk;
   output        de2_sdr__cke;
   output        de2_sdr__cs_n;
   output        de2_sdr__ras_n;
   output        de2_sdr__cas_n;
   output        de2_sdr__we_n;
   output [11:0] de2_sdr__addr;
   output [1:0]  de2_sdr__ba;
   inout  [15:0] de2_sdr__dq;
   output [1:0]  de2_sdr__dqm;

   output        de2_sram__ce_n;
   output        de2_sram__oe_n;
   output        de2_sram__we_n;
   output        de2_sram__lb_n;
   output        de2_sram__ub_n;
   output [17:0] de2_sram__addr;
   inout  [15:0] de2_sram__dq;

   output        de2_flash__reset_n;
   output        de2_flash__ce_n;
   output        de2_flash__oe_n;
   output        de2_flash__we_n;
   //output        de2_flash__wp_n;
   //input        de2_flash__ready;
   output [22:0] de2_flash__addr;
   inout   [7:0] de2_flash__dq;

   inout [35:0]  de2_gpio_0;
   inout [35:0]  de2_gpio_1;
   
   wire               reset_n;
   assign reset_n = de2_switches[0];
  
   wire         vga_clk;
   wire         vga_clk_locked;
   wire         de2_vga_clock;
   wire         de2_vga_reset_n;
   pll_video video_clk_gen( .refclk(clk_50), .rst(!reset_n),
                            .outclk_1(vga_clk), .locked_1(vga_clk_locked) );
   assign de2_vga_clock        = !vga_clk;
   assign de2_vga__clk         = vga_clk;
   assign de2_vga_reset_n      = reset_n && vga_clk_locked;
   
   wire         de2_ps2_in__clk;
   wire         de2_ps2_in__dat;
   wire         de2_ps2_out__clk;
   wire         de2_ps2_out__dat;
   assign de2_ps2_clk = de2_ps2_out__clk  ? 1'bz: 1'b0;
   assign de2_ps2_dat = de2_ps2_out__dat  ? 1'bz: 1'b0;
   assign de2_ps2_in__clk  = de2_ps2_clk;
   assign de2_ps2_in__dat = de2_ps2_dat;

   wire         de2_i2c_in__clk;
   wire         de2_i2c_in__data;
   wire         de2_i2c_out__clk;
   wire         de2_i2c_out__data;
   assign de2_i2c__sclk = de2_i2c_out__sclk ? 1'bz: 1'b0;
   assign de2_i2c__sdat = de2_i2c_out__sdat ? 1'bz: 1'b0;
   assign de2_i2c_in__sclk  = de2_i2c__sclk;
   assign de2_i2c_in__sdat  = de2_i2c__sdat;

   assign  de2_aud__xck = 0; // clock out

   wire          de2_sdr_out__dqe;
   wire [15:0]   de2_sdr_out__dq;
   assign de2_sdr__dq    = de2_sdr_out__dqe ? de2_sdr_out__dq : 16'bz;

   wire [1:0]    de2_sram_out__be_n;
   wire          de2_sram_out__dqe;
   wire [15:0]   de2_sram_out__dq;
   assign de2_sram__lb_n = de2_sram_out__be_n[0];
   assign de2_sram__ub_n = de2_sram_out__be_n[1];
   assign de2_sram__dq   = de2_sram_out__dqe ? de2_sram_out__dq : 16'bz;

   wire         de2_flash_out__dqe;
   wire [7:0]   de2_flash_out__dq;
   assign de2_flash__dq    = de2_flash_out__dqe ? de2_flash_out__dq : 8'bz;
   
   `de2_dut_module dut( .de2_vga_clk(de2_vga_clock),
                        .de2_vga_clk__enable(1'b1),
                        .clk(clk_50),
                        .clk__enable(1'b1),
                        .reset_n(reset_n),

                        .de2_audio_bclk(de2_aud__bclk),
                        .de2_audio_bclk__enable(1'b1),
                        .de2_audio_adc__data(de2_aud__adc_dat),
                        .de2_audio_adc__lrc(de2_aud__adc_lrc),
                        .de2_audio_dac__data(de2_aud__dac_dat),
                        .de2_audio_dac__lrc(de2_aud__dac_lrc),
      
                        // inputs
                        .de2_i2c_in__sclk(de2_i2c_in__sclk),
                        .de2_i2c_in__sdat(de2_i2c_in__sdat),
                        // outputs
                        .de2_i2c_out__sclk(de2_i2c_out__sclk),
                        .de2_i2c_out__sdat(de2_i2c_out__sdat),

                        // inputs
                        .de2_inputs__keys(de2_keys),
                        .de2_inputs__switches(de2_switches),

                        // inputs
                        .de2_inputs__irda_rxd(de2_irda__rxd),

                        // outputs
                        .de2_leds__h0(de2_leds__hex0),
                        .de2_leds__h1(de2_leds__hex1),
                        .de2_leds__h2(de2_leds__hex2),
                        .de2_leds__h3(de2_leds__hex3),
                        .de2_leds__h4(de2_leds__hex4),
                        .de2_leds__h5(de2_leds__hex5),
                        .de2_leds__h6(de2_leds__hex6),
                        .de2_leds__h7(de2_leds__hex7),
                        .de2_leds__ledg(de2_ledg),
                        .de2_leds__ledr(de2_ledr),
      
                        // outputs
                        .de2_lcd__enable(de2_lcd__enable),
                        .de2_lcd__rs(de2_lcd__rs),
                        .de2_lcd__read_write(de2_lcd__read_write),
                        .de2_lcd__data(de2_lcd__data),
                        .de2_lcd__on(de2_lcd__on),
                        .de2_lcd__backlight(de2_lcd__backlight),

                        // inputs
                        .de2_ps2_in__data(de2_ps2_in__dat),
                        .de2_ps2_in__clk(de2_ps2_in__clk),
                        // outputs
                        .de2_ps2_out__data(de2_ps2_out__dat),
                        .de2_ps2_out__clk(de2_ps2_out__clk),
      
                        // inputs
                        //.de2_sma_clkin(de2_sma_clkin),

                        // outputs
                        // .de2_sd__clk(de2_sd__clk),
                        // inouts
                        // .de2_sd__cmd(de2_sd__cmd),
                        // .de2_sd__wp_n(de2_sd__wp_n),
                        // .de2_sd__data(de2_sd__data),

                        // clocks
                        .de2_td_clk(de2_td__clk27),
                        .de2_td_clk__enable(1'b1),
                        // outputs
                        .de2_td_reset_n(de2_td__reset_n),
                        // inputs
                        .de2_td__data(de2_td__data),
                        .de2_td__hs(de2_td__hs),
                        .de2_td__vs(de2_td__vs),

                        // outputs
                        .de2_uart_out__txd(de2_uart__txd),
                        .de2_uart_out__cts(de2_uart__cts),
                        // inputs
                        .de2_uart_in__rxd(de2_uart__rxd),
                        .de2_uart_in__rts(de2_uart__rts),

                        // inputs
                        .de2_vga_reset_n(de2_vga_reset_n),
                        // outputs
                        .de2_vga__blank_n(de2_vga__blank_n),
                        .de2_vga__sync_n(de2_vga__sync_n),
                        .de2_vga__vs(de2_vga__vs),
                        .de2_vga__hs(de2_vga__hs),
                        .de2_vga__red(de2_vga__r),
                        .de2_vga__green(de2_vga__g),
                        .de2_vga__blue(de2_vga__b),

                        // clocks
                        .de2_sdr_clk(de2_sdr__clk),
                        .de2_sdr_clk__enable(1'b1),
                        // outputs
                        .de2_sdr_out__cke(de2_sdr__cke),
                        .de2_sdr_out__cs_n(de2_sdr__cs_n),
                        .de2_sdr_out__ras_n(de2_sdr__ras_n),
                        .de2_sdr_out__cas_n(de2_sdr__cas_n),
                        .de2_sdr_out__we_n(de2_sdr__we_n),
                        .de2_sdr_out__addr(de2_sdr__addr),
                        .de2_sdr_out__ba(de2_sdr__ba),
                        .de2_sdr_out__dq(de2_sdr_out__dq),
                        .de2_sdr_out__dqe(de2_sdr_out__dqe),
                        .de2_sdr_out__dqm(de2_sdr__dqm),
                        .de2_sdr_in__dq(de2_sdr__dq),
      
                        // outputs
                        .de2_sram_out__ce_n(de2_sram__ce_n),
                        .de2_sram_out__oe_n(de2_sram__oe_n),
                        .de2_sram_out__we_n(de2_sram__we_n),
                        .de2_sram_out__be_n(de2_sram_out__be_n),
                        .de2_sram_out__addr(de2_sram__addr),
                        .de2_sram_out__dq(de2_sram_out__dq),
                        .de2_sram_out__dqe(de2_sram_out__dqe),
                        .de2_sram_in__dq(de2_sram__dq),
      
                        // outputs
                        .de2_flash_out__reset_n(de2_flash__reset_n),
                        .de2_flash_out__ce_n(de2_flash__ce_n),
                        .de2_flash_out__oe_n(de2_flash__oe_n),
                        .de2_flash_out__we_n(de2_flash__we_n),
                        //.de2_flash_out__wp_n(de2_flash__wp_n),
                        //.de2_flash_out__ready(de2_flash__ready),
                        .de2_flash_out__addr(de2_flash__addr),
                        .de2_flash_out__dq(de2_flash_out__dq),
                        .de2_flash_out__dqe(de2_flash_out__dqe),
                        .de2_flash_in__dq(de2_flash__dq),

                        // inputs
                        .de2_gpio_in__gpio_0(de2_gpio_0),
                        .de2_gpio_in__gpio_1(de2_gpio_1)
                        );
endmodule
