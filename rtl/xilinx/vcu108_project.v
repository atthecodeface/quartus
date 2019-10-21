module vcu108_project ( input SYS_CLK1__p, input SYS_CLK1__n,
                        input         SYS_CLK2__p, input SYS_CLK2__n,
                        input         CLK_125MHZ__p, input CLK_125MHZ__n,
                        input         USER_SI570_CLOCK__p, input USER_SI570_CLOCK__n,
                        //input         FPGA_EMCCLK,
                        
                        input [3:0]   vcu108_inputs__switches,
                        input [4:0]   vcu108_inputs__buttons,
                        output [7:0]  vcu108_outputs__leds,
                        input         uart_rxd, output uart_txd,
                        input         uart_rts, output uart_cts,

                        output        i2c_reset_mux_n,
                        inout         i2c_main__scl,
                        inout         i2c_main__sda,
                        inout         i2c_sysmon__scl,
                        inout         i2c_sysmon__sda,

                        output        eth__reset_n,
                        input         eth__int_n,
                        output        eth__mdc,
                        inout         eth__mdio,
                        
                        //output        bpi_flash__ce_b,
                        //output        bpi_flash__oe_b,
                        //output        bpi_flash__fwe_b,
                        //input         bpi_flash__wait,
                        //output        bpi_flash__adv,
                        //output [25:0] bpi_flash__a,
                        //inout  [15:0] bpi_flash__d,
                        
                        output        hdmi__clk,
                        output        hdmi__vsync, hdmi__hsync, hdmi__de,
                        output [15:0] hdmi__d,
                        output        hdmi__spdif
);
   wire         video_clk;
   wire         video_clk_locked;
   wire         sysclk1;
   wire         reset_n;

   IBUFDS sys_clk1_buf( .I(SYS_CLK1__p), .IB(SYS_CLK1__n), .O(sysclk1) );
   
   pll_base video_clk_gen( .refclk(sysclk1), .rst(!reset_n),
                           .outclk_225(clk_225),
                           .outclk_150(clk_150),
                           .outclk_100(clk_100),
                           .outclk_50(clk_50),
                           .locked(video_clk_locked) );

   assign video_clk = clk_150;
   assign flash_clk = clk_50;
   assign reset_n = vcu108_inputs__switches[0];
   `debug_module dut( .clk(`dut_clk),
                      .clk__enable(1),
                      .clk_50(clk_50),
                      .clk_50__enable(1),
                      
                      .video_clk(video_clk),
                      .video_clk__enable(1),
                      .reset_n(reset_n),
                      .video_reset_n(reset_n),

                      .flash_clk(flash_clk),
                      .flash_clk__enable(1),
                      
                      .vcu108_inputs__switches(vcu108_inputs__switches),
                      .vcu108_inputs__buttons(vcu108_inputs__buttons),
                      .vcu108_inputs__uart_rx__rxd(uart_rxd),
                      .vcu108_inputs__uart_rx__rts(uart_rts),
                      .vcu108_inputs__mdio(eth__mdio),
                      .vcu108_inputs__eth_int_n(eth__int_n),
                      .vcu108_inputs__i2c__scl(i2c_main__scl),
                      .vcu108_inputs__i2c__sda(i2c_main__sda),
                      
                      .vcu108_outputs__uart_tx__txd(uart_txd),
                      .vcu108_outputs__uart_tx__cts(uart_cts),
                      .vcu108_outputs__leds(vcu108_outputs__leds),
                      .vcu108_outputs__mdio__mdc(eth__mdc),
                      .vcu108_outputs__mdio__mdio(eth__mdio__out),
                      .vcu108_outputs__mdio__mdio_enable(eth__mdio__en),
                      .vcu108_outputs__eth_reset_n(eth__reset_n),
                      .vcu108_outputs__i2c_reset_mux_n(i2c_reset_mux_n__od), // open drain...
                      .vcu108_outputs__i2c__scl(i2c_main__scl__od), // open drain
                      .vcu108_outputs__i2c__sda(i2c_main__sda__od), // open drain

                      .vcu108_video__vsync(hdmi__vsync),
                      .vcu108_video__hsync(hdmi__hsync),
                      .vcu108_video__de(hdmi__de),
                      .vcu108_video__data(hdmi__d),
                      .vcu108_video__spdif(hdmi__spdif),

                      .flash_in__data(0)
                      );
   assign eth__mdio     = eth__mdio__en ? eth__mdio__out : 1'bz;
   assign i2c_reset_mux_n = i2c_reset_mux_n__od ? 1'bz : 1'b0;
   assign i2c_main__scl   = i2c_main__scl__od ? 1'bz : 1'b0;
   assign i2c_main__sda   = i2c_main__sda__od ? 1'bz : 1'b0;
   
   assign hdmi__clk = video_clk;
endmodule
