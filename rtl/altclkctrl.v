module altclkctrl(ena, inclk, outclk);
   input ena, inclk;
   output outclk;
	cyclonev_clkena   sd1
	( 
	.ena(ena),
	.enaout(),
	.inclk(inclk),
	.outclk(outclk));
	defparam
		sd1.clock_type = "Global Clock",
		sd1.ena_register_mode = "falling edge",
		sd1.lpm_type = "cyclonev_clkena";
endmodule
