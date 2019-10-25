module pll_sgmii_tx (
		input  wire  refclk,
		input  wire  rst,     
		output wire  outclk_625,
		output wire  outclk_312_5,
		output wire  outclk_125,
		output wire  outclk_25,
		output wire  locked
	);

   wire              clk_fb;
    MMCME3_BASE  #(
        .CLKIN1_PERIOD(8.0), // Input clock period in ns units, ps resolution (i.e. 33.333 is 30 MHz).
        .DIVCLK_DIVIDE(1), // Master division value
        .CLKFBOUT_MULT_F(5), // Multiply value for VCO
        .CLKOUT0_DIVIDE_F(1), // Divide amount for CLKOUT0
        .CLKOUT1_DIVIDE(2), // Divide amount for CLKOUT1
        .CLKOUT2_DIVIDE(5), // Divide amount for CLKOUT21
        .CLKOUT3_DIVIDE(25) // Divide amount for CLKOUT3
    ) pll_i (
        .RST (rst),
        .PWRDWN (0),
        .CLKOUT0 (outclk_625),
        .CLKOUT1 (outclk_312_5),
        .CLKOUT2 (outclk_125),
        .CLKOUT3 (outclk_25),
        .LOCKED (locked),
        .CLKIN1 (refclk),
        .CLKFBOUT (clk_fb),
        .CLKFBIN (clk_fb)
    );

endmodule

module pll_sgmii_rx (
		input  wire  refclk,
		input  wire  rst,     
		output wire  outclk_625,
		output wire  outclk_312_5,
		output wire  outclk_125,
		output wire  outclk_25,
		output wire  locked
	);

   wire              clk_fb;
    MMCME3_BASE  #(
        .CLKIN1_PERIOD(1.6), // Input clock period in ns units, ps resolution (i.e. 33.333 is 30 MHz).
        .DIVCLK_DIVIDE(2), // Master division value
        .CLKFBOUT_MULT_F(2), // Multiply value for VCO
        .CLKOUT0_DIVIDE_F(1), // Divide amount for CLKOUT0
        .CLKOUT1_DIVIDE(2), // Divide amount for CLKOUT1
        .CLKOUT2_DIVIDE(5), // Divide amount for CLKOUT21
        .CLKOUT3_DIVIDE(25) // Divide amount for CLKOUT3
    ) pll_i (
        .RST (rst),
        .PWRDWN (0),
        .CLKOUT0 (outclk_625),
        .CLKOUT1 (outclk_312_5),
        .CLKOUT2 (outclk_125),
        .CLKOUT3 (outclk_25),
        .LOCKED (locked),
        .CLKIN1 (refclk),
        .CLKFBOUT (clk_fb),
        .CLKFBIN (clk_fb)
    );

endmodule

module pll_base (
		input  wire  refclk,
		input  wire  rst,     
		output wire  outclk_225,
		output wire  outclk_150,
		output wire  outclk_100,
		output wire  outclk_50,
		output wire  locked
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
                   .CLKOUT0_DIVIDE_F(4),     // Divide amount for CLKOUT0 (1.000-128.000) for 225Hz
                   .CLKOUT0_DUTY_CYCLE(0.5), // Default of 0.5
                   // ADV .CLKOUT0_USE_FINE_PS("FALSE"),
                   .CLKOUT1_DIVIDE(6),     // Divide amount for CLKOUT1 (1.000-128.000) for 150MHz
                   .CLKOUT2_DIVIDE(9),     // Divide amount for CLKOUT2 (1.000-128.000) for 100MHz
                   .CLKOUT3_DIVIDE(18),    // Divide amount for CLKOUT3 (1.000-128.000) for 50MHz
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
		     .CLKOUT0	(outclk_225),
		     .CLKOUT1	(outclk_150),
		     .CLKOUT2	(outclk_100),
		     .CLKOUT3	(outclk_50),
		     .LOCKED	(locked),
		     .CLKIN1	(refclk),
             .CLKFBOUT (clk_fb),
             .CLKFBIN  (clk_fb)
	);

endmodule
