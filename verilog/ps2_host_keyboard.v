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

//a Module ps2_host_keyboard
    //   
    //   
module ps2_host_keyboard
(
    clk,
    clk__enable,

    ps2_rx_data__valid,
    ps2_rx_data__data,
    ps2_rx_data__parity_error,
    ps2_rx_data__protocol_error,
    ps2_rx_data__timeout,
    reset_n,

    ps2_key__valid,
    ps2_key__extended,
    ps2_key__release,
    ps2_key__key_number
);

    //b Clocks
        //   Clock
    input clk;
    input clk__enable;

    //b Inputs
    input ps2_rx_data__valid;
    input [7:0]ps2_rx_data__data;
    input ps2_rx_data__parity_error;
    input ps2_rx_data__protocol_error;
    input ps2_rx_data__timeout;
    input reset_n;

    //b Outputs
    output ps2_key__valid;
    output ps2_key__extended;
    output ps2_key__release;
    output [7:0]ps2_key__key_number;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg ps2_key__valid;
    reg ps2_key__extended;
    reg ps2_key__release;
    reg [7:0]ps2_key__key_number;

    //b Internal combinatorials
    reg [2:0]key_action;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b interpretation_logic__comb combinatorial process
        //   
        //       Interpret the PS2 keyboard codes
        //       
    always @ ( * )//interpretation_logic__comb
    begin: interpretation_logic__comb_code
    reg [2:0]key_action__var;
        key_action__var = 3'h0;
        if ((ps2_rx_data__valid!=1'h0))
        begin
            if ((((ps2_rx_data__parity_error!=1'h0)||(ps2_rx_data__protocol_error!=1'h0))||(ps2_rx_data__timeout!=1'h0)))
            begin
                key_action__var = 3'h1;
            end //if
            else
            
            begin
                if ((ps2_rx_data__data==8'hf0))
                begin
                    key_action__var = 3'h3;
                end //if
                else
                
                begin
                    if ((ps2_rx_data__data==8'he0))
                    begin
                        key_action__var = 3'h2;
                    end //if
                    else
                    
                    begin
                        key_action__var = 3'h4;
                    end //else
                end //else
            end //else
        end //if
        key_action = key_action__var;
    end //always

    //b interpretation_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       Interpret the PS2 keyboard codes
        //       
    always @( posedge clk or negedge reset_n)
    begin : interpretation_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            ps2_key__valid <= 1'h0;
            ps2_key__extended <= 1'h0;
            ps2_key__release <= 1'h0;
            ps2_key__key_number <= 8'h0;
        end
        else if (clk__enable)
        begin
            if ((ps2_key__valid!=1'h0))
            begin
                ps2_key__valid <= 1'h0;
                ps2_key__extended <= 1'h0;
                ps2_key__release <= 1'h0;
            end //if
            case (key_action) //synopsys parallel_case
            3'h1: // req 1
                begin
                ps2_key__valid <= 1'h0;
                ps2_key__extended <= 1'h0;
                ps2_key__release <= 1'h0;
                ps2_key__key_number <= 8'h0;
                end
            3'h3: // req 1
                begin
                ps2_key__release <= 1'h1;
                end
            3'h2: // req 1
                begin
                ps2_key__extended <= 1'h1;
                end
            3'h4: // req 1
                begin
                ps2_key__key_number <= ps2_rx_data__data;
                ps2_key__valid <= 1'h1;
                end
            3'h0: // req 1
                begin
                ps2_key__valid <= 1'h0;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:ps2_host_keyboard:interpretation_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
    end //always

endmodule // ps2_host_keyboard
