module pll_150 (
		input  wire  refclk,
		input  wire  rst,     
		output wire  outclk_0,
		output wire  locked_0
	);

   wire              clk_fb;
   // MMCM clock in of 10MHz to 800MHz
   // MMCM VCO frequency between 600MHz and 1200MHz
   // MMCM Output frequency 4.7MHz - 630MHz
   // For 150MHz out we use a mult of 3 to 900MHz and divide of 6
	MMCME3_BASE #( .BANDWIDTH("OPTIMIZED"), // Jitter programming (HIGH, LOW, OPTIMIZED)
                   .STARTUP_WAIT("FALSE"), // Delays DONE until MMCM is locked (FALSE, TRUE)
                   // CLKIN_PERIOD: Input clock period in ns units, ps resolution (i.e. 33.333 is 30 MHz).
                   .CLKIN1_PERIOD(3.33), // 300MHz input
                   .IS_CLKIN1_INVERTED(1'b0), // Optional inversion for CLKIN1
                   // REF_JITTER: Reference input jitter in UI (0.000-0.999).
                   .REF_JITTER1(0.0),
                   // ADV .CLKIN2_PERIOD(10.0), and other clkin2 things
                   .DIVCLK_DIVIDE(1),        // Master division value (1-106)
                   .CLKFBOUT_MULT_F(3),      // Multiply value for VCO (2.000-64.000) - 300MHz up to 900MHz
                   .CLKFBOUT_PHASE(0.0),     // Phase offset in degrees of CLKFB default of 0.
                   .CLKOUT0_DIVIDE_F(6),     // Divide amount for CLKOUT0 (1.000-128.000) for 150MHz
                   .CLKOUT0_DUTY_CYCLE(0.5), // Default of 0.5
                   // ADV .CLKOUT0_USE_FINE_PS("FALSE"),
                   .CLKOUT1_DIVIDE(90), // 10MHz
                   .CLKOUT2_DIVIDE(90),
                   .CLKOUT3_DIVIDE(90),
                   // ADV .CLKOUT4_CASCADE("TRUE"),
                   .CLKOUT4_DIVIDE(90),
                   .CLKOUT5_DIVIDE(90),
                   .CLKOUT6_DIVIDE(90),
                   // ADV .COMPENSATION("AUTO"), // AUTO, BUF_IN, EXTERNAL, INTERNAL, ZHOLD - base uses internal feedback
                   // Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
                   .IS_CLKFBIN_INVERTED(1'b0), // Optional inversion for CLKFBIN
                   // ADV .IS_CLKIN2_INVERTED(1'b0), // Optional inversion for CLKIN2
                   // ADV .IS_CLKINSEL_INVERTED(1'b0), // Optional inversion for CLKINSEL
                   // ADV .IS_PSEN_INVERTED(1'b0), // Optional inversion for PSEN
                   // ADV .IS_PSINCDEC_INVERTED(1'b0), // Optional inversion for PSINCDEC
                   .IS_PWRDWN_INVERTED(1'b0), // Optional inversion for PWRDWN
                   // ADV Spread Spectrum: Spread Spectrum Attributes
                   // ADV .SS_EN("FALSE"), // Enables spread spectrum (FALSE, TRUE)
                   // ADV .SS_MODE("CENTER_HIGH"), // CENTER_HIGH, CENTER_LOW, DOWN_HIGH, DOWN_LOW
                   // ADV .SS_MOD_PERIOD(10000), // Spread spectrum modulation period (ns) (4000-40000)
                   // USE_FINE_PS: Fine phase shift enable (TRUE/FALSE)
                   // ADV .CLKFBOUT_USE_FINE_PS("FALSE"),
                   .IS_RST_INVERTED(1'b0) // Optional inversion for RST
	) pll_i (
		     .RST	(rst),
             .PWRDWN (1'b0),
		     .CLKOUT0	(outclk_0),
		     .LOCKED	(locked_0),
		     .CLKIN1	(refclk),
             .CLKFBOUT (clk_fb),
             .CLKFBIN  (clk_fb)
	);

endmodule

// ADV7511 in XCVU108 connects data bits [16;8] and hence is 16-bit (INPUT ID=1, style=1)
// This requires Cb/Y, Cr/Y in successive cycles
// I2C address is 0x72
// Out of reset (when powers up)
// I2c register 0x41[1;6] = power down (must only be cleared when HPD is high)
// I2C register 0x98[8;0] = 0x03
// I2C register 0x9a[7;1] = 0x70
// I2C register 0x9c[7;0] = 0x30
// I2C register 0x9d[2;0] = 0x01
// I2C register 0xa2[8;0] = 0xa4
// I2C register 0xa3[8;0] = 0xa4
// I2C register 0xe0[8;0] = 0xd0
// I2c register 0xaf[1;1] = output is HDMI (not DVI)
// Input style
// I2C register 0xf9[8;0] = 0
// I2C register 0x15[4;0] = 1 (input id)  (other bits 0)
// I2C register 0x16[2;4] = 2b11 (8 bit per channel)
// I2C register 0x16[2;2] = 2b10 (style 1)  (other bits 0)
// I2C register 0x48[2;3] = 01 (right justified) (other bits 0)
// 1080p-60 is 1920x1080
// pixel clock 148.5MHz = 900MHz/6 almost
// line time is 14.8us
// frame time is 16666us
// horizontal front porch/sync/back porch/active = 88/44/148/1920 +ve sync
// vertical   front porch/sync/back porch/active = 4/5/36/1080 +ve sync

module basic_project_pll ( SYS_CLK1__p,
                           SYS_CLK1__n,
                           switches,
                           leds);

   input SYS_CLK1__p, SYS_CLK1__n;

   input [3:0]  switches;
   output [7:0] leds;

   wire         video_clk;
   wire         video_clk_locked;
   wire         sysclk1;
   wire         reset_n;
   wire [7:0]   leds_basic;
   IBUFDS sys_clk1_buf( .I(SYS_CLK1__p), .IB(SYS_CLK1__n), .O(sysclk1) );
   
   pll_150 video_clk_gen( .refclk(sysclk1), .rst(!reset_n),
                          .outclk_0(video_clk), .locked_0(video_clk_locked) );
   
   assign reset_n = switches[0];
   `basic_module dut( .clk(video_clk),
                      .clk__enable(1),
                      .reset_n(reset_n),

                      .switches(switches),
                      .leds(leds_basic)
                      );
   assign leds = {video_clk_locked, leds_basic[6:0]};
   
endmodule
