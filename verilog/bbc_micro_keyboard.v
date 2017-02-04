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

//a Module bbc_micro_keyboard
module bbc_micro_keyboard
(
    clk,

    bbc_keyboard__reset_pressed,
    bbc_keyboard__keys_down_cols_0_to_7,
    bbc_keyboard__keys_down_cols_8_to_9,
    row_select,
    column_select,
    keyboard_enable_n,
    reset_n,

    selected_key_pressed,
    key_in_column_pressed,
    reset_out_n
);

    //b Clocks
    input clk;

    //b Inputs
    input bbc_keyboard__reset_pressed;
    input [63:0]bbc_keyboard__keys_down_cols_0_to_7;
    input [15:0]bbc_keyboard__keys_down_cols_8_to_9;
        //   Wired to pa[3;4], and indicates which row of the keyboard matrix to access
    input [2:0]row_select;
        //   Wired to pa[4;0], and indicates which column of the keyboard matrix to access
    input [3:0]column_select;
        //   Asserted to make keyboard detection operate
    input keyboard_enable_n;
    input reset_n;

    //b Outputs
        //   Asserted if keyboard_enable_n is asserted and the selected key is pressed
    output selected_key_pressed;
        //   Wired to CA2, asserted if keyboard_enable_n and a key is pressed in the specified column (other than row 0)
    output key_in_column_pressed;
        //   From the Break key
    output reset_out_n;

// output components here

    //b Output combinatorials
        //   Asserted if keyboard_enable_n is asserted and the selected key is pressed
    reg selected_key_pressed;
        //   Wired to CA2, asserted if keyboard_enable_n and a key is pressed in the specified column (other than row 0)
    reg key_in_column_pressed;
        //   From the Break key
    reg reset_out_n;

    //b Output nets

    //b Internal and output registers
    reg reset_pressed;
        //   Keys pressed
    reg [7:0]keys_pressed[9:0];
        //   Column being checked
    reg [3:0]column;

    //b Internal combinatorials
    reg [7:0]matrix_output;
    reg [3:0]column_to_use;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b reset_button_logic__comb combinatorial process
        //   
        //       If the switch is pressed (the 'Break' key, really) then reset is pulled low
        //       
    always @( //reset_button_logic__comb
        reset_pressed )
    begin: reset_button_logic__comb_code
    reg reset_out_n__var;
        reset_out_n__var = 1'h1;
        if ((reset_pressed!=1'h0))
        begin
            reset_out_n__var = 1'h0;
        end //if
        reset_out_n = reset_out_n__var;
    end //always

    //b reset_button_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       If the switch is pressed (the 'Break' key, really) then reset is pulled low
        //       
    always @( posedge clk or negedge reset_n)
    begin : reset_button_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            reset_pressed <= 1'h0;
            keys_pressed[0] <= 8'h0;
            keys_pressed[1] <= 8'h0;
            keys_pressed[2] <= 8'h0;
            keys_pressed[3] <= 8'h0;
            keys_pressed[4] <= 8'h0;
            keys_pressed[5] <= 8'h0;
            keys_pressed[6] <= 8'h0;
            keys_pressed[7] <= 8'h0;
            keys_pressed[8] <= 8'h0;
            keys_pressed[9] <= 8'h0;
        end
        else
        begin
            reset_pressed <= 1'h0;
            keys_pressed[0] <= bbc_keyboard__keys_down_cols_0_to_7[7:0];
            keys_pressed[1] <= bbc_keyboard__keys_down_cols_0_to_7[15:8];
            keys_pressed[2] <= bbc_keyboard__keys_down_cols_0_to_7[23:16];
            keys_pressed[3] <= bbc_keyboard__keys_down_cols_0_to_7[31:24];
            keys_pressed[4] <= bbc_keyboard__keys_down_cols_0_to_7[39:32];
            keys_pressed[5] <= bbc_keyboard__keys_down_cols_0_to_7[47:40];
            keys_pressed[6] <= bbc_keyboard__keys_down_cols_0_to_7[55:48];
            keys_pressed[7] <= bbc_keyboard__keys_down_cols_0_to_7[63:56];
            keys_pressed[8] <= bbc_keyboard__keys_down_cols_8_to_9[7:0];
            keys_pressed[9] <= bbc_keyboard__keys_down_cols_8_to_9[15:8];
        end //if
    end //always

    //b keyboard_logic__comb combinatorial process
        //   
        //       The keyboard consists of a 4-bit counter (ls163), a 4-bit BCD converter (7445), a matrix of keys, and a multiplexer (ls251)
        //   
        //       The 7445 is officially a binary-to-decimal converter - effectively a 4-10 demux.
        //       The outputs are active low (i.e. only one line is low), and hence only one column of the keyboard is pulled low
        //       at any one time.
        //       If the inputs are presented with 10 to 15 (instead of 0 to 9) then all the outputs are inactive (high).
        //   
        //       On the real matrix, the keys are just switches connecting the column of a matrix to a row, with row 0 being slightly special
        //       Keys on row 0 have diodes to stop 'bleeding' from column N row 0 to other columns, should more than one key in row 0 be pressed.
        //       Other rows do not have diodes, so pressing column 1 row 5, column 4 row 5, column 4 row 7, would mean that 'lighting' column 1 will
        //       pull column 1 low, row 5 low, hence column 4 low, hence row 7 hence, and so it will seem that column 1 row 7 is pressed.
        //   
        //       The keyboard matrix is:
        //           0      1      2      3      4      5      6      7      8      9   
        //       7  Esc    F1     F2     F3     F5     F6     F8     F9     |     Rght   
        //       6  Tab     Z     Spc     V      B      M     <,     >.     ?/     Copy                              
        //       5  ShLk    S      C      G      H      N      L     +;     }]     Del                              
        //       4  CpLk    A      X      F      Y      J      K      @     :      Ret                            
        //       3   1      2      D      R      6      U      O      P     [{     Up                         
        //       2  F0      W      E      T      7      I      9      0     _      Down                         
        //       1   Q      3      4      5     F4      8     F7     =-     ~^     Left                         
        //       0  Shft   Ctrl   DIP7   DIP7   DIP7   DIP7   DIP7   DIP7   DIP7   DIP7                                                                            
        //   
        //       The keys that are pressed are kept in this module as active high 'keys_pressed' array of bit vectors.
        //       Key column N bit M is pressed if keys_pressed[N][M] is a 1.
        //       
    always @( //keyboard_logic__comb
        column or
        keyboard_enable_n or
        column_select or
        keys_pressed[0] or
        keys_pressed[1] or
        keys_pressed[2] or
        keys_pressed[3] or
        keys_pressed[4] or
        keys_pressed[5] or
        keys_pressed[6] or
        keys_pressed[7] or
        keys_pressed[8] or
        keys_pressed[9]        //keys_pressed - Xilinx does not want arrays in sensitivity lists
 or
        row_select )
    begin: keyboard_logic__comb_code
    reg [3:0]column_to_use__var;
    reg [7:0]matrix_output__var;
    reg selected_key_pressed__var;
        column_to_use__var = column;
        if (!(keyboard_enable_n!=1'h0))
        begin
            column_to_use__var = column_select;
        end //if
        else
        
        begin
        end //else
        matrix_output__var = 8'hff;
        if ((column_to_use__var<4'ha))
        begin
            matrix_output__var = ~keys_pressed[column_to_use__var];
        end //if
        key_in_column_pressed = (matrix_output__var[7:1]!=7'h7f);
        selected_key_pressed__var = 1'h1;
        if (!(keyboard_enable_n!=1'h0))
        begin
            selected_key_pressed__var = !(matrix_output__var[row_select]!=1'h0);
        end //if
        column_to_use = column_to_use__var;
        matrix_output = matrix_output__var;
        selected_key_pressed = selected_key_pressed__var;
    end //always

    //b keyboard_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The keyboard consists of a 4-bit counter (ls163), a 4-bit BCD converter (7445), a matrix of keys, and a multiplexer (ls251)
        //   
        //       The 7445 is officially a binary-to-decimal converter - effectively a 4-10 demux.
        //       The outputs are active low (i.e. only one line is low), and hence only one column of the keyboard is pulled low
        //       at any one time.
        //       If the inputs are presented with 10 to 15 (instead of 0 to 9) then all the outputs are inactive (high).
        //   
        //       On the real matrix, the keys are just switches connecting the column of a matrix to a row, with row 0 being slightly special
        //       Keys on row 0 have diodes to stop 'bleeding' from column N row 0 to other columns, should more than one key in row 0 be pressed.
        //       Other rows do not have diodes, so pressing column 1 row 5, column 4 row 5, column 4 row 7, would mean that 'lighting' column 1 will
        //       pull column 1 low, row 5 low, hence column 4 low, hence row 7 hence, and so it will seem that column 1 row 7 is pressed.
        //   
        //       The keyboard matrix is:
        //           0      1      2      3      4      5      6      7      8      9   
        //       7  Esc    F1     F2     F3     F5     F6     F8     F9     |     Rght   
        //       6  Tab     Z     Spc     V      B      M     <,     >.     ?/     Copy                              
        //       5  ShLk    S      C      G      H      N      L     +;     }]     Del                              
        //       4  CpLk    A      X      F      Y      J      K      @     :      Ret                            
        //       3   1      2      D      R      6      U      O      P     [{     Up                         
        //       2  F0      W      E      T      7      I      9      0     _      Down                         
        //       1   Q      3      4      5     F4      8     F7     =-     ~^     Left                         
        //       0  Shft   Ctrl   DIP7   DIP7   DIP7   DIP7   DIP7   DIP7   DIP7   DIP7                                                                            
        //   
        //       The keys that are pressed are kept in this module as active high 'keys_pressed' array of bit vectors.
        //       Key column N bit M is pressed if keys_pressed[N][M] is a 1.
        //       
    always @( posedge clk or negedge reset_n)
    begin : keyboard_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            column <= 4'h0;
        end
        else
        begin
            if (!(keyboard_enable_n!=1'h0))
            begin
                column <= column_select;
            end //if
            else
            
            begin
                column <= (column+4'h1);
            end //else
        end //if
    end //always

endmodule // bbc_micro_keyboard
