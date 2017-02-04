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

//a Module bbc_vidproc
module bbc_vidproc
(
    clk_2MHz_video,
    clk_cpu,

    saa5050_blue,
    saa5050_green,
    saa5050_red,
    cursor,
    invert_n,
    disen,
    data_in,
    address,
    chip_select_n,
    reset_n,

    pixels_valid_per_clock,
    blue,
    green,
    red,
    crtc_clock_enable
);

    //b Clocks
        //   2MHz video
    input clk_2MHz_video;
        //   2MHz bus clock
    input clk_cpu;

    //b Inputs
        //   3 pixels out at 2MHz, blue component, from teletext
    input [5:0]saa5050_blue;
        //   3 pixels in at 2MHz, green component, from teletext
    input [5:0]saa5050_green;
        //   3 pixels in at 2MHz, red component, from teletext
    input [5:0]saa5050_red;
        //   Asserted for first character of a cursor
    input cursor;
        //   Asserted (low) if the output should be inverted (post-disen probably)
    input invert_n;
        //   Asserted by CRTC if black output required (e.g. during sync)
    input disen;
        //   Data in (from CPU)
    input [7:0]data_in;
        //   Valid with chip select
    input address;
        //   Active low chip select
    input chip_select_n;
        //   Not present on the chip, but required for the model - power up reset
    input reset_n;

    //b Outputs
    output [2:0]pixels_valid_per_clock;
        //   8 pixels out at 2MHz, blue component
    output [7:0]blue;
        //   8 pixels out at 2MHz, green component
    output [7:0]green;
        //   8 pixels out at 2MHz, red component
    output [7:0]red;
        //   High for 2MHz, toggles for 1MHz - the 'character clock' - used also to determine when the shift register is loaded
    output crtc_clock_enable;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg [15:0]palette__flashing;
    reg [2:0]palette__base_color[15:0];
    reg [2:0]control__cursor_segments;
    reg control__clock_rate;
    reg [1:0]control__columns;
    reg control__teletext;
    reg control__flash;
    reg flash_r;
    reg cursor_r;
    reg [3:0]cursor_shift_register;
    reg [7:0]pixel_values__flashing;
    reg [2:0]pixel_values__base_color[7:0];
    reg [7:0]pixel_shift_register;
    reg [2:0]pixels_valid_per_clock;
    reg [7:0]blue;
    reg [7:0]green;
    reg [7:0]red;
    reg crtc_clock_enable;

    //b Internal combinatorials
    reg [2:0]colors_out[7:0];
    reg [2:0]pixel_color[7:0];

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b pixel_output_interface__comb combinatorial process
    always @( //pixel_output_interface__comb
        pixel_values__base_color[0] or
        pixel_values__base_color[1] or
        pixel_values__base_color[2] or
        pixel_values__base_color[3] or
        pixel_values__base_color[4] or
        pixel_values__base_color[5] or
        pixel_values__base_color[6] or
        pixel_values__base_color[7]        //pixel_values__base_color - Xilinx does not want arrays in sensitivity lists
 or
        cursor_r or
        pixel_values__flashing or
        flash_r or
        control__columns or
        disen or
        control__teletext or
        saa5050_blue or
        saa5050_green or
        saa5050_red )
    begin: pixel_output_interface__comb_code
    reg [2:0]pixel_color__var[7:0];
    reg [2:0]colors_out__var[7:0];
        pixel_color__var[0] = ~pixel_values__base_color[0];
        if (((cursor_r ^ (pixel_values__flashing[0] & flash_r))!=1'h0))
        begin
            pixel_color__var[0] = pixel_values__base_color[0];
        end //if
        pixel_color__var[1] = ~pixel_values__base_color[1];
        if (((cursor_r ^ (pixel_values__flashing[1] & flash_r))!=1'h0))
        begin
            pixel_color__var[1] = pixel_values__base_color[1];
        end //if
        pixel_color__var[2] = ~pixel_values__base_color[2];
        if (((cursor_r ^ (pixel_values__flashing[2] & flash_r))!=1'h0))
        begin
            pixel_color__var[2] = pixel_values__base_color[2];
        end //if
        pixel_color__var[3] = ~pixel_values__base_color[3];
        if (((cursor_r ^ (pixel_values__flashing[3] & flash_r))!=1'h0))
        begin
            pixel_color__var[3] = pixel_values__base_color[3];
        end //if
        pixel_color__var[4] = ~pixel_values__base_color[4];
        if (((cursor_r ^ (pixel_values__flashing[4] & flash_r))!=1'h0))
        begin
            pixel_color__var[4] = pixel_values__base_color[4];
        end //if
        pixel_color__var[5] = ~pixel_values__base_color[5];
        if (((cursor_r ^ (pixel_values__flashing[5] & flash_r))!=1'h0))
        begin
            pixel_color__var[5] = pixel_values__base_color[5];
        end //if
        pixel_color__var[6] = ~pixel_values__base_color[6];
        if (((cursor_r ^ (pixel_values__flashing[6] & flash_r))!=1'h0))
        begin
            pixel_color__var[6] = pixel_values__base_color[6];
        end //if
        pixel_color__var[7] = ~pixel_values__base_color[7];
        if (((cursor_r ^ (pixel_values__flashing[7] & flash_r))!=1'h0))
        begin
            pixel_color__var[7] = pixel_values__base_color[7];
        end //if
        colors_out__var[7] = pixel_color__var[0];
        colors_out__var[6] = pixel_color__var[1];
        colors_out__var[5] = pixel_color__var[2];
        colors_out__var[4] = pixel_color__var[3];
        colors_out__var[3] = pixel_color__var[4];
        colors_out__var[2] = pixel_color__var[5];
        colors_out__var[1] = pixel_color__var[6];
        colors_out__var[0] = pixel_color__var[7];
        case (control__columns) //synopsys parallel_case
        2'h3: // req 1
            begin
            colors_out__var[7] = pixel_color__var[0];
            colors_out__var[6] = pixel_color__var[1];
            colors_out__var[5] = pixel_color__var[2];
            colors_out__var[4] = pixel_color__var[3];
            colors_out__var[3] = pixel_color__var[4];
            colors_out__var[2] = pixel_color__var[5];
            colors_out__var[1] = pixel_color__var[6];
            colors_out__var[0] = pixel_color__var[7];
            end
        2'h2: // req 1
            begin
            colors_out__var[7] = pixel_color__var[0];
            colors_out__var[6] = pixel_color__var[0];
            colors_out__var[5] = pixel_color__var[1];
            colors_out__var[4] = pixel_color__var[1];
            colors_out__var[3] = pixel_color__var[2];
            colors_out__var[2] = pixel_color__var[2];
            colors_out__var[1] = pixel_color__var[3];
            colors_out__var[0] = pixel_color__var[3];
            end
        2'h1: // req 1
            begin
            colors_out__var[7] = pixel_color__var[0];
            colors_out__var[6] = pixel_color__var[0];
            colors_out__var[5] = pixel_color__var[0];
            colors_out__var[4] = pixel_color__var[0];
            colors_out__var[3] = pixel_color__var[1];
            colors_out__var[2] = pixel_color__var[1];
            colors_out__var[1] = pixel_color__var[1];
            colors_out__var[0] = pixel_color__var[1];
            end
        2'h0: // req 1
            begin
            colors_out__var[0] = pixel_color__var[0];
            colors_out__var[1] = pixel_color__var[0];
            colors_out__var[2] = pixel_color__var[0];
            colors_out__var[3] = pixel_color__var[0];
            colors_out__var[4] = pixel_color__var[0];
            colors_out__var[5] = pixel_color__var[0];
            colors_out__var[6] = pixel_color__var[0];
            colors_out__var[7] = pixel_color__var[0];
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:bbc_vidproc:pixel_output_interface: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        if (!(disen!=1'h0))
        begin
            colors_out__var[0] = 3'h0;
            colors_out__var[1] = 3'h0;
            colors_out__var[2] = 3'h0;
            colors_out__var[3] = 3'h0;
            colors_out__var[4] = 3'h0;
            colors_out__var[5] = 3'h0;
            colors_out__var[6] = 3'h0;
            colors_out__var[7] = 3'h0;
        end //if
        if ((control__teletext!=1'h0))
        begin
            colors_out__var[0] = {{saa5050_blue[0],saa5050_green[0]},saa5050_red[0]};
            colors_out__var[1] = {{saa5050_blue[1],saa5050_green[1]},saa5050_red[1]};
            colors_out__var[2] = {{saa5050_blue[2],saa5050_green[2]},saa5050_red[2]};
            colors_out__var[3] = {{saa5050_blue[3],saa5050_green[3]},saa5050_red[3]};
            colors_out__var[4] = {{saa5050_blue[4],saa5050_green[4]},saa5050_red[4]};
            colors_out__var[5] = {{saa5050_blue[5],saa5050_green[5]},saa5050_red[5]};
        end //if
        begin:__set__pixel_color__iter integer __iter; for (__iter=0; __iter<8; __iter=__iter+1) pixel_color[__iter] = pixel_color__var[__iter]; end
        begin:__set__colors_out__iter integer __iter; for (__iter=0; __iter<8; __iter=__iter+1) colors_out[__iter] = colors_out__var[__iter]; end
    end //always

    //b pixel_output_interface__posedge_clk_2MHz_video_active_low_reset_n clock process
    always @( posedge clk_2MHz_video or negedge reset_n)
    begin : pixel_output_interface__posedge_clk_2MHz_video_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            flash_r <= 1'h0;
            cursor_r <= 1'h0;
            pixel_values__flashing[0] <= 1'h0; // Should this be a bit vector?
            pixel_values__flashing[1] <= 1'h0; // Should this be a bit vector?
            pixel_values__flashing[2] <= 1'h0; // Should this be a bit vector?
            pixel_values__flashing[3] <= 1'h0; // Should this be a bit vector?
            pixel_values__flashing[4] <= 1'h0; // Should this be a bit vector?
            pixel_values__flashing[5] <= 1'h0; // Should this be a bit vector?
            pixel_values__flashing[6] <= 1'h0; // Should this be a bit vector?
            pixel_values__flashing[7] <= 1'h0; // Should this be a bit vector?
            pixel_values__base_color[0] <= 3'h0;
            pixel_values__base_color[1] <= 3'h0;
            pixel_values__base_color[2] <= 3'h0;
            pixel_values__base_color[3] <= 3'h0;
            pixel_values__base_color[4] <= 3'h0;
            pixel_values__base_color[5] <= 3'h0;
            pixel_values__base_color[6] <= 3'h0;
            pixel_values__base_color[7] <= 3'h0;
            pixels_valid_per_clock <= 3'h0;
            red <= 8'h0;
            green <= 8'h0;
            blue <= 8'h0;
        end
        else
        begin
            flash_r <= control__flash;
            cursor_r <= cursor_shift_register[3];
            pixel_values__flashing[0] <= palette__flashing[{{{pixel_shift_register[7],pixel_shift_register[5]},pixel_shift_register[3]},pixel_shift_register[1]}];
            pixel_values__base_color[0] <= palette__base_color[{{{pixel_shift_register[7],pixel_shift_register[5]},pixel_shift_register[3]},pixel_shift_register[1]}];
            pixel_values__flashing[1] <= palette__flashing[{{{pixel_shift_register[6],pixel_shift_register[4]},pixel_shift_register[2]},pixel_shift_register[0]}];
            pixel_values__base_color[1] <= palette__base_color[{{{pixel_shift_register[6],pixel_shift_register[4]},pixel_shift_register[2]},pixel_shift_register[0]}];
            pixel_values__flashing[2] <= palette__flashing[{{{pixel_shift_register[5],pixel_shift_register[3]},pixel_shift_register[1]},1'h1}];
            pixel_values__base_color[2] <= palette__base_color[{{{pixel_shift_register[5],pixel_shift_register[3]},pixel_shift_register[1]},1'h1}];
            pixel_values__flashing[3] <= palette__flashing[{{{pixel_shift_register[4],pixel_shift_register[2]},pixel_shift_register[0]},1'h1}];
            pixel_values__base_color[3] <= palette__base_color[{{{pixel_shift_register[4],pixel_shift_register[2]},pixel_shift_register[0]},1'h1}];
            pixel_values__flashing[4] <= palette__flashing[{{pixel_shift_register[3],pixel_shift_register[1]},2'h3}];
            pixel_values__base_color[4] <= palette__base_color[{{pixel_shift_register[3],pixel_shift_register[1]},2'h3}];
            pixel_values__flashing[5] <= palette__flashing[{{pixel_shift_register[2],pixel_shift_register[0]},2'h3}];
            pixel_values__base_color[5] <= palette__base_color[{{pixel_shift_register[2],pixel_shift_register[0]},2'h3}];
            pixel_values__flashing[6] <= palette__flashing[{pixel_shift_register[1],3'h7}];
            pixel_values__base_color[6] <= palette__base_color[{pixel_shift_register[1],3'h7}];
            pixel_values__flashing[7] <= palette__flashing[{pixel_shift_register[0],3'h7}];
            pixel_values__base_color[7] <= palette__base_color[{pixel_shift_register[0],3'h7}];
            case (control__columns) //synopsys parallel_case
            2'h3: // req 1
                begin
                pixels_valid_per_clock <= 3'h4;
                end
            2'h2: // req 1
                begin
                pixels_valid_per_clock <= 3'h2;
                end
            2'h1: // req 1
                begin
                pixels_valid_per_clock <= 3'h1;
                end
            2'h0: // req 1
                begin
                pixels_valid_per_clock <= 3'h0;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:bbc_vidproc:pixel_output_interface: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            if ((control__teletext!=1'h0))
            begin
                pixels_valid_per_clock <= 3'h3;
            end //if
            red[0] <= (colors_out[0][0] ^ ~invert_n);
            green[0] <= (colors_out[0][1] ^ ~invert_n);
            blue[0] <= (colors_out[0][2] ^ ~invert_n);
            red[1] <= (colors_out[1][0] ^ ~invert_n);
            green[1] <= (colors_out[1][1] ^ ~invert_n);
            blue[1] <= (colors_out[1][2] ^ ~invert_n);
            red[2] <= (colors_out[2][0] ^ ~invert_n);
            green[2] <= (colors_out[2][1] ^ ~invert_n);
            blue[2] <= (colors_out[2][2] ^ ~invert_n);
            red[3] <= (colors_out[3][0] ^ ~invert_n);
            green[3] <= (colors_out[3][1] ^ ~invert_n);
            blue[3] <= (colors_out[3][2] ^ ~invert_n);
            red[4] <= (colors_out[4][0] ^ ~invert_n);
            green[4] <= (colors_out[4][1] ^ ~invert_n);
            blue[4] <= (colors_out[4][2] ^ ~invert_n);
            red[5] <= (colors_out[5][0] ^ ~invert_n);
            green[5] <= (colors_out[5][1] ^ ~invert_n);
            blue[5] <= (colors_out[5][2] ^ ~invert_n);
            red[6] <= (colors_out[6][0] ^ ~invert_n);
            green[6] <= (colors_out[6][1] ^ ~invert_n);
            blue[6] <= (colors_out[6][2] ^ ~invert_n);
            red[7] <= (colors_out[7][0] ^ ~invert_n);
            green[7] <= (colors_out[7][1] ^ ~invert_n);
            blue[7] <= (colors_out[7][2] ^ ~invert_n);
        end //if
    end //always

    //b pixel_input_interface clock process
    always @( posedge clk_2MHz_video or negedge reset_n)
    begin : pixel_input_interface__code
        if (reset_n==1'b0)
        begin
            pixel_shift_register <= 8'h0;
            cursor_shift_register <= 4'h0;
        end
        else
        begin
            case (control__columns) //synopsys parallel_case
            2'h3: // req 1
                begin
                pixel_shift_register <= 8'hff;
                end
            2'h2: // req 1
                begin
                pixel_shift_register <= {pixel_shift_register[3:0],4'hf};
                end
            2'h1: // req 1
                begin
                pixel_shift_register <= {pixel_shift_register[5:0],2'h3};
                end
            2'h0: // req 1
                begin
                pixel_shift_register <= {pixel_shift_register[6:0],1'h1};
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:bbc_vidproc:pixel_input_interface: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            if ((crtc_clock_enable!=1'h0))
            begin
                pixel_shift_register <= data_in;
                cursor_shift_register <= {cursor_shift_register[2:0],1'h0};
                if ((cursor!=1'h0))
                begin
                    cursor_shift_register[3] <= control__cursor_segments[2];
                    cursor_shift_register[2] <= control__cursor_segments[1];
                    cursor_shift_register[1] <= control__cursor_segments[0];
                    cursor_shift_register[0] <= control__cursor_segments[0];
                end //if
            end //if
        end //if
    end //always

    //b clock_control clock process
        //   
        //       
    always @( posedge clk_2MHz_video or negedge reset_n)
    begin : clock_control__code
        if (reset_n==1'b0)
        begin
            crtc_clock_enable <= 1'h0;
        end
        else
        begin
            crtc_clock_enable <= 1'h1;
            if (!(control__clock_rate!=1'h0))
            begin
                crtc_clock_enable <= !(crtc_clock_enable!=1'h0);
            end //if
        end //if
    end //always

    //b cpu_interface clock process
    always @( posedge clk_cpu or negedge reset_n)
    begin : cpu_interface__code
        if (reset_n==1'b0)
        begin
            control__cursor_segments <= 3'h0;
            control__clock_rate <= 1'h0;
            control__columns <= 2'h0;
            control__teletext <= 1'h0;
            control__flash <= 1'h0;
            palette__flashing[0] <= 1'h0; // Should this be a bit vector?
            palette__flashing[1] <= 1'h0; // Should this be a bit vector?
            palette__flashing[2] <= 1'h0; // Should this be a bit vector?
            palette__flashing[3] <= 1'h0; // Should this be a bit vector?
            palette__flashing[4] <= 1'h0; // Should this be a bit vector?
            palette__flashing[5] <= 1'h0; // Should this be a bit vector?
            palette__flashing[6] <= 1'h0; // Should this be a bit vector?
            palette__flashing[7] <= 1'h0; // Should this be a bit vector?
            palette__flashing[8] <= 1'h0; // Should this be a bit vector?
            palette__flashing[9] <= 1'h0; // Should this be a bit vector?
            palette__flashing[10] <= 1'h0; // Should this be a bit vector?
            palette__flashing[11] <= 1'h0; // Should this be a bit vector?
            palette__flashing[12] <= 1'h0; // Should this be a bit vector?
            palette__flashing[13] <= 1'h0; // Should this be a bit vector?
            palette__flashing[14] <= 1'h0; // Should this be a bit vector?
            palette__flashing[15] <= 1'h0; // Should this be a bit vector?
            palette__base_color[0] <= 3'h0;
            palette__base_color[1] <= 3'h0;
            palette__base_color[2] <= 3'h0;
            palette__base_color[3] <= 3'h0;
            palette__base_color[4] <= 3'h0;
            palette__base_color[5] <= 3'h0;
            palette__base_color[6] <= 3'h0;
            palette__base_color[7] <= 3'h0;
            palette__base_color[8] <= 3'h0;
            palette__base_color[9] <= 3'h0;
            palette__base_color[10] <= 3'h0;
            palette__base_color[11] <= 3'h0;
            palette__base_color[12] <= 3'h0;
            palette__base_color[13] <= 3'h0;
            palette__base_color[14] <= 3'h0;
            palette__base_color[15] <= 3'h0;
        end
        else
        begin
            if ((!(chip_select_n!=1'h0)&&(address==1'h0)))
            begin
                control__cursor_segments <= data_in[7:5];
                control__clock_rate <= data_in[4];
                control__columns <= data_in[3:2];
                control__teletext <= data_in[1];
                control__flash <= data_in[0];
            end //if
            if ((!(chip_select_n!=1'h0)&&(address==1'h1)))
            begin
                palette__flashing[data_in[7:4]] <= data_in[3];
                palette__base_color[data_in[7:4]] <= data_in[2:0];
            end //if
        end //if
    end //always

endmodule // bbc_vidproc
