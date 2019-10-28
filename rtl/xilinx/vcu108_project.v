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
                        
                        input         sgmii__rxd__p, input sgmii__rxd__n,
                        input         sgmii__rxc__p, input sgmii__rxc__n,
                        output        sgmii__txd__p, output sgmii__txd__n,

                        output        hdmi__clk,
                        output        hdmi__vsync, hdmi__hsync, hdmi__de,
                        output [15:0] hdmi__d,
                        output        hdmi__spdif
);
   wire         video_clk;
   wire         clk_locked;
   wire         reset_n;

   wire         vcu108_dprintf_req__valid;
   wire [15:0]  vcu108_dprintf_req__address;
   wire [63:0]  vcu108_dprintf_req__data_0;
   wire [63:0]  vcu108_dprintf_req__data_1;
   wire [63:0]  vcu108_dprintf_req__data_2;
   wire [63:0]  vcu108_dprintf_req__data_3;
   wire         vcu108_dprintf_ack;


   wire         sysclk1;
   IBUFDS sys_clk1_buf( .I(SYS_CLK1__p), .IB(SYS_CLK1__n), .O(sysclk1) );
   wire         clk125mhz;
   IBUFDS clk125mhz_buf( .I(CLK_125MHZ__p), .IB(CLK_125MHZ__n), .O(clk125mhz) );
   
   wire         sgmii_rxclk;
   IBUFDS sgmii_rxclk_buf( .I(sgmii__rxc__p), .IB(sgmii__rxc__n), .O(sgmii_rxclk) );
   OBUFTDS sgmii_txd_buf( .I(0), .T(1), .O(sgmii__txd__p), .OB(sgmii__txd__n) );
   //                     input         sgmii__rxd__p, input sgmii__rxd__n,
   //                     output        , output sgmii__txd__n,

   assign video_clk = clk_150;
   assign flash_clk = clk_50;
   wire reset_in = vcu108_inputs__buttons[1]
   assign reset_n = clk_locked;

   pll_base video_clk_gen( .refclk(sysclk1), .rst(reset_in),
                           .outclk_225(clk_225),
                           .outclk_150(clk_150),
                           .outclk_100(clk_100),
                           .outclk_50(clk_50),
                           .locked(clk_locked) );

   pll_sgmii_tx sgmii_pll_tx ( .refclk(clk125mhz), .rst(reset_in),
                         .outclk_625(tx_clk_625),
                         .outclk_312_5(tx_clk_312_5),
                         .outclk_125(tx_clk_125),
                         .outclk_25(tx_clk_25),
                         .locked(sgmii_tx_clk_locked) );
   
   pll_sgmii_rx sgmii_pll_rx ( .refclk(sgmii_rxclk), .rst(reset_in),
                         .outclk_625(rx_clk_625),
                         .outclk_312_5(rx_clk_312_5),
                         .outclk_125(rx_clk_125),
                         .outclk_25(rx_clk_25),
                         .locked(sgmii_rx_clk_locked) );
   
                                      
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

                      .vcu108_dprintf_req__valid(vcu108_dprintf_req__valid),
                      .vcu108_dprintf_req__address(vcu108_dprintf_req__address),
                      .vcu108_dprintf_req__data_0(vcu108_dprintf_req__data_0),
                      .vcu108_dprintf_req__data_1(vcu108_dprintf_req__data_1),
                      .vcu108_dprintf_req__data_2(vcu108_dprintf_req__data_2),
                      .vcu108_dprintf_req__data_3(vcu108_dprintf_req__data_3),
                      .vcu108_dprintf_ack(vcu108_dprintf_ack),

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

   wire measure_response__valid;
   wire measure_response__initial_value;
   wire measure_response__abort;
   wire [8:0] measure_response__delay;
   wire [8:0] measure_response__initial_delay;
   wire       cpm_clk;
   assign cpm_clk = rx_clk_125;
   wire [8:0] delay_config__value;
   cascaded_delay_pair cdp(.clk(cpm_clk),
                           .reset(!reset_n),
                           .delay__load(delay_config__load),
                           .delay__value(delay_config__value),
                           .data_in(sgmii_rxclk),
                           .data_out(cdp_delay_out)
                           );
   (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
   FDPE s_0 (.PRE (0),.C (cpm_clk), .CE (1), .D (cdp_delay_out), .Q (d0) );
   (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
   FDPE s_1 (.PRE (0),.C (cpm_clk), .CE (1), .D (d0), .Q (d1) );
   (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
   FDPE s_2 (.PRE (0),.C (cpm_clk), .CE (1), .D (d1), .Q (d2) );
   clocking_phase_measure cpm( .clk(cpm_clk),
                               .clk__enable(1),
                               .reset_n(reset_n),

                               .delay_response__load_ack(1),
                               .delay_response__value(0),
                               .delay_response__sync_value(d2),
                               .delay_config__load(delay_config__load),
                               .delay_config__value(delay_config__value),

                               .measure_request__valid(1),
                               //.measure_response__ack(1),
                               .measure_response__valid(measure_response__valid),
                               .measure_response__initial_value(measure_response__initial_value),
                               .measure_response__abort(measure_response__abort),
                               .measure_response__delay(measure_response__delay),
                               .measure_response__initial_delay(measure_response__initial_delay),
                               );

   dprintf_4_async d4a( .clk_in(cpm_clk),
                        .clk_in__enable(1),
                        .clk_out( `dut_clk),
                        .clk_out__enable(1),
                        .reset_n(reset_n),
                        .req_in__valid(measure_response__valid),
                        .req_in__address(80),
                        .req_in__data_0({32h87,
                                         7h0,
                                         measure_response__initial_delay,
                                         3h0,
                                         measure_response__delay,
                                         3h0,
                                         measure_response__initial_value,
                                         measure_response__abort,
                                         measure_response__valid}),
                        .req_in__data_1({8hff,56h0}),
                        .req_in__data_2(0),
                        .req_in__data_3(0),
                        // ack_in, Ack back to clk_in domain
                        .req_out__valid(vcu108_dprintf_req__valid),
                        .req_out__address(vcu108_dprintf_req__address),
                        .req_out__data_0(vcu108_dprintf_req__data_0),
                        .req_out__data_1(vcu108_dprintf_req__data_1),
                        .req_out__data_2(vcu108_dprintf_req__data_2),
                        .req_out__data_3(vcu108_dprintf_req__data_3),
                        ack_out(vcu108_dprintf_ack)
                        );

endmodule
