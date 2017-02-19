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

//a Module teletext_dprintf
    //   
    //   
module teletext_dprintf
(
    clk,
    clk__enable,

    dprintf_req__valid,
    dprintf_req__address,
    dprintf_req__data_0,
    dprintf_req__data_1,
    reset_n,

    display_sram_write__enable,
    display_sram_write__data,
    display_sram_write__address,
    dprintf_ack
);

    //b Clocks
        //   Clock for data in and display SRAM write out
    input clk;
    input clk__enable;

    //b Inputs
        //   Debug printf request
    input dprintf_req__valid;
    input [15:0]dprintf_req__address;
    input [63:0]dprintf_req__data_0;
    input [63:0]dprintf_req__data_1;
    input reset_n;

    //b Outputs
    output display_sram_write__enable;
    output [47:0]display_sram_write__data;
    output [15:0]display_sram_write__address;
        //   Debug printf acknowledge
    output dprintf_ack;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg sram_write_buffer_state__valid;
    reg [15:0]sram_write_buffer_state__address;
    reg [7:0]sram_write_buffer_state__data;
    reg [2:0]format_state__fsm_state;
    reg [3:0]format_state__bytes_left;
    reg [3:0]format_state__skip_left;
    reg [33:0]decimal_state__accumulator;
    reg [3:0]decimal_state__dividend;
    reg data_buffer_state__full;
    reg [15:0]data_buffer_state__address;
    reg [63:0]data_buffer_state__data[1:0];
    reg display_sram_write__enable;
    reg [47:0]display_sram_write__data;
    reg [15:0]display_sram_write__address;
    reg dprintf_ack;

    //b Internal combinatorials
    reg sram_write_buffer_combs__will_be_empty;
    reg [7:0]format_combs__byte;
    reg [7:0]format_combs__hex_top_nybble;
    reg [7:0]format_combs__hex_bottom_nybble;
    reg format_combs__byte_terminates_string;
    reg format_combs__byte_nul;
    reg format_combs__byte_is_control_hex;
    reg format_combs__byte_is_control_decimal;
    reg [3:0]format_combs__action;
    reg [3:0]format_combs__decimal_action;
    reg [1:0]format_combs__write_buffer_op;
    reg [7:0]format_combs__write_data;
    reg format_combs__pop_byte;
    reg format_combs__increment_address;
    reg format_combs__completed_string;
    reg [34:0]decimal_combs__acc_minus_10e9;
    reg decimal_combs__acc_less_than_10e9;
    reg decimal_combs__acc_is_zero;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b debug_printf_logic clock process
        //   
        //       A single request is stored and handled at any one time. When the
        //       dprintf logic is idle it can accept a new request, and start to
        //       process it.
        //   
        //       This logic manages the request buffer
        //       
    always @( posedge clk or negedge reset_n)
    begin : debug_printf_logic__code
        if (reset_n==1'b0)
        begin
            dprintf_ack <= 1'h0;
            data_buffer_state__full <= 1'h0;
            data_buffer_state__address <= 16'h0;
            data_buffer_state__data[0] <= 64'h0;
            data_buffer_state__data[1] <= 64'h0;
        end
        else if (clk__enable)
        begin
            dprintf_ack <= 1'h0;
            if (((dprintf_req__valid!=1'h0)&&!(data_buffer_state__full!=1'h0)))
            begin
                dprintf_ack <= 1'h1;
                data_buffer_state__full <= 1'h1;
                data_buffer_state__address <= dprintf_req__address;
                data_buffer_state__data[0] <= dprintf_req__data_0;
                data_buffer_state__data[1] <= dprintf_req__data_1;
            end //if
            if ((format_combs__pop_byte!=1'h0))
            begin
                data_buffer_state__data[0] <= {data_buffer_state__data[0][55:0],data_buffer_state__data[1][63:56]};
                data_buffer_state__data[1] <= {data_buffer_state__data[1][55:0],8'hff};
            end //if
            if ((format_combs__increment_address!=1'h0))
            begin
                data_buffer_state__address <= (data_buffer_state__address+16'h1);
            end //if
            if ((format_combs__completed_string!=1'h0))
            begin
                data_buffer_state__full <= 1'h0;
            end //if
        end //if
    end //always

    //b decimal_logic__comb combinatorial process
        //   
        //       This logic maintains a 32-bit decimal accumulator which permits
        //       The accumulator is 34 bits long, to store 10^10-1 (34h2_540b_e3ff)
        //       
        //       
    always @ ( * )//decimal_logic__comb
    begin: decimal_logic__comb_code
        decimal_combs__acc_minus_10e9 = ({1'h0,decimal_state__accumulator}-35'h3b9aca00);
        decimal_combs__acc_less_than_10e9 = decimal_combs__acc_minus_10e9[34];
        decimal_combs__acc_is_zero = (decimal_state__accumulator==34'h0);
    end //always

    //b decimal_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       This logic maintains a 32-bit decimal accumulator which permits
        //       The accumulator is 34 bits long, to store 10^10-1 (34h2_540b_e3ff)
        //       
        //       
    always @( posedge clk or negedge reset_n)
    begin : decimal_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            decimal_state__accumulator <= 34'h0;
            decimal_state__dividend <= 4'h0;
        end
        else if (clk__enable)
        begin
            case (format_combs__decimal_action) //synopsys parallel_case
            4'h0: // req 1
                begin
                decimal_state__accumulator <= decimal_state__accumulator;
                end
            4'h1: // req 1
                begin
                decimal_state__accumulator <= 34'h0;
                decimal_state__dividend <= 4'h0;
                end
            4'h2: // req 1
                begin
                decimal_state__accumulator <= {decimal_state__accumulator[25:0],format_combs__byte};
                end
            4'h3: // req 1
                begin
                decimal_state__accumulator <= ({decimal_state__accumulator[32:0],1'h0}+{decimal_state__accumulator[30:0],3'h0});
                decimal_state__dividend <= 4'h0;
                end
            4'h4: // req 1
                begin
                decimal_state__accumulator <= decimal_combs__acc_minus_10e9[33:0];
                decimal_state__dividend <= (decimal_state__dividend+4'h1);
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:teletext_dprintf:decimal_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
    end //always

    //b format_logic__comb combinatorial process
        //   
        //       This logic implements a state machine and consumes bytes from the data_buffer
        //   
        //       It consumes bytes from the data_buffer_state.data, and the state
        //       machine handles the operation of formatting different characters
        //       
    always @ ( * )//format_logic__comb
    begin: format_logic__comb_code
    reg [7:0]format_combs__byte__var;
    reg [7:0]format_combs__hex_top_nybble__var;
    reg [7:0]format_combs__hex_bottom_nybble__var;
    reg format_combs__byte_terminates_string__var;
    reg format_combs__byte_nul__var;
    reg format_combs__byte_is_control_hex__var;
    reg format_combs__byte_is_control_decimal__var;
    reg [3:0]format_combs__action__var;
    reg [3:0]format_combs__decimal_action__var;
    reg [1:0]format_combs__write_buffer_op__var;
    reg [7:0]format_combs__write_data__var;
    reg format_combs__pop_byte__var;
    reg format_combs__increment_address__var;
    reg format_combs__completed_string__var;
        format_combs__byte__var = 8'h0;
        format_combs__hex_top_nybble__var = 8'h0;
        format_combs__hex_bottom_nybble__var = 8'h0;
        format_combs__byte_terminates_string__var = 1'h0;
        format_combs__byte_nul__var = 1'h0;
        format_combs__byte_is_control_hex__var = 1'h0;
        format_combs__byte_is_control_decimal__var = 1'h0;
        format_combs__action__var = 4'h0;
        format_combs__decimal_action__var = 4'h0;
        format_combs__write_buffer_op__var = 2'h0;
        format_combs__write_data__var = 8'h0;
        format_combs__pop_byte__var = 1'h0;
        format_combs__increment_address__var = 1'h0;
        format_combs__completed_string__var = 1'h0;
        format_combs__byte__var = data_buffer_state__data[0][63:56];
        format_combs__byte_terminates_string__var = (format_combs__byte__var==8'hff);
        format_combs__byte_nul__var = (format_combs__byte__var==8'h0);
        format_combs__byte_is_control_hex__var = (format_combs__byte__var[7:6]==2'h2);
        format_combs__byte_is_control_decimal__var = (format_combs__byte__var[7:6]==2'h3);
        format_combs__hex_top_nybble__var = (8'h30 | {4'h0,format_combs__byte__var[7:4]});
        if ((format_combs__byte__var[7:4]>4'h9))
        begin
            format_combs__hex_top_nybble__var = (8'h37+{4'h0,format_combs__byte__var[7:4]});
        end //if
        format_combs__hex_bottom_nybble__var = (8'h30 | {4'h0,format_combs__byte__var[3:0]});
        if ((format_combs__byte__var[3:0]>4'h9))
        begin
            format_combs__hex_bottom_nybble__var = (8'h37+{4'h0,format_combs__byte__var[3:0]});
        end //if
        format_combs__action__var = 4'h0;
        case (format_state__fsm_state) //synopsys parallel_case
        3'h0: // req 1
            begin
            if ((data_buffer_state__full!=1'h0))
            begin
                format_combs__action__var = 4'h1;
            end //if
            end
        3'h1: // req 1
            begin
            format_combs__action__var = 4'h4;
            if ((format_combs__byte_terminates_string__var!=1'h0))
            begin
                format_combs__action__var = 4'h3;
            end //if
            else
            
            begin
                if ((format_combs__byte_nul__var!=1'h0))
                begin
                    format_combs__action__var = 4'h2;
                end //if
                else
                
                begin
                    if ((format_combs__byte_is_control_hex__var!=1'h0))
                    begin
                        format_combs__action__var = 4'h5;
                    end //if
                    else
                    
                    begin
                        if ((format_combs__byte_is_control_decimal__var!=1'h0))
                        begin
                            format_combs__action__var = 4'h8;
                        end //if
                    end //else
                end //else
            end //else
            end
        3'h2: // req 1
            begin
            format_combs__action__var = 4'h6;
            end
        3'h3: // req 1
            begin
            format_combs__action__var = 4'h7;
            end
        3'h4: // req 1
            begin
            format_combs__action__var = 4'h9;
            end
        3'h5: // req 1
            begin
            format_combs__action__var = 4'ha;
            if ((decimal_combs__acc_less_than_10e9!=1'h0))
            begin
                format_combs__action__var = 4'hb;
            end //if
            end
        3'h6: // req 1
            begin
            format_combs__action__var = 4'ha;
            if ((decimal_combs__acc_less_than_10e9!=1'h0))
            begin
                format_combs__action__var = 4'hd;
            end //if
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:teletext_dprintf:format_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        format_combs__write_buffer_op__var = 2'h0;
        format_combs__increment_address__var = 1'h0;
        format_combs__pop_byte__var = 1'h0;
        format_combs__completed_string__var = 1'h0;
        format_combs__write_data__var = format_combs__byte__var;
        format_combs__decimal_action__var = 4'h0;
        case (format_combs__action__var) //synopsys parallel_case
        4'h0: // req 1
            begin
            end
        4'h1: // req 1
            begin
            end
        4'h4: // req 1
            begin
            format_combs__write_buffer_op__var = 2'h1;
            format_combs__increment_address__var = 1'h1;
            format_combs__pop_byte__var = 1'h1;
            end
        4'h2: // req 1
            begin
            format_combs__pop_byte__var = 1'h1;
            end
        4'h5: // req 1
            begin
            format_combs__pop_byte__var = 1'h1;
            end
        4'h6: // req 1
            begin
            format_combs__write_buffer_op__var = 2'h1;
            format_combs__write_data__var = format_combs__hex_top_nybble__var;
            format_combs__increment_address__var = 1'h1;
            end
        4'h7: // req 1
            begin
            format_combs__write_buffer_op__var = 2'h1;
            format_combs__write_data__var = format_combs__hex_bottom_nybble__var;
            format_combs__increment_address__var = 1'h1;
            format_combs__pop_byte__var = 1'h1;
            end
        4'h8: // req 1
            begin
            format_combs__pop_byte__var = 1'h1;
            format_combs__decimal_action__var = 4'h1;
            end
        4'h9: // req 1
            begin
            format_combs__decimal_action__var = 4'h2;
            format_combs__pop_byte__var = 1'h1;
            end
        4'hb: // req 1
            begin
            if ((format_state__bytes_left<=format_state__skip_left))
            begin
                format_combs__write_buffer_op__var = 2'h1;
                format_combs__write_data__var = 8'h20;
                format_combs__increment_address__var = 1'h1;
            end //if
            if ((format_state__bytes_left==4'h0))
            begin
                format_combs__write_buffer_op__var = 2'h1;
                format_combs__write_data__var = 8'h30;
                format_combs__increment_address__var = 1'h1;
            end //if
            format_combs__decimal_action__var = 4'h3;
            end
        4'hd: // req 1
            begin
            format_combs__write_buffer_op__var = 2'h1;
            format_combs__write_data__var = (8'h30 | {4'h0,decimal_state__dividend});
            format_combs__increment_address__var = 1'h1;
            format_combs__decimal_action__var = 4'h3;
            end
        4'ha: // req 1
            begin
            format_combs__decimal_action__var = 4'h4;
            end
        4'h3: // req 1
            begin
            format_combs__completed_string__var = 1'h1;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:teletext_dprintf:format_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        format_combs__byte = format_combs__byte__var;
        format_combs__hex_top_nybble = format_combs__hex_top_nybble__var;
        format_combs__hex_bottom_nybble = format_combs__hex_bottom_nybble__var;
        format_combs__byte_terminates_string = format_combs__byte_terminates_string__var;
        format_combs__byte_nul = format_combs__byte_nul__var;
        format_combs__byte_is_control_hex = format_combs__byte_is_control_hex__var;
        format_combs__byte_is_control_decimal = format_combs__byte_is_control_decimal__var;
        format_combs__action = format_combs__action__var;
        format_combs__decimal_action = format_combs__decimal_action__var;
        format_combs__write_buffer_op = format_combs__write_buffer_op__var;
        format_combs__write_data = format_combs__write_data__var;
        format_combs__pop_byte = format_combs__pop_byte__var;
        format_combs__increment_address = format_combs__increment_address__var;
        format_combs__completed_string = format_combs__completed_string__var;
    end //always

    //b format_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       This logic implements a state machine and consumes bytes from the data_buffer
        //   
        //       It consumes bytes from the data_buffer_state.data, and the state
        //       machine handles the operation of formatting different characters
        //       
    always @( posedge clk or negedge reset_n)
    begin : format_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            format_state__fsm_state <= 3'h0;
            format_state__bytes_left <= 4'h0;
            format_state__skip_left <= 4'h0;
        end
        else if (clk__enable)
        begin
            case (format_combs__action) //synopsys parallel_case
            4'h0: // req 1
                begin
                format_state__fsm_state <= format_state__fsm_state;
                end
            4'h1: // req 1
                begin
                format_state__fsm_state <= 3'h1;
                end
            4'h4: // req 1
                begin
                format_state__fsm_state <= 3'h1;
                end
            4'h2: // req 1
                begin
                format_state__fsm_state <= 3'h1;
                end
            4'h5: // req 1
                begin
                format_state__bytes_left <= format_combs__byte[4:1];
                if ((format_combs__byte[0]!=1'h0))
                begin
                    format_state__fsm_state <= 3'h2;
                end //if
                else
                
                begin
                    format_state__fsm_state <= 3'h3;
                end //else
                end
            4'h6: // req 1
                begin
                format_state__fsm_state <= 3'h3;
                end
            4'h7: // req 1
                begin
                format_state__bytes_left <= (format_state__bytes_left-4'h1);
                format_state__fsm_state <= 3'h2;
                if ((format_state__bytes_left==4'h0))
                begin
                    format_state__fsm_state <= 3'h1;
                end //if
                end
            4'h8: // req 1
                begin
                format_state__bytes_left <= {2'h0,format_combs__byte[1:0]};
                format_state__skip_left <= format_combs__byte[5:2];
                format_state__fsm_state <= 3'h4;
                end
            4'h9: // req 1
                begin
                format_state__bytes_left <= (format_state__bytes_left-4'h1);
                format_state__fsm_state <= format_state__fsm_state;
                if ((format_state__bytes_left==4'h0))
                begin
                    format_state__fsm_state <= 3'h5;
                    format_state__bytes_left <= 4'h9;
                end //if
                end
            4'hb: // req 1
                begin
                format_state__bytes_left <= (format_state__bytes_left-4'h1);
                if ((format_state__bytes_left==4'h0))
                begin
                    format_state__fsm_state <= 3'h1;
                end //if
                end
            4'hd: // req 1
                begin
                format_state__fsm_state <= 3'h6;
                format_state__bytes_left <= (format_state__bytes_left-4'h1);
                if ((format_state__bytes_left==4'h0))
                begin
                    format_state__fsm_state <= 3'h1;
                end //if
                end
            4'ha: // req 1
                begin
                format_state__fsm_state <= 3'h6;
                end
            4'h3: // req 1
                begin
                format_state__fsm_state <= 3'h0;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:teletext_dprintf:format_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
    end //always

    //b sram_write_buffer_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//sram_write_buffer_logic__comb
    begin: sram_write_buffer_logic__comb_code
        sram_write_buffer_combs__will_be_empty = 1'h1;
    end //always

    //b sram_write_buffer_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : sram_write_buffer_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            sram_write_buffer_state__address <= 16'h0;
            sram_write_buffer_state__valid <= 1'h0;
            sram_write_buffer_state__data <= 8'h0;
            display_sram_write__enable <= 1'h0;
            display_sram_write__data <= 48'h0;
            display_sram_write__address <= 16'h0;
        end
        else if (clk__enable)
        begin
            case (format_combs__write_buffer_op) //synopsys parallel_case
            2'h1: // req 1
                begin
                sram_write_buffer_state__address <= data_buffer_state__address;
                sram_write_buffer_state__valid <= 1'h1;
                sram_write_buffer_state__data <= format_combs__write_data;
                end
            default: // req 1
                begin
                sram_write_buffer_state__valid <= sram_write_buffer_state__valid;
                sram_write_buffer_state__address <= sram_write_buffer_state__address;
                sram_write_buffer_state__data <= sram_write_buffer_state__data;
                sram_write_buffer_state__valid <= 1'h0;
                end
            endcase
            display_sram_write__enable <= 1'h0;
            display_sram_write__data <= 48'h0;
            display_sram_write__address <= 16'h0;
            if ((sram_write_buffer_state__valid!=1'h0))
            begin
                display_sram_write__enable <= 1'h1;
                display_sram_write__address <= sram_write_buffer_state__address;
                display_sram_write__data[7:0] <= sram_write_buffer_state__data;
            end //if
        end //if
    end //always

endmodule // teletext_dprintf
