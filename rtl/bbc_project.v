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
                   inputs_status__sr_data,
                   inputs_status__left_rotary__direction_pin, inputs_status__left_rotary__transition_pin,
                   inputs_status__right_rotary__direction_pin, inputs_status__right_rotary__transition_pin,

                   inputs_control__sr_clock, inputs_control__sr_shift,
                   led_data_pin,
                   lcd__clock, lcd__vsync_n, lcd__hsync_n, lcd__display_enable, lcd__red, lcd__green, lcd__blue,
                   lcd__backlight);
   
   input clk         //synthesis altera_chip_pin_lc="@AF14"
         ; // clock_50 : 
   input reset_n     //synthesis altera_chip_pin_lc="@Y16"
         ; // key 3:

    input inputs_status__sr_data //synthesis altera_chip_pin_lc="@AC23"
          ;
    input inputs_status__left_rotary__direction_pin //synthesis altera_chip_pin_lc="@AE24"
          ;
    input inputs_status__left_rotary__transition_pin //synthesis altera_chip_pin_lc="@AD24"
          ;
    input inputs_status__right_rotary__direction_pin //synthesis altera_chip_pin_lc="@AB21"
          ;
    input inputs_status__right_rotary__transition_pin //synthesis altera_chip_pin_lc="@AB17"
          ;

   input [9:0] switches  //synthesis altera_chip_pin_lc="@AE12,@AD10,@AC9,@AE11,@AD12,@AD11,@AF10,@AF9,@AC12,@AB12"
                 ;
   input [2:0] keys  //synthesis altera_chip_pin_lc="@W15,@AA15,@AA14"
                 ;

    output inputs_control__sr_clock //synthesis altera_chip_pin_lc="@AF25"
           ;
    output inputs_control__sr_shift //synthesis altera_chip_pin_lc="@AE23"
           ;
   output  led_data_pin //synthesis altera_chip_pin_lc="@AG25"
           ; // BSS138 G (AdaFruit/Neopixel LED chain in) 

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
   // 15: AK28 JP2.18  LCD DISP (display on/off) - probably floating high?
   // 11: AH24 JP2.14  J3   Touch SDA
   // 10: AG26 JP2.13  J3   Touch SCL
   //  8: AF26 JP2.9   J3   Touch WAKE
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

                              .inputs_status__sr_data(inputs_status__sr_data),
                              .inputs_status__left_rotary__direction_pin(inputs_status__left_rotary__direction_pin),
                              .inputs_status__left_rotary__transition_pin(inputs_status__left_rotary__transition_pin),
                              .inputs_status__right_rotary__direction_pin(inputs_status__right_rotary__direction_pin),
                              .inputs_status__right_rotary__transition_pin(inputs_status__right_rotary__transition_pin),

                              .switches(switches),
                              .keys({1'b0,keys}),
                              .video_locked(video_clk_locked),
                              .reset_n(reset_n),

                              .inputs_control__sr_clock(inputs_control__sr_clock),
                              .inputs_control__sr_shift(inputs_control__sr_shift),
                              .led_data_pin(led_data_pin),
                              .leds(leds),
                              .lcd__vsync_n(lcd__vsync_n),
                              .lcd__hsync_n(lcd__hsync_n),
                              .lcd__display_enable(lcd__display_enable),
                              .lcd__red(lcd__red),
                              .lcd__green(lcd__green),
                              .lcd__blue(lcd__blue),
                              .lcd__backlight(lcd__backlight) );
   
endmodule
