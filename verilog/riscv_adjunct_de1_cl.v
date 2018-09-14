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

//a Module riscv_adjunct_de1_cl
module riscv_adjunct_de1_cl
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
    switches,
    keys,
    video_locked,
    reset_n,

    inputs_control__sr_clock,
    inputs_control__sr_shift,
    led_data_pin,
    ps2_out__data,
    ps2_out__clk,
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
        //   PS2 output pin driver open collector
    output ps2_out__data;
    output ps2_out__clk;
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
        //   DE1 CL daughterboard neopixel LED pin
    reg led_data_pin;
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
        //   PS2 output pin driver open collector
    wire ps2_out__data;
    wire ps2_out__clk;
        //   DE1 leds
    wire [9:0]leds;

    //b Internal and output registers

    //b Internal combinatorials
    reg framebuffer_reset_n;
    reg bbc_reset_n;

    //b Internal nets
    wire lcd_source;
    wire bbc_keyboard__reset_pressed;
    wire [63:0]bbc_keyboard__keys_down_cols_0_to_7;
    wire [15:0]bbc_keyboard__keys_down_cols_8_to_9;
    wire led_chain;
    wire bbc_csr_response__acknowledge;
    wire bbc_csr_response__read_data_valid;
    wire bbc_csr_response__read_data_error;
    wire [31:0]bbc_csr_response__read_data;
    wire csr_request__valid;
    wire csr_request__read_not_write;
    wire [15:0]csr_request__select;
    wire [15:0]csr_request__address;
    wire [31:0]csr_request__data;
    wire bbc_clock_control__enable_cpu;
    wire bbc_clock_control__will_enable_2MHz_video;
    wire bbc_clock_control__enable_2MHz_video;
    wire bbc_clock_control__enable_1MHz_rising;
    wire bbc_clock_control__enable_1MHz_falling;
    wire [1:0]bbc_clock_control__phi;
    wire bbc_clock_control__reset_cpu;
    wire [3:0]bbc_clock_control__debug;
    wire io_video_bus__vsync;
    wire io_video_bus__hsync;
    wire io_video_bus__display_enable;
    wire [7:0]io_video_bus__red;
    wire [7:0]io_video_bus__green;
    wire [7:0]io_video_bus__blue;
    wire bbc_video_bus__vsync;
    wire bbc_video_bus__hsync;
    wire bbc_video_bus__display_enable;
    wire [7:0]bbc_video_bus__red;
    wire [7:0]bbc_video_bus__green;
    wire [7:0]bbc_video_bus__blue;

    //b Clock gating module instances
    //b Module instances
    bbc_micro_de1_cl_io io(
        .video_clk(video_clk),
        .video_clk__enable(1'b1),
        .clk(clk),
        .clk__enable(1'b1),
        .ps2_in__clk(ps2_in__clk),
        .ps2_in__data(ps2_in__data),
        .inputs_status__right_rotary__transition_pin(inputs_status__right_rotary__transition_pin),
        .inputs_status__right_rotary__direction_pin(inputs_status__right_rotary__direction_pin),
        .inputs_status__left_rotary__transition_pin(inputs_status__left_rotary__transition_pin),
        .inputs_status__left_rotary__direction_pin(inputs_status__left_rotary__direction_pin),
        .inputs_status__sr_data(inputs_status__sr_data),
        .csr_response__read_data(bbc_csr_response__read_data),
        .csr_response__read_data_error(bbc_csr_response__read_data_error),
        .csr_response__read_data_valid(bbc_csr_response__read_data_valid),
        .csr_response__acknowledge(bbc_csr_response__acknowledge),
        .clock_control__debug(bbc_clock_control__debug),
        .clock_control__reset_cpu(bbc_clock_control__reset_cpu),
        .clock_control__phi(bbc_clock_control__phi),
        .clock_control__enable_1MHz_falling(bbc_clock_control__enable_1MHz_falling),
        .clock_control__enable_1MHz_rising(bbc_clock_control__enable_1MHz_rising),
        .clock_control__enable_2MHz_video(bbc_clock_control__enable_2MHz_video),
        .clock_control__will_enable_2MHz_video(bbc_clock_control__will_enable_2MHz_video),
        .clock_control__enable_cpu(bbc_clock_control__enable_cpu),
        .switches(switches),
        .keys(keys),
        .framebuffer_reset_n(framebuffer_reset_n),
        .bbc_reset_n(bbc_reset_n),
        .reset_n(reset_n),
        .led_chain(            led_chain),
        .leds(            leds),
        .lcd_source(            lcd_source),
        .ps2_out__clk(            ps2_out__clk),
        .ps2_out__data(            ps2_out__data),
        .inputs_control__sr_shift(            inputs_control__sr_shift),
        .inputs_control__sr_clock(            inputs_control__sr_clock),
        .csr_request__data(            csr_request__data),
        .csr_request__address(            csr_request__address),
        .csr_request__select(            csr_request__select),
        .csr_request__read_not_write(            csr_request__read_not_write),
        .csr_request__valid(            csr_request__valid),
        .video_bus__blue(            io_video_bus__blue),
        .video_bus__green(            io_video_bus__green),
        .video_bus__red(            io_video_bus__red),
        .video_bus__display_enable(            io_video_bus__display_enable),
        .video_bus__hsync(            io_video_bus__hsync),
        .video_bus__vsync(            io_video_bus__vsync),
        .bbc_keyboard__keys_down_cols_8_to_9(            bbc_keyboard__keys_down_cols_8_to_9),
        .bbc_keyboard__keys_down_cols_0_to_7(            bbc_keyboard__keys_down_cols_0_to_7),
        .bbc_keyboard__reset_pressed(            bbc_keyboard__reset_pressed)         );
    bbc_micro_de1_cl_bbc bbc(
        .video_clk(video_clk),
        .video_clk__enable(1'b1),
        .clk(clk),
        .clk__enable(1'b1),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .bbc_keyboard__keys_down_cols_8_to_9(bbc_keyboard__keys_down_cols_8_to_9),
        .bbc_keyboard__keys_down_cols_0_to_7(bbc_keyboard__keys_down_cols_0_to_7),
        .bbc_keyboard__reset_pressed(bbc_keyboard__reset_pressed),
        .framebuffer_reset_n(framebuffer_reset_n),
        .bbc_reset_n(bbc_reset_n),
        .reset_n(reset_n),
        .csr_response__read_data(            bbc_csr_response__read_data),
        .csr_response__read_data_error(            bbc_csr_response__read_data_error),
        .csr_response__read_data_valid(            bbc_csr_response__read_data_valid),
        .csr_response__acknowledge(            bbc_csr_response__acknowledge),
        .video_bus__blue(            bbc_video_bus__blue),
        .video_bus__green(            bbc_video_bus__green),
        .video_bus__red(            bbc_video_bus__red),
        .video_bus__display_enable(            bbc_video_bus__display_enable),
        .video_bus__hsync(            bbc_video_bus__hsync),
        .video_bus__vsync(            bbc_video_bus__vsync),
        .clock_control__debug(            bbc_clock_control__debug),
        .clock_control__reset_cpu(            bbc_clock_control__reset_cpu),
        .clock_control__phi(            bbc_clock_control__phi),
        .clock_control__enable_1MHz_falling(            bbc_clock_control__enable_1MHz_falling),
        .clock_control__enable_1MHz_rising(            bbc_clock_control__enable_1MHz_rising),
        .clock_control__enable_2MHz_video(            bbc_clock_control__enable_2MHz_video),
        .clock_control__will_enable_2MHz_video(            bbc_clock_control__will_enable_2MHz_video),
        .clock_control__enable_cpu(            bbc_clock_control__enable_cpu)         );
    //b misc_logic combinatorial process
        //   
        //       
    always @ ( * )//misc_logic
    begin: misc_logic__comb_code
        bbc_reset_n = ((reset_n & !(bbc_clock_control__reset_cpu!=1'h0)) & switches[0]);
        framebuffer_reset_n = (reset_n & video_locked);
    end //always

    //b output_muxes combinatorial process
        //   
        //       
    always @ ( * )//output_muxes
    begin: output_muxes__comb_code
    reg lcd__vsync_n__var;
    reg lcd__hsync_n__var;
    reg lcd__display_enable__var;
    reg [5:0]lcd__red__var;
    reg [6:0]lcd__green__var;
    reg [5:0]lcd__blue__var;
        lcd__vsync_n__var = !(bbc_video_bus__vsync!=1'h0);
        lcd__hsync_n__var = !(bbc_video_bus__hsync!=1'h0);
        lcd__display_enable__var = bbc_video_bus__display_enable;
        lcd__red__var = bbc_video_bus__red[7:2];
        lcd__green__var = bbc_video_bus__green[7:1];
        lcd__blue__var = bbc_video_bus__blue[7:2];
        lcd__backlight = switches[1];
        if ((lcd_source!=1'h0))
        begin
            lcd__vsync_n__var = !(io_video_bus__vsync!=1'h0);
            lcd__hsync_n__var = !(io_video_bus__hsync!=1'h0);
            lcd__display_enable__var = io_video_bus__display_enable;
            lcd__red__var = io_video_bus__red[7:2];
            lcd__green__var = io_video_bus__green[7:1];
            lcd__blue__var = io_video_bus__blue[7:2];
        end //if
        led_data_pin = !(led_chain!=1'h0);
        lcd__vsync_n = lcd__vsync_n__var;
        lcd__hsync_n = lcd__hsync_n__var;
        lcd__display_enable = lcd__display_enable__var;
        lcd__red = lcd__red__var;
        lcd__green = lcd__green__var;
        lcd__blue = lcd__blue__var;
    end //always

endmodule // riscv_adjunct_de1_cl
