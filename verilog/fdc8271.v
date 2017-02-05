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

//a Module fdc8271
    //   
    //   Diskettes had a standard format, with up to 80 (or so) tracks, each with a fixed layout
    //   
    //   Each track would 'start' at the index marker, with a sync gap; the
    //   track then contained 'N' sectors each with an ID, a sync gap, data and
    //   another sync gap.
    //   
    //   At the end there would be a final gap - but not a sync gap. A sync gap
    //   is 8hff's followed by six 8h00's. The final gap is all 8hff.
    //   
    //   What this means is that effectively a track is 1's until the
    //   first sector Each sector is 48 0's, then a sector ID (which starts
    //   with a 1) followed by 1's with about 48 0's separating the ID from the
    //   sector data. The sector data starts with a single marker byte
    //   (starting with a 1) followed by the data and a CRC, followed by 1's.
    //   
    //   The 48 0's may not always be 48, and the 1's may vary too - these are
    //   effectively start/stop regions, which can be encroached on by
    //   variations in disk speed.
    //   
    //   Bytes on the disk are stored with a high clock pulse every 4us, and a
    //   low or high data pulse in the middle (i.e. after 2us).
    //   
    //   Each bit on the disk is normally 4us, and a track is notionally
    //   8*5,208 bits, so 166,656us (basically 1/6th of a second). This is
    //   because the disk spins at 360rpm, 6rps.
    //   At 4us/bit, a byte is read a 32us/byte - this is the NMI response time.
    //   
    //   Note that the index markers have gapped clocks, to identify them
    //   properly - but the data is guaranteed to have ones, so the disk will
    //   not have just zeros for the index markers.
    //   
    //   A simple implementation of a disk system might just support the sector
    //   data with a fixed number of sectors. However, for more flexibility
    //   (and perhaps ease of hardware implementation here) an alternative
    //   approach can be taken. This is to have a sector descriptor memory, as
    //   well as a disk data memory.
    //   
    //   The sector descriptor memory is indexed by track and sector
    //   number. Supporting up to 16 sectors per track means that a sector
    //   descriptor memory is addressed by {track[7;0], sector[4;0]} - an
    //   11-bit address. The sector descriptor memory is indexed by physical
    //   sector - i.e. the position on the track. The sector descriptor memory
    //   contains the sector's logical sector number.
    //   
    //   The sector descriptor (64 bits) must contain:
    //   
    //   * bit indicating it is valid (so that a max number of sectors <16 can be used)
    //   * start address in disk data memory of sector data (excluding the
    //   * bottom 7 bits must be zero, since sectors are always a multiple of
    //   * 128 bytes)
    //   
    //   * id address mark for sector (8 bits) (8hFE, clock pattern 8hc7)
    //   * track number (7 bits)
    //   * head number (1 bit)
    //   * sector number (4 bits)
    //   * sector length (2 bits, 0=>128, 1=>256, 2=>512, 3=>1024)
    //   * disk data address mark  (8 bits) (8hFB valid, 8hf8 deleted data) (in the sector data itself on the disk)
    //   * bit indicating ID has bad CRC
    //   * bit indicating data has bad CRC
    //   
    //   A disk descriptor then needs a base address of sector descriptor data,
    //   a base address of disk data memory, a number of tracks.  For emulation
    //   purposes, the disk descriptor also includes details on how realistic
    //   the timing should be.
    //   It should also have a 'valid' bit (0 if disk not loaded), and a 'write protect' bit
    //   
    //   The NMI code is:
    //    7 (NMI brk)
    //    3 0xd00 PHA
    //    4 0xd01 LDA &FE28        ;; FDC Status/Command
    //    2 0xd04 AND #&1F
    //    2 0xd06 CMP #&03
    //   *2 0xd08 BNE LBCBA ... error handling
    //    4 0xd0a LDA &FE2B        ;; FDC Data
    //    4 0xd0d STA &FFFF        ;; Replaced with destination address
    //    6 0xd10 INC 0xD0E
    //   *3 0xd13 BNE 0xd18
    //    - 0xd15 INC 0xD0F
    //    4 0xd18 PLA
    //    6 0xd19 RTI
    //   
    //   Total of 47 cycles, or 23.5us per byte for data transfers
    //   
    //       On a real drive, each track has 5208 bytes.
    //       * index mark
    //       * post-index gap, 32 bytes (26 0xff, 6 0x00 sync)
    //       * Numsectors * { id field, 7 bytes; post-id field gap 17 bytes (11 0xff, 6 0x00 sync); data field (n bytes); post-data field gap 33 bytes (27 0xff, 6 0x00 sync) }
    //       * trailing gap (40 0xff, 6 0x00 sync)
    //   
    //       id field is:
    //       * id address mark
    //       * track address (00-74, officially in 8271)
    //       * head address (0 or 1)
    //       * sector address (01-26)
    //       * sector length (0=>128, 1=>256, 2=>512)
    //       * 2 bytes CRC
    //   
    //       data field is:
    //       * data address mark
    //       * N bytes data
    //       * 2 byte CRC
    //   
    //   
module fdc8271
(
    clk,
    clk__enable,

    bbc_floppy_response__sector_id_valid,
    bbc_floppy_response__sector_id__track,
    bbc_floppy_response__sector_id__head,
    bbc_floppy_response__sector_id__sector_number,
    bbc_floppy_response__sector_id__sector_length,
    bbc_floppy_response__sector_id__bad_crc,
    bbc_floppy_response__sector_id__bad_data_crc,
    bbc_floppy_response__sector_id__deleted_data,
    bbc_floppy_response__index,
    bbc_floppy_response__read_data_valid,
    bbc_floppy_response__read_data,
    bbc_floppy_response__track_zero,
    bbc_floppy_response__write_protect,
    bbc_floppy_response__disk_ready,
    index_n,
    write_protect_n,
    track_0_n,
    ready,
    data_ack_n,
    data_in,
    address,
    write_n,
    read_n,
    chip_select_n,
    reset_n,

    bbc_floppy_op__step_out,
    bbc_floppy_op__step_in,
    bbc_floppy_op__next_id,
    bbc_floppy_op__read_data_enable,
    bbc_floppy_op__write_data_enable,
    bbc_floppy_op__write_data,
    bbc_floppy_op__write_sector_id_enable,
    bbc_floppy_op__sector_id__track,
    bbc_floppy_op__sector_id__head,
    bbc_floppy_op__sector_id__sector_number,
    bbc_floppy_op__sector_id__sector_length,
    bbc_floppy_op__sector_id__bad_crc,
    bbc_floppy_op__sector_id__bad_data_crc,
    bbc_floppy_op__sector_id__deleted_data,
    low_current,
    load_head,
    direction,
    seek_step,
    write_enable,
    fault_reset,
    select,
    data_req,
    irq_n,
    data_out
);

    //b Clocks
        //   
    input clk;
    input clk__enable;

    //b Inputs
        //   Parallel data read, specific to the model
    input bbc_floppy_response__sector_id_valid;
    input [6:0]bbc_floppy_response__sector_id__track;
    input bbc_floppy_response__sector_id__head;
    input [5:0]bbc_floppy_response__sector_id__sector_number;
    input [1:0]bbc_floppy_response__sector_id__sector_length;
    input bbc_floppy_response__sector_id__bad_crc;
    input bbc_floppy_response__sector_id__bad_data_crc;
    input bbc_floppy_response__sector_id__deleted_data;
    input bbc_floppy_response__index;
    input bbc_floppy_response__read_data_valid;
    input [31:0]bbc_floppy_response__read_data;
    input bbc_floppy_response__track_zero;
    input bbc_floppy_response__write_protect;
    input bbc_floppy_response__disk_ready;
        //   Asserted low if the selected drive photodiode indicates start of track
    input index_n;
        //   Asserted low if the selected drive is write-protected
    input write_protect_n;
        //   Asserted low if the selected drive is on track 0
    input track_0_n;
        //   drive ready
    input [1:0]ready;
        //   
    input data_ack_n;
        //   Data in (from CPU)
    input [7:0]data_in;
        //   Address of register being accessed
    input [1:0]address;
        //   Indicates a write transaction if asserted and chip selected
    input write_n;
        //   Indicates a read transaction if asserted and chip selected
    input read_n;
        //   Active low chip select
    input chip_select_n;
        //   8271 has an active high reset, but...
    input reset_n;

    //b Outputs
        //   Model drive operation, including write data
    output bbc_floppy_op__step_out;
    output bbc_floppy_op__step_in;
    output bbc_floppy_op__next_id;
    output bbc_floppy_op__read_data_enable;
    output bbc_floppy_op__write_data_enable;
    output [31:0]bbc_floppy_op__write_data;
    output bbc_floppy_op__write_sector_id_enable;
    output [6:0]bbc_floppy_op__sector_id__track;
    output bbc_floppy_op__sector_id__head;
    output [5:0]bbc_floppy_op__sector_id__sector_number;
    output [1:0]bbc_floppy_op__sector_id__sector_length;
    output bbc_floppy_op__sector_id__bad_crc;
    output bbc_floppy_op__sector_id__bad_data_crc;
    output bbc_floppy_op__sector_id__deleted_data;
        //   Asserted for track>=43
    output low_current;
        //   Enable drive head
    output load_head;
        //   Direction of step
    output direction;
        //   High if the drive should step
    output seek_step;
        //   High if the drive should write data
    output write_enable;
        //   
    output fault_reset;
        //   drive select
    output [1:0]select;
        //   
    output data_req;
        //   Was INT on the 8271, but that means something else now; active low interrupt
    output irq_n;
        //   Read data out (to CPU)
    output [7:0]data_out;

// output components here

    //b Output combinatorials
        //   Asserted for track>=43
    reg low_current;
        //   Enable drive head
    reg load_head;
        //   Direction of step
    reg direction;
        //   High if the drive should step
    reg seek_step;
        //   High if the drive should write data
    reg write_enable;
        //   
    reg fault_reset;
        //   drive select
    reg [1:0]select;
        //   
    reg data_req;
        //   Was INT on the 8271, but that means something else now; active low interrupt
    reg irq_n;
        //   Read data out (to CPU)
    reg [7:0]data_out;

    //b Output nets

    //b Internal and output registers
    reg interrupt_pending;
        //   Drive ready; this is 'zero latching', but what that means is anybody's guess. It has to toggle to work.
    reg [1:0]internal_disk_ready;
    reg [7:0]drive_timing_state__timer_data;
    reg [4:0]drive_timing_state__timer_10us;
    reg drive_timing_state__direction_setting;
    reg drive_timing_state__step_setting;
    reg drive_timing_state__loading_head;
    reg [11:0]drive_timing_state__timer_1ms;
    reg [7:0]drive_timing_state__step_counter;
    reg [9:0]drive_timing_state__head_counter;
    reg [7:0]drive_operation_state__retry_count;
    reg [7:0]drive_operation_state__words_remaining;
    reg [4:0]drive_operation_state__fsm_state;
    reg [7:0]drive_operation_state__current_track;
    reg [31:0]drive_operation_state__read_data_buffer;
    reg [6:0]drive_operation_state__sector_id__track;
    reg drive_operation_state__sector_id__head;
    reg [5:0]drive_operation_state__sector_id__sector_number;
    reg [1:0]drive_operation_state__sector_id__sector_length;
    reg drive_operation_state__sector_id__bad_crc;
    reg drive_operation_state__sector_id__bad_data_crc;
    reg drive_operation_state__sector_id__deleted_data;
    reg [3:0]drive_execution_state__fsm_state;
    reg [2:0]drive_execution_state__operation;
    reg [31:0]drive_execution_state__read_data_buffer;
    reg [3:0]drive_execution_state__read_data_valid;
    reg [5:0]command_state__fsm_state;
    reg command_state__busy;
    reg [1:0]command_state__select;
    reg command_state__surface;
    reg [7:0]command_state__special_reg;
    reg [7:0]command_state__command_track;
    reg [7:0]command_state__command_sector;
    reg [4:0]command_state__command_num_sectors;
    reg [2:0]command_state__command_sector_length;
    reg drive_outputs__direction;
    reg drive_outputs__step;
    reg drive_outputs__load_head;
    reg drive_outputs__write_enable;
    reg [1:0]drive_outputs__select;
    reg drive_outputs__fault_reset;
    reg drive_outputs__low_current;
    reg [7:0]control__scan__sector;
    reg [7:0]control__scan__msb;
    reg [6:0]control__scan__lsb;
    reg [7:0]control__drive_0__current_track;
    reg [7:0]control__drive_0__bad_track_1;
    reg [7:0]control__drive_0__bad_track_2;
    reg [7:0]control__drive_1__current_track;
    reg [7:0]control__drive_1__bad_track_1;
    reg [7:0]control__drive_1__bad_track_2;
    reg control__non_dma_mode;
    reg control__double_actuator;
    reg [7:0]control__step_time;
    reg [7:0]control__head_settling_time;
    reg [3:0]control__head_load_time;
    reg [3:0]control__head_unload_count;
    reg result_register__full;
    reg [7:0]result_register__data;
    reg parameter_register__full;
    reg [7:0]parameter_register__data;
    reg command_register__full;
    reg [7:0]command_register__data;
    reg internal_reset;
    reg bbc_floppy_op__step_out;
    reg bbc_floppy_op__step_in;
    reg bbc_floppy_op__next_id;
    reg bbc_floppy_op__read_data_enable;
    reg bbc_floppy_op__write_data_enable;
    reg [31:0]bbc_floppy_op__write_data;
    reg bbc_floppy_op__write_sector_id_enable;
    reg [6:0]bbc_floppy_op__sector_id__track;
    reg bbc_floppy_op__sector_id__head;
    reg [5:0]bbc_floppy_op__sector_id__sector_number;
    reg [1:0]bbc_floppy_op__sector_id__sector_length;
    reg bbc_floppy_op__sector_id__bad_crc;
    reg bbc_floppy_op__sector_id__bad_data_crc;
    reg bbc_floppy_op__sector_id__deleted_data;

    //b Internal combinatorials
    reg internal_id_ready;
        //   Asserted if the read data is currently valid
    reg internal_read_data_valid;
        //   Asserted if the selected drive is at the last sector
    reg internal_index;
        //   Asserted if the selected drive is write-protected
    reg internal_write_protect;
        //   Asserted if the selected drive is on track 0
    reg internal_track_0;
    reg [7:0]drive_timing__step_timer_1ms;
    reg [7:0]drive_timing__head_timer_4ms;
    reg drive_timing__time_10us_completed;
    reg drive_timing__time_1ms_tick;
    reg drive_timing__time_10us_start;
    reg drive_timing__time_1ms_restart;
    reg drive_timing__direction_can_be_set;
    reg drive_timing__step_can_start;
    reg drive_timing__step_in_progress;
    reg drive_timing__step_settled;
    reg drive_timing__head_settled;
    reg drive_timing__data_byte_ready;
    reg drive_operation__direction_set;
    reg drive_operation__direction_value;
    reg drive_operation__step_start;
    reg drive_operation__load_head;
    reg drive_operation__starting_op;
    reg drive_operation__completing_op;
    reg drive_operation__read_id;
    reg drive_operation__read_data;
    reg drive_operation__capture_id;
    reg drive_operation__capture_data;
    reg drive_operation__read_data_capture_id;
    reg drive_operation__read_data_capture_data;
    reg drive_execution__direction_set;
    reg drive_execution__direction_value;
    reg drive_execution__result__valid;
    reg drive_execution__takes_command;
    reg [2:0]command__drive_execution_command;
    reg command__takes_command;
    reg command__takes_parameter;
    reg command__generate_interrupt;
    reg command__set_outputs__valid;
    reg command__set_outputs__write_enable;
    reg command__set_outputs__seek_step;
    reg command__set_outputs__direction;
    reg command__set_outputs__load_head;
    reg command__set_outputs__low_head_current;
    reg command__set_outputs__write_fault_reset;
    reg [1:0]command__set_outputs__select;
    reg status_register__command_busy;
    reg status_register__command_register_full;
    reg status_register__parameter_register_full;
    reg status_register__result_register_full;
    reg status_register__non_dma_data_request;
    reg status_register__interrupt_request;
    reg [1:0]read_action;
    reg [2:0]write_action;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b read_write_logic__comb combinatorial process
        //   
        //       Read, write, DMA and control logic
        //       
    always @ ( * )//read_write_logic__comb
    begin: read_write_logic__comb_code
    reg status_register__command_busy__var;
    reg status_register__command_register_full__var;
    reg status_register__parameter_register_full__var;
    reg status_register__result_register_full__var;
    reg status_register__non_dma_data_request__var;
    reg status_register__interrupt_request__var;
    reg [2:0]write_action__var;
    reg [1:0]read_action__var;
    reg [7:0]data_out__var;
        status_register__command_busy__var = 1'h0;
        status_register__command_register_full__var = 1'h0;
        status_register__parameter_register_full__var = 1'h0;
        status_register__result_register_full__var = 1'h0;
        status_register__non_dma_data_request__var = 1'h0;
        status_register__interrupt_request__var = 1'h0;
        status_register__command_busy__var = command_state__busy;
        status_register__command_register_full__var = command_register__full;
        status_register__parameter_register_full__var = parameter_register__full;
        status_register__interrupt_request__var = interrupt_pending;
        status_register__non_dma_data_request__var = 1'h0;
        if ((control__non_dma_mode!=1'h0))
        begin
            status_register__non_dma_data_request__var = drive_execution_state__read_data_valid[0];
        end //if
        status_register__result_register_full__var = result_register__full;
        data_req = 1'h0;
        irq_n = !((status_register__interrupt_request__var!=1'h0)||(status_register__non_dma_data_request__var!=1'h0));
        write_action__var = 3'h0;
        if ((!(chip_select_n!=1'h0)&&!(write_n!=1'h0)))
        begin
            case (address) //synopsys parallel_case
            2'h0: // req 1
                begin
                write_action__var = 3'h1;
                end
            2'h1: // req 1
                begin
                write_action__var = 3'h2;
                end
            2'h2: // req 1
                begin
                write_action__var = 3'h4;
                end
            //synopsys  translate_off
            //pragma coverage off
            //synopsys  translate_on
            default:
                begin
                //Need a default case to make Cadence Lint happy, even though this is not a full case
                end
            //synopsys  translate_off
            //pragma coverage on
            //synopsys  translate_on
            endcase
        end //if
        if ((!(data_ack_n!=1'h0)&&!(write_n!=1'h0)))
        begin
            write_action__var = 3'h3;
        end //if
        read_action__var = 2'h0;
        if ((!(chip_select_n!=1'h0)&&!(read_n!=1'h0)))
        begin
            case (address) //synopsys parallel_case
            2'h0: // req 1
                begin
                read_action__var = 2'h1;
                end
            2'h1: // req 1
                begin
                read_action__var = 2'h2;
                end
            //synopsys  translate_off
            //pragma coverage off
            //synopsys  translate_on
            default:
                begin
                //Need a default case to make Cadence Lint happy, even though this is not a full case
                end
            //synopsys  translate_off
            //pragma coverage on
            //synopsys  translate_on
            endcase
        end //if
        if ((!(data_ack_n!=1'h0)&&!(read_n!=1'h0)))
        begin
            read_action__var = 2'h3;
        end //if
        data_out__var = 8'h0;
        case (read_action__var) //synopsys parallel_case
        2'h2: // req 1
            begin
            data_out__var = result_register__data;
            end
        2'h1: // req 1
            begin
            data_out__var = {{{{{{status_register__command_busy__var,status_register__command_register_full__var},status_register__parameter_register_full__var},status_register__result_register_full__var},status_register__interrupt_request__var},status_register__non_dma_data_request__var},2'h0};
            end
        2'h3: // req 1
            begin
            data_out__var = drive_execution_state__read_data_buffer[7:0];
            end
        default: // req 1
            begin
            data_out__var = 8'h0;
            end
        endcase
        status_register__command_busy = status_register__command_busy__var;
        status_register__command_register_full = status_register__command_register_full__var;
        status_register__parameter_register_full = status_register__parameter_register_full__var;
        status_register__result_register_full = status_register__result_register_full__var;
        status_register__non_dma_data_request = status_register__non_dma_data_request__var;
        status_register__interrupt_request = status_register__interrupt_request__var;
        write_action = write_action__var;
        read_action = read_action__var;
        data_out = data_out__var;
    end //always

    //b read_write_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       Read, write, DMA and control logic
        //       
    always @( posedge clk or negedge reset_n)
    begin : read_write_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            parameter_register__full <= 1'h0;
            command_register__full <= 1'h0;
            internal_reset <= 1'h0;
            command_register__data <= 8'h0;
            parameter_register__data <= 8'h0;
            result_register__full <= 1'h0;
            interrupt_pending <= 1'h0;
        end
        else if (clk__enable)
        begin
            if ((command__takes_parameter!=1'h0))
            begin
                parameter_register__full <= 1'h0;
            end //if
            if ((command__takes_command!=1'h0))
            begin
                command_register__full <= 1'h0;
            end //if
            if ((write_action==3'h4))
            begin
                internal_reset <= data_in[0];
            end //if
            if ((write_action==3'h1))
            begin
                command_register__full <= 1'h1;
                command_register__data <= data_in;
            end //if
            if ((write_action==3'h2))
            begin
                parameter_register__full <= 1'h1;
                parameter_register__data <= data_in;
            end //if
            if ((read_action==2'h2))
            begin
                result_register__full <= 1'h0;
            end //if
            case (read_action) //synopsys parallel_case
            2'h2: // req 1
                begin
                interrupt_pending <= 1'h0;
                end
            2'h1: // req 1
                begin
                end
            2'h3: // req 1
                begin
                end
            default: // req 1
                begin
                end
            endcase
            if ((command__generate_interrupt!=1'h0))
            begin
                interrupt_pending <= 1'h1;
            end //if
        end //if
    end //always

    //b command_interface_controller__comb combinatorial process
        //   
        //       Command interface controller consisting of the input buffer and output buffer
        //       
    always @ ( * )//command_interface_controller__comb
    begin: command_interface_controller__comb_code
    reg [2:0]command__drive_execution_command__var;
    reg command__takes_command__var;
    reg command__takes_parameter__var;
    reg command__generate_interrupt__var;
    reg command__set_outputs__valid__var;
    reg command__set_outputs__write_enable__var;
    reg command__set_outputs__seek_step__var;
    reg command__set_outputs__direction__var;
    reg command__set_outputs__load_head__var;
    reg command__set_outputs__low_head_current__var;
    reg command__set_outputs__write_fault_reset__var;
    reg [1:0]command__set_outputs__select__var;
        command__drive_execution_command__var = 3'h0;
        command__takes_command__var = 1'h0;
        command__takes_parameter__var = 1'h0;
        command__generate_interrupt__var = 1'h0;
        command__set_outputs__valid__var = 1'h0;
        command__set_outputs__write_enable__var = 1'h0;
        command__set_outputs__seek_step__var = 1'h0;
        command__set_outputs__direction__var = 1'h0;
        command__set_outputs__load_head__var = 1'h0;
        command__set_outputs__low_head_current__var = 1'h0;
        command__set_outputs__write_fault_reset__var = 1'h0;
        command__set_outputs__select__var = 2'h0;
        case (command_state__fsm_state) //synopsys parallel_case
        6'h0: // req 1
            begin
            command__takes_command__var = 1'h1;
            if (!(command_register__full!=1'h0))
            begin
                command__takes_command__var = 1'h0;
            end //if
            end
        6'h1: // req 1
            begin
            command__takes_parameter__var = 1'h1;
            if (!(parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h0;
            end //if
            end
        6'h2: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h3: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h4: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h5: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h6: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h7: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h8: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h9: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                case (command_state__special_reg) //synopsys parallel_case
                8'h6: // req 1
                    begin
                    end
                8'h14: // req 1
                    begin
                    end
                8'h13: // req 1
                    begin
                    end
                8'h10: // req 1
                    begin
                    end
                8'h11: // req 1
                    begin
                    end
                8'h12: // req 1
                    begin
                    end
                8'h18: // req 1
                    begin
                    end
                8'h19: // req 1
                    begin
                    end
                8'h1a: // req 1
                    begin
                    end
                8'h17: // req 1
                    begin
                    end
                8'h23: // req 1
                    begin
                    command__set_outputs__valid__var = 1'h1;
                    command__set_outputs__write_enable__var = parameter_register__data[0];
                    command__set_outputs__seek_step__var = parameter_register__data[1];
                    command__set_outputs__direction__var = parameter_register__data[2];
                    command__set_outputs__load_head__var = parameter_register__data[3];
                    command__set_outputs__low_head_current__var = parameter_register__data[4];
                    command__set_outputs__write_fault_reset__var = parameter_register__data[5];
                    command__set_outputs__select__var = parameter_register__data[7:6];
                    end
                //synopsys  translate_off
                //pragma coverage off
                //synopsys  translate_on
                default:
                    begin
                    //Need a default case to make Cadence Lint happy, even though this is not a full case
                    end
                //synopsys  translate_off
                //pragma coverage on
                //synopsys  translate_on
                endcase
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'ha: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h29: // req 1
            begin
            end
        6'hb: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'hc: // req 1
            begin
            command__drive_execution_command__var = 3'h2;
            end
        6'hd: // req 1
            begin
            end
        6'h16: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h17: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h18: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h19: // req 1
            begin
            command__drive_execution_command__var = 3'h3;
            end
        6'h1a: // req 1
            begin
            command__drive_execution_command__var = 3'h1;
            end
        6'h1b: // req 1
            begin
            if ((control__scan__sector==8'h0))
            begin
            end //if
            else
            
            begin
                command__drive_execution_command__var = 3'h4;
            end //else
            end
        6'h1c: // req 1
            begin
            end
        6'h1d: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h1e: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h20: // req 1
            begin
            command__drive_execution_command__var = 3'h3;
            end
        6'h1f: // req 1
            begin
            command__drive_execution_command__var = 3'h5;
            end
        6'h21: // req 1
            begin
            end
        6'h22: // req 1
            begin
            command__drive_execution_command__var = 3'h6;
            end
        6'h23: // req 1
            begin
            end
        6'he: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'hf: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h10: // req 1
            begin
            if ((parameter_register__full!=1'h0))
            begin
                command__takes_parameter__var = 1'h1;
            end //if
            end
        6'h12: // req 1
            begin
            command__drive_execution_command__var = 3'h3;
            end
        6'h11: // req 1
            begin
            if ((command_state__command_num_sectors==5'h0))
            begin
            end //if
            else
            
            begin
                command__drive_execution_command__var = 3'h5;
            end //else
            end
        6'h13: // req 1
            begin
            end
        6'h14: // req 1
            begin
            command__drive_execution_command__var = 3'h6;
            end
        6'h15: // req 1
            begin
            end
        6'h25: // req 1
            begin
            end
        6'h26: // req 1
            begin
            end
        6'h27: // req 1
            begin
            command__generate_interrupt__var = 1'h1;
            end
        default: // req 1
            begin
            command__takes_parameter__var = 1'h0;
            end
        endcase
        command__drive_execution_command = command__drive_execution_command__var;
        command__takes_command = command__takes_command__var;
        command__takes_parameter = command__takes_parameter__var;
        command__generate_interrupt = command__generate_interrupt__var;
        command__set_outputs__valid = command__set_outputs__valid__var;
        command__set_outputs__write_enable = command__set_outputs__write_enable__var;
        command__set_outputs__seek_step = command__set_outputs__seek_step__var;
        command__set_outputs__direction = command__set_outputs__direction__var;
        command__set_outputs__load_head = command__set_outputs__load_head__var;
        command__set_outputs__low_head_current = command__set_outputs__low_head_current__var;
        command__set_outputs__write_fault_reset = command__set_outputs__write_fault_reset__var;
        command__set_outputs__select = command__set_outputs__select__var;
    end //always

    //b command_interface_controller__posedge_clk_active_low_reset_n clock process
        //   
        //       Command interface controller consisting of the input buffer and output buffer
        //       
    always @( posedge clk or negedge reset_n)
    begin : command_interface_controller__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            command_state__busy <= 1'h0;
            command_state__select <= 2'h0;
            command_state__fsm_state <= 6'h0;
            command_state__surface <= 1'h0;
            control__step_time <= 8'h0;
            control__head_settling_time <= 8'h0;
            control__head_load_time <= 4'h0;
            control__head_unload_count <= 4'h0;
            control__drive_0__bad_track_1 <= 8'h0;
            control__drive_1__bad_track_1 <= 8'h0;
            control__drive_0__bad_track_2 <= 8'h0;
            control__drive_1__bad_track_2 <= 8'h0;
            control__drive_0__current_track <= 8'h0;
            control__drive_1__current_track <= 8'h0;
            command_state__special_reg <= 8'h0;
            control__scan__sector <= 8'h0;
            control__scan__msb <= 8'h0;
            control__scan__lsb <= 7'h0;
            control__non_dma_mode <= 1'h0;
            control__double_actuator <= 1'h0;
            result_register__data <= 8'h0;
            internal_disk_ready <= 2'h0;
            command_state__command_track <= 8'h0;
            command_state__command_sector <= 8'h0;
            command_state__command_num_sectors <= 5'h0;
            command_state__command_sector_length <= 3'h0;
        end
        else if (clk__enable)
        begin
            case (command_state__fsm_state) //synopsys parallel_case
            6'h0: // req 1
                begin
                command_state__busy <= 1'h1;
                command_state__select <= command_register__data[7:6];
                case (command_register__data[5:0]) //synopsys parallel_case
                6'h35: // req 1
                    begin
                    command_state__fsm_state <= 6'h1;
                    end
                6'h3d: // req 1
                    begin
                    command_state__fsm_state <= 6'ha;
                    end
                6'h3a: // req 1
                    begin
                    command_state__fsm_state <= 6'h8;
                    end
                6'ha: // req 1
                    begin
                    command_state__fsm_state <= 6'h1d;
                    end
                6'he: // req 1
                    begin
                    command_state__fsm_state <= 6'h1d;
                    end
                6'h1e: // req 1
                    begin
                    command_state__fsm_state <= 6'h1d;
                    end
                6'h12: // req 1
                    begin
                    command_state__fsm_state <= 6'h1d;
                    end
                6'h16: // req 1
                    begin
                    command_state__fsm_state <= 6'h1d;
                    end
                6'hb: // req 1
                    begin
                    command_state__fsm_state <= 6'he;
                    end
                6'hf: // req 1
                    begin
                    command_state__fsm_state <= 6'he;
                    end
                6'h1f: // req 1
                    begin
                    command_state__fsm_state <= 6'he;
                    end
                6'h13: // req 1
                    begin
                    command_state__fsm_state <= 6'he;
                    end
                6'h17: // req 1
                    begin
                    command_state__fsm_state <= 6'he;
                    end
                6'h1b: // req 1
                    begin
                    command_state__fsm_state <= 6'h16;
                    end
                6'h23: // req 1
                    begin
                    command_state__fsm_state <= 6'h24;
                    end
                6'h29: // req 1
                    begin
                    command_state__fsm_state <= 6'hb;
                    end
                6'h2a: // req 1
                    begin
                    command_state__fsm_state <= 6'h28;
                    end
                6'h2c: // req 1
                    begin
                    command_state__fsm_state <= 6'h29;
                    end
                default: // req 1
                    begin
                    command_state__fsm_state <= 6'h0;
                    end
                endcase
                if (!(command_register__full!=1'h0))
                begin
                    command_state__fsm_state <= command_state__fsm_state;
                    command_state__busy <= 1'h0;
                end //if
                end
            6'h1: // req 1
                begin
                command_state__surface <= parameter_register__data[3];
                case (parameter_register__data) //synopsys parallel_case
                8'hd: // req 1
                    begin
                    command_state__fsm_state <= 6'h2;
                    end
                8'h10: // req 1
                    begin
                    command_state__fsm_state <= 6'h5;
                    end
                8'h18: // req 1
                    begin
                    command_state__fsm_state <= 6'h5;
                    end
                default: // req 1
                    begin
                    command_state__fsm_state <= 6'h0;
                    end
                endcase
                if (!(parameter_register__full!=1'h0))
                begin
                    command_state__fsm_state <= command_state__fsm_state;
                end //if
                end
            6'h2: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    control__step_time <= parameter_register__data;
                    command_state__fsm_state <= 6'h3;
                end //if
                end
            6'h3: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    control__head_settling_time <= parameter_register__data;
                    command_state__fsm_state <= 6'h4;
                end //if
                end
            6'h4: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    control__head_load_time <= parameter_register__data[3:0];
                    control__head_unload_count <= parameter_register__data[7:4];
                    command_state__fsm_state <= 6'h25;
                end //if
                end
            6'h5: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    if (!(command_state__select[1]!=1'h0))
                    begin
                        control__drive_0__bad_track_1 <= parameter_register__data;
                    end //if
                    if ((command_state__select[1]!=1'h0))
                    begin
                        control__drive_1__bad_track_1 <= parameter_register__data;
                    end //if
                    command_state__fsm_state <= 6'h6;
                end //if
                end
            6'h6: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    if (!(command_state__select[1]!=1'h0))
                    begin
                        control__drive_0__bad_track_2 <= parameter_register__data;
                    end //if
                    if ((command_state__select[1]!=1'h0))
                    begin
                        control__drive_1__bad_track_2 <= parameter_register__data;
                    end //if
                    command_state__fsm_state <= 6'h7;
                end //if
                end
            6'h7: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    if (!(command_state__select[1]!=1'h0))
                    begin
                        control__drive_0__current_track <= parameter_register__data;
                    end //if
                    if ((command_state__select[1]!=1'h0))
                    begin
                        control__drive_1__current_track <= parameter_register__data;
                    end //if
                    command_state__fsm_state <= 6'h25;
                end //if
                end
            6'h8: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    command_state__special_reg <= parameter_register__data;
                    command_state__fsm_state <= 6'h9;
                end //if
                end
            6'h9: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    case (command_state__special_reg) //synopsys parallel_case
                    8'h6: // req 1
                        begin
                        control__scan__sector <= parameter_register__data;
                        end
                    8'h14: // req 1
                        begin
                        control__scan__msb <= parameter_register__data;
                        end
                    8'h13: // req 1
                        begin
                        control__scan__lsb <= parameter_register__data[6:0];
                        end
                    8'h10: // req 1
                        begin
                        control__drive_0__bad_track_1 <= parameter_register__data;
                        end
                    8'h11: // req 1
                        begin
                        control__drive_0__bad_track_2 <= parameter_register__data;
                        end
                    8'h12: // req 1
                        begin
                        control__drive_0__current_track <= parameter_register__data;
                        end
                    8'h18: // req 1
                        begin
                        control__drive_1__bad_track_1 <= parameter_register__data;
                        end
                    8'h19: // req 1
                        begin
                        control__drive_1__bad_track_2 <= parameter_register__data;
                        end
                    8'h1a: // req 1
                        begin
                        control__drive_1__current_track <= parameter_register__data;
                        end
                    8'h17: // req 1
                        begin
                        control__non_dma_mode <= parameter_register__data[0];
                        control__double_actuator <= parameter_register__data[1];
                        end
                    8'h23: // req 1
                        begin
                        end
                    //synopsys  translate_off
                    //pragma coverage off
                    //synopsys  translate_on
                    default:
                        begin
                        //Need a default case to make Cadence Lint happy, even though this is not a full case
                        end
                    //synopsys  translate_off
                    //pragma coverage on
                    //synopsys  translate_on
                    endcase
                    command_state__fsm_state <= 6'h25;
                end //if
                end
            6'ha: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    case (parameter_register__data) //synopsys parallel_case
                    8'h6: // req 1
                        begin
                        result_register__data <= control__scan__sector;
                        end
                    8'h14: // req 1
                        begin
                        result_register__data <= control__scan__msb;
                        end
                    8'h13: // req 1
                        begin
                        result_register__data <= {1'h0,control__scan__lsb};
                        end
                    8'h10: // req 1
                        begin
                        result_register__data <= control__drive_0__bad_track_1;
                        end
                    8'h11: // req 1
                        begin
                        result_register__data <= control__drive_0__bad_track_2;
                        end
                    8'h12: // req 1
                        begin
                        result_register__data <= control__drive_0__current_track;
                        end
                    8'h18: // req 1
                        begin
                        result_register__data <= control__drive_1__bad_track_1;
                        end
                    8'h19: // req 1
                        begin
                        result_register__data <= control__drive_1__bad_track_2;
                        end
                    8'h1a: // req 1
                        begin
                        result_register__data <= control__drive_1__current_track;
                        end
                    8'h17: // req 1
                        begin
                        result_register__data <= {{6'h30,control__double_actuator},control__non_dma_mode};
                        end
                    8'h22: // req 1
                        begin
                        control__non_dma_mode <= parameter_register__data[0];
                        control__double_actuator <= parameter_register__data[1];
                        end
                    8'h23: // req 1
                        begin
                        control__non_dma_mode <= parameter_register__data[0];
                        control__double_actuator <= parameter_register__data[1];
                        end
                    //synopsys  translate_off
                    //pragma coverage off
                    //synopsys  translate_on
                    default:
                        begin
                        //Need a default case to make Cadence Lint happy, even though this is not a full case
                        end
                    //synopsys  translate_off
                    //pragma coverage on
                    //synopsys  translate_on
                    endcase
                    command_state__fsm_state <= 6'h26;
                end //if
                end
            6'h29: // req 1
                begin
                internal_disk_ready <= ~internal_disk_ready;
                result_register__data <= {{{{{{{1'h0,~internal_disk_ready[1]},1'h0},internal_index},internal_write_protect},~internal_disk_ready[0]},internal_track_0},1'h0};
                command_state__fsm_state <= 6'h26;
                end
            6'hb: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    command_state__command_track <= parameter_register__data;
                    command_state__fsm_state <= 6'hc;
                end //if
                end
            6'hc: // req 1
                begin
                if ((drive_execution__takes_command!=1'h0))
                begin
                    command_state__fsm_state <= 6'hd;
                end //if
                end
            6'hd: // req 1
                begin
                if ((drive_execution__result__valid!=1'h0))
                begin
                    command_state__fsm_state <= 6'h27;
                end //if
                end
            6'h16: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    command_state__command_track <= parameter_register__data;
                    command_state__fsm_state <= 6'h17;
                end //if
                end
            6'h17: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    command_state__fsm_state <= 6'h18;
                end //if
                end
            6'h18: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    control__scan__sector <= parameter_register__data;
                    command_state__fsm_state <= 6'h19;
                end //if
                end
            6'h19: // req 1
                begin
                if ((drive_execution__takes_command!=1'h0))
                begin
                    command_state__fsm_state <= 6'h1a;
                end //if
                end
            6'h1a: // req 1
                begin
                if ((drive_execution__takes_command!=1'h0))
                begin
                    command_state__fsm_state <= 6'h1b;
                end //if
                end
            6'h1b: // req 1
                begin
                if ((control__scan__sector==8'h0))
                begin
                    command_state__fsm_state <= 6'h27;
                end //if
                else
                
                begin
                    if ((drive_execution__takes_command!=1'h0))
                    begin
                        command_state__fsm_state <= 6'h1c;
                    end //if
                end //else
                end
            6'h1c: // req 1
                begin
                if ((drive_execution__result__valid!=1'h0))
                begin
                    control__scan__sector <= (control__scan__sector-8'h1);
                    command_state__fsm_state <= 6'h1b;
                end //if
                end
            6'h1d: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    command_state__command_track <= parameter_register__data;
                    command_state__fsm_state <= 6'h1e;
                end //if
                end
            6'h1e: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    command_state__command_sector <= parameter_register__data;
                    command_state__fsm_state <= 6'h20;
                end //if
                end
            6'h20: // req 1
                begin
                if ((drive_execution__takes_command!=1'h0))
                begin
                    command_state__fsm_state <= 6'h1f;
                end //if
                end
            6'h1f: // req 1
                begin
                if ((drive_execution__takes_command!=1'h0))
                begin
                    command_state__fsm_state <= 6'h21;
                end //if
                end
            6'h21: // req 1
                begin
                if ((drive_execution__result__valid!=1'h0))
                begin
                    command_state__fsm_state <= 6'h22;
                end //if
                end
            6'h22: // req 1
                begin
                if ((drive_execution__takes_command!=1'h0))
                begin
                    command_state__fsm_state <= 6'h23;
                end //if
                end
            6'h23: // req 1
                begin
                if ((drive_execution__result__valid!=1'h0))
                begin
                    command_state__command_sector <= (command_state__command_sector+8'h1);
                    command_state__fsm_state <= 6'h27;
                end //if
                end
            6'he: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    command_state__command_track <= parameter_register__data;
                    command_state__fsm_state <= 6'hf;
                end //if
                end
            6'hf: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    command_state__command_sector <= parameter_register__data;
                    command_state__fsm_state <= 6'h10;
                end //if
                end
            6'h10: // req 1
                begin
                if ((parameter_register__full!=1'h0))
                begin
                    command_state__command_num_sectors <= parameter_register__data[4:0];
                    command_state__command_sector_length <= parameter_register__data[7:5];
                    command_state__fsm_state <= 6'h12;
                end //if
                end
            6'h12: // req 1
                begin
                if ((drive_execution__takes_command!=1'h0))
                begin
                    command_state__fsm_state <= 6'h11;
                end //if
                end
            6'h11: // req 1
                begin
                if ((command_state__command_num_sectors==5'h0))
                begin
                    command_state__fsm_state <= 6'h27;
                end //if
                else
                
                begin
                    if ((drive_execution__takes_command!=1'h0))
                    begin
                        command_state__fsm_state <= 6'h13;
                    end //if
                end //else
                end
            6'h13: // req 1
                begin
                if ((drive_execution__result__valid!=1'h0))
                begin
                    command_state__fsm_state <= 6'h14;
                end //if
                end
            6'h14: // req 1
                begin
                if ((drive_execution__takes_command!=1'h0))
                begin
                    command_state__fsm_state <= 6'h15;
                end //if
                end
            6'h15: // req 1
                begin
                if ((drive_execution__result__valid!=1'h0))
                begin
                    command_state__command_sector <= (command_state__command_sector+8'h1);
                    command_state__command_num_sectors <= (command_state__command_num_sectors-5'h1);
                    command_state__fsm_state <= 6'h11;
                end //if
                end
            6'h25: // req 1
                begin
                command_state__fsm_state <= 6'h0;
                end
            6'h26: // req 1
                begin
                command_state__fsm_state <= 6'h0;
                end
            6'h27: // req 1
                begin
                result_register__data <= {{{{2'h0,1'h0},2'h0},2'h0},1'h0};
                command_state__fsm_state <= 6'h0;
                end
            default: // req 1
                begin
                end
            endcase
            if ((internal_reset!=1'h0))
            begin
                command_state__fsm_state <= 6'h0;
                command_state__busy <= 1'h0;
                command_state__select <= 2'h0;
                command_state__surface <= 1'h0;
                command_state__special_reg <= 8'h0;
                command_state__command_track <= 8'h0;
                command_state__command_sector <= 8'h0;
                command_state__command_num_sectors <= 5'h0;
                command_state__command_sector_length <= 3'h0;
                command_state__fsm_state <= 6'h0;
            end //if
        end //if
    end //always

    //b drive_execution_controller__comb combinatorial process
        //   
        //       Drive step, read, write execution controller
        //   
        //       This is two state machines. The first is the main command
        //       execution controller state machine, and the second is an operation
        //       state machine.
        //   
        //       Idle until a command kicks it off.
        //   
        //       The command indicates what needs to be done:
        //   
        //       * seek track (either to 0, or from current track to target track, skipping bad tracks)
        //       + seek track
        //       + complete
        //   
        //       * format track
        //       + load head
        //       + seek track
        //       + format track
        //       + complete
        //   
        //       * read ids (up to a max number)
        //       + load head
        //       + seek track
        //       + read sector ids
        //       + complete
        //   
        //       * read/read deleted/verify data (inc # sectors)
        //       + load head
        //       + seek track
        //       + seek sector
        //       + read sector as data
        //       + repeat if no error
        //       + complete
        //   
        //       * write data (inc # sectors)
        //       + load head
        //       + seek track
        //       + seek sector
        //       + write sector
        //       + repeat if no error
        //       + complete
        //   
        //       
    always @ ( * )//drive_execution_controller__comb
    begin: drive_execution_controller__comb_code
    reg drive_execution__result__valid__var;
    reg drive_execution__takes_command__var;
        drive_execution__direction_set = 1'h0;
        drive_execution__direction_value = 1'h0;
        drive_execution__result__valid__var = 1'h0;
        drive_execution__takes_command__var = 1'h0;
        case (drive_execution_state__fsm_state) //synopsys parallel_case
        4'h0: // req 1
            begin
            drive_execution__takes_command__var = 1'h1;
            end
        4'h1: // req 1
            begin
            end
        4'h2: // req 1
            begin
            if ((drive_operation__completing_op!=1'h0))
            begin
                drive_execution__result__valid__var = 1'h1;
            end //if
            end
        4'h3: // req 1
            begin
            end
        4'h4: // req 1
            begin
            end
        4'h5: // req 1
            begin
            end
        4'h6: // req 1
            begin
            if ((drive_operation__completing_op!=1'h0))
            begin
                drive_execution__result__valid__var = 1'h1;
            end //if
            end
        4'h9: // req 1
            begin
            end
        4'ha: // req 1
            begin
            if ((drive_operation__completing_op!=1'h0))
            begin
                drive_execution__result__valid__var = 1'h1;
            end //if
            end
        4'h7: // req 1
            begin
            end
        4'h8: // req 1
            begin
            if ((drive_operation__completing_op!=1'h0))
            begin
                drive_execution__result__valid__var = 1'h1;
            end //if
            end
        4'hb: // req 1
            begin
            end
        4'hc: // req 1
            begin
            if ((drive_operation__completing_op!=1'h0))
            begin
                drive_execution__result__valid__var = 1'h1;
            end //if
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:fdc8271:drive_execution_controller: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        drive_execution__result__valid = drive_execution__result__valid__var;
        drive_execution__takes_command = drive_execution__takes_command__var;
    end //always

    //b drive_execution_controller__posedge_clk_active_low_reset_n clock process
        //   
        //       Drive step, read, write execution controller
        //   
        //       This is two state machines. The first is the main command
        //       execution controller state machine, and the second is an operation
        //       state machine.
        //   
        //       Idle until a command kicks it off.
        //   
        //       The command indicates what needs to be done:
        //   
        //       * seek track (either to 0, or from current track to target track, skipping bad tracks)
        //       + seek track
        //       + complete
        //   
        //       * format track
        //       + load head
        //       + seek track
        //       + format track
        //       + complete
        //   
        //       * read ids (up to a max number)
        //       + load head
        //       + seek track
        //       + read sector ids
        //       + complete
        //   
        //       * read/read deleted/verify data (inc # sectors)
        //       + load head
        //       + seek track
        //       + seek sector
        //       + read sector as data
        //       + repeat if no error
        //       + complete
        //   
        //       * write data (inc # sectors)
        //       + load head
        //       + seek track
        //       + seek sector
        //       + write sector
        //       + repeat if no error
        //       + complete
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : drive_execution_controller__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            drive_execution_state__operation <= 3'h0;
            drive_execution_state__fsm_state <= 4'h0;
            drive_execution_state__read_data_valid <= 4'h0;
            drive_execution_state__read_data_buffer <= 32'h0;
        end
        else if (clk__enable)
        begin
            drive_execution_state__operation <= 3'h0;
            case (drive_execution_state__fsm_state) //synopsys parallel_case
            4'h0: // req 1
                begin
                case (command__drive_execution_command) //synopsys parallel_case
                3'h2: // req 1
                    begin
                    drive_execution_state__fsm_state <= 4'h5;
                    drive_execution_state__operation <= 3'h2;
                    end
                3'h3: // req 1
                    begin
                    drive_execution_state__fsm_state <= 4'h3;
                    drive_execution_state__operation <= 3'h4;
                    end
                3'h4: // req 1
                    begin
                    drive_execution_state__fsm_state <= 4'h9;
                    end
                3'h1: // req 1
                    begin
                    drive_execution_state__fsm_state <= 4'h1;
                    drive_execution_state__operation <= 3'h1;
                    end
                3'h5: // req 1
                    begin
                    drive_execution_state__fsm_state <= 4'h7;
                    end
                3'h6: // req 1
                    begin
                    drive_execution_state__fsm_state <= 4'hb;
                    end
                3'h0: // req 1
                    begin
                    drive_execution_state__fsm_state <= 4'h0;
                    end
    //synopsys  translate_off
    //pragma coverage off
                default:
                    begin
                        if (1)
                        begin
                            $display("%t *********CDL ASSERTION FAILURE:fdc8271:drive_execution_controller: Full switch statement did not cover all values", $time);
                        end
                    end
    //pragma coverage on
    //synopsys  translate_on
                endcase
                end
            4'h1: // req 1
                begin
                drive_execution_state__operation <= 3'h1;
                if ((drive_operation__starting_op!=1'h0))
                begin
                    drive_execution_state__fsm_state <= 4'h2;
                    drive_execution_state__operation <= 3'h0;
                end //if
                end
            4'h2: // req 1
                begin
                if ((drive_operation__completing_op!=1'h0))
                begin
                    drive_execution_state__fsm_state <= 4'h0;
                end //if
                end
            4'h3: // req 1
                begin
                drive_execution_state__operation <= 3'h4;
                if ((drive_operation__starting_op!=1'h0))
                begin
                    drive_execution_state__fsm_state <= 4'h4;
                    drive_execution_state__operation <= 3'h0;
                end //if
                end
            4'h4: // req 1
                begin
                if ((drive_operation__completing_op!=1'h0))
                begin
                    drive_execution_state__fsm_state <= 4'h5;
                end //if
                end
            4'h5: // req 1
                begin
                drive_execution_state__operation <= 3'h2;
                if ((drive_operation__starting_op!=1'h0))
                begin
                    drive_execution_state__fsm_state <= 4'h6;
                    drive_execution_state__operation <= 3'h0;
                end //if
                end
            4'h6: // req 1
                begin
                if ((drive_operation__completing_op!=1'h0))
                begin
                    drive_execution_state__fsm_state <= 4'h0;
                end //if
                end
            4'h9: // req 1
                begin
                if ((drive_timing__head_settled!=1'h0))
                begin
                    drive_execution_state__operation <= 3'h5;
                    if ((drive_operation__starting_op!=1'h0))
                    begin
                        drive_execution_state__fsm_state <= 4'ha;
                        drive_execution_state__operation <= 3'h0;
                    end //if
                end //if
                end
            4'ha: // req 1
                begin
                if ((drive_operation__completing_op!=1'h0))
                begin
                    drive_execution_state__fsm_state <= 4'h0;
                end //if
                end
            4'h7: // req 1
                begin
                if ((drive_timing__head_settled!=1'h0))
                begin
                    drive_execution_state__operation <= 3'h3;
                    if ((drive_operation__starting_op!=1'h0))
                    begin
                        drive_execution_state__fsm_state <= 4'h8;
                        drive_execution_state__operation <= 3'h0;
                    end //if
                end //if
                end
            4'h8: // req 1
                begin
                if ((drive_operation__completing_op!=1'h0))
                begin
                    drive_execution_state__fsm_state <= 4'h0;
                end //if
                end
            4'hb: // req 1
                begin
                drive_execution_state__operation <= 3'h6;
                if ((drive_operation__starting_op!=1'h0))
                begin
                    drive_execution_state__fsm_state <= 4'hc;
                    drive_execution_state__operation <= 3'h0;
                end //if
                end
            4'hc: // req 1
                begin
                if ((drive_operation__completing_op!=1'h0))
                begin
                    drive_execution_state__fsm_state <= 4'h0;
                end //if
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:fdc8271:drive_execution_controller: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            if ((read_action==2'h3))
            begin
                drive_execution_state__read_data_valid[0] <= 1'h0;
            end //if
            if (((!(drive_execution_state__read_data_valid[0]!=1'h0)&&(drive_execution_state__read_data_valid[3:1]!=3'h0))&&(drive_timing__data_byte_ready!=1'h0)))
            begin
                drive_execution_state__read_data_buffer <= {8'h0,drive_execution_state__read_data_buffer[31:8]};
                drive_execution_state__read_data_valid <= {1'h0,drive_execution_state__read_data_valid[3:1]};
            end //if
            if ((drive_operation__read_data_capture_data!=1'h0))
            begin
                drive_execution_state__read_data_buffer <= drive_operation_state__read_data_buffer;
                drive_execution_state__read_data_valid <= 4'hf;
            end //if
            if ((drive_operation__read_data_capture_id!=1'h0))
            begin
                drive_execution_state__read_data_buffer <= {{{{{{{6'h0,drive_operation_state__sector_id__sector_length},2'h0},drive_operation_state__sector_id__sector_number},7'h0},drive_operation_state__sector_id__head},1'h0},drive_operation_state__sector_id__track};
                drive_execution_state__read_data_valid <= 4'hf;
                if ((drive_operation_state__sector_id__bad_crc!=1'h0))
                begin
                    drive_execution_state__read_data_valid <= 4'h0;
                end //if
            end //if
            if ((internal_reset!=1'h0))
            begin
                drive_execution_state__fsm_state <= 4'h0;
                drive_execution_state__operation <= 3'h0;
                drive_execution_state__read_data_buffer <= 32'h0;
                drive_execution_state__read_data_valid <= 4'h0;
                drive_execution_state__fsm_state <= 4'h0;
            end //if
        end //if
    end //always

    //b drive_operation_controller__comb combinatorial process
        //   
        //       Drive operation controller
        //   
        //       Idle until an operation is kicked off.
        //   
        //       A seek track zero must:
        //       a. retry_count <= 255
        //       b. If track0, then complete
        //       c. set direction=0 (out) (wait 10us if changed)
        //       d. retry_count==0 => error "track 0 not found" (10.10)
        //       e. step
        //       f. retry_count--, repeat a 
        //   
        //       A seek track nonzero must:
        //       a. if track>bad_track_1, track++
        //       b. if track>bad_track_2, track++
        //       c. retry_count=(track-current_track)
        //       d. set direction=retry_count[7]
        //       e. retry_count==0 => complete
        //       f. step
        //       g. retry_count-- (or ++), repeat e
        //   
        //       A load head operation must:
        //       a. load the head (if not loaded)
        //   
        //       A seek sector operation must
        //       a. track_steps = 2
        //       b. retry_count <= 32
        //       c. retry count==0 => error "sector not found" (11.00)
        //       d. read the next (valid) id
        //       e. if id has crc error, then error "id field crc error" (01.10)
        //       f. if id indicates different track and track_steps==0, then error "sector not found" (11.00)
        //       g. if id indicates different track and track_steps==1, then track_steps--, step with direction, and repeat a
        //       h. id indicates correct track and correct sector => complete
        //       i. retry_count--, repeat c
        //   
        //       A read id operation must
        //       a. clear index pulse seen
        //       b. wait for index pulse seen
        //       c. clear index pulse seen
        //       d. read the next (valid) id
        //       e. if index pulse seen => complete
        //       f. if id has crc error, then error "id field crc error" (01.10)
        //       g. present track number to host; head number; sector number; sector length to host (possibly error if data full)
        //       h. repeat d
        //   
        //       A format track operation must
        //       a. retry_count = sectors per track (parameter)
        //       b. clear index pulse seen
        //       c. wait for index pulse seen
        //       d. retry_count==0 => complete
        //       e. get sector id from host (possibly error if data empty)
        //       f. write sector id
        //       g. retry_count--
        //       h. repeat d
        //   
        //       A read sector operation (which must be straight after a seek sector operation) must
        //       a. sector byte <= N.127 (i.e. set bottom bits from held id)
        //       b. read data byte to read data buffer (unless id says deleted and normal data read - but set 'deleted' in result - or if verify)
        //       c. read data buffer full => error "Late DMA ()"
        //       d. sector byte==0.0 and data id crc bad => error "data field crc error" (01.11)
        //       e. sector byte==0.0 => sector complete => op complete
        //       f. sector byte--, repeat c
        //   
        //       A write sector operation (which must be straight after a seek sector operation) must
        //       a. Held sector data id crc bad => error "data field crc error" (01.11)
        //       b. sector byte <= N.127
        //       c. request write data
        //       d. write data buffer empty => error "Late DMA" (01.01) (and the sector id should get a bad data)
        //       e. write data byte from write data buffer
        //       f. sector byte==0.0 => sector complete => complete (and the sector di should get a good crc, and possibly indicate deleted data)
        //       g. sector byte--, repeat c
        //   
        //       
    always @ ( * )//drive_operation_controller__comb
    begin: drive_operation_controller__comb_code
    reg drive_operation__direction_set__var;
    reg drive_operation__direction_value__var;
    reg drive_operation__step_start__var;
    reg drive_operation__load_head__var;
    reg drive_operation__starting_op__var;
    reg drive_operation__completing_op__var;
    reg drive_operation__read_id__var;
    reg drive_operation__read_data__var;
    reg drive_operation__capture_id__var;
    reg drive_operation__capture_data__var;
    reg drive_operation__read_data_capture_id__var;
    reg drive_operation__read_data_capture_data__var;
        drive_operation__direction_set__var = 1'h0;
        drive_operation__direction_value__var = 1'h0;
        drive_operation__step_start__var = 1'h0;
        drive_operation__load_head__var = 1'h0;
        drive_operation__starting_op__var = 1'h0;
        drive_operation__completing_op__var = 1'h0;
        drive_operation__read_id__var = 1'h0;
        drive_operation__read_data__var = 1'h0;
        drive_operation__capture_id__var = 1'h0;
        drive_operation__capture_data__var = 1'h0;
        drive_operation__read_data_capture_id__var = 1'h0;
        drive_operation__read_data_capture_data__var = 1'h0;
        case (drive_operation_state__fsm_state) //synopsys parallel_case
        5'h0: // req 1
            begin
            drive_operation__starting_op__var = 1'h1;
            case (drive_execution_state__operation) //synopsys parallel_case
            3'h2: // req 1
                begin
                end
            3'h4: // req 1
                begin
                end
            3'h5: // req 1
                begin
                end
            3'h3: // req 1
                begin
                end
            3'h6: // req 1
                begin
                end
            3'h1: // req 1
                begin
                end
            3'h0: // req 1
                begin
                drive_operation__starting_op__var = 1'h0;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:fdc8271:drive_operation_controller: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            end
        5'h3: // req 1
            begin
            if ((internal_track_0!=1'h0))
            begin
            end //if
            else
            
            begin
                drive_operation__direction_set__var = 1'h1;
                drive_operation__direction_value__var = 1'h0;
            end //else
            end
        5'h4: // req 1
            begin
            drive_operation__step_start__var = 1'h1;
            end
        5'h5: // req 1
            begin
            end
        5'h6: // req 1
            begin
            end
        5'h7: // req 1
            begin
            end
        5'h8: // req 1
            begin
            end
        5'h9: // req 1
            begin
            drive_operation__direction_set__var = 1'h1;
            drive_operation__direction_value__var = !(drive_operation_state__retry_count[7]!=1'h0);
            end
        5'ha: // req 1
            begin
            if ((drive_operation_state__retry_count==8'h0))
            begin
            end //if
            else
            
            begin
                drive_operation__step_start__var = 1'h1;
            end //else
            end
        5'hd: // req 1
            begin
            drive_operation__load_head__var = 1'h1;
            end
        5'he: // req 1
            begin
            drive_operation__read_id__var = 1'h1;
            if ((internal_id_ready!=1'h0))
            begin
                drive_operation__capture_id__var = 1'h1;
            end //if
            end
        5'hf: // req 1
            begin
            if ((drive_operation_state__sector_id__bad_crc!=1'h0))
            begin
            end //if
            else
            
            begin
                if ((drive_timing__data_byte_ready!=1'h0))
                begin
                    drive_operation__read_data_capture_id__var = 1'h1;
                end //if
            end //else
            end
        5'h13: // req 1
            begin
            end
        5'hb: // req 1
            begin
            drive_operation__read_id__var = 1'h1;
            if ((internal_id_ready!=1'h0))
            begin
                drive_operation__capture_id__var = 1'h1;
            end //if
            end
        5'hc: // req 1
            begin
            end
        5'h10: // req 1
            begin
            if ((drive_operation_state__sector_id__bad_data_crc!=1'h0))
            begin
            end //if
            else
            
            begin
                drive_operation__read_data__var = 1'h1;
                if ((internal_read_data_valid!=1'h0))
                begin
                    drive_operation__capture_data__var = 1'h1;
                end //if
            end //else
            end
        5'h11: // req 1
            begin
            if ((drive_timing__data_byte_ready!=1'h0))
            begin
                drive_operation__read_data_capture_data__var = 1'h1;
            end //if
            end
        5'h12: // req 1
            begin
            end
        5'h14: // req 1
            begin
            if ((internal_index!=1'h0))
            begin
            end //if
            else
            
            begin
                drive_operation__read_id__var = 1'h1;
            end //else
            end
        5'h15: // req 1
            begin
            end
        5'h1: // req 1
            begin
            drive_operation__completing_op__var = 1'h1;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:fdc8271:drive_operation_controller: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        drive_operation__direction_set = drive_operation__direction_set__var;
        drive_operation__direction_value = drive_operation__direction_value__var;
        drive_operation__step_start = drive_operation__step_start__var;
        drive_operation__load_head = drive_operation__load_head__var;
        drive_operation__starting_op = drive_operation__starting_op__var;
        drive_operation__completing_op = drive_operation__completing_op__var;
        drive_operation__read_id = drive_operation__read_id__var;
        drive_operation__read_data = drive_operation__read_data__var;
        drive_operation__capture_id = drive_operation__capture_id__var;
        drive_operation__capture_data = drive_operation__capture_data__var;
        drive_operation__read_data_capture_id = drive_operation__read_data_capture_id__var;
        drive_operation__read_data_capture_data = drive_operation__read_data_capture_data__var;
    end //always

    //b drive_operation_controller__posedge_clk_active_low_reset_n clock process
        //   
        //       Drive operation controller
        //   
        //       Idle until an operation is kicked off.
        //   
        //       A seek track zero must:
        //       a. retry_count <= 255
        //       b. If track0, then complete
        //       c. set direction=0 (out) (wait 10us if changed)
        //       d. retry_count==0 => error "track 0 not found" (10.10)
        //       e. step
        //       f. retry_count--, repeat a 
        //   
        //       A seek track nonzero must:
        //       a. if track>bad_track_1, track++
        //       b. if track>bad_track_2, track++
        //       c. retry_count=(track-current_track)
        //       d. set direction=retry_count[7]
        //       e. retry_count==0 => complete
        //       f. step
        //       g. retry_count-- (or ++), repeat e
        //   
        //       A load head operation must:
        //       a. load the head (if not loaded)
        //   
        //       A seek sector operation must
        //       a. track_steps = 2
        //       b. retry_count <= 32
        //       c. retry count==0 => error "sector not found" (11.00)
        //       d. read the next (valid) id
        //       e. if id has crc error, then error "id field crc error" (01.10)
        //       f. if id indicates different track and track_steps==0, then error "sector not found" (11.00)
        //       g. if id indicates different track and track_steps==1, then track_steps--, step with direction, and repeat a
        //       h. id indicates correct track and correct sector => complete
        //       i. retry_count--, repeat c
        //   
        //       A read id operation must
        //       a. clear index pulse seen
        //       b. wait for index pulse seen
        //       c. clear index pulse seen
        //       d. read the next (valid) id
        //       e. if index pulse seen => complete
        //       f. if id has crc error, then error "id field crc error" (01.10)
        //       g. present track number to host; head number; sector number; sector length to host (possibly error if data full)
        //       h. repeat d
        //   
        //       A format track operation must
        //       a. retry_count = sectors per track (parameter)
        //       b. clear index pulse seen
        //       c. wait for index pulse seen
        //       d. retry_count==0 => complete
        //       e. get sector id from host (possibly error if data empty)
        //       f. write sector id
        //       g. retry_count--
        //       h. repeat d
        //   
        //       A read sector operation (which must be straight after a seek sector operation) must
        //       a. sector byte <= N.127 (i.e. set bottom bits from held id)
        //       b. read data byte to read data buffer (unless id says deleted and normal data read - but set 'deleted' in result - or if verify)
        //       c. read data buffer full => error "Late DMA ()"
        //       d. sector byte==0.0 and data id crc bad => error "data field crc error" (01.11)
        //       e. sector byte==0.0 => sector complete => op complete
        //       f. sector byte--, repeat c
        //   
        //       A write sector operation (which must be straight after a seek sector operation) must
        //       a. Held sector data id crc bad => error "data field crc error" (01.11)
        //       b. sector byte <= N.127
        //       c. request write data
        //       d. write data buffer empty => error "Late DMA" (01.01) (and the sector id should get a bad data)
        //       e. write data byte from write data buffer
        //       f. sector byte==0.0 => sector complete => complete (and the sector di should get a good crc, and possibly indicate deleted data)
        //       g. sector byte--, repeat c
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : drive_operation_controller__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            drive_operation_state__retry_count <= 8'h0;
            drive_operation_state__fsm_state <= 5'h0;
            drive_operation_state__words_remaining <= 8'h0;
            drive_operation_state__current_track <= 8'h0;
            drive_operation_state__sector_id__track <= 7'h0;
            drive_operation_state__sector_id__head <= 1'h0;
            drive_operation_state__sector_id__sector_number <= 6'h0;
            drive_operation_state__sector_id__sector_length <= 2'h0;
            drive_operation_state__sector_id__bad_crc <= 1'h0;
            drive_operation_state__sector_id__bad_data_crc <= 1'h0;
            drive_operation_state__sector_id__deleted_data <= 1'h0;
            drive_operation_state__read_data_buffer <= 32'h0;
        end
        else if (clk__enable)
        begin
            case (drive_operation_state__fsm_state) //synopsys parallel_case
            5'h0: // req 1
                begin
                case (drive_execution_state__operation) //synopsys parallel_case
                3'h2: // req 1
                    begin
                    if ((command_state__command_track==8'h0))
                    begin
                        drive_operation_state__retry_count <= 8'hff;
                        drive_operation_state__fsm_state <= 5'h3;
                    end //if
                    else
                    
                    begin
                        drive_operation_state__retry_count <= command_state__command_track;
                        drive_operation_state__fsm_state <= 5'h6;
                    end //else
                    end
                3'h4: // req 1
                    begin
                    drive_operation_state__fsm_state <= 5'hd;
                    end
                3'h5: // req 1
                    begin
                    drive_operation_state__fsm_state <= 5'he;
                    end
                3'h3: // req 1
                    begin
                    drive_operation_state__retry_count <= 8'h3;
                    drive_operation_state__fsm_state <= 5'hb;
                    end
                3'h6: // req 1
                    begin
                    drive_operation_state__words_remaining <= 8'h40;
                    drive_operation_state__fsm_state <= 5'h10;
                    end
                3'h1: // req 1
                    begin
                    drive_operation_state__fsm_state <= 5'h14;
                    end
                3'h0: // req 1
                    begin
                    end
    //synopsys  translate_off
    //pragma coverage off
                default:
                    begin
                        if (1)
                        begin
                            $display("%t *********CDL ASSERTION FAILURE:fdc8271:drive_operation_controller: Full switch statement did not cover all values", $time);
                        end
                    end
    //pragma coverage on
    //synopsys  translate_on
                endcase
                end
            5'h3: // req 1
                begin
                drive_operation_state__current_track <= 8'h0;
                if ((internal_track_0!=1'h0))
                begin
                    drive_operation_state__fsm_state <= 5'h1;
                end //if
                else
                
                begin
                    if ((drive_timing_state__direction_setting!=1'h0))
                    begin
                        drive_operation_state__fsm_state <= 5'h4;
                    end //if
                end //else
                end
            5'h4: // req 1
                begin
                if ((drive_timing_state__step_setting!=1'h0))
                begin
                    drive_operation_state__fsm_state <= 5'h5;
                end //if
                end
            5'h5: // req 1
                begin
                if ((drive_timing__step_settled!=1'h0))
                begin
                    if ((internal_track_0!=1'h0))
                    begin
                        drive_operation_state__fsm_state <= 5'h1;
                    end //if
                    else
                    
                    begin
                        if ((drive_operation_state__retry_count==8'h0))
                        begin
                            drive_operation_state__fsm_state <= 5'h2;
                        end //if
                        else
                        
                        begin
                            drive_operation_state__retry_count <= (drive_operation_state__retry_count-8'h1);
                            drive_operation_state__fsm_state <= 5'h3;
                        end //else
                    end //else
                end //if
                end
            5'h6: // req 1
                begin
                if ((drive_operation_state__retry_count>=control__drive_0__bad_track_1))
                begin
                    drive_operation_state__retry_count <= (drive_operation_state__retry_count+8'h1);
                end //if
                drive_operation_state__fsm_state <= 5'h7;
                end
            5'h7: // req 1
                begin
                if ((drive_operation_state__retry_count>=control__drive_0__bad_track_2))
                begin
                    drive_operation_state__retry_count <= (drive_operation_state__retry_count+8'h1);
                end //if
                drive_operation_state__fsm_state <= 5'h8;
                end
            5'h8: // req 1
                begin
                drive_operation_state__retry_count <= (drive_operation_state__retry_count-drive_operation_state__current_track);
                drive_operation_state__current_track <= drive_operation_state__retry_count;
                drive_operation_state__fsm_state <= 5'h9;
                end
            5'h9: // req 1
                begin
                if ((drive_timing_state__direction_setting!=1'h0))
                begin
                    drive_operation_state__fsm_state <= 5'ha;
                    if ((drive_operation_state__retry_count[7]!=1'h0))
                    begin
                        drive_operation_state__retry_count <= -drive_operation_state__retry_count;
                    end //if
                end //if
                end
            5'ha: // req 1
                begin
                if ((drive_operation_state__retry_count==8'h0))
                begin
                    drive_operation_state__fsm_state <= 5'h1;
                end //if
                else
                
                begin
                    if ((drive_timing_state__step_setting!=1'h0))
                    begin
                        drive_operation_state__retry_count <= (drive_operation_state__retry_count-8'h1);
                    end //if
                end //else
                end
            5'hd: // req 1
                begin
                if ((drive_timing_state__loading_head!=1'h0))
                begin
                    drive_operation_state__fsm_state <= 5'h1;
                end //if
                end
            5'he: // req 1
                begin
                if ((internal_id_ready!=1'h0))
                begin
                    drive_operation_state__fsm_state <= 5'hf;
                end //if
                end
            5'hf: // req 1
                begin
                if ((drive_operation_state__sector_id__bad_crc!=1'h0))
                begin
                    drive_operation_state__fsm_state <= 5'h1;
                end //if
                else
                
                begin
                    if ((drive_timing__data_byte_ready!=1'h0))
                    begin
                        drive_operation_state__fsm_state <= 5'h13;
                    end //if
                end //else
                end
            5'h13: // req 1
                begin
                if ((drive_execution_state__read_data_valid==4'h0))
                begin
                    drive_operation_state__fsm_state <= 5'h1;
                end //if
                end
            5'hb: // req 1
                begin
                if ((internal_id_ready!=1'h0))
                begin
                    drive_operation_state__fsm_state <= 5'hc;
                end //if
                end
            5'hc: // req 1
                begin
                if (((drive_operation_state__sector_id__track==command_state__command_track[6:0])&&(drive_operation_state__sector_id__sector_number==command_state__command_sector[5:0])))
                begin
                    drive_operation_state__fsm_state <= 5'h1;
                end //if
                else
                
                begin
                    drive_operation_state__fsm_state <= 5'hb;
                    if ((internal_index!=1'h0))
                    begin
                        drive_operation_state__retry_count <= (drive_operation_state__retry_count-8'h1);
                    end //if
                    if ((drive_operation_state__retry_count==8'h0))
                    begin
                        drive_operation_state__fsm_state <= 5'h1;
                    end //if
                end //else
                if ((drive_operation_state__sector_id__bad_crc!=1'h0))
                begin
                    drive_operation_state__fsm_state <= 5'h1;
                end //if
                end
            5'h10: // req 1
                begin
                if ((drive_operation_state__sector_id__bad_data_crc!=1'h0))
                begin
                    drive_operation_state__fsm_state <= 5'h1;
                end //if
                else
                
                begin
                    if ((internal_read_data_valid!=1'h0))
                    begin
                        drive_operation_state__fsm_state <= 5'h11;
                    end //if
                end //else
                end
            5'h11: // req 1
                begin
                if ((drive_timing__data_byte_ready!=1'h0))
                begin
                    drive_operation_state__fsm_state <= 5'h12;
                    drive_operation_state__words_remaining <= (drive_operation_state__words_remaining-8'h1);
                end //if
                end
            5'h12: // req 1
                begin
                if ((drive_execution_state__read_data_valid==4'h0))
                begin
                    drive_operation_state__fsm_state <= 5'h10;
                    if ((drive_operation_state__words_remaining==8'h0))
                    begin
                        drive_operation_state__fsm_state <= 5'h1;
                    end //if
                end //if
                end
            5'h14: // req 1
                begin
                if ((internal_index!=1'h0))
                begin
                    drive_operation_state__fsm_state <= 5'h1;
                end //if
                else
                
                begin
                    if ((internal_id_ready!=1'h0))
                    begin
                        drive_operation_state__fsm_state <= 5'h15;
                    end //if
                end //else
                end
            5'h15: // req 1
                begin
                drive_operation_state__fsm_state <= 5'h14;
                end
            5'h1: // req 1
                begin
                drive_operation_state__fsm_state <= 5'h0;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:fdc8271:drive_operation_controller: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            if ((drive_operation__capture_id!=1'h0))
            begin
                drive_operation_state__sector_id__track <= bbc_floppy_response__sector_id__track;
                drive_operation_state__sector_id__head <= bbc_floppy_response__sector_id__head;
                drive_operation_state__sector_id__sector_number <= bbc_floppy_response__sector_id__sector_number;
                drive_operation_state__sector_id__sector_length <= bbc_floppy_response__sector_id__sector_length;
                drive_operation_state__sector_id__bad_crc <= bbc_floppy_response__sector_id__bad_crc;
                drive_operation_state__sector_id__bad_data_crc <= bbc_floppy_response__sector_id__bad_data_crc;
                drive_operation_state__sector_id__deleted_data <= bbc_floppy_response__sector_id__deleted_data;
            end //if
            if ((drive_operation__capture_data!=1'h0))
            begin
                drive_operation_state__read_data_buffer <= bbc_floppy_response__read_data;
            end //if
        end //if
    end //always

    //b drive_control_timings__comb combinatorial process
        //   
        //       The drive controls have specific timing constraints, and this logic manages that.
        //   
        //       The direction pin has 10us setup to 'step' rising and 10us hold on 'step' falling
        //   
        //       The step pin (in pulse mode) has a 10us high period, and the step
        //       has a configurable settling time (in 1ms increments)
        //   
        //       The head may not be used (for reading or writing) until a
        //       configurable number of 4ms ticks after the step settling time.
        //       
    always @ ( * )//drive_control_timings__comb
    begin: drive_control_timings__comb_code
    reg drive_timing__direction_can_be_set__var;
    reg drive_timing__step_can_start__var;
    reg drive_timing__time_10us_start__var;
    reg drive_timing__time_1ms_restart__var;
        drive_timing__step_timer_1ms = control__step_time;
        drive_timing__head_timer_4ms = control__head_settling_time;
        drive_timing__time_10us_completed = (drive_timing_state__timer_10us==5'h0);
        drive_timing__time_1ms_tick = (drive_timing_state__timer_1ms==12'h0);
        drive_timing__direction_can_be_set__var = 1'h0;
        drive_timing__step_can_start__var = 1'h0;
        if ((drive_timing__time_10us_completed!=1'h0))
        begin
            drive_timing__direction_can_be_set__var = !(drive_outputs__step!=1'h0);
            drive_timing__step_can_start__var = (drive_timing_state__step_counter==8'h0);
        end //if
        drive_timing__step_in_progress = (drive_timing_state__step_counter!=8'h0);
        drive_timing__step_settled = (drive_timing_state__step_counter==8'h0);
        drive_timing__head_settled = ((drive_timing_state__head_counter==10'h0)&&!(drive_timing__step_in_progress!=1'h0));
        drive_timing__data_byte_ready = (drive_timing_state__timer_data==8'h0);
        drive_timing__time_10us_start__var = 1'h0;
        drive_timing__time_1ms_restart__var = 1'h0;
        if ((drive_operation__direction_set!=1'h0))
        begin
            if ((drive_operation__direction_value==drive_outputs__direction))
            begin
            end //if
            else
            
            begin
                if ((drive_timing__direction_can_be_set__var!=1'h0))
                begin
                    drive_timing__time_10us_start__var = 1'h1;
                end //if
            end //else
        end //if
        if (((drive_operation__step_start!=1'h0)&&(drive_timing__step_can_start__var!=1'h0)))
        begin
            drive_timing__time_10us_start__var = 1'h1;
            drive_timing__time_1ms_restart__var = 1'h1;
        end //if
        if (((drive_outputs__step!=1'h0)&&(drive_timing__time_10us_completed!=1'h0)))
        begin
            drive_timing__time_10us_start__var = 1'h1;
        end //if
        low_current = drive_outputs__low_current;
        load_head = drive_outputs__load_head;
        direction = drive_outputs__direction;
        seek_step = drive_outputs__step;
        write_enable = drive_outputs__write_enable;
        fault_reset = drive_outputs__fault_reset;
        select = drive_outputs__select;
        drive_timing__direction_can_be_set = drive_timing__direction_can_be_set__var;
        drive_timing__step_can_start = drive_timing__step_can_start__var;
        drive_timing__time_10us_start = drive_timing__time_10us_start__var;
        drive_timing__time_1ms_restart = drive_timing__time_1ms_restart__var;
    end //always

    //b drive_control_timings__posedge_clk_active_low_reset_n clock process
        //   
        //       The drive controls have specific timing constraints, and this logic manages that.
        //   
        //       The direction pin has 10us setup to 'step' rising and 10us hold on 'step' falling
        //   
        //       The step pin (in pulse mode) has a 10us high period, and the step
        //       has a configurable settling time (in 1ms increments)
        //   
        //       The head may not be used (for reading or writing) until a
        //       configurable number of 4ms ticks after the step settling time.
        //       
    always @( posedge clk or negedge reset_n)
    begin : drive_control_timings__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            drive_timing_state__direction_setting <= 1'h0;
            drive_outputs__direction <= 1'h0;
            drive_timing_state__step_setting <= 1'h0;
            drive_timing_state__step_counter <= 8'h0;
            drive_outputs__step <= 1'h0;
            drive_timing_state__loading_head <= 1'h0;
            drive_timing_state__head_counter <= 10'h0;
            drive_outputs__load_head <= 1'h0;
            drive_timing_state__timer_data <= 8'h0;
            drive_timing_state__timer_10us <= 5'h0;
            drive_timing_state__timer_1ms <= 12'h0;
            drive_outputs__low_current <= 1'h0;
            drive_outputs__write_enable <= 1'h0;
            drive_outputs__fault_reset <= 1'h0;
            drive_outputs__select <= 2'h0;
        end
        else if (clk__enable)
        begin
            drive_timing_state__direction_setting <= 1'h0;
            if ((drive_operation__direction_set!=1'h0))
            begin
                if ((drive_operation__direction_value==drive_outputs__direction))
                begin
                    drive_timing_state__direction_setting <= 1'h1;
                end //if
                else
                
                begin
                    if ((drive_timing__direction_can_be_set!=1'h0))
                    begin
                        drive_timing_state__direction_setting <= 1'h1;
                        drive_outputs__direction <= drive_operation__direction_value;
                    end //if
                end //else
            end //if
            drive_timing_state__step_setting <= 1'h0;
            if (((drive_timing__time_1ms_tick!=1'h0)&&(drive_timing_state__step_counter!=8'h0)))
            begin
                drive_timing_state__step_counter <= (drive_timing_state__step_counter-8'h1);
            end //if
            if (((drive_operation__step_start!=1'h0)&&(drive_timing__step_can_start!=1'h0)))
            begin
                drive_timing_state__step_setting <= 1'h1;
                drive_outputs__step <= 1'h1;
                drive_timing_state__step_counter <= drive_timing__step_timer_1ms;
            end //if
            if (((drive_outputs__step!=1'h0)&&(drive_timing__time_10us_completed!=1'h0)))
            begin
                drive_outputs__step <= 1'h0;
            end //if
            drive_timing_state__loading_head <= 1'h0;
            if (((drive_timing__time_1ms_tick!=1'h0)&&(drive_timing_state__head_counter!=10'h0)))
            begin
                drive_timing_state__head_counter <= (drive_timing_state__head_counter-10'h1);
            end //if
            if ((drive_operation__load_head!=1'h0))
            begin
                if (!(drive_outputs__load_head!=1'h0))
                begin
                    drive_outputs__load_head <= 1'h1;
                    drive_timing_state__head_counter <= {drive_timing__head_timer_4ms,2'h0};
                end //if
                drive_timing_state__loading_head <= 1'h1;
            end //if
            if ((drive_timing__step_in_progress!=1'h0))
            begin
                drive_timing_state__head_counter <= {drive_timing__head_timer_4ms,2'h0};
            end //if
            if ((drive_timing_state__timer_data==8'h0))
            begin
                drive_timing_state__timer_data <= 8'h80;
            end //if
            else
            
            begin
                drive_timing_state__timer_data <= (drive_timing_state__timer_data-8'h1);
            end //else
            if ((drive_timing__time_10us_start!=1'h0))
            begin
                drive_timing_state__timer_10us <= 5'h2;
            end //if
            else
            
            begin
                if ((drive_timing_state__timer_10us!=5'h0))
                begin
                    drive_timing_state__timer_10us <= (drive_timing_state__timer_10us-5'h1);
                end //if
            end //else
            if ((drive_timing__time_1ms_restart!=1'h0))
            begin
                drive_timing_state__timer_1ms <= 12'h8;
            end //if
            else
            
            begin
                if ((drive_timing_state__timer_1ms==12'h0))
                begin
                    drive_timing_state__timer_1ms <= 12'h8;
                end //if
                else
                
                begin
                    drive_timing_state__timer_1ms <= (drive_timing_state__timer_1ms-12'h1);
                end //else
            end //else
            if ((command__set_outputs__valid!=1'h0))
            begin
                drive_outputs__low_current <= command__set_outputs__low_head_current;
                drive_outputs__load_head <= command__set_outputs__load_head;
                drive_outputs__step <= command__set_outputs__seek_step;
                drive_outputs__write_enable <= command__set_outputs__write_enable;
                drive_outputs__fault_reset <= command__set_outputs__write_fault_reset;
                drive_outputs__select <= command__set_outputs__select;
            end //if
            if ((internal_reset!=1'h0))
            begin
                drive_timing_state__timer_data <= 8'h0;
                drive_timing_state__timer_10us <= 5'h0;
                drive_timing_state__direction_setting <= 1'h0;
                drive_timing_state__step_setting <= 1'h0;
                drive_timing_state__loading_head <= 1'h0;
                drive_timing_state__timer_1ms <= 12'h0;
                drive_timing_state__step_counter <= 8'h0;
                drive_timing_state__head_counter <= 10'h0;
            end //if
        end //if
    end //always

    //b bbc_drive_interface__comb combinatorial process
        //   
        //       
    always @ ( * )//bbc_drive_interface__comb
    begin: bbc_drive_interface__comb_code
        internal_read_data_valid = bbc_floppy_response__read_data_valid;
        internal_index = bbc_floppy_response__index;
        internal_write_protect = bbc_floppy_response__write_protect;
        internal_track_0 = bbc_floppy_response__track_zero;
        internal_id_ready = bbc_floppy_response__sector_id_valid;
    end //always

    //b bbc_drive_interface__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : bbc_drive_interface__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            bbc_floppy_op__step_out <= 1'h0;
            bbc_floppy_op__step_in <= 1'h0;
            bbc_floppy_op__next_id <= 1'h0;
            bbc_floppy_op__read_data_enable <= 1'h0;
            bbc_floppy_op__write_data_enable <= 1'h0;
            bbc_floppy_op__write_data <= 32'h0;
            bbc_floppy_op__write_sector_id_enable <= 1'h0;
            bbc_floppy_op__sector_id__track <= 7'h0;
            bbc_floppy_op__sector_id__head <= 1'h0;
            bbc_floppy_op__sector_id__sector_number <= 6'h0;
            bbc_floppy_op__sector_id__sector_length <= 2'h0;
            bbc_floppy_op__sector_id__bad_crc <= 1'h0;
            bbc_floppy_op__sector_id__bad_data_crc <= 1'h0;
            bbc_floppy_op__sector_id__deleted_data <= 1'h0;
        end
        else if (clk__enable)
        begin
            bbc_floppy_op__step_out <= ((drive_outputs__step!=1'h0)&&!(drive_outputs__direction!=1'h0));
            bbc_floppy_op__step_in <= ((drive_outputs__step!=1'h0)&&(drive_outputs__direction!=1'h0));
            if ((drive_operation__read_id!=1'h0))
            begin
                bbc_floppy_op__next_id <= 1'h1;
            end //if
            if ((bbc_floppy_response__sector_id_valid!=1'h0))
            begin
                bbc_floppy_op__next_id <= 1'h0;
            end //if
            if ((drive_operation__read_data!=1'h0))
            begin
                bbc_floppy_op__read_data_enable <= 1'h1;
            end //if
            if ((bbc_floppy_response__read_data_valid!=1'h0))
            begin
                bbc_floppy_op__read_data_enable <= 1'h0;
            end //if
            bbc_floppy_op__write_data_enable <= 1'h0;
            bbc_floppy_op__write_data <= 32'h0;
            bbc_floppy_op__write_sector_id_enable <= 1'h0;
            bbc_floppy_op__sector_id__track <= 7'h0;
            bbc_floppy_op__sector_id__head <= 1'h0;
            bbc_floppy_op__sector_id__sector_number <= 6'h0;
            bbc_floppy_op__sector_id__sector_length <= 2'h0;
            bbc_floppy_op__sector_id__bad_crc <= 1'h0;
            bbc_floppy_op__sector_id__bad_data_crc <= 1'h0;
            bbc_floppy_op__sector_id__deleted_data <= 1'h0;
        end //if
    end //always

endmodule // fdc8271
