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

//a Module bbc_micro_de1_cl
module bbc_micro_de1_cl
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
    switches,
    keys,
    video_locked,
    reset_n,

    inputs_control__sr_clock,
    inputs_control__sr_shift,
    led_data_pin,
    leds,
    lcd__vsync_n,
    lcd__hsync_n,
    lcd__display_enable,
    lcd__red,
    lcd__green,
    lcd__blue,
    lcd__backlight
);

    //b Clocks
        //   9MHz clock from PLL, derived from 50MHz
    input video_clk;
    input video_clk__enable;
        //   50MHz clock from DE1 clock generator
    input clk;
    input clk__enable;
    wire clk_cpu; // Gated version of clock 'clk' enabled by 'enable_cpu_clk'
    wire clk_cpu__enable;
    wire clk_2MHz_video_clock; // Gated version of clock 'clk' enabled by 'enable_clk_2MHz_video'
    wire clk_2MHz_video_clock__enable;

    //b Inputs
        //   DE1 CL daughterboard shifter register etc status
    input inputs_status__sr_data;
    input inputs_status__left_rotary__direction_pin;
    input inputs_status__left_rotary__transition_pin;
    input inputs_status__right_rotary__direction_pin;
    input inputs_status__right_rotary__transition_pin;
        //   DE1 switches
    input [9:0]switches;
        //   DE1 keys
    input [3:0]keys;
        //   High if video PLL has locked
    input video_locked;
        //   hard reset from a pin - a key on DE1
    input reset_n;

    //b Outputs
        //   DE1 CL daughterboard shifter register control
    output inputs_control__sr_clock;
    output inputs_control__sr_shift;
        //   DE1 CL daughterboard neopixel LED pin
    output led_data_pin;
        //   DE1 leds
    output [9:0]leds;
        //   LCD display out to computer lab daughterboard
    output lcd__vsync_n;
    output lcd__hsync_n;
    output lcd__display_enable;
    output [5:0]lcd__red;
    output [6:0]lcd__green;
    output [5:0]lcd__blue;
    output lcd__backlight;

// output components here

    //b Output combinatorials
        //   DE1 leds
    reg [9:0]leds;
        //   LCD display out to computer lab daughterboard
    reg lcd__vsync_n;
    reg lcd__hsync_n;
    reg lcd__display_enable;
    reg [5:0]lcd__red;
    reg [6:0]lcd__green;
    reg [5:0]lcd__blue;
    reg lcd__backlight;

    //b Output nets
        //   DE1 CL daughterboard shifter register control
    wire inputs_control__sr_clock;
    wire inputs_control__sr_shift;
        //   DE1 CL daughterboard neopixel LED pin
    wire led_data_pin;

    //b Internal and output registers
    reg [3:0]last_fn_key;
    reg fn_key_pressed;
    reg [9:0]fn_keys_down;
    reg debug_state__data;
    reg debug_state__last_data;
    reg [31:0]debug_state__counter;
    reg floppy_sram_response__ack;
    reg floppy_sram_response__read_data_valid;
    reg [31:0]floppy_sram_response__read_data;
    reg floppy_sram_request_r__enable;
    reg floppy_sram_request_r__read_not_write;
    reg [19:0]floppy_sram_request_r__address;
    reg [31:0]floppy_sram_request_r__write_data;
    reg floppy_sram_reading;

    //b Internal combinatorials
    reg debug_comb__selected_data;
    reg keyboard__reset_pressed;
    reg [63:0]keyboard__keys_down_cols_0_to_7;
    reg [15:0]keyboard__keys_down_cols_8_to_9;
    reg framebuffer_reset_n;
    reg bbc_reset_n;
    reg led_data__valid;
    reg led_data__last;
    reg [7:0]led_data__red;
    reg [7:0]led_data__green;
    reg [7:0]led_data__blue;
    reg enable_cpu_clk;
    reg enable_clk_2MHz_video;
    reg bbc_micro_host_sram_request__valid;
    reg bbc_micro_host_sram_request__read_enable;
    reg bbc_micro_host_sram_request__write_enable;
    reg [7:0]bbc_micro_host_sram_request__select;
    reg [23:0]bbc_micro_host_sram_request__address;
    reg [63:0]bbc_micro_host_sram_request__write_data;
    reg csr_request__valid;
    reg csr_request__read_not_write;
    reg [15:0]csr_request__select;
    reg [15:0]csr_request__address;
    reg [31:0]csr_request__data;

    //b Internal nets
    wire [31:0]floppy_sram_read_data;
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
    wire bbc_micro_host_sram_response__ack;
    wire bbc_micro_host_sram_response__read_data_valid;
    wire [63:0]bbc_micro_host_sram_response__read_data;
    wire display_sram_write__enable;
    wire [47:0]display_sram_write__data;
    wire [15:0]display_sram_write__address;
    wire floppy_sram_request__enable;
    wire floppy_sram_request__read_not_write;
    wire [19:0]floppy_sram_request__address;
    wire [31:0]floppy_sram_request__write_data;
    wire framebuffer_csr_response__ack;
    wire framebuffer_csr_response__read_data_valid;
    wire [31:0]framebuffer_csr_response__read_data;
    wire floppy_sram_csr_response__ack;
    wire floppy_sram_csr_response__read_data_valid;
    wire [31:0]floppy_sram_csr_response__read_data;
    wire display_sram_csr_response__ack;
    wire display_sram_csr_response__read_data_valid;
    wire [31:0]display_sram_csr_response__read_data;
    wire clocking_csr_response__ack;
    wire clocking_csr_response__read_data_valid;
    wire [31:0]clocking_csr_response__read_data;
    wire clock_control__enable_cpu;
    wire clock_control__will_enable_2MHz_video;
    wire clock_control__enable_2MHz_video;
    wire clock_control__enable_1MHz_rising;
    wire clock_control__enable_1MHz_falling;
    wire [1:0]clock_control__phi;
    wire clock_control__reset_cpu;
    wire clock_status__cpu_1MHz_access;
    wire floppy_response__sector_id_valid;
    wire [6:0]floppy_response__sector_id__track;
    wire floppy_response__sector_id__head;
    wire [5:0]floppy_response__sector_id__sector_number;
    wire [1:0]floppy_response__sector_id__sector_length;
    wire floppy_response__sector_id__bad_crc;
    wire floppy_response__sector_id__bad_data_crc;
    wire floppy_response__sector_id__deleted_data;
    wire floppy_response__index;
    wire floppy_response__read_data_valid;
    wire [31:0]floppy_response__read_data;
    wire floppy_response__track_zero;
    wire floppy_response__write_protect;
    wire floppy_response__disk_ready;
    wire floppy_op__step_out;
    wire floppy_op__step_in;
    wire floppy_op__next_id;
    wire floppy_op__read_data_enable;
    wire floppy_op__write_data_enable;
    wire [31:0]floppy_op__write_data;
    wire floppy_op__write_sector_id_enable;
    wire [6:0]floppy_op__sector_id__track;
    wire floppy_op__sector_id__head;
    wire [5:0]floppy_op__sector_id__sector_number;
    wire [1:0]floppy_op__sector_id__sector_length;
    wire floppy_op__sector_id__bad_crc;
    wire floppy_op__sector_id__bad_data_crc;
    wire floppy_op__sector_id__deleted_data;
    wire keyboard_reset_n;
    wire display__clock_enable;
    wire display__hsync;
    wire display__vsync;
    wire [2:0]display__pixels_per_clock;
    wire [7:0]display__red;
    wire [7:0]display__green;
    wire [7:0]display__blue;
    wire video_bus__vsync;
    wire video_bus__hsync;
    wire video_bus__display_enable;
    wire [7:0]video_bus__red;
    wire [7:0]video_bus__green;
    wire [7:0]video_bus__blue;

    //b Clock gating module instances
    assign clk_cpu__enable = (clk__enable && enable_cpu_clk);
    assign clk_2MHz_video_clock__enable = (clk__enable && enable_clk_2MHz_video);
    //b Module instances
    bbc_micro_clocking clocking(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .clock_status__cpu_1MHz_access(clock_status__cpu_1MHz_access),
        .reset_n(reset_n),
        .csr_response__read_data(            clocking_csr_response__read_data),
        .csr_response__read_data_valid(            clocking_csr_response__read_data_valid),
        .csr_response__ack(            clocking_csr_response__ack),
        .clock_control__reset_cpu(            clock_control__reset_cpu),
        .clock_control__phi(            clock_control__phi),
        .clock_control__enable_1MHz_falling(            clock_control__enable_1MHz_falling),
        .clock_control__enable_1MHz_rising(            clock_control__enable_1MHz_rising),
        .clock_control__enable_2MHz_video(            clock_control__enable_2MHz_video),
        .clock_control__will_enable_2MHz_video(            clock_control__will_enable_2MHz_video),
        .clock_control__enable_cpu(            clock_control__enable_cpu)         );
    bbc_micro bbc(
        .clk(clk),
        .clk__enable(1'b1),
        .host_sram_request__write_data(bbc_micro_host_sram_request__write_data),
        .host_sram_request__address(bbc_micro_host_sram_request__address),
        .host_sram_request__select(bbc_micro_host_sram_request__select),
        .host_sram_request__write_enable(bbc_micro_host_sram_request__write_enable),
        .host_sram_request__read_enable(bbc_micro_host_sram_request__read_enable),
        .host_sram_request__valid(bbc_micro_host_sram_request__valid),
        .floppy_response__disk_ready(floppy_response__disk_ready),
        .floppy_response__write_protect(floppy_response__write_protect),
        .floppy_response__track_zero(floppy_response__track_zero),
        .floppy_response__read_data(floppy_response__read_data),
        .floppy_response__read_data_valid(floppy_response__read_data_valid),
        .floppy_response__index(floppy_response__index),
        .floppy_response__sector_id__deleted_data(floppy_response__sector_id__deleted_data),
        .floppy_response__sector_id__bad_data_crc(floppy_response__sector_id__bad_data_crc),
        .floppy_response__sector_id__bad_crc(floppy_response__sector_id__bad_crc),
        .floppy_response__sector_id__sector_length(floppy_response__sector_id__sector_length),
        .floppy_response__sector_id__sector_number(floppy_response__sector_id__sector_number),
        .floppy_response__sector_id__head(floppy_response__sector_id__head),
        .floppy_response__sector_id__track(floppy_response__sector_id__track),
        .floppy_response__sector_id_valid(floppy_response__sector_id_valid),
        .keyboard__keys_down_cols_8_to_9(keyboard__keys_down_cols_8_to_9),
        .keyboard__keys_down_cols_0_to_7(keyboard__keys_down_cols_0_to_7),
        .keyboard__reset_pressed(keyboard__reset_pressed),
        .clock_control__reset_cpu(clock_control__reset_cpu),
        .clock_control__phi(clock_control__phi),
        .clock_control__enable_1MHz_falling(clock_control__enable_1MHz_falling),
        .clock_control__enable_1MHz_rising(clock_control__enable_1MHz_rising),
        .clock_control__enable_2MHz_video(clock_control__enable_2MHz_video),
        .clock_control__will_enable_2MHz_video(clock_control__will_enable_2MHz_video),
        .clock_control__enable_cpu(clock_control__enable_cpu),
        .reset_n(bbc_reset_n),
        .host_sram_response__read_data(            bbc_micro_host_sram_response__read_data),
        .host_sram_response__read_data_valid(            bbc_micro_host_sram_response__read_data_valid),
        .host_sram_response__ack(            bbc_micro_host_sram_response__ack),
        .floppy_op__sector_id__deleted_data(            floppy_op__sector_id__deleted_data),
        .floppy_op__sector_id__bad_data_crc(            floppy_op__sector_id__bad_data_crc),
        .floppy_op__sector_id__bad_crc(            floppy_op__sector_id__bad_crc),
        .floppy_op__sector_id__sector_length(            floppy_op__sector_id__sector_length),
        .floppy_op__sector_id__sector_number(            floppy_op__sector_id__sector_number),
        .floppy_op__sector_id__head(            floppy_op__sector_id__head),
        .floppy_op__sector_id__track(            floppy_op__sector_id__track),
        .floppy_op__write_sector_id_enable(            floppy_op__write_sector_id_enable),
        .floppy_op__write_data(            floppy_op__write_data),
        .floppy_op__write_data_enable(            floppy_op__write_data_enable),
        .floppy_op__read_data_enable(            floppy_op__read_data_enable),
        .floppy_op__next_id(            floppy_op__next_id),
        .floppy_op__step_in(            floppy_op__step_in),
        .floppy_op__step_out(            floppy_op__step_out),
        .keyboard_reset_n(            keyboard_reset_n),
        .display__blue(            display__blue),
        .display__green(            display__green),
        .display__red(            display__red),
        .display__pixels_per_clock(            display__pixels_per_clock),
        .display__vsync(            display__vsync),
        .display__hsync(            display__hsync),
        .display__clock_enable(            display__clock_enable),
        .clock_status__cpu_1MHz_access(            clock_status__cpu_1MHz_access)         );
    bbc_display_sram display_sram(
        .clk(clk),
        .clk__enable(clk_2MHz_video_clock__enable),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .display__blue(display__blue),
        .display__green(display__green),
        .display__red(display__red),
        .display__pixels_per_clock(display__pixels_per_clock),
        .display__vsync(display__vsync),
        .display__hsync(display__hsync),
        .display__clock_enable(display__clock_enable),
        .reset_n(reset_n),
        .csr_response__read_data(            display_sram_csr_response__read_data),
        .csr_response__read_data_valid(            display_sram_csr_response__read_data_valid),
        .csr_response__ack(            display_sram_csr_response__ack),
        .sram_write__address(            display_sram_write__address),
        .sram_write__data(            display_sram_write__data),
        .sram_write__enable(            display_sram_write__enable)         );
    bbc_floppy_sram floppy_sram(
        .clk(clk),
        .clk__enable(clk_cpu__enable),
        .sram_response__read_data(floppy_sram_response__read_data),
        .sram_response__read_data_valid(floppy_sram_response__read_data_valid),
        .sram_response__ack(floppy_sram_response__ack),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .floppy_op__sector_id__deleted_data(floppy_op__sector_id__deleted_data),
        .floppy_op__sector_id__bad_data_crc(floppy_op__sector_id__bad_data_crc),
        .floppy_op__sector_id__bad_crc(floppy_op__sector_id__bad_crc),
        .floppy_op__sector_id__sector_length(floppy_op__sector_id__sector_length),
        .floppy_op__sector_id__sector_number(floppy_op__sector_id__sector_number),
        .floppy_op__sector_id__head(floppy_op__sector_id__head),
        .floppy_op__sector_id__track(floppy_op__sector_id__track),
        .floppy_op__write_sector_id_enable(floppy_op__write_sector_id_enable),
        .floppy_op__write_data(floppy_op__write_data),
        .floppy_op__write_data_enable(floppy_op__write_data_enable),
        .floppy_op__read_data_enable(floppy_op__read_data_enable),
        .floppy_op__next_id(floppy_op__next_id),
        .floppy_op__step_in(floppy_op__step_in),
        .floppy_op__step_out(floppy_op__step_out),
        .reset_n(reset_n),
        .csr_response__read_data(            floppy_sram_csr_response__read_data),
        .csr_response__read_data_valid(            floppy_sram_csr_response__read_data_valid),
        .csr_response__ack(            floppy_sram_csr_response__ack),
        .sram_request__write_data(            floppy_sram_request__write_data),
        .sram_request__address(            floppy_sram_request__address),
        .sram_request__read_not_write(            floppy_sram_request__read_not_write),
        .sram_request__enable(            floppy_sram_request__enable),
        .floppy_response__disk_ready(            floppy_response__disk_ready),
        .floppy_response__write_protect(            floppy_response__write_protect),
        .floppy_response__track_zero(            floppy_response__track_zero),
        .floppy_response__read_data(            floppy_response__read_data),
        .floppy_response__read_data_valid(            floppy_response__read_data_valid),
        .floppy_response__index(            floppy_response__index),
        .floppy_response__sector_id__deleted_data(            floppy_response__sector_id__deleted_data),
        .floppy_response__sector_id__bad_data_crc(            floppy_response__sector_id__bad_data_crc),
        .floppy_response__sector_id__bad_crc(            floppy_response__sector_id__bad_crc),
        .floppy_response__sector_id__sector_length(            floppy_response__sector_id__sector_length),
        .floppy_response__sector_id__sector_number(            floppy_response__sector_id__sector_number),
        .floppy_response__sector_id__head(            floppy_response__sector_id__head),
        .floppy_response__sector_id__track(            floppy_response__sector_id__track),
        .floppy_response__sector_id_valid(            floppy_response__sector_id_valid)         );
    se_sram_srw_32768x32 floppy(
        .sram_clock(clk),
        .sram_clock__enable(clk_cpu__enable),
        .write_data(floppy_sram_request_r__write_data[31:0]),
        .address(floppy_sram_request_r__address[14:0]),
        .write_enable(!(floppy_sram_request_r__read_not_write!=1'h0)),
        .read_not_write(floppy_sram_request_r__read_not_write),
        .select(((floppy_sram_request_r__enable!=1'h0)&&!(floppy_sram_reading!=1'h0))),
        .data_out(            floppy_sram_read_data)         );
    framebuffer fb(
        .video_clk(video_clk),
        .video_clk__enable(1'b1),
        .sram_clk(clk),
        .sram_clk__enable(clk_2MHz_video_clock__enable),
        .csr_clk(clk),
        .csr_clk__enable(clk_cpu__enable),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .display_sram_write__address(display_sram_write__address),
        .display_sram_write__data(display_sram_write__data),
        .display_sram_write__enable(display_sram_write__enable),
        .reset_n(framebuffer_reset_n),
        .csr_response__read_data(            framebuffer_csr_response__read_data),
        .csr_response__read_data_valid(            framebuffer_csr_response__read_data_valid),
        .csr_response__ack(            framebuffer_csr_response__ack),
        .video_bus__blue(            video_bus__blue),
        .video_bus__green(            video_bus__green),
        .video_bus__red(            video_bus__red),
        .video_bus__display_enable(            video_bus__display_enable),
        .video_bus__hsync(            video_bus__hsync),
        .video_bus__vsync(            video_bus__vsync)         );
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
    led_ws2812_chain led_chain(
        .clk(clk),
        .clk__enable(1'b1),
        .led_data__blue(led_data__blue),
        .led_data__green(led_data__green),
        .led_data__red(led_data__red),
        .led_data__last(led_data__last),
        .led_data__valid(led_data__valid),
        .divider_400ns(8'h13),
        .reset_n(reset_n),
        .led_data_pin(            led_data_pin),
        .led_request__led_number(            led_request__led_number),
        .led_request__first(            led_request__first),
        .led_request__ready(            led_request__ready)         );
    //b debug_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//debug_logic__comb
    begin: debug_logic__comb_code
    reg debug_comb__selected_data__var;
    reg [9:0]leds__var;
       debug_comb__selected_data__var = clock_control__enable_cpu;
        case (switches[8:6]) //synopsys parallel_case
        3'h0: // req 1
            begin
               //debug_comb__selected_data__var = lcd__vsync_n;
            end
        3'h1: // req 1
            begin
            debug_comb__selected_data__var = clock_control__enable_cpu;
            end
        3'h2: // req 1
            begin
            debug_comb__selected_data__var = clock_control__enable_1MHz_falling;
            end
        3'h3: // req 1
            begin
            debug_comb__selected_data__var = floppy_response__read_data_valid;
            end
        3'h4: // req 1
            begin
            //debug_comb__selected_data__var = display_sram_write__enable;
            end
        3'h5: // req 1
            begin
            debug_comb__selected_data__var = floppy_sram_request_r__enable;
            end
        3'h6: // req 1
            begin
            debug_comb__selected_data__var = clock_control__phi[0];
            end
        3'h7: // req 1
            begin
            debug_comb__selected_data__var = clock_control__phi[0];
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:bbc_micro_de1_cl:debug_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        leds__var = debug_state__counter[9:0];
        if ((switches[9]!=1'h0))
        begin
            leds__var = debug_state__counter[15:6];
        end //if
        debug_comb__selected_data = debug_comb__selected_data__var;
        leds = leds__var;
    end //always

    //b debug_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : debug_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            debug_state__data <= 1'h0;
            debug_state__last_data <= 1'h0;
            debug_state__counter <= 32'h0;
        end
        else if (clk__enable)
        begin
            debug_state__data <= debug_comb__selected_data;
            debug_state__last_data <= debug_state__data;
            if (((debug_state__data!=1'h0)&&!(debug_state__last_data!=1'h0)))
            begin
                debug_state__counter <= (debug_state__counter+32'h1);
            end //if
        end //if
    end //always

    //b misc_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//misc_logic__comb
    begin: misc_logic__comb_code
    reg [63:0]keyboard__keys_down_cols_0_to_7__var;
    reg [15:0]keyboard__keys_down_cols_8_to_9__var;
    reg led_data__valid__var;
    reg led_data__last__var;
    reg [7:0]led_data__red__var;
    reg [7:0]led_data__green__var;
    reg [7:0]led_data__blue__var;
        csr_request__valid = 1'h0;
        csr_request__read_not_write = 1'h0;
        csr_request__select = 16'h0;
        csr_request__address = 16'h0;
        csr_request__data = 32'h0;
        bbc_micro_host_sram_request__valid = 1'h0;
        bbc_micro_host_sram_request__read_enable = 1'h0;
        bbc_micro_host_sram_request__write_enable = 1'h0;
        bbc_micro_host_sram_request__select = 8'h0;
        bbc_micro_host_sram_request__address = 24'h0;
        bbc_micro_host_sram_request__write_data = 64'h0;
        keyboard__reset_pressed = 1'h0;
        keyboard__keys_down_cols_0_to_7__var = 64'h0;
        keyboard__keys_down_cols_8_to_9__var = 16'h0;
        keyboard__keys_down_cols_0_to_7__var[0] = !(keys[0]!=1'h0);
        keyboard__keys_down_cols_0_to_7__var[8] = !(keys[1]!=1'h0);
        keyboard__keys_down_cols_0_to_7__var[45] = !(keys[2]!=1'h0);
        keyboard__keys_down_cols_0_to_7__var[13] = user_inputs__joystick__u;
        keyboard__keys_down_cols_0_to_7__var[20] = user_inputs__joystick__d;
        keyboard__keys_down_cols_0_to_7__var[54] = user_inputs__joystick__l;
        keyboard__keys_down_cols_0_to_7__var[62] = user_inputs__joystick__r;
        keyboard__keys_down_cols_0_to_7__var[2] = user_inputs__joystick__c;
        keyboard__keys_down_cols_0_to_7__var[22] = user_inputs__diamond__y;
        keyboard__keys_down_cols_8_to_9__var[6] = user_inputs__diamond__a;
        keyboard__keys_down_cols_0_to_7__var[12] = user_inputs__diamond__b;
        keyboard__keys_down_cols_0_to_7__var[44] = user_inputs__diamond__x;
        keyboard__keys_down_cols_0_to_7__var[15] = fn_keys_down[1];
        keyboard__keys_down_cols_0_to_7__var[23] = fn_keys_down[2];
        keyboard__keys_down_cols_0_to_7__var[31] = fn_keys_down[3];
        keyboard__keys_down_cols_0_to_7__var[33] = fn_keys_down[4];
        keyboard__keys_down_cols_0_to_7__var[39] = fn_keys_down[5];
        keyboard__keys_down_cols_0_to_7__var[47] = fn_keys_down[6];
        keyboard__keys_down_cols_0_to_7__var[49] = fn_keys_down[7];
        keyboard__keys_down_cols_0_to_7__var[55] = fn_keys_down[8];
        keyboard__keys_down_cols_0_to_7__var[63] = fn_keys_down[9];
        keyboard__keys_down_cols_8_to_9__var[11] = user_inputs__joystick__u;
        keyboard__keys_down_cols_8_to_9__var[10] = user_inputs__joystick__d;
        keyboard__keys_down_cols_8_to_9__var[9] = user_inputs__joystick__l;
        keyboard__keys_down_cols_8_to_9__var[15] = user_inputs__joystick__r;
        led_data__valid__var = 1'h0;
        led_data__last__var = 1'h0;
        led_data__red__var = 8'h0;
        led_data__green__var = 8'h0;
        led_data__blue__var = 8'h0;
        if ((led_request__ready!=1'h0))
        begin
            case (led_request__led_number) //synopsys parallel_case
            8'h0: // req 1
                begin
                led_data__valid__var = 1'h1;
                led_data__last__var = 1'h0;
                led_data__red__var = debug_state__counter[7:0];
                led_data__green__var = ~debug_state__counter[7:0];
                led_data__blue__var = 8'h0;
                end
            default: // req 1
                begin
                led_data__valid__var = 1'h1;
                led_data__last__var = 1'h1;
                led_data__blue__var = {last_fn_key,last_fn_key};
                led_data__green__var = 8'h0;
                led_data__red__var = 8'h0;
                end
            endcase
        end //if
        enable_clk_2MHz_video = clock_control__enable_2MHz_video;
        enable_cpu_clk = clock_control__enable_cpu;
        bbc_reset_n = ((reset_n & !(clock_control__reset_cpu!=1'h0)) & switches[0]);
        framebuffer_reset_n = (reset_n & video_locked);
        lcd__vsync_n = !(video_bus__vsync!=1'h0);
        lcd__hsync_n = !(video_bus__hsync!=1'h0);
        lcd__display_enable = video_bus__display_enable;
        lcd__red = video_bus__red[7:2];
        lcd__green = ~video_bus__green[7:1];
        lcd__blue = (video_bus__blue[7:2] ^ debug_state__counter[5:0]);
        lcd__backlight = switches[1];
        keyboard__keys_down_cols_0_to_7 = keyboard__keys_down_cols_0_to_7__var;
        keyboard__keys_down_cols_8_to_9 = keyboard__keys_down_cols_8_to_9__var;
        led_data__valid = led_data__valid__var;
        led_data__last = led_data__last__var;
        led_data__red = led_data__red__var;
        led_data__green = led_data__green__var;
        led_data__blue = led_data__blue__var;
    end //always

    //b misc_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : misc_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            fn_keys_down <= 10'h0;
            fn_key_pressed <= 1'h0;
            last_fn_key <= 4'h1;
        end
        else if (clk__enable)
        begin
            if ((user_inputs__right_dial__direction_pulse!=1'h0))
            begin
                fn_keys_down <= 10'h0;
                fn_key_pressed <= 1'h1;
                if ((user_inputs__right_dial__direction!=1'h0))
                begin
                    last_fn_key <= (last_fn_key+4'h1);
                    if ((last_fn_key==4'h9))
                    begin
                        last_fn_key <= 4'h1;
                    end //if
                end //if
                else
                
                begin
                    last_fn_key <= (last_fn_key-4'h1);
                    if ((last_fn_key==4'h1))
                    begin
                        last_fn_key <= 4'h9;
                    end //if
                end //else
            end //if
            if ((user_inputs__right_dial__pressed!=1'h0))
            begin
                fn_keys_down <= 10'h0;
                fn_keys_down[last_fn_key] <= 1'h1;
            end //if
            else
            
            begin
                fn_keys_down <= 10'h0;
            end //else
        end //if
    end //always

    //b floppy_and_framebuffer clock process
    always @( posedge clk or negedge reset_n)
    begin : floppy_and_framebuffer__code
        if (reset_n==1'b0)
        begin
            floppy_sram_request_r__enable <= 1'h0;
            floppy_sram_request_r__read_not_write <= 1'h0;
            floppy_sram_request_r__address <= 20'h0;
            floppy_sram_request_r__write_data <= 32'h0;
            floppy_sram_reading <= 1'h0;
            floppy_sram_response__ack <= 1'h0;
            floppy_sram_response__read_data_valid <= 1'h0;
            floppy_sram_response__read_data <= 32'h0;
        end
        else if (clk_cpu__enable)
        begin
            floppy_sram_request_r__enable <= floppy_sram_request__enable;
            floppy_sram_request_r__read_not_write <= floppy_sram_request__read_not_write;
            floppy_sram_request_r__address <= floppy_sram_request__address;
            floppy_sram_request_r__write_data <= floppy_sram_request__write_data;
            floppy_sram_reading <= (((floppy_sram_request_r__enable!=1'h0)&&!(floppy_sram_reading!=1'h0))&&(floppy_sram_request_r__read_not_write!=1'h0));
            floppy_sram_response__ack <= floppy_sram_request__enable;
            floppy_sram_response__read_data_valid <= floppy_sram_reading;
            floppy_sram_response__read_data <= floppy_sram_read_data;
        end //if
    end //always

endmodule // bbc_micro_de1_cl
