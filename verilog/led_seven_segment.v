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

//a Module led_seven_segment
    //   
    //   Simple module to map a hex value to the LEDs required to make the
    //   appropriate symbol in a 7-segment display.
    //   
    //   The module combinatorially takes in a hex value, and drives out 7 LED
    //   values.
    //   
module led_seven_segment
(

    hex,

    leds
);

    //b Clocks

    //b Inputs
        //   Hexadecimal to display on 7-segment LED
    input [3:0]hex;

    //b Outputs
        //   1 for LED on, 0 for LED off, for segments a-g in bits 0-7
    output [6:0]leds;

// output components here

    //b Output combinatorials
        //   1 for LED on, 0 for LED off, for segments a-g in bits 0-7
    reg [6:0]leds;

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials
        //   Array to hold value from constants from leds.h
    reg [15:0]segment_consts[6:0];

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b decode_logic combinatorial process
        //   
        //       Simply map input through constants provided by leds.h
        //   
        //       Segment [0] is taken from bit [hex] of the 16-bit
        //       led_seven_seg_hex_a constant, similarly for other segment
        //       bits. This means that there are 7 constants in leds.h which define
        //       the actual LED segments that light up for each input hex value.
        //       
    always @ ( * )//decode_logic
    begin: decode_logic__comb_code
    reg [15:0]segment_consts__var[6:0];
    reg [6:0]leds__var;
        segment_consts__var[0] = 16'hd7ed;
        segment_consts__var[1] = 16'h279f;
        segment_consts__var[2] = 16'h2ffb;
        segment_consts__var[3] = 16'h7b6d;
        segment_consts__var[4] = 16'hfd45;
        segment_consts__var[5] = 16'hdf71;
        segment_consts__var[6] = 16'hef7c;
        leds__var = 7'h0;
        leds__var[0] = segment_consts__var[0][hex];
        leds__var[1] = segment_consts__var[1][hex];
        leds__var[2] = segment_consts__var[2][hex];
        leds__var[3] = segment_consts__var[3][hex];
        leds__var[4] = segment_consts__var[4][hex];
        leds__var[5] = segment_consts__var[5][hex];
        leds__var[6] = segment_consts__var[6][hex];
        begin:__set__segment_consts__iter integer __iter; for (__iter=0; __iter<7; __iter=__iter+1) segment_consts[__iter] = segment_consts__var[__iter]; end
        leds = leds__var;
    end //always

endmodule // led_seven_segment
