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

//a Module bbc_micro_de1_cl_io
module bbc_micro_de1_cl_io
(
    video_clk,
    video_clk__enable,
    clk,
    clk__enable,

    inputs_status__sr_data,
    inputs_status__left_rotary__direction_pin,
    inputs_status__left_rotary__transition_pin,
    inputs_status__right_rotary__direction_pin,
    inputs_status__right_rotary__transition_pin,
    ps2_in__data,
    ps2_in__clk,
    csr_response__ack,
    csr_response__read_data_valid,
    csr_response__read_data,
    clock_control__enable_cpu,
    clock_control__will_enable_2MHz_video,
    clock_control__enable_2MHz_video,
    clock_control__enable_1MHz_rising,
    clock_control__enable_1MHz_falling,
    clock_control__phi,
    clock_control__reset_cpu,
    clock_control__debug,
    switches,
    keys,
    framebuffer_reset_n,
    bbc_reset_n,
    reset_n,

    led_chain,
    leds,
    lcd_source,
    inputs_control__sr_clock,
    inputs_control__sr_shift,
    ps2_out__data,
    ps2_out__clk,
    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    video_bus__vsync,
    video_bus__hsync,
    video_bus__display_enable,
    video_bus__red,
    video_bus__green,
    video_bus__blue,
    bbc_keyboard__reset_pressed,
    bbc_keyboard__keys_down_cols_0_to_7,
    bbc_keyboard__keys_down_cols_8_to_9
);

    //b Clocks
        //   9MHz clock from PLL, derived from 50MHz
    input video_clk;
    input video_clk__enable;
        //   50MHz clock from DE1 clock generator
    input clk;
    input clk__enable;

    //b Inputs
        //   DE1 CL daughterboard shifter register etc status
    input inputs_status__sr_data;
    input inputs_status__left_rotary__direction_pin;
    input inputs_status__left_rotary__transition_pin;
    input inputs_status__right_rotary__direction_pin;
    input inputs_status__right_rotary__transition_pin;
        //   PS2 input pins
    input ps2_in__data;
    input ps2_in__clk;
    input csr_response__ack;
    input csr_response__read_data_valid;
    input [31:0]csr_response__read_data;
    input clock_control__enable_cpu;
    input clock_control__will_enable_2MHz_video;
    input clock_control__enable_2MHz_video;
    input clock_control__enable_1MHz_rising;
    input clock_control__enable_1MHz_falling;
    input [1:0]clock_control__phi;
    input clock_control__reset_cpu;
    input [3:0]clock_control__debug;
    input [9:0]switches;
    input [3:0]keys;
    input framebuffer_reset_n;
    input bbc_reset_n;
        //   hard reset from a pin - a key on DE1
    input reset_n;

    //b Outputs
    output led_chain;
    output [9:0]leds;
    output lcd_source;
        //   DE1 CL daughterboard shifter register control
    output inputs_control__sr_clock;
    output inputs_control__sr_shift;
        //   PS2 output pin driver open collector
    output ps2_out__data;
    output ps2_out__clk;
    output csr_request__valid;
    output csr_request__read_not_write;
    output [15:0]csr_request__select;
    output [15:0]csr_request__address;
    output [31:0]csr_request__data;
    output video_bus__vsync;
    output video_bus__hsync;
    output video_bus__display_enable;
    output [7:0]video_bus__red;
    output [7:0]video_bus__green;
    output [7:0]video_bus__blue;
    output bbc_keyboard__reset_pressed;
    output [63:0]bbc_keyboard__keys_down_cols_0_to_7;
    output [15:0]bbc_keyboard__keys_down_cols_8_to_9;

// output components here

    //b Output combinatorials
    reg [9:0]leds;
    reg lcd_source;
    reg bbc_keyboard__reset_pressed;
    reg [63:0]bbc_keyboard__keys_down_cols_0_to_7;
    reg [15:0]bbc_keyboard__keys_down_cols_8_to_9;

    //b Output nets
    wire led_chain;
        //   DE1 CL daughterboard shifter register control
    wire inputs_control__sr_clock;
    wire inputs_control__sr_shift;
        //   PS2 output pin driver open collector
    wire ps2_out__data;
    wire ps2_out__clk;
    wire csr_request__valid;
    wire csr_request__read_not_write;
    wire [15:0]csr_request__select;
    wire [15:0]csr_request__address;
    wire [31:0]csr_request__data;
    wire video_bus__vsync;
    wire video_bus__hsync;
    wire video_bus__display_enable;
    wire [7:0]video_bus__red;
    wire [7:0]video_bus__green;
    wire [7:0]video_bus__blue;

    //b Internal and output registers
    reg [3:0]keys_r;
    reg [9:0]key_state__fn_keys_down;
    reg [3:0]key_state__last_fn_key;
    reg [3:0]key_state__speed_selection;
    reg key_state__left_dial_was_pressed;
    reg [31:0]debug_state__cpu_ticks;
    reg [31:0]debug_state__video_2MHz_ticks;
    reg [31:0]debug_state__falling_1MHz_ticks;
    reg [31:0]debug_state__rising_1MHz_ticks;
    reg [31:0]debug_state__counter_0;
    reg [31:0]debug_state__counter_1;
    reg [31:0]debug_state__update;
    reg [8:0]dprintf_req__valid;
    reg [15:0]dprintf_req__address[8:0];
    reg [63:0]dprintf_req__data_0[8:0];
    reg [63:0]dprintf_req__data_1[8:0];
    reg csr_response_r__ack;
    reg csr_response_r__read_data_valid;
    reg [31:0]csr_response_r__read_data;

    //b Internal combinatorials
    reg apb_processor_request__valid;
    reg [15:0]apb_processor_request__address;
    reg debug_combs__selected_data;
    reg debug_combs__timer_10ms;
    reg led_data__valid;
    reg led_data__last;
    reg [7:0]led_data__red;
    reg [7:0]led_data__green;
    reg [7:0]led_data__blue;
    reg combined_csr_response__ack;
    reg combined_csr_response__read_data_valid;
    reg [31:0]combined_csr_response__read_data;

    //b Internal nets
    wire [39:0]apb_rom_data;
    wire apb_rom_request__enable;
    wire [15:0]apb_rom_request__address;
    wire apb_processor_response__acknowledge;
    wire apb_processor_response__rom_busy;
    wire [31:0]apb_response__prdata;
    wire apb_response__pready;
    wire apb_response__perr;
    wire [31:0]apb_request__paddr;
    wire apb_request__penable;
    wire apb_request__psel;
    wire apb_request__pwrite;
    wire [31:0]apb_request__pwdata;
    wire bbc_ps2_keyboard__reset_pressed;
    wire [63:0]bbc_ps2_keyboard__keys_down_cols_0_to_7;
    wire [15:0]bbc_ps2_keyboard__keys_down_cols_8_to_9;
    wire [7:0]dprintf_mux_req__valid;
    wire [15:0]dprintf_mux_req__address[7:0];
    wire [63:0]dprintf_mux_req__data_0[7:0];
    wire [63:0]dprintf_mux_req__data_1[7:0];
    wire [7:0]dprintf_mux_ack;
    wire [8:0]dprintf_ack;
    wire tt_display_sram_write__enable;
    wire [47:0]tt_display_sram_write__data;
    wire [15:0]tt_display_sram_write__address;
    wire user_inputs__updated_switches;
    wire user_inputs__diamond__a;
    wire user_inputs__diamond__b;
    wire user_inputs__diamond__x;
    wire user_inputs__diamond__y;
    wire user_inputs__joystick__u;
    wire user_inputs__joystick__d;
    wire user_inputs__joystick__l;
    wire user_inputs__joystick__r;
    wire user_inputs__joystick__c;
    wire user_inputs__left_dial__pressed;
    wire user_inputs__left_dial__direction;
    wire user_inputs__left_dial__direction_pulse;
    wire user_inputs__right_dial__pressed;
    wire user_inputs__right_dial__direction;
    wire user_inputs__right_dial__direction_pulse;
    wire user_inputs__touchpanel_irq;
    wire user_inputs__temperature_alarm;
    wire led_request__ready;
    wire led_request__first;
    wire [7:0]led_request__led_number;
    wire tt_framebuffer_csr_response__ack;
    wire tt_framebuffer_csr_response__read_data_valid;
    wire [31:0]tt_framebuffer_csr_response__read_data;
    wire ps2_key__valid;
    wire ps2_key__extended;
    wire ps2_key__release;
    wire [7:0]ps2_key__key_number;
    wire ps2_rx_data__valid;
    wire [7:0]ps2_rx_data__data;
    wire ps2_rx_data__parity_error;
    wire ps2_rx_data__protocol_error;
    wire ps2_rx_data__timeout;

    //b Clock gating module instances
    //b Module instances
    led_ws2812_chain neopixels(
        .clk(clk),
        .clk__enable(1'b1),
        .led_data__blue(led_data__blue),
        .led_data__green(led_data__green),
        .led_data__red(led_data__red),
        .led_data__last(led_data__last),
        .led_data__valid(led_data__valid),
        .divider_400ns(8'h13),
        .reset_n(reset_n),
        .led_chain(            led_chain),
        .led_request__led_number(            led_request__led_number),
        .led_request__first(            led_request__first),
        .led_request__ready(            led_request__ready)         );
    ps2_host ps2(
        .clk(clk),
        .clk__enable(1'b1),
        .divider(16'h96),
        .ps2_in__clk(ps2_in__clk),
        .ps2_in__data(ps2_in__data),
        .reset_n(reset_n),
        .ps2_rx_data__timeout(            ps2_rx_data__timeout),
        .ps2_rx_data__protocol_error(            ps2_rx_data__protocol_error),
        .ps2_rx_data__parity_error(            ps2_rx_data__parity_error),
        .ps2_rx_data__data(            ps2_rx_data__data),
        .ps2_rx_data__valid(            ps2_rx_data__valid),
        .ps2_out__clk(            ps2_out__clk),
        .ps2_out__data(            ps2_out__data)         );
    ps2_host_keyboard key_decode(
        .clk(clk),
        .clk__enable(1'b1),
        .ps2_rx_data__timeout(ps2_rx_data__timeout),
        .ps2_rx_data__protocol_error(ps2_rx_data__protocol_error),
        .ps2_rx_data__parity_error(ps2_rx_data__parity_error),
        .ps2_rx_data__data(ps2_rx_data__data),
        .ps2_rx_data__valid(ps2_rx_data__valid),
        .reset_n(reset_n),
        .ps2_key__key_number(            ps2_key__key_number),
        .ps2_key__release(            ps2_key__release),
        .ps2_key__extended(            ps2_key__extended),
        .ps2_key__valid(            ps2_key__valid)         );
    bbc_keyboard_ps2 bbc_ps2_kbd(
        .clk(clk),
        .clk__enable(1'b1),
        .ps2_key__key_number(ps2_key__key_number),
        .ps2_key__release(ps2_key__release),
        .ps2_key__extended(ps2_key__extended),
        .ps2_key__valid(ps2_key__valid),
        .reset_n(bbc_reset_n),
        .keyboard__keys_down_cols_8_to_9(            bbc_ps2_keyboard__keys_down_cols_8_to_9),
        .keyboard__keys_down_cols_0_to_7(            bbc_ps2_keyboard__keys_down_cols_0_to_7),
        .keyboard__reset_pressed(            bbc_ps2_keyboard__reset_pressed)         );
    de1_cl_controls controls(
        .clk(clk),
        .clk__enable(1'b1),
        .inputs_status__right_rotary__transition_pin(inputs_status__right_rotary__transition_pin),
        .inputs_status__right_rotary__direction_pin(inputs_status__right_rotary__direction_pin),
        .inputs_status__left_rotary__transition_pin(inputs_status__left_rotary__transition_pin),
        .inputs_status__left_rotary__direction_pin(inputs_status__left_rotary__direction_pin),
        .inputs_status__sr_data(inputs_status__sr_data),
        .sr_divider(8'h31),
        .reset_n(reset_n),
        .user_inputs__temperature_alarm(            user_inputs__temperature_alarm),
        .user_inputs__touchpanel_irq(            user_inputs__touchpanel_irq),
        .user_inputs__right_dial__direction_pulse(            user_inputs__right_dial__direction_pulse),
        .user_inputs__right_dial__direction(            user_inputs__right_dial__direction),
        .user_inputs__right_dial__pressed(            user_inputs__right_dial__pressed),
        .user_inputs__left_dial__direction_pulse(            user_inputs__left_dial__direction_pulse),
        .user_inputs__left_dial__direction(            user_inputs__left_dial__direction),
        .user_inputs__left_dial__pressed(            user_inputs__left_dial__pressed),
        .user_inputs__joystick__c(            user_inputs__joystick__c),
        .user_inputs__joystick__r(            user_inputs__joystick__r),
        .user_inputs__joystick__l(            user_inputs__joystick__l),
        .user_inputs__joystick__d(            user_inputs__joystick__d),
        .user_inputs__joystick__u(            user_inputs__joystick__u),
        .user_inputs__diamond__y(            user_inputs__diamond__y),
        .user_inputs__diamond__x(            user_inputs__diamond__x),
        .user_inputs__diamond__b(            user_inputs__diamond__b),
        .user_inputs__diamond__a(            user_inputs__diamond__a),
        .user_inputs__updated_switches(            user_inputs__updated_switches),
        .inputs_control__sr_shift(            inputs_control__sr_shift),
        .inputs_control__sr_clock(            inputs_control__sr_clock)         );
    teletext_dprintf_mux tdm01(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(dprintf_mux_ack[0]),
        .req_b__data_1(dprintf_req__data_1[1]),
        .req_b__data_0(dprintf_req__data_0[1]),
        .req_b__address(dprintf_req__address[1]),
        .req_b__valid(dprintf_req__valid[1]),
        .req_a__data_1(dprintf_req__data_1[0]),
        .req_a__data_0(dprintf_req__data_0[0]),
        .req_a__address(dprintf_req__address[0]),
        .req_a__valid(dprintf_req__valid[0]),
        .reset_n(reset_n),
        .req__data_1(            dprintf_mux_req__data_1[0]),
        .req__data_0(            dprintf_mux_req__data_0[0]),
        .req__address(            dprintf_mux_req__address[0]),
        .req__valid(            dprintf_mux_req__valid[0]),
        .ack_b(            dprintf_ack[1]),
        .ack_a(            dprintf_ack[0])         );
    teletext_dprintf_mux tdm___0(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(dprintf_mux_ack[1]),
        .req_b__data_1(dprintf_mux_req__data_1[0]),
        .req_b__data_0(dprintf_mux_req__data_0[0]),
        .req_b__address(dprintf_mux_req__address[0]),
        .req_b__valid(dprintf_mux_req__valid[0]),
        .req_a__data_1(dprintf_req__data_1[2]),
        .req_a__data_0(dprintf_req__data_0[2]),
        .req_a__address(dprintf_req__address[2]),
        .req_a__valid(dprintf_req__valid[2]),
        .reset_n(reset_n),
        .req__data_1(            dprintf_mux_req__data_1[1]),
        .req__data_0(            dprintf_mux_req__data_0[1]),
        .req__address(            dprintf_mux_req__address[1]),
        .req__valid(            dprintf_mux_req__valid[1]),
        .ack_b(            dprintf_mux_ack[0]),
        .ack_a(            dprintf_ack[2])         );
    teletext_dprintf_mux tdm___1(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(dprintf_mux_ack[2]),
        .req_b__data_1(dprintf_mux_req__data_1[1]),
        .req_b__data_0(dprintf_mux_req__data_0[1]),
        .req_b__address(dprintf_mux_req__address[1]),
        .req_b__valid(dprintf_mux_req__valid[1]),
        .req_a__data_1(dprintf_req__data_1[3]),
        .req_a__data_0(dprintf_req__data_0[3]),
        .req_a__address(dprintf_req__address[3]),
        .req_a__valid(dprintf_req__valid[3]),
        .reset_n(reset_n),
        .req__data_1(            dprintf_mux_req__data_1[2]),
        .req__data_0(            dprintf_mux_req__data_0[2]),
        .req__address(            dprintf_mux_req__address[2]),
        .req__valid(            dprintf_mux_req__valid[2]),
        .ack_b(            dprintf_mux_ack[1]),
        .ack_a(            dprintf_ack[3])         );
    teletext_dprintf_mux tdm___2(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(dprintf_mux_ack[3]),
        .req_b__data_1(dprintf_mux_req__data_1[2]),
        .req_b__data_0(dprintf_mux_req__data_0[2]),
        .req_b__address(dprintf_mux_req__address[2]),
        .req_b__valid(dprintf_mux_req__valid[2]),
        .req_a__data_1(dprintf_req__data_1[4]),
        .req_a__data_0(dprintf_req__data_0[4]),
        .req_a__address(dprintf_req__address[4]),
        .req_a__valid(dprintf_req__valid[4]),
        .reset_n(reset_n),
        .req__data_1(            dprintf_mux_req__data_1[3]),
        .req__data_0(            dprintf_mux_req__data_0[3]),
        .req__address(            dprintf_mux_req__address[3]),
        .req__valid(            dprintf_mux_req__valid[3]),
        .ack_b(            dprintf_mux_ack[2]),
        .ack_a(            dprintf_ack[4])         );
    teletext_dprintf_mux tdm___3(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(dprintf_mux_ack[4]),
        .req_b__data_1(dprintf_mux_req__data_1[3]),
        .req_b__data_0(dprintf_mux_req__data_0[3]),
        .req_b__address(dprintf_mux_req__address[3]),
        .req_b__valid(dprintf_mux_req__valid[3]),
        .req_a__data_1(dprintf_req__data_1[5]),
        .req_a__data_0(dprintf_req__data_0[5]),
        .req_a__address(dprintf_req__address[5]),
        .req_a__valid(dprintf_req__valid[5]),
        .reset_n(reset_n),
        .req__data_1(            dprintf_mux_req__data_1[4]),
        .req__data_0(            dprintf_mux_req__data_0[4]),
        .req__address(            dprintf_mux_req__address[4]),
        .req__valid(            dprintf_mux_req__valid[4]),
        .ack_b(            dprintf_mux_ack[3]),
        .ack_a(            dprintf_ack[5])         );
    teletext_dprintf_mux tdm___4(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(dprintf_mux_ack[5]),
        .req_b__data_1(dprintf_mux_req__data_1[4]),
        .req_b__data_0(dprintf_mux_req__data_0[4]),
        .req_b__address(dprintf_mux_req__address[4]),
        .req_b__valid(dprintf_mux_req__valid[4]),
        .req_a__data_1(dprintf_req__data_1[6]),
        .req_a__data_0(dprintf_req__data_0[6]),
        .req_a__address(dprintf_req__address[6]),
        .req_a__valid(dprintf_req__valid[6]),
        .reset_n(reset_n),
        .req__data_1(            dprintf_mux_req__data_1[5]),
        .req__data_0(            dprintf_mux_req__data_0[5]),
        .req__address(            dprintf_mux_req__address[5]),
        .req__valid(            dprintf_mux_req__valid[5]),
        .ack_b(            dprintf_mux_ack[4]),
        .ack_a(            dprintf_ack[6])         );
    teletext_dprintf_mux tdm___5(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(dprintf_mux_ack[6]),
        .req_b__data_1(dprintf_mux_req__data_1[5]),
        .req_b__data_0(dprintf_mux_req__data_0[5]),
        .req_b__address(dprintf_mux_req__address[5]),
        .req_b__valid(dprintf_mux_req__valid[5]),
        .req_a__data_1(dprintf_req__data_1[7]),
        .req_a__data_0(dprintf_req__data_0[7]),
        .req_a__address(dprintf_req__address[7]),
        .req_a__valid(dprintf_req__valid[7]),
        .reset_n(reset_n),
        .req__data_1(            dprintf_mux_req__data_1[6]),
        .req__data_0(            dprintf_mux_req__data_0[6]),
        .req__address(            dprintf_mux_req__address[6]),
        .req__valid(            dprintf_mux_req__valid[6]),
        .ack_b(            dprintf_mux_ack[5]),
        .ack_a(            dprintf_ack[7])         );
    teletext_dprintf_mux tdm___6(
        .clk(clk),
        .clk__enable(1'b1),
        .ack(dprintf_mux_ack[7]),
        .req_b__data_1(dprintf_mux_req__data_1[6]),
        .req_b__data_0(dprintf_mux_req__data_0[6]),
        .req_b__address(dprintf_mux_req__address[6]),
        .req_b__valid(dprintf_mux_req__valid[6]),
        .req_a__data_1(dprintf_req__data_1[8]),
        .req_a__data_0(dprintf_req__data_0[8]),
        .req_a__address(dprintf_req__address[8]),
        .req_a__valid(dprintf_req__valid[8]),
        .reset_n(reset_n),
        .req__data_1(            dprintf_mux_req__data_1[7]),
        .req__data_0(            dprintf_mux_req__data_0[7]),
        .req__address(            dprintf_mux_req__address[7]),
        .req__valid(            dprintf_mux_req__valid[7]),
        .ack_b(            dprintf_mux_ack[6]),
        .ack_a(            dprintf_ack[8])         );
    teletext_dprintf dprintf(
        .clk(clk),
        .clk__enable(1'b1),
        .dprintf_req__data_1(dprintf_mux_req__data_1[7]),
        .dprintf_req__data_0(dprintf_mux_req__data_0[7]),
        .dprintf_req__address(dprintf_mux_req__address[7]),
        .dprintf_req__valid(dprintf_mux_req__valid[7]),
        .reset_n(reset_n),
        .display_sram_write__address(            tt_display_sram_write__address),
        .display_sram_write__data(            tt_display_sram_write__data),
        .display_sram_write__enable(            tt_display_sram_write__enable),
        .dprintf_ack(            dprintf_mux_ack[7])         );
    framebuffer_teletext ftb(
        .video_clk(video_clk),
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
        .display_sram_write__address(tt_display_sram_write__address),
        .display_sram_write__data(tt_display_sram_write__data),
        .display_sram_write__enable(tt_display_sram_write__enable),
        .reset_n(framebuffer_reset_n),
        .csr_response__read_data(            tt_framebuffer_csr_response__read_data),
        .csr_response__read_data_valid(            tt_framebuffer_csr_response__read_data_valid),
        .csr_response__ack(            tt_framebuffer_csr_response__ack),
        .video_bus__blue(            video_bus__blue),
        .video_bus__green(            video_bus__green),
        .video_bus__red(            video_bus__red),
        .video_bus__display_enable(            video_bus__display_enable),
        .video_bus__hsync(            video_bus__hsync),
        .video_bus__vsync(            video_bus__vsync)         );
    apb_processor apbp(
        .clk(clk),
        .clk__enable(1'b1),
        .rom_data(apb_rom_data),
        .apb_response__perr(apb_response__perr),
        .apb_response__pready(apb_response__pready),
        .apb_response__prdata(apb_response__prdata),
        .apb_processor_request__address(apb_processor_request__address),
        .apb_processor_request__valid(apb_processor_request__valid),
        .reset_n(reset_n),
        .rom_request__address(            apb_rom_request__address),
        .rom_request__enable(            apb_rom_request__enable),
        .apb_request__pwdata(            apb_request__pwdata),
        .apb_request__pwrite(            apb_request__pwrite),
        .apb_request__psel(            apb_request__psel),
        .apb_request__penable(            apb_request__penable),
        .apb_request__paddr(            apb_request__paddr),
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
    csr_master_apb master(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_response__read_data(csr_response_r__read_data),
        .csr_response__read_data_valid(csr_response_r__read_data_valid),
        .csr_response__ack(csr_response_r__ack),
        .apb_request__pwdata(apb_request__pwdata),
        .apb_request__pwrite(apb_request__pwrite),
        .apb_request__psel(apb_request__psel),
        .apb_request__penable(apb_request__penable),
        .apb_request__paddr(apb_request__paddr),
        .reset_n(reset_n),
        .csr_request__data(            csr_request__data),
        .csr_request__address(            csr_request__address),
        .csr_request__select(            csr_request__select),
        .csr_request__read_not_write(            csr_request__read_not_write),
        .csr_request__valid(            csr_request__valid),
        .apb_response__perr(            apb_response__perr),
        .apb_response__pready(            apb_response__pready),
        .apb_response__prdata(            apb_response__prdata)         );
    //b debug_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//debug_logic__comb
    begin: debug_logic__comb_code
    reg debug_combs__timer_10ms__var;
        debug_combs__selected_data = 1'h0;
        debug_combs__timer_10ms__var = 1'h0;
        debug_combs__timer_10ms__var = 1'h0;
        if ((debug_state__update==32'h7a11f))
        begin
            debug_combs__timer_10ms__var = 1'h1;
        end //if
        debug_combs__timer_10ms = debug_combs__timer_10ms__var;
    end //always

    //b debug_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : debug_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            debug_state__update <= 32'h0;
            debug_state__cpu_ticks <= 32'h0;
            debug_state__video_2MHz_ticks <= 32'h0;
            debug_state__rising_1MHz_ticks <= 32'h0;
            debug_state__falling_1MHz_ticks <= 32'h0;
            debug_state__counter_0 <= 32'h0;
            debug_state__counter_1 <= 32'h0;
        end
        else if (clk__enable)
        begin
            debug_state__update <= (debug_state__update+32'h1);
            if ((debug_combs__timer_10ms!=1'h0))
            begin
                debug_state__update <= 32'h0;
                debug_state__cpu_ticks <= 32'h0;
                debug_state__video_2MHz_ticks <= 32'h0;
                debug_state__rising_1MHz_ticks <= 32'h0;
                debug_state__falling_1MHz_ticks <= 32'h0;
                debug_state__counter_0 <= 32'h0;
                debug_state__counter_1 <= 32'h0;
            end //if
            if ((clock_control__enable_cpu!=1'h0))
            begin
                debug_state__cpu_ticks <= (debug_state__cpu_ticks+32'h1);
            end //if
            if ((clock_control__enable_2MHz_video!=1'h0))
            begin
                debug_state__video_2MHz_ticks <= (debug_state__video_2MHz_ticks+32'h1);
            end //if
            if ((clock_control__enable_1MHz_rising!=1'h0))
            begin
                debug_state__rising_1MHz_ticks <= (debug_state__rising_1MHz_ticks+32'h1);
            end //if
            if ((clock_control__enable_1MHz_falling!=1'h0))
            begin
                debug_state__falling_1MHz_ticks <= (debug_state__falling_1MHz_ticks+32'h1);
            end //if
            if (((clock_control__debug[0]!=1'h0)&&!(switches[4]!=1'h0)))
            begin
                debug_state__counter_0 <= (debug_state__counter_0+32'h1);
            end //if
            if (((clock_control__debug[1]!=1'h0)&&!(switches[4]!=1'h0)))
            begin
                debug_state__counter_1 <= (debug_state__counter_1+32'h1);
            end //if
            if (((clock_control__debug[2]!=1'h0)&&(switches[4]!=1'h0)))
            begin
                debug_state__counter_0 <= (debug_state__counter_0+32'h1);
            end //if
            if (((clock_control__debug[3]!=1'h0)&&(switches[4]!=1'h0)))
            begin
                debug_state__counter_1 <= (debug_state__counter_1+32'h1);
            end //if
        end //if
    end //always

    //b misc_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//misc_logic__comb
    begin: misc_logic__comb_code
        lcd_source = switches[3];
    end //always

    //b misc_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : misc_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            key_state__fn_keys_down <= 10'h0;
            key_state__last_fn_key <= 4'h0;
            key_state__speed_selection <= 4'h0;
            key_state__left_dial_was_pressed <= 1'h0;
        end
        else if (clk__enable)
        begin
            if ((user_inputs__right_dial__direction_pulse!=1'h0))
            begin
                key_state__fn_keys_down <= 10'h0;
                if ((user_inputs__right_dial__direction!=1'h0))
                begin
                    key_state__last_fn_key <= (key_state__last_fn_key+4'h1);
                    if ((key_state__last_fn_key==4'h9))
                    begin
                        key_state__last_fn_key <= 4'h0;
                    end //if
                end //if
                else
                
                begin
                    key_state__last_fn_key <= (key_state__last_fn_key-4'h1);
                    if ((key_state__last_fn_key==4'h0))
                    begin
                        key_state__last_fn_key <= 4'h9;
                    end //if
                end //else
            end //if
            if ((user_inputs__left_dial__direction_pulse!=1'h0))
            begin
                if ((user_inputs__left_dial__direction!=1'h0))
                begin
                    key_state__speed_selection <= (key_state__speed_selection+4'h1);
                    if ((key_state__speed_selection==4'hb))
                    begin
                        key_state__speed_selection <= 4'h0;
                    end //if
                end //if
                else
                
                begin
                    key_state__speed_selection <= (key_state__speed_selection-4'h1);
                    if ((key_state__speed_selection==4'h0))
                    begin
                        key_state__speed_selection <= 4'hb;
                    end //if
                end //else
            end //if
            if ((user_inputs__right_dial__pressed!=1'h0))
            begin
                key_state__fn_keys_down <= 10'h0;
                key_state__fn_keys_down[key_state__last_fn_key] <= 1'h1;
            end //if
            else
            
            begin
                key_state__fn_keys_down <= 10'h0;
            end //else
            key_state__left_dial_was_pressed <= user_inputs__left_dial__pressed;
        end //if
    end //always

    //b led_chain_logic combinatorial process
        //   
        //       
    always @ ( * )//led_chain_logic
    begin: led_chain_logic__comb_code
    reg led_data__valid__var;
    reg led_data__last__var;
    reg [7:0]led_data__red__var;
    reg [7:0]led_data__blue__var;
        led_data__valid__var = 1'h0;
        led_data__last__var = 1'h0;
        led_data__red__var = 8'h0;
        led_data__green = 8'h0;
        led_data__blue__var = 8'h0;
        if ((led_request__ready!=1'h0))
        begin
            led_data__valid__var = 1'h1;
            case (led_request__led_number) //synopsys parallel_case
            8'h0: // req 1
                begin
                led_data__red__var = ((key_state__last_fn_key==4'h0)?8'h3f:8'h0);
                end
            8'h1: // req 1
                begin
                led_data__red__var = ((key_state__last_fn_key==4'h1)?8'h3f:8'h0);
                end
            8'h2: // req 1
                begin
                led_data__red__var = ((key_state__last_fn_key==4'h2)?8'h3f:8'h0);
                end
            8'h3: // req 1
                begin
                led_data__red__var = ((key_state__last_fn_key==4'h3)?8'h3f:8'h0);
                end
            8'h4: // req 1
                begin
                led_data__red__var = ((key_state__last_fn_key==4'h4)?8'h3f:8'h0);
                end
            8'h5: // req 1
                begin
                led_data__red__var = ((key_state__last_fn_key==4'h5)?8'h3f:8'h0);
                end
            8'h6: // req 1
                begin
                led_data__red__var = ((key_state__last_fn_key==4'h6)?8'h3f:8'h0);
                end
            8'h7: // req 1
                begin
                led_data__red__var = ((key_state__last_fn_key==4'h7)?8'h3f:8'h0);
                end
            8'h8: // req 1
                begin
                led_data__red__var = ((key_state__last_fn_key==4'h8)?8'h3f:8'h0);
                end
            8'h9: // req 1
                begin
                led_data__red__var = ((key_state__last_fn_key==4'h9)?8'h3f:8'h0);
                end
            //synopsys  translate_off
            //pragma coverage off
            //synopsys  translate_on
            default:
                begin
                //Need a default case to make Cadence Lint happy, even though this is not a full case
                end
            //synopsys  translate_off
            //pragma coverage on
            //synopsys  translate_on
            endcase
            case (led_request__led_number) //synopsys parallel_case
            8'h0: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'h0)?8'h3f:8'h0);
                end
            8'h1: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'h1)?8'h3f:8'h0);
                end
            8'h2: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'h2)?8'h3f:8'h0);
                end
            8'h3: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'h3)?8'h3f:8'h0);
                end
            8'h4: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'h4)?8'h3f:8'h0);
                end
            8'h5: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'h5)?8'h3f:8'h0);
                end
            8'h6: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'h6)?8'h3f:8'h0);
                end
            8'h7: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'h7)?8'h3f:8'h0);
                end
            8'h8: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'h8)?8'h3f:8'h0);
                end
            8'h9: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'h9)?8'h3f:8'h0);
                end
            8'ha: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'ha)?8'h3f:8'h0);
                end
            8'hb: // req 1
                begin
                led_data__blue__var = ((key_state__speed_selection==4'hb)?8'h3f:8'h0);
                end
            //synopsys  translate_off
            //pragma coverage off
            //synopsys  translate_on
            default:
                begin
                //Need a default case to make Cadence Lint happy, even though this is not a full case
                end
            //synopsys  translate_off
            //pragma coverage on
            //synopsys  translate_on
            endcase
            if ((led_request__led_number==8'hb))
            begin
                led_data__last__var = 1'h1;
            end //if
        end //if
        led_data__valid = led_data__valid__var;
        led_data__last = led_data__last__var;
        led_data__red = led_data__red__var;
        led_data__blue = led_data__blue__var;
    end //always

    //b keyboard_input__comb combinatorial process
    always @ ( * )//keyboard_input__comb
    begin: keyboard_input__comb_code
    reg [63:0]bbc_keyboard__keys_down_cols_0_to_7__var;
    reg [15:0]bbc_keyboard__keys_down_cols_8_to_9__var;
        bbc_keyboard__reset_pressed = 1'h0;
        bbc_keyboard__keys_down_cols_0_to_7__var = bbc_ps2_keyboard__keys_down_cols_0_to_7;
        bbc_keyboard__keys_down_cols_8_to_9__var = bbc_ps2_keyboard__keys_down_cols_8_to_9;
        bbc_keyboard__keys_down_cols_0_to_7__var[0] = bbc_keyboard__keys_down_cols_0_to_7__var[0] | !(keys_r[0]!=1'h0);
        bbc_keyboard__keys_down_cols_0_to_7__var[8] = bbc_keyboard__keys_down_cols_0_to_7__var[8] | !(keys_r[1]!=1'h0);
        bbc_keyboard__keys_down_cols_0_to_7__var[45] = bbc_keyboard__keys_down_cols_0_to_7__var[45] | !(keys_r[2]!=1'h0);
        bbc_keyboard__keys_down_cols_0_to_7__var[13] = bbc_keyboard__keys_down_cols_0_to_7__var[13] | user_inputs__joystick__u;
        bbc_keyboard__keys_down_cols_0_to_7__var[20] = bbc_keyboard__keys_down_cols_0_to_7__var[20] | user_inputs__joystick__d;
        bbc_keyboard__keys_down_cols_0_to_7__var[54] = bbc_keyboard__keys_down_cols_0_to_7__var[54] | user_inputs__joystick__l;
        bbc_keyboard__keys_down_cols_0_to_7__var[62] = bbc_keyboard__keys_down_cols_0_to_7__var[62] | user_inputs__joystick__r;
        bbc_keyboard__keys_down_cols_0_to_7__var[2] = bbc_keyboard__keys_down_cols_0_to_7__var[2] | user_inputs__joystick__c;
        bbc_keyboard__keys_down_cols_0_to_7__var[22] = bbc_keyboard__keys_down_cols_0_to_7__var[22] | user_inputs__diamond__y;
        bbc_keyboard__keys_down_cols_8_to_9__var[6] = bbc_keyboard__keys_down_cols_8_to_9__var[6] | user_inputs__diamond__a;
        bbc_keyboard__keys_down_cols_0_to_7__var[12] = bbc_keyboard__keys_down_cols_0_to_7__var[12] | user_inputs__diamond__b;
        bbc_keyboard__keys_down_cols_0_to_7__var[44] = bbc_keyboard__keys_down_cols_0_to_7__var[44] | user_inputs__diamond__x;
        bbc_keyboard__keys_down_cols_0_to_7__var[2] = bbc_keyboard__keys_down_cols_0_to_7__var[2] | key_state__fn_keys_down[0];
        bbc_keyboard__keys_down_cols_0_to_7__var[15] = bbc_keyboard__keys_down_cols_0_to_7__var[15] | key_state__fn_keys_down[1];
        bbc_keyboard__keys_down_cols_0_to_7__var[23] = bbc_keyboard__keys_down_cols_0_to_7__var[23] | key_state__fn_keys_down[2];
        bbc_keyboard__keys_down_cols_0_to_7__var[31] = bbc_keyboard__keys_down_cols_0_to_7__var[31] | key_state__fn_keys_down[3];
        bbc_keyboard__keys_down_cols_0_to_7__var[33] = bbc_keyboard__keys_down_cols_0_to_7__var[33] | key_state__fn_keys_down[4];
        bbc_keyboard__keys_down_cols_0_to_7__var[39] = bbc_keyboard__keys_down_cols_0_to_7__var[39] | key_state__fn_keys_down[5];
        bbc_keyboard__keys_down_cols_0_to_7__var[47] = bbc_keyboard__keys_down_cols_0_to_7__var[47] | key_state__fn_keys_down[6];
        bbc_keyboard__keys_down_cols_0_to_7__var[49] = bbc_keyboard__keys_down_cols_0_to_7__var[49] | key_state__fn_keys_down[7];
        bbc_keyboard__keys_down_cols_0_to_7__var[55] = bbc_keyboard__keys_down_cols_0_to_7__var[55] | key_state__fn_keys_down[8];
        bbc_keyboard__keys_down_cols_0_to_7__var[63] = bbc_keyboard__keys_down_cols_0_to_7__var[63] | key_state__fn_keys_down[9];
        bbc_keyboard__keys_down_cols_0_to_7 = bbc_keyboard__keys_down_cols_0_to_7__var;
        bbc_keyboard__keys_down_cols_8_to_9 = bbc_keyboard__keys_down_cols_8_to_9__var;
    end //always

    //b keyboard_input__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : keyboard_input__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            keys_r <= 4'h0;
        end
        else if (clk__enable)
        begin
            keys_r <= keys;
        end //if
    end //always

    //b tt_framebuffer clock process
    always @( posedge clk or negedge reset_n)
    begin : tt_framebuffer__code
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
            dprintf_req__address[0] <= 16'h0;
            dprintf_req__address[1] <= 16'h0;
            dprintf_req__address[2] <= 16'h0;
            dprintf_req__address[3] <= 16'h0;
            dprintf_req__address[4] <= 16'h0;
            dprintf_req__address[5] <= 16'h0;
            dprintf_req__address[6] <= 16'h0;
            dprintf_req__address[7] <= 16'h0;
            dprintf_req__address[8] <= 16'h0;
            dprintf_req__data_0[0] <= 64'h0;
            dprintf_req__data_0[1] <= 64'h0;
            dprintf_req__data_0[2] <= 64'h0;
            dprintf_req__data_0[3] <= 64'h0;
            dprintf_req__data_0[4] <= 64'h0;
            dprintf_req__data_0[5] <= 64'h0;
            dprintf_req__data_0[6] <= 64'h0;
            dprintf_req__data_0[7] <= 64'h0;
            dprintf_req__data_0[8] <= 64'h0;
            dprintf_req__data_1[0] <= 64'h0;
            dprintf_req__data_1[1] <= 64'h0;
            dprintf_req__data_1[2] <= 64'h0;
            dprintf_req__data_1[3] <= 64'h0;
            dprintf_req__data_1[4] <= 64'h0;
            dprintf_req__data_1[5] <= 64'h0;
            dprintf_req__data_1[6] <= 64'h0;
            dprintf_req__data_1[7] <= 64'h0;
            dprintf_req__data_1[8] <= 64'h0;
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
            if ((ps2_key__valid!=1'h0))
            begin
                dprintf_req__valid[0] <= 1'h1;
                dprintf_req__address[0] <= 16'h0;
                dprintf_req__data_0[0] <= 64'h505332206b65793a;
                dprintf_req__data_1[0] <= {{{{((ps2_key__release!=1'h0)?8'h2:8'h1),((ps2_key__extended!=1'h0)?8'h45:8'h0)},8'h81},ps2_key__key_number},32'h2020ffff};
            end //if
            if ((debug_combs__timer_10ms!=1'h0))
            begin
                dprintf_req__valid[1] <= 1'h1;
                dprintf_req__address[1] <= 16'h28;
                dprintf_req__data_0[1] <= 64'h5269676874204469;
                dprintf_req__data_1[1] <= {{{{{24'h616c3a,((user_inputs__right_dial__pressed!=1'h0)?8'h1:8'h6)},8'h80},4'h0},key_state__last_fn_key},16'hff};
                dprintf_req__valid[2] <= 1'h1;
                dprintf_req__address[2] <= 16'h50;
                dprintf_req__data_0[2] <= 64'h4c65667420446961;
                dprintf_req__data_1[2] <= {{{{{24'h6c203a,((user_inputs__left_dial__pressed!=1'h0)?8'h1:8'h6)},8'h80},4'h0},key_state__speed_selection},16'hff};
                dprintf_req__valid[3] <= 1'h1;
                dprintf_req__address[3] <= 16'h78;
                dprintf_req__data_0[3] <= 64'h435055207469636b;
                dprintf_req__data_1[3] <= {{24'h73203a,8'hdb},debug_state__cpu_ticks};
                dprintf_req__valid[4] <= 1'h1;
                dprintf_req__address[4] <= 16'ha0;
                dprintf_req__data_0[4] <= 64'h324d687a20566964;
                dprintf_req__data_1[4] <= {{24'h656f3a,8'hdb},debug_state__video_2MHz_ticks};
                dprintf_req__valid[5] <= 1'h1;
                dprintf_req__address[5] <= 16'hc8;
                dprintf_req__data_0[5] <= 64'h314d687a2066616c;
                dprintf_req__data_1[5] <= {{24'h6c203a,8'hdb},debug_state__falling_1MHz_ticks};
                dprintf_req__valid[6] <= 1'h1;
                dprintf_req__address[6] <= 16'hf0;
                dprintf_req__data_0[6] <= 64'h314d687a20726973;
                dprintf_req__data_1[6] <= {{24'h65203a,8'hdb},debug_state__rising_1MHz_ticks};
                dprintf_req__valid[7] <= 1'h1;
                dprintf_req__address[7] <= 16'h118;
                dprintf_req__data_0[7] <= 64'h446562756720303a;
                dprintf_req__data_1[7] <= {{{8'hdb,debug_state__counter_0},8'h81},16'h0};
                dprintf_req__valid[8] <= 1'h1;
                dprintf_req__address[8] <= 16'h140;
                dprintf_req__data_0[8] <= 64'h446562756720313a;
                dprintf_req__data_1[8] <= {{{{8'hdb,debug_state__counter_1},8'h81},12'h0},clock_control__debug};
            end //if
        end //if
    end //always

    //b apb_csr_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//apb_csr_logic__comb
    begin: apb_csr_logic__comb_code
    reg apb_processor_request__valid__var;
    reg [9:0]leds__var;
    reg combined_csr_response__ack__var;
    reg combined_csr_response__read_data_valid__var;
    reg [31:0]combined_csr_response__read_data__var;
        apb_processor_request__valid__var = 1'h0;
        apb_processor_request__address[7:4] = key_state__speed_selection;
        if (((user_inputs__left_dial__pressed!=1'h0)&&!(key_state__left_dial_was_pressed!=1'h0)))
        begin
            apb_processor_request__valid__var = 1'h1;
        end //if
        leds__var[0] = apb_processor_request__valid__var;
        leds__var[1] = apb_processor_response__acknowledge;
        leds__var[2] = apb_processor_response__rom_busy;
        leds__var[3] = csr_request__valid;
        leds__var[4] = csr_response_r__ack;
        combined_csr_response__ack__var = csr_response__ack;
        combined_csr_response__read_data_valid__var = csr_response__read_data_valid;
        combined_csr_response__read_data__var = csr_response__read_data;
        combined_csr_response__ack__var = combined_csr_response__ack__var | tt_framebuffer_csr_response__ack;
        combined_csr_response__read_data_valid__var = combined_csr_response__read_data_valid__var | tt_framebuffer_csr_response__read_data_valid;
        combined_csr_response__read_data__var = combined_csr_response__read_data__var | tt_framebuffer_csr_response__read_data;
        apb_processor_request__valid = apb_processor_request__valid__var;
        leds = leds__var;
        combined_csr_response__ack = combined_csr_response__ack__var;
        combined_csr_response__read_data_valid = combined_csr_response__read_data_valid__var;
        combined_csr_response__read_data = combined_csr_response__read_data__var;
    end //always

    //b apb_csr_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : apb_csr_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            csr_response_r__ack <= 1'h0;
            csr_response_r__read_data_valid <= 1'h0;
            csr_response_r__read_data <= 32'h0;
        end
        else if (clk__enable)
        begin
            csr_response_r__ack <= csr_response__ack;
            csr_response_r__read_data_valid <= csr_response__read_data_valid;
            csr_response_r__read_data <= csr_response__read_data;
        end //if
    end //always

endmodule // bbc_micro_de1_cl_io
