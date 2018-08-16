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

//a Module riscv_i32_pipeline_debug
    //   
    //   This is a fully synchronous pipeline debug module. 
    //   
    //   It is designed to feed data in to a RISC-V pipeline (being merged with
    //   instruction fetch responses), and it takes commands and reports out to
    //   a RISC-V debug module.
    //   
    //   
module riscv_i32_pipeline_debug
(
    clk,
    clk__enable,

    rv_select,
    debug_response__exec_valid,
    debug_response__exec_halting,
    debug_response__exec_dret,
    debug_mst__valid,
    debug_mst__select,
    debug_mst__mask,
    debug_mst__op,
    debug_mst__arg,
    debug_mst__data,
    reset_n,

    debug_control__valid,
    debug_control__kill_fetch,
    debug_control__halt_request,
    debug_control__fetch_dret,
    debug_control__data,
    debug_tgt__valid,
    debug_tgt__selected,
    debug_tgt__halted,
    debug_tgt__resumed,
    debug_tgt__hit_breakpoint,
    debug_tgt__op_was_none,
    debug_tgt__resp,
    debug_tgt__data,
    debug_tgt__attention
);

    //b Clocks
    input clk;
    input clk__enable;

    //b Inputs
    input [5:0]rv_select;
    input debug_response__exec_valid;
    input debug_response__exec_halting;
    input debug_response__exec_dret;
    input debug_mst__valid;
    input [5:0]debug_mst__select;
    input [5:0]debug_mst__mask;
    input [3:0]debug_mst__op;
    input [15:0]debug_mst__arg;
    input [31:0]debug_mst__data;
    input reset_n;

    //b Outputs
    output debug_control__valid;
    output debug_control__kill_fetch;
    output debug_control__halt_request;
    output debug_control__fetch_dret;
    output [31:0]debug_control__data;
    output debug_tgt__valid;
    output [5:0]debug_tgt__selected;
    output debug_tgt__halted;
    output debug_tgt__resumed;
    output debug_tgt__hit_breakpoint;
    output debug_tgt__op_was_none;
    output debug_tgt__resp;
    output [31:0]debug_tgt__data;
    output debug_tgt__attention;

// output components here

    //b Output combinatorials
    reg debug_control__valid;
    reg debug_control__kill_fetch;
    reg debug_control__halt_request;
    reg debug_control__fetch_dret;
    reg [31:0]debug_control__data;
    reg debug_tgt__valid;
    reg [5:0]debug_tgt__selected;
    reg debug_tgt__halted;
    reg debug_tgt__resumed;
    reg debug_tgt__hit_breakpoint;
    reg debug_tgt__op_was_none;
    reg debug_tgt__resp;
    reg [31:0]debug_tgt__data;
    reg debug_tgt__attention;

    //b Output nets

    //b Internal and output registers
    reg [1:0]debug_state__fsm_state;
    reg debug_state__drive_attention;
    reg debug_state__drive_response;
    reg debug_state__halt_req;
    reg debug_state__resume_req;
    reg debug_state__halted;
    reg debug_state__resumed;
    reg debug_state__attention;
    reg debug_state__hit_breakpoint;
    reg [15:0]debug_state__arg;
    reg debug_state__resp;
    reg [31:0]debug_state__data0;

    //b Internal combinatorials
    reg debug_combs__mst_valid;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b pipeline_control combinatorial process
        //   
        //       
    always @ ( * )//pipeline_control
    begin: pipeline_control__comb_code
    reg debug_control__valid__var;
    reg debug_control__kill_fetch__var;
    reg debug_control__halt_request__var;
    reg debug_control__fetch_dret__var;
    reg [31:0]debug_control__data__var;
        debug_control__valid__var = 1'h0;
        debug_control__kill_fetch__var = 1'h0;
        debug_control__halt_request__var = 1'h0;
        debug_control__fetch_dret__var = 1'h0;
        debug_control__data__var = 32'h0;
        debug_control__valid__var = 1'h0;
        debug_control__data__var = debug_state__data0;
        debug_control__kill_fetch__var = 1'h0;
        debug_control__halt_request__var = 1'h0;
        case (debug_state__fsm_state) //synopsys parallel_case
        2'h0: // req 1
            begin
            debug_control__kill_fetch__var = 1'h0;
            end
        2'h1: // req 1
            begin
            debug_control__valid__var = 1'h1;
            debug_control__kill_fetch__var = 1'h1;
            debug_control__halt_request__var = 1'h1;
            end
        2'h2: // req 1
            begin
            debug_control__valid__var = 1'h1;
            debug_control__kill_fetch__var = 1'h1;
            end
        2'h3: // req 1
            begin
            debug_control__valid__var = 1'h1;
            debug_control__fetch_dret__var = 1'h1;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:riscv_i32_pipeline_debug:pipeline_control: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        debug_control__valid = debug_control__valid__var;
        debug_control__kill_fetch = debug_control__kill_fetch__var;
        debug_control__halt_request = debug_control__halt_request__var;
        debug_control__fetch_dret = debug_control__fetch_dret__var;
        debug_control__data = debug_control__data__var;
    end //always

    //b debug_state_machine__comb combinatorial process
        //   
        //       
    always @ ( * )//debug_state_machine__comb
    begin: debug_state_machine__comb_code
    reg debug_combs__mst_valid__var;
        debug_combs__mst_valid__var = debug_mst__valid;
        if ((debug_mst__select!=rv_select))
        begin
            debug_combs__mst_valid__var = 1'h0;
        end //if
        debug_combs__mst_valid = debug_combs__mst_valid__var;
    end //always

    //b debug_state_machine__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : debug_state_machine__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            debug_state__attention <= 1'h0;
            debug_state__halt_req <= 1'h0;
            debug_state__resume_req <= 1'h0;
            debug_state__arg <= 16'h0;
            debug_state__data0 <= 32'h0;
            debug_state__resp <= 1'h0;
            debug_state__resumed <= 1'h0;
            debug_state__fsm_state <= 2'h0;
            debug_state__halted <= 1'h0;
            debug_state__hit_breakpoint <= 1'h0;
        end
        else if (clk__enable)
        begin
            if ((debug_combs__mst_valid!=1'h0))
            begin
                debug_state__attention <= 1'h0;
                if ((debug_mst__op==4'h0))
                begin
                    debug_state__halt_req <= debug_mst__arg[0];
                    debug_state__resume_req <= debug_mst__arg[1];
                end //if
                if ((debug_mst__op==4'h1))
                begin
                    debug_state__arg <= debug_mst__arg;
                    debug_state__data0 <= debug_mst__data;
                end //if
            end //if
            debug_state__resp <= 1'h0;
            if (((debug_state__resumed!=1'h0)&&!(debug_state__resume_req!=1'h0)))
            begin
                debug_state__resumed <= 1'h0;
                debug_state__attention <= 1'h1;
            end //if
            case (debug_state__fsm_state) //synopsys parallel_case
            2'h0: // req 1
                begin
                if ((debug_state__halt_req!=1'h0))
                begin
                    debug_state__fsm_state <= 2'h1;
                end //if
                if (((debug_response__exec_valid!=1'h0)&&(debug_response__exec_halting!=1'h0)))
                begin
                    debug_state__fsm_state <= 2'h2;
                    debug_state__halted <= 1'h1;
                    debug_state__hit_breakpoint <= 1'h1;
                    debug_state__attention <= 1'h1;
                end //if
                end
            2'h1: // req 1
                begin
                if (((debug_response__exec_valid!=1'h0)&&(debug_response__exec_halting!=1'h0)))
                begin
                    debug_state__fsm_state <= 2'h2;
                    debug_state__halted <= 1'h1;
                    debug_state__attention <= 1'h1;
                end //if
                end
            2'h2: // req 1
                begin
                if (((debug_state__resume_req!=1'h0)&&!(debug_state__resumed!=1'h0)))
                begin
                    debug_state__fsm_state <= 2'h3;
                end //if
                end
            2'h3: // req 1
                begin
                if (((debug_response__exec_valid!=1'h0)&&(debug_response__exec_dret!=1'h0)))
                begin
                    debug_state__fsm_state <= 2'h0;
                    debug_state__hit_breakpoint <= 1'h0;
                    debug_state__halted <= 1'h0;
                    debug_state__resumed <= 1'h1;
                    debug_state__attention <= 1'h1;
                end //if
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:riscv_i32_pipeline_debug:debug_state_machine: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
    end //always

    //b debug_response_driving__comb combinatorial process
        //   
        //       
    always @ ( * )//debug_response_driving__comb
    begin: debug_response_driving__comb_code
    reg debug_tgt__valid__var;
    reg [5:0]debug_tgt__selected__var;
    reg debug_tgt__halted__var;
    reg debug_tgt__resumed__var;
    reg debug_tgt__hit_breakpoint__var;
    reg debug_tgt__resp__var;
    reg [31:0]debug_tgt__data__var;
    reg debug_tgt__attention__var;
        debug_tgt__valid__var = 1'h0;
        debug_tgt__selected__var = 6'h0;
        debug_tgt__halted__var = 1'h0;
        debug_tgt__resumed__var = 1'h0;
        debug_tgt__hit_breakpoint__var = 1'h0;
        debug_tgt__op_was_none = 1'h0;
        debug_tgt__resp__var = 1'h0;
        debug_tgt__data__var = 32'h0;
        debug_tgt__attention__var = 1'h0;
        if ((debug_state__drive_attention!=1'h0))
        begin
            debug_tgt__attention__var = debug_state__attention;
        end //if
        if ((debug_state__drive_response!=1'h0))
        begin
            debug_tgt__valid__var = 1'h1;
            debug_tgt__selected__var = rv_select;
            debug_tgt__halted__var = debug_state__halted;
            debug_tgt__resumed__var = debug_state__resumed;
            debug_tgt__hit_breakpoint__var = debug_state__hit_breakpoint;
            debug_tgt__resp__var = debug_state__resp;
            debug_tgt__data__var = debug_state__data0;
        end //if
        debug_tgt__valid = debug_tgt__valid__var;
        debug_tgt__selected = debug_tgt__selected__var;
        debug_tgt__halted = debug_tgt__halted__var;
        debug_tgt__resumed = debug_tgt__resumed__var;
        debug_tgt__hit_breakpoint = debug_tgt__hit_breakpoint__var;
        debug_tgt__resp = debug_tgt__resp__var;
        debug_tgt__data = debug_tgt__data__var;
        debug_tgt__attention = debug_tgt__attention__var;
    end //always

    //b debug_response_driving__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : debug_response_driving__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            debug_state__drive_attention <= 1'h0;
            debug_state__drive_response <= 1'h0;
        end
        else if (clk__enable)
        begin
            debug_state__drive_attention <= 1'h0;
            debug_state__drive_response <= 1'h0;
            if (((debug_mst__mask & rv_select)==debug_mst__select))
            begin
                debug_state__drive_attention <= 1'h1;
            end //if
            if (((debug_mst__valid!=1'h0)&&(rv_select==debug_mst__select)))
            begin
                debug_state__drive_response <= 1'h1;
            end //if
        end //if
    end //always

endmodule // riscv_i32_pipeline_debug
