//a Note: created by CDL 1.4 - do not hand edit without recognizing it will be out of sync with the source
// Output mode 0 (VMOD=1, standard verilog=0)
// Verilog option comb reg suffix '__var'
// Verilog option include_displays 0
// Verilog option include_assertions 1
// Verilog option sv_assertions 0
// Verilog option assert delay string '<NULL>'
// Verilog option include_coverage 0
// Verilog option clock_gate_module_instance_type 'clock_gate_module'
// Verilog option clock_gate_module_instance_extra_ports ''

//a Module bbc_micro_with_rams
module bbc_micro_with_rams
(
    clk,

    host_sram_request__valid,
    host_sram_request__read_enable,
    host_sram_request__write_enable,
    host_sram_request__select,
    host_sram_request__address,
    host_sram_request__write_data,
    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    reset_n,

    display_sram_write__enable,
    display_sram_write__data,
    display_sram_write__address,
    host_sram_response__ack,
    host_sram_response__read_data_valid,
    host_sram_response__read_data,
    csr_response__ack,
    csr_response__read_data_valid,
    csr_response__read_data
);

    //b Clocks
        //   4MHz clock in as a minimum
    input clk;
    wire clk_cpu; // Gated version of clock 'clk' enabled by 'enable_cpu_clk'
    wire clk_2MHz_video_clock; // Gated version of clock 'clk' enabled by 'enable_clk_2MHz_video'

    //b Inputs
    input host_sram_request__valid;
    input host_sram_request__read_enable;
    input host_sram_request__write_enable;
    input [7:0]host_sram_request__select;
    input [23:0]host_sram_request__address;
    input [63:0]host_sram_request__write_data;
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
    input reset_n;

    //b Outputs
    output display_sram_write__enable;
    output [47:0]display_sram_write__data;
    output [15:0]display_sram_write__address;
    output host_sram_response__ack;
    output host_sram_response__read_data_valid;
    output [63:0]host_sram_response__read_data;
    output csr_response__ack;
    output csr_response__read_data_valid;
    output [31:0]csr_response__read_data;

// output components here

    //b Output combinatorials
    reg csr_response__ack;
    reg csr_response__read_data_valid;
    reg [31:0]csr_response__read_data;

    //b Output nets
    wire display_sram_write__enable;
    wire [47:0]display_sram_write__data;
    wire [15:0]display_sram_write__address;
    wire host_sram_response__ack;
    wire host_sram_response__read_data_valid;
    wire [63:0]host_sram_response__read_data;

    //b Internal and output registers

    //b Internal combinatorials
    reg bbc_reset_n;
    reg enable_cpu_clk;
    reg enable_clk_2MHz_video;

    //b Internal nets
    wire keyboard__reset_pressed;
    wire [63:0]keyboard__keys_down_cols_0_to_7;
    wire [15:0]keyboard__keys_down_cols_8_to_9;
    wire bbc_micro_host_sram_response__ack;
    wire bbc_micro_host_sram_response__read_data_valid;
    wire [63:0]bbc_micro_host_sram_response__read_data;
    wire bbc_micro_host_sram_request__valid;
    wire bbc_micro_host_sram_request__read_enable;
    wire bbc_micro_host_sram_request__write_enable;
    wire [7:0]bbc_micro_host_sram_request__select;
    wire [23:0]bbc_micro_host_sram_request__address;
    wire [63:0]bbc_micro_host_sram_request__write_data;
    wire floppy_sram_response__ack;
    wire floppy_sram_response__read_data_valid;
    wire [31:0]floppy_sram_response__read_data;
    wire floppy_sram_request__enable;
    wire floppy_sram_request__read_not_write;
    wire [19:0]floppy_sram_request__address;
    wire [31:0]floppy_sram_request__write_data;
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

    //b Clock gating module instances
    clock_gate_module clk_cpu__gen( .CLK_IN(clk), .ENABLE(enable_cpu_clk), .CLK_OUT(clk_cpu) );
    clock_gate_module clk_2MHz_video_clock__gen( .CLK_IN(clk), .ENABLE(enable_clk_2MHz_video), .CLK_OUT(clk_2MHz_video_clock) );
    //b Module instances
    bbc_micro_clocking clocking(
        .clk(clk),
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
        .clk(clk_2MHz_video_clock),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .keyboard_reset_n(1'h1),
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
        .sram_write__enable(            display_sram_write__enable),
        .keyboard__keys_down_cols_8_to_9(            keyboard__keys_down_cols_8_to_9),
        .keyboard__keys_down_cols_0_to_7(            keyboard__keys_down_cols_0_to_7),
        .keyboard__reset_pressed(            keyboard__reset_pressed)         );
    bbc_floppy_sram floppy_sram(
        .clk(clk_cpu),
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
    bbc_micro_rams rams(
        .clk(clk),
        .bbc_micro_host_sram_response__read_data(bbc_micro_host_sram_response__read_data),
        .bbc_micro_host_sram_response__read_data_valid(bbc_micro_host_sram_response__read_data_valid),
        .bbc_micro_host_sram_response__ack(bbc_micro_host_sram_response__ack),
        .floppy_sram_request__write_data(floppy_sram_request__write_data),
        .floppy_sram_request__address(floppy_sram_request__address),
        .floppy_sram_request__read_not_write(floppy_sram_request__read_not_write),
        .floppy_sram_request__enable(floppy_sram_request__enable),
        .display_sram_write__address(display_sram_write__address),
        .display_sram_write__data(display_sram_write__data),
        .display_sram_write__enable(display_sram_write__enable),
        .host_sram_request__write_data(host_sram_request__write_data),
        .host_sram_request__address(host_sram_request__address),
        .host_sram_request__select(host_sram_request__select),
        .host_sram_request__write_enable(host_sram_request__write_enable),
        .host_sram_request__read_enable(host_sram_request__read_enable),
        .host_sram_request__valid(host_sram_request__valid),
        .clock_control__reset_cpu(clock_control__reset_cpu),
        .clock_control__phi(clock_control__phi),
        .clock_control__enable_1MHz_falling(clock_control__enable_1MHz_falling),
        .clock_control__enable_1MHz_rising(clock_control__enable_1MHz_rising),
        .clock_control__enable_2MHz_video(clock_control__enable_2MHz_video),
        .clock_control__will_enable_2MHz_video(clock_control__will_enable_2MHz_video),
        .clock_control__enable_cpu(clock_control__enable_cpu),
        .reset_n(reset_n),
        .bbc_micro_host_sram_request__write_data(            bbc_micro_host_sram_request__write_data),
        .bbc_micro_host_sram_request__address(            bbc_micro_host_sram_request__address),
        .bbc_micro_host_sram_request__select(            bbc_micro_host_sram_request__select),
        .bbc_micro_host_sram_request__write_enable(            bbc_micro_host_sram_request__write_enable),
        .bbc_micro_host_sram_request__read_enable(            bbc_micro_host_sram_request__read_enable),
        .bbc_micro_host_sram_request__valid(            bbc_micro_host_sram_request__valid),
        .floppy_sram_response__read_data(            floppy_sram_response__read_data),
        .floppy_sram_response__read_data_valid(            floppy_sram_response__read_data_valid),
        .floppy_sram_response__ack(            floppy_sram_response__ack),
        .host_sram_response__read_data(            host_sram_response__read_data),
        .host_sram_response__read_data_valid(            host_sram_response__read_data_valid),
        .host_sram_response__ack(            host_sram_response__ack)         );
    //b stuff combinatorial process
        //   
        //       
    always @( //stuff
        floppy_sram_csr_response__ack or
        display_sram_csr_response__ack or
        clocking_csr_response__ack or
        floppy_sram_csr_response__read_data_valid or
        display_sram_csr_response__read_data_valid or
        clocking_csr_response__read_data_valid or
        floppy_sram_csr_response__read_data or
        display_sram_csr_response__read_data or
        clocking_csr_response__read_data or
        clock_control__enable_2MHz_video or
        clock_control__enable_cpu or
        reset_n or
        clock_control__reset_cpu )
    begin: stuff__comb_code
    reg csr_response__ack__var;
    reg csr_response__read_data_valid__var;
    reg [31:0]csr_response__read_data__var;
        csr_response__ack__var = floppy_sram_csr_response__ack;
        csr_response__read_data_valid__var = floppy_sram_csr_response__read_data_valid;
        csr_response__read_data__var = floppy_sram_csr_response__read_data;
        csr_response__ack__var = csr_response__ack__var | display_sram_csr_response__ack;
        csr_response__read_data_valid__var = csr_response__read_data_valid__var | display_sram_csr_response__read_data_valid;
        csr_response__read_data__var = csr_response__read_data__var | display_sram_csr_response__read_data;
        csr_response__ack__var = csr_response__ack__var | clocking_csr_response__ack;
        csr_response__read_data_valid__var = csr_response__read_data_valid__var | clocking_csr_response__read_data_valid;
        csr_response__read_data__var = csr_response__read_data__var | clocking_csr_response__read_data;
        enable_clk_2MHz_video = clock_control__enable_2MHz_video;
        enable_cpu_clk = clock_control__enable_cpu;
        bbc_reset_n = (reset_n & !(clock_control__reset_cpu!=1'h0));
        csr_response__ack = csr_response__ack__var;
        csr_response__read_data_valid = csr_response__read_data_valid__var;
        csr_response__read_data = csr_response__read_data__var;
    end //always

endmodule // bbc_micro_with_rams