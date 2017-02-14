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

//a Module bbc_keyboard_ps2
    //   
    //   This module provides a BBC keyboard source from a PS2 keyboard, using a mapping ROM
    //   
module bbc_keyboard_ps2
(
    clk,
    clk__enable,

    ps2_key__valid,
    ps2_key__extended,
    ps2_key__release,
    ps2_key__key_number,
    reset_n,

    keyboard__reset_pressed,
    keyboard__keys_down_cols_0_to_7,
    keyboard__keys_down_cols_8_to_9
);

    //b Clocks
        //   Clock of PS2 keyboard
    input clk;
    input clk__enable;

    //b Inputs
    input ps2_key__valid;
    input ps2_key__extended;
    input ps2_key__release;
    input [7:0]ps2_key__key_number;
    input reset_n;

    //b Outputs
    output keyboard__reset_pressed;
    output [63:0]keyboard__keys_down_cols_0_to_7;
    output [15:0]keyboard__keys_down_cols_8_to_9;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg kbd_map_state__valid;
    reg kbd_map_state__release;
    reg keyboard__reset_pressed;
    reg [63:0]keyboard__keys_down_cols_0_to_7;
    reg [15:0]keyboard__keys_down_cols_8_to_9;

    //b Internal combinatorials
    reg [7:0]kbd_rom_address;

    //b Internal nets
    wire [6:0]kbd_map_data;

    //b Clock gating module instances
    //b Module instances
    se_sram_srw_256x7 kbd_map(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(7'h0),
        .read_not_write(1'h1),
        .address(kbd_rom_address),
        .select(ps2_key__valid),
        .data_out(            kbd_map_data)         );
    //b ps2_keyboard_decode__comb combinatorial process
    always @ ( * )//ps2_keyboard_decode__comb
    begin: ps2_keyboard_decode__comb_code
    reg [7:0]kbd_rom_address__var;
        kbd_rom_address__var = ps2_key__key_number;
        if ((ps2_key__key_number[7]!=1'h0))
        begin
            kbd_rom_address__var = 8'h7f;
        end //if
        kbd_rom_address__var[7] = ps2_key__extended;
        kbd_rom_address = kbd_rom_address__var;
    end //always

    //b ps2_keyboard_decode__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : ps2_keyboard_decode__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            kbd_map_state__valid <= 1'h0;
            kbd_map_state__release <= 1'h0;
            keyboard__keys_down_cols_8_to_9 <= 16'h0;
            keyboard__keys_down_cols_0_to_7 <= 64'h0;
            keyboard__reset_pressed <= 1'h0;
        end
        else if (clk__enable)
        begin
            kbd_map_state__valid <= ps2_key__valid;
            kbd_map_state__release <= ps2_key__release;
            if ((kbd_map_data[6]!=1'h0))
            begin
                keyboard__keys_down_cols_8_to_9[kbd_map_data[3:0]] <= !(kbd_map_state__release!=1'h0);
            end //if
            else
            
            begin
                keyboard__keys_down_cols_0_to_7[kbd_map_data[5:0]] <= !(kbd_map_state__release!=1'h0);
            end //else
            if (!(kbd_map_state__valid!=1'h0))
            begin
                keyboard__reset_pressed <= keyboard__reset_pressed;
                keyboard__keys_down_cols_0_to_7 <= keyboard__keys_down_cols_0_to_7;
                keyboard__keys_down_cols_8_to_9 <= keyboard__keys_down_cols_8_to_9;
            end //if
        end //if
    end //always

endmodule // bbc_keyboard_ps2
