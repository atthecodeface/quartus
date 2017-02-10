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

//a Module bbc_floppy_sram
    //   
    //   This module provides an SRAM-fakeout of a set of floppy disks, tied to the BBC
    //   micro floppy disc controller.
    //   
module bbc_floppy_sram
(
    clk,
    clk__enable,

    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    sram_response__ack,
    sram_response__read_data_valid,
    sram_response__read_data,
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
    reset_n,

    csr_response__ack,
    csr_response__read_data_valid,
    csr_response__read_data,
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
    sram_request__enable,
    sram_request__read_not_write,
    sram_request__address,
    sram_request__write_data
);

    //b Clocks
        //   Clock running at 2MHz
    input clk;
    input clk__enable;

    //b Inputs
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
    input sram_response__ack;
    input sram_response__read_data_valid;
    input [31:0]sram_response__read_data;
    input floppy_op__step_out;
    input floppy_op__step_in;
    input floppy_op__next_id;
    input floppy_op__read_data_enable;
    input floppy_op__write_data_enable;
    input [31:0]floppy_op__write_data;
    input floppy_op__write_sector_id_enable;
    input [6:0]floppy_op__sector_id__track;
    input floppy_op__sector_id__head;
    input [5:0]floppy_op__sector_id__sector_number;
    input [1:0]floppy_op__sector_id__sector_length;
    input floppy_op__sector_id__bad_crc;
    input floppy_op__sector_id__bad_data_crc;
    input floppy_op__sector_id__deleted_data;
    input reset_n;

    //b Outputs
    output csr_response__ack;
    output csr_response__read_data_valid;
    output [31:0]csr_response__read_data;
    output floppy_response__sector_id_valid;
    output [6:0]floppy_response__sector_id__track;
    output floppy_response__sector_id__head;
    output [5:0]floppy_response__sector_id__sector_number;
    output [1:0]floppy_response__sector_id__sector_length;
    output floppy_response__sector_id__bad_crc;
    output floppy_response__sector_id__bad_data_crc;
    output floppy_response__sector_id__deleted_data;
    output floppy_response__index;
    output floppy_response__read_data_valid;
    output [31:0]floppy_response__read_data;
    output floppy_response__track_zero;
    output floppy_response__write_protect;
    output floppy_response__disk_ready;
    output sram_request__enable;
    output sram_request__read_not_write;
    output [19:0]sram_request__address;
    output [31:0]sram_request__write_data;

// output components here

    //b Output combinatorials
    reg sram_request__enable;
    reg sram_request__read_not_write;
    reg [19:0]sram_request__address;
    reg [31:0]sram_request__write_data;

    //b Output nets

    //b Internal and output registers
    reg [3:0]floppy_state__fsm_state;
    reg floppy_state__sram_request__enable;
    reg floppy_state__sram_request__read_not_write;
    reg [19:0]floppy_state__sram_request__address;
    reg [31:0]floppy_state__sram_request__write_data;
    reg [1:0]drive_state__selected_floppy;
    reg drive_state__floppy_op__step_out;
    reg drive_state__floppy_op__step_in;
    reg drive_state__floppy_op__next_id;
    reg drive_state__floppy_op__read_data_enable;
    reg drive_state__floppy_op__write_data_enable;
    reg [31:0]drive_state__floppy_op__write_data;
    reg drive_state__floppy_op__write_sector_id_enable;
    reg [6:0]drive_state__floppy_op__sector_id__track;
    reg drive_state__floppy_op__sector_id__head;
    reg [5:0]drive_state__floppy_op__sector_id__sector_number;
    reg [1:0]drive_state__floppy_op__sector_id__sector_length;
    reg drive_state__floppy_op__sector_id__bad_crc;
    reg drive_state__floppy_op__sector_id__bad_data_crc;
    reg drive_state__floppy_op__sector_id__deleted_data;
    reg drive_state__last_floppy_op__step_out;
    reg drive_state__last_floppy_op__step_in;
    reg drive_state__last_floppy_op__next_id;
    reg drive_state__last_floppy_op__read_data_enable;
    reg drive_state__last_floppy_op__write_data_enable;
    reg [31:0]drive_state__last_floppy_op__write_data;
    reg drive_state__last_floppy_op__write_sector_id_enable;
    reg [6:0]drive_state__last_floppy_op__sector_id__track;
    reg drive_state__last_floppy_op__sector_id__head;
    reg [5:0]drive_state__last_floppy_op__sector_id__sector_number;
    reg [1:0]drive_state__last_floppy_op__sector_id__sector_length;
    reg drive_state__last_floppy_op__sector_id__bad_crc;
    reg drive_state__last_floppy_op__sector_id__bad_data_crc;
    reg drive_state__last_floppy_op__sector_id__deleted_data;
    reg [3:0]floppy_disk_state__disk_ready;
    reg [3:0]floppy_disk_state__write_protect;
    reg [7:0]floppy_disk_state__num_tracks[3:0];
    reg [19:0]floppy_disk_state__sram_data_base_address[3:0];
    reg [19:0]floppy_disk_state__sram_id_base_address[3:0];
    reg [7:0]floppy_disk_state__sectors_per_track[3:0];
    reg [7:0]floppy_disk_state__current_track[3:0];
    reg [7:0]floppy_disk_state__current_physical_sector[3:0];
    reg [3:0]floppy_disk_state__next_sector_is_zero;
    reg [11:0]floppy_disk_state__data_words_per_track[3:0];
    reg [19:0]floppy_disk_state__track_data_sram_offset[3:0];
    reg [11:0]floppy_disk_state__track_id_sram_offset[3:0];
    reg [11:0]floppy_disk_state__data_word_offset[3:0];
    reg [6:0]floppy_disk_state__sector_id__track[3:0];
    reg [3:0]floppy_disk_state__sector_id__head;
    reg [5:0]floppy_disk_state__sector_id__sector_number[3:0];
    reg [1:0]floppy_disk_state__sector_id__sector_length[3:0];
    reg [3:0]floppy_disk_state__sector_id__bad_crc;
    reg [3:0]floppy_disk_state__sector_id__bad_data_crc;
    reg [3:0]floppy_disk_state__sector_id__deleted_data;
    reg csr_response__ack;
    reg csr_response__read_data_valid;
    reg [31:0]csr_response__read_data;
    reg floppy_response__sector_id_valid;
    reg [6:0]floppy_response__sector_id__track;
    reg floppy_response__sector_id__head;
    reg [5:0]floppy_response__sector_id__sector_number;
    reg [1:0]floppy_response__sector_id__sector_length;
    reg floppy_response__sector_id__bad_crc;
    reg floppy_response__sector_id__bad_data_crc;
    reg floppy_response__sector_id__deleted_data;
    reg floppy_response__index;
    reg floppy_response__read_data_valid;
    reg [31:0]floppy_response__read_data;
    reg floppy_response__track_zero;
    reg floppy_response__write_protect;
    reg floppy_response__disk_ready;

    //b Internal combinatorials
    reg sram_combs__ack;
    reg sram_combs__read_data_valid;
    reg [31:0]sram_combs__read_data;
    reg [1:0]floppy_combs__fsm_request;
    reg [19:0]floppy_combs__sram_data_address;
    reg [19:0]floppy_combs__sram_id_address;
    reg current_floppy__disk_ready;
    reg current_floppy__write_protect;
    reg [7:0]current_floppy__num_tracks;
    reg [19:0]current_floppy__sram_data_base_address;
    reg [19:0]current_floppy__sram_id_base_address;
    reg [7:0]current_floppy__sectors_per_track;
    reg [7:0]current_floppy__current_track;
    reg [7:0]current_floppy__current_physical_sector;
    reg current_floppy__next_sector_is_zero;
    reg [11:0]current_floppy__data_words_per_track;
    reg [19:0]current_floppy__track_data_sram_offset;
    reg [11:0]current_floppy__track_id_sram_offset;
    reg [11:0]current_floppy__data_word_offset;
    reg [6:0]current_floppy__sector_id__track;
    reg current_floppy__sector_id__head;
    reg [5:0]current_floppy__sector_id__sector_number;
    reg [1:0]current_floppy__sector_id__sector_length;
    reg current_floppy__sector_id__bad_crc;
    reg current_floppy__sector_id__bad_data_crc;
    reg current_floppy__sector_id__deleted_data;
    reg drive_combs__do_step_in;
    reg drive_combs__do_step_out;
    reg drive_combs__get_next_id;
    reg drive_combs__do_read_data;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b inputs_and_outputs__comb combinatorial process
        //   
        //       
    always @ ( * )//inputs_and_outputs__comb
    begin: inputs_and_outputs__comb_code
    reg drive_combs__do_step_in__var;
    reg drive_combs__do_step_out__var;
    reg drive_combs__get_next_id__var;
    reg drive_combs__do_read_data__var;
        drive_combs__do_step_in__var = 1'h0;
        drive_combs__do_step_out__var = 1'h0;
        drive_combs__get_next_id__var = 1'h0;
        drive_combs__do_read_data__var = 1'h0;
        if (((drive_state__floppy_op__step_in!=1'h0)&&!(drive_state__last_floppy_op__step_in!=1'h0)))
        begin
            drive_combs__do_step_in__var = 1'h1;
        end //if
        if (((drive_state__floppy_op__step_out!=1'h0)&&!(drive_state__last_floppy_op__step_out!=1'h0)))
        begin
            drive_combs__do_step_in__var = 1'h0;
            drive_combs__do_step_out__var = 1'h1;
        end //if
        if (((drive_state__floppy_op__next_id!=1'h0)&&!(drive_state__last_floppy_op__next_id!=1'h0)))
        begin
            drive_combs__get_next_id__var = 1'h1;
        end //if
        if (((drive_state__floppy_op__read_data_enable!=1'h0)&&!(drive_state__last_floppy_op__read_data_enable!=1'h0)))
        begin
            drive_combs__do_read_data__var = 1'h1;
        end //if
        drive_combs__do_step_in = drive_combs__do_step_in__var;
        drive_combs__do_step_out = drive_combs__do_step_out__var;
        drive_combs__get_next_id = drive_combs__get_next_id__var;
        drive_combs__do_read_data = drive_combs__do_read_data__var;
    end //always

    //b inputs_and_outputs__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : inputs_and_outputs__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            drive_state__selected_floppy <= 2'h0;
            floppy_response__index <= 1'h0;
            floppy_response__track_zero <= 1'h0;
            floppy_response__write_protect <= 1'h0;
            floppy_response__disk_ready <= 1'h0;
            drive_state__floppy_op__step_out <= 1'h0;
            drive_state__floppy_op__step_in <= 1'h0;
            drive_state__floppy_op__next_id <= 1'h0;
            drive_state__floppy_op__read_data_enable <= 1'h0;
            drive_state__floppy_op__write_data_enable <= 1'h0;
            drive_state__floppy_op__write_data <= 32'h0;
            drive_state__floppy_op__write_sector_id_enable <= 1'h0;
            drive_state__floppy_op__sector_id__track <= 7'h0;
            drive_state__floppy_op__sector_id__head <= 1'h0;
            drive_state__floppy_op__sector_id__sector_number <= 6'h0;
            drive_state__floppy_op__sector_id__sector_length <= 2'h0;
            drive_state__floppy_op__sector_id__bad_crc <= 1'h0;
            drive_state__floppy_op__sector_id__bad_data_crc <= 1'h0;
            drive_state__floppy_op__sector_id__deleted_data <= 1'h0;
            drive_state__last_floppy_op__step_out <= 1'h0;
            drive_state__last_floppy_op__step_in <= 1'h0;
            drive_state__last_floppy_op__next_id <= 1'h0;
            drive_state__last_floppy_op__read_data_enable <= 1'h0;
            drive_state__last_floppy_op__write_data_enable <= 1'h0;
            drive_state__last_floppy_op__write_data <= 32'h0;
            drive_state__last_floppy_op__write_sector_id_enable <= 1'h0;
            drive_state__last_floppy_op__sector_id__track <= 7'h0;
            drive_state__last_floppy_op__sector_id__head <= 1'h0;
            drive_state__last_floppy_op__sector_id__sector_number <= 6'h0;
            drive_state__last_floppy_op__sector_id__sector_length <= 2'h0;
            drive_state__last_floppy_op__sector_id__bad_crc <= 1'h0;
            drive_state__last_floppy_op__sector_id__bad_data_crc <= 1'h0;
            drive_state__last_floppy_op__sector_id__deleted_data <= 1'h0;
        end
        else if (clk__enable)
        begin
            drive_state__selected_floppy <= 2'h0;
            floppy_response__index <= (current_floppy__current_physical_sector==8'h0);
            floppy_response__track_zero <= (current_floppy__current_track==8'h0);
            floppy_response__write_protect <= current_floppy__write_protect;
            floppy_response__disk_ready <= current_floppy__disk_ready;
            drive_state__floppy_op__step_out <= floppy_op__step_out;
            drive_state__floppy_op__step_in <= floppy_op__step_in;
            drive_state__floppy_op__next_id <= floppy_op__next_id;
            drive_state__floppy_op__read_data_enable <= floppy_op__read_data_enable;
            drive_state__floppy_op__write_data_enable <= floppy_op__write_data_enable;
            drive_state__floppy_op__write_data <= floppy_op__write_data;
            drive_state__floppy_op__write_sector_id_enable <= floppy_op__write_sector_id_enable;
            drive_state__floppy_op__sector_id__track <= floppy_op__sector_id__track;
            drive_state__floppy_op__sector_id__head <= floppy_op__sector_id__head;
            drive_state__floppy_op__sector_id__sector_number <= floppy_op__sector_id__sector_number;
            drive_state__floppy_op__sector_id__sector_length <= floppy_op__sector_id__sector_length;
            drive_state__floppy_op__sector_id__bad_crc <= floppy_op__sector_id__bad_crc;
            drive_state__floppy_op__sector_id__bad_data_crc <= floppy_op__sector_id__bad_data_crc;
            drive_state__floppy_op__sector_id__deleted_data <= floppy_op__sector_id__deleted_data;
            drive_state__last_floppy_op__step_out <= drive_state__floppy_op__step_out;
            drive_state__last_floppy_op__step_in <= drive_state__floppy_op__step_in;
            drive_state__last_floppy_op__next_id <= drive_state__floppy_op__next_id;
            drive_state__last_floppy_op__read_data_enable <= drive_state__floppy_op__read_data_enable;
            drive_state__last_floppy_op__write_data_enable <= drive_state__floppy_op__write_data_enable;
            drive_state__last_floppy_op__write_data <= drive_state__floppy_op__write_data;
            drive_state__last_floppy_op__write_sector_id_enable <= drive_state__floppy_op__write_sector_id_enable;
            drive_state__last_floppy_op__sector_id__track <= drive_state__floppy_op__sector_id__track;
            drive_state__last_floppy_op__sector_id__head <= drive_state__floppy_op__sector_id__head;
            drive_state__last_floppy_op__sector_id__sector_number <= drive_state__floppy_op__sector_id__sector_number;
            drive_state__last_floppy_op__sector_id__sector_length <= drive_state__floppy_op__sector_id__sector_length;
            drive_state__last_floppy_op__sector_id__bad_crc <= drive_state__floppy_op__sector_id__bad_crc;
            drive_state__last_floppy_op__sector_id__bad_data_crc <= drive_state__floppy_op__sector_id__bad_data_crc;
            drive_state__last_floppy_op__sector_id__deleted_data <= drive_state__floppy_op__sector_id__deleted_data;
        end //if
    end //always

    //b floppy_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//floppy_logic__comb
    begin: floppy_logic__comb_code
    reg [1:0]floppy_combs__fsm_request__var;
        floppy_combs__fsm_request__var = 2'h0;
        if ((drive_combs__get_next_id!=1'h0))
        begin
            floppy_combs__fsm_request__var = 2'h1;
        end //if
        if ((drive_combs__do_read_data!=1'h0))
        begin
            floppy_combs__fsm_request__var = 2'h2;
        end //if
        floppy_combs__fsm_request = floppy_combs__fsm_request__var;
    end //always

    //b floppy_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : floppy_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            floppy_disk_state__track_id_sram_offset[0] <= 12'h0;
            floppy_disk_state__track_id_sram_offset[1] <= 12'h0;
            floppy_disk_state__track_id_sram_offset[2] <= 12'h0;
            floppy_disk_state__track_id_sram_offset[3] <= 12'h0;
            floppy_disk_state__track_data_sram_offset[0] <= 20'h0;
            floppy_disk_state__track_data_sram_offset[1] <= 20'h0;
            floppy_disk_state__track_data_sram_offset[2] <= 20'h0;
            floppy_disk_state__track_data_sram_offset[3] <= 20'h0;
            floppy_disk_state__current_track[0] <= 8'h0;
            floppy_disk_state__current_track[1] <= 8'h0;
            floppy_disk_state__current_track[2] <= 8'h0;
            floppy_disk_state__current_track[3] <= 8'h0;
            floppy_disk_state__current_physical_sector[0] <= 8'h0;
            floppy_disk_state__current_physical_sector[1] <= 8'h0;
            floppy_disk_state__current_physical_sector[2] <= 8'h0;
            floppy_disk_state__current_physical_sector[3] <= 8'h0;
            floppy_disk_state__next_sector_is_zero[0] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__next_sector_is_zero[1] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__next_sector_is_zero[2] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__next_sector_is_zero[3] <= 1'h0; // Should this be a bit vector?
        end
        else if (clk__enable)
        begin
            if ((current_floppy__current_track==8'h0))
            begin
                floppy_disk_state__track_id_sram_offset[drive_state__selected_floppy] <= 12'h0;
                floppy_disk_state__track_data_sram_offset[drive_state__selected_floppy] <= 20'h0;
            end //if
            if ((drive_combs__do_step_in!=1'h0))
            begin
                if ((current_floppy__current_track!=current_floppy__num_tracks))
                begin
                    floppy_disk_state__current_track[drive_state__selected_floppy] <= (current_floppy__current_track+8'h1);
                    floppy_disk_state__current_physical_sector[drive_state__selected_floppy] <= 8'h0;
                    floppy_disk_state__track_id_sram_offset[drive_state__selected_floppy] <= (current_floppy__track_id_sram_offset+{4'h0,current_floppy__sectors_per_track});
                    floppy_disk_state__track_data_sram_offset[drive_state__selected_floppy] <= (current_floppy__track_data_sram_offset+{{6'h0,current_floppy__sectors_per_track},6'h0});
                end //if
                floppy_disk_state__next_sector_is_zero[drive_state__selected_floppy] <= 1'h1;
            end //if
            if ((drive_combs__do_step_out!=1'h0))
            begin
                if ((current_floppy__current_track!=8'h0))
                begin
                    floppy_disk_state__current_track[drive_state__selected_floppy] <= (current_floppy__current_track-8'h1);
                    floppy_disk_state__track_id_sram_offset[drive_state__selected_floppy] <= (current_floppy__track_id_sram_offset-{4'h0,current_floppy__sectors_per_track});
                    floppy_disk_state__track_data_sram_offset[drive_state__selected_floppy] <= (current_floppy__track_data_sram_offset-{{6'h0,current_floppy__sectors_per_track},6'h0});
                    floppy_disk_state__current_physical_sector[drive_state__selected_floppy] <= 8'h0;
                end //if
                else
                
                begin
                    floppy_disk_state__current_track[drive_state__selected_floppy] <= 8'h0;
                    floppy_disk_state__current_physical_sector[drive_state__selected_floppy] <= 8'h0;
                    floppy_disk_state__track_id_sram_offset[drive_state__selected_floppy] <= 12'h0;
                    floppy_disk_state__track_data_sram_offset[drive_state__selected_floppy] <= 20'h0;
                end //else
                floppy_disk_state__next_sector_is_zero[drive_state__selected_floppy] <= 1'h1;
            end //if
            if ((drive_combs__get_next_id!=1'h0))
            begin
                if ((current_floppy__next_sector_is_zero!=1'h0))
                begin
                    floppy_disk_state__current_physical_sector[drive_state__selected_floppy] <= 8'h0;
                end //if
                else
                
                begin
                    floppy_disk_state__current_physical_sector[drive_state__selected_floppy] <= (current_floppy__current_physical_sector+8'h1);
                    if ((current_floppy__current_physical_sector==(current_floppy__sectors_per_track-8'h1)))
                    begin
                        floppy_disk_state__current_physical_sector[drive_state__selected_floppy] <= 8'h0;
                    end //if
                end //else
                floppy_disk_state__next_sector_is_zero[drive_state__selected_floppy] <= 1'h0;
            end //if
        end //if
    end //always

    //b floppy_fsm__comb combinatorial process
        //   
        //       Floppy FSM - read or write SRAM as requested
        //       
    always @ ( * )//floppy_fsm__comb
    begin: floppy_fsm__comb_code
        current_floppy__disk_ready = floppy_disk_state__disk_ready[drive_state__selected_floppy];
        current_floppy__write_protect = floppy_disk_state__write_protect[drive_state__selected_floppy];
        current_floppy__num_tracks = floppy_disk_state__num_tracks[drive_state__selected_floppy];
        current_floppy__sram_data_base_address = floppy_disk_state__sram_data_base_address[drive_state__selected_floppy];
        current_floppy__sram_id_base_address = floppy_disk_state__sram_id_base_address[drive_state__selected_floppy];
        current_floppy__sectors_per_track = floppy_disk_state__sectors_per_track[drive_state__selected_floppy];
        current_floppy__current_track = floppy_disk_state__current_track[drive_state__selected_floppy];
        current_floppy__current_physical_sector = floppy_disk_state__current_physical_sector[drive_state__selected_floppy];
        current_floppy__next_sector_is_zero = floppy_disk_state__next_sector_is_zero[drive_state__selected_floppy];
        current_floppy__data_words_per_track = floppy_disk_state__data_words_per_track[drive_state__selected_floppy];
        current_floppy__track_data_sram_offset = floppy_disk_state__track_data_sram_offset[drive_state__selected_floppy];
        current_floppy__track_id_sram_offset = floppy_disk_state__track_id_sram_offset[drive_state__selected_floppy];
        current_floppy__data_word_offset = floppy_disk_state__data_word_offset[drive_state__selected_floppy];
        current_floppy__sector_id__track = floppy_disk_state__sector_id__track[drive_state__selected_floppy];
        current_floppy__sector_id__head = floppy_disk_state__sector_id__head[drive_state__selected_floppy];
        current_floppy__sector_id__sector_number = floppy_disk_state__sector_id__sector_number[drive_state__selected_floppy];
        current_floppy__sector_id__sector_length = floppy_disk_state__sector_id__sector_length[drive_state__selected_floppy];
        current_floppy__sector_id__bad_crc = floppy_disk_state__sector_id__bad_crc[drive_state__selected_floppy];
        current_floppy__sector_id__bad_data_crc = floppy_disk_state__sector_id__bad_data_crc[drive_state__selected_floppy];
        current_floppy__sector_id__deleted_data = floppy_disk_state__sector_id__deleted_data[drive_state__selected_floppy];
        floppy_combs__sram_data_address = (((current_floppy__sram_data_base_address+current_floppy__track_data_sram_offset)+{{6'h0,current_floppy__current_physical_sector},6'h0})+{8'h0,current_floppy__data_word_offset});
        floppy_combs__sram_id_address = ((current_floppy__sram_id_base_address+{8'h0,current_floppy__track_id_sram_offset})+{12'h0,current_floppy__current_physical_sector});
    end //always

    //b floppy_fsm__posedge_clk_active_low_reset_n clock process
        //   
        //       Floppy FSM - read or write SRAM as requested
        //       
    always @( posedge clk or negedge reset_n)
    begin : floppy_fsm__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            floppy_state__sram_request__enable <= 1'h0;
            floppy_state__sram_request__write_data <= 32'h0;
            floppy_disk_state__data_word_offset[0] <= 12'h0;
            floppy_disk_state__data_word_offset[1] <= 12'h0;
            floppy_disk_state__data_word_offset[2] <= 12'h0;
            floppy_disk_state__data_word_offset[3] <= 12'h0;
            floppy_state__fsm_state <= 4'h0;
            floppy_state__fsm_state <= 4'h0;
            floppy_state__sram_request__address <= 20'h0;
            floppy_state__sram_request__read_not_write <= 1'h0;
            floppy_disk_state__sector_id__bad_crc[0] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__bad_crc[1] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__bad_crc[2] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__bad_crc[3] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__bad_data_crc[0] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__bad_data_crc[1] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__bad_data_crc[2] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__bad_data_crc[3] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__deleted_data[0] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__deleted_data[1] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__deleted_data[2] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__deleted_data[3] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__head[0] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__head[1] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__head[2] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__head[3] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__sector_id__sector_length[0] <= 2'h0;
            floppy_disk_state__sector_id__sector_length[1] <= 2'h0;
            floppy_disk_state__sector_id__sector_length[2] <= 2'h0;
            floppy_disk_state__sector_id__sector_length[3] <= 2'h0;
            floppy_disk_state__sector_id__sector_number[0] <= 6'h0;
            floppy_disk_state__sector_id__sector_number[1] <= 6'h0;
            floppy_disk_state__sector_id__sector_number[2] <= 6'h0;
            floppy_disk_state__sector_id__sector_number[3] <= 6'h0;
            floppy_disk_state__sector_id__track[0] <= 7'h0;
            floppy_disk_state__sector_id__track[1] <= 7'h0;
            floppy_disk_state__sector_id__track[2] <= 7'h0;
            floppy_disk_state__sector_id__track[3] <= 7'h0;
            floppy_response__read_data_valid <= 1'h0;
            floppy_response__read_data <= 32'h0;
            floppy_response__sector_id_valid <= 1'h0;
            floppy_response__sector_id__track <= 7'h0;
            floppy_response__sector_id__head <= 1'h0;
            floppy_response__sector_id__sector_number <= 6'h0;
            floppy_response__sector_id__sector_length <= 2'h0;
            floppy_response__sector_id__bad_crc <= 1'h0;
            floppy_response__sector_id__bad_data_crc <= 1'h0;
            floppy_response__sector_id__deleted_data <= 1'h0;
        end
        else if (clk__enable)
        begin
            floppy_state__sram_request__enable <= 1'h0;
            floppy_state__sram_request__write_data <= 32'h0;
            if ((((drive_combs__do_step_out!=1'h0)||(drive_combs__do_step_in!=1'h0))||(drive_combs__get_next_id!=1'h0)))
            begin
                floppy_disk_state__data_word_offset[drive_state__selected_floppy] <= 12'h0;
            end //if
            case (floppy_state__fsm_state) //synopsys parallel_case
            4'h0: // req 1
                begin
                if ((floppy_combs__fsm_request==2'h2))
                begin
                    floppy_state__fsm_state <= 4'h1;
                end //if
                else
                
                begin
                    if ((floppy_combs__fsm_request==2'h1))
                    begin
                        floppy_state__fsm_state <= 4'h5;
                    end //if
                end //else
                end
            4'h1: // req 1
                begin
                floppy_state__sram_request__address <= floppy_combs__sram_data_address;
                floppy_state__sram_request__enable <= 1'h1;
                floppy_state__sram_request__read_not_write <= 1'h1;
                floppy_state__fsm_state <= 4'h2;
                end
            4'h2: // req 1
                begin
                floppy_state__sram_request__enable <= 1'h1;
                if ((sram_combs__ack!=1'h0))
                begin
                    floppy_state__sram_request__enable <= 1'h0;
                    floppy_state__fsm_state <= 4'h3;
                end //if
                end
            4'h3: // req 1
                begin
                if ((sram_combs__read_data_valid!=1'h0))
                begin
                    floppy_state__fsm_state <= 4'h4;
                end //if
                end
            4'h4: // req 1
                begin
                floppy_disk_state__data_word_offset[drive_state__selected_floppy] <= (current_floppy__data_word_offset+12'h1);
                floppy_state__fsm_state <= 4'h0;
                end
            4'h5: // req 1
                begin
                floppy_state__sram_request__address <= floppy_combs__sram_id_address;
                floppy_state__sram_request__enable <= 1'h1;
                floppy_state__sram_request__read_not_write <= 1'h1;
                floppy_state__fsm_state <= 4'h6;
                end
            4'h6: // req 1
                begin
                floppy_state__sram_request__enable <= 1'h1;
                if ((sram_combs__ack!=1'h0))
                begin
                    floppy_state__sram_request__enable <= 1'h0;
                    floppy_state__fsm_state <= 4'h7;
                end //if
                end
            4'h7: // req 1
                begin
                if ((sram_combs__read_data_valid!=1'h0))
                begin
                    floppy_state__fsm_state <= 4'h8;
                    floppy_disk_state__sector_id__bad_crc[drive_state__selected_floppy] <= sram_combs__read_data[23];
                    floppy_disk_state__sector_id__bad_data_crc[drive_state__selected_floppy] <= sram_combs__read_data[22];
                    floppy_disk_state__sector_id__deleted_data[drive_state__selected_floppy] <= sram_combs__read_data[21];
                    floppy_disk_state__sector_id__head[drive_state__selected_floppy] <= sram_combs__read_data[20];
                    floppy_disk_state__sector_id__sector_length[drive_state__selected_floppy] <= sram_combs__read_data[17:16];
                    floppy_disk_state__sector_id__sector_number[drive_state__selected_floppy] <= sram_combs__read_data[13:8];
                    floppy_disk_state__sector_id__track[drive_state__selected_floppy] <= sram_combs__read_data[6:0];
                end //if
                end
            4'h8: // req 1
                begin
                floppy_state__fsm_state <= 4'h0;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:bbc_floppy_sram:floppy_fsm: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            floppy_response__read_data_valid <= 1'h0;
            if ((sram_combs__read_data_valid!=1'h0))
            begin
                floppy_response__read_data <= sram_combs__read_data;
            end //if
            if ((floppy_state__fsm_state==4'h4))
            begin
                floppy_response__read_data_valid <= 1'h1;
            end //if
            floppy_response__sector_id_valid <= 1'h0;
            if ((floppy_state__fsm_state==4'h8))
            begin
                floppy_response__sector_id_valid <= 1'h1;
            end //if
            floppy_response__sector_id__track <= current_floppy__sector_id__track;
            floppy_response__sector_id__head <= current_floppy__sector_id__head;
            floppy_response__sector_id__sector_number <= current_floppy__sector_id__sector_number;
            floppy_response__sector_id__sector_length <= current_floppy__sector_id__sector_length;
            floppy_response__sector_id__bad_crc <= current_floppy__sector_id__bad_crc;
            floppy_response__sector_id__bad_data_crc <= current_floppy__sector_id__bad_data_crc;
            floppy_response__sector_id__deleted_data <= current_floppy__sector_id__deleted_data;
        end //if
    end //always

    //b sram_interface combinatorial process
        //   
        //       
    always @ ( * )//sram_interface
    begin: sram_interface__comb_code
        sram_combs__ack = sram_response__ack;
        sram_combs__read_data_valid = sram_response__read_data_valid;
        sram_combs__read_data = sram_response__read_data;
        sram_request__enable = floppy_state__sram_request__enable;
        sram_request__read_not_write = floppy_state__sram_request__read_not_write;
        sram_request__address = floppy_state__sram_request__address;
        sram_request__write_data = floppy_state__sram_request__write_data;
    end //always

    //b csrs_read_write clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : csrs_read_write__code
        if (reset_n==1'b0)
        begin
            csr_response__ack <= 1'h0;
            csr_response__read_data_valid <= 1'h0;
            csr_response__read_data <= 32'h0;
            floppy_disk_state__disk_ready[0] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__disk_ready[1] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__disk_ready[2] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__disk_ready[3] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__num_tracks[0] <= 8'h0;
            floppy_disk_state__num_tracks[1] <= 8'h0;
            floppy_disk_state__num_tracks[2] <= 8'h0;
            floppy_disk_state__num_tracks[3] <= 8'h0;
            floppy_disk_state__sectors_per_track[0] <= 8'h0;
            floppy_disk_state__sectors_per_track[1] <= 8'h0;
            floppy_disk_state__sectors_per_track[2] <= 8'h0;
            floppy_disk_state__sectors_per_track[3] <= 8'h0;
            floppy_disk_state__sram_id_base_address[0] <= 20'h0;
            floppy_disk_state__sram_id_base_address[1] <= 20'h0;
            floppy_disk_state__sram_id_base_address[2] <= 20'h0;
            floppy_disk_state__sram_id_base_address[3] <= 20'h0;
            floppy_disk_state__sram_data_base_address[0] <= 20'h0;
            floppy_disk_state__sram_data_base_address[1] <= 20'h0;
            floppy_disk_state__sram_data_base_address[2] <= 20'h0;
            floppy_disk_state__sram_data_base_address[3] <= 20'h0;
            floppy_disk_state__data_words_per_track[0] <= 12'h0;
            floppy_disk_state__data_words_per_track[1] <= 12'h0;
            floppy_disk_state__data_words_per_track[2] <= 12'h0;
            floppy_disk_state__data_words_per_track[3] <= 12'h0;
            floppy_disk_state__write_protect[0] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__write_protect[1] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__write_protect[2] <= 1'h0; // Should this be a bit vector?
            floppy_disk_state__write_protect[3] <= 1'h0; // Should this be a bit vector?
        end
        else if (clk__enable)
        begin
            csr_response__ack <= 1'h0;
            csr_response__read_data_valid <= 1'h0;
            csr_response__read_data <= 32'h0;
            floppy_disk_state__disk_ready[0] <= 1'h1;
            floppy_disk_state__num_tracks[0] <= 8'h50;
            floppy_disk_state__sectors_per_track[0] <= 8'ha;
            floppy_disk_state__sram_id_base_address[0] <= 20'h7000;
            floppy_disk_state__sram_data_base_address[0] <= 20'h0;
            floppy_disk_state__data_words_per_track[0] <= 12'ha00;
            floppy_disk_state__write_protect[0] <= 1'h1;
        end //if
    end //always

endmodule // bbc_floppy_sram
