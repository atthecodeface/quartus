module basic_project ( SYS_CLK1__p,
                       SYS_CLK1__n,
                       switches,
                       leds);

   input SYS_CLK1__p, SYS_CLK1__n;

   input [3:0]  switches;
   output [7:0] leds;

   wire         sysclk1;
   wire         reset_n;
   IBUFDS sys_clk1_buf( .I(SYS_CLK1__p), .IB(SYS_CLK1__n), .O(sysclk1) );
   assign reset_n = switches[0];
   `basic_module dut( .clk(sysclk1),
                      .clk__enable(1),
                      .reset_n(reset_n),

                      .switches(switches),
                      .leds(leds)
                      );

endmodule
