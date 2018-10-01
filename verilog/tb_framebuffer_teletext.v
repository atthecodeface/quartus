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

//a Module tb_framebuffer_teletext
module tb_framebuffer_teletext
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

    //b Internal nets
    wire csr_response__acknowledge;
    wire csr_response__read_data_valid;
    wire csr_response__read_data_error;
    wire [31:0]csr_response__read_data;
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
    wire display_sram_write__valid;
    wire [3:0]display_sram_write__id;
    wire display_sram_write__read_not_write;
    wire [7:0]display_sram_write__byte_enable;
    wire [31:0]display_sram_write__address;
    wire [63:0]display_sram_write__write_data;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_response__read_data(csr_response__read_data),
        .csr_response__read_data_error(csr_response__read_data_error),
        .csr_response__read_data_valid(csr_response__read_data_valid),
        .csr_response__acknowledge(csr_response__acknowledge),
        .video_bus__blue(video_bus__blue),
        .video_bus__green(video_bus__green),
        .video_bus__red(video_bus__red),
        .video_bus__display_enable(video_bus__display_enable),
        .video_bus__hsync(video_bus__hsync),
        .video_bus__vsync(video_bus__vsync),
        .csr_request__data(            csr_request__data),
        .csr_request__address(            csr_request__address),
        .csr_request__select(            csr_request__select),
        .csr_request__read_not_write(            csr_request__read_not_write),
        .csr_request__valid(            csr_request__valid),
        .display_sram_write__write_data(            display_sram_write__write_data),
        .display_sram_write__address(            display_sram_write__address),
        .display_sram_write__byte_enable(            display_sram_write__byte_enable),
        .display_sram_write__read_not_write(            display_sram_write__read_not_write),
        .display_sram_write__id(            display_sram_write__id),
        .display_sram_write__valid(            display_sram_write__valid)         );
    framebuffer_teletext fb(
        .video_clk(clk),
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
        .csr_select_in(16'h0),
        .display_sram_write__write_data(display_sram_write__write_data),
        .display_sram_write__address(display_sram_write__address),
        .display_sram_write__byte_enable(display_sram_write__byte_enable),
        .display_sram_write__read_not_write(display_sram_write__read_not_write),
        .display_sram_write__id(display_sram_write__id),
        .display_sram_write__valid(display_sram_write__valid),
        .reset_n(reset_n),
        .csr_response__read_data(            csr_response__read_data),
        .csr_response__read_data_error(            csr_response__read_data_error),
        .csr_response__read_data_valid(            csr_response__read_data_valid),
        .csr_response__acknowledge(            csr_response__acknowledge),
        .video_bus__blue(            video_bus__blue),
        .video_bus__green(            video_bus__green),
        .video_bus__red(            video_bus__red),
        .video_bus__display_enable(            video_bus__display_enable),
        .video_bus__hsync(            video_bus__hsync),
        .video_bus__vsync(            video_bus__vsync)         );
endmodule // tb_framebuffer_teletext
