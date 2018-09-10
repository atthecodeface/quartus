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

//a Module riscv_minimal_debug
    //   
    //   
module riscv_minimal_debug
(
    clk,
    clk__enable,

    rv_select,
    riscv_config__i32c,
    riscv_config__e32,
    riscv_config__i32m,
    riscv_config__i32m_fuse,
    riscv_config__coproc_disable,
    riscv_config__unaligned_mem,
    debug_mst__valid,
    debug_mst__select,
    debug_mst__mask,
    debug_mst__op,
    debug_mst__arg,
    debug_mst__data,
    ifetch_resp__valid,
    ifetch_resp__debug,
    ifetch_resp__data,
    ifetch_resp__mode,
    ifetch_resp__error,
    ifetch_resp__tag,
    dmem_access_resp__wait,
    dmem_access_resp__read_data,
    reset_n,

    trace__instr_valid,
    trace__instr_pc,
    trace__instruction__mode,
    trace__instruction__data,
    trace__rfw_retire,
    trace__rfw_data_valid,
    trace__rfw_rd,
    trace__rfw_data,
    trace__branch_taken,
    trace__branch_target,
    trace__trap,
    debug_tgt__valid,
    debug_tgt__selected,
    debug_tgt__halted,
    debug_tgt__resumed,
    debug_tgt__hit_breakpoint,
    debug_tgt__op_was_none,
    debug_tgt__resp,
    debug_tgt__data,
    debug_tgt__attention,
    ifetch_req__valid,
    ifetch_req__address,
    ifetch_req__sequential,
    ifetch_req__mode,
    ifetch_req__flush,
    dmem_access_req__address,
    dmem_access_req__byte_enable,
    dmem_access_req__write_enable,
    dmem_access_req__read_enable,
    dmem_access_req__write_data
);

    //b Clocks
    input clk;
    input clk__enable;

    //b Inputs
    input [5:0]rv_select;
    input riscv_config__i32c;
    input riscv_config__e32;
    input riscv_config__i32m;
    input riscv_config__i32m_fuse;
    input riscv_config__coproc_disable;
    input riscv_config__unaligned_mem;
        //   Driven by debug module to all RISC-V cores
    input debug_mst__valid;
    input [5:0]debug_mst__select;
    input [5:0]debug_mst__mask;
    input [3:0]debug_mst__op;
    input [15:0]debug_mst__arg;
    input [31:0]debug_mst__data;
    input ifetch_resp__valid;
    input ifetch_resp__debug;
    input [31:0]ifetch_resp__data;
    input [2:0]ifetch_resp__mode;
    input ifetch_resp__error;
    input [1:0]ifetch_resp__tag;
    input dmem_access_resp__wait;
    input [31:0]dmem_access_resp__read_data;
    input reset_n;

    //b Outputs
    output trace__instr_valid;
    output [31:0]trace__instr_pc;
    output [2:0]trace__instruction__mode;
    output [31:0]trace__instruction__data;
    output trace__rfw_retire;
    output trace__rfw_data_valid;
    output [4:0]trace__rfw_rd;
    output [31:0]trace__rfw_data;
    output trace__branch_taken;
    output [31:0]trace__branch_target;
    output trace__trap;
        //   Wired-or response bus from all RISC-V cores
    output debug_tgt__valid;
    output [5:0]debug_tgt__selected;
    output debug_tgt__halted;
    output debug_tgt__resumed;
    output debug_tgt__hit_breakpoint;
    output debug_tgt__op_was_none;
    output debug_tgt__resp;
    output [31:0]debug_tgt__data;
    output debug_tgt__attention;
    output ifetch_req__valid;
    output [31:0]ifetch_req__address;
    output ifetch_req__sequential;
    output [2:0]ifetch_req__mode;
    output ifetch_req__flush;
    output [31:0]dmem_access_req__address;
    output [3:0]dmem_access_req__byte_enable;
    output dmem_access_req__write_enable;
    output dmem_access_req__read_enable;
    output [31:0]dmem_access_req__write_data;

// output components here

    //b Output combinatorials

    //b Output nets
    wire trace__instr_valid;
    wire [31:0]trace__instr_pc;
    wire [2:0]trace__instruction__mode;
    wire [31:0]trace__instruction__data;
    wire trace__rfw_retire;
    wire trace__rfw_data_valid;
    wire [4:0]trace__rfw_rd;
    wire [31:0]trace__rfw_data;
    wire trace__branch_taken;
    wire [31:0]trace__branch_target;
    wire trace__trap;
        //   Wired-or response bus from all RISC-V cores
    wire debug_tgt__valid;
    wire [5:0]debug_tgt__selected;
    wire debug_tgt__halted;
    wire debug_tgt__resumed;
    wire debug_tgt__hit_breakpoint;
    wire debug_tgt__op_was_none;
    wire debug_tgt__resp;
    wire [31:0]debug_tgt__data;
    wire debug_tgt__attention;
    wire ifetch_req__valid;
    wire [31:0]ifetch_req__address;
    wire ifetch_req__sequential;
    wire [2:0]ifetch_req__mode;
    wire ifetch_req__flush;
    wire [31:0]dmem_access_req__address;
    wire [3:0]dmem_access_req__byte_enable;
    wire dmem_access_req__write_enable;
    wire dmem_access_req__read_enable;
    wire [31:0]dmem_access_req__write_data;

    //b Internal and output registers

    //b Internal combinatorials
    reg coproc_response__cannot_start;
    reg [31:0]coproc_response__result;
    reg coproc_response__result_valid;
    reg coproc_response__cannot_complete;

    //b Internal nets
    wire debug_response__exec_valid;
    wire debug_response__exec_halting;
    wire debug_response__exec_dret;
    wire debug_control__valid;
    wire debug_control__kill_fetch;
    wire debug_control__halt_request;
    wire debug_control__fetch_dret;
    wire [31:0]debug_control__data;
    wire coproc_controls__dec_idecode_valid;
    wire [4:0]coproc_controls__dec_idecode__rs1;
    wire coproc_controls__dec_idecode__rs1_valid;
    wire [4:0]coproc_controls__dec_idecode__rs2;
    wire coproc_controls__dec_idecode__rs2_valid;
    wire [4:0]coproc_controls__dec_idecode__rd;
    wire coproc_controls__dec_idecode__rd_written;
    wire [2:0]coproc_controls__dec_idecode__csr_access__access;
    wire [11:0]coproc_controls__dec_idecode__csr_access__address;
    wire [31:0]coproc_controls__dec_idecode__immediate;
    wire [4:0]coproc_controls__dec_idecode__immediate_shift;
    wire coproc_controls__dec_idecode__immediate_valid;
    wire [3:0]coproc_controls__dec_idecode__op;
    wire [3:0]coproc_controls__dec_idecode__subop;
    wire coproc_controls__dec_idecode__requires_machine_mode;
    wire coproc_controls__dec_idecode__memory_read_unsigned;
    wire [1:0]coproc_controls__dec_idecode__memory_width;
    wire coproc_controls__dec_idecode__illegal;
    wire coproc_controls__dec_idecode__is_compressed;
    wire coproc_controls__dec_idecode__ext__dummy;
    wire coproc_controls__dec_to_alu_blocked;
    wire [31:0]coproc_controls__alu_rs1;
    wire [31:0]coproc_controls__alu_rs2;
    wire coproc_controls__alu_flush_pipeline;
    wire coproc_controls__alu_cannot_start;
    wire coproc_controls__alu_cannot_complete;
    wire pipeline_ifetch_resp__valid;
    wire pipeline_ifetch_resp__debug;
    wire [31:0]pipeline_ifetch_resp__data;
    wire [2:0]pipeline_ifetch_resp__mode;
    wire pipeline_ifetch_resp__error;
    wire [1:0]pipeline_ifetch_resp__tag;
    wire pipeline_ifetch_req__valid;
    wire [31:0]pipeline_ifetch_req__address;
    wire pipeline_ifetch_req__sequential;
    wire [2:0]pipeline_ifetch_req__mode;
    wire pipeline_ifetch_req__flush;

    //b Clock gating module instances
    //b Module instances
    riscv_i32_ifetch_debug ifetch_debug(
        .ifetch_resp__tag(ifetch_resp__tag),
        .ifetch_resp__error(ifetch_resp__error),
        .ifetch_resp__mode(ifetch_resp__mode),
        .ifetch_resp__data(ifetch_resp__data),
        .ifetch_resp__debug(ifetch_resp__debug),
        .ifetch_resp__valid(ifetch_resp__valid),
        .debug_control__data(debug_control__data),
        .debug_control__fetch_dret(debug_control__fetch_dret),
        .debug_control__halt_request(debug_control__halt_request),
        .debug_control__kill_fetch(debug_control__kill_fetch),
        .debug_control__valid(debug_control__valid),
        .pipeline_trace__trap(trace__trap),
        .pipeline_trace__branch_target(trace__branch_target),
        .pipeline_trace__branch_taken(trace__branch_taken),
        .pipeline_trace__rfw_data(trace__rfw_data),
        .pipeline_trace__rfw_rd(trace__rfw_rd),
        .pipeline_trace__rfw_data_valid(trace__rfw_data_valid),
        .pipeline_trace__rfw_retire(trace__rfw_retire),
        .pipeline_trace__instruction__data(trace__instruction__data),
        .pipeline_trace__instruction__mode(trace__instruction__mode),
        .pipeline_trace__instr_pc(trace__instr_pc),
        .pipeline_trace__instr_valid(trace__instr_valid),
        .pipeline_ifetch_req__flush(pipeline_ifetch_req__flush),
        .pipeline_ifetch_req__mode(pipeline_ifetch_req__mode),
        .pipeline_ifetch_req__sequential(pipeline_ifetch_req__sequential),
        .pipeline_ifetch_req__address(pipeline_ifetch_req__address),
        .pipeline_ifetch_req__valid(pipeline_ifetch_req__valid),
        .ifetch_req__flush(            ifetch_req__flush),
        .ifetch_req__mode(            ifetch_req__mode),
        .ifetch_req__sequential(            ifetch_req__sequential),
        .ifetch_req__address(            ifetch_req__address),
        .ifetch_req__valid(            ifetch_req__valid),
        .debug_response__exec_dret(            debug_response__exec_dret),
        .debug_response__exec_halting(            debug_response__exec_halting),
        .debug_response__exec_valid(            debug_response__exec_valid),
        .pipeline_ifetch_resp__tag(            pipeline_ifetch_resp__tag),
        .pipeline_ifetch_resp__error(            pipeline_ifetch_resp__error),
        .pipeline_ifetch_resp__mode(            pipeline_ifetch_resp__mode),
        .pipeline_ifetch_resp__data(            pipeline_ifetch_resp__data),
        .pipeline_ifetch_resp__debug(            pipeline_ifetch_resp__debug),
        .pipeline_ifetch_resp__valid(            pipeline_ifetch_resp__valid)         );
    riscv_i32_pipeline_debug pdm(
        .clk(clk),
        .clk__enable(1'b1),
        .rv_select(rv_select),
        .debug_response__exec_dret(debug_response__exec_dret),
        .debug_response__exec_halting(debug_response__exec_halting),
        .debug_response__exec_valid(debug_response__exec_valid),
        .debug_mst__data(debug_mst__data),
        .debug_mst__arg(debug_mst__arg),
        .debug_mst__op(debug_mst__op),
        .debug_mst__mask(debug_mst__mask),
        .debug_mst__select(debug_mst__select),
        .debug_mst__valid(debug_mst__valid),
        .reset_n(reset_n),
        .debug_control__data(            debug_control__data),
        .debug_control__fetch_dret(            debug_control__fetch_dret),
        .debug_control__halt_request(            debug_control__halt_request),
        .debug_control__kill_fetch(            debug_control__kill_fetch),
        .debug_control__valid(            debug_control__valid),
        .debug_tgt__attention(            debug_tgt__attention),
        .debug_tgt__data(            debug_tgt__data),
        .debug_tgt__resp(            debug_tgt__resp),
        .debug_tgt__op_was_none(            debug_tgt__op_was_none),
        .debug_tgt__hit_breakpoint(            debug_tgt__hit_breakpoint),
        .debug_tgt__resumed(            debug_tgt__resumed),
        .debug_tgt__halted(            debug_tgt__halted),
        .debug_tgt__selected(            debug_tgt__selected),
        .debug_tgt__valid(            debug_tgt__valid)         );
    riscv_i32c_pipeline pipeline(
        .clk(clk),
        .clk__enable(1'b1),
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .coproc_response__cannot_complete(coproc_response__cannot_complete),
        .coproc_response__result_valid(coproc_response__result_valid),
        .coproc_response__result(coproc_response__result),
        .coproc_response__cannot_start(coproc_response__cannot_start),
        .dmem_access_resp__read_data(dmem_access_resp__read_data),
        .dmem_access_resp__wait(dmem_access_resp__wait),
        .ifetch_resp__tag(pipeline_ifetch_resp__tag),
        .ifetch_resp__error(pipeline_ifetch_resp__error),
        .ifetch_resp__mode(pipeline_ifetch_resp__mode),
        .ifetch_resp__data(pipeline_ifetch_resp__data),
        .ifetch_resp__debug(pipeline_ifetch_resp__debug),
        .ifetch_resp__valid(pipeline_ifetch_resp__valid),
        .reset_n(reset_n),
        .trace__trap(            trace__trap),
        .trace__branch_target(            trace__branch_target),
        .trace__branch_taken(            trace__branch_taken),
        .trace__rfw_data(            trace__rfw_data),
        .trace__rfw_rd(            trace__rfw_rd),
        .trace__rfw_data_valid(            trace__rfw_data_valid),
        .trace__rfw_retire(            trace__rfw_retire),
        .trace__instruction__data(            trace__instruction__data),
        .trace__instruction__mode(            trace__instruction__mode),
        .trace__instr_pc(            trace__instr_pc),
        .trace__instr_valid(            trace__instr_valid),
        .coproc_controls__alu_cannot_complete(            coproc_controls__alu_cannot_complete),
        .coproc_controls__alu_cannot_start(            coproc_controls__alu_cannot_start),
        .coproc_controls__alu_flush_pipeline(            coproc_controls__alu_flush_pipeline),
        .coproc_controls__alu_rs2(            coproc_controls__alu_rs2),
        .coproc_controls__alu_rs1(            coproc_controls__alu_rs1),
        .coproc_controls__dec_to_alu_blocked(            coproc_controls__dec_to_alu_blocked),
        .coproc_controls__dec_idecode__ext__dummy(            coproc_controls__dec_idecode__ext__dummy),
        .coproc_controls__dec_idecode__is_compressed(            coproc_controls__dec_idecode__is_compressed),
        .coproc_controls__dec_idecode__illegal(            coproc_controls__dec_idecode__illegal),
        .coproc_controls__dec_idecode__memory_width(            coproc_controls__dec_idecode__memory_width),
        .coproc_controls__dec_idecode__memory_read_unsigned(            coproc_controls__dec_idecode__memory_read_unsigned),
        .coproc_controls__dec_idecode__requires_machine_mode(            coproc_controls__dec_idecode__requires_machine_mode),
        .coproc_controls__dec_idecode__subop(            coproc_controls__dec_idecode__subop),
        .coproc_controls__dec_idecode__op(            coproc_controls__dec_idecode__op),
        .coproc_controls__dec_idecode__immediate_valid(            coproc_controls__dec_idecode__immediate_valid),
        .coproc_controls__dec_idecode__immediate_shift(            coproc_controls__dec_idecode__immediate_shift),
        .coproc_controls__dec_idecode__immediate(            coproc_controls__dec_idecode__immediate),
        .coproc_controls__dec_idecode__csr_access__address(            coproc_controls__dec_idecode__csr_access__address),
        .coproc_controls__dec_idecode__csr_access__access(            coproc_controls__dec_idecode__csr_access__access),
        .coproc_controls__dec_idecode__rd_written(            coproc_controls__dec_idecode__rd_written),
        .coproc_controls__dec_idecode__rd(            coproc_controls__dec_idecode__rd),
        .coproc_controls__dec_idecode__rs2_valid(            coproc_controls__dec_idecode__rs2_valid),
        .coproc_controls__dec_idecode__rs2(            coproc_controls__dec_idecode__rs2),
        .coproc_controls__dec_idecode__rs1_valid(            coproc_controls__dec_idecode__rs1_valid),
        .coproc_controls__dec_idecode__rs1(            coproc_controls__dec_idecode__rs1),
        .coproc_controls__dec_idecode_valid(            coproc_controls__dec_idecode_valid),
        .dmem_access_req__write_data(            dmem_access_req__write_data),
        .dmem_access_req__read_enable(            dmem_access_req__read_enable),
        .dmem_access_req__write_enable(            dmem_access_req__write_enable),
        .dmem_access_req__byte_enable(            dmem_access_req__byte_enable),
        .dmem_access_req__address(            dmem_access_req__address),
        .ifetch_req__flush(            pipeline_ifetch_req__flush),
        .ifetch_req__mode(            pipeline_ifetch_req__mode),
        .ifetch_req__sequential(            pipeline_ifetch_req__sequential),
        .ifetch_req__address(            pipeline_ifetch_req__address),
        .ifetch_req__valid(            pipeline_ifetch_req__valid)         );
    //b pipeline_debug combinatorial process
    always @ ( * )//pipeline_debug
    begin: pipeline_debug__comb_code
        coproc_response__cannot_start = 1'h0;
        coproc_response__result = 32'h0;
        coproc_response__result_valid = 1'h0;
        coproc_response__cannot_complete = 1'h0;
    end //always

endmodule // riscv_minimal_debug
