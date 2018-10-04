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
    de1_cl_lcd_clock,
    de1_cl_lcd_clock__enable,
    de1_vga_clock,
    de1_vga_clock__enable,
    clk,
    clk__enable,

    de1_cl_inputs_status__sr_data,
    de1_cl_inputs_status__left_rotary__direction_pin,
    de1_cl_inputs_status__left_rotary__transition_pin,
    de1_cl_inputs_status__right_rotary__direction_pin,
    de1_cl_inputs_status__right_rotary__transition_pin,
    de1_ps2b_in__data,
    de1_ps2b_in__clk,
    de1_ps2_in__data,
    de1_ps2_in__clk,
    de1_inputs__irda_rxd,
    de1_inputs__keys,
    de1_inputs__switches,
    de1_cl_lcd_clock_locked,
    de1_vga_clock_locked,
    de1_cl_lcd_reset_n,
    de1_vga_reset_n,
    reset_n,

    de1_cl_inputs_control__sr_clock,
    de1_cl_inputs_control__sr_shift,
    de1_vga__vs,
    de1_vga__hs,
    de1_vga__blank_n,
    de1_vga__sync_n,
    de1_vga__red,
    de1_vga__green,
    de1_vga__blue,
    de1_irda_txd,
    de1_cl_led_data_pin,
    de1_ps2b_out__data,
    de1_ps2b_out__clk,
    de1_ps2_out__data,
    de1_ps2_out__clk,
    de1_leds__leds,
    de1_leds__h0,
    de1_leds__h1,
    de1_leds__h2,
    de1_leds__h3,
    de1_leds__h4,
    de1_leds__h5,
    de1_cl_lcd__vsync_n,
    de1_cl_lcd__hsync_n,
    de1_cl_lcd__display_enable,
    de1_cl_lcd__red,
    de1_cl_lcd__green,
    de1_cl_lcd__blue,
    de1_cl_lcd__backlight
);

    //b Clocks
        //   9MHz clock from PLL, derived from 50MHz
    input de1_cl_lcd_clock;
    input de1_cl_lcd_clock__enable;
        //   VGA clock, not used
    input de1_vga_clock;
    input de1_vga_clock__enable;
        //   50MHz clock from DE1 clock generator
    input clk;
    input clk__enable;

    //b Inputs
        //   DE1 CL daughterboard shifter register etc status
    input de1_cl_inputs_status__sr_data;
    input de1_cl_inputs_status__left_rotary__direction_pin;
    input de1_cl_inputs_status__left_rotary__transition_pin;
    input de1_cl_inputs_status__right_rotary__direction_pin;
    input de1_cl_inputs_status__right_rotary__transition_pin;
        //   PS2 input pins
    input de1_ps2b_in__data;
    input de1_ps2b_in__clk;
        //   PS2 input pins
    input de1_ps2_in__data;
    input de1_ps2_in__clk;
        //   DE1 inputs
    input de1_inputs__irda_rxd;
    input [3:0]de1_inputs__keys;
    input [9:0]de1_inputs__switches;
        //   High if LCD PLL has locked
    input de1_cl_lcd_clock_locked;
        //   High if VGA PLL has locked
    input de1_vga_clock_locked;
        //   Combination of resets
    input de1_cl_lcd_reset_n;
        //   Combination of resets
    input de1_vga_reset_n;
        //   hard reset from a pin - a key on DE1
    input reset_n;

    //b Outputs
        //   DE1 CL daughterboard shifter register control
    output de1_cl_inputs_control__sr_clock;
    output de1_cl_inputs_control__sr_shift;
        //   DE1 VGA board output
    output de1_vga__vs;
    output de1_vga__hs;
    output de1_vga__blank_n;
    output de1_vga__sync_n;
    output [9:0]de1_vga__red;
    output [9:0]de1_vga__green;
    output [9:0]de1_vga__blue;
        //   IrDA tx data pin
    output de1_irda_txd;
        //   DE1 CL daughterboard neopixel LED pin
    output de1_cl_led_data_pin;
        //   PS2 output pin driver open collector
    output de1_ps2b_out__data;
    output de1_ps2b_out__clk;
        //   PS2 output pin driver open collector
    output de1_ps2_out__data;
    output de1_ps2_out__clk;
        //   DE1 LEDs (red+hex)
    output [9:0]de1_leds__leds;
    output [6:0]de1_leds__h0;
    output [6:0]de1_leds__h1;
    output [6:0]de1_leds__h2;
    output [6:0]de1_leds__h3;
    output [6:0]de1_leds__h4;
    output [6:0]de1_leds__h5;
        //   LCD display out to computer lab daughterboard
    output de1_cl_lcd__vsync_n;
    output de1_cl_lcd__hsync_n;
    output de1_cl_lcd__display_enable;
    output [5:0]de1_cl_lcd__red;
    output [6:0]de1_cl_lcd__green;
    output [5:0]de1_cl_lcd__blue;
    output de1_cl_lcd__backlight;

// output components here

    //b Output combinatorials
        //   DE1 VGA board output
    reg de1_vga__vs;
    reg de1_vga__hs;
    reg de1_vga__blank_n;
    reg de1_vga__sync_n;
    reg [9:0]de1_vga__red;
    reg [9:0]de1_vga__green;
    reg [9:0]de1_vga__blue;
        //   IrDA tx data pin
    reg de1_irda_txd;
        //   DE1 CL daughterboard neopixel LED pin
    reg de1_cl_led_data_pin;
        //   PS2 output pin driver open collector
    reg de1_ps2b_out__data;
    reg de1_ps2b_out__clk;
        //   LCD display out to computer lab daughterboard
    reg de1_cl_lcd__vsync_n;
    reg de1_cl_lcd__hsync_n;
    reg de1_cl_lcd__display_enable;
    reg [5:0]de1_cl_lcd__red;
    reg [6:0]de1_cl_lcd__green;
    reg [5:0]de1_cl_lcd__blue;
    reg de1_cl_lcd__backlight;

    //b Output nets
        //   DE1 CL daughterboard shifter register control
    wire de1_cl_inputs_control__sr_clock;
    wire de1_cl_inputs_control__sr_shift;
        //   PS2 output pin driver open collector
    wire de1_ps2_out__data;
    wire de1_ps2_out__clk;
        //   DE1 LEDs (red+hex)
    wire [9:0]de1_leds__leds;
    wire [6:0]de1_leds__h0;
    wire [6:0]de1_leds__h1;
    wire [6:0]de1_leds__h2;
    wire [6:0]de1_leds__h3;
    wire [6:0]de1_leds__h4;
    wire [6:0]de1_leds__h5;

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
        .video_clk(de1_cl_lcd_clock),
        .video_clk__enable(1'b1),
        .clk(clk),
        .clk__enable(1'b1),
        .ps2_in__clk(de1_ps2_in__clk),
        .ps2_in__data(de1_ps2_in__data),
        .inputs_status__right_rotary__transition_pin(de1_cl_inputs_status__right_rotary__transition_pin),
        .inputs_status__right_rotary__direction_pin(de1_cl_inputs_status__right_rotary__direction_pin),
        .inputs_status__left_rotary__transition_pin(de1_cl_inputs_status__left_rotary__transition_pin),
        .inputs_status__left_rotary__direction_pin(de1_cl_inputs_status__left_rotary__direction_pin),
        .inputs_status__sr_data(de1_cl_inputs_status__sr_data),
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
        .de1_inputs__switches(de1_inputs__switches),
        .de1_inputs__keys(de1_inputs__keys),
        .de1_inputs__irda_rxd(de1_inputs__irda_rxd),
        .framebuffer_reset_n(framebuffer_reset_n),
        .bbc_reset_n(bbc_reset_n),
        .reset_n(reset_n),
        .led_chain(            led_chain),
        .de1_leds__h5(            de1_leds__h5),
        .de1_leds__h4(            de1_leds__h4),
        .de1_leds__h3(            de1_leds__h3),
        .de1_leds__h2(            de1_leds__h2),
        .de1_leds__h1(            de1_leds__h1),
        .de1_leds__h0(            de1_leds__h0),
        .de1_leds__leds(            de1_leds__leds),
        .lcd_source(            lcd_source),
        .ps2_out__clk(            de1_ps2_out__clk),
        .ps2_out__data(            de1_ps2_out__data),
        .inputs_control__sr_shift(            de1_cl_inputs_control__sr_shift),
        .inputs_control__sr_clock(            de1_cl_inputs_control__sr_clock),
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
        .video_clk(de1_cl_lcd_clock),
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
        bbc_reset_n = ((reset_n & !(bbc_clock_control__reset_cpu!=1'h0)) & de1_inputs__switches[0]);
        framebuffer_reset_n = (reset_n & de1_cl_lcd_clock_locked);
        de1_irda_txd = 1'h0;
        de1_vga__vs = 1'h0;
        de1_vga__hs = 1'h0;
        de1_vga__blank_n = 1'h0;
        de1_vga__sync_n = 1'h0;
        de1_vga__red = 10'h0;
        de1_vga__green = 10'h0;
        de1_vga__blue = 10'h0;
        de1_ps2b_out__data = 1'h0;
        de1_ps2b_out__clk = 1'h0;
    end //always

    //b output_muxes combinatorial process
        //   
        //       
    always @ ( * )//output_muxes
    begin: output_muxes__comb_code
    reg de1_cl_lcd__vsync_n__var;
    reg de1_cl_lcd__hsync_n__var;
    reg de1_cl_lcd__display_enable__var;
    reg [5:0]de1_cl_lcd__red__var;
    reg [6:0]de1_cl_lcd__green__var;
    reg [5:0]de1_cl_lcd__blue__var;
        de1_cl_lcd__vsync_n__var = !(bbc_video_bus__vsync!=1'h0);
        de1_cl_lcd__hsync_n__var = !(bbc_video_bus__hsync!=1'h0);
        de1_cl_lcd__display_enable__var = bbc_video_bus__display_enable;
        de1_cl_lcd__red__var = bbc_video_bus__red[7:2];
        de1_cl_lcd__green__var = bbc_video_bus__green[7:1];
        de1_cl_lcd__blue__var = bbc_video_bus__blue[7:2];
        de1_cl_lcd__backlight = de1_inputs__switches[1];
        if ((lcd_source!=1'h0))
        begin
            de1_cl_lcd__vsync_n__var = !(io_video_bus__vsync!=1'h0);
            de1_cl_lcd__hsync_n__var = !(io_video_bus__hsync!=1'h0);
            de1_cl_lcd__display_enable__var = io_video_bus__display_enable;
            de1_cl_lcd__red__var = io_video_bus__red[7:2];
            de1_cl_lcd__green__var = io_video_bus__green[7:1];
            de1_cl_lcd__blue__var = io_video_bus__blue[7:2];
        end //if
        de1_cl_led_data_pin = !(led_chain!=1'h0);
        de1_cl_lcd__vsync_n = de1_cl_lcd__vsync_n__var;
        de1_cl_lcd__hsync_n = de1_cl_lcd__hsync_n__var;
        de1_cl_lcd__display_enable = de1_cl_lcd__display_enable__var;
        de1_cl_lcd__red = de1_cl_lcd__red__var;
        de1_cl_lcd__green = de1_cl_lcd__green__var;
        de1_cl_lcd__blue = de1_cl_lcd__blue__var;
    end //always

endmodule // bbc_micro_de1_cl
