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

//a Module apb_target_gpio
    //   
    //   Simple APB interface to a GPIO system.
    //   
    //   The module has 16 outputs, each with separate enables which reset to
    //   off; it also has 16 inputs, each of which is synced and then edge
    //   detected (or other configured event).
    //   
    //   This module has four APB-addressable registers:
    //   + OutputControl (0):
    //   
    //     Each output (16 of them) has 2 bits; bit 0 is used for GPIO
    //     output 0 @a value, and bit 1 is used for its @a enable. Bits 2 and 3
    //     are used for GPIO output 1, and so on.
    //        
    //   + InputStatus (1):
    //   
    //     This register contains the input pin values and the event status
    //     for the 16 GPIO inputs. The bottom 16 bits contain the input pin
    //     @a value for each of the 16 inputs; the top 16 bits contain the
    //     @a event status.
    //   
    //   + InputReg0 (2):
    //   
    //     On reads, this register contains the input pin event types for input
    //     pins - see the @a t_gpio_input_type for the decode; bits [3;0] are
    //     used for GPIO 0, [3;4] for GPIO1, and so on up to [3;28] for GPIO7.
    //     On writes, this register writes a *single* GPIO input control:
    //     bits[4;0] contain the GPIO input to control; and bits [3;12] contain
    //     the event type - which is only written if bit[8] is set; and if
    //     bit[9] then the input event is cleared.
    //   
    //   + InputReg1 (3):
    //   
    //     This register contains the input pin event types for the top 8 GPIO
    //     pins, in a manner identical to InputReg0.
    //        
    //   
    //   
module apb_target_gpio
(
    clk,
    clk__enable,

    gpio_input,
    apb_request__paddr,
    apb_request__penable,
    apb_request__psel,
    apb_request__pwrite,
    apb_request__pwdata,
    reset_n,

    gpio_input_event,
    gpio_output_enable,
    gpio_output,
    apb_response__prdata,
    apb_response__pready,
    apb_response__perr
);

    //b Clocks
        //   System clock
    input clk;
    input clk__enable;

    //b Inputs
        //   GPIO input pin connections
    input [15:0]gpio_input;
        //   APB request
    input [31:0]apb_request__paddr;
    input apb_request__penable;
    input apb_request__psel;
    input apb_request__pwrite;
    input [31:0]apb_request__pwdata;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Driven high when at least one GPIO input event has occurred, for use as an interrupt to a CPU
    output gpio_input_event;
        //   GPIO output enables
    output [15:0]gpio_output_enable;
        //   GPIO output values, if @p gpio_output_enable is set
    output [15:0]gpio_output;
        //   APB response
    output [31:0]apb_response__prdata;
    output apb_response__pready;
    output apb_response__perr;

// output components here

    //b Output combinatorials
        //   Driven high when at least one GPIO input event has occurred, for use as an interrupt to a CPU
    reg gpio_input_event;
        //   GPIO output enables
    reg [15:0]gpio_output_enable;
        //   GPIO output values, if @p gpio_output_enable is set
    reg [15:0]gpio_output;
        //   APB response
    reg [31:0]apb_response__prdata;
    reg apb_response__pready;
    reg apb_response__perr;

    //b Output nets

    //b Internal and output registers
        //   GPIO output controls
    reg [15:0]outputs__value;
    reg [15:0]outputs__enable;
        //   GPIO input configuration and state
    reg [2:0]inputs__input_type[15:0];
    reg [15:0]inputs__sync_value;
    reg [15:0]inputs__last_sync_value;
    reg [15:0]inputs__value;
    reg [15:0]inputs__event;
        //   Access being performed by APB
    reg [2:0]access;

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b apb_interface_logic__comb combinatorial process
        //   
        //       The APB interface is decoded to @a access when @p psel is asserted
        //       and @p penable is deasserted - this is the first cycle of an APB
        //       access. This permits the access type to be registered, so that the
        //       APB @p prdata can be driven from registers, and so that writes
        //       will occur correctly when @p penable is asserted.
        //   
        //       The APB read data @p prdata can then be generated based on @a
        //       access.
        //       
    always @ ( * )//apb_interface_logic__comb
    begin: apb_interface_logic__comb_code
    reg [31:0]apb_response__prdata__var;
    reg apb_response__pready__var;
        apb_response__prdata__var = 32'h0;
        apb_response__pready__var = 1'h0;
        apb_response__perr = 1'h0;
        apb_response__pready__var = 1'h1;
        case (access) //synopsys parallel_case
        3'h6: // req 1
            begin
            apb_response__prdata__var[16] = inputs__event[0];
            apb_response__prdata__var[0] = inputs__value[0];
            apb_response__prdata__var[17] = inputs__event[1];
            apb_response__prdata__var[1] = inputs__value[1];
            apb_response__prdata__var[18] = inputs__event[2];
            apb_response__prdata__var[2] = inputs__value[2];
            apb_response__prdata__var[19] = inputs__event[3];
            apb_response__prdata__var[3] = inputs__value[3];
            apb_response__prdata__var[20] = inputs__event[4];
            apb_response__prdata__var[4] = inputs__value[4];
            apb_response__prdata__var[21] = inputs__event[5];
            apb_response__prdata__var[5] = inputs__value[5];
            apb_response__prdata__var[22] = inputs__event[6];
            apb_response__prdata__var[6] = inputs__value[6];
            apb_response__prdata__var[23] = inputs__event[7];
            apb_response__prdata__var[7] = inputs__value[7];
            apb_response__prdata__var[24] = inputs__event[8];
            apb_response__prdata__var[8] = inputs__value[8];
            apb_response__prdata__var[25] = inputs__event[9];
            apb_response__prdata__var[9] = inputs__value[9];
            apb_response__prdata__var[26] = inputs__event[10];
            apb_response__prdata__var[10] = inputs__value[10];
            apb_response__prdata__var[27] = inputs__event[11];
            apb_response__prdata__var[11] = inputs__value[11];
            apb_response__prdata__var[28] = inputs__event[12];
            apb_response__prdata__var[12] = inputs__value[12];
            apb_response__prdata__var[29] = inputs__event[13];
            apb_response__prdata__var[13] = inputs__value[13];
            apb_response__prdata__var[30] = inputs__event[14];
            apb_response__prdata__var[14] = inputs__value[14];
            apb_response__prdata__var[31] = inputs__event[15];
            apb_response__prdata__var[15] = inputs__value[15];
            end
        3'h4: // req 1
            begin
            apb_response__prdata__var[2:0] = inputs__input_type[0];
            apb_response__prdata__var[6:4] = inputs__input_type[1];
            apb_response__prdata__var[10:8] = inputs__input_type[2];
            apb_response__prdata__var[14:12] = inputs__input_type[3];
            apb_response__prdata__var[18:16] = inputs__input_type[4];
            apb_response__prdata__var[22:20] = inputs__input_type[5];
            apb_response__prdata__var[26:24] = inputs__input_type[6];
            apb_response__prdata__var[30:28] = inputs__input_type[7];
            end
        3'h5: // req 1
            begin
            apb_response__prdata__var[2:0] = inputs__input_type[8];
            apb_response__prdata__var[6:4] = inputs__input_type[9];
            apb_response__prdata__var[10:8] = inputs__input_type[10];
            apb_response__prdata__var[14:12] = inputs__input_type[11];
            apb_response__prdata__var[18:16] = inputs__input_type[12];
            apb_response__prdata__var[22:20] = inputs__input_type[13];
            apb_response__prdata__var[26:24] = inputs__input_type[14];
            apb_response__prdata__var[30:28] = inputs__input_type[15];
            end
        3'h3: // req 1
            begin
            apb_response__prdata__var[1] = outputs__enable[0];
            apb_response__prdata__var[0] = outputs__value[0];
            apb_response__prdata__var[3] = outputs__enable[1];
            apb_response__prdata__var[2] = outputs__value[1];
            apb_response__prdata__var[5] = outputs__enable[2];
            apb_response__prdata__var[4] = outputs__value[2];
            apb_response__prdata__var[7] = outputs__enable[3];
            apb_response__prdata__var[6] = outputs__value[3];
            apb_response__prdata__var[9] = outputs__enable[4];
            apb_response__prdata__var[8] = outputs__value[4];
            apb_response__prdata__var[11] = outputs__enable[5];
            apb_response__prdata__var[10] = outputs__value[5];
            apb_response__prdata__var[13] = outputs__enable[6];
            apb_response__prdata__var[12] = outputs__value[6];
            apb_response__prdata__var[15] = outputs__enable[7];
            apb_response__prdata__var[14] = outputs__value[7];
            apb_response__prdata__var[17] = outputs__enable[8];
            apb_response__prdata__var[16] = outputs__value[8];
            apb_response__prdata__var[19] = outputs__enable[9];
            apb_response__prdata__var[18] = outputs__value[9];
            apb_response__prdata__var[21] = outputs__enable[10];
            apb_response__prdata__var[20] = outputs__value[10];
            apb_response__prdata__var[23] = outputs__enable[11];
            apb_response__prdata__var[22] = outputs__value[11];
            apb_response__prdata__var[25] = outputs__enable[12];
            apb_response__prdata__var[24] = outputs__value[12];
            apb_response__prdata__var[27] = outputs__enable[13];
            apb_response__prdata__var[26] = outputs__value[13];
            apb_response__prdata__var[29] = outputs__enable[14];
            apb_response__prdata__var[28] = outputs__value[14];
            apb_response__prdata__var[31] = outputs__enable[15];
            apb_response__prdata__var[30] = outputs__value[15];
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
        apb_response__prdata = apb_response__prdata__var;
        apb_response__pready = apb_response__pready__var;
    end //always

    //b apb_interface_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The APB interface is decoded to @a access when @p psel is asserted
        //       and @p penable is deasserted - this is the first cycle of an APB
        //       access. This permits the access type to be registered, so that the
        //       APB @p prdata can be driven from registers, and so that writes
        //       will occur correctly when @p penable is asserted.
        //   
        //       The APB read data @p prdata can then be generated based on @a
        //       access.
        //       
    always @( posedge clk or negedge reset_n)
    begin : apb_interface_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            access <= 3'h0;
        end
        else if (clk__enable)
        begin
            access <= 3'h0;
            case (apb_request__paddr[1:0]) //synopsys parallel_case
            2'h0: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h1:3'h3);
                end
            2'h2: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h2:3'h4);
                end
            2'h3: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h2:3'h5);
                end
            2'h1: // req 1
                begin
                access <= 3'h6;
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
            if ((!(apb_request__psel!=1'h0)||(apb_request__penable!=1'h0)))
            begin
                access <= 3'h0;
            end //if
        end //if
    end //always

    //b output_logic__comb combinatorial process
        //   
        //       GPIO outputs are simply driven outputs and output enables.
        //       
    always @ ( * )//output_logic__comb
    begin: output_logic__comb_code
    reg [15:0]gpio_output__var;
    reg [15:0]gpio_output_enable__var;
        gpio_output__var[0] = outputs__value[0];
        gpio_output_enable__var[0] = outputs__enable[0];
        gpio_output__var[1] = outputs__value[1];
        gpio_output_enable__var[1] = outputs__enable[1];
        gpio_output__var[2] = outputs__value[2];
        gpio_output_enable__var[2] = outputs__enable[2];
        gpio_output__var[3] = outputs__value[3];
        gpio_output_enable__var[3] = outputs__enable[3];
        gpio_output__var[4] = outputs__value[4];
        gpio_output_enable__var[4] = outputs__enable[4];
        gpio_output__var[5] = outputs__value[5];
        gpio_output_enable__var[5] = outputs__enable[5];
        gpio_output__var[6] = outputs__value[6];
        gpio_output_enable__var[6] = outputs__enable[6];
        gpio_output__var[7] = outputs__value[7];
        gpio_output_enable__var[7] = outputs__enable[7];
        gpio_output__var[8] = outputs__value[8];
        gpio_output_enable__var[8] = outputs__enable[8];
        gpio_output__var[9] = outputs__value[9];
        gpio_output_enable__var[9] = outputs__enable[9];
        gpio_output__var[10] = outputs__value[10];
        gpio_output_enable__var[10] = outputs__enable[10];
        gpio_output__var[11] = outputs__value[11];
        gpio_output_enable__var[11] = outputs__enable[11];
        gpio_output__var[12] = outputs__value[12];
        gpio_output_enable__var[12] = outputs__enable[12];
        gpio_output__var[13] = outputs__value[13];
        gpio_output_enable__var[13] = outputs__enable[13];
        gpio_output__var[14] = outputs__value[14];
        gpio_output_enable__var[14] = outputs__enable[14];
        gpio_output__var[15] = outputs__value[15];
        gpio_output_enable__var[15] = outputs__enable[15];
        gpio_output = gpio_output__var;
        gpio_output_enable = gpio_output_enable__var;
    end //always

    //b output_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       GPIO outputs are simply driven outputs and output enables.
        //       
    always @( posedge clk or negedge reset_n)
    begin : output_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            outputs__enable[0] <= 1'h0; // Should this be a bit vector?
            outputs__enable[1] <= 1'h0; // Should this be a bit vector?
            outputs__enable[2] <= 1'h0; // Should this be a bit vector?
            outputs__enable[3] <= 1'h0; // Should this be a bit vector?
            outputs__enable[4] <= 1'h0; // Should this be a bit vector?
            outputs__enable[5] <= 1'h0; // Should this be a bit vector?
            outputs__enable[6] <= 1'h0; // Should this be a bit vector?
            outputs__enable[7] <= 1'h0; // Should this be a bit vector?
            outputs__enable[8] <= 1'h0; // Should this be a bit vector?
            outputs__enable[9] <= 1'h0; // Should this be a bit vector?
            outputs__enable[10] <= 1'h0; // Should this be a bit vector?
            outputs__enable[11] <= 1'h0; // Should this be a bit vector?
            outputs__enable[12] <= 1'h0; // Should this be a bit vector?
            outputs__enable[13] <= 1'h0; // Should this be a bit vector?
            outputs__enable[14] <= 1'h0; // Should this be a bit vector?
            outputs__enable[15] <= 1'h0; // Should this be a bit vector?
            outputs__value[0] <= 1'h0; // Should this be a bit vector?
            outputs__value[1] <= 1'h0; // Should this be a bit vector?
            outputs__value[2] <= 1'h0; // Should this be a bit vector?
            outputs__value[3] <= 1'h0; // Should this be a bit vector?
            outputs__value[4] <= 1'h0; // Should this be a bit vector?
            outputs__value[5] <= 1'h0; // Should this be a bit vector?
            outputs__value[6] <= 1'h0; // Should this be a bit vector?
            outputs__value[7] <= 1'h0; // Should this be a bit vector?
            outputs__value[8] <= 1'h0; // Should this be a bit vector?
            outputs__value[9] <= 1'h0; // Should this be a bit vector?
            outputs__value[10] <= 1'h0; // Should this be a bit vector?
            outputs__value[11] <= 1'h0; // Should this be a bit vector?
            outputs__value[12] <= 1'h0; // Should this be a bit vector?
            outputs__value[13] <= 1'h0; // Should this be a bit vector?
            outputs__value[14] <= 1'h0; // Should this be a bit vector?
            outputs__value[15] <= 1'h0; // Should this be a bit vector?
        end
        else if (clk__enable)
        begin
            if ((access==3'h1))
            begin
                outputs__enable[0] <= apb_request__pwdata[1];
                outputs__value[0] <= apb_request__pwdata[0];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[1] <= apb_request__pwdata[3];
                outputs__value[1] <= apb_request__pwdata[2];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[2] <= apb_request__pwdata[5];
                outputs__value[2] <= apb_request__pwdata[4];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[3] <= apb_request__pwdata[7];
                outputs__value[3] <= apb_request__pwdata[6];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[4] <= apb_request__pwdata[9];
                outputs__value[4] <= apb_request__pwdata[8];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[5] <= apb_request__pwdata[11];
                outputs__value[5] <= apb_request__pwdata[10];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[6] <= apb_request__pwdata[13];
                outputs__value[6] <= apb_request__pwdata[12];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[7] <= apb_request__pwdata[15];
                outputs__value[7] <= apb_request__pwdata[14];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[8] <= apb_request__pwdata[17];
                outputs__value[8] <= apb_request__pwdata[16];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[9] <= apb_request__pwdata[19];
                outputs__value[9] <= apb_request__pwdata[18];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[10] <= apb_request__pwdata[21];
                outputs__value[10] <= apb_request__pwdata[20];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[11] <= apb_request__pwdata[23];
                outputs__value[11] <= apb_request__pwdata[22];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[12] <= apb_request__pwdata[25];
                outputs__value[12] <= apb_request__pwdata[24];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[13] <= apb_request__pwdata[27];
                outputs__value[13] <= apb_request__pwdata[26];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[14] <= apb_request__pwdata[29];
                outputs__value[14] <= apb_request__pwdata[28];
            end //if
            if ((access==3'h1))
            begin
                outputs__enable[15] <= apb_request__pwdata[31];
                outputs__value[15] <= apb_request__pwdata[30];
            end //if
        end //if
    end //always

    //b input_logic__comb combinatorial process
        //   
        //       GPIO inputs; allow writing one input at a time, using @p pwdata[4;0] to specify which input is to be written.
        //   
        //       Bits [3;12] will be written as the @p input_type, but only if bit[8] is set.
        //       The input event status may be cleared (separately, or at the same time) by writing with bit[9] set.
        //   
        //       The input pin state is synchronized with two flops. The
        //       sychronized value (in @a last_sync_value) is copied to the GPIO
        //       input value only if the APB access is not being used - this
        //       permits event detection to be performed with atomic-read-and-clear
        //       (if implemented). The input event can then be detected straight
        //       from the input value, or from a difference between the input value
        //       and the newly synchronized value.
        //       
    always @ ( * )//input_logic__comb
    begin: input_logic__comb_code
    reg gpio_input_event__var;
        gpio_input_event__var = 1'h0;
        if ((inputs__event[0]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[1]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[2]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[3]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[4]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[5]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[6]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[7]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[8]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[9]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[10]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[11]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[12]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[13]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[14]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        if ((inputs__event[15]!=1'h0))
        begin
            gpio_input_event__var = 1'h1;
        end //if
        gpio_input_event = gpio_input_event__var;
    end //always

    //b input_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       GPIO inputs; allow writing one input at a time, using @p pwdata[4;0] to specify which input is to be written.
        //   
        //       Bits [3;12] will be written as the @p input_type, but only if bit[8] is set.
        //       The input event status may be cleared (separately, or at the same time) by writing with bit[9] set.
        //   
        //       The input pin state is synchronized with two flops. The
        //       sychronized value (in @a last_sync_value) is copied to the GPIO
        //       input value only if the APB access is not being used - this
        //       permits event detection to be performed with atomic-read-and-clear
        //       (if implemented). The input event can then be detected straight
        //       from the input value, or from a difference between the input value
        //       and the newly synchronized value.
        //       
    always @( posedge clk or negedge reset_n)
    begin : input_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            inputs__input_type[0] <= 3'h0;
            inputs__input_type[1] <= 3'h0;
            inputs__input_type[2] <= 3'h0;
            inputs__input_type[3] <= 3'h0;
            inputs__input_type[4] <= 3'h0;
            inputs__input_type[5] <= 3'h0;
            inputs__input_type[6] <= 3'h0;
            inputs__input_type[7] <= 3'h0;
            inputs__input_type[8] <= 3'h0;
            inputs__input_type[9] <= 3'h0;
            inputs__input_type[10] <= 3'h0;
            inputs__input_type[11] <= 3'h0;
            inputs__input_type[12] <= 3'h0;
            inputs__input_type[13] <= 3'h0;
            inputs__input_type[14] <= 3'h0;
            inputs__input_type[15] <= 3'h0;
            inputs__event[0] <= 1'h0; // Should this be a bit vector?
            inputs__event[1] <= 1'h0; // Should this be a bit vector?
            inputs__event[2] <= 1'h0; // Should this be a bit vector?
            inputs__event[3] <= 1'h0; // Should this be a bit vector?
            inputs__event[4] <= 1'h0; // Should this be a bit vector?
            inputs__event[5] <= 1'h0; // Should this be a bit vector?
            inputs__event[6] <= 1'h0; // Should this be a bit vector?
            inputs__event[7] <= 1'h0; // Should this be a bit vector?
            inputs__event[8] <= 1'h0; // Should this be a bit vector?
            inputs__event[9] <= 1'h0; // Should this be a bit vector?
            inputs__event[10] <= 1'h0; // Should this be a bit vector?
            inputs__event[11] <= 1'h0; // Should this be a bit vector?
            inputs__event[12] <= 1'h0; // Should this be a bit vector?
            inputs__event[13] <= 1'h0; // Should this be a bit vector?
            inputs__event[14] <= 1'h0; // Should this be a bit vector?
            inputs__event[15] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[0] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[1] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[2] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[3] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[4] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[5] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[6] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[7] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[8] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[9] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[10] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[11] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[12] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[13] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[14] <= 1'h0; // Should this be a bit vector?
            inputs__sync_value[15] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[0] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[1] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[2] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[3] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[4] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[5] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[6] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[7] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[8] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[9] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[10] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[11] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[12] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[13] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[14] <= 1'h0; // Should this be a bit vector?
            inputs__last_sync_value[15] <= 1'h0; // Should this be a bit vector?
            inputs__value[0] <= 1'h0; // Should this be a bit vector?
            inputs__value[1] <= 1'h0; // Should this be a bit vector?
            inputs__value[2] <= 1'h0; // Should this be a bit vector?
            inputs__value[3] <= 1'h0; // Should this be a bit vector?
            inputs__value[4] <= 1'h0; // Should this be a bit vector?
            inputs__value[5] <= 1'h0; // Should this be a bit vector?
            inputs__value[6] <= 1'h0; // Should this be a bit vector?
            inputs__value[7] <= 1'h0; // Should this be a bit vector?
            inputs__value[8] <= 1'h0; // Should this be a bit vector?
            inputs__value[9] <= 1'h0; // Should this be a bit vector?
            inputs__value[10] <= 1'h0; // Should this be a bit vector?
            inputs__value[11] <= 1'h0; // Should this be a bit vector?
            inputs__value[12] <= 1'h0; // Should this be a bit vector?
            inputs__value[13] <= 1'h0; // Should this be a bit vector?
            inputs__value[14] <= 1'h0; // Should this be a bit vector?
            inputs__value[15] <= 1'h0; // Should this be a bit vector?
        end
        else if (clk__enable)
        begin
            if ((apb_request__pwdata[3:0]==4'h0))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[0] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[0] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'h1))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[1] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[1] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'h2))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[2] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[2] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'h3))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[3] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[3] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'h4))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[4] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[4] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'h5))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[5] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[5] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'h6))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[6] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[6] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'h7))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[7] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[7] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'h8))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[8] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[8] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'h9))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[9] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[9] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'ha))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[10] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[10] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'hb))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[11] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[11] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'hc))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[12] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[12] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'hd))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[13] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[13] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'he))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[14] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[14] <= 1'h0;
                    end //if
                end //if
            end //if
            if ((apb_request__pwdata[3:0]==4'hf))
            begin
                if ((access==3'h2))
                begin
                    if ((apb_request__pwdata[8]!=1'h0))
                    begin
                        inputs__input_type[15] <= apb_request__pwdata[14:12];
                    end //if
                    if ((apb_request__pwdata[9]!=1'h0))
                    begin
                        inputs__event[15] <= 1'h0;
                    end //if
                end //if
            end //if
            inputs__sync_value[0] <= gpio_input[0];
            inputs__last_sync_value[0] <= inputs__sync_value[0];
            if ((access==3'h0))
            begin
                inputs__value[0] <= inputs__last_sync_value[0];
                case (inputs__input_type[0]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[0] <= !(inputs__value[0]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[0] <= inputs__value[0];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[0] <= (inputs__event[0] | ((inputs__value[0]!=1'h0)&&!(inputs__last_sync_value[0]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[0] <= (inputs__event[0] | (!(inputs__value[0]!=1'h0)&&(inputs__last_sync_value[0]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[0] <= (inputs__event[0] | (inputs__value[0] ^ inputs__last_sync_value[0]));
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
            inputs__sync_value[1] <= gpio_input[1];
            inputs__last_sync_value[1] <= inputs__sync_value[1];
            if ((access==3'h0))
            begin
                inputs__value[1] <= inputs__last_sync_value[1];
                case (inputs__input_type[1]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[1] <= !(inputs__value[1]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[1] <= inputs__value[1];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[1] <= (inputs__event[1] | ((inputs__value[1]!=1'h0)&&!(inputs__last_sync_value[1]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[1] <= (inputs__event[1] | (!(inputs__value[1]!=1'h0)&&(inputs__last_sync_value[1]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[1] <= (inputs__event[1] | (inputs__value[1] ^ inputs__last_sync_value[1]));
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
            inputs__sync_value[2] <= gpio_input[2];
            inputs__last_sync_value[2] <= inputs__sync_value[2];
            if ((access==3'h0))
            begin
                inputs__value[2] <= inputs__last_sync_value[2];
                case (inputs__input_type[2]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[2] <= !(inputs__value[2]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[2] <= inputs__value[2];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[2] <= (inputs__event[2] | ((inputs__value[2]!=1'h0)&&!(inputs__last_sync_value[2]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[2] <= (inputs__event[2] | (!(inputs__value[2]!=1'h0)&&(inputs__last_sync_value[2]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[2] <= (inputs__event[2] | (inputs__value[2] ^ inputs__last_sync_value[2]));
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
            inputs__sync_value[3] <= gpio_input[3];
            inputs__last_sync_value[3] <= inputs__sync_value[3];
            if ((access==3'h0))
            begin
                inputs__value[3] <= inputs__last_sync_value[3];
                case (inputs__input_type[3]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[3] <= !(inputs__value[3]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[3] <= inputs__value[3];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[3] <= (inputs__event[3] | ((inputs__value[3]!=1'h0)&&!(inputs__last_sync_value[3]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[3] <= (inputs__event[3] | (!(inputs__value[3]!=1'h0)&&(inputs__last_sync_value[3]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[3] <= (inputs__event[3] | (inputs__value[3] ^ inputs__last_sync_value[3]));
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
            inputs__sync_value[4] <= gpio_input[4];
            inputs__last_sync_value[4] <= inputs__sync_value[4];
            if ((access==3'h0))
            begin
                inputs__value[4] <= inputs__last_sync_value[4];
                case (inputs__input_type[4]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[4] <= !(inputs__value[4]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[4] <= inputs__value[4];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[4] <= (inputs__event[4] | ((inputs__value[4]!=1'h0)&&!(inputs__last_sync_value[4]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[4] <= (inputs__event[4] | (!(inputs__value[4]!=1'h0)&&(inputs__last_sync_value[4]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[4] <= (inputs__event[4] | (inputs__value[4] ^ inputs__last_sync_value[4]));
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
            inputs__sync_value[5] <= gpio_input[5];
            inputs__last_sync_value[5] <= inputs__sync_value[5];
            if ((access==3'h0))
            begin
                inputs__value[5] <= inputs__last_sync_value[5];
                case (inputs__input_type[5]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[5] <= !(inputs__value[5]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[5] <= inputs__value[5];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[5] <= (inputs__event[5] | ((inputs__value[5]!=1'h0)&&!(inputs__last_sync_value[5]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[5] <= (inputs__event[5] | (!(inputs__value[5]!=1'h0)&&(inputs__last_sync_value[5]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[5] <= (inputs__event[5] | (inputs__value[5] ^ inputs__last_sync_value[5]));
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
            inputs__sync_value[6] <= gpio_input[6];
            inputs__last_sync_value[6] <= inputs__sync_value[6];
            if ((access==3'h0))
            begin
                inputs__value[6] <= inputs__last_sync_value[6];
                case (inputs__input_type[6]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[6] <= !(inputs__value[6]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[6] <= inputs__value[6];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[6] <= (inputs__event[6] | ((inputs__value[6]!=1'h0)&&!(inputs__last_sync_value[6]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[6] <= (inputs__event[6] | (!(inputs__value[6]!=1'h0)&&(inputs__last_sync_value[6]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[6] <= (inputs__event[6] | (inputs__value[6] ^ inputs__last_sync_value[6]));
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
            inputs__sync_value[7] <= gpio_input[7];
            inputs__last_sync_value[7] <= inputs__sync_value[7];
            if ((access==3'h0))
            begin
                inputs__value[7] <= inputs__last_sync_value[7];
                case (inputs__input_type[7]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[7] <= !(inputs__value[7]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[7] <= inputs__value[7];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[7] <= (inputs__event[7] | ((inputs__value[7]!=1'h0)&&!(inputs__last_sync_value[7]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[7] <= (inputs__event[7] | (!(inputs__value[7]!=1'h0)&&(inputs__last_sync_value[7]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[7] <= (inputs__event[7] | (inputs__value[7] ^ inputs__last_sync_value[7]));
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
            inputs__sync_value[8] <= gpio_input[8];
            inputs__last_sync_value[8] <= inputs__sync_value[8];
            if ((access==3'h0))
            begin
                inputs__value[8] <= inputs__last_sync_value[8];
                case (inputs__input_type[8]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[8] <= !(inputs__value[8]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[8] <= inputs__value[8];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[8] <= (inputs__event[8] | ((inputs__value[8]!=1'h0)&&!(inputs__last_sync_value[8]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[8] <= (inputs__event[8] | (!(inputs__value[8]!=1'h0)&&(inputs__last_sync_value[8]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[8] <= (inputs__event[8] | (inputs__value[8] ^ inputs__last_sync_value[8]));
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
            inputs__sync_value[9] <= gpio_input[9];
            inputs__last_sync_value[9] <= inputs__sync_value[9];
            if ((access==3'h0))
            begin
                inputs__value[9] <= inputs__last_sync_value[9];
                case (inputs__input_type[9]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[9] <= !(inputs__value[9]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[9] <= inputs__value[9];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[9] <= (inputs__event[9] | ((inputs__value[9]!=1'h0)&&!(inputs__last_sync_value[9]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[9] <= (inputs__event[9] | (!(inputs__value[9]!=1'h0)&&(inputs__last_sync_value[9]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[9] <= (inputs__event[9] | (inputs__value[9] ^ inputs__last_sync_value[9]));
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
            inputs__sync_value[10] <= gpio_input[10];
            inputs__last_sync_value[10] <= inputs__sync_value[10];
            if ((access==3'h0))
            begin
                inputs__value[10] <= inputs__last_sync_value[10];
                case (inputs__input_type[10]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[10] <= !(inputs__value[10]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[10] <= inputs__value[10];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[10] <= (inputs__event[10] | ((inputs__value[10]!=1'h0)&&!(inputs__last_sync_value[10]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[10] <= (inputs__event[10] | (!(inputs__value[10]!=1'h0)&&(inputs__last_sync_value[10]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[10] <= (inputs__event[10] | (inputs__value[10] ^ inputs__last_sync_value[10]));
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
            inputs__sync_value[11] <= gpio_input[11];
            inputs__last_sync_value[11] <= inputs__sync_value[11];
            if ((access==3'h0))
            begin
                inputs__value[11] <= inputs__last_sync_value[11];
                case (inputs__input_type[11]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[11] <= !(inputs__value[11]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[11] <= inputs__value[11];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[11] <= (inputs__event[11] | ((inputs__value[11]!=1'h0)&&!(inputs__last_sync_value[11]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[11] <= (inputs__event[11] | (!(inputs__value[11]!=1'h0)&&(inputs__last_sync_value[11]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[11] <= (inputs__event[11] | (inputs__value[11] ^ inputs__last_sync_value[11]));
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
            inputs__sync_value[12] <= gpio_input[12];
            inputs__last_sync_value[12] <= inputs__sync_value[12];
            if ((access==3'h0))
            begin
                inputs__value[12] <= inputs__last_sync_value[12];
                case (inputs__input_type[12]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[12] <= !(inputs__value[12]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[12] <= inputs__value[12];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[12] <= (inputs__event[12] | ((inputs__value[12]!=1'h0)&&!(inputs__last_sync_value[12]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[12] <= (inputs__event[12] | (!(inputs__value[12]!=1'h0)&&(inputs__last_sync_value[12]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[12] <= (inputs__event[12] | (inputs__value[12] ^ inputs__last_sync_value[12]));
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
            inputs__sync_value[13] <= gpio_input[13];
            inputs__last_sync_value[13] <= inputs__sync_value[13];
            if ((access==3'h0))
            begin
                inputs__value[13] <= inputs__last_sync_value[13];
                case (inputs__input_type[13]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[13] <= !(inputs__value[13]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[13] <= inputs__value[13];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[13] <= (inputs__event[13] | ((inputs__value[13]!=1'h0)&&!(inputs__last_sync_value[13]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[13] <= (inputs__event[13] | (!(inputs__value[13]!=1'h0)&&(inputs__last_sync_value[13]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[13] <= (inputs__event[13] | (inputs__value[13] ^ inputs__last_sync_value[13]));
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
            inputs__sync_value[14] <= gpio_input[14];
            inputs__last_sync_value[14] <= inputs__sync_value[14];
            if ((access==3'h0))
            begin
                inputs__value[14] <= inputs__last_sync_value[14];
                case (inputs__input_type[14]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[14] <= !(inputs__value[14]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[14] <= inputs__value[14];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[14] <= (inputs__event[14] | ((inputs__value[14]!=1'h0)&&!(inputs__last_sync_value[14]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[14] <= (inputs__event[14] | (!(inputs__value[14]!=1'h0)&&(inputs__last_sync_value[14]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[14] <= (inputs__event[14] | (inputs__value[14] ^ inputs__last_sync_value[14]));
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
            inputs__sync_value[15] <= gpio_input[15];
            inputs__last_sync_value[15] <= inputs__sync_value[15];
            if ((access==3'h0))
            begin
                inputs__value[15] <= inputs__last_sync_value[15];
                case (inputs__input_type[15]) //synopsys parallel_case
                3'h1: // req 1
                    begin
                    inputs__event[15] <= !(inputs__value[15]!=1'h0);
                    end
                3'h2: // req 1
                    begin
                    inputs__event[15] <= inputs__value[15];
                    end
                3'h3: // req 1
                    begin
                    inputs__event[15] <= (inputs__event[15] | ((inputs__value[15]!=1'h0)&&!(inputs__last_sync_value[15]!=1'h0)));
                    end
                3'h4: // req 1
                    begin
                    inputs__event[15] <= (inputs__event[15] | (!(inputs__value[15]!=1'h0)&&(inputs__last_sync_value[15]!=1'h0)));
                    end
                3'h5: // req 1
                    begin
                    inputs__event[15] <= (inputs__event[15] | (inputs__value[15] ^ inputs__last_sync_value[15]));
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

endmodule // apb_target_gpio
