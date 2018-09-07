module cam_de1_hps_project ( clk_50, clk_2_50, clk_3_50, clk_4_50, reset_n,

                     de1_adc__cs_n, de1_adc__din, de1_adc__dout, de1_adc__sclk,
                     de1_aud__adcdat, de1_aud__adclkrck, de1_aud__bclk, de1_aud__dacdat, de1_aud__daclrck, de1_aud__xck,

                     de1_ddr__clk, de1_ddr__cke, de1_ddr__cs_n,
                     de1_ddr__addr, de1_ddr__ba,
                     de1_ddr__ras_n, de1_ddr__cas_n, de1_ddr__we_n,
                     de1_ddr__dq, de1_ddr__ldqm, de1_ddr__udqm,

                     de1_fan_ctrl,

                     de1_fpga_i2c__sclk,
                     de1_fpga_i2c__sdat,

                     de1_hex0, de1_hex1,de1_hex2, de1_hex3, de1_hex4, de1_hex5,

                     de1_irda__rxd, de1_irda__txd,
                     de1_key, de1_switches, de1_leds,
                     
                     de1_td__clk27, de1_td__data, de1_td__hs, de1_td__reset_n, de1_td__vs,

                     de1_vga__b, de1_vga__blank_n, de1_vga__clk, de1_vga__g, de1_vga__hs, de1_vga__r, de1_vga__sync_n, de1_vga__vs,

                     de1_ps2_dat, de1_ps2_clk,
                     de1_ps2_b_dat, de1_ps2_b_clk,

                     hps_conv_usb_n,

                     hps_ddr3__ck_n, hps_ddr3__ck_p, hps_ddr3__cke, hps_ddr3__reset_n,
                     hps_ddr3__cs_n, hps_ddr3__ras_n, hps_ddr3__cas_n, hps_ddr3__we_n,
                     hps_ddr3__addr, hps_ddr3__ba,
                     hps_ddr3__dm, hps_ddr3__dq, hps_ddr3__dqs_n, hps_ddr3__dqs_p,

                     hps_ddr3__odt, hps_ddr3__rzq,

                     hps_enet__gtx_clk,
                     hps_enet__int_n,
                     hps_enet__mdc, hps_enet__mdio,
                     hps_enet__rx_clk, hps_enet__rx_data, hps_enet__rx_dv,
                     hps_enet__tx_data, hps_enet__tx_en,

                     hps_flash__data, hps_flash__dclk, hps_flash__ncso,

                     hps_gsensor_int,

                     hps_i2c1_sclk, hps_i2c1_sdat, hps_i2c2_sclk, hps_i2c2_sdat, hps_i2c_control,

                     hps_key,
                     hps_led,
                     hps_ltc_gpio,

                     hps_sd__clk, hps_sd__cmd, hps_sd__data,

                     hps_spim__clk, hps_spim__miso, hps_spim__mosi, hps_spim__ss,

                     hps_uart__rx, hps_uart__tx,

                     hps_usb__clkout, hps_usb__data, hps_usb__dir, hps_usb__nxt, hps_usb__stp,

                     cam_inputs_status__sr_data,
                     cam_inputs_status__left_rotary__direction_pin, cam_inputs_status__left_rotary__transition_pin,
                     cam_inputs_status__right_rotary__direction_pin, cam_inputs_status__right_rotary__transition_pin,

                     cam_inputs_control__sr_clock, cam_inputs_control__sr_shift,
                     cam_led_data_pin,
                     cam_lcd__clock, cam_lcd__vsync_n, cam_lcd__hsync_n, cam_lcd__display_enable, cam_lcd__red, cam_lcd__green, cam_lcd__blue,
                     cam_lcd__backlight

                     );
   input clk_50;
   input clk_2_50;
   input clk_3_50;
   input clk_4_50;
   input reset_n;

   inout   de1_adc__cs_n;
   output  de1_adc__din;
   input   de1_adc__dout;
   output  de1_adc__sclk;

   input   de1_aud__adcdat;
   inout   de1_aud__adclkrck;
   inout   de1_aud__bclk;
   output  de1_aud__dacdat;
   inout   de1_aud__daclrck;
   output  de1_aud__xck;

   output  de1_ddr__clk;
   output  de1_ddr__cke;
   output  de1_ddr__cs_n;
   output [12:0] de1_ddr__addr;
   output [1:0]  de1_ddr__ba;
   inout [15:0]  de1_ddr__dq;
   output        de1_ddr__ldqm;
   output        de1_ddr__udqm;
   output        de1_ddr__ras_n;
   output        de1_ddr__cas_n;
   output        de1_ddr__we_n;

   output        de1_fan_ctrl;
   output        de1_fpga_i2c__sclk;
   inout         de1_fpga_i2c__sdat;
   output [6:0]  de1_hex0;
   output [6:0]  de1_hex1;
   output [6:0]  de1_hex2;
   output [6:0]  de1_hex3;
   output [6:0]  de1_hex4;
   output [6:0]  de1_hex5;

   input         de1_irda__rxd;
   output        de1_irda__txd;
   input [3:0]   de1_key;
   output [9:0]  de1_leds;
   input [9:0]   de1_switches;

   inout       de1_ps2_clk;
   inout       de1_ps2_dat;
   inout       de1_ps2_b_clk;
   inout       de1_ps2_b_dat;

   input        de1_td__clk27;
   input [7:0]  de1_td__data;
   input        de1_td__hs;
   output       de1_td__reset_n;
   input        de1_td__vs;

   output [7:0] de1_vga__b;
   output       de1_vga__blank_n;
   output       de1_vga__clk;
   output [7:0] de1_vga__g;
   output       de1_vga__hs;
   output [7:0] de1_vga__r;
   output       de1_vga__sync_n;
   output       de1_vga__vs;
   
   input        cam_inputs_status__sr_data;
   input        cam_inputs_status__left_rotary__direction_pin;
   input        cam_inputs_status__left_rotary__transition_pin;
   input        cam_inputs_status__right_rotary__direction_pin;
   input        cam_inputs_status__right_rotary__transition_pin;

   output      cam_inputs_control__sr_clock;
   output      cam_inputs_control__sr_shift;
   output      cam_led_data_pin;
   output      cam_lcd__clock             ;
   output      cam_lcd__vsync_n           ;
   output      cam_lcd__hsync_n           ;
   output      cam_lcd__display_enable    ;
   output [5:0] cam_lcd__red               ;
   output [6:0] cam_lcd__green             ;
   output [5:0] cam_lcd__blue              ;
   output       cam_lcd__backlight         ;

   inout        hps_conv_usb_n;

   output        hps_ddr3__ck_p;
   output        hps_ddr3__ck_n;
   output        hps_ddr3__cke;
   output        hps_ddr3__reset_n;
   output        hps_ddr3__cs_n;
   output        hps_ddr3__cas_n;
   output        hps_ddr3__ras_n;
   output        hps_ddr3__we_n;
   output [14:0] hps_ddr3__addr;
   output [2:0]  hps_ddr3__ba;
   output [3:0]  hps_ddr3__dm;
   inout [31:0]  hps_ddr3__dq;
   inout [3:0]   hps_ddr3__dqs_n;
   inout [3:0]   hps_ddr3__dqs_p;
   output        hps_ddr3__odt;
   input         hps_ddr3__rzq;

   output        hps_enet__gtx_clk;
   inout         hps_enet__int_n;
   output        hps_enet__mdc;
   inout         hps_enet__mdio;
   input         hps_enet__rx_clk;
   input [3:0]   hps_enet__rx_data;
   input         hps_enet__rx_dv;
   output [3:0]  hps_enet__tx_data;
   output        hps_enet__tx_en;

   inout [3:0]   hps_flash__data;
   output        hps_flash__dclk;
   output        hps_flash__ncso;

   inout         hps_gsensor_int;

   inout         hps_i2c1_sclk;
   inout         hps_i2c1_sdat;
   inout         hps_i2c2_sclk;
   inout         hps_i2c2_sdat;
   inout         hps_i2c_control;

   inout         hps_key;
   inout         hps_led;

   inout         hps_ltc_gpio;

   output        hps_sd__clk;
   inout         hps_sd__cmd;
   inout [3:0]   hps_sd__data;

   output        hps_spim__clk;
   input         hps_spim__miso;
   output        hps_spim__mosi;
   inout         hps_spim__ss;

   input         hps_uart__rx;
   output        hps_uart__tx;

   input         hps_usb__clkout;
   inout [7:0]   hps_usb__data;
   input         hps_usb__dir;
   input         hps_usb__nxt;
   output        hps_usb__stp;


   wire               hps_0_f2h_axi_clock_clk;
   wire [7:0]         f2h__awid;
   wire [31:0]        f2h__awaddr;
   wire [3:0]         f2h__awlen;
   wire [2:0]         f2h__awsize;
   wire [1:0]         f2h__awburst;
   wire [1:0]         f2h__awlock;
   wire [3:0]         f2h__awcache;
   wire [2:0]         f2h__awprot;
   wire               f2h__awvalid;
   wire               f2h__awready;
   wire [4:0]         f2h__awuser;
   wire [7:0]         f2h__wid;
   wire [63:0]        f2h__wdata;
   wire [7:0]         f2h__wstrb;
   wire               f2h__wlast;
   wire               f2h__wvalid;
   wire               f2h__wready;
   wire [7:0]         f2h__bid;
   wire [1:0]         f2h__bresp;
   wire               f2h__bvalid;
   wire               f2h__bready;
   wire [7:0]         f2h__arid;
   wire [31:0]        f2h__araddr;
   wire [3:0]         f2h__arlen;
   wire [2:0]         f2h__arsize;
   wire [1:0]         f2h__arburst;
   wire [1:0]         f2h__arlock;
   wire [3:0]         f2h__arcache;
   wire [2:0]         f2h__arprot;
   wire               f2h__arvalid;
   wire               f2h__arready;
   wire [4:0]         f2h__aruser;
   wire [7:0]         f2h__rid;
   wire [63:0]        f2h__rdata;
   wire [1:0]         f2h__rresp;
   wire               f2h__rlast;
   wire               f2h__rvalid;
   wire               f2h__rready;
                wire [31:0]        hps_0_f2h_irq0_irq;
   wire [31:0]        hps_0_f2h_irq1_irq;
                wire               hps_0_h2f_axi_clock_clk;
   wire [11:0]        h2f__awid;
   wire [29:0]        h2f__awaddr;
   wire [3:0]         h2f__awlen;
   wire [2:0]         h2f__awsize;
   wire [1:0]         h2f__awburst;
   wire [1:0]         h2f__awlock;
   wire [3:0]         h2f__awcache;
   wire [2:0]         h2f__awprot;
   wire               h2f__awvalid;
   wire               h2f__awready;
   wire [11:0]        h2f__wid;
   wire [63:0]        h2f__wdata;
   wire [7:0]         h2f__wstrb;
   wire               h2f__wlast;
   wire               h2f__wvalid;
   wire               h2f__wready;
   wire [11:0]        h2f__bid;
   wire [1:0]         h2f__bresp;
   wire               h2f__bvalid;
   wire               h2f__bready;
   wire [11:0]        h2f__arid;
   wire [29:0]        h2f__araddr;
   wire [3:0]         h2f__arlen;
   wire [2:0]         h2f__arsize;
   wire [1:0]         h2f__arburst;
   wire [1:0]         h2f__arlock;
   wire [3:0]         h2f__arcache;
   wire [2:0]         h2f__arprot;
   wire               h2f__arvalid;
   wire               h2f__arready;
   wire [11:0]        h2f__rid;
   wire [63:0]        h2f__rdata;
   wire [1:0]         h2f__rresp;
   wire               h2f__rlast;
   wire               h2f__rvalid;
   wire               h2f__rready;

   wire               hps_0_h2f_lw_axi_clock_clk;
   wire [11:0]        h2f_lw__awid;
   wire [20:0]        h2f_lw__awaddr;
   wire [3:0]         h2f_lw__awlen;
   wire [2:0]         h2f_lw__awsize;
   wire [1:0]         h2f_lw__awburst;
   wire [1:0]         h2f_lw__awlock;
   wire [3:0]         h2f_lw__awcache;
   wire [2:0]         h2f_lw__awprot;
   wire               h2f_lw__awvalid;
   wire               h2f_lw__awready;
   wire [11:0]        h2f_lw__wid;
   wire [31:0]        h2f_lw__wdata;
   wire [3:0]         h2f_lw__wstrb;
   wire               h2f_lw__wlast;
   wire               h2f_lw__wvalid;
   wire               h2f_lw__wready;
   wire [11:0]        h2f_lw__bid;
   wire [1:0]         h2f_lw__bresp;
   wire               h2f_lw__bvalid;
   wire               h2f_lw__bready;
   wire [11:0]        h2f_lw__arid;
   wire [20:0]        h2f_lw__araddr;
   wire [3:0]         h2f_lw__arlen;
   wire [2:0]         h2f_lw__arsize;
   wire [1:0]         h2f_lw__arburst;
   wire [1:0]         h2f_lw__arlock;
   wire [3:0]         h2f_lw__arcache;
   wire [2:0]         h2f_lw__arprot;
   wire               h2f_lw__arvalid;
   wire               h2f_lw__arready;
   wire [11:0]        h2f_lw__rid;
   wire [31:0]        h2f_lw__rdata;
   wire [1:0]         h2f_lw__rresp;
   wire               h2f_lw__rlast;
   wire               h2f_lw__rvalid;
   wire               h2f_lw__rready;
                
   wire               h2f_reset_reset_n;

   hps hps_i(.clk_clk(clk_50),
             .hps_0_f2h_axi_clock_clk( hps_0_f2h_axi_clock_clk),
             .hps_0_f2h_axi_slave_awid( f2h__awid),
             .hps_0_f2h_axi_slave_awaddr( f2h__awaddr),
             .hps_0_f2h_axi_slave_awlen( f2h__awlen),
             .hps_0_f2h_axi_slave_awsize( f2h__awsize),
             .hps_0_f2h_axi_slave_awburst( f2h__awburst),
             .hps_0_f2h_axi_slave_awlock( f2h__awlock),
             .hps_0_f2h_axi_slave_awcache( f2h__awcache),
             .hps_0_f2h_axi_slave_awprot( f2h__awprot),
             .hps_0_f2h_axi_slave_awvalid( f2h__awvalid),
             .hps_0_f2h_axi_slave_awready( f2h__awready),
             .hps_0_f2h_axi_slave_awuser( f2h__awuser),
             .hps_0_f2h_axi_slave_wid( f2h__wid),
             .hps_0_f2h_axi_slave_wdata( f2h__wdata),
             .hps_0_f2h_axi_slave_wstrb( f2h__wstrb),
             .hps_0_f2h_axi_slave_wlast( f2h__wlast),
             .hps_0_f2h_axi_slave_wvalid( f2h__wvalid),
             .hps_0_f2h_axi_slave_wready( f2h__wready),
             .hps_0_f2h_axi_slave_bid( f2h__bid),
             .hps_0_f2h_axi_slave_bresp( f2h__bresp),
             .hps_0_f2h_axi_slave_bvalid( f2h__bvalid),
             .hps_0_f2h_axi_slave_bready( f2h__bready),
             .hps_0_f2h_axi_slave_arid( f2h__arid),
             .hps_0_f2h_axi_slave_araddr( f2h__araddr),
             .hps_0_f2h_axi_slave_arlen( f2h__arlen),
             .hps_0_f2h_axi_slave_arsize( f2h__arsize),
             .hps_0_f2h_axi_slave_arburst( f2h__arburst),
             .hps_0_f2h_axi_slave_arlock( f2h__arlock),
             .hps_0_f2h_axi_slave_arcache( f2h__arcache),
             .hps_0_f2h_axi_slave_arprot( f2h__arprot),
             .hps_0_f2h_axi_slave_arvalid( f2h__arvalid),
             .hps_0_f2h_axi_slave_arready( f2h__arready),
             .hps_0_f2h_axi_slave_aruser( f2h__aruser),
             .hps_0_f2h_axi_slave_rid( f2h__rid),
             .hps_0_f2h_axi_slave_rdata( f2h__rdata),
             .hps_0_f2h_axi_slave_rresp( f2h__rresp),
             .hps_0_f2h_axi_slave_rlast( f2h__rlast),
             .hps_0_f2h_axi_slave_rvalid( f2h__rvalid),
             .hps_0_f2h_axi_slave_rready( f2h__rready),
             .hps_0_f2h_irq0_irq( hps_0_f2h_irq0_irq),
             .hps_0_f2h_irq1_irq( hps_0_f2h_irq1_irq),
             .hps_0_h2f_axi_clock_clk( hps_0_h2f_axi_clock_clk),
             .hps_0_h2f_axi_master_awid( h2f__awid),
             .hps_0_h2f_axi_master_awaddr( h2f__awaddr),
             .hps_0_h2f_axi_master_awlen( h2f__awlen),
             .hps_0_h2f_axi_master_awsize( h2f__awsize),
             .hps_0_h2f_axi_master_awburst( h2f__awburst),
             .hps_0_h2f_axi_master_awlock( h2f__awlock),
             .hps_0_h2f_axi_master_awcache( h2f__awcache),
             .hps_0_h2f_axi_master_awprot( h2f__awprot),
             .hps_0_h2f_axi_master_awvalid( h2f__awvalid),
             .hps_0_h2f_axi_master_awready( h2f__awready),
             .hps_0_h2f_axi_master_wid( h2f__wid),
             .hps_0_h2f_axi_master_wdata( h2f__wdata),
             .hps_0_h2f_axi_master_wstrb( h2f__wstrb),
             .hps_0_h2f_axi_master_wlast( h2f__wlast),
             .hps_0_h2f_axi_master_wvalid( h2f__wvalid),
             .hps_0_h2f_axi_master_wready( h2f__wready),
             .hps_0_h2f_axi_master_bid( h2f__bid),
             .hps_0_h2f_axi_master_bresp( h2f__bresp),
             .hps_0_h2f_axi_master_bvalid( h2f__bvalid),
             .hps_0_h2f_axi_master_bready( h2f__bready),
             .hps_0_h2f_axi_master_arid( h2f__arid),
             .hps_0_h2f_axi_master_araddr( h2f__araddr),
             .hps_0_h2f_axi_master_arlen( h2f__arlen),
             .hps_0_h2f_axi_master_arsize( h2f__arsize),
             .hps_0_h2f_axi_master_arburst( h2f__arburst),
             .hps_0_h2f_axi_master_arlock( h2f__arlock),
             .hps_0_h2f_axi_master_arcache( h2f__arcache),
             .hps_0_h2f_axi_master_arprot( h2f__arprot),
             .hps_0_h2f_axi_master_arvalid( h2f__arvalid),
             .hps_0_h2f_axi_master_arready( h2f__arready),
             .hps_0_h2f_axi_master_rid( h2f__rid),
             .hps_0_h2f_axi_master_rdata( h2f__rdata),
             .hps_0_h2f_axi_master_rresp( h2f__rresp),
             .hps_0_h2f_axi_master_rlast( h2f__rlast),
             .hps_0_h2f_axi_master_rvalid( h2f__rvalid),
             .hps_0_h2f_axi_master_rready( h2f__rready),
             .hps_0_h2f_lw_axi_clock_clk( hps_0_h2f_lw_axi_clock_clk),
             .hps_0_h2f_lw_axi_master_awid( h2f_lw__awid),
             .hps_0_h2f_lw_axi_master_awaddr( h2f_lw__awaddr),
             .hps_0_h2f_lw_axi_master_awlen( h2f_lw__awlen),
             .hps_0_h2f_lw_axi_master_awsize( h2f_lw__awsize),
             .hps_0_h2f_lw_axi_master_awburst( h2f_lw__awburst),
             .hps_0_h2f_lw_axi_master_awlock( h2f_lw__awlock),
             .hps_0_h2f_lw_axi_master_awcache( h2f_lw__awcache),
             .hps_0_h2f_lw_axi_master_awprot( h2f_lw__awprot),
             .hps_0_h2f_lw_axi_master_awvalid( h2f_lw__awvalid),
             .hps_0_h2f_lw_axi_master_awready( h2f_lw__awready),
             .hps_0_h2f_lw_axi_master_wid( h2f_lw__wid),
             .hps_0_h2f_lw_axi_master_wdata( h2f_lw__wdata),
             .hps_0_h2f_lw_axi_master_wstrb( h2f_lw__wstrb),
             .hps_0_h2f_lw_axi_master_wlast( h2f_lw__wlast),
             .hps_0_h2f_lw_axi_master_wvalid( h2f_lw__wvalid),
             .hps_0_h2f_lw_axi_master_wready( h2f_lw__wready),
             .hps_0_h2f_lw_axi_master_bid( h2f_lw__bid),
             .hps_0_h2f_lw_axi_master_bresp( h2f_lw__bresp),
             .hps_0_h2f_lw_axi_master_bvalid( h2f_lw__bvalid),
             .hps_0_h2f_lw_axi_master_bready( h2f_lw__bready),
             .hps_0_h2f_lw_axi_master_arid( h2f_lw__arid),
             .hps_0_h2f_lw_axi_master_araddr( h2f_lw__araddr),
             .hps_0_h2f_lw_axi_master_arlen( h2f_lw__arlen),
             .hps_0_h2f_lw_axi_master_arsize( h2f_lw__arsize),
             .hps_0_h2f_lw_axi_master_arburst( h2f_lw__arburst),
             .hps_0_h2f_lw_axi_master_arlock( h2f_lw__arlock),
             .hps_0_h2f_lw_axi_master_arcache( h2f_lw__arcache),
             .hps_0_h2f_lw_axi_master_arprot( h2f_lw__arprot),
             .hps_0_h2f_lw_axi_master_arvalid( h2f_lw__arvalid),
             .hps_0_h2f_lw_axi_master_arready( h2f_lw__arready),
             .hps_0_h2f_lw_axi_master_rid( h2f_lw__rid),
             .hps_0_h2f_lw_axi_master_rdata( h2f_lw__rdata),
             .hps_0_h2f_lw_axi_master_rresp( h2f_lw__rresp),
             .hps_0_h2f_lw_axi_master_rlast( h2f_lw__rlast),
             .hps_0_h2f_lw_axi_master_rvalid( h2f_lw__rvalid),
             .hps_0_h2f_lw_axi_master_rready( h2f_lw__rready),
             .hps_0_h2f_reset_reset_n( h2f_reset_reset_n), // output
             
             .hps_io_hps_io_emac1_inst_MDIO( hps_enet__mdio),
             .hps_io_hps_io_emac1_inst_MDC( hps_enet__mdc),
                //    inout         hps_enet__int_n; gpio 35
             .hps_io_hps_io_emac1_inst_TX_CLK( hps_enet__gtx_clk),
             .hps_io_hps_io_emac1_inst_TX_CTL( hps_enet__tx_en),
             .hps_io_hps_io_emac1_inst_TXD0( hps_enet__tx_data[0]),
             .hps_io_hps_io_emac1_inst_TXD1( hps_enet__tx_data[1]),
             .hps_io_hps_io_emac1_inst_TXD2( hps_enet__tx_data[2]),
             .hps_io_hps_io_emac1_inst_TXD3( hps_enet__tx_data[3]),
             .hps_io_hps_io_emac1_inst_RXD0( hps_enet__rx_data[0]),
             .hps_io_hps_io_emac1_inst_RXD1( hps_enet__rx_data[1]),
             .hps_io_hps_io_emac1_inst_RXD2( hps_enet__rx_data[2]),
             .hps_io_hps_io_emac1_inst_RXD3( hps_enet__rx_data[3]),
             .hps_io_hps_io_emac1_inst_RX_CTL( hps_enet__rx_dv),
             .hps_io_hps_io_emac1_inst_RX_CLK( hps_enet__rx_clk),

             .hps_io_hps_io_qspi_inst_IO0( hps_flash__data[0]),
             .hps_io_hps_io_qspi_inst_IO1( hps_flash__data[1]),
             .hps_io_hps_io_qspi_inst_IO2( hps_flash__data[2]),
             .hps_io_hps_io_qspi_inst_IO3( hps_flash__data[3]),
             .hps_io_hps_io_qspi_inst_SS0( hps_flash__ncso),
             .hps_io_hps_io_qspi_inst_CLK( hps_flash__dclk),

             .hps_io_hps_io_sdio_inst_CLK( hps_sd__clk),
             .hps_io_hps_io_sdio_inst_CMD( hps_sd__cmd),
             .hps_io_hps_io_sdio_inst_D0( hps_sd__data[0]),
             .hps_io_hps_io_sdio_inst_D1( hps_sd__data[1]),
             .hps_io_hps_io_sdio_inst_D2( hps_sd__data[2]),
             .hps_io_hps_io_sdio_inst_D3( hps_sd__data[3]),
             
             .hps_io_hps_io_usb1_inst_D0( hps_usb__data[0]),
             .hps_io_hps_io_usb1_inst_D1( hps_usb__data[1]),
             .hps_io_hps_io_usb1_inst_D2( hps_usb__data[2]),
             .hps_io_hps_io_usb1_inst_D3( hps_usb__data[3]),
             .hps_io_hps_io_usb1_inst_D4( hps_usb__data[4]),
             .hps_io_hps_io_usb1_inst_D5( hps_usb__data[5]),
             .hps_io_hps_io_usb1_inst_D6( hps_usb__data[6]),
             .hps_io_hps_io_usb1_inst_D7( hps_usb__data[7]),
             .hps_io_hps_io_usb1_inst_CLK( hps_usb__clkout),
             .hps_io_hps_io_usb1_inst_STP( hps_usb__stp),
             .hps_io_hps_io_usb1_inst_DIR( hps_usb__dir),
             .hps_io_hps_io_usb1_inst_NXT( hps_usb__nxt),
             
             .hps_io_hps_io_spim1_inst_CLK( hps_spim__clk),
             .hps_io_hps_io_spim1_inst_MOSI( hps_spim__mosi),
             .hps_io_hps_io_spim1_inst_MISO( hps_spim__miso),
             .hps_io_hps_io_spim1_inst_SS0( hps_spim__ss),

             .hps_io_hps_io_uart0_inst_RX( hps_uart__rx),
             .hps_io_hps_io_uart0_inst_TX( hps_uart__tx),
             
             // inout         hps_i2c_control; // maps to gpio48
             .hps_io_hps_io_i2c0_inst_SDA( hps_i2c1_sdat),
             .hps_io_hps_io_i2c0_inst_SCL( hps_i2c1_sclk),
             .hps_io_hps_io_i2c1_inst_SDA( hps_i2c2_sdat),
             .hps_io_hps_io_i2c1_inst_SCL( hps_i2c2_sclk),

             // inout         hps_gsensor_int; // gpio 61
             // inout         hps_key; // gpio54
             // inout         hps_led; // gpio53
             // inout         hps_ltc_gpio; // gpio40

             .memory_mem_ck( hps_ddr3__ck_p),
             .memory_mem_ck_n( hps_ddr3__ck_n),
             .memory_mem_cke( hps_ddr3__cke),
             .memory_mem_reset_n( hps_ddr3__reset_n),

             .memory_mem_cs_n( hps_ddr3__cs_n),
             .memory_mem_ras_n( hps_ddr3__ras_n),
             .memory_mem_cas_n( hps_ddr3__cas_n),
             .memory_mem_we_n( hps_ddr3__we_n),

             .memory_mem_a( hps_ddr3__addr),
             .memory_mem_ba( hps_ddr3__ba),

             .memory_mem_dm( hps_ddr3__dm),
             .memory_mem_dq( hps_ddr3__dq),
             .memory_mem_dqs( hps_ddr3__dqs_p),
             .memory_mem_dqs_n( hps_ddr3__dqs_n),
             .memory_mem_odt( hps_ddr3__odt),
             .memory_oct_rzqin( hps_ddr3__rzq),
             
             .reset_reset_n( reset_n)
	         );



   assign de1_adc__din = 0;
   assign de1_adc__sclk = 0;

//   inout   de1_aud__adclkrck;
//   inout   de1_aud__bclk;
   assign de1_aud__dacdat = 0;
//   inout   de1_aud__daclrck;
   assign de1_aud__xck = 0;

   assign de1_ddr__clk = 0;
   assign de1_ddr__cke = 0;
   assign de1_ddr__cs_n = 0;
   assign de1_ddr__addr = 0;
   assign  de1_ddr__ba = 0;
//   inout [15:0]  de1_ddr__dq;
   assign de1_ddr__ldqm = 0;
   assign de1_ddr__udqm = 0;
   assign de1_ddr__ras_n = 0;
   assign de1_ddr__cas_n = 0;
   assign de1_ddr__we_n = 0;

   assign de1_fan_ctrl = 0;
   assign de1_fpga_i2c__sclk = 0;
//   inout         de1_fpga_i2c__sdat;
   assign  de1_hex0 = 0;
   assign  de1_hex1 = 0;
   assign  de1_hex2 = 0;
   assign  de1_hex3 = 0;
   assign  de1_hex4 = 0;
   assign  de1_hex5 = 0;

   assign de1_irda__txd = 0;
   assign  de1_leds = 0;

//   inout       de1_ps2_clk;
//   inout       de1_ps2_dat;
//   inout       de1_ps2_b_clk;
//   inout       de1_ps2_b_dat;

   assign de1_td__reset_n = 0;

   assign de1_vga__b = 0;
   assign de1_vga__blank_n = 0;
   assign de1_vga__clk = 0;
   assign de1_vga__g = 0;
   assign de1_vga__hs = 0;
   assign de1_vga__r = 0;
   assign de1_vga__sync_n = 0;
   assign de1_vga__vs = 0;
   
//   assign cam_led_data_pin = 0;
   assign cam_lcd__clock              = 0;
   assign cam_lcd__vsync_n            = 0;
   assign cam_lcd__hsync_n            = 0;
   assign cam_lcd__display_enable     = 0;
   assign cam_lcd__red                = 0;
   assign cam_lcd__green              = 0;
   assign cam_lcd__blue               = 0;
   assign cam_lcd__backlight          = 0;

endmodule
