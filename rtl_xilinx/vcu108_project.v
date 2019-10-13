module vcu108_project ( input SYS_CLK1__p, input SYS_CLK1__n,
                        input         SYS_CLK2__p, input SYS_CLK2__n,
                        input         CLK_125MHZ__p, input CLK_125MHZ__n,
                        input         USER_SI570_CLOCK__p, input USER_SI570_CLOCK__n,
                        input FPGA_EMCCLK,
                        
                        input [3:0]   vcu108_inputs__switches,
                        input [4:0]   vcu108_inputs__buttons,
                        output [7:0]  vcu108_leds__leds,
                        input         uart_rxd, output uart_txd,
                        input         uart_rts, output uart_cts,
                        output        hdmi__clk,
                        output        hdmi__vsync, hdmi__hsync, hdmi__de,
                        output [15:0] hdmi__d,
                        output        hdmi__spdif
);
   wire         video_clk;
   wire         video_clk_locked;
   wire         sysclk1;
   wire         reset_n;

   assign uart_cts=0;
   
   IBUFDS sys_clk1_buf( .I(SYS_CLK1__p), .IB(SYS_CLK1__n), .O(sysclk1) );
   
   pll_150 video_clk_gen( .refclk(sysclk1), .rst(!reset_n),
                          .outclk_0(video_clk), .locked_0(video_clk_locked) );
   
   assign reset_n = vcu108_inputs__switches[0];
   `debug_module dut( .clk(sysclk1),
            .clk__enable(1),
            .video_clk(video_clk),
            .video_clk__enable(1),
            .reset_n(reset_n),
            .video_reset_n(reset_n),

            .vcu108_inputs__switches(vcu108_inputs__switches),
            .vcu108_inputs__buttons(vcu108_inputs__buttons),
            .vcu108_leds__leds(vcu108_leds__leds),
            .vcu108_video__vsync(hdmi__vsync),
            .vcu108_video__hsync(hdmi__hsync),
            .vcu108_video__de(hdmi__de),
            .vcu108_video__data(hdmi__d),
            .vcu108_video__spdif(hdmi__spdif),

     .uart_rxd(uart_rxd),
     .uart_txd(uart_txd)
            );
   assign hdmi__clk = video_clk;
endmodule
