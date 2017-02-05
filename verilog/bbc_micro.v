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

//a Module bbc_micro
module bbc_micro
(
    clk,
    clk__enable,

    host_sram_request__valid,
    host_sram_request__read_enable,
    host_sram_request__write_enable,
    host_sram_request__select,
    host_sram_request__address,
    host_sram_request__write_data,
    floppy_response__sector_id_valid,
    floppy_response__sector_id__track,
    floppy_response__sector_id__head,
    floppy_response__sector_id__sector_number,
    floppy_response__sector_id__sector_length,
    floppy_response__sector_id__bad_crc,
    floppy_response__sector_id__bad_data_crc,
    floppy_response__sector_id__deleted_data,
    floppy_response__index,
    floppy_response__read_data_valid,
    floppy_response__read_data,
    floppy_response__track_zero,
    floppy_response__write_protect,
    floppy_response__disk_ready,
    keyboard__reset_pressed,
    keyboard__keys_down_cols_0_to_7,
    keyboard__keys_down_cols_8_to_9,
    reset_n,
    clock_control__enable_cpu,
    clock_control__will_enable_2MHz_video,
    clock_control__enable_2MHz_video,
    clock_control__enable_1MHz_rising,
    clock_control__enable_1MHz_falling,
    clock_control__phi,
    clock_control__reset_cpu,

    host_sram_response__ack,
    host_sram_response__read_data_valid,
    host_sram_response__read_data,
    floppy_op__step_out,
    floppy_op__step_in,
    floppy_op__next_id,
    floppy_op__read_data_enable,
    floppy_op__write_data_enable,
    floppy_op__write_data,
    floppy_op__write_sector_id_enable,
    floppy_op__sector_id__track,
    floppy_op__sector_id__head,
    floppy_op__sector_id__sector_number,
    floppy_op__sector_id__sector_length,
    floppy_op__sector_id__bad_crc,
    floppy_op__sector_id__bad_data_crc,
    floppy_op__sector_id__deleted_data,
    keyboard_reset_n,
    display__clock_enable,
    display__hsync,
    display__vsync,
    display__pixels_per_clock,
    display__red,
    display__green,
    display__blue,
    clock_status__cpu_1MHz_access
);

    //b Clocks
        //   Clock at least at '4MHz' - CPU runs at least half of this
    input clk;
    input clk__enable;
    wire cpu_clk; // Gated version of clock 'clk' enabled by 'enable_cpu_clk'
    wire cpu_clk__enable;
    wire clk_1MHzE_falling; // Gated version of clock 'clk' enabled by 'enable_clk_1MHz_falling'
    wire clk_1MHzE_falling__enable;
    wire clk_1MHzE_rising; // Gated version of clock 'clk' enabled by 'enable_clk_1MHz_rising'
    wire clk_1MHzE_rising__enable;
    wire clk_2MHz_video_clock; // Gated version of clock 'clk' enabled by 'enable_clk_2MHz_video'
    wire clk_2MHz_video_clock__enable;

    //b Inputs
    input host_sram_request__valid;
    input host_sram_request__read_enable;
    input host_sram_request__write_enable;
    input [7:0]host_sram_request__select;
    input [23:0]host_sram_request__address;
    input [63:0]host_sram_request__write_data;
    input floppy_response__sector_id_valid;
    input [6:0]floppy_response__sector_id__track;
    input floppy_response__sector_id__head;
    input [5:0]floppy_response__sector_id__sector_number;
    input [1:0]floppy_response__sector_id__sector_length;
    input floppy_response__sector_id__bad_crc;
    input floppy_response__sector_id__bad_data_crc;
    input floppy_response__sector_id__deleted_data;
    input floppy_response__index;
    input floppy_response__read_data_valid;
    input [31:0]floppy_response__read_data;
    input floppy_response__track_zero;
    input floppy_response__write_protect;
    input floppy_response__disk_ready;
    input keyboard__reset_pressed;
    input [63:0]keyboard__keys_down_cols_0_to_7;
    input [15:0]keyboard__keys_down_cols_8_to_9;
    input reset_n;
    input clock_control__enable_cpu;
    input clock_control__will_enable_2MHz_video;
    input clock_control__enable_2MHz_video;
    input clock_control__enable_1MHz_rising;
    input clock_control__enable_1MHz_falling;
    input [1:0]clock_control__phi;
    input clock_control__reset_cpu;

    //b Outputs
    output host_sram_response__ack;
    output host_sram_response__read_data_valid;
    output [63:0]host_sram_response__read_data;
    output floppy_op__step_out;
    output floppy_op__step_in;
    output floppy_op__next_id;
    output floppy_op__read_data_enable;
    output floppy_op__write_data_enable;
    output [31:0]floppy_op__write_data;
    output floppy_op__write_sector_id_enable;
    output [6:0]floppy_op__sector_id__track;
    output floppy_op__sector_id__head;
    output [5:0]floppy_op__sector_id__sector_number;
    output [1:0]floppy_op__sector_id__sector_length;
    output floppy_op__sector_id__bad_crc;
    output floppy_op__sector_id__bad_data_crc;
    output floppy_op__sector_id__deleted_data;
    output keyboard_reset_n;
    output display__clock_enable;
    output display__hsync;
    output display__vsync;
    output [2:0]display__pixels_per_clock;
    output [7:0]display__red;
    output [7:0]display__green;
    output [7:0]display__blue;
    output clock_status__cpu_1MHz_access;

// output components here

    //b Output combinatorials
    reg display__clock_enable;
    reg display__hsync;
    reg display__vsync;
    reg [2:0]display__pixels_per_clock;
    reg [7:0]display__red;
    reg [7:0]display__green;
    reg [7:0]display__blue;
    reg clock_status__cpu_1MHz_access;

    //b Output nets
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

    //b Internal and output registers
    reg [3:0]rom_sel;
        //   1MHz clock enable for SAA5050 in video clock domain, reset at start of display period
    reg saa_enable;
        //   Real BBC SAA5050 registers this data on rising 1MHz so gets every other 2MHz clock tick data
    reg saa_lose;
        //   Real BBC clocks on 1MHz falling which is presumably coincident with 2MHz falling (not 1MHzE falling...)
    reg [6:0]saa_data;
    reg [7:0]via_a_latch;
    reg via_a_update_latch;
    reg pending_host_sram_request__valid;
    reg pending_host_sram_request__read_enable;
    reg pending_host_sram_request__write_enable;
    reg [7:0]pending_host_sram_request__select;
    reg [23:0]pending_host_sram_request__address;
    reg [63:0]pending_host_sram_request__write_data;
    reg last_memory_access__read_enable;
    reg last_memory_access__write_enable;
    reg [1:0]last_memory_access__ram_select;
    reg [3:0]last_memory_access__rom_select;
    reg last_memory_access__os_select;
    reg [13:0]last_memory_access__address;
    reg [7:0]last_memory_access__write_data;
    reg host_reading_memory;
    reg cpu_reading_memory;
    reg [7:0]cpu_memory_data_hold;
    reg host_sram_response__ack;
    reg host_sram_response__read_data_valid;
    reg [63:0]host_sram_response__read_data;

    //b Internal combinatorials
    reg nmi_n;
    reg irq_n;
    reg ttx_vdu;
    reg [14:0]video_mem_address;
    reg vsp_rdy_n;
    reg vsp_int_n;
    reg [1:0]lightpen_buttons;
    reg lightpen_strobe;
    reg [7:0]data_out_sheila;
    reg phi2;
    reg phi1;
    reg enable_cpu_clk;
    reg enable_clk_1MHz_falling;
    reg enable_clk_1MHz_rising;
    reg enable_clk_2MHz_video;
    reg [7:0]memory_databus;
    reg [7:0]ram_databus;
    reg memory_access__read_enable;
    reg memory_access__write_enable;
    reg [1:0]memory_access__ram_select;
    reg [3:0]memory_access__rom_select;
    reg memory_access__os_select;
    reg [13:0]memory_access__address;
    reg [7:0]memory_access__write_data;
    reg [1:0]memory_grant;
    reg address_map_decode__fred;
    reg address_map_decode__jim;
    reg address_map_decode__sheila;
    reg address_map_decode__crtc;
    reg address_map_decode__acia;
    reg address_map_decode__serproc;
    reg address_map_decode__intoff;
    reg address_map_decode__vidproc;
    reg address_map_decode__romsel;
    reg address_map_decode__inton;
    reg address_map_decode__via_a;
    reg address_map_decode__via_b;
    reg address_map_decode__fdc;
    reg address_map_decode__adlc;
    reg address_map_decode__adc;
    reg address_map_decode__tube;
    reg address_map_decode__access_1mhz;
    reg [1:0]address_map_decode__rams;
    reg address_map_decode__rom;
    reg address_map_decode__os;
    reg [3:0]address_map_decode__roms;
    reg [7:0]main_databus;

    //b Internal nets
    wire nmi_n_fdc;
    wire selected_key_pressed;
    wire [7:0]via_b_pb_out;
    wire [7:0]via_b_pa_out;
    wire [7:0]via_a_pb_out;
    wire [7:0]via_a_pa_out;
    wire via_a_ca2_in;
    wire [5:0]saa5050_blue;
    wire [5:0]saa5050_green;
    wire [5:0]saa5050_red;
    wire [2:0]vidproc_pixels_valid_per_clock;
    wire [7:0]vidproc_blue;
    wire [7:0]vidproc_green;
    wire [7:0]vidproc_red;
    wire vsync;
    wire hsync;
    wire [4:0]crtc_row_address;
    wire [13:0]crtc_memory_address;
    wire [7:0]crtc_data_out;
    wire crtc_display_enable;
    wire crtc_clock_enable;
    wire irq_n_acia;
    wire [7:0]data_out_acia;
    wire [7:0]data_out_fdc;
    wire irq_n_via_b;
    wire [7:0]data_out_via_b;
    wire irq_n_via_a;
    wire [7:0]data_out_via_a;
        //   Captured at the end of phase 2 (rising clock with phi[1] high)
    wire [7:0]cpu_data_out;
        //   Changes during phase 2 (phi[1] high) with data to write
    wire [7:0]ram1_data_out;
        //   Changes during phase 2 (phi[1] high) with data to write
    wire [7:0]ram0_data_out;
        //   Changes during phase 2 (phi[1] high) with data to write
    wire [7:0]adfs_data_out;
        //   Changes during phase 2 (phi[1] high) with data to write
    wire [7:0]basic_data_out;
        //   Changes during phase 2 (phi[1] high) with data to write
    wire [7:0]os_data_out;
        //   Changes during phase 1 (phi[0] high) with whether to read or write
    wire read_not_write;
        //   Changes during phase 1 (phi[0] high) with address to read or write
    wire [15:0]address;
        //   Goes high during phase 2 if ready was low in phase 1 if read_not_write is 1, to permit someone else to use the memory bus
    wire ba;

    //b Clock gating module instances
    assign cpu_clk__enable = (clk__enable && enable_cpu_clk);
    assign clk_1MHzE_falling__enable = (clk__enable && enable_clk_1MHz_falling);
    assign clk_1MHzE_rising__enable = (clk__enable && enable_clk_1MHz_rising);
    assign clk_2MHz_video_clock__enable = (clk__enable && enable_clk_2MHz_video);
    //b Module instances
    fdc8271 fdc(
        .clk(clk),
        .clk__enable(cpu_clk__enable),
        .bbc_floppy_response__disk_ready(floppy_response__disk_ready),
        .bbc_floppy_response__write_protect(floppy_response__write_protect),
        .bbc_floppy_response__track_zero(floppy_response__track_zero),
        .bbc_floppy_response__read_data(floppy_response__read_data),
        .bbc_floppy_response__read_data_valid(floppy_response__read_data_valid),
        .bbc_floppy_response__index(floppy_response__index),
        .bbc_floppy_response__sector_id__deleted_data(floppy_response__sector_id__deleted_data),
        .bbc_floppy_response__sector_id__bad_data_crc(floppy_response__sector_id__bad_data_crc),
        .bbc_floppy_response__sector_id__bad_crc(floppy_response__sector_id__bad_crc),
        .bbc_floppy_response__sector_id__sector_length(floppy_response__sector_id__sector_length),
        .bbc_floppy_response__sector_id__sector_number(floppy_response__sector_id__sector_number),
        .bbc_floppy_response__sector_id__head(floppy_response__sector_id__head),
        .bbc_floppy_response__sector_id__track(floppy_response__sector_id__track),
        .bbc_floppy_response__sector_id_valid(floppy_response__sector_id_valid),
        .ready(2'h0),
        .index_n(1'h1),
        .write_protect_n(1'h1),
        .track_0_n(1'h1),
        .data_in(cpu_data_out),
        .data_ack_n(!((address[2] & address_map_decode__fdc)!=1'h0)),
        .address(address[1:0]),
        .write_n(read_not_write),
        .read_n(!(read_not_write!=1'h0)),
        .chip_select_n(!(address_map_decode__fdc!=1'h0)),
        .reset_n(reset_n),
        .bbc_floppy_op__sector_id__deleted_data(            floppy_op__sector_id__deleted_data),
        .bbc_floppy_op__sector_id__bad_data_crc(            floppy_op__sector_id__bad_data_crc),
        .bbc_floppy_op__sector_id__bad_crc(            floppy_op__sector_id__bad_crc),
        .bbc_floppy_op__sector_id__sector_length(            floppy_op__sector_id__sector_length),
        .bbc_floppy_op__sector_id__sector_number(            floppy_op__sector_id__sector_number),
        .bbc_floppy_op__sector_id__head(            floppy_op__sector_id__head),
        .bbc_floppy_op__sector_id__track(            floppy_op__sector_id__track),
        .bbc_floppy_op__write_sector_id_enable(            floppy_op__write_sector_id_enable),
        .bbc_floppy_op__write_data(            floppy_op__write_data),
        .bbc_floppy_op__write_data_enable(            floppy_op__write_data_enable),
        .bbc_floppy_op__read_data_enable(            floppy_op__read_data_enable),
        .bbc_floppy_op__next_id(            floppy_op__next_id),
        .bbc_floppy_op__step_in(            floppy_op__step_in),
        .bbc_floppy_op__step_out(            floppy_op__step_out),
        .irq_n(            nmi_n_fdc),
        .data_out(            data_out_fdc)         );
    acia6850 acia(
        .clk(clk),
        .clk__enable(clk_1MHzE_falling__enable),
        .dcd(1'h1),
        .cts(1'h1),
        .rxd(1'h1),
        .rx_clk(1'h1),
        .tx_clk(1'h1),
        .data_in(cpu_data_out),
        .address(address[0]),
        .chip_select_n(!(address_map_decode__acia!=1'h0)),
        .chip_select(2'h3),
        .read_not_write(read_not_write),
        .reset_n(reset_n),
        .irq_n(            irq_n_acia),
        .data_out(            data_out_acia)         );
    via6522 via_a(
        .clk_io(clk),
        .clk_io__enable(clk_1MHzE_rising__enable),
        .clk(clk),
        .clk__enable(clk_1MHzE_falling__enable),
        .pb_in({{{vsp_int_n,vsp_rdy_n},lightpen_buttons},4'h0}),
        .cb2_in(lightpen_strobe),
        .cb1(1'h0),
        .pa_in({selected_key_pressed,via_a_pa_out[6:0]}),
        .ca2_in(via_a_ca2_in),
        .ca1(vsync),
        .data_in(cpu_data_out),
        .address(address[3:0]),
        .chip_select_n(!(address_map_decode__via_a!=1'h0)),
        .chip_select(phi2),
        .read_not_write(read_not_write),
        .reset_n(reset_n),
        .pb_out(            via_a_pb_out),
        .pa_out(            via_a_pa_out),
        .irq_n(            irq_n_via_a),
        .data_out(            data_out_via_a)         );
    via6522 via_b(
        .clk_io(clk),
        .clk_io__enable(clk_1MHzE_rising__enable),
        .clk(clk),
        .clk__enable(clk_1MHzE_falling__enable),
        .pb_in(8'h0),
        .cb2_in(1'h0),
        .cb1(1'h0),
        .pa_in(8'h0),
        .ca2_in(1'h0),
        .ca1(1'h0),
        .data_in(cpu_data_out),
        .address(address[3:0]),
        .chip_select_n(!(address_map_decode__via_b!=1'h0)),
        .chip_select(phi2),
        .read_not_write(read_not_write),
        .reset_n(reset_n),
        .pb_out(            via_b_pb_out),
        .pa_out(            via_b_pa_out),
        .irq_n(            irq_n_via_b),
        .data_out(            data_out_via_b)         );
    bbc_vidproc vidproc(
        .clk_2MHz_video(clk),
        .clk_2MHz_video__enable(clk_2MHz_video_clock__enable),
        .clk_cpu(clk),
        .clk_cpu__enable(cpu_clk__enable),
        .saa5050_blue(saa5050_blue),
        .saa5050_green(saa5050_green),
        .saa5050_red(saa5050_red),
        .cursor(1'h0),
        .invert_n(1'h1),
        .disen((crtc_display_enable & ~crtc_row_address[3])),
        .pixel_data_in(ram_databus),
        .cpu_data_in(cpu_data_out),
        .address(address[0]),
        .chip_select_n(!(address_map_decode__vidproc!=1'h0)),
        .reset_n(reset_n),
        .pixels_valid_per_clock(            vidproc_pixels_valid_per_clock),
        .blue(            vidproc_blue),
        .green(            vidproc_green),
        .red(            vidproc_red),
        .crtc_clock_enable(            crtc_clock_enable)         );
    crtc6845 crtc(
        .clk_1MHz(clk),
        .clk_1MHz__enable(clk_1MHzE_falling__enable),
        .clk_2MHz(clk),
        .clk_2MHz__enable(clk_2MHz_video_clock__enable),
        .crtc_clock_enable(crtc_clock_enable),
        .lpstb_n(lightpen_strobe),
        .data_in(cpu_data_out),
        .rs(address[0]),
        .chip_select_n(!(address_map_decode__crtc!=1'h0)),
        .read_not_write(read_not_write),
        .reset_n(reset_n),
        .vsync(            vsync),
        .hsync(            hsync),
        .de(            crtc_display_enable),
        .ra(            crtc_row_address),
        .ma(            crtc_memory_address),
        .data_out(            crtc_data_out)         );
    saa5050 saa(
        .clk_2MHz(clk),
        .clk_2MHz__enable(clk_2MHz_video_clock__enable),
        .host_sram_request__write_data(pending_host_sram_request__write_data),
        .host_sram_request__address(pending_host_sram_request__address),
        .host_sram_request__select(pending_host_sram_request__select),
        .host_sram_request__write_enable(pending_host_sram_request__write_enable),
        .host_sram_request__read_enable(pending_host_sram_request__read_enable),
        .host_sram_request__valid(pending_host_sram_request__valid),
        .po(1'h0),
        .de(1'h1),
        .lose(saa_lose),
        .bcs_n(1'h0),
        .crs(crtc_row_address[0]),
        .dew(vsync),
        .glr(!(hsync!=1'h0)),
        .dlim(1'h0),
        .data_in(saa_data),
        .data_n(1'h0),
        .superimpose_n(1'h0),
        .reset_n(reset_n),
        .clk_1MHz_enable(saa_enable),
        .blue(            saa5050_blue),
        .green(            saa5050_green),
        .red(            saa5050_red)         );
    bbc_micro_keyboard keyboard(
        .clk(clk),
        .clk__enable(clk_1MHzE_rising__enable),
        .bbc_keyboard__keys_down_cols_8_to_9(keyboard__keys_down_cols_8_to_9),
        .bbc_keyboard__keys_down_cols_0_to_7(keyboard__keys_down_cols_0_to_7),
        .bbc_keyboard__reset_pressed(keyboard__reset_pressed),
        .row_select(via_a_pa_out[6:4]),
        .column_select(via_a_pa_out[3:0]),
        .keyboard_enable_n(via_a_latch[3]),
        .reset_n(reset_n),
        .selected_key_pressed(            selected_key_pressed),
        .key_in_column_pressed(            via_a_ca2_in),
        .reset_out_n(            keyboard_reset_n)         );
    se_sram_srw_16384x8 ram_0(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(memory_access__write_data),
        .address(memory_access__address),
        .write_enable(memory_access__write_enable),
        .read_not_write(memory_access__read_enable),
        .select(memory_access__ram_select[0]),
        .data_out(            ram0_data_out)         );
    se_sram_srw_16384x8 ram_1(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(memory_access__write_data),
        .address(memory_access__address),
        .write_enable(memory_access__write_enable),
        .read_not_write(memory_access__read_enable),
        .select(memory_access__ram_select[1]),
        .data_out(            ram1_data_out)         );
    se_sram_srw_16384x8 basic(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(memory_access__write_data),
        .address(memory_access__address),
        .write_enable(memory_access__write_enable),
        .read_not_write(memory_access__read_enable),
        .select(memory_access__rom_select[0]),
        .data_out(            basic_data_out)         );
    se_sram_srw_16384x8 adfs(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(memory_access__write_data),
        .address(memory_access__address),
        .write_enable(memory_access__write_enable),
        .read_not_write(memory_access__read_enable),
        .select(memory_access__rom_select[1]),
        .data_out(            adfs_data_out)         );
    se_sram_srw_16384x8 os(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(memory_access__write_data),
        .address(memory_access__address),
        .write_enable(memory_access__write_enable),
        .read_not_write(memory_access__read_enable),
        .select(memory_access__os_select),
        .data_out(            os_data_out)         );
    cpu6502 main_cpu(
        .clk(clk),
        .clk__enable(cpu_clk__enable),
        .data_in(main_databus),
        .nmi_n(nmi_n),
        .irq_n(irq_n),
        .ready(1'h1),
        .reset_n(reset_n),
        .data_out(            cpu_data_out),
        .read_not_write(            read_not_write),
        .address(            address),
        .ba(            ba)         );
    //b clocking_logic combinatorial process
        //   
        //       
    always @ ( * )//clocking_logic
    begin: clocking_logic__comb_code
        enable_clk_2MHz_video = clock_control__enable_2MHz_video;
        enable_clk_1MHz_rising = clock_control__enable_1MHz_rising;
        enable_clk_1MHz_falling = clock_control__enable_1MHz_falling;
        enable_cpu_clk = clock_control__enable_cpu;
        phi1 = clock_control__phi[0];
        phi2 = clock_control__phi[1];
        clock_status__cpu_1MHz_access = address_map_decode__access_1mhz;
    end //always

    //b inputs_and_outputs__comb combinatorial process
        //   
        //       
    always @ ( * )//inputs_and_outputs__comb
    begin: inputs_and_outputs__comb_code
    reg display__hsync__var;
    reg display__vsync__var;
    reg [2:0]display__pixels_per_clock__var;
    reg [7:0]display__red__var;
    reg [7:0]display__green__var;
    reg [7:0]display__blue__var;
        display__clock_enable = 1'h0;
        display__hsync__var = 1'h0;
        display__vsync__var = 1'h0;
        display__pixels_per_clock__var = 3'h0;
        display__red__var = 8'h0;
        display__green__var = 8'h0;
        display__blue__var = 8'h0;
        display__hsync__var = hsync;
        display__vsync__var = vsync;
        display__red__var = vidproc_red;
        display__green__var = vidproc_green;
        display__blue__var = vidproc_blue;
        display__pixels_per_clock__var = vidproc_pixels_valid_per_clock;
        display__hsync = display__hsync__var;
        display__vsync = display__vsync__var;
        display__pixels_per_clock = display__pixels_per_clock__var;
        display__red = display__red__var;
        display__green = display__green__var;
        display__blue = display__blue__var;
    end //always

    //b inputs_and_outputs__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : inputs_and_outputs__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            host_sram_response__ack <= 1'h0;
            pending_host_sram_request__valid <= 1'h0;
            pending_host_sram_request__read_enable <= 1'h0;
            pending_host_sram_request__write_enable <= 1'h0;
            pending_host_sram_request__select <= 8'h0;
            pending_host_sram_request__address <= 24'h0;
            pending_host_sram_request__write_data <= 64'h0;
            host_sram_response__read_data_valid <= 1'h0;
            host_sram_response__read_data <= 64'h0;
        end
        else if (clk__enable)
        begin
            if ((pending_host_sram_request__valid!=1'h0))
            begin
                if (!(host_sram_request__valid!=1'h0))
                begin
                    host_sram_response__ack <= 1'h0;
                end //if
                if ((memory_grant==2'h3))
                begin
                    host_sram_response__ack <= 1'h1;
                    pending_host_sram_request__valid <= 1'h0;
                end //if
                if (((pending_host_sram_request__select==8'h14)&&(enable_clk_2MHz_video!=1'h0)))
                begin
                    host_sram_response__ack <= 1'h1;
                    pending_host_sram_request__valid <= 1'h0;
                end //if
            end //if
            else
            
            begin
                if (((host_sram_request__valid!=1'h0)&&!(host_sram_response__ack!=1'h0)))
                begin
                    if (((host_sram_request__select & 8'h10)!=8'h0))
                    begin
                        pending_host_sram_request__valid <= host_sram_request__valid;
                        pending_host_sram_request__read_enable <= host_sram_request__read_enable;
                        pending_host_sram_request__write_enable <= host_sram_request__write_enable;
                        pending_host_sram_request__select <= host_sram_request__select;
                        pending_host_sram_request__address <= host_sram_request__address;
                        pending_host_sram_request__write_data <= host_sram_request__write_data;
                    end //if
                end //if
                else
                
                begin
                    if ((!(host_sram_request__valid!=1'h0)&&(host_sram_response__ack!=1'h0)))
                    begin
                        host_sram_response__ack <= 1'h0;
                    end //if
                end //else
            end //else
            host_sram_response__read_data_valid <= 1'h0;
            host_sram_response__read_data <= 64'h0;
            if ((host_reading_memory!=1'h0))
            begin
                host_sram_response__read_data_valid <= 1'h1;
                host_sram_response__read_data[7:0] <= memory_databus;
            end //if
        end //if
    end //always

    //b via_6522s__comb combinatorial process
        //   
        //       The 6522's have 1MHzE wired to the clock pin (phi2, pin 25). This means that they run constantly at 1MHz.
        //   
        //       It also means that they need to have their accesses stretched to be at 1MHz. The addresses and selects etc
        //       must change while 1MHzE is low, and read data out of them must be captured on falling 1MHzE. Write data
        //       is also captured on falling 1MHzE.
        //   
        //       In order to achieve this neatly the chip selects (two of them) are address decode (1) and 2MHzE==!phi[1]==phi[2] (2).
        //   
        //       Hence when accessing 1MHz space the clock in to the 6502 is stretched during its 'high' period (phi[2]) so that this
        //       period ends simultaneously with falling 1MHzE. Also, the low period is stretched IF REQUIRED (phi[1]) so that phi[2]
        //       assertion is delayed until 1MHzE is low.
        //   
        //       For the modern world we make the clock in be a clock edge at '1MHzE falling'
        //   
        //       
    always @ ( * )//via_6522s__comb
    begin: via_6522s__comb_code
    reg [7:0]data_out_sheila__var;
        lightpen_buttons = 2'h3;
        lightpen_strobe = 1'h1;
        vsp_int_n = 1'h1;
        vsp_rdy_n = 1'h1;
        data_out_sheila__var = data_out_via_a;
        if ((address_map_decode__via_b!=1'h0))
        begin
            data_out_sheila__var = data_out_via_b;
        end //if
        if ((address_map_decode__acia!=1'h0))
        begin
            data_out_sheila__var = data_out_acia;
        end //if
        if ((address_map_decode__fdc!=1'h0))
        begin
            data_out_sheila__var = data_out_fdc;
        end //if
        data_out_sheila = data_out_sheila__var;
    end //always

    //b via_6522s__posedge_clk_1MHzE_falling_active_low_reset_n clock process
        //   
        //       The 6522's have 1MHzE wired to the clock pin (phi2, pin 25). This means that they run constantly at 1MHz.
        //   
        //       It also means that they need to have their accesses stretched to be at 1MHz. The addresses and selects etc
        //       must change while 1MHzE is low, and read data out of them must be captured on falling 1MHzE. Write data
        //       is also captured on falling 1MHzE.
        //   
        //       In order to achieve this neatly the chip selects (two of them) are address decode (1) and 2MHzE==!phi[1]==phi[2] (2).
        //   
        //       Hence when accessing 1MHz space the clock in to the 6502 is stretched during its 'high' period (phi[2]) so that this
        //       period ends simultaneously with falling 1MHzE. Also, the low period is stretched IF REQUIRED (phi[1]) so that phi[2]
        //       assertion is delayed until 1MHzE is low.
        //   
        //       For the modern world we make the clock in be a clock edge at '1MHzE falling'
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : via_6522s__posedge_clk_1MHzE_falling_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            via_a_update_latch <= 1'h0;
            via_a_latch <= 8'h0;
        end
        else if (clk_1MHzE_falling__enable)
        begin
            via_a_update_latch <= 1'h0;
            if ((address_map_decode__via_a!=1'h0))
            begin
                via_a_update_latch <= 1'h1;
            end //if
            if ((via_a_update_latch!=1'h0))
            begin
                via_a_latch[via_a_pb_out[2:0]] <= via_a_pb_out[3];
            end //if
        end //if
    end //always

    //b video__comb combinatorial process
        //   
        //       
    always @ ( * )//video__comb
    begin: video__comb_code
    reg [14:0]video_mem_address__var;
        ttx_vdu = crtc_memory_address[13];
        video_mem_address__var = {{crtc_memory_address[11:8],crtc_memory_address[7:0]},crtc_row_address[2:0]};
        if ((crtc_memory_address[12]!=1'h0))
        begin
            case (via_a_latch[5:4]) //synopsys parallel_case
            2'h1: // req 1
                begin
                video_mem_address__var[11:8] = (crtc_memory_address[11:8]+4'hc);
                end
            2'h3: // req 1
                begin
                video_mem_address__var[11:8] = (crtc_memory_address[11:8]+4'hb);
                end
            2'h0: // req 1
                begin
                video_mem_address__var[11:8] = (crtc_memory_address[11:8]+4'h8);
                end
            2'h2: // req 1
                begin
                video_mem_address__var[11:8] = (crtc_memory_address[11:8]+4'h6);
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:bbc_micro:video: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
        if ((ttx_vdu!=1'h0))
        begin
            video_mem_address__var = {5'h1f,crtc_memory_address[9:0]};
        end //if
        video_mem_address = video_mem_address__var;
    end //always

    //b video__posedge_clk_2MHz_video_clock_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : video__posedge_clk_2MHz_video_clock_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            saa_data <= 7'h0;
            saa_lose <= 1'h0;
            saa_enable <= 1'h0;
        end
        else if (clk_2MHz_video_clock__enable)
        begin
            saa_data <= ram_databus[6:0];
            saa_lose <= crtc_display_enable;
            saa_enable <= !(saa_enable!=1'h0);
            if ((!(saa_lose!=1'h0)&&(crtc_display_enable!=1'h0)))
            begin
                saa_enable <= 1'h1;
            end //if
        end //if
    end //always

    //b glue_logic combinatorial process
        //   
        //       
    always @ ( * )//glue_logic
    begin: glue_logic__comb_code
    reg nmi_n__var;
    reg irq_n__var;
        nmi_n__var = 1'h1;
        if (!(nmi_n_fdc!=1'h0))
        begin
            nmi_n__var = 1'h0;
        end //if
        irq_n__var = 1'h1;
        if (!(irq_n_via_a!=1'h0))
        begin
            irq_n__var = 1'h0;
        end //if
        if (!(irq_n_via_b!=1'h0))
        begin
            irq_n__var = 1'h0;
        end //if
        if (!(irq_n_acia!=1'h0))
        begin
            irq_n__var = 1'h0;
        end //if
        nmi_n = nmi_n__var;
        irq_n = irq_n__var;
    end //always

    //b address_map_decoding__comb combinatorial process
        //   
        //       Decode the addresses from the CPU.
        //       This is bascially in the north center of the BBC micro schematic
        //       
    always @ ( * )//address_map_decoding__comb
    begin: address_map_decoding__comb_code
    reg [1:0]address_map_decode__rams__var;
    reg [3:0]address_map_decode__roms__var;
        address_map_decode__fred = ((address & 16'hff00)==16'hfc00);
        address_map_decode__jim = ((address & 16'hff00)==16'hfd00);
        address_map_decode__sheila = ((address & 16'hff00)==16'hfe00);
        address_map_decode__crtc = ((address & 16'hfff8)==16'hfe00);
        address_map_decode__acia = ((address & 16'hfff8)==16'hfe08);
        address_map_decode__serproc = ((address & 16'hfff8)==16'hfe10);
        address_map_decode__intoff = ((address & 16'hfff8)==16'hfe18);
        address_map_decode__vidproc = (((address & 16'hfff0)==16'hfe20)&&!(read_not_write!=1'h0));
        address_map_decode__romsel = (((address & 16'hfff0)==16'hfe30)&&!(read_not_write!=1'h0));
        address_map_decode__inton = (((address & 16'hfff0)==16'hfe20)&&(read_not_write!=1'h0));
        address_map_decode__via_a = ((address & 16'hffe0)==16'hfe40);
        address_map_decode__via_b = ((address & 16'hffe0)==16'hfe60);
        address_map_decode__fdc = ((address & 16'hffe0)==16'hfe80);
        address_map_decode__adlc = ((address & 16'hffe0)==16'hfea0);
        address_map_decode__adc = ((address & 16'hffe0)==16'hfec0);
        address_map_decode__tube = ((address & 16'hffe0)==16'hfee0);
        address_map_decode__access_1mhz = ((((((address_map_decode__crtc | address_map_decode__acia) | address_map_decode__serproc) | address_map_decode__intoff) | address_map_decode__via_a) | address_map_decode__via_b) | address_map_decode__adc);
        address_map_decode__rams__var[0] = (address[15:14]==2'h0);
        address_map_decode__rams__var[1] = (address[15:14]==2'h1);
        address_map_decode__rom = (address[15:14]==2'h2);
        address_map_decode__os = (address[15:14]==2'h3);
        address_map_decode__roms__var = 4'h0;
        if ((address_map_decode__rom!=1'h0))
        begin
            address_map_decode__roms__var[rom_sel] = 1'h1;
        end //if
        address_map_decode__rams = address_map_decode__rams__var;
        address_map_decode__roms = address_map_decode__roms__var;
    end //always

    //b address_map_decoding__posedge_cpu_clk_active_low_reset_n clock process
        //   
        //       Decode the addresses from the CPU.
        //       This is bascially in the north center of the BBC micro schematic
        //       
    always @( posedge clk or negedge reset_n)
    begin : address_map_decoding__posedge_cpu_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            rom_sel <= 4'h0;
        end
        else if (cpu_clk__enable)
        begin
            if ((address_map_decode__romsel!=1'h0))
            begin
                rom_sel <= cpu_data_out[3:0];
            end //if
        end //if
    end //always

    //b srams__comb combinatorial process
        //   
        //       The RAM in the BBC micro is accessed during the second half of a
        //       2MHz clock by the CPU, and during the first half of the 2MHz clock
        //       by the video memory.
        //   
        //       Notionally the second half of the clock is PHI2, except when PHI2
        //       is extended for non-memory transactions (when it is clearly longer
        //       and asserted in the first half of a 2MHz clock...), in which case
        //       the CPU is not accessing the memory anyway, and so the video can
        //       still have priority. Hence in the real system the video is always
        //       on the second half of the 2MHz clock.
        //   
        //       In this implementation the  memories are  synchronous and  so the
        //       select, address  etc have to be  valid on a clock  edge before the
        //       access - hence  the RAM is accessed for the  CPU during the second
        //       half of the clock by presenting the controls during the first half
        //       of the clock - or phi1.
        //   
        //       Now this will only work if the CPU is running on every clock tick
        //       - as the read data out of the SRAM will only stay valid for a
        //       single tick. Hence the RAM data for the CPU must be registered,
        //       such that it records the RAM data if the CPU was reading the RAM;
        //       the CPU gets the RAM data directly during such cycles, but it gets
        //       the recorded RAM data in other cycles.
        //   
        //       The video memory is granted access ONLY during PHI2 (the clock
        //       control for the video guarantees this) and only on cycles that the
        //       video could require it. (Perhaps one could hold off during
        //       hsync/vsync?)
        //   
        //       To support the initial setting up of the system (loading of RAMs
        //       etc), this implementation also supports host access to the
        //       memories as the lowest priority.
        //       
    always @ ( * )//srams__comb
    begin: srams__comb_code
    reg [1:0]memory_grant__var;
    reg [1:0]memory_access__ram_select__var;
    reg [3:0]memory_access__rom_select__var;
    reg memory_access__os_select__var;
    reg memory_access__read_enable__var;
    reg memory_access__write_enable__var;
    reg [13:0]memory_access__address__var;
    reg [7:0]memory_access__write_data__var;
        memory_grant__var = 2'h0;
        if ((clock_control__will_enable_2MHz_video!=1'h0))
        begin
            memory_grant__var = 2'h2;
        end //if
        else
        
        begin
            if (((phi1!=1'h0)&&!(cpu_reading_memory!=1'h0)))
            begin
                memory_grant__var = 2'h1;
            end //if
            else
            
            begin
                if ((pending_host_sram_request__valid!=1'h0))
                begin
                    if ((pending_host_sram_request__select!=8'h14))
                    begin
                        memory_grant__var = 2'h3;
                    end //if
                end //if
            end //else
        end //else
        memory_access__ram_select__var = 2'h0;
        memory_access__rom_select__var = 4'h0;
        memory_access__os_select__var = 1'h0;
        memory_access__read_enable__var = 1'h0;
        memory_access__write_enable__var = 1'h0;
        memory_access__address__var = address[13:0];
        memory_access__write_data__var = cpu_data_out;
        if ((memory_grant__var==2'h1))
        begin
            memory_access__ram_select__var = address_map_decode__rams;
            memory_access__rom_select__var = address_map_decode__roms;
            memory_access__os_select__var = address_map_decode__os;
            memory_access__read_enable__var = read_not_write;
            memory_access__write_enable__var = (!(read_not_write!=1'h0)&&(address_map_decode__rams!=2'h0));
        end //if
        else
        
        begin
            if ((memory_grant__var==2'h2))
            begin
                memory_access__address__var = video_mem_address[13:0];
                memory_access__ram_select__var = ((video_mem_address[14]!=1'h0)?2'h2:2'h1);
                memory_access__rom_select__var = 4'h0;
                memory_access__os_select__var = 1'h0;
                memory_access__read_enable__var = 1'h1;
                memory_access__write_enable__var = 1'h0;
            end //if
            else
            
            begin
                if ((memory_grant__var==2'h3))
                begin
                    memory_access__address__var = pending_host_sram_request__address[13:0];
                    memory_access__ram_select__var[0] = (pending_host_sram_request__select==8'h10);
                    memory_access__ram_select__var[1] = (pending_host_sram_request__select==8'h11);
                    memory_access__os_select__var = (pending_host_sram_request__select==8'h12);
                    memory_access__rom_select__var[0] = (pending_host_sram_request__select==8'h18);
                    memory_access__rom_select__var[1] = (pending_host_sram_request__select==8'h19);
                    memory_access__rom_select__var[2] = (pending_host_sram_request__select==8'h1a);
                    memory_access__rom_select__var[3] = (pending_host_sram_request__select==8'h1b);
                    memory_access__read_enable__var = pending_host_sram_request__read_enable;
                    memory_access__write_enable__var = pending_host_sram_request__write_enable;
                    memory_access__write_data__var = pending_host_sram_request__write_data[7:0];
                end //if
            end //else
        end //else
        memory_grant = memory_grant__var;
        memory_access__ram_select = memory_access__ram_select__var;
        memory_access__rom_select = memory_access__rom_select__var;
        memory_access__os_select = memory_access__os_select__var;
        memory_access__read_enable = memory_access__read_enable__var;
        memory_access__write_enable = memory_access__write_enable__var;
        memory_access__address = memory_access__address__var;
        memory_access__write_data = memory_access__write_data__var;
    end //always

    //b srams__posedge_clk_active_low_reset_n clock process
        //   
        //       The RAM in the BBC micro is accessed during the second half of a
        //       2MHz clock by the CPU, and during the first half of the 2MHz clock
        //       by the video memory.
        //   
        //       Notionally the second half of the clock is PHI2, except when PHI2
        //       is extended for non-memory transactions (when it is clearly longer
        //       and asserted in the first half of a 2MHz clock...), in which case
        //       the CPU is not accessing the memory anyway, and so the video can
        //       still have priority. Hence in the real system the video is always
        //       on the second half of the 2MHz clock.
        //   
        //       In this implementation the  memories are  synchronous and  so the
        //       select, address  etc have to be  valid on a clock  edge before the
        //       access - hence  the RAM is accessed for the  CPU during the second
        //       half of the clock by presenting the controls during the first half
        //       of the clock - or phi1.
        //   
        //       Now this will only work if the CPU is running on every clock tick
        //       - as the read data out of the SRAM will only stay valid for a
        //       single tick. Hence the RAM data for the CPU must be registered,
        //       such that it records the RAM data if the CPU was reading the RAM;
        //       the CPU gets the RAM data directly during such cycles, but it gets
        //       the recorded RAM data in other cycles.
        //   
        //       The video memory is granted access ONLY during PHI2 (the clock
        //       control for the video guarantees this) and only on cycles that the
        //       video could require it. (Perhaps one could hold off during
        //       hsync/vsync?)
        //   
        //       To support the initial setting up of the system (loading of RAMs
        //       etc), this implementation also supports host access to the
        //       memories as the lowest priority.
        //       
    always @( posedge clk or negedge reset_n)
    begin : srams__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            cpu_reading_memory <= 1'h0;
            host_reading_memory <= 1'h0;
            last_memory_access__read_enable <= 1'h0;
            last_memory_access__write_enable <= 1'h0;
            last_memory_access__ram_select <= 2'h0;
            last_memory_access__rom_select <= 4'h0;
            last_memory_access__os_select <= 1'h0;
            last_memory_access__address <= 14'h0;
            last_memory_access__write_data <= 8'h0;
        end
        else if (clk__enable)
        begin
            cpu_reading_memory <= 1'h0;
            host_reading_memory <= 1'h0;
            if ((memory_grant==2'h1))
            begin
                cpu_reading_memory <= read_not_write;
            end //if
            else
            
            begin
                if ((memory_grant==2'h2))
                begin
                end //if
                else
                
                begin
                    if ((memory_grant==2'h3))
                    begin
                        host_reading_memory <= pending_host_sram_request__read_enable;
                    end //if
                end //else
            end //else
            last_memory_access__read_enable <= memory_access__read_enable;
            last_memory_access__write_enable <= memory_access__write_enable;
            last_memory_access__ram_select <= memory_access__ram_select;
            last_memory_access__rom_select <= memory_access__rom_select;
            last_memory_access__os_select <= memory_access__os_select;
            last_memory_access__address <= memory_access__address;
            last_memory_access__write_data <= memory_access__write_data;
        end //if
    end //always

    //b databus_multiplexing__comb combinatorial process
        //   
        //       
    always @ ( * )//databus_multiplexing__comb
    begin: databus_multiplexing__comb_code
    reg [7:0]ram_databus__var;
    reg [7:0]memory_databus__var;
    reg [7:0]main_databus__var;
        ram_databus__var = 8'h0;
        memory_databus__var = 8'h0;
        if ((last_memory_access__ram_select[0]!=1'h0))
        begin
            ram_databus__var = ram_databus__var | ram0_data_out;
        end //if
        if ((last_memory_access__ram_select[1]!=1'h0))
        begin
            ram_databus__var = ram_databus__var | ram1_data_out;
        end //if
        memory_databus__var = ram_databus__var;
        if ((last_memory_access__os_select!=1'h0))
        begin
            memory_databus__var = memory_databus__var | os_data_out;
        end //if
        if ((last_memory_access__rom_select[0]!=1'h0))
        begin
            memory_databus__var = memory_databus__var | basic_data_out;
        end //if
        if ((last_memory_access__rom_select[1]!=1'h0))
        begin
            memory_databus__var = memory_databus__var | adfs_data_out;
        end //if
        main_databus__var = 8'hff;
        if ((read_not_write!=1'h0))
        begin
            main_databus__var = memory_databus__var;
            if (!(cpu_reading_memory!=1'h0))
            begin
                main_databus__var = cpu_memory_data_hold;
            end //if
            if ((address_map_decode__rom!=1'h0))
            begin
                if ((!(address_map_decode__roms[0]!=1'h0)&&!(address_map_decode__roms[1]!=1'h0)))
                begin
                    main_databus__var = 8'hff;
                end //if
            end //if
            if ((address_map_decode__sheila!=1'h0))
            begin
                main_databus__var = data_out_sheila;
            end //if
        end //if
        ram_databus = ram_databus__var;
        memory_databus = memory_databus__var;
        main_databus = main_databus__var;
    end //always

    //b databus_multiplexing__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : databus_multiplexing__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            cpu_memory_data_hold <= 8'h0;
        end
        else if (clk__enable)
        begin
            if ((cpu_reading_memory!=1'h0))
            begin
                cpu_memory_data_hold <= memory_databus;
            end //if
        end //if
    end //always

endmodule // bbc_micro
