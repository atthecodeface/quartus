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
