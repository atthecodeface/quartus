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

//a Module picoriscv_de1_cl
module picoriscv_de1_cl
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
        //   DE1 CL daughterboard shifter register control
    reg inputs_control__sr_clock;
    reg inputs_control__sr_shift;
        //   DE1 CL daughterboard neopixel LED pin
    reg led_data_pin;
        //   PS2 output pin driver open collector
    reg ps2_out__data;
    reg ps2_out__clk;
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

    //b Internal and output registers

    //b Internal combinatorials
    reg lcd_source;
    reg [63:0]prv_keyboard__keys_low;
    reg video_reset_n;
    reg prv_reset_n;
    reg led_chain;
    reg csr_request__valid;
    reg csr_request__read_not_write;
    reg [15:0]csr_request__select;
    reg [15:0]csr_request__address;
    reg [31:0]csr_request__data;
    reg io_video_bus__vsync;
    reg io_video_bus__hsync;
    reg io_video_bus__display_enable;
    reg [7:0]io_video_bus__red;
    reg [7:0]io_video_bus__green;
    reg [7:0]io_video_bus__blue;

    //b Internal nets
    wire prv_csr_response__acknowledge;
    wire prv_csr_response__read_data_valid;
    wire prv_csr_response__read_data_error;
    wire [31:0]prv_csr_response__read_data;
    wire prv_video_bus__vsync;
    wire prv_video_bus__hsync;
    wire prv_video_bus__display_enable;
    wire [7:0]prv_video_bus__red;
    wire [7:0]prv_video_bus__green;
    wire [7:0]prv_video_bus__blue;

    //b Clock gating module instances
    //b Module instances
    picoriscv prv(
        .video_clk(video_clk),
        .video_clk__enable(1'b1),
        .clk(clk),
        .clk__enable(1'b1),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .keyboard__keys_low(prv_keyboard__keys_low),
        .video_reset_n(video_reset_n),
        .reset_n(prv_reset_n),
        .csr_response__read_data(            prv_csr_response__read_data),
        .csr_response__read_data_error(            prv_csr_response__read_data_error),
        .csr_response__read_data_valid(            prv_csr_response__read_data_valid),
        .csr_response__acknowledge(            prv_csr_response__acknowledge),
        .video_bus__blue(            prv_video_bus__blue),
        .video_bus__green(            prv_video_bus__green),
        .video_bus__red(            prv_video_bus__red),
        .video_bus__display_enable(            prv_video_bus__display_enable),
        .video_bus__hsync(            prv_video_bus__hsync),
        .video_bus__vsync(            prv_video_bus__vsync)         );
    //b misc_logic combinatorial process
        //   
        //       
    always @ ( * )//misc_logic
    begin: misc_logic__comb_code
        prv_reset_n = (reset_n & switches[0]);
        video_reset_n = (reset_n & video_locked);
    end //always

    //b prv_de1_cl_instantiations combinatorial process
    always @ ( * )//prv_de1_cl_instantiations
    begin: prv_de1_cl_instantiations__comb_code
        lcd_source = 1'h0;
        prv_keyboard__keys_low = 64'h0;
        led_chain = 1'h0;
        csr_request__valid = 1'h0;
        csr_request__read_not_write = 1'h0;
        csr_request__select = 16'h0;
        csr_request__address = 16'h0;
        csr_request__data = 32'h0;
        io_video_bus__vsync = 1'h0;
        io_video_bus__hsync = 1'h0;
        io_video_bus__display_enable = 1'h0;
        io_video_bus__red = 8'h0;
        io_video_bus__green = 8'h0;
        io_video_bus__blue = 8'h0;
        inputs_control__sr_clock = 1'h0;
        inputs_control__sr_shift = 1'h0;
        ps2_out__data = 1'h0;
        ps2_out__clk = 1'h0;
        leds = 10'h0;
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
        lcd__vsync_n__var = !(prv_video_bus__vsync!=1'h0);
        lcd__hsync_n__var = !(prv_video_bus__hsync!=1'h0);
        lcd__display_enable__var = prv_video_bus__display_enable;
        lcd__red__var = prv_video_bus__red[7:2];
        lcd__green__var = prv_video_bus__green[7:1];
        lcd__blue__var = prv_video_bus__blue[7:2];
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

endmodule // picoriscv_de1_cl
