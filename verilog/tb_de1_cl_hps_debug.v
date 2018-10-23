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

//a Module tb_de1_cl_hps_debug
module tb_de1_cl_hps_debug
(
    clk,
    clk__enable,

    reset_n

);

    //b Clocks
    input clk;
    input clk__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials
    reg de1_irda_rxd;
    reg [9:0]de1_switches;
    reg [3:0]de1_keys;
    reg de1_ps2b_in__data;
    reg de1_ps2b_in__clk;
    reg de1_ps2_in__data;
    reg de1_ps2_in__clk;
    reg de1_cl_inputs_status__sr_data;
    reg de1_cl_inputs_status__left_rotary__direction_pin;
    reg de1_cl_inputs_status__left_rotary__transition_pin;
    reg de1_cl_inputs_status__right_rotary__direction_pin;
    reg de1_cl_inputs_status__right_rotary__transition_pin;

    //b Internal nets
    wire de1_irda_txd;
    wire de1_vga__vs;
    wire de1_vga__hs;
    wire de1_vga__blank_n;
    wire de1_vga__sync_n;
    wire [9:0]de1_vga__red;
    wire [9:0]de1_vga__green;
    wire [9:0]de1_vga__blue;
    wire de1_ps2b_out__data;
    wire de1_ps2b_out__clk;
    wire de1_ps2_out__data;
    wire de1_ps2_out__clk;
    wire [9:0]de1_leds__leds;
    wire [6:0]de1_leds__h0;
    wire [6:0]de1_leds__h1;
    wire [6:0]de1_leds__h2;
    wire [6:0]de1_leds__h3;
    wire [6:0]de1_leds__h4;
    wire [6:0]de1_leds__h5;
    wire de1_cl_lcd__vsync_n;
    wire de1_cl_lcd__hsync_n;
    wire de1_cl_lcd__display_enable;
    wire [5:0]de1_cl_lcd__red;
    wire [6:0]de1_cl_lcd__green;
    wire [5:0]de1_cl_lcd__blue;
    wire de1_cl_lcd__backlight;
    wire de1_cl_led_data_pin;
    wire de1_cl_inputs_control__sr_clock;
    wire de1_cl_inputs_control__sr_shift;
    wire lw_axi_r__valid;
    wire [11:0]lw_axi_r__id;
    wire [31:0]lw_axi_r__data;
    wire [1:0]lw_axi_r__resp;
    wire lw_axi_r__last;
    wire [3:0]lw_axi_r__user;
    wire lw_axi_rready;
    wire lw_axi_b__valid;
    wire [11:0]lw_axi_b__id;
    wire [1:0]lw_axi_b__resp;
    wire [3:0]lw_axi_b__user;
    wire lw_axi_bready;
    wire lw_axi_w__valid;
    wire [11:0]lw_axi_w__id;
    wire [31:0]lw_axi_w__data;
    wire [3:0]lw_axi_w__strb;
    wire lw_axi_w__last;
    wire [3:0]lw_axi_w__user;
    wire lw_axi_wready;
    wire lw_axi_awready;
    wire lw_axi_aw__valid;
    wire [11:0]lw_axi_aw__id;
    wire [31:0]lw_axi_aw__addr;
    wire [3:0]lw_axi_aw__len;
    wire [2:0]lw_axi_aw__size;
    wire [1:0]lw_axi_aw__burst;
    wire [1:0]lw_axi_aw__lock;
    wire [3:0]lw_axi_aw__cache;
    wire [2:0]lw_axi_aw__prot;
    wire [3:0]lw_axi_aw__qos;
    wire [3:0]lw_axi_aw__region;
    wire [3:0]lw_axi_aw__user;
    wire lw_axi_arready;
    wire lw_axi_ar__valid;
    wire [11:0]lw_axi_ar__id;
    wire [31:0]lw_axi_ar__addr;
    wire [3:0]lw_axi_ar__len;
    wire [2:0]lw_axi_ar__size;
    wire [1:0]lw_axi_ar__burst;
    wire [1:0]lw_axi_ar__lock;
    wire [3:0]lw_axi_ar__cache;
    wire [2:0]lw_axi_ar__prot;
    wire [3:0]lw_axi_ar__qos;
    wire [3:0]lw_axi_ar__region;
    wire [3:0]lw_axi_ar__user;

    //b Clock gating module instances
    //b Module instances
    axi_master th(
        .aclk(clk),
        .aclk__enable(1'b1),
        .r__user(lw_axi_r__user),
        .r__last(lw_axi_r__last),
        .r__resp(lw_axi_r__resp),
        .r__data(lw_axi_r__data),
        .r__id(lw_axi_r__id),
        .r__valid(lw_axi_r__valid),
        .b__user(lw_axi_b__user),
        .b__resp(lw_axi_b__resp),
        .b__id(lw_axi_b__id),
        .b__valid(lw_axi_b__valid),
        .wready(lw_axi_wready),
        .awready(lw_axi_awready),
        .arready(lw_axi_arready),
        .areset_n(reset_n),
        .rready(            lw_axi_rready),
        .bready(            lw_axi_bready),
        .w__user(            lw_axi_w__user),
        .w__last(            lw_axi_w__last),
        .w__strb(            lw_axi_w__strb),
        .w__data(            lw_axi_w__data),
        .w__id(            lw_axi_w__id),
        .w__valid(            lw_axi_w__valid),
        .aw__user(            lw_axi_aw__user),
        .aw__region(            lw_axi_aw__region),
        .aw__qos(            lw_axi_aw__qos),
        .aw__prot(            lw_axi_aw__prot),
        .aw__cache(            lw_axi_aw__cache),
        .aw__lock(            lw_axi_aw__lock),
        .aw__burst(            lw_axi_aw__burst),
        .aw__size(            lw_axi_aw__size),
        .aw__len(            lw_axi_aw__len),
        .aw__addr(            lw_axi_aw__addr),
        .aw__id(            lw_axi_aw__id),
        .aw__valid(            lw_axi_aw__valid),
        .ar__user(            lw_axi_ar__user),
        .ar__region(            lw_axi_ar__region),
        .ar__qos(            lw_axi_ar__qos),
        .ar__prot(            lw_axi_ar__prot),
        .ar__cache(            lw_axi_ar__cache),
        .ar__lock(            lw_axi_ar__lock),
        .ar__burst(            lw_axi_ar__burst),
        .ar__size(            lw_axi_ar__size),
        .ar__len(            lw_axi_ar__len),
        .ar__addr(            lw_axi_ar__addr),
        .ar__id(            lw_axi_ar__id),
        .ar__valid(            lw_axi_ar__valid)         );
    de1_cl_hps_debug dut(
        .de1_vga_clock(clk),
        .de1_vga_clock__enable(1'b1),
        .de1_cl_lcd_clock(clk),
        .de1_cl_lcd_clock__enable(1'b1),
        .lw_axi_clock_clk(clk),
        .lw_axi_clock_clk__enable(1'b1),
        .clk(clk),
        .clk__enable(1'b1),
        .de1_irda_rxd(de1_irda_rxd),
        .de1_switches(de1_switches),
        .de1_keys(de1_keys),
        .de1_vga_reset_n(reset_n),
        .de1_ps2b_in__clk(de1_ps2b_in__clk),
        .de1_ps2b_in__data(de1_ps2b_in__data),
        .de1_ps2_in__clk(de1_ps2_in__clk),
        .de1_ps2_in__data(de1_ps2_in__data),
        .de1_cl_lcd_reset_n(reset_n),
        .de1_cl_inputs_status__right_rotary__transition_pin(de1_cl_inputs_status__right_rotary__transition_pin),
        .de1_cl_inputs_status__right_rotary__direction_pin(de1_cl_inputs_status__right_rotary__direction_pin),
        .de1_cl_inputs_status__left_rotary__transition_pin(de1_cl_inputs_status__left_rotary__transition_pin),
        .de1_cl_inputs_status__left_rotary__direction_pin(de1_cl_inputs_status__left_rotary__direction_pin),
        .de1_cl_inputs_status__sr_data(de1_cl_inputs_status__sr_data),
        .lw_axi_rready(lw_axi_rready),
        .lw_axi_bready(lw_axi_bready),
        .lw_axi_w__user(lw_axi_w__user),
        .lw_axi_w__last(lw_axi_w__last),
        .lw_axi_w__strb(lw_axi_w__strb),
        .lw_axi_w__data(lw_axi_w__data),
        .lw_axi_w__id(lw_axi_w__id),
        .lw_axi_w__valid(lw_axi_w__valid),
        .lw_axi_aw__user(lw_axi_aw__user),
        .lw_axi_aw__region(lw_axi_aw__region),
        .lw_axi_aw__qos(lw_axi_aw__qos),
        .lw_axi_aw__prot(lw_axi_aw__prot),
        .lw_axi_aw__cache(lw_axi_aw__cache),
        .lw_axi_aw__lock(lw_axi_aw__lock),
        .lw_axi_aw__burst(lw_axi_aw__burst),
        .lw_axi_aw__size(lw_axi_aw__size),
        .lw_axi_aw__len(lw_axi_aw__len),
        .lw_axi_aw__addr(lw_axi_aw__addr),
        .lw_axi_aw__id(lw_axi_aw__id),
        .lw_axi_aw__valid(lw_axi_aw__valid),
        .lw_axi_ar__user(lw_axi_ar__user),
        .lw_axi_ar__region(lw_axi_ar__region),
        .lw_axi_ar__qos(lw_axi_ar__qos),
        .lw_axi_ar__prot(lw_axi_ar__prot),
        .lw_axi_ar__cache(lw_axi_ar__cache),
        .lw_axi_ar__lock(lw_axi_ar__lock),
        .lw_axi_ar__burst(lw_axi_ar__burst),
        .lw_axi_ar__size(lw_axi_ar__size),
        .lw_axi_ar__len(lw_axi_ar__len),
        .lw_axi_ar__addr(lw_axi_ar__addr),
        .lw_axi_ar__id(lw_axi_ar__id),
        .lw_axi_ar__valid(lw_axi_ar__valid),
        .reset_n(reset_n),
        .de1_irda_txd(            de1_irda_txd),
        .de1_vga__blue(            de1_vga__blue),
        .de1_vga__green(            de1_vga__green),
        .de1_vga__red(            de1_vga__red),
        .de1_vga__sync_n(            de1_vga__sync_n),
        .de1_vga__blank_n(            de1_vga__blank_n),
        .de1_vga__hs(            de1_vga__hs),
        .de1_vga__vs(            de1_vga__vs),
        .de1_ps2b_out__clk(            de1_ps2b_out__clk),
        .de1_ps2b_out__data(            de1_ps2b_out__data),
        .de1_ps2_out__clk(            de1_ps2_out__clk),
        .de1_ps2_out__data(            de1_ps2_out__data),
        .de1_leds__h5(            de1_leds__h5),
        .de1_leds__h4(            de1_leds__h4),
        .de1_leds__h3(            de1_leds__h3),
        .de1_leds__h2(            de1_leds__h2),
        .de1_leds__h1(            de1_leds__h1),
        .de1_leds__h0(            de1_leds__h0),
        .de1_leds__leds(            de1_leds__leds),
        .de1_cl_lcd__backlight(            de1_cl_lcd__backlight),
        .de1_cl_lcd__blue(            de1_cl_lcd__blue),
        .de1_cl_lcd__green(            de1_cl_lcd__green),
        .de1_cl_lcd__red(            de1_cl_lcd__red),
        .de1_cl_lcd__display_enable(            de1_cl_lcd__display_enable),
        .de1_cl_lcd__hsync_n(            de1_cl_lcd__hsync_n),
        .de1_cl_lcd__vsync_n(            de1_cl_lcd__vsync_n),
        .de1_cl_led_data_pin(            de1_cl_led_data_pin),
        .de1_cl_inputs_control__sr_shift(            de1_cl_inputs_control__sr_shift),
        .de1_cl_inputs_control__sr_clock(            de1_cl_inputs_control__sr_clock),
        .lw_axi_r__user(            lw_axi_r__user),
        .lw_axi_r__last(            lw_axi_r__last),
        .lw_axi_r__resp(            lw_axi_r__resp),
        .lw_axi_r__data(            lw_axi_r__data),
        .lw_axi_r__id(            lw_axi_r__id),
        .lw_axi_r__valid(            lw_axi_r__valid),
        .lw_axi_b__user(            lw_axi_b__user),
        .lw_axi_b__resp(            lw_axi_b__resp),
        .lw_axi_b__id(            lw_axi_b__id),
        .lw_axi_b__valid(            lw_axi_b__valid),
        .lw_axi_wready(            lw_axi_wready),
        .lw_axi_awready(            lw_axi_awready),
        .lw_axi_arready(            lw_axi_arready)         );
    //b instantiations combinatorial process
    always @ ( * )//instantiations
    begin: instantiations__comb_code
        de1_keys = 4'h0;
        de1_cl_inputs_status__sr_data = 1'h0;
        de1_cl_inputs_status__left_rotary__direction_pin = 1'h0;
        de1_cl_inputs_status__left_rotary__transition_pin = 1'h0;
        de1_cl_inputs_status__right_rotary__direction_pin = 1'h0;
        de1_cl_inputs_status__right_rotary__transition_pin = 1'h0;
        de1_ps2_in__data = 1'h0;
        de1_ps2_in__clk = 1'h0;
        de1_ps2b_in__data = 1'h0;
        de1_ps2b_in__clk = 1'h0;
        de1_switches = 10'h0;
        de1_irda_rxd = 1'h0;
    end //always

endmodule // tb_de1_cl_hps_debug
