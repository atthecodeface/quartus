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
        //   Clock that rises when the 'enable' of the 6845 completes - but a real clock for this model
    input clk_1MHz;
    input clk_1MHz__enable;
    input clk_2MHz;
    input clk_2MHz__enable;

    //b Inputs
        //   Not on the real chip - really CLK - the character clock - but this is an enable for clk_2MHz
    input crtc_clock_enable;
        //   Light pen strobe
    input lpstb_n;
        //   Data in (from CPU)
    input [7:0]data_in;
        //   Register select - address line really
    input rs;
        //   Active low chip select
    input chip_select_n;
        //   Indicates a read transaction if asserted and chip selected
    input read_not_write;
    input reset_n;

    //b Outputs
    output vsync;
    output hsync;
    output cursor;
    output de;
        //   Data out (to CPU)
    output [7:0]data_out;
        //   Row address
    output [4:0]ra;
        //   Memory address
    output [13:0]ma;

// output components here

    //b Output combinatorials
    reg vsync;
    reg hsync;
    reg cursor;
    reg de;
        //   Data out (to CPU)
    reg [7:0]data_out;
        //   Row address
    reg [4:0]ra;
        //   Memory address
    reg [13:0]ma;

    //b Output nets

    //b Internal and output registers
    reg [13:0]address_state__memory_address;
    reg [13:0]address_state__memory_address_line_start;
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
    reg [7:0]horizontal_state__counter;
    reg [3:0]horizontal_state__sync_counter;
    reg horizontal_state__sync;
    reg horizontal_state__display_enable;
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
    reg [4:0]address_register;

    //b Internal combinatorials
    reg cursor_decode__disabled;
    reg cursor_decode__enable;
    reg cursor_decode__address_match;
    reg vertical__field_restart;
    reg vertical__sync_start;
    reg vertical__sync_done;
    reg vertical__display_end;
    reg vertical__max_scan_line;
    reg vertical__row_restart;
    reg vertical__field_rows_complete;
    reg vertical__adjust_complete;
    reg vertical__start_vsync;
    reg vertical__cursor_start;
    reg vertical__cursor_end;
    reg [6:0]vertical__next_character_row_counter;
    reg [4:0]vertical__next_scan_line_counter;
    reg [4:0]vertical__next_adjust_counter;
    reg horizontal__complete;
    reg horizontal__sync_start;
    reg horizontal__sync_done;
    reg horizontal__display_end;
    reg horizontal__halfway;
    reg [7:0]horizontal__next_counter;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b outputs combinatorial process
        //   
        //       
    always @ ( * )//outputs
    begin: outputs__comb_code
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
        cursor = 1'h0;
        hsync = horizontal_state__sync;
        vsync = vertical_state__sync;
        de = de__var;
        ra = ra__var;
    end //always

    //b horizontal_timing__comb combinatorial process
        //   
        //       Horizontal timing is control.h_total+1 characters wide (count from 0 to control.h_total inclusive)
        //       At control.h_displayed characters (count+1 == control.h_displayed) front porch starts (disen low)
        //       At control.h_sync_pos characters (count+1 == control.h_sync_pos) hsync asserted, sync down count reset
        //       After control.h_sync_width characters hsync deasserted (back porch starts)
        //       Back porch continues until control.h_total+1 characters wide reached, then disen rises (if vertical permis) and the next row starts
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
        //       
    always @ ( * )//horizontal_timing__comb
    begin: horizontal_timing__comb_code
    reg [6:0]vertical__next_character_row_counter__var;
    reg [4:0]vertical__next_scan_line_counter__var;
    reg [4:0]vertical__next_adjust_counter__var;
    reg vertical__max_scan_line__var;
    reg vertical__adjust_complete__var;
    reg vertical__field_restart__var;
    reg vertical__row_restart__var;
    reg vertical__sync_start__var;
    reg vertical__start_vsync__var;
        horizontal__next_counter = (horizontal_state__counter+8'h1);
        horizontal__halfway = (horizontal_state__counter=={1'h0,control__h_total[7:1]});
        horizontal__display_end = (horizontal__next_counter==control__h_displayed);
        horizontal__sync_start = (horizontal_state__counter==control__h_sync_pos);
        horizontal__sync_done = (horizontal_state__sync_counter==control__h_sync_width);
        horizontal__complete = (horizontal_state__counter==control__h_total);
        vertical__next_character_row_counter__var = vertical_state__character_row_counter;
        vertical__next_scan_line_counter__var = vertical_state__scan_line_counter;
        vertical__next_adjust_counter__var = vertical_state__adjust_counter;
        vertical__max_scan_line__var = (vertical_state__scan_line_counter==control__v_max_scan_line);
        if ((control__interlace_mode==2'h3))
        begin
            vertical__max_scan_line__var = (vertical_state__scan_line_counter=={1'h0,control__v_max_scan_line[4:1]});
        end //if
        vertical__field_rows_complete = (vertical_state__character_row_counter==control__v_total);
        vertical__adjust_complete__var = (vertical_state__adjust_counter==(control__v_total_adjust+5'h1));
        if (!(vertical_state__doing_adjust!=1'h0))
        begin
            vertical__adjust_complete__var = 1'h0;
        end //if
        if (((control__interlace_mode==2'h0)||!(vertical_state__even_field!=1'h0)))
        begin
            vertical__adjust_complete__var = (vertical_state__adjust_counter==control__v_total_adjust);
            if (!(vertical_state__doing_adjust!=1'h0))
            begin
                vertical__adjust_complete__var = (control__v_total_adjust==5'h0);
            end //if
        end //if
        vertical__field_restart__var = 1'h0;
        vertical__row_restart__var = 1'h0;
        if ((horizontal__complete!=1'h0))
        begin
            vertical__next_scan_line_counter__var = (vertical_state__scan_line_counter+5'h1);
            if ((vertical_state__doing_adjust!=1'h0))
            begin
                vertical__next_adjust_counter__var = (vertical_state__adjust_counter+5'h1);
                if ((vertical__adjust_complete__var!=1'h0))
                begin
                    vertical__field_restart__var = 1'h1;
                end //if
            end //if
            else
            
            begin
                if ((vertical__max_scan_line__var!=1'h0))
                begin
                    vertical__row_restart__var = 1'h1;
                    vertical__next_character_row_counter__var = (vertical_state__character_row_counter+7'h1);
                    vertical__next_scan_line_counter__var = 5'h0;
                    vertical__next_adjust_counter__var = 5'h0;
                    if ((vertical__field_rows_complete!=1'h0))
                    begin
                        if ((vertical__adjust_complete__var!=1'h0))
                        begin
                            vertical__field_restart__var = 1'h1;
                        end //if
                        else
                        
                        begin
                            vertical__next_adjust_counter__var = 5'h1;
                        end //else
                    end //if
                end //if
            end //else
        end //if
        vertical__sync_start__var = ((vertical_state__scan_line_counter==5'h0)&&(vertical_state__character_row_counter==control__v_sync_pos));
        if (((control__interlace_mode==2'h0)||!(vertical_state__even_field!=1'h0)))
        begin
            vertical__sync_start__var = ((vertical__max_scan_line__var!=1'h0)&&(vertical__next_character_row_counter__var==control__v_sync_pos));
        end //if
        vertical__display_end = (vertical_state__character_row_counter==control__v_displayed);
        vertical__sync_done = (vertical_state__sync_counter==control__v_sync_width);
        vertical__cursor_start = (vertical__next_scan_line_counter__var==control__cursor__start);
        vertical__cursor_end = (vertical_state__scan_line_counter==control__cursor__end);
        vertical__start_vsync__var = horizontal__halfway;
        if (((control__interlace_mode==2'h0)||!(vertical_state__even_field!=1'h0)))
        begin
            vertical__start_vsync__var = horizontal__complete;
        end //if
        vertical__next_character_row_counter = vertical__next_character_row_counter__var;
        vertical__next_scan_line_counter = vertical__next_scan_line_counter__var;
        vertical__next_adjust_counter = vertical__next_adjust_counter__var;
        vertical__max_scan_line = vertical__max_scan_line__var;
        vertical__adjust_complete = vertical__adjust_complete__var;
        vertical__field_restart = vertical__field_restart__var;
        vertical__row_restart = vertical__row_restart__var;
        vertical__sync_start = vertical__sync_start__var;
        vertical__start_vsync = vertical__start_vsync__var;
    end //always

    //b horizontal_timing__posedge_clk_2MHz_active_low_reset_n clock process
        //   
        //       Horizontal timing is control.h_total+1 characters wide (count from 0 to control.h_total inclusive)
        //       At control.h_displayed characters (count+1 == control.h_displayed) front porch starts (disen low)
        //       At control.h_sync_pos characters (count+1 == control.h_sync_pos) hsync asserted, sync down count reset
        //       After control.h_sync_width characters hsync deasserted (back porch starts)
        //       Back porch continues until control.h_total+1 characters wide reached, then disen rises (if vertical permis) and the next row starts
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
        //       
    always @( posedge clk_2MHz or negedge reset_n)
    begin : horizontal_timing__posedge_clk_2MHz_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            horizontal_state__counter <= 8'h0;
            horizontal_state__display_enable <= 1'h0;
            horizontal_state__sync_counter <= 4'h0;
            horizontal_state__sync <= 1'h0;
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
            horizontal_state__counter <= horizontal__next_counter;
            if ((horizontal__complete!=1'h0))
            begin
                horizontal_state__counter <= 8'h0;
                horizontal_state__display_enable <= 1'h1;
            end //if
            if ((horizontal__display_end!=1'h0))
            begin
                horizontal_state__display_enable <= 1'h0;
            end //if
            if ((horizontal_state__sync!=1'h0))
            begin
                horizontal_state__sync_counter <= (horizontal_state__sync_counter+4'h1);
            end //if
            if ((horizontal__sync_start!=1'h0))
            begin
                if ((control__h_sync_width!=4'h0))
                begin
                    horizontal_state__sync <= 1'h1;
                    horizontal_state__sync_counter <= 4'h1;
                end //if
            end //if
            else
            
            begin
                if ((horizontal__sync_done!=1'h0))
                begin
                    horizontal_state__sync <= 1'h0;
                end //if
            end //else
            if ((horizontal__complete!=1'h0))
            begin
                vertical_state__character_row_counter <= vertical__next_character_row_counter;
                vertical_state__scan_line_counter <= vertical__next_scan_line_counter;
                vertical_state__adjust_counter <= vertical__next_adjust_counter;
                if (((vertical__cursor_end!=1'h0)||(vertical__row_restart!=1'h0)))
                begin
                    vertical_state__cursor_line <= 1'h0;
                end //if
                if ((vertical__cursor_start!=1'h0))
                begin
                    vertical_state__cursor_line <= 1'h1;
                end //if
                if (((vertical__max_scan_line!=1'h0)&&(vertical__display_end!=1'h0)))
                begin
                    vertical_state__display_enable <= 1'h0;
                end //if
                if (((vertical__max_scan_line!=1'h0)&&(vertical__field_rows_complete!=1'h0)))
                begin
                    vertical_state__doing_adjust <= 1'h1;
                end //if
            end //if
            if ((vertical__field_restart!=1'h0))
            begin
                vertical_state__even_field <= !(vertical_state__even_field!=1'h0);
                vertical_state__doing_adjust <= 1'h0;
                vertical_state__scan_line_counter <= 5'h0;
                vertical_state__character_row_counter <= 7'h0;
                vertical_state__display_enable <= 1'h1;
            end //if
            if ((vertical__start_vsync!=1'h0))
            begin
                if ((vertical_state__sync!=1'h0))
                begin
                    vertical_state__sync_counter <= (vertical_state__sync_counter+4'h1);
                end //if
                if ((vertical__sync_done!=1'h0))
                begin
                    vertical_state__sync <= 1'h0;
                end //if
                if ((vertical__sync_start!=1'h0))
                begin
                    vertical_state__sync <= 1'h1;
                    vertical_state__sync_counter <= 4'h1;
                    vertical_state__vsync_counter <= (vertical_state__vsync_counter+6'h1);
                end //if
            end //if
            if (!(crtc_clock_enable!=1'h0))
            begin
                horizontal_state__counter <= horizontal_state__counter;
                horizontal_state__sync_counter <= horizontal_state__sync_counter;
                horizontal_state__sync <= horizontal_state__sync;
                horizontal_state__display_enable <= horizontal_state__display_enable;
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
            if ((horizontal__complete!=1'h0))
            begin
                if ((vertical__row_restart!=1'h0))
                begin
                    address_state__memory_address_line_start <= address_state__memory_address;
                end //if
                else
                
                begin
                    address_state__memory_address <= address_state__memory_address_line_start;
                end //else
            end //if
            if ((vertical__field_restart!=1'h0))
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
    always @ ( * )//read_write_interface__comb
    begin: read_write_interface__comb_code
        data_out = 8'hff;
    end //always

    //b read_write_interface__posedge_clk_1MHz_active_low_reset_n clock process
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
