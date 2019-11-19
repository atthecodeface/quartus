module pll_lcd (
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
		.pll_type("General"),
		.pll_subtype("General")
	) altera_pll_i (
		.rst	(rst),
		.outclk	(outclk),
		.locked	(locked),
		.refclk	(refclk)
	);

endmodule
module de1_cl_project ( clk_50, clk2_50, clk3_50, clk4_50, // reset_n,

                     de1_adc__cs_n, de1_adc__din, de1_adc__dout, de1_adc__sclk,
                     de1_aud__adcdat, de1_aud__adclrck, de1_aud__bclk, de1_aud__dacdat, de1_aud__daclrck, de1_aud__xck,

                     de1_ddr__clk, de1_ddr__cke, de1_ddr__cs_n,
                     de1_ddr__addr, de1_ddr__ba,
                     de1_ddr__ras_n, de1_ddr__cas_n, de1_ddr__we_n,
                     de1_ddr__dq, de1_ddr__ldqm, de1_ddr__udqm,

                     de1_fan_ctrl,

                     de1_fpga_i2c__sclk,
                     de1_fpga_i2c__sdat,

                     de1_hex0, de1_hex1,de1_hex2, de1_hex3, de1_hex4, de1_hex5,

                     de1_irda__rxd, de1_irda__txd,
                     de1_keys, de1_switches, de1_leds,
                     
                     de1_td__clk27, de1_td__data, de1_td__hs, de1_td__reset_n, de1_td__vs,

                     de1_vga__b, de1_vga__blank_n, de1_vga__clk, de1_vga__g, de1_vga__hs, de1_vga__r, de1_vga__sync_n, de1_vga__vs,

                     de1_ps2_dat, de1_ps2_clk,
                     de1_ps2_b_dat, de1_ps2_b_clk,

                     de1_cl_inputs_status__sr_data,
                     de1_cl_inputs_status__left_rotary__direction_pin, de1_cl_inputs_status__left_rotary__transition_pin,
                     de1_cl_inputs_status__right_rotary__direction_pin, de1_cl_inputs_status__right_rotary__transition_pin,

                     de1_cl_inputs_control__sr_clock, de1_cl_inputs_control__sr_shift,
                     de1_cl_led_data_pin,
                     de1_cl_lcd__clock, de1_cl_lcd__vsync_n, de1_cl_lcd__hsync_n, de1_cl_lcd__display_enable, de1_cl_lcd__red, de1_cl_lcd__green, de1_cl_lcd__blue,
                     de1_cl_lcd__backlight

                     );
   input clk_50;
   input clk2_50;
   input clk3_50;
   input clk4_50;
   //input reset_n;

   inout   de1_adc__cs_n;
   output  de1_adc__din;
   input   de1_adc__dout;
   output  de1_adc__sclk;

   input   de1_aud__adcdat;
   inout   de1_aud__adclrck;
   inout   de1_aud__bclk;
   output  de1_aud__dacdat;
   inout   de1_aud__daclrck;
   output  de1_aud__xck;

   output  de1_ddr__clk;
   output  de1_ddr__cke;
   output  de1_ddr__cs_n;
   output [12:0] de1_ddr__addr;
   output [1:0]  de1_ddr__ba;
   inout [15:0]  de1_ddr__dq;
   output        de1_ddr__ldqm;
   output        de1_ddr__udqm;
   output        de1_ddr__ras_n;
   output        de1_ddr__cas_n;
   output        de1_ddr__we_n;

   output        de1_fan_ctrl;
   output        de1_fpga_i2c__sclk;
   inout         de1_fpga_i2c__sdat;
   output [6:0]  de1_hex0;
   output [6:0]  de1_hex1;
   output [6:0]  de1_hex2;
   output [6:0]  de1_hex3;
   output [6:0]  de1_hex4;
   output [6:0]  de1_hex5;

   input         de1_irda__rxd;
   output        de1_irda__txd;
   input [3:0]   de1_keys;
   output [9:0]  de1_leds;
   input [9:0]   de1_switches;

   inout       de1_ps2_clk;
   inout       de1_ps2_dat;
   inout       de1_ps2_b_clk;
   inout       de1_ps2_b_dat;

   input        de1_td__clk27;
   input [7:0]  de1_td__data;
   input        de1_td__hs;
   output       de1_td__reset_n;
   input        de1_td__vs;

   output [7:0] de1_vga__b;
   output       de1_vga__blank_n;
   output       de1_vga__clk;
   output [7:0] de1_vga__g;
   output       de1_vga__hs;
   output [7:0] de1_vga__r;
   output       de1_vga__sync_n;
   output       de1_vga__vs;
   
   input        de1_cl_inputs_status__sr_data;
   input        de1_cl_inputs_status__left_rotary__direction_pin;
   input        de1_cl_inputs_status__left_rotary__transition_pin;
   input        de1_cl_inputs_status__right_rotary__direction_pin;
   input        de1_cl_inputs_status__right_rotary__transition_pin;

   output      de1_cl_inputs_control__sr_clock;
   output      de1_cl_inputs_control__sr_shift;
   output      de1_cl_led_data_pin;
   output      de1_cl_lcd__clock             ;
   output      de1_cl_lcd__vsync_n           ;
   output      de1_cl_lcd__hsync_n           ;
   output      de1_cl_lcd__display_enable    ;
   output [5:0] de1_cl_lcd__red               ;
   output [6:0] de1_cl_lcd__green             ;
   output [5:0] de1_cl_lcd__blue              ;
   output       de1_cl_lcd__backlight         ;

   wire               reset_n;
   assign reset_n = de1_keys[3];
  
   wire         vga_clk;
   wire         vga_clk_locked;
   wire         de1_cl_lcd_clock_locked;
   wire         de1_cl_lcd__clock;
   wire         de1_vga_clock;
   wire         de1_vga_reset_n;

   wire         lcd_clk;
   wire de1_vga_clock_locked;
   wire de1_cl_lcd_reset_n;
   wire de1_ps2b_clk;
   wire de1_ps2b_dat;

       
   pll_lcd video_clk_gen( .refclk(clk_50), .rst(!reset_n),
                          .outclk_0(lcd_clk), .locked_0(de1_cl_lcd_clock_locked),
                          .outclk_1(vga_clk), .locked_1(de1_vga_clock_locked) );
   assign de1_cl_lcd__clock    = !lcd_clk;
   assign de1_cl_lcd_reset_n   = reset_n && de1_cl_lcd_clock_locked;
   assign de1_vga_clock        = !vga_clk;
   assign de1_vga__clk         = vga_clk;
   assign de1_vga_reset_n      = reset_n && de1_vga_clock_locked;
   
  
   wire         de1_ps2_in__clk;
   wire         de1_ps2_in__data;
   wire         de1_ps2_out__clk;
   wire         de1_ps2_out__data;
   assign de1_ps2_clk = de1_ps2_out__clk  ? 1'bz: 1'b0;
   assign de1_ps2_dat = de1_ps2_out__data ? 1'bz: 1'b0;
   assign de1_ps2_in__clk  = de1_ps2_clk;
   assign de1_ps2_in__data = de1_ps2_dat;

   wire         de1_ps2b_in__clk;
   wire         de1_ps2b_in__data;
   wire         de1_ps2b_out__clk;
   wire         de1_ps2b_out__data;
   assign de1_ps2b_clk = de1_ps2b_out__clk  ? 1'bz: 1'b0;
   assign de1_ps2b_dat = de1_ps2b_out__data ? 1'bz: 1'b0;
   assign de1_ps2b_in__clk  = de1_ps2b_clk;
   assign de1_ps2b_in__data = de1_ps2b_dat;
   

   // reset sources for hps reset are:
   // .hps_0_f2h_cold_reset_req_reset_n      (~hps_cold_reset)   - derived from hps_reset_req[0]
   // .hps_0_f2h_warm_reset_req_reset_n      (~hps_warm_reset)   - derived from hps_reset_req[1]
   // .hps_0_f2h_debug_reset_req_reset_n     (~hps_debug_reset)  - derived from hps_reset_req[2]
   // output of HPS reset is
   // .hps_0_h2f_reset_reset_n               (hps_fpga_reset_n),               //                hps_0_h2f_reset.reset_n
   // input to hps is
   //.reset_reset_n in to hps is (hps_fpga_reset_n),                         //                          reset.reset_n
   

   `de1_cl_dut_module dut( .de1_vga_clock(de1_vga_clock),
                          .de1_vga_clock__enable(1'b1),
                           .de1_vga_clock_locked(de1_vga_clock_locked),
                          .de1_cl_lcd_clock(de1_cl_lcd__clock),
                          .de1_cl_lcd_clock__enable(1'b1),
                           .de1_cl_lcd_clock_locked(de1_cl_lcd_clock_locked),
                          .clk(clk_50),
                          .clk__enable(1'b1),
                        .reset_n(reset_n),

                        .de1_inputs__irda_rxd(de1_irda__rxd),
                        .de1_inputs__switches(de1_switches),
                        .de1_inputs__keys(de1_keys),
                        .de1_vga_reset_n(de1_vga_reset_n),
                        .de1_ps2b_in__data(de1_ps2b_in__data),
                        .de1_ps2b_in__clk(de1_ps2b_in__clk),
                        .de1_ps2_in__data(de1_ps2_in__data),
                        .de1_ps2_in__clk(de1_ps2_in__clk),
                        .de1_cl_inputs_status__sr_data(de1_cl_inputs_status__sr_data),
                        .de1_cl_inputs_status__left_rotary__direction_pin(de1_cl_inputs_status__left_rotary__direction_pin),
                        .de1_cl_inputs_status__left_rotary__transition_pin(de1_cl_inputs_status__left_rotary__transition_pin),
                        .de1_cl_inputs_status__right_rotary__direction_pin(de1_cl_inputs_status__right_rotary__direction_pin),
                        .de1_cl_inputs_status__right_rotary__transition_pin(de1_cl_inputs_status__right_rotary__transition_pin),

                        .de1_vga__vs(de1_vga__vs),
                        .de1_vga__hs(de1_vga__hs),
                        .de1_vga__blank_n(de1_vga__blank_n),
                        .de1_vga__sync_n(de1_vga__sync_n),
                        .de1_vga__red(de1_vga__r),
                        .de1_vga__green(de1_vga__g),
                        .de1_vga__blue(de1_vga__b),

                        .de1_cl_lcd_reset_n(de1_cl_lcd_reset_n),
                        .de1_cl_lcd__vsync_n(de1_cl_lcd__vsync_n),
                        .de1_cl_lcd__hsync_n(de1_cl_lcd__hsync_n),
                        .de1_cl_lcd__display_enable(de1_cl_lcd__display_enable),
                        .de1_cl_lcd__red(de1_cl_lcd__red),
                        .de1_cl_lcd__green(de1_cl_lcd__green),
                        .de1_cl_lcd__blue(de1_cl_lcd__blue),
                        .de1_cl_lcd__backlight(de1_cl_lcd__backlight),
                        
                        .de1_irda_txd(de1_irda__txd),
                        .de1_ps2b_out__data(de1_ps2b_out__data),
                        .de1_ps2b_out__clk(de1_ps2b_out__clk),
                        .de1_ps2_out__data(de1_ps2_out__data),
                        .de1_ps2_out__clk(de1_ps2_out__clk),
                        .de1_leds__leds(de1_leds),
                        .de1_leds__h0(de1_hex0),
                        .de1_leds__h1(de1_hex1),
                        .de1_leds__h2(de1_hex2),
                        .de1_leds__h3(de1_hex3),
                        .de1_leds__h4(de1_hex4),
                        .de1_leds__h5(de1_hex5),
                        .de1_cl_led_data_pin(de1_cl_led_data_pin),
                        .de1_cl_inputs_control__sr_clock(de1_cl_inputs_control__sr_clock),
                        .de1_cl_inputs_control__sr_shift(de1_cl_inputs_control__sr_shift)
                        );

endmodule
