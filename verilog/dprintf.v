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

//a Module dprintf
    //   
    //   This module that takes an input debug request and converts it in to a
    //   stream of bytes. The debug request is similar to a 'printf' string, in
    //   that it allows formatted data.
    //   
    //   A request is effectively a bytestream with an SRAM address.  The
    //   byte stream consists of ASCII characters plus potentially 'video
    //   control' characters - all in the range 1 to 127, plus control
    //   codes of 0 or 128 to 255.
    //   
    //   The code 0 is just skipped; it allows for simple alignment of data
    //   in the dprintf request.
    //   
    //   A code of 128 to 191 is a zero-padded hex format field. The
    //   encoding is 8h10xxssss; x is unused, and the size @a ss is 0-f,
    //   indicating 1 to 16 following nybbles are data (msb first). The
    //   data follows in the succeeding bytes.
    //   
    //   A code of 192 to 254 is a space-padded decimal format field. The
    //   The encoding is 8h11ppppss; the @a size is 0-3 for 1 to 4 bytes of
    //   data, in the succeeding bytes. The @a padding (pppp) is zero for no
    //   padding; 1 forces the string to be at least 2 characters long
    //   (prepadded with space if required); 2 is pad to 3 characters, and
    //   so on. The maximum padding is to a ten character output (pppp of 9).
    //   
    //   A code of 255 terminates the string.
    //   
module dprintf
(
    clk,
    clk__enable,

    dprintf_req__valid,
    dprintf_req__address,
    dprintf_req__data_0,
    dprintf_req__data_1,
    dprintf_req__data_2,
    dprintf_req__data_3,
    reset_n,

    dprintf_byte__valid,
    dprintf_byte__data,
    dprintf_byte__address,
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
    input [63:0]dprintf_req__data_2;
    input [63:0]dprintf_req__data_3;
    input reset_n;

    //b Outputs
        //   Byte to output
    output dprintf_byte__valid;
    output [7:0]dprintf_byte__data;
    output [15:0]dprintf_byte__address;
        //   Debug printf acknowledge
    output dprintf_ack;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
        //   Formatter state
    reg [2:0]format_state__fsm_state;
    reg [3:0]format_state__bytes_left;
    reg [3:0]format_state__skip_left;
        //   State of decimal divide circuit used to format decimal numbers
    reg [33:0]decimal_state__accumulator;
    reg [3:0]decimal_state__dividend;
        //   Data buffer, reset data to all ones as that matches the data shifted in
    reg data_buffer_state__full;
    reg [15:0]data_buffer_state__address;
    reg [63:0]data_buffer_state__data[3:0];
    reg dprintf_byte__valid;
    reg [7:0]dprintf_byte__data;
    reg [15:0]dprintf_byte__address;
    reg dprintf_ack;

    //b Internal combinatorials
    reg byte_output_combs__will_be_empty;
        //   Combinatorial state of format logic
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
        //   Combinatorials for decimal divide circuit
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
        //       This logic manages the request buffer, loading it, and shifting
        //       data when the formatter consumes it.
        //   
        //       The shift register shifts in 8hff, the 'finish' token, so that a
        //       string is guaranteed to complete. Because of this the reset value
        //       for the shift register should be all ones, and any clients should
        //       drive ones on unused data bits (to reduce unnecessary logic)
        //       
    always @( posedge clk or negedge reset_n)
    begin : debug_printf_logic__code
        if (reset_n==1'b0)
        begin
            dprintf_ack <= 1'h0;
            data_buffer_state__full <= 1'h0;
            data_buffer_state__address <= 16'h0;
            data_buffer_state__data[0] <= 64'h0;
            data_buffer_state__data[0] <= 64'hffffffffffffffff;
            data_buffer_state__data[1] <= 64'h0;
            data_buffer_state__data[1] <= 64'hffffffffffffffff;
            data_buffer_state__data[2] <= 64'h0;
            data_buffer_state__data[2] <= 64'hffffffffffffffff;
            data_buffer_state__data[3] <= 64'h0;
            data_buffer_state__data[3] <= 64'hffffffffffffffff;
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
                data_buffer_state__data[2] <= dprintf_req__data_2;
                data_buffer_state__data[3] <= dprintf_req__data_3;
            end //if
            if ((format_combs__pop_byte!=1'h0))
            begin
                data_buffer_state__data[0] <= {data_buffer_state__data[0][55:0],data_buffer_state__data[1][63:56]};
                data_buffer_state__data[1] <= {data_buffer_state__data[1][55:0],data_buffer_state__data[2][63:56]};
                data_buffer_state__data[2] <= {data_buffer_state__data[2][55:0],data_buffer_state__data[3][63:56]};
                data_buffer_state__data[3] <= {data_buffer_state__data[3][55:0],8'hff};
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
        //       This logic maintains a 34-bit decimal accumulator which permits
        //       repeated subtraction of 10^9, and multiplication by ten. Combined,
        //       this permits a decimal representation of a 32-bit value to be
        //       determined.
        //   
        //       The accumulator is 34 bits long, to store 10^10-1 (34h2_540b_e3ff)
        //   
        //       For repeated subtraction to be used the accumulator must have a
        //       'minus 10^9' value calculated; if this is negative then the
        //       accumulator should be mutliplied by ten to work on the next digit,
        //       but if not then the dividend should be incremented and the 'minus
        //       10^9' value stored in the accumulator.
        //   
        //       A single 4-bit dividend is maintained to permit a digit value to
        //       be determined; once evaluated, the digit is presumably output, and
        //       the accumulator can be multiplied by ten to work on the next least
        //       significant digit.
        //       
    always @ ( * )//decimal_logic__comb
    begin: decimal_logic__comb_code
        decimal_combs__acc_minus_10e9 = ({1'h0,decimal_state__accumulator}-35'h3b9aca00);
        decimal_combs__acc_less_than_10e9 = decimal_combs__acc_minus_10e9[34];
        decimal_combs__acc_is_zero = (decimal_state__accumulator==34'h0);
    end //always

    //b decimal_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       This logic maintains a 34-bit decimal accumulator which permits
        //       repeated subtraction of 10^9, and multiplication by ten. Combined,
        //       this permits a decimal representation of a 32-bit value to be
        //       determined.
        //   
        //       The accumulator is 34 bits long, to store 10^10-1 (34h2_540b_e3ff)
        //   
        //       For repeated subtraction to be used the accumulator must have a
        //       'minus 10^9' value calculated; if this is negative then the
        //       accumulator should be mutliplied by ten to work on the next digit,
        //       but if not then the dividend should be incremented and the 'minus
        //       10^9' value stored in the accumulator.
        //   
        //       A single 4-bit dividend is maintained to permit a digit value to
        //       be determined; once evaluated, the digit is presumably output, and
        //       the accumulator can be multiplied by ten to work on the next least
        //       significant digit.
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
                        $display("%t *********CDL ASSERTION FAILURE:dprintf:decimal_logic: Full switch statement did not cover all values", $time);
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
                    $display("%t *********CDL ASSERTION FAILURE:dprintf:format_logic: Full switch statement did not cover all values", $time);
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
                    $display("%t *********CDL ASSERTION FAILURE:dprintf:format_logic: Full switch statement did not cover all values", $time);
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
                        $display("%t *********CDL ASSERTION FAILURE:dprintf:format_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
    end //always

    //b byte_output_logic__comb combinatorial process
        //   
        //       Drive a valid data byte out if given by the formatter, else hold
        //       the data but invalidated.
        //       
    always @ ( * )//byte_output_logic__comb
    begin: byte_output_logic__comb_code
        byte_output_combs__will_be_empty = 1'h1;
    end //always

    //b byte_output_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       Drive a valid data byte out if given by the formatter, else hold
        //       the data but invalidated.
        //       
    always @( posedge clk or negedge reset_n)
    begin : byte_output_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            dprintf_byte__address <= 16'h0;
            dprintf_byte__valid <= 1'h0;
            dprintf_byte__data <= 8'h0;
        end
        else if (clk__enable)
        begin
            case (format_combs__write_buffer_op) //synopsys parallel_case
            2'h1: // req 1
                begin
                dprintf_byte__address <= data_buffer_state__address;
                dprintf_byte__valid <= 1'h1;
                dprintf_byte__data <= format_combs__write_data;
                end
            default: // req 1
                begin
                dprintf_byte__valid <= dprintf_byte__valid;
                dprintf_byte__data <= dprintf_byte__data;
                dprintf_byte__address <= dprintf_byte__address;
                dprintf_byte__valid <= 1'h0;
                end
            endcase
        end //if
    end //always

endmodule // dprintf
