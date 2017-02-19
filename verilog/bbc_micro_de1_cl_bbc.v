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

//a Module bbc_micro_de1_cl_bbc
module bbc_micro_de1_cl_bbc
(
    video_clk,
    video_clk__enable,
    clk,
    clk__enable,

    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    bbc_keyboard__reset_pressed,
    bbc_keyboard__keys_down_cols_0_to_7,
    bbc_keyboard__keys_down_cols_8_to_9,
    framebuffer_reset_n,
    bbc_reset_n,
    reset_n,

    csr_response__ack,
    csr_response__read_data_valid,
    csr_response__read_data,
    video_bus__vsync,
    video_bus__hsync,
    video_bus__display_enable,
    video_bus__red,
    video_bus__green,
    video_bus__blue,
    clock_control__enable_cpu,
    clock_control__will_enable_2MHz_video,
    clock_control__enable_2MHz_video,
    clock_control__enable_1MHz_rising,
    clock_control__enable_1MHz_falling,
    clock_control__phi,
    clock_control__reset_cpu,
    clock_control__debug
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
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
    input bbc_keyboard__reset_pressed;
    input [63:0]bbc_keyboard__keys_down_cols_0_to_7;
    input [15:0]bbc_keyboard__keys_down_cols_8_to_9;
    input framebuffer_reset_n;
    input bbc_reset_n;
        //   hard reset from a pin - a key on DE1
    input reset_n;

    //b Outputs
    output csr_response__ack;
    output csr_response__read_data_valid;
    output [31:0]csr_response__read_data;
    output video_bus__vsync;
    output video_bus__hsync;
    output video_bus__display_enable;
    output [7:0]video_bus__red;
    output [7:0]video_bus__green;
    output [7:0]video_bus__blue;
    output clock_control__enable_cpu;
    output clock_control__will_enable_2MHz_video;
    output clock_control__enable_2MHz_video;
    output clock_control__enable_1MHz_rising;
    output clock_control__enable_1MHz_falling;
    output [1:0]clock_control__phi;
    output clock_control__reset_cpu;
    output [3:0]clock_control__debug;

// output components here

    //b Output combinatorials

    //b Output nets
    wire video_bus__vsync;
    wire video_bus__hsync;
    wire video_bus__display_enable;
    wire [7:0]video_bus__red;
    wire [7:0]video_bus__green;
    wire [7:0]video_bus__blue;
    wire clock_control__enable_cpu;
    wire clock_control__will_enable_2MHz_video;
    wire clock_control__enable_2MHz_video;
    wire clock_control__enable_1MHz_rising;
    wire clock_control__enable_1MHz_falling;
    wire [1:0]clock_control__phi;
    wire clock_control__reset_cpu;
    wire [3:0]clock_control__debug;

    //b Internal and output registers
    reg floppy_sram_response__ack;
    reg floppy_sram_response__read_data_valid;
    reg [31:0]floppy_sram_response__read_data;
    reg floppy_sram_request_r__enable;
    reg floppy_sram_request_r__read_not_write;
    reg [19:0]floppy_sram_request_r__address;
    reg [31:0]floppy_sram_request_r__write_data;
    reg floppy_sram_reading;
    reg csr_response__ack;
    reg csr_response__read_data_valid;
    reg [31:0]csr_response__read_data;

    //b Internal combinatorials
    reg enable_cpu_clk;
    reg enable_clk_2MHz_video;
    reg bbc_micro_host_sram_request__valid;
    reg bbc_micro_host_sram_request__read_enable;
    reg bbc_micro_host_sram_request__write_enable;
    reg [7:0]bbc_micro_host_sram_request__select;
    reg [23:0]bbc_micro_host_sram_request__address;
    reg [63:0]bbc_micro_host_sram_request__write_data;
    reg combined_csr_response__ack;
    reg combined_csr_response__read_data_valid;
    reg [31:0]combined_csr_response__read_data;

    //b Internal nets
    wire [31:0]floppy_sram_read_data;
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
    wire display__clock_enable;
    wire display__hsync;
    wire display__vsync;
    wire [2:0]display__pixels_per_clock;
    wire [7:0]display__red;
    wire [7:0]display__green;
    wire [7:0]display__blue;

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
        .clock_control__debug(            clock_control__debug),
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
        .keyboard__keys_down_cols_8_to_9(bbc_keyboard__keys_down_cols_8_to_9),
        .keyboard__keys_down_cols_0_to_7(bbc_keyboard__keys_down_cols_0_to_7),
        .keyboard__reset_pressed(bbc_keyboard__reset_pressed),
        .clock_control__debug(clock_control__debug),
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
    //b bbc_micro_instantiations__comb combinatorial process
    always @ ( * )//bbc_micro_instantiations__comb
    begin: bbc_micro_instantiations__comb_code
    reg combined_csr_response__ack__var;
    reg combined_csr_response__read_data_valid__var;
    reg [31:0]combined_csr_response__read_data__var;
        bbc_micro_host_sram_request__valid = 1'h0;
        bbc_micro_host_sram_request__read_enable = 1'h0;
        bbc_micro_host_sram_request__write_enable = 1'h0;
        bbc_micro_host_sram_request__select = 8'h0;
        bbc_micro_host_sram_request__address = 24'h0;
        bbc_micro_host_sram_request__write_data = 64'h0;
        enable_cpu_clk = clock_control__enable_cpu;
        enable_clk_2MHz_video = clock_control__enable_2MHz_video;
        combined_csr_response__ack__var = clocking_csr_response__ack;
        combined_csr_response__read_data_valid__var = clocking_csr_response__read_data_valid;
        combined_csr_response__read_data__var = clocking_csr_response__read_data;
        combined_csr_response__ack__var = combined_csr_response__ack__var | display_sram_csr_response__ack;
        combined_csr_response__read_data_valid__var = combined_csr_response__read_data_valid__var | display_sram_csr_response__read_data_valid;
        combined_csr_response__read_data__var = combined_csr_response__read_data__var | display_sram_csr_response__read_data;
        combined_csr_response__ack__var = combined_csr_response__ack__var | floppy_sram_csr_response__ack;
        combined_csr_response__read_data_valid__var = combined_csr_response__read_data_valid__var | floppy_sram_csr_response__read_data_valid;
        combined_csr_response__read_data__var = combined_csr_response__read_data__var | floppy_sram_csr_response__read_data;
        combined_csr_response__ack__var = combined_csr_response__ack__var | framebuffer_csr_response__ack;
        combined_csr_response__read_data_valid__var = combined_csr_response__read_data_valid__var | framebuffer_csr_response__read_data_valid;
        combined_csr_response__read_data__var = combined_csr_response__read_data__var | framebuffer_csr_response__read_data;
        combined_csr_response__ack = combined_csr_response__ack__var;
        combined_csr_response__read_data_valid = combined_csr_response__read_data_valid__var;
        combined_csr_response__read_data = combined_csr_response__read_data__var;
    end //always

    //b bbc_micro_instantiations__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : bbc_micro_instantiations__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            csr_response__ack <= 1'h0;
            csr_response__read_data_valid <= 1'h0;
            csr_response__read_data <= 32'h0;
        end
        else if (clk__enable)
        begin
            csr_response__ack <= combined_csr_response__ack;
            csr_response__read_data_valid <= combined_csr_response__read_data_valid;
            csr_response__read_data <= combined_csr_response__read_data;
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

endmodule // bbc_micro_de1_cl_bbc
