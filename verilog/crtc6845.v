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

//a Module crtc6845
    //   
    //   This is an implementation of the Motorola 6845 CRTC, which was used
    //   in the BBC microcomputer for sync and video memory address
    //   generation.
    //   
module crtc6845
(
    clk_1MHz,
    clk_1MHz__enable,
    clk_2MHz,
    clk_2MHz__enable,

    crtc_clock_enable,
    lpstb_n,
    data_in,
    rs,
    chip_select_n,
    read_not_write,
    reset_n,

    vsync,
    hsync,
    cursor,
    de,
    data_out,
    ra,
    ma
);

    //b Clocks
        //   Clock that rises when the 'enable' of the 6845 completes - but a real clock for this model - used for the CPU interface
    input clk_1MHz;
    input clk_1MHz__enable;
        //   2MHz clock that runs the memory interface and video sync output
    input clk_2MHz;
    input clk_2MHz__enable;

    //b Inputs
        //   An enable for clk_2MHz for the character clock - on the real chip this is actually a clock
    input crtc_clock_enable;
        //   Light pen strobe input, used to capture the memory address of the display when the CRT passes it; not much use nowadays
    input lpstb_n;
        //   Data in (from CPU) for writing
    input [7:0]data_in;
        //   Register select - address line really
    input rs;
        //   Active low chip select
    input chip_select_n;
        //   Indicates a read transaction if asserted and chip selected
    input read_not_write;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Vertical sync strobe, of configurable position and width
    output vsync;
        //   Horizontal sync strobe, of configurable position and width
    output hsync;
        //   Driven when the cursor is configured and the cursor address is matched
    output cursor;
        //   Display enable output, asserted during horizontal display when vertical display is also permitted
    output de;
        //   Data out (to CPU) for reading
    output [7:0]data_out;
        //   Row address
    output [4:0]ra;
        //   Memory address
    output [13:0]ma;

// output components here

    //b Output combinatorials
        //   Vertical sync strobe, of configurable position and width
    reg vsync;
        //   Horizontal sync strobe, of configurable position and width
    reg hsync;
        //   Driven when the cursor is configured and the cursor address is matched
    reg cursor;
        //   Display enable output, asserted during horizontal display when vertical display is also permitted
    reg de;
        //   Data out (to CPU) for reading
    reg [7:0]data_out;
        //   Row address
    reg [4:0]ra;
        //   Memory address
    reg [13:0]ma;

    //b Output nets

    //b Internal and output registers
        //   Only changing when crtc_clock_enable is asserted, maintains the memory address of the current character
    reg [13:0]address_state__memory_address;
    reg [13:0]address_state__memory_address_line_start;
        //   Only changing when crtc_clock_enable is asserted, maintains the vertical timing state
    reg [6:0]vertical_state__character_row_counter;
    reg [4:0]vertical_state__scan_line_counter;
    reg [4:0]vertical_state__adjust_counter;
    reg [3:0]vertical_state__sync_counter;
    reg [5:0]vertical_state__vsync_counter;
    reg vertical_state__doing_adjust;
    reg vertical_state__cursor_line;
    reg vertical_state__sync;
    reg vertical_state__display_enable;
    reg vertical_state__even_field;
        //   Only changing when crtc_clock_enable is asserted, maintains the horizontal timing state
    reg [7:0]horizontal_state__counter;
    reg [3:0]horizontal_state__sync_counter;
    reg horizontal_state__sync;
    reg horizontal_state__display_enable;
        //   CPU-written control state
    reg [7:0]control__h_total;
    reg [7:0]control__h_displayed;
    reg [7:0]control__h_sync_pos;
    reg [3:0]control__h_sync_width;
    reg [6:0]control__v_total;
    reg [4:0]control__v_total_adjust;
    reg [6:0]control__v_displayed;
    reg [6:0]control__v_sync_pos;
    reg [3:0]control__v_sync_width;
    reg [4:0]control__v_max_scan_line;
    reg [1:0]control__cursor__mode;
    reg [4:0]control__cursor__start;
    reg [4:0]control__cursor__end;
    reg [13:0]control__cursor__address;
    reg [1:0]control__interlace_mode;
    reg [5:0]control__start_addr_h;
    reg [7:0]control__start_addr_l;
        //   CPU-written address, indicating which data register is accessed
    reg [4:0]address_register;

    //b Internal combinatorials
        //   Cursor decode, determining where in a character and which character to assert the cursor output
    reg cursor_decode__disabled;
    reg cursor_decode__address_match;
    reg cursor_decode__enable;
        //   Decode of the vertical state
    reg vertical_combs__field_rows_complete;
    reg vertical_combs__display_end;
    reg vertical_combs__sync_done;
    reg vertical_combs__start_vsync;
    reg vertical_combs__max_scan_line;
    reg vertical_combs__adjust_complete;
    reg vertical_combs__field_restart;
    reg vertical_combs__row_restart;
    reg [6:0]vertical_combs__next_character_row_counter;
    reg [4:0]vertical_combs__next_scan_line_counter;
    reg [4:0]vertical_combs__next_adjust_counter;
    reg vertical_combs__sync_start;
    reg vertical_combs__cursor_start;
    reg vertical_combs__cursor_end;
        //   Decode of the horizontal state
    reg horizontal_combs__end_of_scanline;
    reg horizontal_combs__sync_start;
    reg horizontal_combs__sync_done;
    reg horizontal_combs__display_end;
    reg horizontal_combs__halfway;
    reg [7:0]horizontal_combs__next_counter;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b output_logic combinatorial process
        //   
        //       The @a de output is asserted when BOTH the horizontal and vertical
        //       state indicate that the display is enabled.
        //   
        //       The row address for the scanline is usually the line counter,
        //       except when interlaced, in which case every line appears twice as
        //       a row address and @a ra[0] is set for odd fields.
        //   
        //       The memory address, sync signals, and cursor come directly from decode.
        //       
    always @ ( * )//output_logic
    begin: output_logic__comb_code
    reg de__var;
    reg [4:0]ra__var;
        de__var = 1'h1;
        if (!(horizontal_state__display_enable!=1'h0))
        begin
            de__var = 1'h0;
        end //if
        if (!(vertical_state__display_enable!=1'h0))
        begin
            de__var = 1'h0;
        end //if
        ra__var = vertical_state__scan_line_counter;
        if ((control__interlace_mode==2'h3))
        begin
            ra__var = {vertical_state__scan_line_counter[3:0],vertical_state__even_field};
        end //if
        ma = address_state__memory_address;
        cursor = cursor_decode__enable;
        hsync = horizontal_state__sync;
        vsync = vertical_state__sync;
        de = de__var;
        ra = ra__var;
    end //always

    //b horizontal_timing_logic__comb combinatorial process
        //   
        //       Horizontal timing is control.h_total+1 characters wide (count from 0 to control.h_total inclusive)
        //       At control.h_displayed characters (count+1 == control.h_displayed) front porch starts (display_enable falls)
        //       At control.h_sync_pos characters (count+1 == control.h_sync_pos) hsync is asserted, and the sync counter is reset
        //       After control.h_sync_width characters hsync is deasserted (back porch starts)
        //       Back porch continues until control.h_total+1 characters wide reached, then display_enable rises and the next row starts
        //       
    always @ ( * )//horizontal_timing_logic__comb
    begin: horizontal_timing_logic__comb_code
        horizontal_combs__next_counter = (horizontal_state__counter+8'h1);
        horizontal_combs__halfway = (horizontal_state__counter=={1'h0,control__h_total[7:1]});
        horizontal_combs__display_end = (horizontal_combs__next_counter==control__h_displayed);
        horizontal_combs__sync_start = (horizontal_state__counter==control__h_sync_pos);
        horizontal_combs__sync_done = (horizontal_state__sync_counter==control__h_sync_width);
        horizontal_combs__end_of_scanline = (horizontal_state__counter==control__h_total);
    end //always

    //b horizontal_timing_logic__posedge_clk_2MHz_active_low_reset_n clock process
        //   
        //       Horizontal timing is control.h_total+1 characters wide (count from 0 to control.h_total inclusive)
        //       At control.h_displayed characters (count+1 == control.h_displayed) front porch starts (display_enable falls)
        //       At control.h_sync_pos characters (count+1 == control.h_sync_pos) hsync is asserted, and the sync counter is reset
        //       After control.h_sync_width characters hsync is deasserted (back porch starts)
        //       Back porch continues until control.h_total+1 characters wide reached, then display_enable rises and the next row starts
        //       
    always @( posedge clk_2MHz or negedge reset_n)
    begin : horizontal_timing_logic__posedge_clk_2MHz_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            horizontal_state__counter <= 8'h0;
            horizontal_state__display_enable <= 1'h0;
            horizontal_state__sync_counter <= 4'h0;
            horizontal_state__sync <= 1'h0;
        end
        else if (clk_2MHz__enable)
        begin
            horizontal_state__counter <= horizontal_combs__next_counter;
            if ((horizontal_combs__end_of_scanline!=1'h0))
            begin
                horizontal_state__counter <= 8'h0;
                horizontal_state__display_enable <= 1'h1;
            end //if
            if ((horizontal_combs__display_end!=1'h0))
            begin
                horizontal_state__display_enable <= 1'h0;
            end //if
            if ((horizontal_state__sync!=1'h0))
            begin
                horizontal_state__sync_counter <= (horizontal_state__sync_counter+4'h1);
            end //if
            if ((horizontal_combs__sync_start!=1'h0))
            begin
                if ((control__h_sync_width!=4'h0))
                begin
                    horizontal_state__sync <= 1'h1;
                    horizontal_state__sync_counter <= 4'h1;
                end //if
            end //if
            else
            
            begin
                if ((horizontal_combs__sync_done!=1'h0))
                begin
                    horizontal_state__sync <= 1'h0;
                end //if
            end //else
            if (!(crtc_clock_enable!=1'h0))
            begin
                horizontal_state__counter <= horizontal_state__counter;
                horizontal_state__sync_counter <= horizontal_state__sync_counter;
                horizontal_state__sync <= horizontal_state__sync;
                horizontal_state__display_enable <= horizontal_state__display_enable;
            end //if
        end //if
    end //always

    //b vertical_timing__comb combinatorial process
        //   
        //       With interlace the odd field is done first.
        //       Then a horizontal half line is counted off, the even field starts at 0.
        //   
        //       VSync for the even field is 16 horizontal rows starting at half the horizontal row in to Nvsp (number of vertical sync pos) row.
        //       After line Nvl and AdjustRaster lines the half horizontal row is added in to delay the data.
        //       Probably at the start of the odd field another half horizontal rows is added in to delay the data (i.e. the data just has an idle row...)
        //       The odd field is then done, with Vsync of 16 rows starting at the start of row Nvsp.
        //   
        //       If it is interlace sync mode, then the even and odd fields have the same data
        //       If it is interlace sync and video then the even field has RA0 clear, and odd fields have RA1 set
        //   
        //       The upshot of the sync stuff is that even fields have vsync starting half a scanline in to row Nvsp, odd fields have it starting at the beginning of row Nvsp.
        //       Hence vsync runs at a constant frequency, but even fields have vsync occuring half a scan-line later than odd fields, and hence there is a dead row between even and odd fields
        //       to make vsync occur at even spacing
        //   
        //       Because the vsync has to start half-way through the row, h_total must be odd (hence h_total+1 characters is even, and divisible by 2)
        //       
    always @ ( * )//vertical_timing__comb
    begin: vertical_timing__comb_code
    reg vertical_combs__start_vsync__var;
    reg vertical_combs__max_scan_line__var;
    reg vertical_combs__adjust_complete__var;
    reg vertical_combs__field_restart__var;
    reg vertical_combs__row_restart__var;
    reg [6:0]vertical_combs__next_character_row_counter__var;
    reg [4:0]vertical_combs__next_scan_line_counter__var;
    reg [4:0]vertical_combs__next_adjust_counter__var;
    reg vertical_combs__sync_start__var;
        vertical_combs__field_rows_complete = (vertical_state__character_row_counter==control__v_total);
        vertical_combs__display_end = (vertical_state__character_row_counter==control__v_displayed);
        vertical_combs__sync_done = (vertical_state__sync_counter==control__v_sync_width);
        vertical_combs__start_vsync__var = horizontal_combs__halfway;
        if (((control__interlace_mode==2'h0)||!(vertical_state__even_field!=1'h0)))
        begin
            vertical_combs__start_vsync__var = horizontal_combs__end_of_scanline;
        end //if
        vertical_combs__max_scan_line__var = (vertical_state__scan_line_counter==control__v_max_scan_line);
        if ((control__interlace_mode==2'h3))
        begin
            vertical_combs__max_scan_line__var = (vertical_state__scan_line_counter=={1'h0,control__v_max_scan_line[4:1]});
        end //if
        vertical_combs__adjust_complete__var = (vertical_state__adjust_counter==(control__v_total_adjust+5'h1));
        if (!(vertical_state__doing_adjust!=1'h0))
        begin
            vertical_combs__adjust_complete__var = 1'h0;
        end //if
        if (((control__interlace_mode==2'h0)||!(vertical_state__even_field!=1'h0)))
        begin
            vertical_combs__adjust_complete__var = (vertical_state__adjust_counter==control__v_total_adjust);
            if (!(vertical_state__doing_adjust!=1'h0))
            begin
                vertical_combs__adjust_complete__var = (control__v_total_adjust==5'h0);
            end //if
        end //if
        vertical_combs__field_restart__var = 1'h0;
        vertical_combs__row_restart__var = 1'h0;
        vertical_combs__next_character_row_counter__var = vertical_state__character_row_counter;
        vertical_combs__next_scan_line_counter__var = vertical_state__scan_line_counter;
        vertical_combs__next_adjust_counter__var = vertical_state__adjust_counter;
        if ((horizontal_combs__end_of_scanline!=1'h0))
        begin
            vertical_combs__next_scan_line_counter__var = (vertical_state__scan_line_counter+5'h1);
            if ((vertical_state__doing_adjust!=1'h0))
            begin
                vertical_combs__next_adjust_counter__var = (vertical_state__adjust_counter+5'h1);
                if ((vertical_combs__adjust_complete__var!=1'h0))
                begin
                    vertical_combs__field_restart__var = 1'h1;
                end //if
            end //if
            else
            
            begin
                if ((vertical_combs__max_scan_line__var!=1'h0))
                begin
                    vertical_combs__row_restart__var = 1'h1;
                    vertical_combs__next_character_row_counter__var = (vertical_state__character_row_counter+7'h1);
                    vertical_combs__next_scan_line_counter__var = 5'h0;
                    vertical_combs__next_adjust_counter__var = 5'h0;
                    if ((vertical_combs__field_rows_complete!=1'h0))
                    begin
                        if ((vertical_combs__adjust_complete__var!=1'h0))
                        begin
                            vertical_combs__field_restart__var = 1'h1;
                        end //if
                        else
                        
                        begin
                            vertical_combs__next_adjust_counter__var = 5'h1;
                        end //else
                    end //if
                end //if
            end //else
        end //if
        vertical_combs__sync_start__var = ((vertical_state__scan_line_counter==5'h0)&&(vertical_state__character_row_counter==control__v_sync_pos));
        if (((control__interlace_mode==2'h0)||!(vertical_state__even_field!=1'h0)))
        begin
            vertical_combs__sync_start__var = ((vertical_combs__max_scan_line__var!=1'h0)&&(vertical_combs__next_character_row_counter__var==control__v_sync_pos));
        end //if
        vertical_combs__cursor_start = (vertical_combs__next_scan_line_counter__var==control__cursor__start);
        vertical_combs__cursor_end = (vertical_state__scan_line_counter==control__cursor__end);
        vertical_combs__start_vsync = vertical_combs__start_vsync__var;
        vertical_combs__max_scan_line = vertical_combs__max_scan_line__var;
        vertical_combs__adjust_complete = vertical_combs__adjust_complete__var;
        vertical_combs__field_restart = vertical_combs__field_restart__var;
        vertical_combs__row_restart = vertical_combs__row_restart__var;
        vertical_combs__next_character_row_counter = vertical_combs__next_character_row_counter__var;
        vertical_combs__next_scan_line_counter = vertical_combs__next_scan_line_counter__var;
        vertical_combs__next_adjust_counter = vertical_combs__next_adjust_counter__var;
        vertical_combs__sync_start = vertical_combs__sync_start__var;
    end //always

    //b vertical_timing__posedge_clk_2MHz_active_low_reset_n clock process
        //   
        //       With interlace the odd field is done first.
        //       Then a horizontal half line is counted off, the even field starts at 0.
        //   
        //       VSync for the even field is 16 horizontal rows starting at half the horizontal row in to Nvsp (number of vertical sync pos) row.
        //       After line Nvl and AdjustRaster lines the half horizontal row is added in to delay the data.
        //       Probably at the start of the odd field another half horizontal rows is added in to delay the data (i.e. the data just has an idle row...)
        //       The odd field is then done, with Vsync of 16 rows starting at the start of row Nvsp.
        //   
        //       If it is interlace sync mode, then the even and odd fields have the same data
        //       If it is interlace sync and video then the even field has RA0 clear, and odd fields have RA1 set
        //   
        //       The upshot of the sync stuff is that even fields have vsync starting half a scanline in to row Nvsp, odd fields have it starting at the beginning of row Nvsp.
        //       Hence vsync runs at a constant frequency, but even fields have vsync occuring half a scan-line later than odd fields, and hence there is a dead row between even and odd fields
        //       to make vsync occur at even spacing
        //   
        //       Because the vsync has to start half-way through the row, h_total must be odd (hence h_total+1 characters is even, and divisible by 2)
        //       
    always @( posedge clk_2MHz or negedge reset_n)
    begin : vertical_timing__posedge_clk_2MHz_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            vertical_state__character_row_counter <= 7'h0;
            vertical_state__scan_line_counter <= 5'h0;
            vertical_state__adjust_counter <= 5'h0;
            vertical_state__cursor_line <= 1'h0;
            vertical_state__display_enable <= 1'h0;
            vertical_state__doing_adjust <= 1'h0;
            vertical_state__even_field <= 1'h0;
            vertical_state__sync_counter <= 4'h0;
            vertical_state__sync <= 1'h0;
            vertical_state__vsync_counter <= 6'h0;
        end
        else if (clk_2MHz__enable)
        begin
            if ((horizontal_combs__end_of_scanline!=1'h0))
            begin
                vertical_state__character_row_counter <= vertical_combs__next_character_row_counter;
                vertical_state__scan_line_counter <= vertical_combs__next_scan_line_counter;
                vertical_state__adjust_counter <= vertical_combs__next_adjust_counter;
                if (((vertical_combs__cursor_end!=1'h0)||(vertical_combs__row_restart!=1'h0)))
                begin
                    vertical_state__cursor_line <= 1'h0;
                end //if
                if ((vertical_combs__cursor_start!=1'h0))
                begin
                    vertical_state__cursor_line <= 1'h1;
                end //if
                if (((vertical_combs__max_scan_line!=1'h0)&&(vertical_combs__display_end!=1'h0)))
                begin
                    vertical_state__display_enable <= 1'h0;
                end //if
                if (((vertical_combs__max_scan_line!=1'h0)&&(vertical_combs__field_rows_complete!=1'h0)))
                begin
                    vertical_state__doing_adjust <= 1'h1;
                end //if
            end //if
            if ((vertical_combs__field_restart!=1'h0))
            begin
                vertical_state__even_field <= !(vertical_state__even_field!=1'h0);
                vertical_state__doing_adjust <= 1'h0;
                vertical_state__scan_line_counter <= 5'h0;
                vertical_state__character_row_counter <= 7'h0;
                vertical_state__display_enable <= 1'h1;
            end //if
            if ((vertical_combs__start_vsync!=1'h0))
            begin
                if ((vertical_state__sync!=1'h0))
                begin
                    vertical_state__sync_counter <= (vertical_state__sync_counter+4'h1);
                end //if
                if ((vertical_combs__sync_done!=1'h0))
                begin
                    vertical_state__sync <= 1'h0;
                end //if
                if ((vertical_combs__sync_start!=1'h0))
                begin
                    vertical_state__sync <= 1'h1;
                    vertical_state__sync_counter <= 4'h1;
                    vertical_state__vsync_counter <= (vertical_state__vsync_counter+6'h1);
                end //if
            end //if
            if (!(crtc_clock_enable!=1'h0))
            begin
                vertical_state__character_row_counter <= vertical_state__character_row_counter;
                vertical_state__scan_line_counter <= vertical_state__scan_line_counter;
                vertical_state__adjust_counter <= vertical_state__adjust_counter;
                vertical_state__sync_counter <= vertical_state__sync_counter;
                vertical_state__vsync_counter <= vertical_state__vsync_counter;
                vertical_state__doing_adjust <= vertical_state__doing_adjust;
                vertical_state__cursor_line <= vertical_state__cursor_line;
                vertical_state__sync <= vertical_state__sync;
                vertical_state__display_enable <= vertical_state__display_enable;
                vertical_state__even_field <= vertical_state__even_field;
            end //if
        end //if
    end //always

    //b address_and_cursor__comb combinatorial process
        //   
        //       Address register and cursor
        //       
    always @ ( * )//address_and_cursor__comb
    begin: address_and_cursor__comb_code
    reg cursor_decode__disabled__var;
        cursor_decode__address_match = (control__cursor__address==address_state__memory_address);
        cursor_decode__disabled__var = 1'h0;
        case (control__cursor__mode) //synopsys parallel_case
        2'h0: // req 1
            begin
            cursor_decode__disabled__var = 1'h0;
            end
        2'h1: // req 1
            begin
            cursor_decode__disabled__var = 1'h1;
            end
        2'h2: // req 1
            begin
            cursor_decode__disabled__var = vertical_state__vsync_counter[4];
            end
        2'h3: // req 1
            begin
            cursor_decode__disabled__var = vertical_state__vsync_counter[5];
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:crtc6845:address_and_cursor: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        cursor_decode__enable = ((!(cursor_decode__disabled__var!=1'h0)&&(cursor_decode__address_match!=1'h0))&&(vertical_state__cursor_line!=1'h0));
        cursor_decode__disabled = cursor_decode__disabled__var;
    end //always

    //b address_and_cursor__posedge_clk_2MHz_active_low_reset_n clock process
        //   
        //       Address register and cursor
        //       
    always @( posedge clk_2MHz or negedge reset_n)
    begin : address_and_cursor__posedge_clk_2MHz_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            address_state__memory_address <= 14'h0;
            address_state__memory_address_line_start <= 14'h0;
        end
        else if (clk_2MHz__enable)
        begin
            if ((horizontal_state__display_enable!=1'h0))
            begin
                address_state__memory_address <= (address_state__memory_address+14'h1);
            end //if
            if ((horizontal_combs__end_of_scanline!=1'h0))
            begin
                if ((vertical_combs__row_restart!=1'h0))
                begin
                    address_state__memory_address_line_start <= address_state__memory_address;
                end //if
                else
                
                begin
                    address_state__memory_address <= address_state__memory_address_line_start;
                end //else
            end //if
            if ((vertical_combs__field_restart!=1'h0))
            begin
                address_state__memory_address <= {control__start_addr_h,control__start_addr_l};
                address_state__memory_address_line_start <= {control__start_addr_h,control__start_addr_l};
            end //if
            if (!(crtc_clock_enable!=1'h0))
            begin
                address_state__memory_address <= address_state__memory_address;
                address_state__memory_address_line_start <= address_state__memory_address_line_start;
            end //if
        end //if
    end //always

    //b read_write_interface__comb combinatorial process
        //   
        //       The CPU interface has two registers: the first is the address
        //       register, which defines which control will be written to; the
        //       other is the data register, which accesses the register specified
        //       by the address register.
        //   
        //       Currently reads are not supported in this model. Might just be
        //       laziness - but is the 6845 readable?
        //       
    always @ ( * )//read_write_interface__comb
    begin: read_write_interface__comb_code
        data_out = 8'hff;
    end //always

    //b read_write_interface__posedge_clk_1MHz_active_low_reset_n clock process
        //   
        //       The CPU interface has two registers: the first is the address
        //       register, which defines which control will be written to; the
        //       other is the data register, which accesses the register specified
        //       by the address register.
        //   
        //       Currently reads are not supported in this model. Might just be
        //       laziness - but is the 6845 readable?
        //       
    always @( posedge clk_1MHz or negedge reset_n)
    begin : read_write_interface__posedge_clk_1MHz_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            address_register <= 5'h0;
            control__h_total <= 8'h0;
            control__h_displayed <= 8'h0;
            control__h_sync_pos <= 8'h0;
            control__h_sync_width <= 4'h0;
            control__v_sync_width <= 4'h0;
            control__v_total <= 7'h0;
            control__v_total_adjust <= 5'h0;
            control__v_displayed <= 7'h0;
            control__v_sync_pos <= 7'h0;
            control__interlace_mode <= 2'h0;
            control__v_max_scan_line <= 5'h0;
            control__cursor__mode <= 2'h0;
            control__cursor__start <= 5'h0;
            control__cursor__end <= 5'h0;
            control__start_addr_l <= 8'h0;
            control__start_addr_h <= 6'h0;
            control__cursor__address <= 14'h0;
        end
        else if (clk_1MHz__enable)
        begin
            if (((!(chip_select_n!=1'h0)&&(rs==1'h0))&&!(read_not_write!=1'h0)))
            begin
                address_register <= data_in[4:0];
            end //if
            if (((!(chip_select_n!=1'h0)&&(rs==1'h1))&&!(read_not_write!=1'h0)))
            begin
                case (address_register) //synopsys parallel_case
                5'h0: // req 1
                    begin
                    control__h_total <= data_in;
                    end
                5'h1: // req 1
                    begin
                    control__h_displayed <= data_in;
                    end
                5'h2: // req 1
                    begin
                    control__h_sync_pos <= data_in;
                    end
                5'h3: // req 1
                    begin
                    control__h_sync_width <= data_in[3:0];
                    control__v_sync_width <= data_in[7:4];
                    end
                5'h4: // req 1
                    begin
                    control__v_total <= data_in[6:0];
                    end
                5'h5: // req 1
                    begin
                    control__v_total_adjust <= data_in[4:0];
                    end
                5'h6: // req 1
                    begin
                    control__v_displayed <= data_in[6:0];
                    end
                5'h7: // req 1
                    begin
                    control__v_sync_pos <= data_in[6:0];
                    end
                5'h8: // req 1
                    begin
                    control__interlace_mode <= data_in[1:0];
                    end
                5'h9: // req 1
                    begin
                    control__v_max_scan_line <= data_in[4:0];
                    end
                5'ha: // req 1
                    begin
                    control__cursor__mode <= data_in[6:5];
                    control__cursor__start <= data_in[4:0];
                    end
                5'hb: // req 1
                    begin
                    control__cursor__end <= data_in[4:0];
                    end
                5'hd: // req 1
                    begin
                    control__start_addr_l <= data_in;
                    end
                5'hc: // req 1
                    begin
                    control__start_addr_h <= data_in[5:0];
                    end
                5'hf: // req 1
                    begin
                    control__cursor__address[7:0] <= data_in;
                    end
                5'he: // req 1
                    begin
                    control__cursor__address[13:8] <= data_in[5:0];
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
        end //if
    end //always

endmodule // crtc6845
