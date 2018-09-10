module  pll_lcd_0002(

	// interface 'refclk'
	input wire refclk,

	// interface 'reset'
	input wire rst,

	// interface 'outclk0'
	output wire outclk_0,

	// interface 'locked'
	output wire locked
);

	altera_pll #(
		.fractional_vco_multiplier("false"),
		.reference_clock_frequency("50.0 MHz"),
		.operation_mode("direct"),
		.number_of_clocks(1),
		.output_clock_frequency0("9.000000 MHz"),
		.phase_shift0("0 ps"),
		.duty_cycle0(50),
		.output_clock_frequency1("0 MHz"),
		.phase_shift1("0 ps"),
		.duty_cycle1(50),
		.output_clock_frequency2("0 MHz"),
		.phase_shift2("0 ps"),
		.duty_cycle2(50),
		.output_clock_frequency3("0 MHz"),
		.phase_shift3("0 ps"),
		.duty_cycle3(50),
		.output_clock_frequency4("0 MHz"),
		.phase_shift4("0 ps"),
		.duty_cycle4(50),
		.output_clock_frequency5("0 MHz"),
		.phase_shift5("0 ps"),
		.duty_cycle5(50),
		.output_clock_frequency6("0 MHz"),
		.phase_shift6("0 ps"),
		.duty_cycle6(50),
		.output_clock_frequency7("0 MHz"),
		.phase_shift7("0 ps"),
		.duty_cycle7(50),
		.output_clock_frequency8("0 MHz"),
		.phase_shift8("0 ps"),
		.duty_cycle8(50),
		.output_clock_frequency9("0 MHz"),
		.phase_shift9("0 ps"),
		.duty_cycle9(50),
		.output_clock_frequency10("0 MHz"),
		.phase_shift10("0 ps"),
		.duty_cycle10(50),
		.output_clock_frequency11("0 MHz"),
		.phase_shift11("0 ps"),
		.duty_cycle11(50),
		.output_clock_frequency12("0 MHz"),
		.phase_shift12("0 ps"),
		.duty_cycle12(50),
		.output_clock_frequency13("0 MHz"),
		.phase_shift13("0 ps"),
		.duty_cycle13(50),
		.output_clock_frequency14("0 MHz"),
		.phase_shift14("0 ps"),
		.duty_cycle14(50),
		.output_clock_frequency15("0 MHz"),
		.phase_shift15("0 ps"),
		.duty_cycle15(50),
		.output_clock_frequency16("0 MHz"),
		.phase_shift16("0 ps"),
		.duty_cycle16(50),
		.output_clock_frequency17("0 MHz"),
		.phase_shift17("0 ps"),
		.duty_cycle17(50),
		.pll_type("General"),
		.pll_subtype("General")
	) altera_pll_i (
		.rst	(rst),
		.outclk	({outclk_0}),
		.locked	(locked),
		.fboutclk	( ),
		.fbclk	(1'b0),
		.refclk	(refclk)
	);
endmodule
module pll_lcd (
		input  wire  refclk,   //  refclk.clk
		input  wire  rst,      //   reset.reset
		output wire  outclk_0, // outclk0.clk
		output wire  locked    //  locked.export
	);

	pll_lcd_0002 pll_lcd_inst (
		.refclk   (refclk),   //  refclk.clk
		.rst      (rst),      //   reset.reset
		.outclk_0 (outclk_0), // outclk0.clk
		.locked   (locked)    //  locked.export
	);

endmodule
module cam_de1_hps_project ( clk_50, clk2_50, clk3_50, clk4_50, // reset_n,

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
                     de1_keys, de1_switches, de1_leds,
                     
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

                     hps_i2c1_sclk, hps_i2c1_sdat, hps_i2c2_sclk, hps_i2c2_sdat, hps_i2c_control,

                     hps_sd__clk, hps_sd__cmd, hps_sd__data,

                     hps_spim__clk, hps_spim__miso, hps_spim__mosi, hps_spim__ss,

                     hps_uart__rx, hps_uart__tx,

                     hps_usb__clkout, hps_usb__data, hps_usb__dir, hps_usb__nxt, hps_usb__stp,

                     de1_cl_inputs_status__sr_data,
                     de1_cl_inputs_status__left_rotary__direction_pin, de1_cl_inputs_status__left_rotary__transition_pin,
                     de1_cl_inputs_status__right_rotary__direction_pin, de1_cl_inputs_status__right_rotary__transition_pin,

                     de1_cl_inputs_control__sr_clock, de1_cl_inputs_control__sr_shift,
                     de1_cl_led_data_pin,
                     de1_cl_lcd__clock, de1_cl_lcd__vsync_n, de1_cl_lcd__hsync_n, de1_cl_lcd__display_enable, de1_cl_lcd__red, de1_cl_lcd__green, de1_cl_lcd__blue,
                     de1_cl_lcd__backlight

                     );
   input clk_50;
   input clk2_50;
   input clk3_50;
   input clk4_50;
   //input reset_n;

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
   input [3:0]   de1_keys;
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
   
   input        de1_cl_inputs_status__sr_data;
   input        de1_cl_inputs_status__left_rotary__direction_pin;
   input        de1_cl_inputs_status__left_rotary__transition_pin;
   input        de1_cl_inputs_status__right_rotary__direction_pin;
   input        de1_cl_inputs_status__right_rotary__transition_pin;

   output      de1_cl_inputs_control__sr_clock;
   output      de1_cl_inputs_control__sr_shift;
   output      de1_cl_led_data_pin;
   output      de1_cl_lcd__clock             ;
   output      de1_cl_lcd__vsync_n           ;
   output      de1_cl_lcd__hsync_n           ;
   output      de1_cl_lcd__display_enable    ;
   output [5:0] de1_cl_lcd__red               ;
   output [6:0] de1_cl_lcd__green             ;
   output [5:0] de1_cl_lcd__blue              ;
   output       de1_cl_lcd__backlight         ;

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

   inout         hps_i2c1_sclk;
   inout         hps_i2c1_sdat;
   inout         hps_i2c2_sclk;
   inout         hps_i2c2_sdat;
   inout         hps_i2c_control;

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

   wire               reset_n;
   assign reset_n = de1_switches[0];
  
   wire         video_clk;
   wire         video_clk_locked;
   wire         de1_cl_lcd__clock;
   wire         de1_vga_clock;
   wire         de1_vga_reset_n;
   pll_lcd video_clk_gen( .refclk(clk_50), .rst(!reset_n), .outclk_0(video_clk), .locked(video_clk_locked) );
   assign de1_cl_lcd__clock  = !video_clk;
   //assign de1_cl_lcd_reset_n   = reset_n && video_clk_locked;
   assign de1_vga_clock     = !video_clk;
   assign de1_vga_reset_n   = reset_n && video_clk_locked;
   
  
   wire         de1_ps2_in__clk;
   wire         de1_ps2_in__data;
   wire         de1_ps2_out__clk;
   wire         de1_ps2_out__data;
   assign de1_ps2_clk = de1_ps2_out__clk  ? 1'bz: 1'b0;
   assign de1_ps2_dat = de1_ps2_out__data ? 1'bz: 1'b0;
   assign de1_ps2_in__clk  = de1_ps2_clk;
   assign de1_ps2_in__data = de1_ps2_dat;

   wire         de1_ps2b_in__clk;
   wire         de1_ps2b_in__data;
   wire         de1_ps2b_out__clk;
   wire         de1_ps2b_out__data;
   assign de1_ps2b_clk = de1_ps2b_out__clk  ? 1'bz: 1'b0;
   assign de1_ps2b_dat = de1_ps2b_out__data ? 1'bz: 1'b0;
   assign de1_ps2b_in__clk  = de1_ps2b_clk;
   assign de1_ps2b_in__data = de1_ps2b_dat;
   
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


   // reset sources for hps reset are:
   // .hps_0_f2h_cold_reset_req_reset_n      (~hps_cold_reset)   - derived from hps_reset_req[0]
   // .hps_0_f2h_warm_reset_req_reset_n      (~hps_warm_reset)   - derived from hps_reset_req[1]
   // .hps_0_f2h_debug_reset_req_reset_n     (~hps_debug_reset)  - derived from hps_reset_req[2]
   // output of HPS reset is
   // .hps_0_h2f_reset_reset_n               (hps_fpga_reset_n),               //                hps_0_h2f_reset.reset_n
   // input to hps is
   //.reset_reset_n in to hps is (hps_fpga_reset_n),                         //                          reset.reset_n
   

   assign hps_0_h2f_lw_axi_clock_clk = clk_50;
   hps_fpga_debug fpga_0( .de1_vga_clock(de1_vga_clock),
                          .de1_vga_clock__enable(1'b1),
                          .de1_cl_lcd_clock(de1_cl_lcd__clock),
                          .de1_cl_lcd_clock__enable(1'b1),
                          .lw_axi_clock_clk(hps_0_h2f_lw_axi_clock_clk),
                          .lw_axi_clock_clk__enable(1'b1),
                          .clk(hps_0_h2f_lw_axi_clock_clk),
                          .clk__enable(1'b1),
    .reset_n(reset_n),

    .de1_irda_rxd(de1_irda__rxd),
    .de1_switches(de1_switches),
    .de1_keys(de1_keys),
    .de1_vga_reset_n(de1_vga_reset_n),
    .de1_ps2b_in__data(de1_ps2b_in__data),
    .de1_ps2b_in__clk(de1_ps2b_in__clk),
    .de1_ps2_in__data(de1_ps2_in__data),
    .de1_ps2_in__clk(de1_ps2_in__clk),
    .de1_cl_inputs_status__sr_data(de1_cl_inputs_status__sr_data),
    .de1_cl_inputs_status__left_rotary__direction_pin(de1_cl_inputs_status__left_rotary__direction_pin),
    .de1_cl_inputs_status__left_rotary__transition_pin(de1_cl_inputs_status__left_rotary__transition_pin),
    .de1_cl_inputs_status__right_rotary__direction_pin(de1_cl_inputs_status__right_rotary__direction_pin),
    .de1_cl_inputs_status__right_rotary__transition_pin(de1_cl_inputs_status__right_rotary__transition_pin),
    .lw_axi_rready(h2f_lw__rready),
    .lw_axi_bready(h2f_lw__bready),
    .lw_axi_w__valid(h2f_lw__wvalid),
    .lw_axi_w__id(h2f_lw__wid),
    .lw_axi_w__data(h2f_lw__wdata),
    .lw_axi_w__strb(h2f_lw__wstrb),
    .lw_axi_w__last(h2f_lw__wlast),
    .lw_axi_w__user(0),
    .lw_axi_aw__valid(h2f_lw__awvalid),
    .lw_axi_aw__id(h2f_lw__awid),
    .lw_axi_aw__addr(h2f_lw__awaddr),
    .lw_axi_aw__len(h2f_lw__awlen),
    .lw_axi_aw__size(h2f_lw__awsize),
    .lw_axi_aw__burst(h2f_lw__awburst),
    .lw_axi_aw__lock(h2f_lw__awlock),
    .lw_axi_aw__cache(h2f_lw__awcache),
    .lw_axi_aw__prot(h2f_lw__awprot),
    .lw_axi_aw__qos(0),
    .lw_axi_aw__region(0),
    .lw_axi_aw__user(0),
    .lw_axi_ar__valid(h2f_lw__arvalid),
    .lw_axi_ar__id(h2f_lw__arid),
    .lw_axi_ar__addr(h2f_lw__araddr),
    .lw_axi_ar__len(h2f_lw__arlen),
    .lw_axi_ar__size(h2f_lw__arsize),
    .lw_axi_ar__burst(h2f_lw__arburst),
    .lw_axi_ar__lock(h2f_lw__arlock),
    .lw_axi_ar__cache(h2f_lw__arcache),
    .lw_axi_ar__prot(h2f_lw__arprot),
    .lw_axi_ar__qos(0),
    .lw_axi_ar__region(0),
    .lw_axi_ar__user(0),

    .de1_vga__vs(de1_vga__vs),
    .de1_vga__hs(de1_vga__hs),
    .de1_vga__blank_n(de1_vga__blank_n),
    .de1_vga__sync_n(de1_vga__sync_n),
    .de1_vga__red(de1_vga__r),
    .de1_vga__green(de1_vga__g),
    .de1_vga__blue(de1_vga__b),
    .de1_cl_lcd__vsync_n(de1_cl_lcd__vsync_n),
    .de1_cl_lcd__hsync_n(de1_cl_lcd__hsync_n),
    .de1_cl_lcd__display_enable(de1_cl_lcd__display_enable),
    .de1_cl_lcd__red(de1_cl_lcd__red),
    .de1_cl_lcd__green(de1_cl_lcd__green),
    .de1_cl_lcd__blue(de1_cl_lcd__blue),
    .de1_cl_lcd__backlight(de1_cl_lcd__backlight),
    .de1_irda_txd(de1_irda__txd),
    .de1_ps2b_out__data(de1_ps2b_out__data),
    .de1_ps2b_out__clk(de1_ps2b_out__clk),
    .de1_ps2_out__data(de1_ps2_out__data),
    .de1_ps2_out__clk(de1_ps2_out__clk),
    .de1_leds__leds(de1_leds),
    .de1_leds__h0(de1_hex0),
    .de1_leds__h1(de1_hex1),
    .de1_leds__h2(de1_hex2),
    .de1_leds__h3(de1_hex3),
    .de1_leds__h4(de1_hex4),
    .de1_leds__h5(de1_hex5),
    .de1_cl_led_data_pin(de1_cl_led_data_pin),
    .de1_cl_inputs_control__sr_clock(de1_cl_inputs_control__sr_clock),
    .de1_cl_inputs_control__sr_shift(de1_cl_inputs_control__sr_shift),
    .lw_axi_r__valid(h2f_lw__rvalid),
    .lw_axi_r__id(h2f_lw__rid),
    .lw_axi_r__data(h2f_lw__rdata),
    .lw_axi_r__resp(h2f_lw__rresp),
    .lw_axi_r__last(h2f_lw__rlast),
    .lw_axi_r__user(),
    .lw_axi_b__valid(h2f_lw__bvalid),
    .lw_axi_b__id(h2f_lw__bid),
    .lw_axi_b__resp(h2f_lw__bresp),
    .lw_axi_b__user(),
    .lw_axi_wready(h2f_lw__wready),
    .lw_axi_awready(h2f_lw__awready),
    .lw_axi_arready(h2f_lw__arready)
);

endmodule
