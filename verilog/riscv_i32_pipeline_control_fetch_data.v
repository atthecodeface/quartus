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

//a Module riscv_i32_pipeline_control_fetch_data
module riscv_i32_pipeline_control_fetch_data
(

    ifetch_resp__valid,
    ifetch_resp__debug,
    ifetch_resp__data,
    ifetch_resp__mode,
    ifetch_resp__error,
    ifetch_resp__tag,
    ifetch_req__valid,
    ifetch_req__address,
    ifetch_req__sequential,
    ifetch_req__mode,
    ifetch_req__predicted_branch,
    ifetch_req__pc_if_mispredicted,
    ifetch_req__flush_pipeline,
    pipeline_control__valid,
    pipeline_control__debug,
    pipeline_control__fetch_action,
    pipeline_control__decode_pc,
    pipeline_control__mode,
    pipeline_control__error,
    pipeline_control__tag,
    pipeline_control__interrupt_req,
    pipeline_control__interrupt_number,
    pipeline_control__interrupt_to_mode,

    pipeline_fetch_data__valid,
    pipeline_fetch_data__pc,
    pipeline_fetch_data__data,
    pipeline_fetch_data__dec_flush_pipeline,
    pipeline_fetch_data__dec_predicted_branch,
    pipeline_fetch_data__dec_pc_if_mispredicted
);

    //b Clocks

    //b Inputs
    input ifetch_resp__valid;
    input ifetch_resp__debug;
    input [31:0]ifetch_resp__data;
    input [2:0]ifetch_resp__mode;
    input ifetch_resp__error;
    input [1:0]ifetch_resp__tag;
    input ifetch_req__valid;
    input [31:0]ifetch_req__address;
    input ifetch_req__sequential;
    input [2:0]ifetch_req__mode;
    input ifetch_req__predicted_branch;
    input [31:0]ifetch_req__pc_if_mispredicted;
    input ifetch_req__flush_pipeline;
    input pipeline_control__valid;
    input pipeline_control__debug;
    input [1:0]pipeline_control__fetch_action;
    input [31:0]pipeline_control__decode_pc;
    input [2:0]pipeline_control__mode;
    input pipeline_control__error;
    input [1:0]pipeline_control__tag;
    input pipeline_control__interrupt_req;
    input [3:0]pipeline_control__interrupt_number;
    input [2:0]pipeline_control__interrupt_to_mode;

    //b Outputs
    output pipeline_fetch_data__valid;
    output [31:0]pipeline_fetch_data__pc;
    output [31:0]pipeline_fetch_data__data;
    output pipeline_fetch_data__dec_flush_pipeline;
    output pipeline_fetch_data__dec_predicted_branch;
    output [31:0]pipeline_fetch_data__dec_pc_if_mispredicted;

// output components here

    //b Output combinatorials
    reg pipeline_fetch_data__valid;
    reg [31:0]pipeline_fetch_data__pc;
    reg [31:0]pipeline_fetch_data__data;
    reg pipeline_fetch_data__dec_flush_pipeline;
    reg pipeline_fetch_data__dec_predicted_branch;
    reg [31:0]pipeline_fetch_data__dec_pc_if_mispredicted;

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b pipeline_control_logic combinatorial process
        //   
        //       The instruction fetch request derives from the
        //       decode/execute stage (the instruction address that is required
        //       next) and presents that to the outside world.
        //   
        //       This request may be for any 16-bit aligned address, and two
        //       successive 16-bit words from that request must be presented,
        //       aligned to bit 0.
        //   
        //       If the decode/execute stage is invalid (i.e. it does not have a
        //       valid instruction to decode) then the current PC is requested.
        //       
    always @ ( * )//pipeline_control_logic
    begin: pipeline_control_logic__comb_code
        pipeline_fetch_data__valid = (((pipeline_control__valid!=1'h0)&&(ifetch_req__valid!=1'h0))&&(ifetch_resp__valid!=1'h0));
        pipeline_fetch_data__pc = ifetch_req__address;
        pipeline_fetch_data__data = ifetch_resp__data;
        pipeline_fetch_data__dec_pc_if_mispredicted = ifetch_req__pc_if_mispredicted;
        pipeline_fetch_data__dec_predicted_branch = ifetch_req__predicted_branch;
        pipeline_fetch_data__dec_flush_pipeline = ifetch_req__flush_pipeline;
    end //always

endmodule // riscv_i32_pipeline_control_fetch_data
