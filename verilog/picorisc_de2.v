//a Note: created by CDL 1.4 - do not hand edit without recognizing it will be out of sync with the source
// Output mode 0 (VMOD=1, standard verilog=0)
// Verilog option comb reg suffix '__var'
// Verilog option include_displays 0
// Verilog option include_assertions 1
// Verilog option sv_assertions 0
// Verilog option assert delay string '<NULL>'
// Verilog option include_coverage 0
// Verilog option clock_gate_module_instance_type 'banana'
// Verilog option clock_gate_module_instance_extra_ports ''
// Verilog option use_always_at_star 1
// Verilog option clocks_must_have_enables 1

//a Module picorisc_de2
module picorisc_de2
(
    de2_sdr_clk,
    de2_sdr_clk__enable,
    de2_vga_clk,
    de2_vga_clk__enable,
    de2_td_clk,
    de2_td_clk__enable,
    de2_audio_bclk,
    de2_audio_bclk__enable,
    clk,
    clk__enable,

    de2_gpio_in__gpio_0,
    de2_gpio_in__gpio_1,
    de2_flash_in__dq,
    de2_sram_in__dq,
    de2_sdr_in__dq,
    de2_vga_reset_n,
    de2_uart_in__rxd,
    de2_uart_in__rts,
    de2_td__hs,
    de2_td__vs,
    de2_td__data,
    de2_ps2_in__data,
    de2_ps2_in__clk,
    de2_inputs__keys,
    de2_inputs__switches,
    de2_inputs__irda_rxd,
    de2_i2c_in__sclk,
    de2_i2c_in__sdat,
    de2_audio_adc__data,
    de2_audio_adc__lrc,
    reset_n,

    de2_vga__vs,
    de2_vga__hs,
    de2_vga__blank_n,
    de2_vga__sync_n,
    de2_vga__red,
    de2_vga__green,
    de2_vga__blue,
    de2_ps2_out__data,
    de2_ps2_out__clk,
    de2_flash_out__reset_n,
    de2_flash_out__ce_n,
    de2_flash_out__oe_n,
    de2_flash_out__we_n,
    de2_flash_out__addr,
    de2_flash_out__dq,
    de2_flash_out__dqe,
    de2_sram_out__ce_n,
    de2_sram_out__oe_n,
    de2_sram_out__we_n,
    de2_sram_out__be_n,
    de2_sram_out__addr,
    de2_sram_out__dq,
    de2_sram_out__dqe,
    de2_sdr_out__cke,
    de2_sdr_out__cs_n,
    de2_sdr_out__ras_n,
    de2_sdr_out__cas_n,
    de2_sdr_out__we_n,
    de2_sdr_out__ba,
    de2_sdr_out__addr,
    de2_sdr_out__dq,
    de2_sdr_out__dqm,
    de2_sdr_out__dqe,
    de2_uart_out__txd,
    de2_uart_out__cts,
    de2_td_reset_n,
    de2_lcd__backlight,
    de2_lcd__on,
    de2_lcd__rs,
    de2_lcd__read_write,
    de2_lcd__enable,
    de2_lcd__data,
    de2_leds__ledg,
    de2_leds__ledr,
    de2_leds__h0,
    de2_leds__h1,
    de2_leds__h2,
    de2_leds__h3,
    de2_leds__h4,
    de2_leds__h5,
    de2_leds__h6,
    de2_leds__h7,
    de2_i2c_out__sclk,
    de2_i2c_out__sdat,
    de2_audio_dac__data,
    de2_audio_dac__lrc
);

    //b Clocks
    input de2_sdr_clk;
    input de2_sdr_clk__enable;
    input de2_vga_clk;
    input de2_vga_clk__enable;
    input de2_td_clk;
    input de2_td_clk__enable;
    input de2_audio_bclk;
    input de2_audio_bclk__enable;
    input clk;
    input clk__enable;

    //b Inputs
    input [17:0]de2_gpio_in__gpio_0;
    input [17:0]de2_gpio_in__gpio_1;
    input [7:0]de2_flash_in__dq;
    input [15:0]de2_sram_in__dq;
    input [15:0]de2_sdr_in__dq;
    input de2_vga_reset_n;
    input de2_uart_in__rxd;
    input de2_uart_in__rts;
    input de2_td__hs;
    input de2_td__vs;
    input [7:0]de2_td__data;
    input de2_ps2_in__data;
    input de2_ps2_in__clk;
    input [3:0]de2_inputs__keys;
    input [17:0]de2_inputs__switches;
    input de2_inputs__irda_rxd;
    input de2_i2c_in__sclk;
    input de2_i2c_in__sdat;
    input de2_audio_adc__data;
    input de2_audio_adc__lrc;
    input reset_n;

    //b Outputs
    output de2_vga__vs;
    output de2_vga__hs;
    output de2_vga__blank_n;
    output de2_vga__sync_n;
    output [9:0]de2_vga__red;
    output [9:0]de2_vga__green;
    output [9:0]de2_vga__blue;
    output de2_ps2_out__data;
    output de2_ps2_out__clk;
    output de2_flash_out__reset_n;
    output de2_flash_out__ce_n;
    output de2_flash_out__oe_n;
    output de2_flash_out__we_n;
    output [21:0]de2_flash_out__addr;
    output [7:0]de2_flash_out__dq;
    output de2_flash_out__dqe;
    output de2_sram_out__ce_n;
    output de2_sram_out__oe_n;
    output de2_sram_out__we_n;
    output [1:0]de2_sram_out__be_n;
    output [11:0]de2_sram_out__addr;
    output [15:0]de2_sram_out__dq;
    output de2_sram_out__dqe;
    output de2_sdr_out__cke;
    output de2_sdr_out__cs_n;
    output de2_sdr_out__ras_n;
    output de2_sdr_out__cas_n;
    output de2_sdr_out__we_n;
    output [1:0]de2_sdr_out__ba;
    output [11:0]de2_sdr_out__addr;
    output [15:0]de2_sdr_out__dq;
    output [1:0]de2_sdr_out__dqm;
    output de2_sdr_out__dqe;
    output de2_uart_out__txd;
    output de2_uart_out__cts;
    output de2_td_reset_n;
    output de2_lcd__backlight;
    output de2_lcd__on;
    output de2_lcd__rs;
    output de2_lcd__read_write;
    output de2_lcd__enable;
    output [7:0]de2_lcd__data;
    output [9:0]de2_leds__ledg;
    output [17:0]de2_leds__ledr;
    output [6:0]de2_leds__h0;
    output [6:0]de2_leds__h1;
    output [6:0]de2_leds__h2;
    output [6:0]de2_leds__h3;
    output [6:0]de2_leds__h4;
    output [6:0]de2_leds__h5;
    output [6:0]de2_leds__h6;
    output [6:0]de2_leds__h7;
    output de2_i2c_out__sclk;
    output de2_i2c_out__sdat;
    output de2_audio_dac__data;
    output de2_audio_dac__lrc;

// output components here

    //b Output combinatorials
    reg de2_flash_out__reset_n;
    reg de2_flash_out__ce_n;
    reg de2_flash_out__oe_n;
    reg de2_flash_out__we_n;
    reg [21:0]de2_flash_out__addr;
    reg [7:0]de2_flash_out__dq;
    reg de2_flash_out__dqe;
    reg de2_sram_out__ce_n;
    reg de2_sram_out__oe_n;
    reg de2_sram_out__we_n;
    reg [1:0]de2_sram_out__be_n;
    reg [11:0]de2_sram_out__addr;
    reg [15:0]de2_sram_out__dq;
    reg de2_sram_out__dqe;
    reg de2_sdr_out__cke;
    reg de2_sdr_out__cs_n;
    reg de2_sdr_out__ras_n;
    reg de2_sdr_out__cas_n;
    reg de2_sdr_out__we_n;
    reg [1:0]de2_sdr_out__ba;
    reg [11:0]de2_sdr_out__addr;
    reg [15:0]de2_sdr_out__dq;
    reg [1:0]de2_sdr_out__dqm;
    reg de2_sdr_out__dqe;
    reg de2_uart_out__txd;
    reg de2_uart_out__cts;
    reg de2_td_reset_n;
    reg de2_lcd__backlight;
    reg de2_lcd__on;
    reg de2_lcd__rs;
    reg de2_lcd__read_write;
    reg de2_lcd__enable;
    reg [7:0]de2_lcd__data;
    reg [9:0]de2_leds__ledg;
    reg [17:0]de2_leds__ledr;
    reg [6:0]de2_leds__h0;
    reg [6:0]de2_leds__h1;
    reg [6:0]de2_leds__h2;
    reg [6:0]de2_leds__h3;
    reg [6:0]de2_leds__h4;
    reg [6:0]de2_leds__h5;
    reg [6:0]de2_leds__h6;
    reg [6:0]de2_leds__h7;
    reg de2_i2c_out__sclk;
    reg de2_i2c_out__sdat;
    reg de2_audio_dac__data;
    reg de2_audio_dac__lrc;

    //b Output nets

    //b Internal and output registers
    reg [31:0]vga_counters[3:0];
    reg [3:0]vga_seconds_sr;
    reg [11:0]vga_hsync_counter;
    reg [3:0]vga_vsync_counter;
    reg ps2_in__data;
    reg ps2_in__clk;
    reg [31:0]counter;
    reg [7:0]seconds;
    reg divider_reset;
    reg [31:0]divider;
    reg apb_processor_completed;
    reg apb_processor_request__valid;
    reg [15:0]apb_processor_request__address;
    reg csr_response_r__acknowledge;
    reg csr_response_r__read_data_valid;
    reg csr_response_r__read_data_error;
    reg [31:0]csr_response_r__read_data;
    reg [15:0]dprintf_req__valid;
    reg [15:0]dprintf_req__address[15:0];
    reg [63:0]dprintf_req__data_0[15:0];
    reg [63:0]dprintf_req__data_1[15:0];
    reg [63:0]dprintf_req__data_2[15:0];
    reg [63:0]dprintf_req__data_3[15:0];
    reg de2_vga__vs;
    reg de2_vga__hs;
    reg de2_vga__blank_n;
    reg de2_vga__sync_n;
    reg [9:0]de2_vga__red;
    reg [9:0]de2_vga__green;
    reg [9:0]de2_vga__blue;
    reg de2_ps2_out__data;
    reg de2_ps2_out__clk;

    //b Internal combinatorials
    reg fb_sram_access_resp__ack;
    reg fb_sram_access_resp__valid;
    reg [3:0]fb_sram_access_resp__id;
    reg [63:0]fb_sram_access_resp__data;
    reg rv_sram_access_resp__ack;
    reg rv_sram_access_resp__valid;
    reg [3:0]rv_sram_access_resp__id;
    reg [63:0]rv_sram_access_resp__data;
    reg tt_display_sram_access_req__valid;
    reg [3:0]tt_display_sram_access_req__id;
    reg tt_display_sram_access_req__read_not_write;
    reg [7:0]tt_display_sram_access_req__byte_enable;
    reg [31:0]tt_display_sram_access_req__address;
    reg [63:0]tt_display_sram_access_req__write_data;
    reg csr_response__acknowledge;
    reg csr_response__read_data_valid;
    reg csr_response__read_data_error;
    reg [31:0]csr_response__read_data;
        //   Ack for dprintf request from APB target
    reg apb_dprintf_ack;
    reg timer_control__reset_counter;
    reg timer_control__enable_counter;
    reg timer_control__block_writes;
    reg [7:0]timer_control__bonus_subfraction_numer;
    reg [7:0]timer_control__bonus_subfraction_denom;
    reg [3:0]timer_control__fractional_adder;
    reg [7:0]timer_control__integer_adder;
    reg [31:0]proc_apb_response__prdata;
    reg proc_apb_response__pready;
    reg proc_apb_response__perr;
    reg [31:0]apb_response__prdata;
    reg apb_response__pready;
    reg apb_response__perr;
    reg [31:0]ps2_apb_request__paddr;
    reg ps2_apb_request__penable;
    reg ps2_apb_request__psel;
    reg ps2_apb_request__pwrite;
    reg [31:0]ps2_apb_request__pwdata;
    reg [31:0]fb_sram_apb_request__paddr;
    reg fb_sram_apb_request__penable;
    reg fb_sram_apb_request__psel;
    reg fb_sram_apb_request__pwrite;
    reg [31:0]fb_sram_apb_request__pwdata;
    reg [31:0]rv_sram_apb_request__paddr;
    reg rv_sram_apb_request__penable;
    reg rv_sram_apb_request__psel;
    reg rv_sram_apb_request__pwrite;
    reg [31:0]rv_sram_apb_request__pwdata;
    reg [31:0]csr_apb_request__paddr;
    reg csr_apb_request__penable;
    reg csr_apb_request__psel;
    reg csr_apb_request__pwrite;
    reg [31:0]csr_apb_request__pwdata;
    reg [31:0]dprintf_apb_request__paddr;
    reg dprintf_apb_request__penable;
    reg dprintf_apb_request__psel;
    reg dprintf_apb_request__pwrite;
    reg [31:0]dprintf_apb_request__pwdata;
    reg [31:0]timer_apb_request__paddr;
    reg timer_apb_request__penable;
    reg timer_apb_request__psel;
    reg timer_apb_request__pwrite;
    reg [31:0]timer_apb_request__pwdata;
    reg [3:0]apb_request_sel;
    reg [31:0]apb_request__paddr;
    reg apb_request__penable;
    reg apb_request__psel;
    reg apb_request__pwrite;
    reg [31:0]apb_request__pwdata;

    //b Internal nets
    wire [6:0]de2_hex_leds[5:0];
    wire ps2_out__data;
    wire ps2_out__clk;
    wire fb_sram_access_req__valid;
    wire [3:0]fb_sram_access_req__id;
    wire fb_sram_access_req__read_not_write;
    wire [7:0]fb_sram_access_req__byte_enable;
    wire [31:0]fb_sram_access_req__address;
    wire [63:0]fb_sram_access_req__write_data;
    wire rv_sram_access_req__valid;
    wire [3:0]rv_sram_access_req__id;
    wire rv_sram_access_req__read_not_write;
    wire [7:0]rv_sram_access_req__byte_enable;
    wire [31:0]rv_sram_access_req__address;
    wire [63:0]rv_sram_access_req__write_data;
    wire [39:0]apb_rom_data;
    wire apb_rom_request__enable;
    wire [15:0]apb_rom_request__address;
    wire apb_processor_response__acknowledge;
    wire apb_processor_response__rom_busy;
    wire vga_video_bus__vsync;
    wire vga_video_bus__hsync;
    wire vga_video_bus__display_enable;
    wire [7:0]vga_video_bus__red;
    wire [7:0]vga_video_bus__green;
    wire [7:0]vga_video_bus__blue;
    wire timeout_csr_response__acknowledge;
    wire timeout_csr_response__read_data_valid;
    wire timeout_csr_response__read_data_error;
    wire [31:0]timeout_csr_response__read_data;
    wire tt_vga_framebuffer_csr_response__acknowledge;
    wire tt_vga_framebuffer_csr_response__read_data_valid;
    wire tt_vga_framebuffer_csr_response__read_data_error;
    wire [31:0]tt_vga_framebuffer_csr_response__read_data;
    wire csr_request__valid;
    wire csr_request__read_not_write;
    wire [15:0]csr_request__select;
    wire [15:0]csr_request__address;
    wire [31:0]csr_request__data;
    wire dprintf_byte__valid;
    wire [7:0]dprintf_byte__data;
    wire [15:0]dprintf_byte__address;
        //   Dprintf request after multiplexing
    wire [14:0]mux_dprintf_req__valid;
    wire [15:0]mux_dprintf_req__address[14:0];
    wire [63:0]mux_dprintf_req__data_0[14:0];
    wire [63:0]mux_dprintf_req__data_1[14:0];
    wire [63:0]mux_dprintf_req__data_2[14:0];
    wire [63:0]mux_dprintf_req__data_3[14:0];
        //   Ack for dprintf request after multiplexing
    wire [14:0]mux_dprintf_ack;
    wire [15:0]dprintf_ack;
        //   Dprintf request from APB target
    wire apb_dprintf_req__valid;
    wire [15:0]apb_dprintf_req__address;
    wire [63:0]apb_dprintf_req__data_0;
    wire [63:0]apb_dprintf_req__data_1;
    wire [63:0]apb_dprintf_req__data_2;
    wire [63:0]apb_dprintf_req__data_3;
    wire [31:0]fb_sram_ctrl;
    wire [31:0]rv_sram_ctrl;
    wire timer_value__irq;
    wire [63:0]timer_value__value;
    wire [31:0]ps2_apb_response__prdata;
    wire ps2_apb_response__pready;
    wire ps2_apb_response__perr;
    wire [31:0]fb_sram_apb_response__prdata;
    wire fb_sram_apb_response__pready;
    wire fb_sram_apb_response__perr;
    wire [31:0]rv_sram_apb_response__prdata;
    wire rv_sram_apb_response__pready;
    wire rv_sram_apb_response__perr;
    wire [31:0]csr_apb_response__prdata;
    wire csr_apb_response__pready;
    wire csr_apb_response__perr;
    wire [31:0]dprintf_apb_response__prdata;
    wire dprintf_apb_response__pready;
    wire dprintf_apb_response__perr;
    wire [31:0]timer_apb_response__prdata;
    wire timer_apb_response__pready;
    wire timer_apb_response__perr;
    wire [31:0]proc_apb_request__paddr;
    wire proc_apb_request__penable;
    wire proc_apb_request__psel;
    wire proc_apb_request__pwrite;
    wire [31:0]proc_apb_request__pwdata;

    //b Clock gating module instances
    //b Module instances
    apb_processor apbp(
        .clk(clk),
        .clk__enable(1'b1),
        .rom_data(apb_rom_data),
        .apb_response__perr(proc_apb_response__perr),
        .apb_response__pready(proc_apb_response__pready),
        .apb_response__prdata(proc_apb_response__prdata),
        .apb_processor_request__address(apb_processor_request__address),
        .apb_processor_request__valid(apb_processor_request__valid),
        .reset_n(reset_n),
        .rom_request__address(            apb_rom_request__address),
        .rom_request__enable(            apb_rom_request__enable),
        .apb_request__pwdata(            proc_apb_request__pwdata),
        .apb_request__pwrite(            proc_apb_request__pwrite),
        .apb_request__psel(            proc_apb_request__psel),
        .apb_request__penable(            proc_apb_request__penable),
        .apb_request__paddr(            proc_apb_request__paddr),
        .apb_processor_response__rom_busy(            apb_processor_response__rom_busy),
        .apb_processor_response__acknowledge(            apb_processor_response__acknowledge)         );
    se_sram_srw_256x40 apb_rom(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(40'h0),
        .read_not_write(1'h1),
        .address(apb_rom_request__address[7:0]),
        .select(apb_rom_request__enable),
        .data_out(            apb_rom_data)         );
    dprintf_4_mux tdm_n(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[14]),
        .req_b__data_3(dprintf_req__data_3[15]),
        .req_b__data_2(dprintf_req__data_2[15]),
        .req_b__data_1(dprintf_req__data_1[15]),
        .req_b__data_0(dprintf_req__data_0[15]),
        .req_b__address(dprintf_req__address[15]),
        .req_b__valid(dprintf_req__valid[15]),
        .req_a__data_3(dprintf_req__data_3[14]),
        .req_a__data_2(dprintf_req__data_2[14]),
        .req_a__data_1(dprintf_req__data_1[14]),
        .req_a__data_0(dprintf_req__data_0[14]),
        .req_a__address(dprintf_req__address[14]),
        .req_a__valid(dprintf_req__valid[14]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[14]),
        .req__data_2(            mux_dprintf_req__data_2[14]),
        .req__data_1(            mux_dprintf_req__data_1[14]),
        .req__data_0(            mux_dprintf_req__data_0[14]),
        .req__address(            mux_dprintf_req__address[14]),
        .req__valid(            mux_dprintf_req__valid[14]),
        .ack_b(            dprintf_ack[15]),
        .ack_a(            dprintf_ack[14])         );
    dprintf_4_mux tdm___0(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[0]),
        .req_b__data_3(mux_dprintf_req__data_3[1]),
        .req_b__data_2(mux_dprintf_req__data_2[1]),
        .req_b__data_1(mux_dprintf_req__data_1[1]),
        .req_b__data_0(mux_dprintf_req__data_0[1]),
        .req_b__address(mux_dprintf_req__address[1]),
        .req_b__valid(mux_dprintf_req__valid[1]),
        .req_a__data_3(dprintf_req__data_3[0]),
        .req_a__data_2(dprintf_req__data_2[0]),
        .req_a__data_1(dprintf_req__data_1[0]),
        .req_a__data_0(dprintf_req__data_0[0]),
        .req_a__address(dprintf_req__address[0]),
        .req_a__valid(dprintf_req__valid[0]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[0]),
        .req__data_2(            mux_dprintf_req__data_2[0]),
        .req__data_1(            mux_dprintf_req__data_1[0]),
        .req__data_0(            mux_dprintf_req__data_0[0]),
        .req__address(            mux_dprintf_req__address[0]),
        .req__valid(            mux_dprintf_req__valid[0]),
        .ack_b(            mux_dprintf_ack[1]),
        .ack_a(            dprintf_ack[0])         );
    dprintf_4_mux tdm___1(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[1]),
        .req_b__data_3(mux_dprintf_req__data_3[2]),
        .req_b__data_2(mux_dprintf_req__data_2[2]),
        .req_b__data_1(mux_dprintf_req__data_1[2]),
        .req_b__data_0(mux_dprintf_req__data_0[2]),
        .req_b__address(mux_dprintf_req__address[2]),
        .req_b__valid(mux_dprintf_req__valid[2]),
        .req_a__data_3(dprintf_req__data_3[1]),
        .req_a__data_2(dprintf_req__data_2[1]),
        .req_a__data_1(dprintf_req__data_1[1]),
        .req_a__data_0(dprintf_req__data_0[1]),
        .req_a__address(dprintf_req__address[1]),
        .req_a__valid(dprintf_req__valid[1]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[1]),
        .req__data_2(            mux_dprintf_req__data_2[1]),
        .req__data_1(            mux_dprintf_req__data_1[1]),
        .req__data_0(            mux_dprintf_req__data_0[1]),
        .req__address(            mux_dprintf_req__address[1]),
        .req__valid(            mux_dprintf_req__valid[1]),
        .ack_b(            mux_dprintf_ack[2]),
        .ack_a(            dprintf_ack[1])         );
    dprintf_4_mux tdm___2(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[2]),
        .req_b__data_3(mux_dprintf_req__data_3[3]),
        .req_b__data_2(mux_dprintf_req__data_2[3]),
        .req_b__data_1(mux_dprintf_req__data_1[3]),
        .req_b__data_0(mux_dprintf_req__data_0[3]),
        .req_b__address(mux_dprintf_req__address[3]),
        .req_b__valid(mux_dprintf_req__valid[3]),
        .req_a__data_3(dprintf_req__data_3[2]),
        .req_a__data_2(dprintf_req__data_2[2]),
        .req_a__data_1(dprintf_req__data_1[2]),
        .req_a__data_0(dprintf_req__data_0[2]),
        .req_a__address(dprintf_req__address[2]),
        .req_a__valid(dprintf_req__valid[2]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[2]),
        .req__data_2(            mux_dprintf_req__data_2[2]),
        .req__data_1(            mux_dprintf_req__data_1[2]),
        .req__data_0(            mux_dprintf_req__data_0[2]),
        .req__address(            mux_dprintf_req__address[2]),
        .req__valid(            mux_dprintf_req__valid[2]),
        .ack_b(            mux_dprintf_ack[3]),
        .ack_a(            dprintf_ack[2])         );
    dprintf_4_mux tdm___3(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[3]),
        .req_b__data_3(mux_dprintf_req__data_3[4]),
        .req_b__data_2(mux_dprintf_req__data_2[4]),
        .req_b__data_1(mux_dprintf_req__data_1[4]),
        .req_b__data_0(mux_dprintf_req__data_0[4]),
        .req_b__address(mux_dprintf_req__address[4]),
        .req_b__valid(mux_dprintf_req__valid[4]),
        .req_a__data_3(dprintf_req__data_3[3]),
        .req_a__data_2(dprintf_req__data_2[3]),
        .req_a__data_1(dprintf_req__data_1[3]),
        .req_a__data_0(dprintf_req__data_0[3]),
        .req_a__address(dprintf_req__address[3]),
        .req_a__valid(dprintf_req__valid[3]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[3]),
        .req__data_2(            mux_dprintf_req__data_2[3]),
        .req__data_1(            mux_dprintf_req__data_1[3]),
        .req__data_0(            mux_dprintf_req__data_0[3]),
        .req__address(            mux_dprintf_req__address[3]),
        .req__valid(            mux_dprintf_req__valid[3]),
        .ack_b(            mux_dprintf_ack[4]),
        .ack_a(            dprintf_ack[3])         );
    dprintf_4_mux tdm___4(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[4]),
        .req_b__data_3(mux_dprintf_req__data_3[5]),
        .req_b__data_2(mux_dprintf_req__data_2[5]),
        .req_b__data_1(mux_dprintf_req__data_1[5]),
        .req_b__data_0(mux_dprintf_req__data_0[5]),
        .req_b__address(mux_dprintf_req__address[5]),
        .req_b__valid(mux_dprintf_req__valid[5]),
        .req_a__data_3(dprintf_req__data_3[4]),
        .req_a__data_2(dprintf_req__data_2[4]),
        .req_a__data_1(dprintf_req__data_1[4]),
        .req_a__data_0(dprintf_req__data_0[4]),
        .req_a__address(dprintf_req__address[4]),
        .req_a__valid(dprintf_req__valid[4]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[4]),
        .req__data_2(            mux_dprintf_req__data_2[4]),
        .req__data_1(            mux_dprintf_req__data_1[4]),
        .req__data_0(            mux_dprintf_req__data_0[4]),
        .req__address(            mux_dprintf_req__address[4]),
        .req__valid(            mux_dprintf_req__valid[4]),
        .ack_b(            mux_dprintf_ack[5]),
        .ack_a(            dprintf_ack[4])         );
    dprintf_4_mux tdm___5(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[5]),
        .req_b__data_3(mux_dprintf_req__data_3[6]),
        .req_b__data_2(mux_dprintf_req__data_2[6]),
        .req_b__data_1(mux_dprintf_req__data_1[6]),
        .req_b__data_0(mux_dprintf_req__data_0[6]),
        .req_b__address(mux_dprintf_req__address[6]),
        .req_b__valid(mux_dprintf_req__valid[6]),
        .req_a__data_3(dprintf_req__data_3[5]),
        .req_a__data_2(dprintf_req__data_2[5]),
        .req_a__data_1(dprintf_req__data_1[5]),
        .req_a__data_0(dprintf_req__data_0[5]),
        .req_a__address(dprintf_req__address[5]),
        .req_a__valid(dprintf_req__valid[5]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[5]),
        .req__data_2(            mux_dprintf_req__data_2[5]),
        .req__data_1(            mux_dprintf_req__data_1[5]),
        .req__data_0(            mux_dprintf_req__data_0[5]),
        .req__address(            mux_dprintf_req__address[5]),
        .req__valid(            mux_dprintf_req__valid[5]),
        .ack_b(            mux_dprintf_ack[6]),
        .ack_a(            dprintf_ack[5])         );
    dprintf_4_mux tdm___6(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[6]),
        .req_b__data_3(mux_dprintf_req__data_3[7]),
        .req_b__data_2(mux_dprintf_req__data_2[7]),
        .req_b__data_1(mux_dprintf_req__data_1[7]),
        .req_b__data_0(mux_dprintf_req__data_0[7]),
        .req_b__address(mux_dprintf_req__address[7]),
        .req_b__valid(mux_dprintf_req__valid[7]),
        .req_a__data_3(dprintf_req__data_3[6]),
        .req_a__data_2(dprintf_req__data_2[6]),
        .req_a__data_1(dprintf_req__data_1[6]),
        .req_a__data_0(dprintf_req__data_0[6]),
        .req_a__address(dprintf_req__address[6]),
        .req_a__valid(dprintf_req__valid[6]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[6]),
        .req__data_2(            mux_dprintf_req__data_2[6]),
        .req__data_1(            mux_dprintf_req__data_1[6]),
        .req__data_0(            mux_dprintf_req__data_0[6]),
        .req__address(            mux_dprintf_req__address[6]),
        .req__valid(            mux_dprintf_req__valid[6]),
        .ack_b(            mux_dprintf_ack[7]),
        .ack_a(            dprintf_ack[6])         );
    dprintf_4_mux tdm___7(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[7]),
        .req_b__data_3(mux_dprintf_req__data_3[8]),
        .req_b__data_2(mux_dprintf_req__data_2[8]),
        .req_b__data_1(mux_dprintf_req__data_1[8]),
        .req_b__data_0(mux_dprintf_req__data_0[8]),
        .req_b__address(mux_dprintf_req__address[8]),
        .req_b__valid(mux_dprintf_req__valid[8]),
        .req_a__data_3(dprintf_req__data_3[7]),
        .req_a__data_2(dprintf_req__data_2[7]),
        .req_a__data_1(dprintf_req__data_1[7]),
        .req_a__data_0(dprintf_req__data_0[7]),
        .req_a__address(dprintf_req__address[7]),
        .req_a__valid(dprintf_req__valid[7]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[7]),
        .req__data_2(            mux_dprintf_req__data_2[7]),
        .req__data_1(            mux_dprintf_req__data_1[7]),
        .req__data_0(            mux_dprintf_req__data_0[7]),
        .req__address(            mux_dprintf_req__address[7]),
        .req__valid(            mux_dprintf_req__valid[7]),
        .ack_b(            mux_dprintf_ack[8]),
        .ack_a(            dprintf_ack[7])         );
    dprintf_4_mux tdm___8(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[8]),
        .req_b__data_3(mux_dprintf_req__data_3[9]),
        .req_b__data_2(mux_dprintf_req__data_2[9]),
        .req_b__data_1(mux_dprintf_req__data_1[9]),
        .req_b__data_0(mux_dprintf_req__data_0[9]),
        .req_b__address(mux_dprintf_req__address[9]),
        .req_b__valid(mux_dprintf_req__valid[9]),
        .req_a__data_3(dprintf_req__data_3[8]),
        .req_a__data_2(dprintf_req__data_2[8]),
        .req_a__data_1(dprintf_req__data_1[8]),
        .req_a__data_0(dprintf_req__data_0[8]),
        .req_a__address(dprintf_req__address[8]),
        .req_a__valid(dprintf_req__valid[8]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[8]),
        .req__data_2(            mux_dprintf_req__data_2[8]),
        .req__data_1(            mux_dprintf_req__data_1[8]),
        .req__data_0(            mux_dprintf_req__data_0[8]),
        .req__address(            mux_dprintf_req__address[8]),
        .req__valid(            mux_dprintf_req__valid[8]),
        .ack_b(            mux_dprintf_ack[9]),
        .ack_a(            dprintf_ack[8])         );
    dprintf_4_mux tdm___9(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[9]),
        .req_b__data_3(mux_dprintf_req__data_3[10]),
        .req_b__data_2(mux_dprintf_req__data_2[10]),
        .req_b__data_1(mux_dprintf_req__data_1[10]),
        .req_b__data_0(mux_dprintf_req__data_0[10]),
        .req_b__address(mux_dprintf_req__address[10]),
        .req_b__valid(mux_dprintf_req__valid[10]),
        .req_a__data_3(dprintf_req__data_3[9]),
        .req_a__data_2(dprintf_req__data_2[9]),
        .req_a__data_1(dprintf_req__data_1[9]),
        .req_a__data_0(dprintf_req__data_0[9]),
        .req_a__address(dprintf_req__address[9]),
        .req_a__valid(dprintf_req__valid[9]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[9]),
        .req__data_2(            mux_dprintf_req__data_2[9]),
        .req__data_1(            mux_dprintf_req__data_1[9]),
        .req__data_0(            mux_dprintf_req__data_0[9]),
        .req__address(            mux_dprintf_req__address[9]),
        .req__valid(            mux_dprintf_req__valid[9]),
        .ack_b(            mux_dprintf_ack[10]),
        .ack_a(            dprintf_ack[9])         );
    dprintf_4_mux tdm___10(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[10]),
        .req_b__data_3(mux_dprintf_req__data_3[11]),
        .req_b__data_2(mux_dprintf_req__data_2[11]),
        .req_b__data_1(mux_dprintf_req__data_1[11]),
        .req_b__data_0(mux_dprintf_req__data_0[11]),
        .req_b__address(mux_dprintf_req__address[11]),
        .req_b__valid(mux_dprintf_req__valid[11]),
        .req_a__data_3(dprintf_req__data_3[10]),
        .req_a__data_2(dprintf_req__data_2[10]),
        .req_a__data_1(dprintf_req__data_1[10]),
        .req_a__data_0(dprintf_req__data_0[10]),
        .req_a__address(dprintf_req__address[10]),
        .req_a__valid(dprintf_req__valid[10]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[10]),
        .req__data_2(            mux_dprintf_req__data_2[10]),
        .req__data_1(            mux_dprintf_req__data_1[10]),
        .req__data_0(            mux_dprintf_req__data_0[10]),
        .req__address(            mux_dprintf_req__address[10]),
        .req__valid(            mux_dprintf_req__valid[10]),
        .ack_b(            mux_dprintf_ack[11]),
        .ack_a(            dprintf_ack[10])         );
    dprintf_4_mux tdm___11(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[11]),
        .req_b__data_3(mux_dprintf_req__data_3[12]),
        .req_b__data_2(mux_dprintf_req__data_2[12]),
        .req_b__data_1(mux_dprintf_req__data_1[12]),
        .req_b__data_0(mux_dprintf_req__data_0[12]),
        .req_b__address(mux_dprintf_req__address[12]),
        .req_b__valid(mux_dprintf_req__valid[12]),
        .req_a__data_3(dprintf_req__data_3[11]),
        .req_a__data_2(dprintf_req__data_2[11]),
        .req_a__data_1(dprintf_req__data_1[11]),
        .req_a__data_0(dprintf_req__data_0[11]),
        .req_a__address(dprintf_req__address[11]),
        .req_a__valid(dprintf_req__valid[11]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[11]),
        .req__data_2(            mux_dprintf_req__data_2[11]),
        .req__data_1(            mux_dprintf_req__data_1[11]),
        .req__data_0(            mux_dprintf_req__data_0[11]),
        .req__address(            mux_dprintf_req__address[11]),
        .req__valid(            mux_dprintf_req__valid[11]),
        .ack_b(            mux_dprintf_ack[12]),
        .ack_a(            dprintf_ack[11])         );
    dprintf_4_mux tdm___12(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[12]),
        .req_b__data_3(mux_dprintf_req__data_3[13]),
        .req_b__data_2(mux_dprintf_req__data_2[13]),
        .req_b__data_1(mux_dprintf_req__data_1[13]),
        .req_b__data_0(mux_dprintf_req__data_0[13]),
        .req_b__address(mux_dprintf_req__address[13]),
        .req_b__valid(mux_dprintf_req__valid[13]),
        .req_a__data_3(dprintf_req__data_3[12]),
        .req_a__data_2(dprintf_req__data_2[12]),
        .req_a__data_1(dprintf_req__data_1[12]),
        .req_a__data_0(dprintf_req__data_0[12]),
        .req_a__address(dprintf_req__address[12]),
        .req_a__valid(dprintf_req__valid[12]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[12]),
        .req__data_2(            mux_dprintf_req__data_2[12]),
        .req__data_1(            mux_dprintf_req__data_1[12]),
        .req__data_0(            mux_dprintf_req__data_0[12]),
        .req__address(            mux_dprintf_req__address[12]),
        .req__valid(            mux_dprintf_req__valid[12]),
        .ack_b(            mux_dprintf_ack[13]),
        .ack_a(            dprintf_ack[12])         );
    dprintf_4_mux tdm___13(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(mux_dprintf_ack[13]),
        .req_b__data_3(mux_dprintf_req__data_3[14]),
        .req_b__data_2(mux_dprintf_req__data_2[14]),
        .req_b__data_1(mux_dprintf_req__data_1[14]),
        .req_b__data_0(mux_dprintf_req__data_0[14]),
        .req_b__address(mux_dprintf_req__address[14]),
        .req_b__valid(mux_dprintf_req__valid[14]),
        .req_a__data_3(dprintf_req__data_3[13]),
        .req_a__data_2(dprintf_req__data_2[13]),
        .req_a__data_1(dprintf_req__data_1[13]),
        .req_a__data_0(dprintf_req__data_0[13]),
        .req_a__address(dprintf_req__address[13]),
        .req_a__valid(dprintf_req__valid[13]),
        .reset_n(reset_n),
        .req__data_3(            mux_dprintf_req__data_3[13]),
        .req__data_2(            mux_dprintf_req__data_2[13]),
        .req__data_1(            mux_dprintf_req__data_1[13]),
        .req__data_0(            mux_dprintf_req__data_0[13]),
        .req__address(            mux_dprintf_req__address[13]),
        .req__valid(            mux_dprintf_req__valid[13]),
        .ack_b(            mux_dprintf_ack[14]),
        .ack_a(            dprintf_ack[13])         );
    apb_target_sram_interface rv_sram_if(
        .clk(clk),
        .clk__enable(1'b1),
        .sram_access_resp__data(rv_sram_access_resp__data),
        .sram_access_resp__id(rv_sram_access_resp__id),
        .sram_access_resp__valid(rv_sram_access_resp__valid),
        .sram_access_resp__ack(rv_sram_access_resp__ack),
        .apb_request__pwdata(rv_sram_apb_request__pwdata),
        .apb_request__pwrite(rv_sram_apb_request__pwrite),
        .apb_request__psel(rv_sram_apb_request__psel),
        .apb_request__penable(rv_sram_apb_request__penable),
        .apb_request__paddr(rv_sram_apb_request__paddr),
        .reset_n(reset_n),
        .sram_access_req__write_data(            rv_sram_access_req__write_data),
        .sram_access_req__address(            rv_sram_access_req__address),
        .sram_access_req__byte_enable(            rv_sram_access_req__byte_enable),
        .sram_access_req__read_not_write(            rv_sram_access_req__read_not_write),
        .sram_access_req__id(            rv_sram_access_req__id),
        .sram_access_req__valid(            rv_sram_access_req__valid),
        .sram_ctrl(            rv_sram_ctrl),
        .apb_response__perr(            rv_sram_apb_response__perr),
        .apb_response__pready(            rv_sram_apb_response__pready),
        .apb_response__prdata(            rv_sram_apb_response__prdata)         );
    apb_target_sram_interface fb_sram_if(
        .clk(clk),
        .clk__enable(1'b1),
        .sram_access_resp__data(fb_sram_access_resp__data),
        .sram_access_resp__id(fb_sram_access_resp__id),
        .sram_access_resp__valid(fb_sram_access_resp__valid),
        .sram_access_resp__ack(fb_sram_access_resp__ack),
        .apb_request__pwdata(fb_sram_apb_request__pwdata),
        .apb_request__pwrite(fb_sram_apb_request__pwrite),
        .apb_request__psel(fb_sram_apb_request__psel),
        .apb_request__penable(fb_sram_apb_request__penable),
        .apb_request__paddr(fb_sram_apb_request__paddr),
        .reset_n(reset_n),
        .sram_access_req__write_data(            fb_sram_access_req__write_data),
        .sram_access_req__address(            fb_sram_access_req__address),
        .sram_access_req__byte_enable(            fb_sram_access_req__byte_enable),
        .sram_access_req__read_not_write(            fb_sram_access_req__read_not_write),
        .sram_access_req__id(            fb_sram_access_req__id),
        .sram_access_req__valid(            fb_sram_access_req__valid),
        .sram_ctrl(            fb_sram_ctrl),
        .apb_response__perr(            fb_sram_apb_response__perr),
        .apb_response__pready(            fb_sram_apb_response__pready),
        .apb_response__prdata(            fb_sram_apb_response__prdata)         );
    apb_target_dprintf apb_dprintf(
        .clk(clk),
        .clk__enable(1'b1),
        .dprintf_ack(apb_dprintf_ack),
        .apb_request__pwdata(dprintf_apb_request__pwdata),
        .apb_request__pwrite(dprintf_apb_request__pwrite),
        .apb_request__psel(dprintf_apb_request__psel),
        .apb_request__penable(dprintf_apb_request__penable),
        .apb_request__paddr(dprintf_apb_request__paddr),
        .reset_n(reset_n),
        .dprintf_req__data_3(            apb_dprintf_req__data_3),
        .dprintf_req__data_2(            apb_dprintf_req__data_2),
        .dprintf_req__data_1(            apb_dprintf_req__data_1),
        .dprintf_req__data_0(            apb_dprintf_req__data_0),
        .dprintf_req__address(            apb_dprintf_req__address),
        .dprintf_req__valid(            apb_dprintf_req__valid),
        .apb_response__perr(            dprintf_apb_response__perr),
        .apb_response__pready(            dprintf_apb_response__pready),
        .apb_response__prdata(            dprintf_apb_response__prdata)         );
    apb_target_rv_timer timer(
        .clk(clk),
        .clk__enable(1'b1),
        .apb_request__pwdata(timer_apb_request__pwdata),
        .apb_request__pwrite(timer_apb_request__pwrite),
        .apb_request__psel(timer_apb_request__psel),
        .apb_request__penable(timer_apb_request__penable),
        .apb_request__paddr(timer_apb_request__paddr),
        .timer_control__integer_adder(timer_control__integer_adder),
        .timer_control__fractional_adder(timer_control__fractional_adder),
        .timer_control__bonus_subfraction_denom(timer_control__bonus_subfraction_denom),
        .timer_control__bonus_subfraction_numer(timer_control__bonus_subfraction_numer),
        .timer_control__block_writes(timer_control__block_writes),
        .timer_control__enable_counter(timer_control__enable_counter),
        .timer_control__reset_counter(timer_control__reset_counter),
        .reset_n(reset_n),
        .timer_value__value(            timer_value__value),
        .timer_value__irq(            timer_value__irq),
        .apb_response__perr(            timer_apb_response__perr),
        .apb_response__pready(            timer_apb_response__pready),
        .apb_response__prdata(            timer_apb_response__prdata)         );
    apb_target_ps2_host ps2_if(
        .clk(clk),
        .clk__enable(1'b1),
        .ps2_in__clk(ps2_in__clk),
        .ps2_in__data(ps2_in__data),
        .apb_request__pwdata(ps2_apb_request__pwdata),
        .apb_request__pwrite(ps2_apb_request__pwrite),
        .apb_request__psel(ps2_apb_request__psel),
        .apb_request__penable(ps2_apb_request__penable),
        .apb_request__paddr(ps2_apb_request__paddr),
        .reset_n(reset_n),
        .ps2_out__clk(            ps2_out__clk),
        .ps2_out__data(            ps2_out__data),
        .apb_response__perr(            ps2_apb_response__perr),
        .apb_response__pready(            ps2_apb_response__pready),
        .apb_response__prdata(            ps2_apb_response__prdata)         );
    csr_master_apb master(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_response__read_data(csr_response_r__read_data),
        .csr_response__read_data_error(csr_response_r__read_data_error),
        .csr_response__read_data_valid(csr_response_r__read_data_valid),
        .csr_response__acknowledge(csr_response_r__acknowledge),
        .apb_request__pwdata(csr_apb_request__pwdata),
        .apb_request__pwrite(csr_apb_request__pwrite),
        .apb_request__psel(csr_apb_request__psel),
        .apb_request__penable(csr_apb_request__penable),
        .apb_request__paddr(csr_apb_request__paddr),
        .reset_n(reset_n),
        .csr_request__data(            csr_request__data),
        .csr_request__address(            csr_request__address),
        .csr_request__select(            csr_request__select),
        .csr_request__read_not_write(            csr_request__read_not_write),
        .csr_request__valid(            csr_request__valid),
        .apb_response__perr(            csr_apb_response__perr),
        .apb_response__pready(            csr_apb_response__pready),
        .apb_response__prdata(            csr_apb_response__prdata)         );
    dprintf dprintf(
        .clk(clk),
        .clk__enable(1'b1),
        .dprintf_req__data_3(mux_dprintf_req__data_3[0]),
        .dprintf_req__data_2(mux_dprintf_req__data_2[0]),
        .dprintf_req__data_1(mux_dprintf_req__data_1[0]),
        .dprintf_req__data_0(mux_dprintf_req__data_0[0]),
        .dprintf_req__address(mux_dprintf_req__address[0]),
        .dprintf_req__valid(mux_dprintf_req__valid[0]),
        .reset_n(reset_n),
        .dprintf_byte__address(            dprintf_byte__address),
        .dprintf_byte__data(            dprintf_byte__data),
        .dprintf_byte__valid(            dprintf_byte__valid),
        .dprintf_ack(            mux_dprintf_ack[0])         );
    framebuffer_teletext ftb_vga(
        .video_clk(de2_vga_clk),
        .video_clk__enable(1'b1),
        .sram_clk(clk),
        .sram_clk__enable(1'b1),
        .csr_clk(clk),
        .csr_clk__enable(1'b1),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .csr_select_in(16'h4),
        .display_sram_write__write_data(tt_display_sram_access_req__write_data),
        .display_sram_write__address(tt_display_sram_access_req__address),
        .display_sram_write__byte_enable(tt_display_sram_access_req__byte_enable),
        .display_sram_write__read_not_write(tt_display_sram_access_req__read_not_write),
        .display_sram_write__id(tt_display_sram_access_req__id),
        .display_sram_write__valid(tt_display_sram_access_req__valid),
        .reset_n(reset_n),
        .csr_response__read_data(            tt_vga_framebuffer_csr_response__read_data),
        .csr_response__read_data_error(            tt_vga_framebuffer_csr_response__read_data_error),
        .csr_response__read_data_valid(            tt_vga_framebuffer_csr_response__read_data_valid),
        .csr_response__acknowledge(            tt_vga_framebuffer_csr_response__acknowledge),
        .video_bus__blue(            vga_video_bus__blue),
        .video_bus__green(            vga_video_bus__green),
        .video_bus__red(            vga_video_bus__red),
        .video_bus__display_enable(            vga_video_bus__display_enable),
        .video_bus__hsync(            vga_video_bus__hsync),
        .video_bus__vsync(            vga_video_bus__vsync)         );
    csr_target_timeout csr_timeout(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_timeout(16'h100),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .reset_n(reset_n),
        .csr_response__read_data(            timeout_csr_response__read_data),
        .csr_response__read_data_error(            timeout_csr_response__read_data_error),
        .csr_response__read_data_valid(            timeout_csr_response__read_data_valid),
        .csr_response__acknowledge(            timeout_csr_response__acknowledge)         );
    led_seven_segment h___0(
        .hex(counter[3:0]),
        .leds(            de2_hex_leds[0])         );
    led_seven_segment h___1(
        .hex(counter[7:4]),
        .leds(            de2_hex_leds[1])         );
    led_seven_segment h___2(
        .hex(counter[11:8]),
        .leds(            de2_hex_leds[2])         );
    led_seven_segment h___3(
        .hex(counter[15:12]),
        .leds(            de2_hex_leds[3])         );
    led_seven_segment h___4(
        .hex(counter[19:16]),
        .leds(            de2_hex_leds[4])         );
    led_seven_segment h___5(
        .hex(counter[23:20]),
        .leds(            de2_hex_leds[5])         );
    //b riscv_instance combinatorial process
    always @ ( * )//riscv_instance
    begin: riscv_instance__comb_code
    reg timer_control__enable_counter__var;
    reg [7:0]timer_control__integer_adder__var;
        timer_control__reset_counter = 1'h0;
        timer_control__enable_counter__var = 1'h0;
        timer_control__block_writes = 1'h0;
        timer_control__bonus_subfraction_numer = 8'h0;
        timer_control__bonus_subfraction_denom = 8'h0;
        timer_control__fractional_adder = 4'h0;
        timer_control__integer_adder__var = 8'h0;
        timer_control__enable_counter__var = 1'h1;
        timer_control__integer_adder__var = 8'h14;
        timer_control__enable_counter = timer_control__enable_counter__var;
        timer_control__integer_adder = timer_control__integer_adder__var;
    end //always

    //b apb_master_instances clock process
    always @( posedge clk or negedge reset_n)
    begin : apb_master_instances__code
        if (reset_n==1'b0)
        begin
            apb_processor_request__address <= 16'h0;
            apb_processor_request__valid <= 1'h0;
            apb_processor_completed <= 1'h0;
        end
        else if (clk__enable)
        begin
            apb_processor_request__address <= 16'h0;
            apb_processor_request__valid <= !(apb_processor_completed!=1'h0);
            if ((apb_processor_response__acknowledge!=1'h0))
            begin
                apb_processor_request__valid <= 1'h0;
                apb_processor_completed <= 1'h1;
            end //if
        end //if
    end //always

    //b apb_multiplexing_decode combinatorial process
    always @ ( * )//apb_multiplexing_decode
    begin: apb_multiplexing_decode__comb_code
    reg [31:0]timer_apb_request__paddr__var;
    reg timer_apb_request__psel__var;
    reg [31:0]dprintf_apb_request__paddr__var;
    reg dprintf_apb_request__psel__var;
    reg [31:0]csr_apb_request__paddr__var;
    reg csr_apb_request__psel__var;
    reg [31:0]rv_sram_apb_request__paddr__var;
    reg rv_sram_apb_request__psel__var;
    reg [31:0]fb_sram_apb_request__paddr__var;
    reg fb_sram_apb_request__psel__var;
    reg [31:0]ps2_apb_request__paddr__var;
    reg ps2_apb_request__psel__var;
    reg [31:0]apb_response__prdata__var;
    reg apb_response__pready__var;
    reg apb_response__perr__var;
        apb_request__paddr = proc_apb_request__paddr;
        apb_request__penable = proc_apb_request__penable;
        apb_request__psel = proc_apb_request__psel;
        apb_request__pwrite = proc_apb_request__pwrite;
        apb_request__pwdata = proc_apb_request__pwdata;
        apb_request_sel = apb_request__paddr[19:16];
        timer_apb_request__paddr__var = apb_request__paddr;
        timer_apb_request__penable = apb_request__penable;
        timer_apb_request__psel__var = apb_request__psel;
        timer_apb_request__pwrite = apb_request__pwrite;
        timer_apb_request__pwdata = apb_request__pwdata;
        dprintf_apb_request__paddr__var = apb_request__paddr;
        dprintf_apb_request__penable = apb_request__penable;
        dprintf_apb_request__psel__var = apb_request__psel;
        dprintf_apb_request__pwrite = apb_request__pwrite;
        dprintf_apb_request__pwdata = apb_request__pwdata;
        csr_apb_request__paddr__var = apb_request__paddr;
        csr_apb_request__penable = apb_request__penable;
        csr_apb_request__psel__var = apb_request__psel;
        csr_apb_request__pwrite = apb_request__pwrite;
        csr_apb_request__pwdata = apb_request__pwdata;
        rv_sram_apb_request__paddr__var = apb_request__paddr;
        rv_sram_apb_request__penable = apb_request__penable;
        rv_sram_apb_request__psel__var = apb_request__psel;
        rv_sram_apb_request__pwrite = apb_request__pwrite;
        rv_sram_apb_request__pwdata = apb_request__pwdata;
        fb_sram_apb_request__paddr__var = apb_request__paddr;
        fb_sram_apb_request__penable = apb_request__penable;
        fb_sram_apb_request__psel__var = apb_request__psel;
        fb_sram_apb_request__pwrite = apb_request__pwrite;
        fb_sram_apb_request__pwdata = apb_request__pwdata;
        ps2_apb_request__paddr__var = apb_request__paddr;
        ps2_apb_request__penable = apb_request__penable;
        ps2_apb_request__psel__var = apb_request__psel;
        ps2_apb_request__pwrite = apb_request__pwrite;
        ps2_apb_request__pwdata = apb_request__pwdata;
        timer_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        dprintf_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        rv_sram_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        fb_sram_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        ps2_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        timer_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h0));
        dprintf_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h2));
        csr_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h3));
        rv_sram_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h4));
        fb_sram_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h7));
        ps2_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h8));
        csr_apb_request__paddr__var[31:16] = {12'h0,apb_request__paddr[15:12]};
        csr_apb_request__paddr__var[15:0] = {6'h0,apb_request__paddr[11:2]};
        apb_response__prdata__var = timer_apb_response__prdata;
        apb_response__pready__var = timer_apb_response__pready;
        apb_response__perr__var = timer_apb_response__perr;
        if ((apb_request_sel==4'h2))
        begin
            apb_response__prdata__var = dprintf_apb_response__prdata;
            apb_response__pready__var = dprintf_apb_response__pready;
            apb_response__perr__var = dprintf_apb_response__perr;
        end //if
        if ((apb_request_sel==4'h3))
        begin
            apb_response__prdata__var = csr_apb_response__prdata;
            apb_response__pready__var = csr_apb_response__pready;
            apb_response__perr__var = csr_apb_response__perr;
        end //if
        if ((apb_request_sel==4'h4))
        begin
            apb_response__prdata__var = rv_sram_apb_response__prdata;
            apb_response__pready__var = rv_sram_apb_response__pready;
            apb_response__perr__var = rv_sram_apb_response__perr;
        end //if
        if ((apb_request_sel==4'h7))
        begin
            apb_response__prdata__var = fb_sram_apb_response__prdata;
            apb_response__pready__var = fb_sram_apb_response__pready;
            apb_response__perr__var = fb_sram_apb_response__perr;
        end //if
        if ((apb_request_sel==4'h8))
        begin
            apb_response__prdata__var = ps2_apb_response__prdata;
            apb_response__pready__var = ps2_apb_response__pready;
            apb_response__perr__var = ps2_apb_response__perr;
        end //if
        proc_apb_response__prdata = apb_response__prdata__var;
        proc_apb_response__pready = apb_response__pready__var;
        proc_apb_response__perr = apb_response__perr__var;
        timer_apb_request__paddr = timer_apb_request__paddr__var;
        timer_apb_request__psel = timer_apb_request__psel__var;
        dprintf_apb_request__paddr = dprintf_apb_request__paddr__var;
        dprintf_apb_request__psel = dprintf_apb_request__psel__var;
        csr_apb_request__paddr = csr_apb_request__paddr__var;
        csr_apb_request__psel = csr_apb_request__psel__var;
        rv_sram_apb_request__paddr = rv_sram_apb_request__paddr__var;
        rv_sram_apb_request__psel = rv_sram_apb_request__psel__var;
        fb_sram_apb_request__paddr = fb_sram_apb_request__paddr__var;
        fb_sram_apb_request__psel = fb_sram_apb_request__psel__var;
        ps2_apb_request__paddr = ps2_apb_request__paddr__var;
        ps2_apb_request__psel = ps2_apb_request__psel__var;
        apb_response__prdata = apb_response__prdata__var;
        apb_response__pready = apb_response__pready__var;
        apb_response__perr = apb_response__perr__var;
    end //always

    //b dprintf_requesting__comb combinatorial process
    always @ ( * )//dprintf_requesting__comb
    begin: dprintf_requesting__comb_code
        apb_dprintf_ack = dprintf_ack[0];
    end //always

    //b dprintf_requesting__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : dprintf_requesting__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            dprintf_req__valid[0] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[1] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[2] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[3] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[4] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[5] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[6] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[7] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[8] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[9] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[10] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[11] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[12] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[13] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[14] <= 1'h0; // Should this be a bit vector?
            dprintf_req__valid[15] <= 1'h0; // Should this be a bit vector?
            dprintf_req__address[0] <= 16'h0;
            dprintf_req__address[1] <= 16'h0;
            dprintf_req__address[2] <= 16'h0;
            dprintf_req__address[3] <= 16'h0;
            dprintf_req__address[4] <= 16'h0;
            dprintf_req__address[5] <= 16'h0;
            dprintf_req__address[6] <= 16'h0;
            dprintf_req__address[7] <= 16'h0;
            dprintf_req__address[8] <= 16'h0;
            dprintf_req__address[9] <= 16'h0;
            dprintf_req__address[10] <= 16'h0;
            dprintf_req__address[11] <= 16'h0;
            dprintf_req__address[12] <= 16'h0;
            dprintf_req__address[13] <= 16'h0;
            dprintf_req__address[14] <= 16'h0;
            dprintf_req__address[15] <= 16'h0;
            dprintf_req__data_0[0] <= 64'h0;
            dprintf_req__data_0[1] <= 64'h0;
            dprintf_req__data_0[2] <= 64'h0;
            dprintf_req__data_0[3] <= 64'h0;
            dprintf_req__data_0[4] <= 64'h0;
            dprintf_req__data_0[5] <= 64'h0;
            dprintf_req__data_0[6] <= 64'h0;
            dprintf_req__data_0[7] <= 64'h0;
            dprintf_req__data_0[8] <= 64'h0;
            dprintf_req__data_0[9] <= 64'h0;
            dprintf_req__data_0[10] <= 64'h0;
            dprintf_req__data_0[11] <= 64'h0;
            dprintf_req__data_0[12] <= 64'h0;
            dprintf_req__data_0[13] <= 64'h0;
            dprintf_req__data_0[14] <= 64'h0;
            dprintf_req__data_0[15] <= 64'h0;
            dprintf_req__data_1[0] <= 64'h0;
            dprintf_req__data_1[1] <= 64'h0;
            dprintf_req__data_1[2] <= 64'h0;
            dprintf_req__data_1[3] <= 64'h0;
            dprintf_req__data_1[4] <= 64'h0;
            dprintf_req__data_1[5] <= 64'h0;
            dprintf_req__data_1[6] <= 64'h0;
            dprintf_req__data_1[7] <= 64'h0;
            dprintf_req__data_1[8] <= 64'h0;
            dprintf_req__data_1[9] <= 64'h0;
            dprintf_req__data_1[10] <= 64'h0;
            dprintf_req__data_1[11] <= 64'h0;
            dprintf_req__data_1[12] <= 64'h0;
            dprintf_req__data_1[13] <= 64'h0;
            dprintf_req__data_1[14] <= 64'h0;
            dprintf_req__data_1[15] <= 64'h0;
            dprintf_req__data_2[0] <= 64'h0;
            dprintf_req__data_2[1] <= 64'h0;
            dprintf_req__data_2[2] <= 64'h0;
            dprintf_req__data_2[3] <= 64'h0;
            dprintf_req__data_2[4] <= 64'h0;
            dprintf_req__data_2[5] <= 64'h0;
            dprintf_req__data_2[6] <= 64'h0;
            dprintf_req__data_2[7] <= 64'h0;
            dprintf_req__data_2[8] <= 64'h0;
            dprintf_req__data_2[9] <= 64'h0;
            dprintf_req__data_2[10] <= 64'h0;
            dprintf_req__data_2[11] <= 64'h0;
            dprintf_req__data_2[12] <= 64'h0;
            dprintf_req__data_2[13] <= 64'h0;
            dprintf_req__data_2[14] <= 64'h0;
            dprintf_req__data_2[15] <= 64'h0;
            dprintf_req__data_3[0] <= 64'h0;
            dprintf_req__data_3[1] <= 64'h0;
            dprintf_req__data_3[2] <= 64'h0;
            dprintf_req__data_3[3] <= 64'h0;
            dprintf_req__data_3[4] <= 64'h0;
            dprintf_req__data_3[5] <= 64'h0;
            dprintf_req__data_3[6] <= 64'h0;
            dprintf_req__data_3[7] <= 64'h0;
            dprintf_req__data_3[8] <= 64'h0;
            dprintf_req__data_3[9] <= 64'h0;
            dprintf_req__data_3[10] <= 64'h0;
            dprintf_req__data_3[11] <= 64'h0;
            dprintf_req__data_3[12] <= 64'h0;
            dprintf_req__data_3[13] <= 64'h0;
            dprintf_req__data_3[14] <= 64'h0;
            dprintf_req__data_3[15] <= 64'h0;
        end
        else if (clk__enable)
        begin
            if ((dprintf_ack[0]!=1'h0))
            begin
                dprintf_req__valid[0] <= 1'h0;
            end //if
            if ((dprintf_ack[1]!=1'h0))
            begin
                dprintf_req__valid[1] <= 1'h0;
            end //if
            if ((dprintf_ack[2]!=1'h0))
            begin
                dprintf_req__valid[2] <= 1'h0;
            end //if
            if ((dprintf_ack[3]!=1'h0))
            begin
                dprintf_req__valid[3] <= 1'h0;
            end //if
            if ((dprintf_ack[4]!=1'h0))
            begin
                dprintf_req__valid[4] <= 1'h0;
            end //if
            if ((dprintf_ack[5]!=1'h0))
            begin
                dprintf_req__valid[5] <= 1'h0;
            end //if
            if ((dprintf_ack[6]!=1'h0))
            begin
                dprintf_req__valid[6] <= 1'h0;
            end //if
            if ((dprintf_ack[7]!=1'h0))
            begin
                dprintf_req__valid[7] <= 1'h0;
            end //if
            if ((dprintf_ack[8]!=1'h0))
            begin
                dprintf_req__valid[8] <= 1'h0;
            end //if
            if ((dprintf_ack[9]!=1'h0))
            begin
                dprintf_req__valid[9] <= 1'h0;
            end //if
            if ((dprintf_ack[10]!=1'h0))
            begin
                dprintf_req__valid[10] <= 1'h0;
            end //if
            if ((dprintf_ack[11]!=1'h0))
            begin
                dprintf_req__valid[11] <= 1'h0;
            end //if
            if ((dprintf_ack[12]!=1'h0))
            begin
                dprintf_req__valid[12] <= 1'h0;
            end //if
            if ((dprintf_ack[13]!=1'h0))
            begin
                dprintf_req__valid[13] <= 1'h0;
            end //if
            if ((dprintf_ack[14]!=1'h0))
            begin
                dprintf_req__valid[14] <= 1'h0;
            end //if
            if ((dprintf_ack[15]!=1'h0))
            begin
                dprintf_req__valid[15] <= 1'h0;
            end //if
            dprintf_req__valid[0] <= apb_dprintf_req__valid;
            dprintf_req__address[0] <= apb_dprintf_req__address;
            dprintf_req__data_0[0] <= apb_dprintf_req__data_0;
            dprintf_req__data_1[0] <= apb_dprintf_req__data_1;
            dprintf_req__data_2[0] <= apb_dprintf_req__data_2;
            dprintf_req__data_3[0] <= apb_dprintf_req__data_3;
            if ((apb_request__psel!=1'h0))
            begin
                dprintf_req__valid[6] <= 1'h1;
                dprintf_req__address[6] <= 16'hf0;
                dprintf_req__data_0[6] <= {{{40'h4150423a80,7'h0},apb_request__pwrite},16'h2087};
                dprintf_req__data_1[6] <= {apb_request__paddr,32'h20000087};
                dprintf_req__data_2[6] <= {{apb_request__pwdata,8'hff},24'h0};
            end //if
            if ((csr_request__valid!=1'h0))
            begin
                dprintf_req__valid[7] <= 1'h1;
                dprintf_req__address[7] <= 16'h118;
                dprintf_req__data_0[7] <= {{{40'h4353523a80,7'h0},csr_request__read_not_write},16'h2083};
                dprintf_req__data_1[7] <= {csr_request__select,48'h200000000083};
                dprintf_req__data_2[7] <= {csr_request__address,48'h200000000087};
                dprintf_req__data_3[7] <= {{csr_request__data,8'hff},24'h0};
            end //if
            if ((rv_sram_access_req__valid!=1'h0))
            begin
                dprintf_req__valid[8] <= 1'h1;
                dprintf_req__address[8] <= 16'h140;
                dprintf_req__data_0[8] <= {{{40'h53524d3a83,4'h0},rv_sram_access_req__id},16'h2080};
                dprintf_req__data_1[8] <= {{7'h0,rv_sram_access_req__read_not_write},56'h20000000000087};
                dprintf_req__data_2[8] <= {rv_sram_access_req__address,32'h20000087};
                dprintf_req__data_3[8] <= {{{rv_sram_access_req__write_data[31:0],16'h2080},rv_sram_access_req__byte_enable},8'hff};
            end //if
            if ((divider_reset!=1'h0))
            begin
                dprintf_req__valid[11] <= 1'h1;
                dprintf_req__address[11] <= 16'h1b8;
                dprintf_req__data_0[11] <= {32'h5647413a,32'h87};
                dprintf_req__data_1[11] <= {vga_counters[0],32'h20000087};
                dprintf_req__data_2[11] <= {vga_counters[1],32'h20000087};
                dprintf_req__data_3[11] <= {{vga_counters[2],8'hff},24'h0};
            end //if
        end //if
    end //always

    //b apb_target_instances clock process
    always @( posedge clk or negedge reset_n)
    begin : apb_target_instances__code
        if (reset_n==1'b0)
        begin
            ps2_in__data <= 1'hffffffffffffffff;
            ps2_in__clk <= 1'hffffffffffffffff;
        end
        else if (clk__enable)
        begin
            ps2_in__data <= de2_ps2_in__data;
            ps2_in__clk <= de2_ps2_in__clk;
        end //if
    end //always

    //b dprintf_framebuffer_instances__comb combinatorial process
    always @ ( * )//dprintf_framebuffer_instances__comb
    begin: dprintf_framebuffer_instances__comb_code
    reg tt_display_sram_access_req__valid__var;
    reg [31:0]tt_display_sram_access_req__address__var;
    reg [63:0]tt_display_sram_access_req__write_data__var;
    reg fb_sram_access_resp__ack__var;
    reg fb_sram_access_resp__valid__var;
    reg [3:0]fb_sram_access_resp__id__var;
    reg rv_sram_access_resp__ack__var;
    reg rv_sram_access_resp__valid__var;
    reg [3:0]rv_sram_access_resp__id__var;
    reg csr_response__acknowledge__var;
    reg csr_response__read_data_valid__var;
    reg csr_response__read_data_error__var;
    reg [31:0]csr_response__read_data__var;
        tt_display_sram_access_req__valid__var = 1'h0;
        tt_display_sram_access_req__id = 4'h0;
        tt_display_sram_access_req__read_not_write = 1'h0;
        tt_display_sram_access_req__byte_enable = 8'h0;
        tt_display_sram_access_req__address__var = 32'h0;
        tt_display_sram_access_req__write_data__var = 64'h0;
        tt_display_sram_access_req__valid__var = dprintf_byte__valid;
        tt_display_sram_access_req__address__var = {16'h0,dprintf_byte__address};
        tt_display_sram_access_req__write_data__var = {56'h0,dprintf_byte__data};
        fb_sram_access_resp__ack__var = 1'h0;
        fb_sram_access_resp__valid__var = 1'h0;
        fb_sram_access_resp__id__var = 4'h0;
        fb_sram_access_resp__data = 64'h0;
        fb_sram_access_resp__ack__var = fb_sram_access_req__valid;
        fb_sram_access_resp__valid__var = fb_sram_access_req__valid;
        fb_sram_access_resp__id__var = fb_sram_access_req__id;
        rv_sram_access_resp__ack__var = 1'h0;
        rv_sram_access_resp__valid__var = 1'h0;
        rv_sram_access_resp__id__var = 4'h0;
        rv_sram_access_resp__data = 64'h0;
        rv_sram_access_resp__ack__var = rv_sram_access_req__valid;
        rv_sram_access_resp__valid__var = rv_sram_access_req__valid;
        rv_sram_access_resp__id__var = rv_sram_access_req__id;
        csr_response__acknowledge__var = tt_vga_framebuffer_csr_response__acknowledge;
        csr_response__read_data_valid__var = tt_vga_framebuffer_csr_response__read_data_valid;
        csr_response__read_data_error__var = tt_vga_framebuffer_csr_response__read_data_error;
        csr_response__read_data__var = tt_vga_framebuffer_csr_response__read_data;
        csr_response__acknowledge__var = csr_response__acknowledge__var | timeout_csr_response__acknowledge;
        csr_response__read_data_valid__var = csr_response__read_data_valid__var | timeout_csr_response__read_data_valid;
        csr_response__read_data_error__var = csr_response__read_data_error__var | timeout_csr_response__read_data_error;
        csr_response__read_data__var = csr_response__read_data__var | timeout_csr_response__read_data;
        tt_display_sram_access_req__valid = tt_display_sram_access_req__valid__var;
        tt_display_sram_access_req__address = tt_display_sram_access_req__address__var;
        tt_display_sram_access_req__write_data = tt_display_sram_access_req__write_data__var;
        fb_sram_access_resp__ack = fb_sram_access_resp__ack__var;
        fb_sram_access_resp__valid = fb_sram_access_resp__valid__var;
        fb_sram_access_resp__id = fb_sram_access_resp__id__var;
        rv_sram_access_resp__ack = rv_sram_access_resp__ack__var;
        rv_sram_access_resp__valid = rv_sram_access_resp__valid__var;
        rv_sram_access_resp__id = rv_sram_access_resp__id__var;
        csr_response__acknowledge = csr_response__acknowledge__var;
        csr_response__read_data_valid = csr_response__read_data_valid__var;
        csr_response__read_data_error = csr_response__read_data_error__var;
        csr_response__read_data = csr_response__read_data__var;
    end //always

    //b dprintf_framebuffer_instances__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : dprintf_framebuffer_instances__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            csr_response_r__acknowledge <= 1'h0;
            csr_response_r__read_data_valid <= 1'h0;
            csr_response_r__read_data_error <= 1'h0;
            csr_response_r__read_data <= 32'h0;
        end
        else if (clk__enable)
        begin
            csr_response_r__acknowledge <= csr_response__acknowledge;
            csr_response_r__read_data_valid <= csr_response__read_data_valid;
            csr_response_r__read_data_error <= csr_response__read_data_error;
            csr_response_r__read_data <= csr_response__read_data;
        end //if
    end //always

    //b dprintf_framebuffer_instances__posedge_de2_vga_clk_active_low_de2_vga_reset_n clock process
    always @( posedge de2_vga_clk or negedge de2_vga_reset_n)
    begin : dprintf_framebuffer_instances__posedge_de2_vga_clk_active_low_de2_vga_reset_n__code
        if (de2_vga_reset_n==1'b0)
        begin
            de2_vga__hs <= 1'h0;
            vga_hsync_counter <= 12'h0;
            de2_vga__vs <= 1'h0;
            vga_vsync_counter <= 4'h0;
            de2_vga__blank_n <= 1'h0;
            de2_vga__sync_n <= 1'h0;
            de2_vga__red <= 10'h0;
            de2_vga__green <= 10'h0;
            de2_vga__blue <= 10'h0;
            vga_counters[0] <= 32'h0;
            vga_counters[1] <= 32'h0;
            vga_counters[2] <= 32'h0;
            vga_counters[3] <= 32'h0;
            vga_seconds_sr <= 4'h0;
        end
        else if (de2_vga_clk__enable)
        begin
            de2_vga__hs <= 1'h1;
            if ((vga_hsync_counter!=12'h0))
            begin
                de2_vga__hs <= 1'h0;
                vga_hsync_counter <= (vga_hsync_counter-12'h1);
            end //if
            if ((vga_video_bus__hsync!=1'h0))
            begin
                de2_vga__hs <= 1'h0;
                vga_hsync_counter <= 12'h6e;
                de2_vga__vs <= 1'h1;
                if ((vga_vsync_counter!=4'h0))
                begin
                    de2_vga__vs <= 1'h0;
                    vga_vsync_counter <= (vga_vsync_counter-4'h1);
                end //if
            end //if
            if ((vga_video_bus__vsync!=1'h0))
            begin
                de2_vga__vs <= 1'h0;
                vga_vsync_counter <= 4'h1;
            end //if
            de2_vga__blank_n <= vga_video_bus__display_enable;
            de2_vga__sync_n <= (de2_vga__vs & de2_vga__hs);
            if ((de2_inputs__switches[9]!=1'h0))
            begin
                de2_vga__sync_n <= de2_inputs__switches[8];
            end //if
            de2_vga__red <= {vga_video_bus__red[7:0],2'h0};
            de2_vga__green <= {vga_video_bus__green[7:0],2'h0};
            de2_vga__blue <= {vga_video_bus__blue[7:0],2'h0};
            if ((vga_video_bus__vsync!=1'h0))
            begin
                vga_counters[0] <= (vga_counters[0]+32'h1);
            end //if
            if ((vga_video_bus__hsync!=1'h0))
            begin
                vga_counters[1] <= (vga_counters[1]+32'h1);
            end //if
            if ((vga_video_bus__display_enable!=1'h0))
            begin
                vga_counters[2] <= (vga_counters[2]+32'h1);
            end //if
            vga_seconds_sr <= {seconds[0],vga_seconds_sr[3:1]};
            if ((vga_seconds_sr[0]!=vga_seconds_sr[1]))
            begin
                vga_counters[0] <= 32'h0;
                vga_counters[1] <= 32'h0;
                vga_counters[2] <= 32'h0;
                vga_counters[3] <= 32'h0;
            end //if
        end //if
    end //always

    //b stubs__comb combinatorial process
    always @ ( * )//stubs__comb
    begin: stubs__comb_code
    reg [17:0]de2_leds__ledr__var;
    reg [6:0]de2_leds__h0__var;
    reg [6:0]de2_leds__h1__var;
    reg [6:0]de2_leds__h2__var;
    reg [6:0]de2_leds__h3__var;
    reg [6:0]de2_leds__h4__var;
    reg [6:0]de2_leds__h5__var;
        de2_leds__ledg = 10'h0;
        de2_leds__ledr__var = 18'h0;
        de2_leds__h0__var = 7'h0;
        de2_leds__h1__var = 7'h0;
        de2_leds__h2__var = 7'h0;
        de2_leds__h3__var = 7'h0;
        de2_leds__h4__var = 7'h0;
        de2_leds__h5__var = 7'h0;
        de2_leds__h6 = 7'h0;
        de2_leds__h7 = 7'h0;
        de2_leds__ledr__var = counter[17:0];
        de2_leds__h0__var = de2_hex_leds[0];
        de2_leds__h1__var = de2_hex_leds[1];
        de2_leds__h2__var = de2_hex_leds[2];
        de2_leds__h3__var = de2_hex_leds[3];
        de2_leds__h4__var = de2_hex_leds[4];
        de2_leds__h5__var = de2_hex_leds[5];
        de2_leds__ledr = de2_leds__ledr__var;
        de2_leds__h0 = de2_leds__h0__var;
        de2_leds__h1 = de2_leds__h1__var;
        de2_leds__h2 = de2_leds__h2__var;
        de2_leds__h3 = de2_leds__h3__var;
        de2_leds__h4 = de2_leds__h4__var;
        de2_leds__h5 = de2_leds__h5__var;
    end //always

    //b stubs__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : stubs__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            divider <= 32'h0;
            divider_reset <= 1'h0;
            seconds <= 8'h0;
            counter <= 32'h0;
            de2_ps2_out__data <= 1'hffffffffffffffff;
            de2_ps2_out__clk <= 1'hffffffffffffffff;
        end
        else if (clk__enable)
        begin
            divider <= (divider+32'h1);
            divider_reset <= 1'h0;
            if ((divider==32'h2faf080))
            begin
                divider <= 32'h0;
                divider_reset <= 1'h1;
                seconds <= (seconds+8'h1);
            end //if
            if ((de2_inputs__switches[4:2]==3'h0))
            begin
                counter <= (counter+32'h1);
            end //if
            if (((de2_inputs__switches[4:2]==3'h1)&&(mux_dprintf_req__valid[0]!=1'h0)))
            begin
                counter <= (counter+32'h1);
            end //if
            if (((de2_inputs__switches[4:2]==3'h2)&&(mux_dprintf_ack[0]!=1'h0)))
            begin
                counter <= (counter+32'h1);
            end //if
            if (((de2_inputs__switches[4:2]==3'h3)&&(apb_request__psel!=1'h0)))
            begin
                counter <= (counter+32'h1);
            end //if
            if (((de2_inputs__switches[4:2]==3'h4)&&(apb_processor_request__valid!=1'h0)))
            begin
                counter <= (counter+32'h1);
            end //if
            if (((de2_inputs__switches[4:2]==3'h5)&&(apb_processor_response__acknowledge!=1'h0)))
            begin
                counter <= (counter+32'h1);
            end //if
            if (((de2_inputs__switches[4:2]==3'h6)&&(tt_display_sram_access_req__valid!=1'h0)))
            begin
                counter <= (counter+32'h1);
            end //if
            de2_ps2_out__data <= ps2_out__data;
            de2_ps2_out__clk <= ps2_out__clk;
        end //if
    end //always

    //b tieoffs combinatorial process
    always @ ( * )//tieoffs
    begin: tieoffs__comb_code
        de2_audio_dac__data = 1'h0;
        de2_audio_dac__lrc = 1'h0;
        de2_i2c_out__sclk = 1'h1;
        de2_i2c_out__sdat = 1'h1;
        de2_lcd__backlight = 1'h0;
        de2_lcd__on = 1'h0;
        de2_lcd__rs = 1'h0;
        de2_lcd__read_write = 1'h0;
        de2_lcd__enable = 1'h0;
        de2_lcd__data = 8'h0;
        de2_uart_out__txd = 1'h0;
        de2_uart_out__cts = 1'h0;
        de2_td_reset_n = 1'h0;
        de2_sdr_out__cke = 1'h0;
        de2_sdr_out__cs_n = 1'h0;
        de2_sdr_out__ras_n = 1'h0;
        de2_sdr_out__cas_n = 1'h0;
        de2_sdr_out__we_n = 1'h0;
        de2_sdr_out__ba = 2'h0;
        de2_sdr_out__addr = 12'h0;
        de2_sdr_out__dq = 16'h0;
        de2_sdr_out__dqm = 2'h0;
        de2_sdr_out__dqe = 1'h0;
        de2_sram_out__ce_n = 1'h0;
        de2_sram_out__oe_n = 1'h0;
        de2_sram_out__we_n = 1'h0;
        de2_sram_out__be_n = 2'h0;
        de2_sram_out__addr = 12'h0;
        de2_sram_out__dq = 16'h0;
        de2_sram_out__dqe = 1'h0;
        de2_flash_out__reset_n = 1'h0;
        de2_flash_out__ce_n = 1'h0;
        de2_flash_out__oe_n = 1'h0;
        de2_flash_out__we_n = 1'h0;
        de2_flash_out__addr = 22'h0;
        de2_flash_out__dq = 8'h0;
        de2_flash_out__dqe = 1'h0;
    end //always

endmodule // picorisc_de2
