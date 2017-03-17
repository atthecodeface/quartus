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

//a Module apb_processor
    //   
    //   The module is presented with a request to execute a program from the
    //   ROM starting at a certain address. It executes the program, and hence
    //   a set of APB requests, as required.
    //   
    //   The purpose of the module is to permit programmed sequences of APB
    //   transactions without a full-fledge microcontroller being needed, even
    //   for PLL setup or DDR pin DLL scanning, and so on.
    //   
    //   A request to run a program is an @a address with a @a valid bit; if a
    //   valid request is presented, it should be held until acknowledge. The
    //   module will acknowledge a request using a single cycle @a acknowledge
    //   in its @p apb_processor_response. Then the module will start reading
    //   the ROM at the given address, executing 'APB program instructions'
    //   from the data returned. The ROM is external to this module, and hence
    //   the @p rom_request and @p rom_data signals permit a simple synchronous
    //   memory to be attached with the program data.
    //   
    //   A second request to run a program may be presented while the APB
    //   processor module is busy with the previous program request; this is
    //   perfectly acceptable, but there will not be an @a acknowledge until
    //   the APB processor is ready to start the new program; the new request
    //   should be held stable until that point.
    //   
    //   The ROM contains the APB program, which is 40 bits of data per
    //   instruction - 8 bits of opcode, 32 bits of data, per word. The opcode
    //   is in [8;32], and the operand data is in [32;0].
    //    
    //   The opcodes fall in to 6 different classes: ALU, branch, set
    //   parameter, APB request, wait, finish.
    //    
    //   + ALU
    //   
    //     Five ALU ops are supported - OR, BIC, AND, XOR, ADD
    //    
    //   + Branch
    //   
    //     Four branch types are supported - always, if acc is zero, if acc is
    //     nonzero, and if repeat count is nonzero (with the side effect of
    //     decrementing the repeat count)
    //   
    //   + Set parameter    
    //   
    //     Set parameter can set the APB address, accumulator and repeat count
    //    
    //   + Wait
    //   
    //     Wait uses the accumulator, decrementing it once per cycle, to wait
    //     before moving on in the program.
    //    
    //   + APB request
    //   
    //     APB request can request read, write accumulator, or write using the
    //     ROM content as data; these can optionally also auto-increment the address
    //    
    //   + Finish
    //   
    //     Complete the program, and permit a new request to be started
    //   
    //   The module presents a registered APB request interface out, and
    //   accepts an APB response back, including @a pready.
    //   
module apb_processor
(
    clk,
    clk__enable,

    rom_data,
    apb_response__prdata,
    apb_response__pready,
    apb_response__perr,
    apb_processor_request__valid,
    apb_processor_request__address,
    reset_n,

    apb_request__paddr,
    apb_request__penable,
    apb_request__psel,
    apb_request__pwrite,
    apb_request__pwdata,
    rom_request__enable,
    rom_request__address,
    apb_processor_response__acknowledge,
    apb_processor_response__rom_busy
);

    //b Clocks
        //   Clock for the CSR interface; a superset of all targets clock
    input clk;
    input clk__enable;

    //b Inputs
        //   Read data back from the ROM with the APB program instruction
    input [39:0]rom_data;
        //   Pipelined csr request interface response
    input [31:0]apb_response__prdata;
    input apb_response__pready;
    input apb_response__perr;
        //   Request from the client to execute from an address in the ROM
    input apb_processor_request__valid;
    input [15:0]apb_processor_request__address;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Pipelined csr request interface output
    output [31:0]apb_request__paddr;
    output apb_request__penable;
    output apb_request__psel;
    output apb_request__pwrite;
    output [31:0]apb_request__pwdata;
        //   Request to the instruction ROM for reading, with address
    output rom_request__enable;
    output [15:0]rom_request__address;
        //   Response to the client acknowledging a request
    output apb_processor_response__acknowledge;
    output apb_processor_response__rom_busy;

// output components here

    //b Output combinatorials
        //   Request to the instruction ROM for reading, with address
    reg rom_request__enable;
    reg [15:0]rom_request__address;
        //   Response to the client acknowledging a request
    reg apb_processor_response__acknowledge;
    reg apb_processor_response__rom_busy;

    //b Output nets

    //b Internal and output registers
        //   APB state, including FSM
    reg [1:0]apb_state__fsm_state;
        //   Processor state, including FSM and accumulator
    reg [1:0]processor_state__fsm_state;
    reg [31:0]processor_state__address;
    reg [31:0]processor_state__accumulator;
    reg [31:0]processor_state__repeat_count;
        //   State of the ROM-side; request and ROM access
    reg rom_state__busy;
    reg rom_state__opcode_valid;
    reg [7:0]rom_state__opcode;
    reg [15:0]rom_state__address;
    reg [31:0]rom_state__arg_data;
    reg rom_state__reading;
    reg rom_state__acknowledge;
    reg [31:0]apb_request__paddr;
    reg apb_request__penable;
    reg apb_request__psel;
    reg apb_request__pwrite;
    reg [31:0]apb_request__pwdata;

    //b Internal combinatorials
        //   Combinatorial decode of APB state and APB response
    reg [2:0]apb_combs__action;
    reg apb_combs__completing_request;
        //   Combinatorial decode of the processor state, to determine processor action
    reg processor_combs__apb_req__valid;
    reg processor_combs__apb_req__read_not_write;
    reg [31:0]processor_combs__apb_req__wdata;
    reg [3:0]processor_combs__action;
    reg [31:0]processor_combs__arg_data;
    reg processor_combs__acc_is_zero;
    reg processor_combs__rpt_is_zero;
    reg processor_combs__take_branch;
    reg processor_combs__completes_op;
    reg processor_combs__finishing;
    reg [2:0]processor_combs__opcode_subclass;
    reg [2:0]processor_combs__opcode_class;
    reg processor_combs__opcode_valid;
        //   Combinatorial decode of ROM state
    reg rom_combs__request__enable;
    reg [15:0]rom_combs__request__address;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b rom_interface_logic__comb combinatorial process
        //   
        //       Start a program (go @a busy) when a valid request comes in,
        //       storing the request's @a address as the ROM 'program counter'.
        //       Complete the program when the processor indicates it is executing
        //       a @a finish instruction.
        //   
        //       Request a read of the ROM if there is not a valid opcode in hand,
        //       and a request is being processed (@a busy asserted); don't request
        //       a ROM read if it was requested in the last cycle, as the ROM will
        //       be presenting the data already.
        //   
        //       If reading the ROM, then capture the data from the ROM as a valid
        //       opcode, and move on the 'program counter' @a address.  If the
        //       processor, though, has consumed the opcode, then invalidate it
        //       (these should be mutually exclusive). If the processor indicates a
        //       branch is to be taken, then change the program counter @a address
        //       appropriately.
        //       
    always @ ( * )//rom_interface_logic__comb
    begin: rom_interface_logic__comb_code
    reg rom_combs__request__enable__var;
        rom_combs__request__enable__var = 1'h0;
        rom_combs__request__address = rom_state__address;
        if ((((rom_state__busy!=1'h0)&&!(rom_state__opcode_valid!=1'h0))&&!(rom_state__reading!=1'h0)))
        begin
            rom_combs__request__enable__var = 1'h1;
        end //if
        rom_request__enable = rom_combs__request__enable__var;
        rom_request__address = rom_combs__request__address;
        apb_processor_response__acknowledge = rom_state__acknowledge;
        apb_processor_response__rom_busy = rom_state__busy;
        rom_combs__request__enable = rom_combs__request__enable__var;
    end //always

    //b rom_interface_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       Start a program (go @a busy) when a valid request comes in,
        //       storing the request's @a address as the ROM 'program counter'.
        //       Complete the program when the processor indicates it is executing
        //       a @a finish instruction.
        //   
        //       Request a read of the ROM if there is not a valid opcode in hand,
        //       and a request is being processed (@a busy asserted); don't request
        //       a ROM read if it was requested in the last cycle, as the ROM will
        //       be presenting the data already.
        //   
        //       If reading the ROM, then capture the data from the ROM as a valid
        //       opcode, and move on the 'program counter' @a address.  If the
        //       processor, though, has consumed the opcode, then invalidate it
        //       (these should be mutually exclusive). If the processor indicates a
        //       branch is to be taken, then change the program counter @a address
        //       appropriately.
        //       
    always @( posedge clk or negedge reset_n)
    begin : rom_interface_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            rom_state__acknowledge <= 1'h0;
            rom_state__address <= 16'h0;
            rom_state__busy <= 1'h0;
            rom_state__reading <= 1'h0;
            rom_state__opcode_valid <= 1'h0;
            rom_state__opcode <= 8'h0;
            rom_state__arg_data <= 32'h0;
        end
        else if (clk__enable)
        begin
            rom_state__acknowledge <= 1'h0;
            if (((!(rom_state__busy!=1'h0)&&(apb_processor_request__valid!=1'h0))&&!(rom_state__acknowledge!=1'h0)))
            begin
                rom_state__acknowledge <= 1'h1;
                rom_state__address <= apb_processor_request__address;
                rom_state__busy <= 1'h1;
            end //if
            if ((processor_combs__finishing!=1'h0))
            begin
                rom_state__busy <= 1'h0;
            end //if
            rom_state__reading <= rom_combs__request__enable;
            if ((rom_state__reading!=1'h0))
            begin
                rom_state__opcode_valid <= 1'h1;
                rom_state__opcode <= rom_data[39:32];
                rom_state__arg_data <= rom_data[31:0];
                rom_state__address <= (rom_state__address+16'h1);
            end //if
            if ((processor_combs__completes_op!=1'h0))
            begin
                rom_state__opcode_valid <= 1'h0;
            end //if
            if ((processor_combs__finishing!=1'h0))
            begin
                rom_state__opcode_valid <= 1'h0;
            end //if
            if ((processor_combs__take_branch!=1'h0))
            begin
                rom_state__address <= processor_combs__arg_data[15:0];
            end //if
        end //if
    end //always

    //b processor_execute_logic__comb combinatorial process
        //   
        //       Break out the ROM state data, and determine some simple flags
        //       (e.g. @a acc_is_zero).
        //   
        //       From the processor FSM state, determine the action to take. The
        //       processor will be in 'idle' if it is ready to start processing of
        //       the ROM opcode being presented. Hence most actions are just a
        //       decode, when in idle, of the incoming opcode class. However, if
        //       the processor FSM is indicating an APB request in process then the
        //       processor action is pending the APB request; if the processor is
        //       handling a wait delay then either decrement the accumulator or (if
        //       it is zero) complete the wait instruction.
        //   
        //       Handling the processor action is the essence of executing the
        //       opcode classes, generally; most will complete the opcode execution
        //       and return the processor FSM to idle. A pending APB request will
        //       need to wait for the APB state machine to complete, and it may
        //       (for APB reads) capture the APB @a prdata in the accumulator. A
        //       wait start will cause the delay to be written to the accumulator,
        //       and wait steps are then to decrement the accumulator or simply
        //       complete (if the accumulator is zero). A branch will complete,
        //       while indicating to the ROM state machine to take the branch if
        //       necessary.
        //       
    always @ ( * )//processor_execute_logic__comb
    begin: processor_execute_logic__comb_code
    reg [3:0]processor_combs__action__var;
    reg processor_combs__take_branch__var;
    reg processor_combs__completes_op__var;
    reg processor_combs__finishing__var;
    reg processor_combs__apb_req__valid__var;
    reg processor_combs__apb_req__read_not_write__var;
    reg [31:0]processor_combs__apb_req__wdata__var;
        processor_combs__arg_data = rom_state__arg_data;
        processor_combs__opcode_valid = rom_state__opcode_valid;
        processor_combs__opcode_class = rom_state__opcode[7:5];
        processor_combs__opcode_subclass = rom_state__opcode[2:0];
        processor_combs__acc_is_zero = (processor_state__accumulator==32'h0);
        processor_combs__rpt_is_zero = (processor_state__repeat_count==32'h0);
        processor_combs__action__var = 4'h0;
        case (processor_state__fsm_state) //synopsys parallel_case
        2'h0: // req 1
            begin
            case (processor_combs__opcode_class) //synopsys parallel_case
            3'h1: // req 1
                begin
                processor_combs__action__var = 4'h1;
                end
            3'h2: // req 1
                begin
                processor_combs__action__var = 4'h2;
                end
            3'h0: // req 1
                begin
                processor_combs__action__var = 4'h3;
                end
            3'h3: // req 1
                begin
                processor_combs__action__var = 4'h4;
                end
            3'h4: // req 1
                begin
                processor_combs__action__var = 4'h5;
                end
            3'h5: // req 1
                begin
                processor_combs__action__var = 4'h9;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:apb_processor:processor_execute_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            if (!(processor_combs__opcode_valid!=1'h0))
            begin
                processor_combs__action__var = 4'h0;
            end //if
            end
        2'h1: // req 1
            begin
            processor_combs__action__var = 4'h7;
            end
        2'h2: // req 1
            begin
            processor_combs__action__var = 4'h6;
            if ((processor_combs__acc_is_zero!=1'h0))
            begin
                processor_combs__action__var = 4'h8;
            end //if
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:apb_processor:processor_execute_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        processor_combs__take_branch__var = 1'h0;
        processor_combs__completes_op__var = 1'h0;
        processor_combs__finishing__var = 1'h0;
        processor_combs__apb_req__valid__var = 1'h0;
        processor_combs__apb_req__read_not_write__var = 1'h0;
        processor_combs__apb_req__wdata__var = processor_state__accumulator;
        case (processor_combs__action__var) //synopsys parallel_case
        4'h1: // req 1
            begin
            processor_combs__completes_op__var = 1'h1;
            end
        4'h2: // req 1
            begin
            processor_combs__apb_req__valid__var = 1'h1;
            case (processor_combs__opcode_subclass[1:0]) //synopsys parallel_case
            2'h0: // req 1
                begin
                processor_combs__apb_req__read_not_write__var = 1'h1;
                end
            2'h2: // req 1
                begin
                processor_combs__apb_req__read_not_write__var = 1'h0;
                processor_combs__apb_req__wdata__var = processor_state__accumulator;
                end
            2'h1: // req 1
                begin
                processor_combs__apb_req__read_not_write__var = 1'h0;
                processor_combs__apb_req__wdata__var = processor_combs__arg_data;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:apb_processor:processor_execute_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            end
        4'h7: // req 1
            begin
            if ((apb_combs__completing_request!=1'h0))
            begin
                processor_combs__completes_op__var = 1'h1;
            end //if
            end
        4'h3: // req 1
            begin
            processor_combs__completes_op__var = 1'h1;
            end
        4'h4: // req 1
            begin
            case (processor_combs__opcode_subclass[2:0]) //synopsys parallel_case
            3'h0: // req 1
                begin
                processor_combs__take_branch__var = 1'h1;
                end
            3'h1: // req 1
                begin
                processor_combs__take_branch__var = processor_combs__acc_is_zero;
                end
            3'h2: // req 1
                begin
                processor_combs__take_branch__var = !(processor_combs__acc_is_zero!=1'h0);
                end
            3'h3: // req 1
                begin
                processor_combs__take_branch__var = !(processor_combs__rpt_is_zero!=1'h0);
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:apb_processor:processor_execute_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            processor_combs__completes_op__var = 1'h1;
            end
        4'h9: // req 1
            begin
            processor_combs__completes_op__var = 1'h1;
            processor_combs__finishing__var = 1'h1;
            end
        4'h5: // req 1
            begin
            end
        4'h8: // req 1
            begin
            processor_combs__completes_op__var = 1'h1;
            end
        4'h6: // req 1
            begin
            end
        4'h0: // req 1
            begin
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:apb_processor:processor_execute_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        processor_combs__action = processor_combs__action__var;
        processor_combs__take_branch = processor_combs__take_branch__var;
        processor_combs__completes_op = processor_combs__completes_op__var;
        processor_combs__finishing = processor_combs__finishing__var;
        processor_combs__apb_req__valid = processor_combs__apb_req__valid__var;
        processor_combs__apb_req__read_not_write = processor_combs__apb_req__read_not_write__var;
        processor_combs__apb_req__wdata = processor_combs__apb_req__wdata__var;
    end //always

    //b processor_execute_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       Break out the ROM state data, and determine some simple flags
        //       (e.g. @a acc_is_zero).
        //   
        //       From the processor FSM state, determine the action to take. The
        //       processor will be in 'idle' if it is ready to start processing of
        //       the ROM opcode being presented. Hence most actions are just a
        //       decode, when in idle, of the incoming opcode class. However, if
        //       the processor FSM is indicating an APB request in process then the
        //       processor action is pending the APB request; if the processor is
        //       handling a wait delay then either decrement the accumulator or (if
        //       it is zero) complete the wait instruction.
        //   
        //       Handling the processor action is the essence of executing the
        //       opcode classes, generally; most will complete the opcode execution
        //       and return the processor FSM to idle. A pending APB request will
        //       need to wait for the APB state machine to complete, and it may
        //       (for APB reads) capture the APB @a prdata in the accumulator. A
        //       wait start will cause the delay to be written to the accumulator,
        //       and wait steps are then to decrement the accumulator or simply
        //       complete (if the accumulator is zero). A branch will complete,
        //       while indicating to the ROM state machine to take the branch if
        //       necessary.
        //       
    always @( posedge clk or negedge reset_n)
    begin : processor_execute_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            processor_state__address <= 32'h0;
            processor_state__repeat_count <= 32'h0;
            processor_state__accumulator <= 32'h0;
            processor_state__fsm_state <= 2'h0;
            processor_state__fsm_state <= 2'h0;
        end
        else if (clk__enable)
        begin
            case (processor_combs__action) //synopsys parallel_case
            4'h1: // req 1
                begin
                case (processor_combs__opcode_subclass[2:0]) //synopsys parallel_case
                3'h0: // req 1
                    begin
                    processor_state__address <= processor_combs__arg_data;
                    end
                3'h1: // req 1
                    begin
                    processor_state__repeat_count <= processor_combs__arg_data;
                    end
                3'h2: // req 1
                    begin
                    processor_state__accumulator <= processor_combs__arg_data;
                    end
    //synopsys  translate_off
    //pragma coverage off
                default:
                    begin
                        if (1)
                        begin
                            $display("%t *********CDL ASSERTION FAILURE:apb_processor:processor_execute_logic: Full switch statement did not cover all values", $time);
                        end
                    end
    //pragma coverage on
    //synopsys  translate_on
                endcase
                processor_state__fsm_state <= 2'h0;
                end
            4'h2: // req 1
                begin
                processor_state__fsm_state <= 2'h1;
                end
            4'h7: // req 1
                begin
                if ((apb_combs__completing_request!=1'h0))
                begin
                    if ((processor_combs__opcode_subclass[2]!=1'h0))
                    begin
                        processor_state__address <= (processor_state__address+32'h1);
                    end //if
                    if (!(apb_request__pwrite!=1'h0))
                    begin
                        processor_state__accumulator <= apb_response__prdata;
                    end //if
                    processor_state__fsm_state <= 2'h0;
                end //if
                end
            4'h3: // req 1
                begin
                case (processor_combs__opcode_subclass[2:0]) //synopsys parallel_case
                3'h0: // req 1
                    begin
                    processor_state__accumulator <= (processor_state__accumulator | processor_combs__arg_data);
                    end
                3'h1: // req 1
                    begin
                    processor_state__accumulator <= (processor_state__accumulator & processor_combs__arg_data);
                    end
                3'h2: // req 1
                    begin
                    processor_state__accumulator <= (processor_state__accumulator & ~processor_combs__arg_data);
                    end
                3'h3: // req 1
                    begin
                    processor_state__accumulator <= (processor_state__accumulator ^ processor_combs__arg_data);
                    end
                3'h4: // req 1
                    begin
                    processor_state__accumulator <= (processor_state__accumulator+processor_combs__arg_data);
                    end
    //synopsys  translate_off
    //pragma coverage off
                default:
                    begin
                        if (1)
                        begin
                            $display("%t *********CDL ASSERTION FAILURE:apb_processor:processor_execute_logic: Full switch statement did not cover all values", $time);
                        end
                    end
    //pragma coverage on
    //synopsys  translate_on
                endcase
                processor_state__fsm_state <= 2'h0;
                end
            4'h4: // req 1
                begin
                case (processor_combs__opcode_subclass[2:0]) //synopsys parallel_case
                3'h0: // req 1
                    begin
                    end
                3'h1: // req 1
                    begin
                    end
                3'h2: // req 1
                    begin
                    end
                3'h3: // req 1
                    begin
                    processor_state__repeat_count <= (processor_state__repeat_count-32'h1);
                    end
    //synopsys  translate_off
    //pragma coverage off
                default:
                    begin
                        if (1)
                        begin
                            $display("%t *********CDL ASSERTION FAILURE:apb_processor:processor_execute_logic: Full switch statement did not cover all values", $time);
                        end
                    end
    //pragma coverage on
    //synopsys  translate_on
                endcase
                processor_state__fsm_state <= 2'h0;
                end
            4'h9: // req 1
                begin
                processor_state__fsm_state <= 2'h0;
                end
            4'h5: // req 1
                begin
                processor_state__accumulator <= processor_combs__arg_data;
                processor_state__fsm_state <= 2'h2;
                end
            4'h8: // req 1
                begin
                processor_state__fsm_state <= 2'h0;
                end
            4'h6: // req 1
                begin
                processor_state__accumulator <= (processor_state__accumulator-32'h1);
                processor_state__fsm_state <= processor_state__fsm_state;
                end
            4'h0: // req 1
                begin
                processor_state__fsm_state <= processor_state__fsm_state;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:apb_processor:processor_execute_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
    end //always

    //b apb_master_logic__comb combinatorial process
        //   
        //       The APB master interface accepts a request from the processor and
        //       drives the signals as required by the APB spec, waiting for pready
        //       to complete. It always has at least one dead cycle between
        //       presenting APB requests, as it will have to transition from idle,
        //       to the select phase, to the enable phase, then back to idle.
        //   
        //       The logic is simple enough - an incoming request (which should
        //       only be valid when the APB state machine is idle) causes an APB
        //       read or write to start, to the @a paddr in the processor's APB
        //       address register, using @a pwdata required by the processor
        //       (either the accumulator or the ROM data[32;0]). The request out is
        //       registered, and so when the APB FSM is in its select phase, the
        //       APB request on the bus has @a psel asserted and @a penable
        //       deasserted. In the enable phase of the FSM, the APB request out
        //       will have @a psel asserted and @a penable asserted, and be waiting
        //       for @a pready to be asserted.
        //       
    always @ ( * )//apb_master_logic__comb
    begin: apb_master_logic__comb_code
    reg [2:0]apb_combs__action__var;
    reg apb_combs__completing_request__var;
        apb_combs__action__var = 3'h0;
        case (apb_state__fsm_state) //synopsys parallel_case
        2'h0: // req 1
            begin
            if ((processor_combs__apb_req__valid!=1'h0))
            begin
                apb_combs__action__var = ((processor_combs__apb_req__read_not_write!=1'h0)?3'h2:3'h1);
            end //if
            end
        2'h1: // req 1
            begin
            apb_combs__action__var = 3'h3;
            end
        2'h2: // req 1
            begin
            if ((apb_response__pready!=1'h0))
            begin
                apb_combs__action__var = 3'h4;
            end //if
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:apb_processor:apb_master_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        apb_combs__completing_request__var = 1'h0;
        case (apb_combs__action__var) //synopsys parallel_case
        3'h1: // req 1
            begin
            end
        3'h2: // req 1
            begin
            end
        3'h3: // req 1
            begin
            end
        3'h4: // req 1
            begin
            apb_combs__completing_request__var = 1'h1;
            end
        3'h0: // req 1
            begin
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:apb_processor:apb_master_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        apb_combs__action = apb_combs__action__var;
        apb_combs__completing_request = apb_combs__completing_request__var;
    end //always

    //b apb_master_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The APB master interface accepts a request from the processor and
        //       drives the signals as required by the APB spec, waiting for pready
        //       to complete. It always has at least one dead cycle between
        //       presenting APB requests, as it will have to transition from idle,
        //       to the select phase, to the enable phase, then back to idle.
        //   
        //       The logic is simple enough - an incoming request (which should
        //       only be valid when the APB state machine is idle) causes an APB
        //       read or write to start, to the @a paddr in the processor's APB
        //       address register, using @a pwdata required by the processor
        //       (either the accumulator or the ROM data[32;0]). The request out is
        //       registered, and so when the APB FSM is in its select phase, the
        //       APB request on the bus has @a psel asserted and @a penable
        //       deasserted. In the enable phase of the FSM, the APB request out
        //       will have @a psel asserted and @a penable asserted, and be waiting
        //       for @a pready to be asserted.
        //       
    always @( posedge clk or negedge reset_n)
    begin : apb_master_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            apb_state__fsm_state <= 2'h0;
            apb_state__fsm_state <= 2'h0;
            apb_request__psel <= 1'h0;
            apb_request__penable <= 1'h0;
            apb_request__pwrite <= 1'h0;
            apb_request__paddr <= 32'h0;
            apb_request__pwdata <= 32'h0;
        end
        else if (clk__enable)
        begin
            case (apb_combs__action) //synopsys parallel_case
            3'h1: // req 1
                begin
                apb_state__fsm_state <= 2'h1;
                apb_request__psel <= 1'h1;
                apb_request__penable <= 1'h0;
                apb_request__pwrite <= 1'h1;
                apb_request__paddr <= processor_state__address;
                apb_request__pwdata <= processor_combs__apb_req__wdata;
                end
            3'h2: // req 1
                begin
                apb_state__fsm_state <= 2'h1;
                apb_request__psel <= 1'h1;
                apb_request__penable <= 1'h0;
                apb_request__pwrite <= 1'h0;
                apb_request__paddr <= processor_state__address;
                end
            3'h3: // req 1
                begin
                apb_request__penable <= 1'h1;
                apb_state__fsm_state <= 2'h2;
                end
            3'h4: // req 1
                begin
                apb_request__psel <= 1'h0;
                apb_request__penable <= 1'h0;
                apb_state__fsm_state <= 2'h0;
                end
            3'h0: // req 1
                begin
                apb_state__fsm_state <= apb_state__fsm_state;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:apb_processor:apb_master_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
    end //always

endmodule // apb_processor
