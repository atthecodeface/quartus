module  pll_lcd_0002(

	// interface 'refclk'
	input wire refclk,

	// interface 'reset'
	input wire rst,

	// interface 'outclk0'
	output wire outclk_0,

	// interface 'locked'
	output wire locked
);

	altera_pll #(
		.fractional_vco_multiplier("false"),
		.reference_clock_frequency("50.0 MHz"),
		.operation_mode("direct"),
		.number_of_clocks(1),
		.output_clock_frequency0("9.000000 MHz"),
		.phase_shift0("0 ps"),
		.duty_cycle0(50),
		.output_clock_frequency1("0 MHz"),
		.phase_shift1("0 ps"),
		.duty_cycle1(50),
		.output_clock_frequency2("0 MHz"),
		.phase_shift2("0 ps"),
		.duty_cycle2(50),
		.output_clock_frequency3("0 MHz"),
		.phase_shift3("0 ps"),
		.duty_cycle3(50),
		.output_clock_frequency4("0 MHz"),
		.phase_shift4("0 ps"),
		.duty_cycle4(50),
		.output_clock_frequency5("0 MHz"),
		.phase_shift5("0 ps"),
		.duty_cycle5(50),
		.output_clock_frequency6("0 MHz"),
		.phase_shift6("0 ps"),
		.duty_cycle6(50),
		.output_clock_frequency7("0 MHz"),
		.phase_shift7("0 ps"),
		.duty_cycle7(50),
		.output_clock_frequency8("0 MHz"),
		.phase_shift8("0 ps"),
		.duty_cycle8(50),
		.output_clock_frequency9("0 MHz"),
		.phase_shift9("0 ps"),
		.duty_cycle9(50),
		.output_clock_frequency10("0 MHz"),
		.phase_shift10("0 ps"),
		.duty_cycle10(50),
		.output_clock_frequency11("0 MHz"),
		.phase_shift11("0 ps"),
		.duty_cycle11(50),
		.output_clock_frequency12("0 MHz"),
		.phase_shift12("0 ps"),
		.duty_cycle12(50),
		.output_clock_frequency13("0 MHz"),
		.phase_shift13("0 ps"),
		.duty_cycle13(50),
		.output_clock_frequency14("0 MHz"),
		.phase_shift14("0 ps"),
		.duty_cycle14(50),
		.output_clock_frequency15("0 MHz"),
		.phase_shift15("0 ps"),
		.duty_cycle15(50),
		.output_clock_frequency16("0 MHz"),
		.phase_shift16("0 ps"),
		.duty_cycle16(50),
		.output_clock_frequency17("0 MHz"),
		.phase_shift17("0 ps"),
		.duty_cycle17(50),
		.pll_type("General"),
		.pll_subtype("General")
	) altera_pll_i (
		.rst	(rst),
		.outclk	({outclk_0}),
		.locked	(locked),
		.fboutclk	( ),
		.fbclk	(1'b0),
		.refclk	(refclk)
	);
endmodule
module pll_lcd (
		input  wire  refclk,   //  refclk.clk
		input  wire  rst,      //   reset.reset
		output wire  outclk_0, // outclk0.clk
		output wire  locked    //  locked.export
	);

	pll_lcd_0002 pll_lcd_inst (
		.refclk   (refclk),   //  refclk.clk
		.rst      (rst),      //   reset.reset
		.outclk_0 (outclk_0), // outclk0.clk
		.locked   (locked)    //  locked.export
	);

endmodule
module bbc_project(clk, reset_n, leds, switches, keys,
                   lcd__clock, lcd__vsync_n, lcd__hsync_n, lcd__display_enable, lcd__red, lcd__green, lcd__blue,
                   lcd__backlight);
   
   input clk         //synthesis altera_chip_pin_lc="@AF14"
         ; // clock_50 : 
   input reset_n     //synthesis altera_chip_pin_lc="@Y16"
         ; // key 3:
   input [9:0] switches  //synthesis altera_chip_pin_lc="@AE12,@AD10,@AC9,@AE11,@AD12,@AD11,@AF10,@AF9,@AC12,@AB12"
                 ;
   input [2:0] keys  //synthesis altera_chip_pin_lc="@W15,@AA15,@AA14"
                 ;

   output [9:0] leds //synthesis altera_chip_pin_lc="@Y21,@W21,@W20,@Y19,@W19,@W17,@V18,@V17,@W16,@V16"
                ; // LEDS: 
   
   output       lcd__clock              //synthesis altera_chip_pin_lc="@AK27"
                ;
   output       lcd__vsync_n            //synthesis altera_chip_pin_lc="@AJ27"
                ;
   output       lcd__hsync_n            //synthesis altera_chip_pin_lc="@AK29"
                ;
   output       lcd__display_enable     //synthesis altera_chip_pin_lc="@AH27"
                ;
   output [5:0] lcd__red                //synthesis altera_chip_pin_lc="@AF24,@AF23,@AE22,@AD21,@AA20,@AC22"
                ;
   output [6:0] lcd__green              //synthesis altera_chip_pin_lc="@AG23,@AK23,@AH23,@AK22,@AJ22,@AH22,@AG22"
                ;
   output [5:0] lcd__blue               //synthesis altera_chip_pin_lc="@AJ26,@AK26,@AH25,@AJ25,@AJ24,@AK24"
                ;
   output       lcd__backlight          //synthesis altera_chip_pin_lc="@AA21"
                ;
   
   assign lcd__clock          = !video_clk;

   // e.g. output [7:0] sum /* synthesis altera_chip_pin_lc="@17, @166, @191, @152, @15, @148, @147, @149" */;
   // pin assignments
   // GPIO1
   // 35: AC22 JP2.40  LCD R
   // 34: AA20 JP2.39  LCD R
   // 33: AD21 JP2.38  LCD R
   // 32: AE22 JP2.37  LCD R
   // 31: AF23 JP2.36  LCD R
   // 30: AF24 JP2.35  LCD R
   // 29: AG22 JP2.34  LCD G
   // 28: AH22 JP2.33  LCD G
   // 27: AJ22 JP2.32  LCD G
   // 26: AK22 JP2.31  LCD G
   // 25: AH23 JP2.28  LCD G
   // 24: AK23 JP2.27  LCD G
   // 23: AG23 JP2.26  LCD G
   // 22: AK24 JP2.25  LCD B
   // 21: AJ24 JP2.24  LCD B
   // 20: AJ25 JP2.23  LCD B
   // 19: AH25 JP2.22  LCD B
   // 18: AK26 JP2.21  LCD B
   // 17: AJ26 JP2.20  LCD B
   // 16: AK27 JP2.19  LCD CLK = (5,9,12)MHz
   // 15: AK28 JP2.18  LCD DISP (display on/off)
   // 14: AK29 JP2.17  LCD HSYNCn - 1 clock, active low; 55 to 65ns period (520,525,800) ticks; (36,40,255) back porch, (4,5,65) front porch
   // 13: AJ27 JP2.16  LCD VSYNCn - 1 HSYNCn period, going low with HSYNCd, high with HSYNCn; 277,288,400 (min, typ, max) H periods for a VSYNCn period; (3,8,31) back porch; (2,8,97) front porch
   // 12: AH27 JP2.15  LCD DEN - high for 480 clocks per line, data valid; no data during porches; 272 periods per vsync
   // 11: AH24 JP2.14  J3   Touch SDA
   // 10: AG26 JP2.13  J3   Touch SCL
   //  9: AG25 JP2.10  Q1   BSS138 G (AdaFruit/Neopixel LED chain in)
   //  8: AF26 JP2.9   J3   Touch WAKE
   //  7: AF25 JP2.8   IC6  74LS165 CLK
   //  6: AE24 JP2.7 SW8
   //  5: AE23 JP2.6   IC6  74LS165 SH/LDn
   //  4: AD24 JP2.5 SW8
   //  3: AC23 JP2.4   IC6  74LS165 QHn (joystick nsew/in, rotary switch, touchpad interrupt, SW8/9)
   //  2: AB21 JP2.3 SW9
   //  1: AA21 JP2.2   IC1  FAN5333 SHDN (backlight)
   //  0: AB17 JP2.1 SW9
   // LEDs
   //  9: Y21
   //  8: W21
   //  7: W20
   //  6: Y19
   //  5: W19
   //  4: W17
   //  3: V18
   //  2: V17
   //  1: W16
   //  0: V16
   // Keys - pushbuttons
   //  0: AA14
   //  1: AA15
   //  2: W15
   //  3: Y16
   // Slide switches
   //  0: AB12
   //  1: AC12
   //  2: AF9
   //  3: A
   //  4: A
   //  5: AD12
   //  6: A
   //  7: A
   //  8: A
   //  9: A
   // VGA
   //  R7-0: F13,E12,D12,C12,B12,E13,C13,A13
   //  G7-0: E11,F11,G12,G11,G10,H12,G1,G0
   //  B7-0: J14,G15,F15,H14,F14,H13,G13,B13
   //  VGA_BLANK_N: F10
   //  VGA_VSYNC_N: D11 - to D-sub
   //  VGA_HSYNC_N: B11 - to D-sub
   //  VGA_SYNC_N:  C10 - to ADV7123
   //  VGA_CLK:     A11 - to ADV7123
   
   wire         video_clk;
   wire         video_clk_locked;
   pll_lcd video_clk_gen( .refclk(clk), .rst(!reset_n), .outclk_0(video_clk), .locked(video_clk_locked) );

   bbc_micro_de1_cl bbc_micro(.video_clk(video_clk),
                              .video_clk__enable(1'b1),
                              .clk(clk),
                              .clk__enable(1'b1),

                              .switches(switches),
                              .keys({1'b0,keys}),
                              .video_locked(video_clk_locked),
                              .reset_n(reset_n),

                              .leds(leds),
                              .lcd__vsync_n(lcd__vsync_n),
                              .lcd__hsync_n(lcd__hsync_n),
                              .lcd__display_enable(lcd__display_enable),
                              .lcd__red(lcd__red),
                              .lcd__green(lcd__green),
                              .lcd__blue(lcd__blue),
                              .lcd__backlight(lcd__backlight) );
   
endmodule
