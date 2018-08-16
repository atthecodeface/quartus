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

//a Module riscv_i32c_pipeline3
    //   
    //   This is just the processor pipeline, using thress stages for execution.
    //   
    //   The decode and RFR is performed in the first stage
    //   
    //   The ALU execution (and coprocessor execution) is performed in the second stage
    //   
    //   Memory operations are performed in the third stage
    //   
    //   Register file is written at the end of the third stage; there is a RFW stage to
    //   forward data from RFW back to execution.
    //   
    //   The instruction fetch request for the next cycle is put out just after
    //   the ALU stage logic, which may be a long time into the cycle; the
    //   fetch data response presents the instruction fetched at the end of the
    //   cycle, where it is registered for execution.
    //   
    //   
module riscv_i32c_pipeline3
(
    clk,
    clk__enable,

    riscv_config__i32c,
    riscv_config__e32,
    riscv_config__i32m,
    riscv_config__i32m_fuse,
    riscv_config__coproc_disable,
    riscv_config__unaligned_mem,
    coproc_response__cannot_start,
    coproc_response__result,
    coproc_response__result_valid,
    coproc_response__cannot_complete,
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
    trace__instr_data,
    trace__rfw_retire,
    trace__rfw_data_valid,
    trace__rfw_rd,
    trace__rfw_data,
    trace__branch_taken,
    trace__branch_target,
    trace__trap,
    coproc_controls__dec_idecode_valid,
    coproc_controls__dec_idecode__rs1,
    coproc_controls__dec_idecode__rs1_valid,
    coproc_controls__dec_idecode__rs2,
    coproc_controls__dec_idecode__rs2_valid,
    coproc_controls__dec_idecode__rd,
    coproc_controls__dec_idecode__rd_written,
    coproc_controls__dec_idecode__csr_access__access,
    coproc_controls__dec_idecode__csr_access__address,
    coproc_controls__dec_idecode__immediate,
    coproc_controls__dec_idecode__immediate_shift,
    coproc_controls__dec_idecode__immediate_valid,
    coproc_controls__dec_idecode__op,
    coproc_controls__dec_idecode__subop,
    coproc_controls__dec_idecode__requires_machine_mode,
    coproc_controls__dec_idecode__memory_read_unsigned,
    coproc_controls__dec_idecode__memory_width,
    coproc_controls__dec_idecode__illegal,
    coproc_controls__dec_idecode__is_compressed,
    coproc_controls__dec_to_alu_blocked,
    coproc_controls__alu_rs1,
    coproc_controls__alu_rs2,
    coproc_controls__alu_flush_pipeline,
    coproc_controls__alu_cannot_start,
    coproc_controls__alu_cannot_complete,
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
    input riscv_config__i32c;
    input riscv_config__e32;
    input riscv_config__i32m;
    input riscv_config__i32m_fuse;
    input riscv_config__coproc_disable;
    input riscv_config__unaligned_mem;
    input coproc_response__cannot_start;
    input [31:0]coproc_response__result;
    input coproc_response__result_valid;
    input coproc_response__cannot_complete;
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
    output [31:0]trace__instr_data;
    output trace__rfw_retire;
    output trace__rfw_data_valid;
    output [4:0]trace__rfw_rd;
    output [31:0]trace__rfw_data;
    output trace__branch_taken;
    output [31:0]trace__branch_target;
    output trace__trap;
    output coproc_controls__dec_idecode_valid;
    output [4:0]coproc_controls__dec_idecode__rs1;
    output coproc_controls__dec_idecode__rs1_valid;
    output [4:0]coproc_controls__dec_idecode__rs2;
    output coproc_controls__dec_idecode__rs2_valid;
    output [4:0]coproc_controls__dec_idecode__rd;
    output coproc_controls__dec_idecode__rd_written;
    output [2:0]coproc_controls__dec_idecode__csr_access__access;
    output [11:0]coproc_controls__dec_idecode__csr_access__address;
    output [31:0]coproc_controls__dec_idecode__immediate;
    output [4:0]coproc_controls__dec_idecode__immediate_shift;
    output coproc_controls__dec_idecode__immediate_valid;
    output [3:0]coproc_controls__dec_idecode__op;
    output [3:0]coproc_controls__dec_idecode__subop;
    output coproc_controls__dec_idecode__requires_machine_mode;
    output coproc_controls__dec_idecode__memory_read_unsigned;
    output [1:0]coproc_controls__dec_idecode__memory_width;
    output coproc_controls__dec_idecode__illegal;
    output coproc_controls__dec_idecode__is_compressed;
    output coproc_controls__dec_to_alu_blocked;
    output [31:0]coproc_controls__alu_rs1;
    output [31:0]coproc_controls__alu_rs2;
    output coproc_controls__alu_flush_pipeline;
    output coproc_controls__alu_cannot_start;
    output coproc_controls__alu_cannot_complete;
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
    reg trace__instr_valid;
    reg [31:0]trace__instr_pc;
    reg [31:0]trace__instr_data;
    reg trace__rfw_retire;
    reg trace__rfw_data_valid;
    reg [4:0]trace__rfw_rd;
    reg [31:0]trace__rfw_data;
    reg trace__branch_taken;
    reg [31:0]trace__branch_target;
    reg trace__trap;
    reg coproc_controls__dec_idecode_valid;
    reg [4:0]coproc_controls__dec_idecode__rs1;
    reg coproc_controls__dec_idecode__rs1_valid;
    reg [4:0]coproc_controls__dec_idecode__rs2;
    reg coproc_controls__dec_idecode__rs2_valid;
    reg [4:0]coproc_controls__dec_idecode__rd;
    reg coproc_controls__dec_idecode__rd_written;
    reg [2:0]coproc_controls__dec_idecode__csr_access__access;
    reg [11:0]coproc_controls__dec_idecode__csr_access__address;
    reg [31:0]coproc_controls__dec_idecode__immediate;
    reg [4:0]coproc_controls__dec_idecode__immediate_shift;
    reg coproc_controls__dec_idecode__immediate_valid;
    reg [3:0]coproc_controls__dec_idecode__op;
    reg [3:0]coproc_controls__dec_idecode__subop;
    reg coproc_controls__dec_idecode__requires_machine_mode;
    reg coproc_controls__dec_idecode__memory_read_unsigned;
    reg [1:0]coproc_controls__dec_idecode__memory_width;
    reg coproc_controls__dec_idecode__illegal;
    reg coproc_controls__dec_idecode__is_compressed;
    reg coproc_controls__dec_to_alu_blocked;
    reg [31:0]coproc_controls__alu_rs1;
    reg [31:0]coproc_controls__alu_rs2;
    reg coproc_controls__alu_flush_pipeline;
    reg coproc_controls__alu_cannot_start;
    reg coproc_controls__alu_cannot_complete;
    reg ifetch_req__valid;
    reg [31:0]ifetch_req__address;
    reg ifetch_req__sequential;
    reg [2:0]ifetch_req__mode;
    reg ifetch_req__flush;
    reg [31:0]dmem_access_req__address;
    reg [3:0]dmem_access_req__byte_enable;
    reg dmem_access_req__write_enable;
    reg dmem_access_req__read_enable;
    reg [31:0]dmem_access_req__write_data;

    //b Output nets

    //b Internal and output registers
    reg rfw_state__valid;
    reg [31:0]rfw_state__mem_result;
    reg rfw_state__rd_written;
    reg [4:0]rfw_state__rd;
    reg mem_state__valid;
    reg [31:0]mem_state__alu_result;
    reg mem_state__rd_written;
    reg mem_state__rd_from_mem;
    reg [4:0]mem_state__rd;
    reg mem_state__reading;
    reg [3:0]mem_state__byte_clear;
    reg [3:0]mem_state__byte_enable;
    reg [1:0]mem_state__rotation;
    reg mem_state__sign_extend_byte;
    reg mem_state__sign_extend_half;
    reg alu_state__valid;
    reg alu_state__first_cycle;
    reg [4:0]alu_state__idecode__rs1;
    reg alu_state__idecode__rs1_valid;
    reg [4:0]alu_state__idecode__rs2;
    reg alu_state__idecode__rs2_valid;
    reg [4:0]alu_state__idecode__rd;
    reg alu_state__idecode__rd_written;
    reg [2:0]alu_state__idecode__csr_access__access;
    reg [11:0]alu_state__idecode__csr_access__address;
    reg [31:0]alu_state__idecode__immediate;
    reg [4:0]alu_state__idecode__immediate_shift;
    reg alu_state__idecode__immediate_valid;
    reg [3:0]alu_state__idecode__op;
    reg [3:0]alu_state__idecode__subop;
    reg alu_state__idecode__requires_machine_mode;
    reg alu_state__idecode__memory_read_unsigned;
    reg [1:0]alu_state__idecode__memory_width;
    reg alu_state__idecode__illegal;
    reg alu_state__idecode__is_compressed;
    reg [31:0]alu_state__pc;
    reg alu_state__illegal_pc;
    reg [31:0]alu_state__pc_if_mispredicted;
    reg alu_state__predicted_branch;
    reg alu_state__rs1_from_alu;
    reg alu_state__rs1_from_mem;
    reg alu_state__rs2_from_alu;
    reg alu_state__rs2_from_mem;
    reg [31:0]alu_state__rs1;
    reg [31:0]alu_state__rs2;
    reg [31:0]alu_state__debug_instr_data;
    reg dec_state__enable;
    reg [31:0]dec_state__instr_data;
    reg dec_state__valid;
    reg dec_state__illegal_pc;
    reg [31:0]dec_state__pc;
    reg dec_state__fetch_sequential;
        //   Register 0 is tied to 0 - so it is written on every cycle to zero...
    reg [31:0]registers[31:0];

    //b Internal combinatorials
    reg csr_controls__retire;
    reg csr_controls__timer_inc;
    reg csr_controls__timer_clear;
    reg csr_controls__timer_load;
    reg [63:0]csr_controls__timer_value;
    reg csr_controls__trap;
    reg [3:0]csr_controls__trap_cause;
    reg [31:0]csr_controls__trap_pc;
    reg [31:0]csr_controls__trap_value;
        //   Coprocessor response masked out if configured off
    reg coproc_response_cfg__cannot_start;
    reg [31:0]coproc_response_cfg__result;
    reg coproc_response_cfg__result_valid;
    reg coproc_response_cfg__cannot_complete;
    reg [31:0]mem_combs__aligned_data;
    reg [31:0]mem_combs__memory_data;
    reg [31:0]mem_combs__result_data;
    reg alu_combs__valid_legal;
    reg alu_combs__blocked_by_mem;
    reg alu_combs__cannot_start;
    reg alu_combs__cannot_complete;
    reg alu_combs__flush_pipeline;
    reg [31:0]alu_combs__next_pc;
    reg [31:0]alu_combs__rs1;
    reg [31:0]alu_combs__rs2;
    reg [1:0]alu_combs__word_offset;
    reg alu_combs__reading;
    reg [1:0]alu_combs__read_data_rotation;
    reg [3:0]alu_combs__read_data_byte_clear;
    reg [3:0]alu_combs__read_data_byte_enable;
    reg alu_combs__branch_taken;
    reg alu_combs__trap;
    reg alu_combs__mret;
    reg alu_combs__jalr;
    reg [3:0]alu_combs__trap_cause;
    reg [31:0]alu_combs__trap_value;
    reg [2:0]alu_combs__csr_access__access;
    reg [11:0]alu_combs__csr_access__address;
    reg [31:0]alu_combs__result_data;
    reg alu_combs__dmem_misaligned;
    reg alu_combs__dmem_multicycle;
    reg [4:0]dec_combs__idecode__rs1;
    reg dec_combs__idecode__rs1_valid;
    reg [4:0]dec_combs__idecode__rs2;
    reg dec_combs__idecode__rs2_valid;
    reg [4:0]dec_combs__idecode__rd;
    reg dec_combs__idecode__rd_written;
    reg [2:0]dec_combs__idecode__csr_access__access;
    reg [11:0]dec_combs__idecode__csr_access__address;
    reg [31:0]dec_combs__idecode__immediate;
    reg [4:0]dec_combs__idecode__immediate_shift;
    reg dec_combs__idecode__immediate_valid;
    reg [3:0]dec_combs__idecode__op;
    reg [3:0]dec_combs__idecode__subop;
    reg dec_combs__idecode__requires_machine_mode;
    reg dec_combs__idecode__memory_read_unsigned;
    reg [1:0]dec_combs__idecode__memory_width;
    reg dec_combs__idecode__illegal;
    reg dec_combs__idecode__is_compressed;
    reg [31:0]dec_combs__rs1;
    reg [31:0]dec_combs__rs2;
    reg [31:0]dec_combs__pc_plus_4;
    reg [31:0]dec_combs__pc_plus_2;
    reg [31:0]dec_combs__pc_plus_inst;
    reg [31:0]dec_combs__pc_branch_target;
    reg dec_combs__predict_branch;
    reg [31:0]dec_combs__fetch_next_pc;
    reg [31:0]dec_combs__pc_if_mispredicted;
    reg dec_combs__fetch_sequential;
    reg dec_combs__rs1_from_alu;
    reg dec_combs__rs1_from_mem;
    reg dec_combs__rs2_from_alu;
    reg dec_combs__rs2_from_mem;
    reg ifetch_combs__request;
    reg [31:0]ifetch_combs__address;
    reg ifetch_combs__sequential;

    //b Internal nets
    wire [63:0]csrs__cycles;
    wire [63:0]csrs__instret;
    wire [63:0]csrs__time;
    wire [31:0]csrs__mscratch;
    wire [31:0]csrs__mepc;
    wire [31:0]csrs__mcause;
    wire [31:0]csrs__mtval;
    wire [31:0]csrs__mtvec;
    wire [31:0]csr_data__read_data;
    wire csr_data__illegal_access;
    wire [31:0]alu_result__result;
    wire [31:0]alu_result__arith_result;
    wire alu_result__branch_condition_met;
    wire [31:0]alu_result__branch_target;
    wire [2:0]alu_result__csr_access__access;
    wire [11:0]alu_result__csr_access__address;
    wire [4:0]idecode_i32c__rs1;
    wire idecode_i32c__rs1_valid;
    wire [4:0]idecode_i32c__rs2;
    wire idecode_i32c__rs2_valid;
    wire [4:0]idecode_i32c__rd;
    wire idecode_i32c__rd_written;
    wire [2:0]idecode_i32c__csr_access__access;
    wire [11:0]idecode_i32c__csr_access__address;
    wire [31:0]idecode_i32c__immediate;
    wire [4:0]idecode_i32c__immediate_shift;
    wire idecode_i32c__immediate_valid;
    wire [3:0]idecode_i32c__op;
    wire [3:0]idecode_i32c__subop;
    wire idecode_i32c__requires_machine_mode;
    wire idecode_i32c__memory_read_unsigned;
    wire [1:0]idecode_i32c__memory_width;
    wire idecode_i32c__illegal;
    wire idecode_i32c__is_compressed;
    wire [4:0]idecode_i32__rs1;
    wire idecode_i32__rs1_valid;
    wire [4:0]idecode_i32__rs2;
    wire idecode_i32__rs2_valid;
    wire [4:0]idecode_i32__rd;
    wire idecode_i32__rd_written;
    wire [2:0]idecode_i32__csr_access__access;
    wire [11:0]idecode_i32__csr_access__address;
    wire [31:0]idecode_i32__immediate;
    wire [4:0]idecode_i32__immediate_shift;
    wire idecode_i32__immediate_valid;
    wire [3:0]idecode_i32__op;
    wire [3:0]idecode_i32__subop;
    wire idecode_i32__requires_machine_mode;
    wire idecode_i32__memory_read_unsigned;
    wire [1:0]idecode_i32__memory_width;
    wire idecode_i32__illegal;
    wire idecode_i32__is_compressed;

    //b Clock gating module instances
    //b Module instances
    riscv_i32_decode decode_i32(
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .instruction(dec_state__instr_data),
        .idecode__is_compressed(            idecode_i32__is_compressed),
        .idecode__illegal(            idecode_i32__illegal),
        .idecode__memory_width(            idecode_i32__memory_width),
        .idecode__memory_read_unsigned(            idecode_i32__memory_read_unsigned),
        .idecode__requires_machine_mode(            idecode_i32__requires_machine_mode),
        .idecode__subop(            idecode_i32__subop),
        .idecode__op(            idecode_i32__op),
        .idecode__immediate_valid(            idecode_i32__immediate_valid),
        .idecode__immediate_shift(            idecode_i32__immediate_shift),
        .idecode__immediate(            idecode_i32__immediate),
        .idecode__csr_access__address(            idecode_i32__csr_access__address),
        .idecode__csr_access__access(            idecode_i32__csr_access__access),
        .idecode__rd_written(            idecode_i32__rd_written),
        .idecode__rd(            idecode_i32__rd),
        .idecode__rs2_valid(            idecode_i32__rs2_valid),
        .idecode__rs2(            idecode_i32__rs2),
        .idecode__rs1_valid(            idecode_i32__rs1_valid),
        .idecode__rs1(            idecode_i32__rs1)         );
    riscv_i32c_decode decode_i32c(
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .instruction(dec_state__instr_data),
        .idecode__is_compressed(            idecode_i32c__is_compressed),
        .idecode__illegal(            idecode_i32c__illegal),
        .idecode__memory_width(            idecode_i32c__memory_width),
        .idecode__memory_read_unsigned(            idecode_i32c__memory_read_unsigned),
        .idecode__requires_machine_mode(            idecode_i32c__requires_machine_mode),
        .idecode__subop(            idecode_i32c__subop),
        .idecode__op(            idecode_i32c__op),
        .idecode__immediate_valid(            idecode_i32c__immediate_valid),
        .idecode__immediate_shift(            idecode_i32c__immediate_shift),
        .idecode__immediate(            idecode_i32c__immediate),
        .idecode__csr_access__address(            idecode_i32c__csr_access__address),
        .idecode__csr_access__access(            idecode_i32c__csr_access__access),
        .idecode__rd_written(            idecode_i32c__rd_written),
        .idecode__rd(            idecode_i32c__rd),
        .idecode__rs2_valid(            idecode_i32c__rs2_valid),
        .idecode__rs2(            idecode_i32c__rs2),
        .idecode__rs1_valid(            idecode_i32c__rs1_valid),
        .idecode__rs1(            idecode_i32c__rs1)         );
    riscv_i32_alu alu(
        .rs2(alu_combs__rs2),
        .rs1(alu_combs__rs1),
        .pc(alu_state__pc),
        .idecode__is_compressed(alu_state__idecode__is_compressed),
        .idecode__illegal(alu_state__idecode__illegal),
        .idecode__memory_width(alu_state__idecode__memory_width),
        .idecode__memory_read_unsigned(alu_state__idecode__memory_read_unsigned),
        .idecode__requires_machine_mode(alu_state__idecode__requires_machine_mode),
        .idecode__subop(alu_state__idecode__subop),
        .idecode__op(alu_state__idecode__op),
        .idecode__immediate_valid(alu_state__idecode__immediate_valid),
        .idecode__immediate_shift(alu_state__idecode__immediate_shift),
        .idecode__immediate(alu_state__idecode__immediate),
        .idecode__csr_access__address(alu_state__idecode__csr_access__address),
        .idecode__csr_access__access(alu_state__idecode__csr_access__access),
        .idecode__rd_written(alu_state__idecode__rd_written),
        .idecode__rd(alu_state__idecode__rd),
        .idecode__rs2_valid(alu_state__idecode__rs2_valid),
        .idecode__rs2(alu_state__idecode__rs2),
        .idecode__rs1_valid(alu_state__idecode__rs1_valid),
        .idecode__rs1(alu_state__idecode__rs1),
        .alu_result__csr_access__address(            alu_result__csr_access__address),
        .alu_result__csr_access__access(            alu_result__csr_access__access),
        .alu_result__branch_target(            alu_result__branch_target),
        .alu_result__branch_condition_met(            alu_result__branch_condition_met),
        .alu_result__arith_result(            alu_result__arith_result),
        .alu_result__result(            alu_result__result)         );
    riscv_csrs_minimal csrs(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_controls__trap_value(csr_controls__trap_value),
        .csr_controls__trap_pc(csr_controls__trap_pc),
        .csr_controls__trap_cause(csr_controls__trap_cause),
        .csr_controls__trap(csr_controls__trap),
        .csr_controls__timer_value(csr_controls__timer_value),
        .csr_controls__timer_load(csr_controls__timer_load),
        .csr_controls__timer_clear(csr_controls__timer_clear),
        .csr_controls__timer_inc(csr_controls__timer_inc),
        .csr_controls__retire(csr_controls__retire),
        .csr_write_data(((alu_state__idecode__illegal!=1'h0)?{27'h0,alu_state__idecode__rs1}:alu_combs__rs1)),
        .csr_access__address(alu_combs__csr_access__address),
        .csr_access__access(alu_combs__csr_access__access),
        .reset_n(reset_n),
        .csrs__mtvec(            csrs__mtvec),
        .csrs__mtval(            csrs__mtval),
        .csrs__mcause(            csrs__mcause),
        .csrs__mepc(            csrs__mepc),
        .csrs__mscratch(            csrs__mscratch),
        .csrs__time(            csrs__time),
        .csrs__instret(            csrs__instret),
        .csrs__cycles(            csrs__cycles),
        .csr_data__illegal_access(            csr_data__illegal_access),
        .csr_data__read_data(            csr_data__read_data)         );
    //b instruction_fetch_request combinatorial process
        //   
        //       The instruction fetch request derives from the decode stage for
        //       conditional branches (predicted taken if backwards) and for
        //       unconditional branches.
        //   
        //       If the decode stage is invalid (i.e. it does not have a
        //       valid instruction to decode) then the current decode stage PC is requested.
        //   
        //       However, if the execute stage is valid and
        //       a trap is taken, or a forward conditional branch is taken or a
        //       backward conditional branch is not taken or a jump table branch is
        //       taken, then the execute stage result pc has to be used.
        //   
        //       This request may be for any 16-bit aligned address, and two
        //       successive 16-bit words from that request must be presented,
        //       aligned to bit 0.
        //   
        //       
    always @ ( * )//instruction_fetch_request
    begin: instruction_fetch_request__comb_code
    reg [31:0]ifetch_combs__address__var;
    reg ifetch_combs__sequential__var;
    reg ifetch_req__valid__var;
    reg [31:0]ifetch_req__address__var;
    reg ifetch_req__sequential__var;
        ifetch_combs__address__var = dec_combs__fetch_next_pc;
        ifetch_combs__sequential__var = dec_combs__fetch_sequential;
        if (!(dec_state__valid!=1'h0))
        begin
            ifetch_combs__address__var = dec_state__pc;
            ifetch_combs__sequential__var = dec_state__fetch_sequential;
        end //if
        if (((alu_state__valid!=1'h0)&&(alu_combs__flush_pipeline!=1'h0)))
        begin
            ifetch_combs__address__var = alu_combs__next_pc;
            ifetch_combs__sequential__var = 1'h0;
        end //if
        ifetch_combs__request = dec_state__enable;
        ifetch_req__valid__var = 1'h0;
        ifetch_req__address__var = 32'h0;
        ifetch_req__sequential__var = 1'h0;
        ifetch_req__mode = 3'h0;
        ifetch_req__flush = 1'h0;
        ifetch_req__valid__var = ifetch_combs__request;
        ifetch_req__sequential__var = ifetch_combs__sequential__var;
        ifetch_req__address__var = ifetch_combs__address__var;
        ifetch_combs__address = ifetch_combs__address__var;
        ifetch_combs__sequential = ifetch_combs__sequential__var;
        ifetch_req__valid = ifetch_req__valid__var;
        ifetch_req__address = ifetch_req__address__var;
        ifetch_req__sequential = ifetch_req__sequential__var;
    end //always

    //b decode_rfr_stage__comb combinatorial process
        //   
        //       The decode/RFR stage decodes an instruction, follows unconditional
        //       branches and backward conditional branches (to generate the next
        //       PC as far as decode is concerned), determines register forwarding
        //       required, reads the register file.
        //   
        //       Currently assumes the pipeline always takes the decoded instruction
        //       
    always @ ( * )//decode_rfr_stage__comb
    begin: decode_rfr_stage__comb_code
    reg [4:0]dec_combs__idecode__rs1__var;
    reg dec_combs__idecode__rs1_valid__var;
    reg [4:0]dec_combs__idecode__rs2__var;
    reg dec_combs__idecode__rs2_valid__var;
    reg [4:0]dec_combs__idecode__rd__var;
    reg dec_combs__idecode__rd_written__var;
    reg [2:0]dec_combs__idecode__csr_access__access__var;
    reg [11:0]dec_combs__idecode__csr_access__address__var;
    reg [31:0]dec_combs__idecode__immediate__var;
    reg [4:0]dec_combs__idecode__immediate_shift__var;
    reg dec_combs__idecode__immediate_valid__var;
    reg [3:0]dec_combs__idecode__op__var;
    reg [3:0]dec_combs__idecode__subop__var;
    reg dec_combs__idecode__requires_machine_mode__var;
    reg dec_combs__idecode__memory_read_unsigned__var;
    reg [1:0]dec_combs__idecode__memory_width__var;
    reg dec_combs__idecode__illegal__var;
    reg dec_combs__idecode__is_compressed__var;
    reg dec_combs__predict_branch__var;
    reg [31:0]dec_combs__fetch_next_pc__var;
    reg dec_combs__fetch_sequential__var;
    reg [31:0]dec_combs__pc_if_mispredicted__var;
    reg dec_combs__rs1_from_alu__var;
    reg dec_combs__rs1_from_mem__var;
    reg dec_combs__rs2_from_alu__var;
    reg dec_combs__rs2_from_mem__var;
        dec_combs__idecode__rs1__var = idecode_i32__rs1;
        dec_combs__idecode__rs1_valid__var = idecode_i32__rs1_valid;
        dec_combs__idecode__rs2__var = idecode_i32__rs2;
        dec_combs__idecode__rs2_valid__var = idecode_i32__rs2_valid;
        dec_combs__idecode__rd__var = idecode_i32__rd;
        dec_combs__idecode__rd_written__var = idecode_i32__rd_written;
        dec_combs__idecode__csr_access__access__var = idecode_i32__csr_access__access;
        dec_combs__idecode__csr_access__address__var = idecode_i32__csr_access__address;
        dec_combs__idecode__immediate__var = idecode_i32__immediate;
        dec_combs__idecode__immediate_shift__var = idecode_i32__immediate_shift;
        dec_combs__idecode__immediate_valid__var = idecode_i32__immediate_valid;
        dec_combs__idecode__op__var = idecode_i32__op;
        dec_combs__idecode__subop__var = idecode_i32__subop;
        dec_combs__idecode__requires_machine_mode__var = idecode_i32__requires_machine_mode;
        dec_combs__idecode__memory_read_unsigned__var = idecode_i32__memory_read_unsigned;
        dec_combs__idecode__memory_width__var = idecode_i32__memory_width;
        dec_combs__idecode__illegal__var = idecode_i32__illegal;
        dec_combs__idecode__is_compressed__var = idecode_i32__is_compressed;
        if ((1'h1&&(riscv_config__i32c!=1'h0)))
        begin
            if ((dec_state__instr_data[1:0]!=2'h3))
            begin
                dec_combs__idecode__rs1__var = idecode_i32c__rs1;
                dec_combs__idecode__rs1_valid__var = idecode_i32c__rs1_valid;
                dec_combs__idecode__rs2__var = idecode_i32c__rs2;
                dec_combs__idecode__rs2_valid__var = idecode_i32c__rs2_valid;
                dec_combs__idecode__rd__var = idecode_i32c__rd;
                dec_combs__idecode__rd_written__var = idecode_i32c__rd_written;
                dec_combs__idecode__csr_access__access__var = idecode_i32c__csr_access__access;
                dec_combs__idecode__csr_access__address__var = idecode_i32c__csr_access__address;
                dec_combs__idecode__immediate__var = idecode_i32c__immediate;
                dec_combs__idecode__immediate_shift__var = idecode_i32c__immediate_shift;
                dec_combs__idecode__immediate_valid__var = idecode_i32c__immediate_valid;
                dec_combs__idecode__op__var = idecode_i32c__op;
                dec_combs__idecode__subop__var = idecode_i32c__subop;
                dec_combs__idecode__requires_machine_mode__var = idecode_i32c__requires_machine_mode;
                dec_combs__idecode__memory_read_unsigned__var = idecode_i32c__memory_read_unsigned;
                dec_combs__idecode__memory_width__var = idecode_i32c__memory_width;
                dec_combs__idecode__illegal__var = idecode_i32c__illegal;
                dec_combs__idecode__is_compressed__var = idecode_i32c__is_compressed;
            end //if
        end //if
        dec_combs__rs1 = registers[dec_combs__idecode__rs1__var];
        dec_combs__rs2 = registers[dec_combs__idecode__rs2__var];
        dec_combs__pc_plus_4 = (dec_state__pc+32'h4);
        dec_combs__pc_plus_2 = (dec_state__pc+32'h2);
        dec_combs__pc_plus_inst = ((dec_combs__idecode__is_compressed__var!=1'h0)?dec_combs__pc_plus_2:dec_combs__pc_plus_4);
        dec_combs__pc_branch_target = (dec_state__pc+dec_combs__idecode__immediate__var);
        dec_combs__predict_branch__var = 1'h0;
        case (dec_combs__idecode__op__var) //synopsys parallel_case
        4'h0: // req 1
            begin
            dec_combs__predict_branch__var = dec_combs__idecode__immediate__var[31];
            end
        4'h1: // req 1
            begin
            dec_combs__predict_branch__var = 1'h1;
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
        dec_combs__fetch_next_pc__var = dec_combs__pc_plus_inst;
        dec_combs__fetch_sequential__var = 1'h1;
        dec_combs__pc_if_mispredicted__var = dec_combs__pc_branch_target;
        if ((dec_combs__predict_branch__var!=1'h0))
        begin
            dec_combs__fetch_next_pc__var = dec_combs__pc_branch_target;
            dec_combs__fetch_sequential__var = 1'h0;
            dec_combs__pc_if_mispredicted__var = dec_combs__pc_plus_inst;
        end //if
        dec_combs__rs1_from_alu__var = 1'h0;
        dec_combs__rs1_from_mem__var = 1'h0;
        dec_combs__rs2_from_alu__var = 1'h0;
        dec_combs__rs2_from_mem__var = 1'h0;
        if (((mem_state__rd==dec_combs__idecode__rs1__var)&&(mem_state__rd_written!=1'h0)))
        begin
            dec_combs__rs1_from_mem__var = 1'h1;
        end //if
        if (((alu_state__idecode__rd==dec_combs__idecode__rs1__var)&&(alu_state__idecode__rd_written!=1'h0)))
        begin
            dec_combs__rs1_from_alu__var = 1'h1;
        end //if
        if (((mem_state__rd==dec_combs__idecode__rs2__var)&&(mem_state__rd_written!=1'h0)))
        begin
            dec_combs__rs2_from_mem__var = 1'h1;
        end //if
        if (((alu_state__idecode__rd==dec_combs__idecode__rs2__var)&&(alu_state__idecode__rd_written!=1'h0)))
        begin
            dec_combs__rs2_from_alu__var = 1'h1;
        end //if
        dec_combs__idecode__rs1 = dec_combs__idecode__rs1__var;
        dec_combs__idecode__rs1_valid = dec_combs__idecode__rs1_valid__var;
        dec_combs__idecode__rs2 = dec_combs__idecode__rs2__var;
        dec_combs__idecode__rs2_valid = dec_combs__idecode__rs2_valid__var;
        dec_combs__idecode__rd = dec_combs__idecode__rd__var;
        dec_combs__idecode__rd_written = dec_combs__idecode__rd_written__var;
        dec_combs__idecode__csr_access__access = dec_combs__idecode__csr_access__access__var;
        dec_combs__idecode__csr_access__address = dec_combs__idecode__csr_access__address__var;
        dec_combs__idecode__immediate = dec_combs__idecode__immediate__var;
        dec_combs__idecode__immediate_shift = dec_combs__idecode__immediate_shift__var;
        dec_combs__idecode__immediate_valid = dec_combs__idecode__immediate_valid__var;
        dec_combs__idecode__op = dec_combs__idecode__op__var;
        dec_combs__idecode__subop = dec_combs__idecode__subop__var;
        dec_combs__idecode__requires_machine_mode = dec_combs__idecode__requires_machine_mode__var;
        dec_combs__idecode__memory_read_unsigned = dec_combs__idecode__memory_read_unsigned__var;
        dec_combs__idecode__memory_width = dec_combs__idecode__memory_width__var;
        dec_combs__idecode__illegal = dec_combs__idecode__illegal__var;
        dec_combs__idecode__is_compressed = dec_combs__idecode__is_compressed__var;
        dec_combs__predict_branch = dec_combs__predict_branch__var;
        dec_combs__fetch_next_pc = dec_combs__fetch_next_pc__var;
        dec_combs__fetch_sequential = dec_combs__fetch_sequential__var;
        dec_combs__pc_if_mispredicted = dec_combs__pc_if_mispredicted__var;
        dec_combs__rs1_from_alu = dec_combs__rs1_from_alu__var;
        dec_combs__rs1_from_mem = dec_combs__rs1_from_mem__var;
        dec_combs__rs2_from_alu = dec_combs__rs2_from_alu__var;
        dec_combs__rs2_from_mem = dec_combs__rs2_from_mem__var;
    end //always

    //b decode_rfr_stage__posedge_clk_active_low_reset_n clock process
        //   
        //       The decode/RFR stage decodes an instruction, follows unconditional
        //       branches and backward conditional branches (to generate the next
        //       PC as far as decode is concerned), determines register forwarding
        //       required, reads the register file.
        //   
        //       Currently assumes the pipeline always takes the decoded instruction
        //       
    always @( posedge clk or negedge reset_n)
    begin : decode_rfr_stage__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            dec_state__enable <= 1'h0;
            dec_state__valid <= 1'h0;
            dec_state__instr_data <= 32'h0;
            dec_state__illegal_pc <= 1'h0;
            dec_state__pc <= 32'h0;
            dec_state__pc <= 32'h80000000;
            dec_state__fetch_sequential <= 1'h0;
        end
        else if (clk__enable)
        begin
            dec_state__enable <= 1'h1;
            dec_state__valid <= 1'h0;
            if (((alu_combs__cannot_complete!=1'h0)&&(dec_state__valid!=1'h0)))
            begin
                dec_state__enable <= dec_state__enable;
                dec_state__instr_data <= dec_state__instr_data;
                dec_state__valid <= dec_state__valid;
                dec_state__illegal_pc <= dec_state__illegal_pc;
                dec_state__pc <= dec_state__pc;
                dec_state__fetch_sequential <= dec_state__fetch_sequential;
            end //if
            else
            
            begin
                if ((ifetch_req__valid!=1'h0))
                begin
                    if ((ifetch_resp__valid!=1'h0))
                    begin
                        dec_state__valid <= 1'h1;
                        dec_state__instr_data <= ifetch_resp__data;
                        dec_state__illegal_pc <= 1'h0;
                    end //if
                    dec_state__pc <= ifetch_req__address;
                    dec_state__fetch_sequential <= ifetch_req__sequential;
                end //if
            end //else
        end //if
    end //always

    //b alu_stage clock process
        //   
        //       The ALU stage does data forwarding, ALU operation, conditional branches, CSR accesses, memory request
        //       
    always @( posedge clk or negedge reset_n)
    begin : alu_stage__code
        if (reset_n==1'b0)
        begin
            alu_state__valid <= 1'h0;
            alu_state__idecode__rd_written <= 1'h0;
            alu_state__first_cycle <= 1'h0;
            alu_state__idecode__rs1 <= 5'h0;
            alu_state__idecode__rs1_valid <= 1'h0;
            alu_state__idecode__rs2 <= 5'h0;
            alu_state__idecode__rs2_valid <= 1'h0;
            alu_state__idecode__rd <= 5'h0;
            alu_state__idecode__csr_access__access <= 3'h0;
            alu_state__idecode__csr_access__address <= 12'h0;
            alu_state__idecode__immediate <= 32'h0;
            alu_state__idecode__immediate_shift <= 5'h0;
            alu_state__idecode__immediate_valid <= 1'h0;
            alu_state__idecode__op <= 4'h0;
            alu_state__idecode__subop <= 4'h0;
            alu_state__idecode__requires_machine_mode <= 1'h0;
            alu_state__idecode__memory_read_unsigned <= 1'h0;
            alu_state__idecode__memory_width <= 2'h0;
            alu_state__idecode__illegal <= 1'h0;
            alu_state__idecode__is_compressed <= 1'h0;
            alu_state__pc <= 32'h0;
            alu_state__illegal_pc <= 1'h0;
            alu_state__pc_if_mispredicted <= 32'h0;
            alu_state__predicted_branch <= 1'h0;
            alu_state__rs1_from_alu <= 1'h0;
            alu_state__rs1_from_mem <= 1'h0;
            alu_state__rs2_from_alu <= 1'h0;
            alu_state__rs2_from_mem <= 1'h0;
            alu_state__rs1 <= 32'h0;
            alu_state__rs2 <= 32'h0;
            alu_state__debug_instr_data <= 32'h0;
        end
        else if (clk__enable)
        begin
            alu_state__valid <= 1'h0;
            alu_state__idecode__rd_written <= 1'h0;
            if ((alu_combs__cannot_complete!=1'h0))
            begin
                if (!(alu_combs__cannot_start!=1'h0))
                begin
                    alu_state__first_cycle <= 1'h0;
                end //if
                alu_state__valid <= alu_state__valid;
                alu_state__first_cycle <= alu_state__first_cycle;
                alu_state__idecode__rs1 <= alu_state__idecode__rs1;
                alu_state__idecode__rs1_valid <= alu_state__idecode__rs1_valid;
                alu_state__idecode__rs2 <= alu_state__idecode__rs2;
                alu_state__idecode__rs2_valid <= alu_state__idecode__rs2_valid;
                alu_state__idecode__rd <= alu_state__idecode__rd;
                alu_state__idecode__rd_written <= alu_state__idecode__rd_written;
                alu_state__idecode__csr_access__access <= alu_state__idecode__csr_access__access;
                alu_state__idecode__csr_access__address <= alu_state__idecode__csr_access__address;
                alu_state__idecode__immediate <= alu_state__idecode__immediate;
                alu_state__idecode__immediate_shift <= alu_state__idecode__immediate_shift;
                alu_state__idecode__immediate_valid <= alu_state__idecode__immediate_valid;
                alu_state__idecode__op <= alu_state__idecode__op;
                alu_state__idecode__subop <= alu_state__idecode__subop;
                alu_state__idecode__requires_machine_mode <= alu_state__idecode__requires_machine_mode;
                alu_state__idecode__memory_read_unsigned <= alu_state__idecode__memory_read_unsigned;
                alu_state__idecode__memory_width <= alu_state__idecode__memory_width;
                alu_state__idecode__illegal <= alu_state__idecode__illegal;
                alu_state__idecode__is_compressed <= alu_state__idecode__is_compressed;
                alu_state__pc <= alu_state__pc;
                alu_state__illegal_pc <= alu_state__illegal_pc;
                alu_state__pc_if_mispredicted <= alu_state__pc_if_mispredicted;
                alu_state__predicted_branch <= alu_state__predicted_branch;
                alu_state__rs1_from_alu <= alu_state__rs1_from_alu;
                alu_state__rs1_from_mem <= alu_state__rs1_from_mem;
                alu_state__rs2_from_alu <= alu_state__rs2_from_alu;
                alu_state__rs2_from_mem <= alu_state__rs2_from_mem;
                alu_state__rs1 <= alu_state__rs1;
                alu_state__rs2 <= alu_state__rs2;
                alu_state__debug_instr_data <= alu_state__debug_instr_data;
                alu_state__rs1_from_alu <= 1'h0;
                alu_state__rs2_from_alu <= 1'h0;
                alu_state__rs1_from_mem <= alu_state__rs1_from_alu;
                alu_state__rs2_from_mem <= alu_state__rs2_from_alu;
                if ((alu_state__rs1_from_mem!=1'h0))
                begin
                    alu_state__rs1 <= rfw_state__mem_result;
                end //if
                if ((alu_state__rs2_from_mem!=1'h0))
                begin
                    alu_state__rs2 <= rfw_state__mem_result;
                end //if
            end //if
            else
            
            begin
                if (((dec_state__valid!=1'h0)&&!(alu_combs__flush_pipeline!=1'h0)))
                begin
                    alu_state__valid <= 1'h1;
                    alu_state__first_cycle <= 1'h1;
                    alu_state__illegal_pc <= dec_state__illegal_pc;
                    alu_state__idecode__rs1 <= dec_combs__idecode__rs1;
                    alu_state__idecode__rs1_valid <= dec_combs__idecode__rs1_valid;
                    alu_state__idecode__rs2 <= dec_combs__idecode__rs2;
                    alu_state__idecode__rs2_valid <= dec_combs__idecode__rs2_valid;
                    alu_state__idecode__rd <= dec_combs__idecode__rd;
                    alu_state__idecode__rd_written <= dec_combs__idecode__rd_written;
                    alu_state__idecode__csr_access__access <= dec_combs__idecode__csr_access__access;
                    alu_state__idecode__csr_access__address <= dec_combs__idecode__csr_access__address;
                    alu_state__idecode__immediate <= dec_combs__idecode__immediate;
                    alu_state__idecode__immediate_shift <= dec_combs__idecode__immediate_shift;
                    alu_state__idecode__immediate_valid <= dec_combs__idecode__immediate_valid;
                    alu_state__idecode__op <= dec_combs__idecode__op;
                    alu_state__idecode__subop <= dec_combs__idecode__subop;
                    alu_state__idecode__requires_machine_mode <= dec_combs__idecode__requires_machine_mode;
                    alu_state__idecode__memory_read_unsigned <= dec_combs__idecode__memory_read_unsigned;
                    alu_state__idecode__memory_width <= dec_combs__idecode__memory_width;
                    alu_state__idecode__illegal <= dec_combs__idecode__illegal;
                    alu_state__idecode__is_compressed <= dec_combs__idecode__is_compressed;
                    alu_state__pc <= dec_state__pc;
                    alu_state__pc_if_mispredicted <= dec_combs__pc_if_mispredicted;
                    alu_state__predicted_branch <= dec_combs__predict_branch;
                    alu_state__rs1 <= dec_combs__rs1;
                    alu_state__rs2 <= dec_combs__rs2;
                    alu_state__rs1_from_alu <= dec_combs__rs1_from_alu;
                    alu_state__rs1_from_mem <= dec_combs__rs1_from_mem;
                    alu_state__rs2_from_alu <= dec_combs__rs2_from_alu;
                    alu_state__rs2_from_mem <= dec_combs__rs2_from_mem;
                    alu_state__debug_instr_data <= dec_state__instr_data;
                end //if
            end //else
        end //if
    end //always

    //b alu_stage_logic combinatorial process
        //   
        //       The ALU stage does data forwarding, ALU operation, conditional branches, CSR accesses, memory request
        //       
    always @ ( * )//alu_stage_logic
    begin: alu_stage_logic__comb_code
    reg [31:0]alu_combs__rs1__var;
    reg alu_combs__blocked_by_mem__var;
    reg [31:0]alu_combs__rs2__var;
    reg csr_controls__retire__var;
    reg csr_controls__timer_inc__var;
    reg csr_controls__trap__var;
    reg [3:0]csr_controls__trap_cause__var;
    reg [31:0]csr_controls__trap_pc__var;
    reg [31:0]csr_controls__trap_value__var;
    reg [2:0]alu_combs__csr_access__access__var;
    reg [31:0]alu_combs__result_data__var;
    reg dmem_access_req__read_enable__var;
    reg dmem_access_req__write_enable__var;
    reg alu_combs__dmem_misaligned__var;
    reg alu_combs__dmem_multicycle__var;
    reg [3:0]alu_combs__read_data_byte_enable__var;
    reg [3:0]dmem_access_req__byte_enable__var;
    reg [31:0]dmem_access_req__write_data__var;
    reg alu_combs__trap__var;
    reg [3:0]alu_combs__trap_cause__var;
    reg [31:0]alu_combs__trap_value__var;
    reg alu_combs__branch_taken__var;
    reg alu_combs__mret__var;
    reg alu_combs__jalr__var;
    reg alu_combs__flush_pipeline__var;
    reg [31:0]alu_combs__next_pc__var;
        alu_combs__valid_legal = ((alu_state__valid!=1'h0)&&!(alu_state__idecode__illegal!=1'h0));
        alu_combs__rs1__var = alu_state__rs1;
        alu_combs__blocked_by_mem__var = 1'h0;
        if ((alu_state__rs1_from_mem!=1'h0))
        begin
            alu_combs__rs1__var = rfw_state__mem_result;
        end //if
        if ((alu_state__rs1_from_alu!=1'h0))
        begin
            alu_combs__rs1__var = mem_state__alu_result;
            if ((mem_state__rd_from_mem!=1'h0))
            begin
                alu_combs__blocked_by_mem__var = alu_state__idecode__rs1_valid;
            end //if
        end //if
        alu_combs__rs2__var = alu_state__rs2;
        if ((alu_state__rs2_from_mem!=1'h0))
        begin
            alu_combs__rs2__var = rfw_state__mem_result;
        end //if
        if ((alu_state__rs2_from_alu!=1'h0))
        begin
            alu_combs__rs2__var = mem_state__alu_result;
            if ((mem_state__rd_from_mem!=1'h0))
            begin
                alu_combs__blocked_by_mem__var = alu_state__idecode__rs2_valid;
            end //if
        end //if
        alu_combs__cannot_start = ((alu_combs__blocked_by_mem__var!=1'h0)||(coproc_response_cfg__cannot_start!=1'h0));
        alu_combs__cannot_complete = ((alu_combs__cannot_start!=1'h0)||(coproc_response_cfg__cannot_complete!=1'h0));
        csr_controls__retire__var = 1'h0;
        csr_controls__timer_inc__var = 1'h0;
        csr_controls__timer_clear = 1'h0;
        csr_controls__timer_load = 1'h0;
        csr_controls__timer_value = 64'h0;
        csr_controls__trap__var = 1'h0;
        csr_controls__trap_cause__var = 4'h0;
        csr_controls__trap_pc__var = 32'h0;
        csr_controls__trap_value__var = 32'h0;
        csr_controls__retire__var = alu_combs__valid_legal;
        csr_controls__timer_inc__var = 1'h1;
        alu_combs__csr_access__access__var = alu_state__idecode__csr_access__access;
        alu_combs__csr_access__address = alu_state__idecode__csr_access__address;
        if (!(alu_combs__valid_legal!=1'h0))
        begin
            alu_combs__csr_access__access__var = 3'h0;
        end //if
        alu_combs__result_data__var = (alu_result__result | coproc_response_cfg__result);
        if ((coproc_response_cfg__result_valid!=1'h0))
        begin
            alu_combs__result_data__var = coproc_response_cfg__result;
        end //if
        if ((alu_state__idecode__csr_access__access!=3'h0))
        begin
            alu_combs__result_data__var = csr_data__read_data;
        end //if
        dmem_access_req__read_enable__var = (alu_state__idecode__op==4'h6);
        dmem_access_req__write_enable__var = (alu_state__idecode__op==4'h7);
        if (!(alu_state__valid!=1'h0))
        begin
            dmem_access_req__read_enable__var = 1'h0;
            dmem_access_req__write_enable__var = 1'h0;
        end //if
        alu_combs__reading = dmem_access_req__read_enable__var;
        dmem_access_req__address = alu_result__arith_result;
        alu_combs__word_offset = alu_result__arith_result[1:0];
        alu_combs__dmem_misaligned__var = (alu_combs__word_offset!=2'h0);
        alu_combs__dmem_multicycle__var = (alu_combs__word_offset!=2'h0);
        alu_combs__read_data_rotation = alu_combs__word_offset;
        alu_combs__read_data_byte_enable__var = 4'hf;
        alu_combs__read_data_byte_clear = 4'hf;
        case (alu_state__idecode__memory_width) //synopsys parallel_case
        2'h0: // req 1
            begin
            dmem_access_req__byte_enable__var = (4'h1<<alu_combs__word_offset);
            alu_combs__read_data_byte_enable__var = 4'h1;
            alu_combs__dmem_misaligned__var = 1'h0;
            alu_combs__dmem_multicycle__var = 1'h0;
            end
        2'h1: // req 1
            begin
            dmem_access_req__byte_enable__var = (4'h3<<alu_combs__word_offset);
            alu_combs__read_data_byte_enable__var = 4'h3;
            alu_combs__dmem_misaligned__var = alu_combs__word_offset[0];
            alu_combs__dmem_multicycle__var = (alu_combs__word_offset==2'h3);
            end
        default: // req 1
            begin
            dmem_access_req__byte_enable__var = (4'hf<<alu_combs__word_offset);
            alu_combs__dmem_misaligned__var = (alu_combs__word_offset!=2'h0);
            alu_combs__dmem_multicycle__var = (alu_combs__word_offset!=2'h0);
            end
        endcase
        dmem_access_req__write_data__var = alu_combs__rs2__var;
        case (alu_combs__word_offset) //synopsys parallel_case
        2'h0: // req 1
            begin
            dmem_access_req__write_data__var = alu_combs__rs2__var;
            end
        2'h1: // req 1
            begin
            dmem_access_req__write_data__var = {alu_combs__rs2__var[23:0],alu_combs__rs2__var[31:24]};
            end
        2'h2: // req 1
            begin
            dmem_access_req__write_data__var = {alu_combs__rs2__var[15:0],alu_combs__rs2__var[31:16]};
            end
        2'h3: // req 1
            begin
            dmem_access_req__write_data__var = {alu_combs__rs2__var[7:0],alu_combs__rs2__var[31:8]};
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:riscv_i32c_pipeline3:alu_stage_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        alu_combs__trap__var = 1'h0;
        alu_combs__trap_cause__var = 4'h0;
        alu_combs__trap_value__var = 32'h0;
        alu_combs__branch_taken__var = 1'h0;
        alu_combs__mret__var = 1'h0;
        alu_combs__jalr__var = 1'h0;
        case (alu_state__idecode__op) //synopsys parallel_case
        4'h0: // req 1
            begin
            alu_combs__branch_taken__var = alu_result__branch_condition_met;
            end
        4'h1: // req 1
            begin
            alu_combs__branch_taken__var = 1'h1;
            end
        4'h2: // req 1
            begin
            alu_combs__jalr__var = 1'h1;
            end
        4'h3: // req 1
            begin
            if ((alu_state__idecode__subop==4'h2))
            begin
                alu_combs__mret__var = 1'h1;
            end //if
            if ((alu_state__idecode__subop==4'h0))
            begin
                alu_combs__trap__var = 1'h1;
                alu_combs__trap_cause__var = 4'hb;
            end //if
            if ((alu_state__idecode__subop==4'h1))
            begin
                alu_combs__trap__var = 1'h1;
                alu_combs__trap_cause__var = 4'h3;
                alu_combs__trap_value__var = alu_state__pc;
            end //if
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
        if ((alu_state__idecode__illegal!=1'h0))
        begin
            alu_combs__trap__var = 1'h1;
            alu_combs__trap_cause__var = 4'h2;
            alu_combs__trap_value__var = alu_state__debug_instr_data;
        end //if
        if ((alu_state__illegal_pc!=1'h0))
        begin
            alu_combs__trap__var = 1'h1;
            alu_combs__trap_cause__var = 4'h0;
            alu_combs__trap_value__var = alu_state__pc;
        end //if
        alu_combs__flush_pipeline__var = 1'h0;
        alu_combs__next_pc__var = alu_state__pc_if_mispredicted;
        if ((alu_combs__branch_taken__var!=1'h0))
        begin
            alu_combs__flush_pipeline__var = !(alu_state__predicted_branch!=1'h0);
        end //if
        else
        
        begin
            alu_combs__flush_pipeline__var = alu_state__predicted_branch;
        end //else
        if ((alu_combs__jalr__var!=1'h0))
        begin
            alu_combs__flush_pipeline__var = 1'h1;
            alu_combs__next_pc__var = alu_result__arith_result;
        end //if
        if ((alu_combs__mret__var!=1'h0))
        begin
            alu_combs__flush_pipeline__var = 1'h1;
            alu_combs__next_pc__var = csrs__mepc;
        end //if
        if ((alu_combs__trap__var!=1'h0))
        begin
            alu_combs__flush_pipeline__var = 1'h1;
            alu_combs__next_pc__var = csrs__mtvec;
        end //if
        if ((!(alu_state__valid!=1'h0)||(alu_combs__cannot_complete!=1'h0)))
        begin
            alu_combs__flush_pipeline__var = 1'h0;
        end //if
        csr_controls__trap_cause__var = alu_combs__trap_cause__var;
        csr_controls__trap__var = 1'h0;
        csr_controls__trap_pc__var = alu_state__pc;
        csr_controls__trap_value__var = alu_combs__trap_value__var;
        if ((alu_combs__trap__var!=1'h0))
        begin
            csr_controls__trap__var = alu_state__valid;
        end //if
        alu_combs__rs1 = alu_combs__rs1__var;
        alu_combs__blocked_by_mem = alu_combs__blocked_by_mem__var;
        alu_combs__rs2 = alu_combs__rs2__var;
        csr_controls__retire = csr_controls__retire__var;
        csr_controls__timer_inc = csr_controls__timer_inc__var;
        csr_controls__trap = csr_controls__trap__var;
        csr_controls__trap_cause = csr_controls__trap_cause__var;
        csr_controls__trap_pc = csr_controls__trap_pc__var;
        csr_controls__trap_value = csr_controls__trap_value__var;
        alu_combs__csr_access__access = alu_combs__csr_access__access__var;
        alu_combs__result_data = alu_combs__result_data__var;
        dmem_access_req__read_enable = dmem_access_req__read_enable__var;
        dmem_access_req__write_enable = dmem_access_req__write_enable__var;
        alu_combs__dmem_misaligned = alu_combs__dmem_misaligned__var;
        alu_combs__dmem_multicycle = alu_combs__dmem_multicycle__var;
        alu_combs__read_data_byte_enable = alu_combs__read_data_byte_enable__var;
        dmem_access_req__byte_enable = dmem_access_req__byte_enable__var;
        dmem_access_req__write_data = dmem_access_req__write_data__var;
        alu_combs__trap = alu_combs__trap__var;
        alu_combs__trap_cause = alu_combs__trap_cause__var;
        alu_combs__trap_value = alu_combs__trap_value__var;
        alu_combs__branch_taken = alu_combs__branch_taken__var;
        alu_combs__mret = alu_combs__mret__var;
        alu_combs__jalr = alu_combs__jalr__var;
        alu_combs__flush_pipeline = alu_combs__flush_pipeline__var;
        alu_combs__next_pc = alu_combs__next_pc__var;
    end //always

    //b memory_stage__comb combinatorial process
        //   
        //       The memory access stage is when the memory is performing a read
        //   
        //       When unaligned accesses are supported this will merge two reads
        //       using multiple cycles
        //   
        //       This is a single cycle, with committed transactions only being
        //       valid
        //   
        //       If the memory is performing a read then the memory data is rotated
        //       and presented as the result; otherwise the ALU result is passed
        //       through.
        //   
        //       
    always @ ( * )//memory_stage__comb
    begin: memory_stage__comb_code
    reg [31:0]mem_combs__aligned_data__var;
    reg [31:0]mem_combs__memory_data__var;
    reg [31:0]mem_combs__result_data__var;
        mem_combs__aligned_data__var = dmem_access_resp__read_data;
        case (mem_state__rotation) //synopsys parallel_case
        2'h0: // req 1
            begin
            mem_combs__aligned_data__var = dmem_access_resp__read_data;
            end
        2'h1: // req 1
            begin
            mem_combs__aligned_data__var = {dmem_access_resp__read_data[7:0],dmem_access_resp__read_data[31:8]};
            end
        2'h2: // req 1
            begin
            mem_combs__aligned_data__var = {dmem_access_resp__read_data[15:0],dmem_access_resp__read_data[31:16]};
            end
        2'h3: // req 1
            begin
            mem_combs__aligned_data__var = {dmem_access_resp__read_data[23:0],dmem_access_resp__read_data[31:24]};
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:riscv_i32c_pipeline3:memory_stage: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        mem_combs__memory_data__var = mem_combs__aligned_data__var;
        mem_combs__memory_data__var[7:0] = (((mem_state__byte_clear[0]!=1'h0)?8'h0:mem_state__alu_result[7:0]) | ((mem_state__byte_enable[0]!=1'h0)?mem_combs__aligned_data__var[7:0]:8'h0));
        mem_combs__memory_data__var[15:8] = (((mem_state__byte_clear[1]!=1'h0)?8'h0:mem_state__alu_result[15:8]) | ((mem_state__byte_enable[1]!=1'h0)?mem_combs__aligned_data__var[15:8]:8'h0));
        mem_combs__memory_data__var[23:16] = (((mem_state__byte_clear[2]!=1'h0)?8'h0:mem_state__alu_result[23:16]) | ((mem_state__byte_enable[2]!=1'h0)?mem_combs__aligned_data__var[23:16]:8'h0));
        mem_combs__memory_data__var[31:24] = (((mem_state__byte_clear[3]!=1'h0)?8'h0:mem_state__alu_result[31:24]) | ((mem_state__byte_enable[3]!=1'h0)?mem_combs__aligned_data__var[31:24]:8'h0));
        if (((mem_state__sign_extend_byte!=1'h0)&&(mem_combs__memory_data__var[7]!=1'h0)))
        begin
            mem_combs__memory_data__var[31:8] = 24'hffffff;
        end //if
        if (((mem_state__sign_extend_half!=1'h0)&&(mem_combs__memory_data__var[15]!=1'h0)))
        begin
            mem_combs__memory_data__var[31:16] = 16'hffff;
        end //if
        mem_combs__result_data__var = mem_state__alu_result;
        if ((mem_state__reading!=1'h0))
        begin
            mem_combs__result_data__var = mem_combs__memory_data__var;
        end //if
        mem_combs__aligned_data = mem_combs__aligned_data__var;
        mem_combs__memory_data = mem_combs__memory_data__var;
        mem_combs__result_data = mem_combs__result_data__var;
    end //always

    //b memory_stage__posedge_clk_active_low_reset_n clock process
        //   
        //       The memory access stage is when the memory is performing a read
        //   
        //       When unaligned accesses are supported this will merge two reads
        //       using multiple cycles
        //   
        //       This is a single cycle, with committed transactions only being
        //       valid
        //   
        //       If the memory is performing a read then the memory data is rotated
        //       and presented as the result; otherwise the ALU result is passed
        //       through.
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : memory_stage__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            mem_state__valid <= 1'h0;
            mem_state__reading <= 1'h0;
            mem_state__rd_written <= 1'h0;
            mem_state__rd_from_mem <= 1'h0;
            mem_state__rotation <= 2'h0;
            mem_state__byte_enable <= 4'h0;
            mem_state__byte_clear <= 4'h0;
            mem_state__rd <= 5'h0;
            mem_state__alu_result <= 32'h0;
            mem_state__sign_extend_half <= 1'h0;
            mem_state__sign_extend_byte <= 1'h0;
        end
        else if (clk__enable)
        begin
            mem_state__valid <= 1'h0;
            mem_state__reading <= 1'h0;
            mem_state__rd_written <= 1'h0;
            mem_state__rd_from_mem <= 1'h0;
            mem_state__rotation <= 2'h0;
            mem_state__byte_enable <= 4'h0;
            mem_state__byte_clear <= 4'hf;
            if (((alu_combs__valid_legal!=1'h0)&&!(alu_combs__cannot_complete!=1'h0)))
            begin
                mem_state__valid <= 1'h1;
                mem_state__reading <= alu_combs__reading;
                mem_state__rotation <= alu_combs__read_data_rotation;
                mem_state__byte_enable <= alu_combs__read_data_byte_enable;
                mem_state__byte_clear <= alu_combs__read_data_byte_clear;
                mem_state__rd_written <= alu_state__idecode__rd_written;
                if (((alu_combs__reading!=1'h0)&&(alu_state__idecode__rd_written!=1'h0)))
                begin
                    mem_state__rd_from_mem <= 1'h1;
                end //if
                mem_state__rd <= alu_state__idecode__rd;
                mem_state__alu_result <= alu_combs__result_data;
                mem_state__sign_extend_half <= (!(alu_state__idecode__memory_read_unsigned!=1'h0)&&(alu_state__idecode__memory_width==2'h1));
                mem_state__sign_extend_byte <= (!(alu_state__idecode__memory_read_unsigned!=1'h0)&&(alu_state__idecode__memory_width==2'h0));
            end //if
        end //if
    end //always

    //b rfw_stage clock process
        //   
        //       The RFW stage takes the memory read data and memory stage internal data,
        //       and combines them, preparing the result for the register file (written at the end of the clock)
        //       
    always @( posedge clk or negedge reset_n)
    begin : rfw_stage__code
        if (reset_n==1'b0)
        begin
            rfw_state__valid <= 1'h0;
            rfw_state__rd_written <= 1'h0;
            rfw_state__rd <= 5'h0;
            rfw_state__mem_result <= 32'h0;
            registers[0] <= 32'hffffffffffffffff;
            registers[1] <= 32'hffffffffffffffff;
            registers[2] <= 32'hffffffffffffffff;
            registers[3] <= 32'hffffffffffffffff;
            registers[4] <= 32'hffffffffffffffff;
            registers[5] <= 32'hffffffffffffffff;
            registers[6] <= 32'hffffffffffffffff;
            registers[7] <= 32'hffffffffffffffff;
            registers[8] <= 32'hffffffffffffffff;
            registers[9] <= 32'hffffffffffffffff;
            registers[10] <= 32'hffffffffffffffff;
            registers[11] <= 32'hffffffffffffffff;
            registers[12] <= 32'hffffffffffffffff;
            registers[13] <= 32'hffffffffffffffff;
            registers[14] <= 32'hffffffffffffffff;
            registers[15] <= 32'hffffffffffffffff;
            registers[16] <= 32'hffffffffffffffff;
            registers[17] <= 32'hffffffffffffffff;
            registers[18] <= 32'hffffffffffffffff;
            registers[19] <= 32'hffffffffffffffff;
            registers[20] <= 32'hffffffffffffffff;
            registers[21] <= 32'hffffffffffffffff;
            registers[22] <= 32'hffffffffffffffff;
            registers[23] <= 32'hffffffffffffffff;
            registers[24] <= 32'hffffffffffffffff;
            registers[25] <= 32'hffffffffffffffff;
            registers[26] <= 32'hffffffffffffffff;
            registers[27] <= 32'hffffffffffffffff;
            registers[28] <= 32'hffffffffffffffff;
            registers[29] <= 32'hffffffffffffffff;
            registers[30] <= 32'hffffffffffffffff;
            registers[31] <= 32'hffffffffffffffff;
        end
        else if (clk__enable)
        begin
            rfw_state__valid <= 1'h0;
            rfw_state__rd_written <= 1'h0;
            if ((mem_state__valid!=1'h0))
            begin
                rfw_state__valid <= 1'h1;
                rfw_state__rd_written <= mem_state__rd_written;
                rfw_state__rd <= mem_state__rd;
                rfw_state__mem_result <= mem_combs__result_data;
                if ((mem_state__rd_written!=1'h0))
                begin
                    registers[mem_state__rd] <= mem_combs__result_data;
                end //if
            end //if
            registers[0] <= 32'h0;
        end //if
    end //always

    //b coprocessor_interface combinatorial process
        //   
        //       Drive the coprocessor controls unless disabled; mirror the pipeline combs
        //       
    always @ ( * )//coprocessor_interface
    begin: coprocessor_interface__comb_code
    reg coproc_response_cfg__cannot_start__var;
    reg [31:0]coproc_response_cfg__result__var;
    reg coproc_response_cfg__result_valid__var;
    reg coproc_response_cfg__cannot_complete__var;
    reg coproc_controls__dec_idecode_valid__var;
    reg [4:0]coproc_controls__dec_idecode__rs1__var;
    reg coproc_controls__dec_idecode__rs1_valid__var;
    reg [4:0]coproc_controls__dec_idecode__rs2__var;
    reg coproc_controls__dec_idecode__rs2_valid__var;
    reg [4:0]coproc_controls__dec_idecode__rd__var;
    reg coproc_controls__dec_idecode__rd_written__var;
    reg [2:0]coproc_controls__dec_idecode__csr_access__access__var;
    reg [11:0]coproc_controls__dec_idecode__csr_access__address__var;
    reg [31:0]coproc_controls__dec_idecode__immediate__var;
    reg [4:0]coproc_controls__dec_idecode__immediate_shift__var;
    reg coproc_controls__dec_idecode__immediate_valid__var;
    reg [3:0]coproc_controls__dec_idecode__op__var;
    reg [3:0]coproc_controls__dec_idecode__subop__var;
    reg coproc_controls__dec_idecode__requires_machine_mode__var;
    reg coproc_controls__dec_idecode__memory_read_unsigned__var;
    reg [1:0]coproc_controls__dec_idecode__memory_width__var;
    reg coproc_controls__dec_idecode__illegal__var;
    reg coproc_controls__dec_idecode__is_compressed__var;
    reg coproc_controls__dec_to_alu_blocked__var;
    reg [31:0]coproc_controls__alu_rs1__var;
    reg [31:0]coproc_controls__alu_rs2__var;
    reg coproc_controls__alu_flush_pipeline__var;
    reg coproc_controls__alu_cannot_start__var;
    reg coproc_controls__alu_cannot_complete__var;
        coproc_response_cfg__cannot_start__var = coproc_response__cannot_start;
        coproc_response_cfg__result__var = coproc_response__result;
        coproc_response_cfg__result_valid__var = coproc_response__result_valid;
        coproc_response_cfg__cannot_complete__var = coproc_response__cannot_complete;
        if (((1'h0!=64'h0)||(riscv_config__coproc_disable!=1'h0)))
        begin
            coproc_response_cfg__cannot_start__var = 1'h0;
            coproc_response_cfg__result__var = 32'h0;
            coproc_response_cfg__result_valid__var = 1'h0;
            coproc_response_cfg__cannot_complete__var = 1'h0;
        end //if
        coproc_controls__dec_idecode_valid__var = 1'h0;
        coproc_controls__dec_idecode__rs1__var = 5'h0;
        coproc_controls__dec_idecode__rs1_valid__var = 1'h0;
        coproc_controls__dec_idecode__rs2__var = 5'h0;
        coproc_controls__dec_idecode__rs2_valid__var = 1'h0;
        coproc_controls__dec_idecode__rd__var = 5'h0;
        coproc_controls__dec_idecode__rd_written__var = 1'h0;
        coproc_controls__dec_idecode__csr_access__access__var = 3'h0;
        coproc_controls__dec_idecode__csr_access__address__var = 12'h0;
        coproc_controls__dec_idecode__immediate__var = 32'h0;
        coproc_controls__dec_idecode__immediate_shift__var = 5'h0;
        coproc_controls__dec_idecode__immediate_valid__var = 1'h0;
        coproc_controls__dec_idecode__op__var = 4'h0;
        coproc_controls__dec_idecode__subop__var = 4'h0;
        coproc_controls__dec_idecode__requires_machine_mode__var = 1'h0;
        coproc_controls__dec_idecode__memory_read_unsigned__var = 1'h0;
        coproc_controls__dec_idecode__memory_width__var = 2'h0;
        coproc_controls__dec_idecode__illegal__var = 1'h0;
        coproc_controls__dec_idecode__is_compressed__var = 1'h0;
        coproc_controls__dec_to_alu_blocked__var = 1'h0;
        coproc_controls__alu_rs1__var = 32'h0;
        coproc_controls__alu_rs2__var = 32'h0;
        coproc_controls__alu_flush_pipeline__var = 1'h0;
        coproc_controls__alu_cannot_start__var = 1'h0;
        coproc_controls__alu_cannot_complete__var = 1'h0;
        coproc_controls__dec_idecode_valid__var = dec_state__valid;
        coproc_controls__dec_idecode__rs1__var = dec_combs__idecode__rs1;
        coproc_controls__dec_idecode__rs1_valid__var = dec_combs__idecode__rs1_valid;
        coproc_controls__dec_idecode__rs2__var = dec_combs__idecode__rs2;
        coproc_controls__dec_idecode__rs2_valid__var = dec_combs__idecode__rs2_valid;
        coproc_controls__dec_idecode__rd__var = dec_combs__idecode__rd;
        coproc_controls__dec_idecode__rd_written__var = dec_combs__idecode__rd_written;
        coproc_controls__dec_idecode__csr_access__access__var = dec_combs__idecode__csr_access__access;
        coproc_controls__dec_idecode__csr_access__address__var = dec_combs__idecode__csr_access__address;
        coproc_controls__dec_idecode__immediate__var = dec_combs__idecode__immediate;
        coproc_controls__dec_idecode__immediate_shift__var = dec_combs__idecode__immediate_shift;
        coproc_controls__dec_idecode__immediate_valid__var = dec_combs__idecode__immediate_valid;
        coproc_controls__dec_idecode__op__var = dec_combs__idecode__op;
        coproc_controls__dec_idecode__subop__var = dec_combs__idecode__subop;
        coproc_controls__dec_idecode__requires_machine_mode__var = dec_combs__idecode__requires_machine_mode;
        coproc_controls__dec_idecode__memory_read_unsigned__var = dec_combs__idecode__memory_read_unsigned;
        coproc_controls__dec_idecode__memory_width__var = dec_combs__idecode__memory_width;
        coproc_controls__dec_idecode__illegal__var = dec_combs__idecode__illegal;
        coproc_controls__dec_idecode__is_compressed__var = dec_combs__idecode__is_compressed;
        coproc_controls__dec_to_alu_blocked__var = alu_combs__cannot_complete;
        coproc_controls__alu_rs1__var = alu_combs__rs1;
        coproc_controls__alu_rs2__var = alu_combs__rs2;
        coproc_controls__alu_flush_pipeline__var = alu_combs__flush_pipeline;
        coproc_controls__alu_cannot_start__var = alu_combs__blocked_by_mem;
        coproc_controls__alu_cannot_complete__var = alu_combs__cannot_complete;
        if (((1'h0!=64'h0)||(riscv_config__coproc_disable!=1'h0)))
        begin
            coproc_controls__dec_idecode_valid__var = 1'h0;
            coproc_controls__dec_idecode__rs1__var = 5'h0;
            coproc_controls__dec_idecode__rs1_valid__var = 1'h0;
            coproc_controls__dec_idecode__rs2__var = 5'h0;
            coproc_controls__dec_idecode__rs2_valid__var = 1'h0;
            coproc_controls__dec_idecode__rd__var = 5'h0;
            coproc_controls__dec_idecode__rd_written__var = 1'h0;
            coproc_controls__dec_idecode__csr_access__access__var = 3'h0;
            coproc_controls__dec_idecode__csr_access__address__var = 12'h0;
            coproc_controls__dec_idecode__immediate__var = 32'h0;
            coproc_controls__dec_idecode__immediate_shift__var = 5'h0;
            coproc_controls__dec_idecode__immediate_valid__var = 1'h0;
            coproc_controls__dec_idecode__op__var = 4'h0;
            coproc_controls__dec_idecode__subop__var = 4'h0;
            coproc_controls__dec_idecode__requires_machine_mode__var = 1'h0;
            coproc_controls__dec_idecode__memory_read_unsigned__var = 1'h0;
            coproc_controls__dec_idecode__memory_width__var = 2'h0;
            coproc_controls__dec_idecode__illegal__var = 1'h0;
            coproc_controls__dec_idecode__is_compressed__var = 1'h0;
            coproc_controls__dec_to_alu_blocked__var = 1'h0;
            coproc_controls__alu_rs1__var = 32'h0;
            coproc_controls__alu_rs2__var = 32'h0;
            coproc_controls__alu_flush_pipeline__var = 1'h0;
            coproc_controls__alu_cannot_start__var = 1'h0;
            coproc_controls__alu_cannot_complete__var = 1'h0;
        end //if
        coproc_response_cfg__cannot_start = coproc_response_cfg__cannot_start__var;
        coproc_response_cfg__result = coproc_response_cfg__result__var;
        coproc_response_cfg__result_valid = coproc_response_cfg__result_valid__var;
        coproc_response_cfg__cannot_complete = coproc_response_cfg__cannot_complete__var;
        coproc_controls__dec_idecode_valid = coproc_controls__dec_idecode_valid__var;
        coproc_controls__dec_idecode__rs1 = coproc_controls__dec_idecode__rs1__var;
        coproc_controls__dec_idecode__rs1_valid = coproc_controls__dec_idecode__rs1_valid__var;
        coproc_controls__dec_idecode__rs2 = coproc_controls__dec_idecode__rs2__var;
        coproc_controls__dec_idecode__rs2_valid = coproc_controls__dec_idecode__rs2_valid__var;
        coproc_controls__dec_idecode__rd = coproc_controls__dec_idecode__rd__var;
        coproc_controls__dec_idecode__rd_written = coproc_controls__dec_idecode__rd_written__var;
        coproc_controls__dec_idecode__csr_access__access = coproc_controls__dec_idecode__csr_access__access__var;
        coproc_controls__dec_idecode__csr_access__address = coproc_controls__dec_idecode__csr_access__address__var;
        coproc_controls__dec_idecode__immediate = coproc_controls__dec_idecode__immediate__var;
        coproc_controls__dec_idecode__immediate_shift = coproc_controls__dec_idecode__immediate_shift__var;
        coproc_controls__dec_idecode__immediate_valid = coproc_controls__dec_idecode__immediate_valid__var;
        coproc_controls__dec_idecode__op = coproc_controls__dec_idecode__op__var;
        coproc_controls__dec_idecode__subop = coproc_controls__dec_idecode__subop__var;
        coproc_controls__dec_idecode__requires_machine_mode = coproc_controls__dec_idecode__requires_machine_mode__var;
        coproc_controls__dec_idecode__memory_read_unsigned = coproc_controls__dec_idecode__memory_read_unsigned__var;
        coproc_controls__dec_idecode__memory_width = coproc_controls__dec_idecode__memory_width__var;
        coproc_controls__dec_idecode__illegal = coproc_controls__dec_idecode__illegal__var;
        coproc_controls__dec_idecode__is_compressed = coproc_controls__dec_idecode__is_compressed__var;
        coproc_controls__dec_to_alu_blocked = coproc_controls__dec_to_alu_blocked__var;
        coproc_controls__alu_rs1 = coproc_controls__alu_rs1__var;
        coproc_controls__alu_rs2 = coproc_controls__alu_rs2__var;
        coproc_controls__alu_flush_pipeline = coproc_controls__alu_flush_pipeline__var;
        coproc_controls__alu_cannot_start = coproc_controls__alu_cannot_start__var;
        coproc_controls__alu_cannot_complete = coproc_controls__alu_cannot_complete__var;
    end //always

    //b logging combinatorial process
        //   
        //       
    always @ ( * )//logging
    begin: logging__comb_code
    reg trace__instr_valid__var;
    reg [31:0]trace__instr_pc__var;
    reg [31:0]trace__instr_data__var;
    reg trace__rfw_retire__var;
    reg trace__rfw_data_valid__var;
    reg [4:0]trace__rfw_rd__var;
    reg [31:0]trace__rfw_data__var;
    reg trace__branch_taken__var;
    reg [31:0]trace__branch_target__var;
    reg trace__trap__var;
        trace__instr_valid__var = 1'h0;
        trace__instr_pc__var = 32'h0;
        trace__instr_data__var = 32'h0;
        trace__rfw_retire__var = 1'h0;
        trace__rfw_data_valid__var = 1'h0;
        trace__rfw_rd__var = 5'h0;
        trace__rfw_data__var = 32'h0;
        trace__branch_taken__var = 1'h0;
        trace__branch_target__var = 32'h0;
        trace__trap__var = 1'h0;
        trace__instr_valid__var = alu_state__valid;
        trace__instr_pc__var = alu_state__pc;
        trace__instr_data__var = alu_state__debug_instr_data;
        trace__rfw_retire__var = rfw_state__valid;
        trace__rfw_data_valid__var = rfw_state__rd_written;
        trace__rfw_rd__var = rfw_state__rd;
        trace__rfw_data__var = rfw_state__mem_result;
        trace__branch_taken__var = ((alu_combs__branch_taken!=1'h0)||(alu_combs__jalr!=1'h0));
        trace__trap__var = alu_combs__trap;
        trace__branch_target__var = alu_combs__next_pc;
        trace__instr_valid = trace__instr_valid__var;
        trace__instr_pc = trace__instr_pc__var;
        trace__instr_data = trace__instr_data__var;
        trace__rfw_retire = trace__rfw_retire__var;
        trace__rfw_data_valid = trace__rfw_data_valid__var;
        trace__rfw_rd = trace__rfw_rd__var;
        trace__rfw_data = trace__rfw_data__var;
        trace__branch_taken = trace__branch_taken__var;
        trace__branch_target = trace__branch_target__var;
        trace__trap = trace__trap__var;
    end //always

endmodule // riscv_i32c_pipeline3
