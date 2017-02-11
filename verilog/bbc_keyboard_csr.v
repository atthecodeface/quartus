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

//a Module bbc_keyboard_csr
    //   
    //   This module provides a keyboard source from CSR writes
    //   
module bbc_keyboard_csr
(
    clk,
    clk__enable,

    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    keyboard_reset_n,
    reset_n,

    keyboard__reset_pressed,
    keyboard__keys_down_cols_0_to_7,
    keyboard__keys_down_cols_8_to_9,
    csr_response__ack,
    csr_response__read_data_valid,
    csr_response__read_data
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
    input keyboard_reset_n;
    input reset_n;

    //b Outputs
    output keyboard__reset_pressed;
    output [63:0]keyboard__keys_down_cols_0_to_7;
    output [15:0]keyboard__keys_down_cols_8_to_9;
    output csr_response__ack;
    output csr_response__read_data_valid;
    output [31:0]csr_response__read_data;

// output components here

    //b Output combinatorials

    //b Output nets
    wire csr_response__ack;
    wire csr_response__read_data_valid;
    wire [31:0]csr_response__read_data;

    //b Internal and output registers
    reg [7:0]keyboard_state__reset_counter;
    reg keyboard_state__reset_out;
    reg csrs__reset_pressed;
    reg [7:0]csrs__reset_counter;
    reg [63:0]csrs__keys_down_cols_0_to_7;
    reg [15:0]csrs__keys_down_cols_8_to_9;
    reg keyboard__reset_pressed;
    reg [63:0]keyboard__keys_down_cols_0_to_7;
    reg [15:0]keyboard__keys_down_cols_8_to_9;

    //b Internal combinatorials
    reg [31:0]csr_read_data;

    //b Internal nets
    wire csr_access__valid;
    wire csr_access__read_not_write;
    wire [15:0]csr_access__address;
    wire [31:0]csr_access__data;

    //b Clock gating module instances
    //b Module instances
    bbc_csr_interface csri(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_select(16'h3),
        .csr_read_data(csr_read_data),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .reset_n(reset_n),
        .csr_access__data(            csr_access__data),
        .csr_access__address(            csr_access__address),
        .csr_access__read_not_write(            csr_access__read_not_write),
        .csr_access__valid(            csr_access__valid),
        .csr_response__read_data(            csr_response__read_data),
        .csr_response__read_data_valid(            csr_response__read_data_valid),
        .csr_response__ack(            csr_response__ack)         );
    //b control_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//control_logic__comb
    begin: control_logic__comb_code
        csr_read_data = 32'h0;
    end //always

    //b control_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : control_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            csrs__reset_pressed <= 1'h0;
            csrs__reset_counter <= 8'h0;
            csrs__keys_down_cols_0_to_7 <= 64'h0;
            csrs__keys_down_cols_8_to_9 <= 16'h0;
        end
        else if (clk__enable)
        begin
            if (((csr_access__valid!=1'h0)&&!(csr_access__read_not_write!=1'h0)))
            begin
                case (csr_access__address[3:0]) //synopsys parallel_case
                4'h4: // req 1
                    begin
                    csrs__reset_pressed <= csr_access__data[0];
                    csrs__reset_counter <= csr_access__data[31:24];
                    end
                4'h8: // req 1
                    begin
                    csrs__keys_down_cols_0_to_7 <= {csrs__keys_down_cols_0_to_7[63:32],csr_access__data};
                    end
                4'h9: // req 1
                    begin
                    csrs__keys_down_cols_0_to_7 <= {csr_access__data,csrs__keys_down_cols_0_to_7[31:0]};
                    end
                4'ha: // req 1
                    begin
                    csrs__keys_down_cols_8_to_9 <= csr_access__data[15:0];
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

    //b reset_and_keys clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : reset_and_keys__code
        if (reset_n==1'b0)
        begin
            keyboard_state__reset_out <= 1'h0;
            keyboard_state__reset_counter <= 8'h0;
            keyboard_state__reset_counter <= 8'hff;
            keyboard__reset_pressed <= 1'h0;
            keyboard__keys_down_cols_0_to_7 <= 64'h0;
            keyboard__keys_down_cols_8_to_9 <= 16'h0;
        end
        else if (clk__enable)
        begin
            keyboard_state__reset_out <= 1'h0;
            if ((keyboard_state__reset_counter!=8'h0))
            begin
                keyboard_state__reset_out <= 1'h1;
                keyboard_state__reset_counter <= (keyboard_state__reset_counter-8'h1);
            end //if
            if ((keyboard__reset_pressed!=1'h0))
            begin
                keyboard_state__reset_out <= 1'h1;
                keyboard_state__reset_counter <= csrs__reset_counter;
            end //if
            keyboard__reset_pressed <= csrs__reset_pressed;
            keyboard__keys_down_cols_0_to_7 <= csrs__keys_down_cols_0_to_7;
            keyboard__keys_down_cols_8_to_9 <= csrs__keys_down_cols_8_to_9;
        end //if
    end //always

endmodule // bbc_keyboard_csr
