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

//a Module riscv_i32_fetch_debug
    //   
    //   
    //   
module riscv_i32_fetch_debug
(

    ifetch_resp__valid,
    ifetch_resp__debug,
    ifetch_resp__data,
    ifetch_resp__mode,
    ifetch_resp__error,
    ifetch_resp__tag,
    debug_control__valid,
    debug_control__kill_fetch,
    debug_control__halt_request,
    debug_control__fetch_dret,
    debug_control__data,
    pipeline_trace__instr_valid,
    pipeline_trace__instr_pc,
    pipeline_trace__instruction__mode,
    pipeline_trace__instruction__data,
    pipeline_trace__rfw_retire,
    pipeline_trace__rfw_data_valid,
    pipeline_trace__rfw_rd,
    pipeline_trace__rfw_data,
    pipeline_trace__branch_taken,
    pipeline_trace__branch_target,
    pipeline_trace__trap,
    pipeline_ifetch_req__valid,
    pipeline_ifetch_req__address,
    pipeline_ifetch_req__sequential,
    pipeline_ifetch_req__mode,
    pipeline_ifetch_req__flush,

    ifetch_req__valid,
    ifetch_req__address,
    ifetch_req__sequential,
    ifetch_req__mode,
    ifetch_req__flush,
    debug_response__valid,
    debug_response__kill_fetch,
    debug_response__halt_request,
    debug_response__fetch_dret,
    debug_response__data,
    pipeline_ifetch_resp__valid,
    pipeline_ifetch_resp__debug,
    pipeline_ifetch_resp__data,
    pipeline_ifetch_resp__mode,
    pipeline_ifetch_resp__error,
    pipeline_ifetch_resp__tag
);

    //b Clocks

    //b Inputs
    input ifetch_resp__valid;
    input ifetch_resp__debug;
    input [31:0]ifetch_resp__data;
    input [2:0]ifetch_resp__mode;
    input ifetch_resp__error;
    input [1:0]ifetch_resp__tag;
    input debug_control__valid;
    input debug_control__kill_fetch;
    input debug_control__halt_request;
    input debug_control__fetch_dret;
    input [31:0]debug_control__data;
    input pipeline_trace__instr_valid;
    input [31:0]pipeline_trace__instr_pc;
    input [2:0]pipeline_trace__instruction__mode;
    input [31:0]pipeline_trace__instruction__data;
    input pipeline_trace__rfw_retire;
    input pipeline_trace__rfw_data_valid;
    input [4:0]pipeline_trace__rfw_rd;
    input [31:0]pipeline_trace__rfw_data;
    input pipeline_trace__branch_taken;
    input [31:0]pipeline_trace__branch_target;
    input pipeline_trace__trap;
    input pipeline_ifetch_req__valid;
    input [31:0]pipeline_ifetch_req__address;
    input pipeline_ifetch_req__sequential;
    input [2:0]pipeline_ifetch_req__mode;
    input pipeline_ifetch_req__flush;

    //b Outputs
    output ifetch_req__valid;
    output [31:0]ifetch_req__address;
    output ifetch_req__sequential;
    output [2:0]ifetch_req__mode;
    output ifetch_req__flush;
    output debug_response__valid;
    output debug_response__kill_fetch;
    output debug_response__halt_request;
    output debug_response__fetch_dret;
    output [31:0]debug_response__data;
    output pipeline_ifetch_resp__valid;
    output pipeline_ifetch_resp__debug;
    output [31:0]pipeline_ifetch_resp__data;
    output [2:0]pipeline_ifetch_resp__mode;
    output pipeline_ifetch_resp__error;
    output [1:0]pipeline_ifetch_resp__tag;

// output components here

    //b Output combinatorials
    reg ifetch_req__valid;
    reg [31:0]ifetch_req__address;
    reg ifetch_req__sequential;
    reg [2:0]ifetch_req__mode;
    reg ifetch_req__flush;
    reg debug_response__valid;
    reg debug_response__kill_fetch;
    reg debug_response__halt_request;
    reg debug_response__fetch_dret;
    reg [31:0]debug_response__data;
    reg pipeline_ifetch_resp__valid;
    reg pipeline_ifetch_resp__debug;
    reg [31:0]pipeline_ifetch_resp__data;
    reg [2:0]pipeline_ifetch_resp__mode;
    reg pipeline_ifetch_resp__error;
    reg [1:0]pipeline_ifetch_resp__tag;

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b fetch_debug_operation combinatorial process
        //   
        //       
    always @ ( * )//fetch_debug_operation
    begin: fetch_debug_operation__comb_code
        ifetch_req__valid = pipeline_ifetch_req__valid;
        ifetch_req__address = pipeline_ifetch_req__address;
        ifetch_req__sequential = pipeline_ifetch_req__sequential;
        ifetch_req__mode = pipeline_ifetch_req__mode;
        ifetch_req__flush = pipeline_ifetch_req__flush;
        pipeline_ifetch_resp__valid = ifetch_resp__valid;
        pipeline_ifetch_resp__debug = ifetch_resp__debug;
        pipeline_ifetch_resp__data = ifetch_resp__data;
        pipeline_ifetch_resp__mode = ifetch_resp__mode;
        pipeline_ifetch_resp__error = ifetch_resp__error;
        pipeline_ifetch_resp__tag = ifetch_resp__tag;
        debug_response__valid = 1'h0;
        debug_response__kill_fetch = 1'h0;
        debug_response__halt_request = 1'h0;
        debug_response__fetch_dret = 1'h0;
        debug_response__data = 32'h0;
    end //always

endmodule // riscv_i32_fetch_debug
