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

//a Module hps_fpga_debug
module hps_fpga_debug
(
    de1_vga_clock,
    de1_vga_clock__enable,
    de1_cl_lcd_clock,
    de1_cl_lcd_clock__enable,
    lw_axi_clock_clk,
    lw_axi_clock_clk__enable,
    clk,
    clk__enable,

    de1_irda_rxd,
    de1_switches,
    de1_keys,
    de1_vga_reset_n,
    de1_ps2b_in__data,
    de1_ps2b_in__clk,
    de1_ps2_in__data,
    de1_ps2_in__clk,
    de1_cl_lcd_reset_n,
    de1_cl_inputs_status__sr_data,
    de1_cl_inputs_status__left_rotary__direction_pin,
    de1_cl_inputs_status__left_rotary__transition_pin,
    de1_cl_inputs_status__right_rotary__direction_pin,
    de1_cl_inputs_status__right_rotary__transition_pin,
    lw_axi_rready,
    lw_axi_bready,
    lw_axi_w__valid,
    lw_axi_w__id,
    lw_axi_w__data,
    lw_axi_w__strb,
    lw_axi_w__last,
    lw_axi_w__user,
    lw_axi_aw__valid,
    lw_axi_aw__id,
    lw_axi_aw__addr,
    lw_axi_aw__len,
    lw_axi_aw__size,
    lw_axi_aw__burst,
    lw_axi_aw__lock,
    lw_axi_aw__cache,
    lw_axi_aw__prot,
    lw_axi_aw__qos,
    lw_axi_aw__region,
    lw_axi_aw__user,
    lw_axi_ar__valid,
    lw_axi_ar__id,
    lw_axi_ar__addr,
    lw_axi_ar__len,
    lw_axi_ar__size,
    lw_axi_ar__burst,
    lw_axi_ar__lock,
    lw_axi_ar__cache,
    lw_axi_ar__prot,
    lw_axi_ar__qos,
    lw_axi_ar__region,
    lw_axi_ar__user,
    reset_n,

    de1_vga__vs,
    de1_vga__hs,
    de1_vga__blank_n,
    de1_vga__sync_n,
    de1_vga__red,
    de1_vga__green,
    de1_vga__blue,
    de1_ps2_out__data,
    de1_ps2_out__clk,
    de1_cl_lcd__vsync_n,
    de1_cl_lcd__hsync_n,
    de1_cl_lcd__display_enable,
    de1_cl_lcd__red,
    de1_cl_lcd__green,
    de1_cl_lcd__blue,
    de1_cl_lcd__backlight,
    de1_irda_txd,
    de1_ps2b_out__data,
    de1_ps2b_out__clk,
    de1_leds__leds,
    de1_leds__h0,
    de1_leds__h1,
    de1_leds__h2,
    de1_leds__h3,
    de1_leds__h4,
    de1_leds__h5,
    de1_cl_led_data_pin,
    de1_cl_inputs_control__sr_clock,
    de1_cl_inputs_control__sr_shift,
    lw_axi_r__valid,
    lw_axi_r__id,
    lw_axi_r__data,
    lw_axi_r__resp,
    lw_axi_r__last,
    lw_axi_r__user,
    lw_axi_b__valid,
    lw_axi_b__id,
    lw_axi_b__resp,
    lw_axi_b__user,
    lw_axi_wready,
    lw_axi_awready,
    lw_axi_arready
);

    //b Clocks
    input de1_vga_clock;
    input de1_vga_clock__enable;
    input de1_cl_lcd_clock;
    input de1_cl_lcd_clock__enable;
    input lw_axi_clock_clk;
    input lw_axi_clock_clk__enable;
    input clk;
    input clk__enable;

    //b Inputs
    input de1_irda_rxd;
    input [9:0]de1_switches;
    input [3:0]de1_keys;
    input de1_vga_reset_n;
    input de1_ps2b_in__data;
    input de1_ps2b_in__clk;
    input de1_ps2_in__data;
    input de1_ps2_in__clk;
    input de1_cl_lcd_reset_n;
    input de1_cl_inputs_status__sr_data;
    input de1_cl_inputs_status__left_rotary__direction_pin;
    input de1_cl_inputs_status__left_rotary__transition_pin;
    input de1_cl_inputs_status__right_rotary__direction_pin;
    input de1_cl_inputs_status__right_rotary__transition_pin;
    input lw_axi_rready;
    input lw_axi_bready;
    input lw_axi_w__valid;
    input [11:0]lw_axi_w__id;
    input [31:0]lw_axi_w__data;
    input [3:0]lw_axi_w__strb;
    input lw_axi_w__last;
    input [3:0]lw_axi_w__user;
    input lw_axi_aw__valid;
    input [11:0]lw_axi_aw__id;
    input [31:0]lw_axi_aw__addr;
    input [3:0]lw_axi_aw__len;
    input [2:0]lw_axi_aw__size;
    input [1:0]lw_axi_aw__burst;
    input [1:0]lw_axi_aw__lock;
    input [3:0]lw_axi_aw__cache;
    input [2:0]lw_axi_aw__prot;
    input [3:0]lw_axi_aw__qos;
    input [3:0]lw_axi_aw__region;
    input [3:0]lw_axi_aw__user;
    input lw_axi_ar__valid;
    input [11:0]lw_axi_ar__id;
    input [31:0]lw_axi_ar__addr;
    input [3:0]lw_axi_ar__len;
    input [2:0]lw_axi_ar__size;
    input [1:0]lw_axi_ar__burst;
    input [1:0]lw_axi_ar__lock;
    input [3:0]lw_axi_ar__cache;
    input [2:0]lw_axi_ar__prot;
    input [3:0]lw_axi_ar__qos;
    input [3:0]lw_axi_ar__region;
    input [3:0]lw_axi_ar__user;
    input reset_n;

    //b Outputs
    output de1_vga__vs;
    output de1_vga__hs;
    output de1_vga__blank_n;
    output de1_vga__sync_n;
    output [9:0]de1_vga__red;
    output [9:0]de1_vga__green;
    output [9:0]de1_vga__blue;
    output de1_ps2_out__data;
    output de1_ps2_out__clk;
    output de1_cl_lcd__vsync_n;
    output de1_cl_lcd__hsync_n;
    output de1_cl_lcd__display_enable;
    output [5:0]de1_cl_lcd__red;
    output [6:0]de1_cl_lcd__green;
    output [5:0]de1_cl_lcd__blue;
    output de1_cl_lcd__backlight;
    output de1_irda_txd;
    output de1_ps2b_out__data;
    output de1_ps2b_out__clk;
    output [9:0]de1_leds__leds;
    output [6:0]de1_leds__h0;
    output [6:0]de1_leds__h1;
    output [6:0]de1_leds__h2;
    output [6:0]de1_leds__h3;
    output [6:0]de1_leds__h4;
    output [6:0]de1_leds__h5;
    output de1_cl_led_data_pin;
    output de1_cl_inputs_control__sr_clock;
    output de1_cl_inputs_control__sr_shift;
    output lw_axi_r__valid;
    output [11:0]lw_axi_r__id;
    output [31:0]lw_axi_r__data;
    output [1:0]lw_axi_r__resp;
    output lw_axi_r__last;
    output [3:0]lw_axi_r__user;
    output lw_axi_b__valid;
    output [11:0]lw_axi_b__id;
    output [1:0]lw_axi_b__resp;
    output [3:0]lw_axi_b__user;
    output lw_axi_wready;
    output lw_axi_awready;
    output lw_axi_arready;

// output components here

    //b Output combinatorials
    reg de1_irda_txd;
    reg de1_ps2b_out__data;
    reg de1_ps2b_out__clk;
    reg [9:0]de1_leds__leds;
    reg [6:0]de1_leds__h0;
    reg [6:0]de1_leds__h1;
    reg [6:0]de1_leds__h2;
    reg [6:0]de1_leds__h3;
    reg [6:0]de1_leds__h4;
    reg [6:0]de1_leds__h5;
    reg de1_cl_led_data_pin;

    //b Output nets
    wire de1_cl_inputs_control__sr_clock;
    wire de1_cl_inputs_control__sr_shift;
    wire lw_axi_r__valid;
    wire [11:0]lw_axi_r__id;
    wire [31:0]lw_axi_r__data;
    wire [1:0]lw_axi_r__resp;
    wire lw_axi_r__last;
    wire [3:0]lw_axi_r__user;
    wire lw_axi_b__valid;
    wire [11:0]lw_axi_b__id;
    wire [1:0]lw_axi_b__resp;
    wire [3:0]lw_axi_b__user;
    wire lw_axi_wready;
    wire lw_axi_awready;
    wire lw_axi_arready;

    //b Internal and output registers
    reg [31:0]lcd_counters[3:0];
    reg [3:0]lcd_seconds_sr;
    reg [31:0]vga_counters[3:0];
    reg [3:0]vga_seconds_sr;
    reg [11:0]vga_hsync_counter;
    reg [3:0]vga_vsync_counter;
    reg [31:0]riscv_last_pc;
    reg ps2_in__data;
    reg ps2_in__clk;
    reg [15:0]counter;
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
    reg [15:0]gpio_input;
    reg de1_vga__vs;
    reg de1_vga__hs;
    reg de1_vga__blank_n;
    reg de1_vga__sync_n;
    reg [9:0]de1_vga__red;
    reg [9:0]de1_vga__green;
    reg [9:0]de1_vga__blue;
    reg de1_ps2_out__data;
    reg de1_ps2_out__clk;
    reg de1_cl_lcd__vsync_n;
    reg de1_cl_lcd__hsync_n;
    reg de1_cl_lcd__display_enable;
    reg [5:0]de1_cl_lcd__red;
    reg [6:0]de1_cl_lcd__green;
    reg [5:0]de1_cl_lcd__blue;
    reg de1_cl_lcd__backlight;

    //b Internal combinatorials
    reg fb_sram_access_resp__ack;
    reg fb_sram_access_resp__valid;
    reg [3:0]fb_sram_access_resp__id;
    reg [63:0]fb_sram_access_resp__data;
    reg irqs__nmi;
    reg irqs__meip;
    reg irqs__seip;
    reg irqs__ueip;
    reg irqs__mtip;
    reg irqs__msip;
    reg [63:0]irqs__time;
    reg riscv_config__i32c;
    reg riscv_config__e32;
    reg riscv_config__i32m;
    reg riscv_config__i32m_fuse;
    reg riscv_config__coproc_disable;
    reg riscv_config__unaligned_mem;
    reg fb_display_sram_write__enable;
    reg [47:0]fb_display_sram_write__data;
    reg [15:0]fb_display_sram_write__address;
    reg tt_display_sram_write__enable;
    reg [47:0]tt_display_sram_write__data;
    reg [15:0]tt_display_sram_write__address;
    reg csr_response__acknowledge;
    reg csr_response__read_data_valid;
    reg csr_response__read_data_error;
    reg [31:0]csr_response__read_data;
        //   Ack for dprintf request from APB target
    reg apb_dprintf_ack;
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
    reg [31:0]inputs_apb_request__paddr;
    reg inputs_apb_request__penable;
    reg inputs_apb_request__psel;
    reg inputs_apb_request__pwrite;
    reg [31:0]inputs_apb_request__pwdata;
    reg [31:0]led_chain_apb_request__paddr;
    reg led_chain_apb_request__penable;
    reg led_chain_apb_request__psel;
    reg led_chain_apb_request__pwrite;
    reg [31:0]led_chain_apb_request__pwdata;
    reg [31:0]gpio_apb_request__paddr;
    reg gpio_apb_request__penable;
    reg gpio_apb_request__psel;
    reg gpio_apb_request__pwrite;
    reg [31:0]gpio_apb_request__pwdata;
    reg [31:0]timer_apb_request__paddr;
    reg timer_apb_request__penable;
    reg timer_apb_request__psel;
    reg timer_apb_request__pwrite;
    reg [31:0]timer_apb_request__pwdata;
    reg [3:0]apb_request_sel;

    //b Internal nets
    wire [6:0]de1_hex_leds[5:0];
    wire ps2_out__data;
    wire ps2_out__clk;
    wire fb_sram_access_req__valid;
    wire [3:0]fb_sram_access_req__id;
    wire fb_sram_access_req__read_not_write;
    wire [7:0]fb_sram_access_req__byte_enable;
    wire [31:0]fb_sram_access_req__address;
    wire [63:0]fb_sram_access_req__write_data;
    wire rv_sram_access_resp__ack;
    wire rv_sram_access_resp__valid;
    wire [3:0]rv_sram_access_resp__id;
    wire [63:0]rv_sram_access_resp__data;
    wire rv_sram_access_req__valid;
    wire [3:0]rv_sram_access_req__id;
    wire rv_sram_access_req__read_not_write;
    wire [7:0]rv_sram_access_req__byte_enable;
    wire [31:0]rv_sram_access_req__address;
    wire [63:0]rv_sram_access_req__write_data;
    wire data_access_resp__wait;
    wire [31:0]data_access_resp__read_data;
    wire [31:0]data_access_req__address;
    wire [3:0]data_access_req__byte_enable;
    wire data_access_req__write_enable;
    wire data_access_req__read_enable;
    wire [31:0]data_access_req__write_data;
    wire riscv_trace__instr_valid;
    wire [31:0]riscv_trace__instr_pc;
    wire [2:0]riscv_trace__instruction__mode;
    wire [31:0]riscv_trace__instruction__data;
    wire riscv_trace__rfw_retire;
    wire riscv_trace__rfw_data_valid;
    wire [4:0]riscv_trace__rfw_rd;
    wire [31:0]riscv_trace__rfw_data;
    wire riscv_trace__branch_taken;
    wire [31:0]riscv_trace__branch_target;
    wire riscv_trace__trap;
    wire [39:0]apb_rom_data;
    wire apb_rom_request__enable;
    wire [15:0]apb_rom_request__address;
    wire apb_processor_response__acknowledge;
    wire apb_processor_response__rom_busy;
    wire lcd_video_bus__vsync;
    wire lcd_video_bus__hsync;
    wire lcd_video_bus__display_enable;
    wire [7:0]lcd_video_bus__red;
    wire [7:0]lcd_video_bus__green;
    wire [7:0]lcd_video_bus__blue;
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
    wire tt_lcd_framebuffer_csr_response__acknowledge;
    wire tt_lcd_framebuffer_csr_response__read_data_valid;
    wire tt_lcd_framebuffer_csr_response__read_data_error;
    wire [31:0]tt_lcd_framebuffer_csr_response__read_data;
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
    wire gpio_input_event;
    wire [15:0]gpio_output_enable;
    wire [15:0]gpio_output;
    wire [2:0]timer_equalled;
    wire led_chain;
        //   
    wire de1_cl_user_inputs__updated_switches;
    wire de1_cl_user_inputs__diamond__a;
    wire de1_cl_user_inputs__diamond__b;
    wire de1_cl_user_inputs__diamond__x;
    wire de1_cl_user_inputs__diamond__y;
    wire de1_cl_user_inputs__joystick__u;
    wire de1_cl_user_inputs__joystick__d;
    wire de1_cl_user_inputs__joystick__l;
    wire de1_cl_user_inputs__joystick__r;
    wire de1_cl_user_inputs__joystick__c;
    wire de1_cl_user_inputs__left_dial__pressed;
    wire de1_cl_user_inputs__left_dial__direction;
    wire de1_cl_user_inputs__left_dial__direction_pulse;
    wire de1_cl_user_inputs__right_dial__pressed;
    wire de1_cl_user_inputs__right_dial__direction;
    wire de1_cl_user_inputs__right_dial__direction_pulse;
    wire de1_cl_user_inputs__touchpanel_irq;
    wire de1_cl_user_inputs__temperature_alarm;
    wire [31:0]riscv_apb_response__prdata;
    wire riscv_apb_response__pready;
    wire riscv_apb_response__perr;
    wire [31:0]proc_apb_response__prdata;
    wire proc_apb_response__pready;
    wire proc_apb_response__perr;
    wire [31:0]axi_apb_response__prdata;
    wire axi_apb_response__pready;
    wire axi_apb_response__perr;
    wire [31:0]rp_apb_response__prdata;
    wire rp_apb_response__pready;
    wire rp_apb_response__perr;
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
    wire [31:0]inputs_apb_response__prdata;
    wire inputs_apb_response__pready;
    wire inputs_apb_response__perr;
    wire [31:0]led_chain_apb_response__prdata;
    wire led_chain_apb_response__pready;
    wire led_chain_apb_response__perr;
    wire [31:0]gpio_apb_response__prdata;
    wire gpio_apb_response__pready;
    wire gpio_apb_response__perr;
    wire [31:0]timer_apb_response__prdata;
    wire timer_apb_response__pready;
    wire timer_apb_response__perr;
    wire [31:0]apb_request__paddr;
    wire apb_request__penable;
    wire apb_request__psel;
    wire apb_request__pwrite;
    wire [31:0]apb_request__pwdata;
    wire [31:0]rp_apb_request__paddr;
    wire rp_apb_request__penable;
    wire rp_apb_request__psel;
    wire rp_apb_request__pwrite;
    wire [31:0]rp_apb_request__pwdata;
    wire [31:0]proc_apb_request__paddr;
    wire proc_apb_request__penable;
    wire proc_apb_request__psel;
    wire proc_apb_request__pwrite;
    wire [31:0]proc_apb_request__pwdata;
    wire [31:0]axi_apb_request__paddr;
    wire axi_apb_request__penable;
    wire axi_apb_request__psel;
    wire axi_apb_request__pwrite;
    wire [31:0]axi_apb_request__pwdata;
    wire [31:0]riscv_apb_request__paddr;
    wire riscv_apb_request__penable;
    wire riscv_apb_request__psel;
    wire riscv_apb_request__pwrite;
    wire [31:0]riscv_apb_request__pwdata;

    //b Clock gating module instances
    //b Module instances
    riscv_i32_minimal riscv(
        .clk(lw_axi_clock_clk),
        .clk__enable(1'b1),
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .sram_access_req__write_data(rv_sram_access_req__write_data),
        .sram_access_req__address(rv_sram_access_req__address),
        .sram_access_req__byte_enable(rv_sram_access_req__byte_enable),
        .sram_access_req__read_not_write(rv_sram_access_req__read_not_write),
        .sram_access_req__id(rv_sram_access_req__id),
        .sram_access_req__valid(rv_sram_access_req__valid),
        .data_access_resp__read_data(data_access_resp__read_data),
        .data_access_resp__wait(data_access_resp__wait),
        .irqs__time(irqs__time),
        .irqs__msip(irqs__msip),
        .irqs__mtip(irqs__mtip),
        .irqs__ueip(irqs__ueip),
        .irqs__seip(irqs__seip),
        .irqs__meip(irqs__meip),
        .irqs__nmi(irqs__nmi),
        .reset_n(reset_n),
        .proc_reset_n((reset_n & rv_sram_ctrl[0])),
        .trace__trap(            riscv_trace__trap),
        .trace__branch_target(            riscv_trace__branch_target),
        .trace__branch_taken(            riscv_trace__branch_taken),
        .trace__rfw_data(            riscv_trace__rfw_data),
        .trace__rfw_rd(            riscv_trace__rfw_rd),
        .trace__rfw_data_valid(            riscv_trace__rfw_data_valid),
        .trace__rfw_retire(            riscv_trace__rfw_retire),
        .trace__instruction__data(            riscv_trace__instruction__data),
        .trace__instruction__mode(            riscv_trace__instruction__mode),
        .trace__instr_pc(            riscv_trace__instr_pc),
        .trace__instr_valid(            riscv_trace__instr_valid),
        .sram_access_resp__data(            rv_sram_access_resp__data),
        .sram_access_resp__id(            rv_sram_access_resp__id),
        .sram_access_resp__valid(            rv_sram_access_resp__valid),
        .sram_access_resp__ack(            rv_sram_access_resp__ack),
        .data_access_req__write_data(            data_access_req__write_data),
        .data_access_req__read_enable(            data_access_req__read_enable),
        .data_access_req__write_enable(            data_access_req__write_enable),
        .data_access_req__byte_enable(            data_access_req__byte_enable),
        .data_access_req__address(            data_access_req__address)         );
    riscv_i32_trace trace(
        .clk(lw_axi_clock_clk),
        .clk__enable(1'b1),
        .trace__trap(riscv_trace__trap),
        .trace__branch_target(riscv_trace__branch_target),
        .trace__branch_taken(riscv_trace__branch_taken),
        .trace__rfw_data(riscv_trace__rfw_data),
        .trace__rfw_rd(riscv_trace__rfw_rd),
        .trace__rfw_data_valid(riscv_trace__rfw_data_valid),
        .trace__rfw_retire(riscv_trace__rfw_retire),
        .trace__instruction__data(riscv_trace__instruction__data),
        .trace__instruction__mode(riscv_trace__instruction__mode),
        .trace__instr_pc(riscv_trace__instr_pc),
        .trace__instr_valid(riscv_trace__instr_valid),
        .reset_n(reset_n)         );
    riscv_i32_minimal_apb rv_apb(
        .clk(lw_axi_clock_clk),
        .clk__enable(1'b1),
        .apb_response__perr(riscv_apb_response__perr),
        .apb_response__pready(riscv_apb_response__pready),
        .apb_response__prdata(riscv_apb_response__prdata),
        .data_access_req__write_data(data_access_req__write_data),
        .data_access_req__read_enable(data_access_req__read_enable),
        .data_access_req__write_enable(data_access_req__write_enable),
        .data_access_req__byte_enable(data_access_req__byte_enable),
        .data_access_req__address(data_access_req__address),
        .reset_n(reset_n),
        .apb_request__pwdata(            riscv_apb_request__pwdata),
        .apb_request__pwrite(            riscv_apb_request__pwrite),
        .apb_request__psel(            riscv_apb_request__psel),
        .apb_request__penable(            riscv_apb_request__penable),
        .apb_request__paddr(            riscv_apb_request__paddr),
        .data_access_resp__read_data(            data_access_resp__read_data),
        .data_access_resp__wait(            data_access_resp__wait)         );
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
    apb_master_axi apbm(
        .aclk(lw_axi_clock_clk),
        .aclk__enable(1'b1),
        .apb_response__perr(axi_apb_response__perr),
        .apb_response__pready(axi_apb_response__pready),
        .apb_response__prdata(axi_apb_response__prdata),
        .rready(lw_axi_rready),
        .bready(lw_axi_bready),
        .w__user(lw_axi_w__user),
        .w__last(lw_axi_w__last),
        .w__strb(lw_axi_w__strb),
        .w__data(lw_axi_w__data),
        .w__id(lw_axi_w__id),
        .w__valid(lw_axi_w__valid),
        .aw__user(lw_axi_aw__user),
        .aw__region(lw_axi_aw__region),
        .aw__qos(lw_axi_aw__qos),
        .aw__prot(lw_axi_aw__prot),
        .aw__cache(lw_axi_aw__cache),
        .aw__lock(lw_axi_aw__lock),
        .aw__burst(lw_axi_aw__burst),
        .aw__size(lw_axi_aw__size),
        .aw__len(lw_axi_aw__len),
        .aw__addr(lw_axi_aw__addr),
        .aw__id(lw_axi_aw__id),
        .aw__valid(lw_axi_aw__valid),
        .ar__user(lw_axi_ar__user),
        .ar__region(lw_axi_ar__region),
        .ar__qos(lw_axi_ar__qos),
        .ar__prot(lw_axi_ar__prot),
        .ar__cache(lw_axi_ar__cache),
        .ar__lock(lw_axi_ar__lock),
        .ar__burst(lw_axi_ar__burst),
        .ar__size(lw_axi_ar__size),
        .ar__len(lw_axi_ar__len),
        .ar__addr(lw_axi_ar__addr),
        .ar__id(lw_axi_ar__id),
        .ar__valid(lw_axi_ar__valid),
        .areset_n(reset_n),
        .apb_request__pwdata(            axi_apb_request__pwdata),
        .apb_request__pwrite(            axi_apb_request__pwrite),
        .apb_request__psel(            axi_apb_request__psel),
        .apb_request__penable(            axi_apb_request__penable),
        .apb_request__paddr(            axi_apb_request__paddr),
        .r__user(            lw_axi_r__user),
        .r__last(            lw_axi_r__last),
        .r__resp(            lw_axi_r__resp),
        .r__data(            lw_axi_r__data),
        .r__id(            lw_axi_r__id),
        .r__valid(            lw_axi_r__valid),
        .b__user(            lw_axi_b__user),
        .b__resp(            lw_axi_b__resp),
        .b__id(            lw_axi_b__id),
        .b__valid(            lw_axi_b__valid),
        .wready(            lw_axi_wready),
        .awready(            lw_axi_awready),
        .arready(            lw_axi_arready)         );
    apb_master_mux apb_mux_rp(
        .clk(lw_axi_clock_clk),
        .clk__enable(1'b1),
        .apb_response__perr(rp_apb_response__perr),
        .apb_response__pready(rp_apb_response__pready),
        .apb_response__prdata(rp_apb_response__prdata),
        .apb_request_1__pwdata(proc_apb_request__pwdata),
        .apb_request_1__pwrite(proc_apb_request__pwrite),
        .apb_request_1__psel(proc_apb_request__psel),
        .apb_request_1__penable(proc_apb_request__penable),
        .apb_request_1__paddr(proc_apb_request__paddr),
        .apb_request_0__pwdata(riscv_apb_request__pwdata),
        .apb_request_0__pwrite(riscv_apb_request__pwrite),
        .apb_request_0__psel(riscv_apb_request__psel),
        .apb_request_0__penable(riscv_apb_request__penable),
        .apb_request_0__paddr(riscv_apb_request__paddr),
        .reset_n(reset_n),
        .apb_request__pwdata(            rp_apb_request__pwdata),
        .apb_request__pwrite(            rp_apb_request__pwrite),
        .apb_request__psel(            rp_apb_request__psel),
        .apb_request__penable(            rp_apb_request__penable),
        .apb_request__paddr(            rp_apb_request__paddr),
        .apb_response_1__perr(            proc_apb_response__perr),
        .apb_response_1__pready(            proc_apb_response__pready),
        .apb_response_1__prdata(            proc_apb_response__prdata),
        .apb_response_0__perr(            riscv_apb_response__perr),
        .apb_response_0__pready(            riscv_apb_response__pready),
        .apb_response_0__prdata(            riscv_apb_response__prdata)         );
    apb_master_mux apb_mux_ap(
        .clk(lw_axi_clock_clk),
        .clk__enable(1'b1),
        .apb_response__perr(apb_response__perr),
        .apb_response__pready(apb_response__pready),
        .apb_response__prdata(apb_response__prdata),
        .apb_request_1__pwdata(rp_apb_request__pwdata),
        .apb_request_1__pwrite(rp_apb_request__pwrite),
        .apb_request_1__psel(rp_apb_request__psel),
        .apb_request_1__penable(rp_apb_request__penable),
        .apb_request_1__paddr(rp_apb_request__paddr),
        .apb_request_0__pwdata(axi_apb_request__pwdata),
        .apb_request_0__pwrite(axi_apb_request__pwrite),
        .apb_request_0__psel(axi_apb_request__psel),
        .apb_request_0__penable(axi_apb_request__penable),
        .apb_request_0__paddr(axi_apb_request__paddr),
        .reset_n(reset_n),
        .apb_request__pwdata(            apb_request__pwdata),
        .apb_request__pwrite(            apb_request__pwrite),
        .apb_request__psel(            apb_request__psel),
        .apb_request__penable(            apb_request__penable),
        .apb_request__paddr(            apb_request__paddr),
        .apb_response_1__perr(            rp_apb_response__perr),
        .apb_response_1__pready(            rp_apb_response__pready),
        .apb_response_1__prdata(            rp_apb_response__prdata),
        .apb_response_0__perr(            axi_apb_response__perr),
        .apb_response_0__pready(            axi_apb_response__pready),
        .apb_response_0__prdata(            axi_apb_response__prdata)         );
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
        .clk(lw_axi_clock_clk),
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
    apb_target_timer timer(
        .clk(lw_axi_clock_clk),
        .clk__enable(1'b1),
        .apb_request__pwdata(timer_apb_request__pwdata),
        .apb_request__pwrite(timer_apb_request__pwrite),
        .apb_request__psel(timer_apb_request__psel),
        .apb_request__penable(timer_apb_request__penable),
        .apb_request__paddr(timer_apb_request__paddr),
        .reset_n(reset_n),
        .timer_equalled(            timer_equalled),
        .apb_response__perr(            timer_apb_response__perr),
        .apb_response__pready(            timer_apb_response__pready),
        .apb_response__prdata(            timer_apb_response__prdata)         );
    apb_target_gpio gpio(
        .clk(lw_axi_clock_clk),
        .clk__enable(1'b1),
        .gpio_input(gpio_input),
        .apb_request__pwdata(gpio_apb_request__pwdata),
        .apb_request__pwrite(gpio_apb_request__pwrite),
        .apb_request__psel(gpio_apb_request__psel),
        .apb_request__penable(gpio_apb_request__penable),
        .apb_request__paddr(gpio_apb_request__paddr),
        .reset_n(reset_n),
        .gpio_input_event(            gpio_input_event),
        .gpio_output_enable(            gpio_output_enable),
        .gpio_output(            gpio_output),
        .apb_response__perr(            gpio_apb_response__perr),
        .apb_response__pready(            gpio_apb_response__pready),
        .apb_response__prdata(            gpio_apb_response__prdata)         );
    apb_target_led_ws2812 led_ws2812(
        .clk(lw_axi_clock_clk),
        .clk__enable(1'b1),
        .divider_400ns_in(8'h13),
        .apb_request__pwdata(led_chain_apb_request__pwdata),
        .apb_request__pwrite(led_chain_apb_request__pwrite),
        .apb_request__psel(led_chain_apb_request__psel),
        .apb_request__penable(led_chain_apb_request__penable),
        .apb_request__paddr(led_chain_apb_request__paddr),
        .reset_n(reset_n),
        .led_chain(            led_chain),
        .apb_response__perr(            led_chain_apb_response__perr),
        .apb_response__pready(            led_chain_apb_response__pready),
        .apb_response__prdata(            led_chain_apb_response__prdata)         );
    apb_target_de1_cl_inputs de1_cl_inputs(
        .clk(lw_axi_clock_clk),
        .clk__enable(1'b1),
        .user_inputs__temperature_alarm(de1_cl_user_inputs__temperature_alarm),
        .user_inputs__touchpanel_irq(de1_cl_user_inputs__touchpanel_irq),
        .user_inputs__right_dial__direction_pulse(de1_cl_user_inputs__right_dial__direction_pulse),
        .user_inputs__right_dial__direction(de1_cl_user_inputs__right_dial__direction),
        .user_inputs__right_dial__pressed(de1_cl_user_inputs__right_dial__pressed),
        .user_inputs__left_dial__direction_pulse(de1_cl_user_inputs__left_dial__direction_pulse),
        .user_inputs__left_dial__direction(de1_cl_user_inputs__left_dial__direction),
        .user_inputs__left_dial__pressed(de1_cl_user_inputs__left_dial__pressed),
        .user_inputs__joystick__c(de1_cl_user_inputs__joystick__c),
        .user_inputs__joystick__r(de1_cl_user_inputs__joystick__r),
        .user_inputs__joystick__l(de1_cl_user_inputs__joystick__l),
        .user_inputs__joystick__d(de1_cl_user_inputs__joystick__d),
        .user_inputs__joystick__u(de1_cl_user_inputs__joystick__u),
        .user_inputs__diamond__y(de1_cl_user_inputs__diamond__y),
        .user_inputs__diamond__x(de1_cl_user_inputs__diamond__x),
        .user_inputs__diamond__b(de1_cl_user_inputs__diamond__b),
        .user_inputs__diamond__a(de1_cl_user_inputs__diamond__a),
        .user_inputs__updated_switches(de1_cl_user_inputs__updated_switches),
        .apb_request__pwdata(inputs_apb_request__pwdata),
        .apb_request__pwrite(inputs_apb_request__pwrite),
        .apb_request__psel(inputs_apb_request__psel),
        .apb_request__penable(inputs_apb_request__penable),
        .apb_request__paddr(inputs_apb_request__paddr),
        .reset_n(reset_n),
        .apb_response__perr(            inputs_apb_response__perr),
        .apb_response__pready(            inputs_apb_response__pready),
        .apb_response__prdata(            inputs_apb_response__prdata)         );
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
        .clk(lw_axi_clock_clk),
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
    framebuffer_teletext ftb_lcd(
        .video_clk(de1_cl_lcd_clock),
        .video_clk__enable(1'b1),
        .sram_clk(lw_axi_clock_clk),
        .sram_clk__enable(1'b1),
        .csr_clk(lw_axi_clock_clk),
        .csr_clk__enable(1'b1),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .csr_select_in(16'h2),
        .display_sram_write__address(tt_display_sram_write__address),
        .display_sram_write__data(tt_display_sram_write__data),
        .display_sram_write__enable(tt_display_sram_write__enable),
        .reset_n(reset_n),
        .csr_response__read_data(            tt_lcd_framebuffer_csr_response__read_data),
        .csr_response__read_data_error(            tt_lcd_framebuffer_csr_response__read_data_error),
        .csr_response__read_data_valid(            tt_lcd_framebuffer_csr_response__read_data_valid),
        .csr_response__acknowledge(            tt_lcd_framebuffer_csr_response__acknowledge),
        .video_bus__blue(            lcd_video_bus__blue),
        .video_bus__green(            lcd_video_bus__green),
        .video_bus__red(            lcd_video_bus__red),
        .video_bus__display_enable(            lcd_video_bus__display_enable),
        .video_bus__hsync(            lcd_video_bus__hsync),
        .video_bus__vsync(            lcd_video_bus__vsync)         );
    framebuffer_teletext ftb_vga(
        .video_clk(de1_vga_clock),
        .video_clk__enable(1'b1),
        .sram_clk(lw_axi_clock_clk),
        .sram_clk__enable(1'b1),
        .csr_clk(lw_axi_clock_clk),
        .csr_clk__enable(1'b1),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .csr_select_in(16'h4),
        .display_sram_write__address(fb_display_sram_write__address),
        .display_sram_write__data(fb_display_sram_write__data),
        .display_sram_write__enable(fb_display_sram_write__enable),
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
        .clk(lw_axi_clock_clk),
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
        .hex(riscv_last_pc[3:0]),
        .leds(            de1_hex_leds[0])         );
    led_seven_segment h___1(
        .hex(riscv_last_pc[7:4]),
        .leds(            de1_hex_leds[1])         );
    led_seven_segment h___2(
        .hex(riscv_last_pc[11:8]),
        .leds(            de1_hex_leds[2])         );
    led_seven_segment h___3(
        .hex(riscv_last_pc[15:12]),
        .leds(            de1_hex_leds[3])         );
    led_seven_segment h___4(
        .hex(riscv_last_pc[19:16]),
        .leds(            de1_hex_leds[4])         );
    led_seven_segment h___5(
        .hex(riscv_last_pc[23:20]),
        .leds(            de1_hex_leds[5])         );
    de1_cl_controls input_ctls(
        .clk(clk),
        .clk__enable(1'b1),
        .sr_divider(8'h31),
        .inputs_status__right_rotary__transition_pin(de1_cl_inputs_status__right_rotary__transition_pin),
        .inputs_status__right_rotary__direction_pin(de1_cl_inputs_status__right_rotary__direction_pin),
        .inputs_status__left_rotary__transition_pin(de1_cl_inputs_status__left_rotary__transition_pin),
        .inputs_status__left_rotary__direction_pin(de1_cl_inputs_status__left_rotary__direction_pin),
        .inputs_status__sr_data(de1_cl_inputs_status__sr_data),
        .reset_n(reset_n),
        .user_inputs__temperature_alarm(            de1_cl_user_inputs__temperature_alarm),
        .user_inputs__touchpanel_irq(            de1_cl_user_inputs__touchpanel_irq),
        .user_inputs__right_dial__direction_pulse(            de1_cl_user_inputs__right_dial__direction_pulse),
        .user_inputs__right_dial__direction(            de1_cl_user_inputs__right_dial__direction),
        .user_inputs__right_dial__pressed(            de1_cl_user_inputs__right_dial__pressed),
        .user_inputs__left_dial__direction_pulse(            de1_cl_user_inputs__left_dial__direction_pulse),
        .user_inputs__left_dial__direction(            de1_cl_user_inputs__left_dial__direction),
        .user_inputs__left_dial__pressed(            de1_cl_user_inputs__left_dial__pressed),
        .user_inputs__joystick__c(            de1_cl_user_inputs__joystick__c),
        .user_inputs__joystick__r(            de1_cl_user_inputs__joystick__r),
        .user_inputs__joystick__l(            de1_cl_user_inputs__joystick__l),
        .user_inputs__joystick__d(            de1_cl_user_inputs__joystick__d),
        .user_inputs__joystick__u(            de1_cl_user_inputs__joystick__u),
        .user_inputs__diamond__y(            de1_cl_user_inputs__diamond__y),
        .user_inputs__diamond__x(            de1_cl_user_inputs__diamond__x),
        .user_inputs__diamond__b(            de1_cl_user_inputs__diamond__b),
        .user_inputs__diamond__a(            de1_cl_user_inputs__diamond__a),
        .user_inputs__updated_switches(            de1_cl_user_inputs__updated_switches),
        .inputs_control__sr_shift(            de1_cl_inputs_control__sr_shift),
        .inputs_control__sr_clock(            de1_cl_inputs_control__sr_clock)         );
    //b riscv_instance combinatorial process
    always @ ( * )//riscv_instance
    begin: riscv_instance__comb_code
    reg riscv_config__i32c__var;
    reg riscv_config__e32__var;
        riscv_config__i32c__var = 1'h0;
        riscv_config__e32__var = 1'h0;
        riscv_config__i32m = 1'h0;
        riscv_config__i32m_fuse = 1'h0;
        riscv_config__coproc_disable = 1'h0;
        riscv_config__unaligned_mem = 1'h0;
        riscv_config__e32__var = 1'h0;
        riscv_config__i32c__var = 1'h1;
        irqs__nmi = 1'h0;
        irqs__meip = 1'h0;
        irqs__seip = 1'h0;
        irqs__ueip = 1'h0;
        irqs__mtip = 1'h0;
        irqs__msip = 1'h0;
        irqs__time = 64'h0;
        riscv_config__i32c = riscv_config__i32c__var;
        riscv_config__e32 = riscv_config__e32__var;
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
    reg [31:0]gpio_apb_request__paddr__var;
    reg gpio_apb_request__psel__var;
    reg [31:0]led_chain_apb_request__paddr__var;
    reg led_chain_apb_request__psel__var;
    reg [31:0]inputs_apb_request__paddr__var;
    reg inputs_apb_request__psel__var;
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
        apb_request_sel = apb_request__paddr[19:16];
        timer_apb_request__paddr__var = apb_request__paddr;
        timer_apb_request__penable = apb_request__penable;
        timer_apb_request__psel__var = apb_request__psel;
        timer_apb_request__pwrite = apb_request__pwrite;
        timer_apb_request__pwdata = apb_request__pwdata;
        gpio_apb_request__paddr__var = apb_request__paddr;
        gpio_apb_request__penable = apb_request__penable;
        gpio_apb_request__psel__var = apb_request__psel;
        gpio_apb_request__pwrite = apb_request__pwrite;
        gpio_apb_request__pwdata = apb_request__pwdata;
        led_chain_apb_request__paddr__var = apb_request__paddr;
        led_chain_apb_request__penable = apb_request__penable;
        led_chain_apb_request__psel__var = apb_request__psel;
        led_chain_apb_request__pwrite = apb_request__pwrite;
        led_chain_apb_request__pwdata = apb_request__pwdata;
        inputs_apb_request__paddr__var = apb_request__paddr;
        inputs_apb_request__penable = apb_request__penable;
        inputs_apb_request__psel__var = apb_request__psel;
        inputs_apb_request__pwrite = apb_request__pwrite;
        inputs_apb_request__pwdata = apb_request__pwdata;
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
        gpio_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        led_chain_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        inputs_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        dprintf_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        rv_sram_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        fb_sram_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        ps2_apb_request__paddr__var = (apb_request__paddr>>64'h2);
        timer_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h0));
        gpio_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h1));
        dprintf_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h2));
        csr_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h3));
        rv_sram_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h4));
        led_chain_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h5));
        inputs_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h6));
        fb_sram_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h7));
        ps2_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request_sel==4'h8));
        csr_apb_request__paddr__var[31:16] = {12'h0,apb_request__paddr[15:12]};
        csr_apb_request__paddr__var[15:0] = {6'h0,apb_request__paddr[11:2]};
        apb_response__prdata__var = timer_apb_response__prdata;
        apb_response__pready__var = timer_apb_response__pready;
        apb_response__perr__var = timer_apb_response__perr;
        if ((apb_request_sel==4'h1))
        begin
            apb_response__prdata__var = gpio_apb_response__prdata;
            apb_response__pready__var = gpio_apb_response__pready;
            apb_response__perr__var = gpio_apb_response__perr;
        end //if
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
        if ((apb_request_sel==4'h5))
        begin
            apb_response__prdata__var = led_chain_apb_response__prdata;
            apb_response__pready__var = led_chain_apb_response__pready;
            apb_response__perr__var = led_chain_apb_response__perr;
        end //if
        if ((apb_request_sel==4'h6))
        begin
            apb_response__prdata__var = inputs_apb_response__prdata;
            apb_response__pready__var = inputs_apb_response__pready;
            apb_response__perr__var = inputs_apb_response__perr;
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
        timer_apb_request__paddr = timer_apb_request__paddr__var;
        timer_apb_request__psel = timer_apb_request__psel__var;
        gpio_apb_request__paddr = gpio_apb_request__paddr__var;
        gpio_apb_request__psel = gpio_apb_request__psel__var;
        led_chain_apb_request__paddr = led_chain_apb_request__paddr__var;
        led_chain_apb_request__psel = led_chain_apb_request__psel__var;
        inputs_apb_request__paddr = inputs_apb_request__paddr__var;
        inputs_apb_request__psel = inputs_apb_request__psel__var;
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
            if ((lw_axi_ar__valid!=1'h0))
            begin
                dprintf_req__valid[1] <= 1'h1;
                dprintf_req__address[1] <= 16'h28;
                dprintf_req__data_0[1] <= {{36'h41523a830,lw_axi_ar__id},16'h2087};
                dprintf_req__data_1[1] <= {{{{lw_axi_ar__addr,16'h2080},4'h0},lw_axi_ar__len},8'h20};
                dprintf_req__data_2[1] <= {{{{{{{8'h80,5'h0},lw_axi_ar__size},16'h2080},6'h0},lw_axi_ar__burst},8'hff},16'h0};
            end //if
            if ((lw_axi_aw__valid!=1'h0))
            begin
                dprintf_req__valid[2] <= 1'h1;
                dprintf_req__address[2] <= 16'h50;
                dprintf_req__data_0[2] <= {{36'h41573a830,lw_axi_aw__id},16'h2087};
                dprintf_req__data_1[2] <= {{{{lw_axi_aw__addr,16'h2080},4'h0},lw_axi_aw__len},8'h20};
                dprintf_req__data_2[2] <= {{{{{{{8'h80,5'h0},lw_axi_aw__size},16'h2080},6'h0},lw_axi_aw__burst},8'hff},16'h0};
            end //if
            if ((lw_axi_w__valid!=1'h0))
            begin
                dprintf_req__valid[3] <= 1'h1;
                dprintf_req__address[3] <= 16'h78;
                dprintf_req__data_0[3] <= {{36'h20573a830,lw_axi_w__id},16'h2087};
                dprintf_req__data_1[3] <= {{{{lw_axi_w__data,16'h2080},4'h0},lw_axi_w__strb},8'h20};
                dprintf_req__data_2[3] <= {{{{8'h80,7'h0},lw_axi_w__last},8'hff},40'h0};
            end //if
            if ((lw_axi_b__valid!=1'h0))
            begin
                dprintf_req__valid[4] <= 1'h1;
                dprintf_req__address[4] <= 16'ha0;
                dprintf_req__data_0[4] <= {{36'h20423a830,lw_axi_b__id},16'h2080};
                dprintf_req__data_1[4] <= {{{6'h0,lw_axi_b__resp},8'hff},48'h0};
            end //if
            if ((lw_axi_r__valid!=1'h0))
            begin
                dprintf_req__valid[5] <= 1'h1;
                dprintf_req__address[5] <= 16'hc8;
                dprintf_req__data_0[5] <= {{36'h20523a830,lw_axi_b__id},16'h2087};
                dprintf_req__data_1[5] <= {{{{lw_axi_r__data,16'h2080},6'h0},lw_axi_r__resp},8'h20};
                dprintf_req__data_2[5] <= {{{{8'h80,7'h0},lw_axi_w__last},8'hff},40'h0};
            end //if
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
            if ((riscv_trace__instr_valid!=1'h0))
            begin
                dprintf_req__valid[9] <= 1'h1;
                dprintf_req__address[9] <= 16'h168;
                dprintf_req__data_0[9] <= {32'h5256493a,32'h87};
                dprintf_req__data_1[9] <= {riscv_trace__instr_pc,32'h200087};
                dprintf_req__data_2[9] <= {{riscv_trace__instruction__data,8'hff},24'h0};
            end //if
            if ((riscv_apb_request__psel!=1'h0))
            begin
                dprintf_req__valid[10] <= 1'h1;
                dprintf_req__address[10] <= 16'h190;
                dprintf_req__data_0[10] <= {{{40'h4150423a80,7'h0},riscv_apb_request__pwrite},16'h2087};
                dprintf_req__data_1[10] <= {riscv_apb_request__paddr,32'h20000087};
                dprintf_req__data_2[10] <= {{riscv_apb_request__pwdata,8'hff},24'h0};
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
            if ((divider_reset!=1'h0))
            begin
                dprintf_req__valid[12] <= 1'h1;
                dprintf_req__address[12] <= 16'h1e0;
                dprintf_req__data_0[12] <= {32'h4c43443a,32'h87};
                dprintf_req__data_1[12] <= {lcd_counters[0],32'h20000087};
                dprintf_req__data_2[12] <= {lcd_counters[1],32'h20000087};
                dprintf_req__data_3[12] <= {{lcd_counters[2],8'hff},24'h0};
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
            ps2_in__data <= de1_ps2_in__data;
            ps2_in__clk <= de1_ps2_in__clk;
        end //if
    end //always

    //b dprintf_framebuffer_instances__comb combinatorial process
    always @ ( * )//dprintf_framebuffer_instances__comb
    begin: dprintf_framebuffer_instances__comb_code
    reg fb_sram_access_resp__ack__var;
    reg fb_sram_access_resp__valid__var;
    reg [3:0]fb_sram_access_resp__id__var;
    reg csr_response__acknowledge__var;
    reg csr_response__read_data_valid__var;
    reg csr_response__read_data_error__var;
    reg [31:0]csr_response__read_data__var;
        tt_display_sram_write__enable = dprintf_byte__valid;
        tt_display_sram_write__address = dprintf_byte__address;
        tt_display_sram_write__data = {40'h0,dprintf_byte__data};
        fb_display_sram_write__enable = ((fb_sram_access_req__valid!=1'h0)&&!(fb_sram_access_req__read_not_write!=1'h0));
        fb_display_sram_write__address = fb_sram_access_req__address[15:0];
        fb_display_sram_write__data = {40'h0,fb_sram_access_req__write_data[7:0]};
        fb_sram_access_resp__ack__var = 1'h0;
        fb_sram_access_resp__valid__var = 1'h0;
        fb_sram_access_resp__id__var = 4'h0;
        fb_sram_access_resp__data = 64'h0;
        fb_sram_access_resp__ack__var = fb_sram_access_req__valid;
        fb_sram_access_resp__valid__var = fb_sram_access_req__valid;
        fb_sram_access_resp__id__var = fb_sram_access_req__id;
        csr_response__acknowledge__var = tt_vga_framebuffer_csr_response__acknowledge;
        csr_response__read_data_valid__var = tt_vga_framebuffer_csr_response__read_data_valid;
        csr_response__read_data_error__var = tt_vga_framebuffer_csr_response__read_data_error;
        csr_response__read_data__var = tt_vga_framebuffer_csr_response__read_data;
        csr_response__acknowledge__var = csr_response__acknowledge__var | tt_lcd_framebuffer_csr_response__acknowledge;
        csr_response__read_data_valid__var = csr_response__read_data_valid__var | tt_lcd_framebuffer_csr_response__read_data_valid;
        csr_response__read_data_error__var = csr_response__read_data_error__var | tt_lcd_framebuffer_csr_response__read_data_error;
        csr_response__read_data__var = csr_response__read_data__var | tt_lcd_framebuffer_csr_response__read_data;
        csr_response__acknowledge__var = csr_response__acknowledge__var | timeout_csr_response__acknowledge;
        csr_response__read_data_valid__var = csr_response__read_data_valid__var | timeout_csr_response__read_data_valid;
        csr_response__read_data_error__var = csr_response__read_data_error__var | timeout_csr_response__read_data_error;
        csr_response__read_data__var = csr_response__read_data__var | timeout_csr_response__read_data;
        fb_sram_access_resp__ack = fb_sram_access_resp__ack__var;
        fb_sram_access_resp__valid = fb_sram_access_resp__valid__var;
        fb_sram_access_resp__id = fb_sram_access_resp__id__var;
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

    //b dprintf_framebuffer_instances__posedge_de1_vga_clock_active_low_de1_vga_reset_n clock process
    always @( posedge de1_vga_clock or negedge de1_vga_reset_n)
    begin : dprintf_framebuffer_instances__posedge_de1_vga_clock_active_low_de1_vga_reset_n__code
        if (de1_vga_reset_n==1'b0)
        begin
            de1_vga__hs <= 1'h0;
            vga_hsync_counter <= 12'h0;
            de1_vga__vs <= 1'h0;
            vga_vsync_counter <= 4'h0;
            de1_vga__blank_n <= 1'h0;
            de1_vga__sync_n <= 1'h0;
            de1_vga__red <= 10'h0;
            de1_vga__green <= 10'h0;
            de1_vga__blue <= 10'h0;
            vga_counters[0] <= 32'h0;
            vga_counters[1] <= 32'h0;
            vga_counters[2] <= 32'h0;
            vga_counters[3] <= 32'h0;
            vga_seconds_sr <= 4'h0;
        end
        else if (de1_vga_clock__enable)
        begin
            de1_vga__hs <= 1'h1;
            if ((vga_hsync_counter!=12'h0))
            begin
                de1_vga__hs <= 1'h0;
                vga_hsync_counter <= (vga_hsync_counter-12'h1);
            end //if
            if ((vga_video_bus__hsync!=1'h0))
            begin
                de1_vga__hs <= 1'h0;
                vga_hsync_counter <= 12'h6e;
                de1_vga__vs <= 1'h1;
                if ((vga_vsync_counter!=4'h0))
                begin
                    de1_vga__vs <= 1'h0;
                    vga_vsync_counter <= (vga_vsync_counter-4'h1);
                end //if
            end //if
            if ((vga_video_bus__vsync!=1'h0))
            begin
                de1_vga__vs <= 1'h0;
                vga_vsync_counter <= 4'h1;
            end //if
            de1_vga__blank_n <= vga_video_bus__display_enable;
            de1_vga__sync_n <= (de1_vga__vs & de1_vga__hs);
            if ((de1_switches[9]!=1'h0))
            begin
                de1_vga__sync_n <= de1_switches[8];
            end //if
            de1_vga__red <= {vga_video_bus__red[7:0],2'h0};
            de1_vga__green <= {vga_video_bus__green[7:0],2'h0};
            de1_vga__blue <= {vga_video_bus__blue[7:0],2'h0};
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

    //b dprintf_framebuffer_instances__posedge_de1_cl_lcd_clock_active_low_de1_cl_lcd_reset_n clock process
    always @( posedge de1_cl_lcd_clock or negedge de1_cl_lcd_reset_n)
    begin : dprintf_framebuffer_instances__posedge_de1_cl_lcd_clock_active_low_de1_cl_lcd_reset_n__code
        if (de1_cl_lcd_reset_n==1'b0)
        begin
            lcd_seconds_sr <= 4'h0;
            de1_cl_lcd__vsync_n <= 1'h0;
            de1_cl_lcd__hsync_n <= 1'h0;
            de1_cl_lcd__display_enable <= 1'h0;
            de1_cl_lcd__red <= 6'h0;
            de1_cl_lcd__green <= 7'h0;
            de1_cl_lcd__blue <= 6'h0;
            de1_cl_lcd__backlight <= 1'h0;
            lcd_counters[0] <= 32'h0;
            lcd_counters[1] <= 32'h0;
            lcd_counters[2] <= 32'h0;
            lcd_counters[3] <= 32'h0;
        end
        else if (de1_cl_lcd_clock__enable)
        begin
            lcd_seconds_sr <= {seconds[0],lcd_seconds_sr[3:1]};
            de1_cl_lcd__vsync_n <= !(lcd_video_bus__vsync!=1'h0);
            de1_cl_lcd__hsync_n <= !(lcd_video_bus__hsync!=1'h0);
            de1_cl_lcd__display_enable <= lcd_video_bus__display_enable;
            de1_cl_lcd__red <= lcd_video_bus__red[7:2];
            de1_cl_lcd__green <= lcd_video_bus__green[7:1];
            de1_cl_lcd__blue <= lcd_video_bus__blue[7:2];
            de1_cl_lcd__backlight <= 1'h1;
            lcd_seconds_sr <= {seconds[0],lcd_seconds_sr[3:1]};
            if ((lcd_video_bus__vsync!=1'h0))
            begin
                lcd_counters[0] <= (lcd_counters[0]+32'h1);
            end //if
            if ((lcd_video_bus__hsync!=1'h0))
            begin
                lcd_counters[1] <= (lcd_counters[1]+32'h1);
            end //if
            if ((lcd_video_bus__display_enable!=1'h0))
            begin
                lcd_counters[2] <= (lcd_counters[2]+32'h1);
            end //if
            if ((lcd_seconds_sr[0]!=lcd_seconds_sr[1]))
            begin
                lcd_counters[0] <= 32'h0;
                lcd_counters[1] <= 32'h0;
                lcd_counters[2] <= 32'h0;
                lcd_counters[3] <= 32'h0;
            end //if
        end //if
    end //always

    //b stubs__comb combinatorial process
    always @ ( * )//stubs__comb
    begin: stubs__comb_code
        de1_leds__leds = counter[9:0];
        de1_leds__h0 = de1_hex_leds[0];
        de1_leds__h1 = de1_hex_leds[1];
        de1_leds__h2 = de1_hex_leds[2];
        de1_leds__h3 = de1_hex_leds[3];
        de1_leds__h4 = de1_hex_leds[4];
        de1_leds__h5 = de1_hex_leds[5];
        de1_cl_led_data_pin = !(led_chain!=1'h0);
        de1_ps2b_out__data = 1'h0;
        de1_ps2b_out__clk = 1'h0;
        de1_irda_txd = 1'h0;
    end //always

    //b stubs__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : stubs__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            divider <= 32'h0;
            divider_reset <= 1'h0;
            seconds <= 8'h0;
            counter <= 16'h0;
            riscv_last_pc <= 32'h0;
            gpio_input <= 16'h0;
            de1_ps2_out__data <= 1'hffffffffffffffff;
            de1_ps2_out__clk <= 1'hffffffffffffffff;
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
            if ((de1_switches[4:2]==3'h0))
            begin
                counter <= (counter+16'h1);
            end //if
            if (((de1_switches[4:2]==3'h1)&&(mux_dprintf_req__valid[0]!=1'h0)))
            begin
                counter <= (counter+16'h1);
            end //if
            if (((de1_switches[4:2]==3'h2)&&(mux_dprintf_ack[0]!=1'h0)))
            begin
                counter <= (counter+16'h1);
            end //if
            if (((de1_switches[4:2]==3'h3)&&(apb_request__psel!=1'h0)))
            begin
                counter <= (counter+16'h1);
            end //if
            if (((de1_switches[4:2]==3'h4)&&(apb_processor_request__valid!=1'h0)))
            begin
                counter <= (counter+16'h1);
            end //if
            if (((de1_switches[4:2]==3'h5)&&(apb_processor_response__acknowledge!=1'h0)))
            begin
                counter <= (counter+16'h1);
            end //if
            if (((de1_switches[4:2]==3'h6)&&(tt_display_sram_write__enable!=1'h0)))
            begin
                counter <= (counter+16'h1);
            end //if
            if ((riscv_trace__instr_valid!=1'h0))
            begin
                riscv_last_pc <= riscv_trace__instr_pc;
            end //if
            gpio_input <= 16'h0;
            gpio_input[3:0] <= de1_keys;
            gpio_input[13:4] <= de1_switches;
            gpio_input[14] <= de1_irda_rxd;
            de1_ps2_out__data <= ps2_out__data;
            de1_ps2_out__clk <= ps2_out__clk;
        end //if
    end //always

endmodule // hps_fpga_debug
