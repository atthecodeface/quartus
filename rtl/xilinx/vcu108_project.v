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

   assign video_clk = clk_150;
   assign flash_clk = clk_50;
   wire   reset_in = vcu108_inputs__buttons[1];
   assign reset_n = clk_locked;

   wire   measure_response__ack;
   wire   measure_response__abort;
   wire   measure_response__valid;
   wire [8:0] measure_response__delay;
   wire [8:0] measure_response__initial_delay;
   wire   measure_response__initial_value;
   wire       eye_track_response__measure_ack;
   wire       eye_track_response__locked;
   wire       eye_track_response__eye_data_valid;
   wire [8:0] eye_track_response__data_delay;
   wire [8:0] eye_track_response__eye_width;
   wire [8:0] eye_track_response__eye_center;

   wire [3:0] sgmii_txd;
   wire [3:0] sgmii_rxd;
   wire [3:0] sgmii_rxd_tracker;

   pll_base video_clk_gen( .refclk(sysclk1), .rst(reset_in),
                           .outclk_225(clk_225),
                           .outclk_150(clk_150),
                           .outclk_128_57(clk_128_57),
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

                      .sgmii_rx_clk(rx_clk_312_5), // frequency locked to rx data stream
                      .sgmii_rx_clk__enable(1),
                      .sgmii_tx_clk(tx_clk_312_5), // not locked to rx data stream
                      .sgmii_tx_clk__enable(1),

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

                      .sgmii_txd(sgmii_txd),
                      .sgmii_rxd(sgmii_rxd),
                      .sgmii_rx_reset_n(reset_n),
                      .sgmii_tx_reset_n(reset_n),

                      .flash_in__data(0)
                      );
   assign eth__mdio     = eth__mdio__en ? eth__mdio__out : 1'bz;
   assign i2c_reset_mux_n = i2c_reset_mux_n__od ? 1'bz : 1'b0;
   assign i2c_main__scl   = i2c_main__scl__od ? 1'bz : 1'b0;
   assign i2c_main__sda   = i2c_main__sda__od ? 1'bz : 1'b0;
   
   assign hdmi__clk = video_clk;

   sgmii_transceiver sgmii_xcvr (
                      .rx_clk_serial(rx_clk_625),
                      .rx_clk_serial__enable(1),
                      .rx_clk_312_5(rx_clk_312_5),
                      .rx_clk_312_5__enable(1),
                      .tx_clk_serial(tx_clk_625),
                      .tx_clk_serial__enable(1),
                      .tx_clk_312_5(tx_clk_312_5),
                      .tx_clk_312_5__enable(1),

    //.transceiver_control__valid(),
    .sgmii_rxclk(sgmii_rxclk),
    .sgmii__rxd__p(sgmii__rxd__p),
    .sgmii__rxd__n(sgmii__rxd__n),
    .sgmii_txd(sgmii_txd),
    .reset_n(reset_n),

    .sgmii_rxd(sgmii_rxd),
    .sgmii__txd__p(sgmii__txd__p),
    .sgmii__txd__n(sgmii__txd__n),

    .transceiver_status__measure_response__ack(measure_response__ack),
    .transceiver_status__measure_response__abort(measure_response__abort),
    .transceiver_status__measure_response__valid(measure_response__valid),
    .transceiver_status__measure_response__delay(measure_response__delay),
    .transceiver_status__measure_response__initial_delay(measure_response__initial_delay),
    .transceiver_status__measure_response__initial_value(measure_response__initial_value),
    .transceiver_status__eye_track_response__measure_ack(eye_track_response__measure_ack),
    .transceiver_status__eye_track_response__locked(eye_track_response__locked),
    .transceiver_status__eye_track_response__eye_data_valid(eye_track_response__eye_data_valid),
    .transceiver_status__eye_track_response__data_delay(eye_track_response__data_delay),
    .transceiver_status__eye_track_response__eye_width(eye_track_response__eye_width),
    .transceiver_status__eye_track_response__eye_center(eye_track_response__eye_center)
);

   wire        mr_okay = measure_response__valid && (measure_response__delay>16);
   wire        dprintf_req_valid = mr_okay | eye_track_response__eye_data_valid;
   wire [15:0] dprintf_req_addr  = mr_okay ? 80 : 100;
   wire [63:0] dprintf_req_data = mr_okay ? {32'h20202087,
                                             7'h0,
                                             measure_response__initial_delay, // 9
                                             3'h0,
                                             measure_response__delay, // 9
                                             1'h0,
                                             measure_response__initial_value, // 1
                                             measure_response__abort, // 1
                                             measure_response__valid} : // 1
               { 8'h89, // 8
                 3'b0, eye_track_response__eye_width, // 12
                 3'b0, eye_track_response__eye_center, // 12
                 3'b0, eye_track_response__data_delay, // 12
                 4'b0, // 4
                 8'hff, 8'h00 // 16
                 }; // 1
   dprintf_4_async d4a( .clk_in(rx_clk_312_5),
                        .clk_in__enable(1),
                        .clk_out( `dut_clk),
                        .clk_out__enable(1),
                        .reset_n(reset_n),
                        .req_in__valid(dprintf_req_valid),
                        .req_in__address(dprintf_req_addr),
                        .req_in__data_0(dprintf_req_data),
                        .req_in__data_1({32'hffffffff,32'hffffffff}),
                        .req_in__data_2({32'hffffffff,32'hffffffff}),
                        .req_in__data_3({32'hffffffff,32'hffffffff}),
                        // ack_in, Ack back to clk_in domain
                        .req_out__valid(vcu108_dprintf_req__valid),
                        .req_out__address(vcu108_dprintf_req__address),
                        .req_out__data_0(vcu108_dprintf_req__data_0),
                        .req_out__data_1(vcu108_dprintf_req__data_1),
                        .req_out__data_2(vcu108_dprintf_req__data_2),
                        .req_out__data_3(vcu108_dprintf_req__data_3),
                        .ack_out(vcu108_dprintf_ack)
                        );

endmodule
