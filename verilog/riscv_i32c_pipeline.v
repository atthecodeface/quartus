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

//a Module riscv_i32c_pipeline
    //   
    //   This is just the processor pipeline, using a single stage for execution.
    //   
    //   The instruction fetch request for the next cycle is put out just after
    //   the ALU stage logic, which may be a long time into the cycle; the
    //   fetch data response presents the instruction fetched at the end of the
    //   cycle, where it is registered for execution.
    //   
    //   The pipeline is then a single stage that takes the fetched
    //   instruction, decodes, fetches register values, and executes the ALU
    //   stage; determining in half a cycle the next instruction fetch, and in
    //   the whole cycle the data memory request, which is valid just before
    //   the end
    //   
    //   A coprocessor is supported; this may be configured to be disabled, in
    //   which case the outputs are driven low and the inputs are coprocessor
    //   response is ignored.
    //   
    //   A coprocessor can implement, for example, the multiply for i32m (using riscv_i32_muldiv).
    //   
    //   
module riscv_i32c_pipeline
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
    trace__instruction__mode,
    trace__instruction__data,
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
    coproc_controls__dec_idecode__ext__dummy,
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
    output [2:0]trace__instruction__mode;
    output [31:0]trace__instruction__data;
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
    output coproc_controls__dec_idecode__ext__dummy;
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
    reg [2:0]trace__instruction__mode;
    reg [31:0]trace__instruction__data;
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
    reg coproc_controls__dec_idecode__ext__dummy;
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
    reg decexecrfw_state__enable;
    reg [2:0]decexecrfw_state__instruction__mode;
    reg [31:0]decexecrfw_state__instruction__data;
    reg decexecrfw_state__valid;
    reg decexecrfw_state__valid_legal;
    reg decexecrfw_state__illegal_pc;
    reg [31:0]decexecrfw_state__pc;
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
    reg [4:0]decexecrfw_combs__idecode__rs1;
    reg decexecrfw_combs__idecode__rs1_valid;
    reg [4:0]decexecrfw_combs__idecode__rs2;
    reg decexecrfw_combs__idecode__rs2_valid;
    reg [4:0]decexecrfw_combs__idecode__rd;
    reg decexecrfw_combs__idecode__rd_written;
    reg [2:0]decexecrfw_combs__idecode__csr_access__access;
    reg [11:0]decexecrfw_combs__idecode__csr_access__address;
    reg [31:0]decexecrfw_combs__idecode__immediate;
    reg [4:0]decexecrfw_combs__idecode__immediate_shift;
    reg decexecrfw_combs__idecode__immediate_valid;
    reg [3:0]decexecrfw_combs__idecode__op;
    reg [3:0]decexecrfw_combs__idecode__subop;
    reg decexecrfw_combs__idecode__requires_machine_mode;
    reg decexecrfw_combs__idecode__memory_read_unsigned;
    reg [1:0]decexecrfw_combs__idecode__memory_width;
    reg decexecrfw_combs__idecode__illegal;
    reg decexecrfw_combs__idecode__is_compressed;
    reg decexecrfw_combs__idecode__ext__dummy;
    reg [31:0]decexecrfw_combs__rs1;
    reg [31:0]decexecrfw_combs__rs2;
    reg [31:0]decexecrfw_combs__pc_plus_4;
    reg [31:0]decexecrfw_combs__pc_plus_2;
    reg [31:0]decexecrfw_combs__pc_plus_inst;
    reg [31:0]decexecrfw_combs__next_pc;
    reg decexecrfw_combs__fetch_sequential;
    reg [1:0]decexecrfw_combs__word_offset;
    reg [31:0]decexecrfw_combs__branch_target;
    reg decexecrfw_combs__branch_taken;
    reg decexecrfw_combs__trap;
    reg [3:0]decexecrfw_combs__trap_cause;
    reg [31:0]decexecrfw_combs__trap_value;
    reg [2:0]decexecrfw_combs__csr_access__access;
    reg [11:0]decexecrfw_combs__csr_access__address;
    reg [31:0]decexecrfw_combs__rfw_write_data;
    reg [31:0]decexecrfw_combs__memory_data;
    reg decexecrfw_combs__dmem_misaligned;
    reg decexecrfw_combs__load_address_misaligned;
    reg decexecrfw_combs__store_address_misaligned;
    reg ifetch_combs__request;
    reg [31:0]ifetch_combs__address;

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
    wire [31:0]decexecrfw_alu_result__result;
    wire [31:0]decexecrfw_alu_result__arith_result;
    wire decexecrfw_alu_result__branch_condition_met;
    wire [31:0]decexecrfw_alu_result__branch_target;
    wire [2:0]decexecrfw_alu_result__csr_access__access;
    wire [11:0]decexecrfw_alu_result__csr_access__address;
    wire [4:0]decexecrfw_idecode_i32c__rs1;
    wire decexecrfw_idecode_i32c__rs1_valid;
    wire [4:0]decexecrfw_idecode_i32c__rs2;
    wire decexecrfw_idecode_i32c__rs2_valid;
    wire [4:0]decexecrfw_idecode_i32c__rd;
    wire decexecrfw_idecode_i32c__rd_written;
    wire [2:0]decexecrfw_idecode_i32c__csr_access__access;
    wire [11:0]decexecrfw_idecode_i32c__csr_access__address;
    wire [31:0]decexecrfw_idecode_i32c__immediate;
    wire [4:0]decexecrfw_idecode_i32c__immediate_shift;
    wire decexecrfw_idecode_i32c__immediate_valid;
    wire [3:0]decexecrfw_idecode_i32c__op;
    wire [3:0]decexecrfw_idecode_i32c__subop;
    wire decexecrfw_idecode_i32c__requires_machine_mode;
    wire decexecrfw_idecode_i32c__memory_read_unsigned;
    wire [1:0]decexecrfw_idecode_i32c__memory_width;
    wire decexecrfw_idecode_i32c__illegal;
    wire decexecrfw_idecode_i32c__is_compressed;
    wire decexecrfw_idecode_i32c__ext__dummy;
    wire [4:0]decexecrfw_idecode_i32__rs1;
    wire decexecrfw_idecode_i32__rs1_valid;
    wire [4:0]decexecrfw_idecode_i32__rs2;
    wire decexecrfw_idecode_i32__rs2_valid;
    wire [4:0]decexecrfw_idecode_i32__rd;
    wire decexecrfw_idecode_i32__rd_written;
    wire [2:0]decexecrfw_idecode_i32__csr_access__access;
    wire [11:0]decexecrfw_idecode_i32__csr_access__address;
    wire [31:0]decexecrfw_idecode_i32__immediate;
    wire [4:0]decexecrfw_idecode_i32__immediate_shift;
    wire decexecrfw_idecode_i32__immediate_valid;
    wire [3:0]decexecrfw_idecode_i32__op;
    wire [3:0]decexecrfw_idecode_i32__subop;
    wire decexecrfw_idecode_i32__requires_machine_mode;
    wire decexecrfw_idecode_i32__memory_read_unsigned;
    wire [1:0]decexecrfw_idecode_i32__memory_width;
    wire decexecrfw_idecode_i32__illegal;
    wire decexecrfw_idecode_i32__is_compressed;
    wire decexecrfw_idecode_i32__ext__dummy;

    //b Clock gating module instances
    //b Module instances
    riscv_i32_decode decode_i32(
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .instruction__data(decexecrfw_state__instruction__data),
        .instruction__mode(decexecrfw_state__instruction__mode),
        .idecode__ext__dummy(            decexecrfw_idecode_i32__ext__dummy),
        .idecode__is_compressed(            decexecrfw_idecode_i32__is_compressed),
        .idecode__illegal(            decexecrfw_idecode_i32__illegal),
        .idecode__memory_width(            decexecrfw_idecode_i32__memory_width),
        .idecode__memory_read_unsigned(            decexecrfw_idecode_i32__memory_read_unsigned),
        .idecode__requires_machine_mode(            decexecrfw_idecode_i32__requires_machine_mode),
        .idecode__subop(            decexecrfw_idecode_i32__subop),
        .idecode__op(            decexecrfw_idecode_i32__op),
        .idecode__immediate_valid(            decexecrfw_idecode_i32__immediate_valid),
        .idecode__immediate_shift(            decexecrfw_idecode_i32__immediate_shift),
        .idecode__immediate(            decexecrfw_idecode_i32__immediate),
        .idecode__csr_access__address(            decexecrfw_idecode_i32__csr_access__address),
        .idecode__csr_access__access(            decexecrfw_idecode_i32__csr_access__access),
        .idecode__rd_written(            decexecrfw_idecode_i32__rd_written),
        .idecode__rd(            decexecrfw_idecode_i32__rd),
        .idecode__rs2_valid(            decexecrfw_idecode_i32__rs2_valid),
        .idecode__rs2(            decexecrfw_idecode_i32__rs2),
        .idecode__rs1_valid(            decexecrfw_idecode_i32__rs1_valid),
        .idecode__rs1(            decexecrfw_idecode_i32__rs1)         );
    riscv_i32c_decode decode_i32c(
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .instruction__data(decexecrfw_state__instruction__data),
        .instruction__mode(decexecrfw_state__instruction__mode),
        .idecode__ext__dummy(            decexecrfw_idecode_i32c__ext__dummy),
        .idecode__is_compressed(            decexecrfw_idecode_i32c__is_compressed),
        .idecode__illegal(            decexecrfw_idecode_i32c__illegal),
        .idecode__memory_width(            decexecrfw_idecode_i32c__memory_width),
        .idecode__memory_read_unsigned(            decexecrfw_idecode_i32c__memory_read_unsigned),
        .idecode__requires_machine_mode(            decexecrfw_idecode_i32c__requires_machine_mode),
        .idecode__subop(            decexecrfw_idecode_i32c__subop),
        .idecode__op(            decexecrfw_idecode_i32c__op),
        .idecode__immediate_valid(            decexecrfw_idecode_i32c__immediate_valid),
        .idecode__immediate_shift(            decexecrfw_idecode_i32c__immediate_shift),
        .idecode__immediate(            decexecrfw_idecode_i32c__immediate),
        .idecode__csr_access__address(            decexecrfw_idecode_i32c__csr_access__address),
        .idecode__csr_access__access(            decexecrfw_idecode_i32c__csr_access__access),
        .idecode__rd_written(            decexecrfw_idecode_i32c__rd_written),
        .idecode__rd(            decexecrfw_idecode_i32c__rd),
        .idecode__rs2_valid(            decexecrfw_idecode_i32c__rs2_valid),
        .idecode__rs2(            decexecrfw_idecode_i32c__rs2),
        .idecode__rs1_valid(            decexecrfw_idecode_i32c__rs1_valid),
        .idecode__rs1(            decexecrfw_idecode_i32c__rs1)         );
    riscv_i32_alu alu(
        .rs2(decexecrfw_combs__rs2),
        .rs1(decexecrfw_combs__rs1),
        .pc(decexecrfw_state__pc),
        .idecode__ext__dummy(decexecrfw_combs__idecode__ext__dummy),
        .idecode__is_compressed(decexecrfw_combs__idecode__is_compressed),
        .idecode__illegal(decexecrfw_combs__idecode__illegal),
        .idecode__memory_width(decexecrfw_combs__idecode__memory_width),
        .idecode__memory_read_unsigned(decexecrfw_combs__idecode__memory_read_unsigned),
        .idecode__requires_machine_mode(decexecrfw_combs__idecode__requires_machine_mode),
        .idecode__subop(decexecrfw_combs__idecode__subop),
        .idecode__op(decexecrfw_combs__idecode__op),
        .idecode__immediate_valid(decexecrfw_combs__idecode__immediate_valid),
        .idecode__immediate_shift(decexecrfw_combs__idecode__immediate_shift),
        .idecode__immediate(decexecrfw_combs__idecode__immediate),
        .idecode__csr_access__address(decexecrfw_combs__idecode__csr_access__address),
        .idecode__csr_access__access(decexecrfw_combs__idecode__csr_access__access),
        .idecode__rd_written(decexecrfw_combs__idecode__rd_written),
        .idecode__rd(decexecrfw_combs__idecode__rd),
        .idecode__rs2_valid(decexecrfw_combs__idecode__rs2_valid),
        .idecode__rs2(decexecrfw_combs__idecode__rs2),
        .idecode__rs1_valid(decexecrfw_combs__idecode__rs1_valid),
        .idecode__rs1(decexecrfw_combs__idecode__rs1),
        .alu_result__csr_access__address(            decexecrfw_alu_result__csr_access__address),
        .alu_result__csr_access__access(            decexecrfw_alu_result__csr_access__access),
        .alu_result__branch_target(            decexecrfw_alu_result__branch_target),
        .alu_result__branch_condition_met(            decexecrfw_alu_result__branch_condition_met),
        .alu_result__arith_result(            decexecrfw_alu_result__arith_result),
        .alu_result__result(            decexecrfw_alu_result__result)         );
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
        .csr_write_data(((decexecrfw_combs__idecode__illegal!=1'h0)?{27'h0,decexecrfw_combs__idecode__rs1}:decexecrfw_combs__rs1)),
        .csr_access__address(decexecrfw_combs__csr_access__address),
        .csr_access__access(decexecrfw_combs__csr_access__access),
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
    always @ ( * )//instruction_fetch_request
    begin: instruction_fetch_request__comb_code
    reg [31:0]ifetch_combs__address__var;
    reg ifetch_req__valid__var;
    reg [31:0]ifetch_req__address__var;
    reg ifetch_req__sequential__var;
        ifetch_combs__address__var = decexecrfw_combs__next_pc;
        if ((!(decexecrfw_state__valid!=1'h0)&&(decexecrfw_state__enable!=1'h0)))
        begin
            ifetch_combs__address__var = decexecrfw_state__pc;
        end //if
        ifetch_combs__request = decexecrfw_state__enable;
        ifetch_req__valid__var = 1'h0;
        ifetch_req__address__var = 32'h0;
        ifetch_req__sequential__var = 1'h0;
        ifetch_req__mode = 3'h0;
        ifetch_req__flush = 1'h0;
        ifetch_req__valid__var = ifetch_combs__request;
        ifetch_req__sequential__var = decexecrfw_combs__fetch_sequential;
        ifetch_req__address__var = ifetch_combs__address__var;
        ifetch_combs__address = ifetch_combs__address__var;
        ifetch_req__valid = ifetch_req__valid__var;
        ifetch_req__address = ifetch_req__address__var;
        ifetch_req__sequential = ifetch_req__sequential__var;
    end //always

    //b decode_rfr_execute_stage__comb combinatorial process
        //   
        //       The decode/RFR/execute stage performs all of the hard workin the
        //       implementation.
        //   
        //       It first incorporates a program counter (PC) and an instruction
        //       register (IR). The instruction in the IR corresponds to that
        //       PC. Initially (at reset) the IR will not be valid, as an
        //       instruction must first be fetched, so there is a corresponding
        //       valid bit too.
        //   
        //       The IR is decoded as both a RV32C (16-bit) and RV32 (32-bit) in
        //       parallel; the bottom two bits of the instruction register indicate
        //       which is valid for the IR.
        //   
        //       
    always @ ( * )//decode_rfr_execute_stage__comb
    begin: decode_rfr_execute_stage__comb_code
    reg [4:0]decexecrfw_combs__idecode__rs1__var;
    reg decexecrfw_combs__idecode__rs1_valid__var;
    reg [4:0]decexecrfw_combs__idecode__rs2__var;
    reg decexecrfw_combs__idecode__rs2_valid__var;
    reg [4:0]decexecrfw_combs__idecode__rd__var;
    reg decexecrfw_combs__idecode__rd_written__var;
    reg [2:0]decexecrfw_combs__idecode__csr_access__access__var;
    reg [11:0]decexecrfw_combs__idecode__csr_access__address__var;
    reg [31:0]decexecrfw_combs__idecode__immediate__var;
    reg [4:0]decexecrfw_combs__idecode__immediate_shift__var;
    reg decexecrfw_combs__idecode__immediate_valid__var;
    reg [3:0]decexecrfw_combs__idecode__op__var;
    reg [3:0]decexecrfw_combs__idecode__subop__var;
    reg decexecrfw_combs__idecode__requires_machine_mode__var;
    reg decexecrfw_combs__idecode__memory_read_unsigned__var;
    reg [1:0]decexecrfw_combs__idecode__memory_width__var;
    reg decexecrfw_combs__idecode__illegal__var;
    reg decexecrfw_combs__idecode__is_compressed__var;
    reg decexecrfw_combs__idecode__ext__dummy__var;
    reg csr_controls__retire__var;
    reg csr_controls__timer_inc__var;
    reg csr_controls__trap__var;
    reg [3:0]csr_controls__trap_cause__var;
    reg [31:0]csr_controls__trap_pc__var;
    reg [31:0]csr_controls__trap_value__var;
    reg [2:0]decexecrfw_combs__csr_access__access__var;
    reg dmem_access_req__read_enable__var;
    reg dmem_access_req__write_enable__var;
    reg decexecrfw_combs__dmem_misaligned__var;
    reg [3:0]dmem_access_req__byte_enable__var;
    reg decexecrfw_combs__load_address_misaligned__var;
    reg decexecrfw_combs__store_address_misaligned__var;
    reg decexecrfw_combs__trap__var;
    reg [3:0]decexecrfw_combs__trap_cause__var;
    reg [31:0]decexecrfw_combs__trap_value__var;
    reg decexecrfw_combs__branch_taken__var;
    reg [31:0]decexecrfw_combs__branch_target__var;
    reg [31:0]decexecrfw_combs__next_pc__var;
    reg decexecrfw_combs__fetch_sequential__var;
    reg [31:0]decexecrfw_combs__memory_data__var;
    reg [31:0]decexecrfw_combs__rfw_write_data__var;
        decexecrfw_combs__idecode__rs1__var = decexecrfw_idecode_i32__rs1;
        decexecrfw_combs__idecode__rs1_valid__var = decexecrfw_idecode_i32__rs1_valid;
        decexecrfw_combs__idecode__rs2__var = decexecrfw_idecode_i32__rs2;
        decexecrfw_combs__idecode__rs2_valid__var = decexecrfw_idecode_i32__rs2_valid;
        decexecrfw_combs__idecode__rd__var = decexecrfw_idecode_i32__rd;
        decexecrfw_combs__idecode__rd_written__var = decexecrfw_idecode_i32__rd_written;
        decexecrfw_combs__idecode__csr_access__access__var = decexecrfw_idecode_i32__csr_access__access;
        decexecrfw_combs__idecode__csr_access__address__var = decexecrfw_idecode_i32__csr_access__address;
        decexecrfw_combs__idecode__immediate__var = decexecrfw_idecode_i32__immediate;
        decexecrfw_combs__idecode__immediate_shift__var = decexecrfw_idecode_i32__immediate_shift;
        decexecrfw_combs__idecode__immediate_valid__var = decexecrfw_idecode_i32__immediate_valid;
        decexecrfw_combs__idecode__op__var = decexecrfw_idecode_i32__op;
        decexecrfw_combs__idecode__subop__var = decexecrfw_idecode_i32__subop;
        decexecrfw_combs__idecode__requires_machine_mode__var = decexecrfw_idecode_i32__requires_machine_mode;
        decexecrfw_combs__idecode__memory_read_unsigned__var = decexecrfw_idecode_i32__memory_read_unsigned;
        decexecrfw_combs__idecode__memory_width__var = decexecrfw_idecode_i32__memory_width;
        decexecrfw_combs__idecode__illegal__var = decexecrfw_idecode_i32__illegal;
        decexecrfw_combs__idecode__is_compressed__var = decexecrfw_idecode_i32__is_compressed;
        decexecrfw_combs__idecode__ext__dummy__var = decexecrfw_idecode_i32__ext__dummy;
        if ((1'h1&&(riscv_config__i32c!=1'h0)))
        begin
            if ((decexecrfw_state__instruction__data[1:0]!=2'h3))
            begin
                decexecrfw_combs__idecode__rs1__var = decexecrfw_idecode_i32c__rs1;
                decexecrfw_combs__idecode__rs1_valid__var = decexecrfw_idecode_i32c__rs1_valid;
                decexecrfw_combs__idecode__rs2__var = decexecrfw_idecode_i32c__rs2;
                decexecrfw_combs__idecode__rs2_valid__var = decexecrfw_idecode_i32c__rs2_valid;
                decexecrfw_combs__idecode__rd__var = decexecrfw_idecode_i32c__rd;
                decexecrfw_combs__idecode__rd_written__var = decexecrfw_idecode_i32c__rd_written;
                decexecrfw_combs__idecode__csr_access__access__var = decexecrfw_idecode_i32c__csr_access__access;
                decexecrfw_combs__idecode__csr_access__address__var = decexecrfw_idecode_i32c__csr_access__address;
                decexecrfw_combs__idecode__immediate__var = decexecrfw_idecode_i32c__immediate;
                decexecrfw_combs__idecode__immediate_shift__var = decexecrfw_idecode_i32c__immediate_shift;
                decexecrfw_combs__idecode__immediate_valid__var = decexecrfw_idecode_i32c__immediate_valid;
                decexecrfw_combs__idecode__op__var = decexecrfw_idecode_i32c__op;
                decexecrfw_combs__idecode__subop__var = decexecrfw_idecode_i32c__subop;
                decexecrfw_combs__idecode__requires_machine_mode__var = decexecrfw_idecode_i32c__requires_machine_mode;
                decexecrfw_combs__idecode__memory_read_unsigned__var = decexecrfw_idecode_i32c__memory_read_unsigned;
                decexecrfw_combs__idecode__memory_width__var = decexecrfw_idecode_i32c__memory_width;
                decexecrfw_combs__idecode__illegal__var = decexecrfw_idecode_i32c__illegal;
                decexecrfw_combs__idecode__is_compressed__var = decexecrfw_idecode_i32c__is_compressed;
                decexecrfw_combs__idecode__ext__dummy__var = decexecrfw_idecode_i32c__ext__dummy;
            end //if
        end //if
        decexecrfw_combs__rs1 = registers[decexecrfw_combs__idecode__rs1__var];
        decexecrfw_combs__rs2 = registers[decexecrfw_combs__idecode__rs2__var];
        csr_controls__retire__var = 1'h0;
        csr_controls__timer_inc__var = 1'h0;
        csr_controls__timer_clear = 1'h0;
        csr_controls__timer_load = 1'h0;
        csr_controls__timer_value = 64'h0;
        csr_controls__trap__var = 1'h0;
        csr_controls__trap_cause__var = 4'h0;
        csr_controls__trap_pc__var = 32'h0;
        csr_controls__trap_value__var = 32'h0;
        csr_controls__retire__var = decexecrfw_state__valid_legal;
        csr_controls__timer_inc__var = 1'h1;
        decexecrfw_combs__csr_access__access__var = decexecrfw_combs__idecode__csr_access__access__var;
        decexecrfw_combs__csr_access__address = decexecrfw_combs__idecode__csr_access__address__var;
        if ((!(decexecrfw_state__valid_legal!=1'h0)||(decexecrfw_combs__idecode__illegal__var!=1'h0)))
        begin
            decexecrfw_combs__csr_access__access__var = 3'h0;
        end //if
        dmem_access_req__read_enable__var = (decexecrfw_combs__idecode__op__var==4'h6);
        dmem_access_req__write_enable__var = (decexecrfw_combs__idecode__op__var==4'h7);
        if (!(decexecrfw_state__valid_legal!=1'h0))
        begin
            dmem_access_req__read_enable__var = 1'h0;
            dmem_access_req__write_enable__var = 1'h0;
        end //if
        dmem_access_req__address = decexecrfw_alu_result__arith_result;
        decexecrfw_combs__word_offset = decexecrfw_alu_result__arith_result[1:0];
        decexecrfw_combs__dmem_misaligned__var = (decexecrfw_combs__word_offset!=2'h0);
        dmem_access_req__byte_enable__var = (4'hf<<decexecrfw_combs__word_offset);
        case (decexecrfw_combs__idecode__memory_width__var) //synopsys parallel_case
        2'h0: // req 1
            begin
            dmem_access_req__byte_enable__var = (4'h1<<decexecrfw_combs__word_offset);
            decexecrfw_combs__dmem_misaligned__var = 1'h0;
            end
        2'h1: // req 1
            begin
            dmem_access_req__byte_enable__var = (4'h3<<decexecrfw_combs__word_offset);
            decexecrfw_combs__dmem_misaligned__var = decexecrfw_combs__word_offset[0];
            end
        default: // req 1
            begin
            decexecrfw_combs__dmem_misaligned__var = (decexecrfw_combs__word_offset!=2'h0);
            end
        endcase
        decexecrfw_combs__load_address_misaligned__var = 1'h1;
        decexecrfw_combs__store_address_misaligned__var = 1'h1;
        if (((dmem_access_req__read_enable__var!=1'h0)&&(decexecrfw_combs__dmem_misaligned__var!=1'h0)))
        begin
            decexecrfw_combs__load_address_misaligned__var = 1'h1;
        end //if
        if (((dmem_access_req__write_enable__var!=1'h0)&&(decexecrfw_combs__dmem_misaligned__var!=1'h0)))
        begin
            decexecrfw_combs__store_address_misaligned__var = 1'h1;
        end //if
        dmem_access_req__write_data = (decexecrfw_combs__rs2<<{decexecrfw_combs__word_offset,3'h0});
        decexecrfw_combs__trap__var = 1'h0;
        decexecrfw_combs__trap_cause__var = 4'h0;
        decexecrfw_combs__trap_value__var = 32'h0;
        decexecrfw_combs__branch_taken__var = 1'h0;
        decexecrfw_combs__branch_target__var = decexecrfw_alu_result__branch_target;
        case (decexecrfw_combs__idecode__op__var) //synopsys parallel_case
        4'h0: // req 1
            begin
            decexecrfw_combs__branch_taken__var = decexecrfw_alu_result__branch_condition_met;
            end
        4'h1: // req 1
            begin
            decexecrfw_combs__branch_taken__var = 1'h1;
            end
        4'h2: // req 1
            begin
            decexecrfw_combs__branch_taken__var = 1'h1;
            end
        4'h3: // req 1
            begin
            if ((decexecrfw_combs__idecode__subop__var==4'h2))
            begin
                decexecrfw_combs__branch_taken__var = 1'h1;
                decexecrfw_combs__branch_target__var = csrs__mepc;
            end //if
            if ((decexecrfw_combs__idecode__subop__var==4'h0))
            begin
                decexecrfw_combs__trap__var = 1'h1;
                decexecrfw_combs__trap_cause__var = 4'hb;
            end //if
            if ((decexecrfw_combs__idecode__subop__var==4'h1))
            begin
                decexecrfw_combs__trap__var = 1'h1;
                decexecrfw_combs__trap_cause__var = 4'h3;
                decexecrfw_combs__trap_value__var = decexecrfw_state__pc;
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
        if ((decexecrfw_combs__idecode__illegal__var!=1'h0))
        begin
            decexecrfw_combs__trap__var = 1'h1;
            decexecrfw_combs__trap_cause__var = 4'h2;
            decexecrfw_combs__trap_value__var = decexecrfw_state__instruction__data;
        end //if
        decexecrfw_combs__pc_plus_4 = (decexecrfw_state__pc+32'h4);
        decexecrfw_combs__pc_plus_2 = (decexecrfw_state__pc+32'h2);
        decexecrfw_combs__pc_plus_inst = ((decexecrfw_combs__idecode__is_compressed__var!=1'h0)?decexecrfw_combs__pc_plus_2:decexecrfw_combs__pc_plus_4);
        decexecrfw_combs__next_pc__var = decexecrfw_combs__pc_plus_inst;
        decexecrfw_combs__fetch_sequential__var = 1'h1;
        if ((decexecrfw_combs__branch_taken__var!=1'h0))
        begin
            decexecrfw_combs__next_pc__var = decexecrfw_combs__branch_target__var;
            decexecrfw_combs__fetch_sequential__var = 1'h0;
        end //if
        if ((decexecrfw_combs__trap__var!=1'h0))
        begin
            decexecrfw_combs__next_pc__var = csrs__mtvec;
            decexecrfw_combs__fetch_sequential__var = 1'h0;
        end //if
        csr_controls__trap_cause__var = decexecrfw_combs__trap_cause__var;
        csr_controls__trap__var = 1'h0;
        csr_controls__trap_pc__var = decexecrfw_state__pc;
        csr_controls__trap_value__var = decexecrfw_combs__trap_value__var;
        if ((decexecrfw_combs__trap__var!=1'h0))
        begin
            csr_controls__trap__var = decexecrfw_state__valid_legal;
        end //if
        if ((decexecrfw_state__illegal_pc!=1'h0))
        begin
            csr_controls__trap_cause__var = 4'h0;
            csr_controls__trap__var = 1'h1;
            csr_controls__trap_value__var = decexecrfw_state__pc;
        end //if
        decexecrfw_combs__memory_data__var = dmem_access_resp__read_data;
        case (decexecrfw_combs__idecode__memory_width__var) //synopsys parallel_case
        2'h0: // req 1
            begin
            decexecrfw_combs__memory_data__var = ((dmem_access_resp__read_data>>{decexecrfw_combs__word_offset,3'h0}) & 32'hff);
            if ((!(decexecrfw_combs__idecode__memory_read_unsigned__var!=1'h0)&&(decexecrfw_combs__memory_data__var[7]!=1'h0)))
            begin
                decexecrfw_combs__memory_data__var[31:8] = 24'hffffff;
            end //if
            end
        2'h1: // req 1
            begin
            decexecrfw_combs__memory_data__var = ((dmem_access_resp__read_data>>{decexecrfw_combs__word_offset,3'h0}) & 32'hffff);
            if ((!(decexecrfw_combs__idecode__memory_read_unsigned__var!=1'h0)&&(decexecrfw_combs__memory_data__var[15]!=1'h0)))
            begin
                decexecrfw_combs__memory_data__var[31:16] = 16'hffff;
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
        decexecrfw_combs__rfw_write_data__var = (decexecrfw_alu_result__result | coproc_response__result);
        if (((1'h0!=64'h0)||(riscv_config__coproc_disable!=1'h0)))
        begin
            decexecrfw_combs__rfw_write_data__var = decexecrfw_alu_result__result;
        end //if
        if ((dmem_access_req__read_enable__var!=1'h0))
        begin
            decexecrfw_combs__rfw_write_data__var = decexecrfw_combs__memory_data__var;
        end //if
        if ((decexecrfw_combs__idecode__csr_access__access__var!=3'h0))
        begin
            decexecrfw_combs__rfw_write_data__var = csr_data__read_data;
        end //if
        decexecrfw_combs__idecode__rs1 = decexecrfw_combs__idecode__rs1__var;
        decexecrfw_combs__idecode__rs1_valid = decexecrfw_combs__idecode__rs1_valid__var;
        decexecrfw_combs__idecode__rs2 = decexecrfw_combs__idecode__rs2__var;
        decexecrfw_combs__idecode__rs2_valid = decexecrfw_combs__idecode__rs2_valid__var;
        decexecrfw_combs__idecode__rd = decexecrfw_combs__idecode__rd__var;
        decexecrfw_combs__idecode__rd_written = decexecrfw_combs__idecode__rd_written__var;
        decexecrfw_combs__idecode__csr_access__access = decexecrfw_combs__idecode__csr_access__access__var;
        decexecrfw_combs__idecode__csr_access__address = decexecrfw_combs__idecode__csr_access__address__var;
        decexecrfw_combs__idecode__immediate = decexecrfw_combs__idecode__immediate__var;
        decexecrfw_combs__idecode__immediate_shift = decexecrfw_combs__idecode__immediate_shift__var;
        decexecrfw_combs__idecode__immediate_valid = decexecrfw_combs__idecode__immediate_valid__var;
        decexecrfw_combs__idecode__op = decexecrfw_combs__idecode__op__var;
        decexecrfw_combs__idecode__subop = decexecrfw_combs__idecode__subop__var;
        decexecrfw_combs__idecode__requires_machine_mode = decexecrfw_combs__idecode__requires_machine_mode__var;
        decexecrfw_combs__idecode__memory_read_unsigned = decexecrfw_combs__idecode__memory_read_unsigned__var;
        decexecrfw_combs__idecode__memory_width = decexecrfw_combs__idecode__memory_width__var;
        decexecrfw_combs__idecode__illegal = decexecrfw_combs__idecode__illegal__var;
        decexecrfw_combs__idecode__is_compressed = decexecrfw_combs__idecode__is_compressed__var;
        decexecrfw_combs__idecode__ext__dummy = decexecrfw_combs__idecode__ext__dummy__var;
        csr_controls__retire = csr_controls__retire__var;
        csr_controls__timer_inc = csr_controls__timer_inc__var;
        csr_controls__trap = csr_controls__trap__var;
        csr_controls__trap_cause = csr_controls__trap_cause__var;
        csr_controls__trap_pc = csr_controls__trap_pc__var;
        csr_controls__trap_value = csr_controls__trap_value__var;
        decexecrfw_combs__csr_access__access = decexecrfw_combs__csr_access__access__var;
        dmem_access_req__read_enable = dmem_access_req__read_enable__var;
        dmem_access_req__write_enable = dmem_access_req__write_enable__var;
        decexecrfw_combs__dmem_misaligned = decexecrfw_combs__dmem_misaligned__var;
        dmem_access_req__byte_enable = dmem_access_req__byte_enable__var;
        decexecrfw_combs__load_address_misaligned = decexecrfw_combs__load_address_misaligned__var;
        decexecrfw_combs__store_address_misaligned = decexecrfw_combs__store_address_misaligned__var;
        decexecrfw_combs__trap = decexecrfw_combs__trap__var;
        decexecrfw_combs__trap_cause = decexecrfw_combs__trap_cause__var;
        decexecrfw_combs__trap_value = decexecrfw_combs__trap_value__var;
        decexecrfw_combs__branch_taken = decexecrfw_combs__branch_taken__var;
        decexecrfw_combs__branch_target = decexecrfw_combs__branch_target__var;
        decexecrfw_combs__next_pc = decexecrfw_combs__next_pc__var;
        decexecrfw_combs__fetch_sequential = decexecrfw_combs__fetch_sequential__var;
        decexecrfw_combs__memory_data = decexecrfw_combs__memory_data__var;
        decexecrfw_combs__rfw_write_data = decexecrfw_combs__rfw_write_data__var;
    end //always

    //b decode_rfr_execute_stage__posedge_clk_active_low_reset_n clock process
        //   
        //       The decode/RFR/execute stage performs all of the hard workin the
        //       implementation.
        //   
        //       It first incorporates a program counter (PC) and an instruction
        //       register (IR). The instruction in the IR corresponds to that
        //       PC. Initially (at reset) the IR will not be valid, as an
        //       instruction must first be fetched, so there is a corresponding
        //       valid bit too.
        //   
        //       The IR is decoded as both a RV32C (16-bit) and RV32 (32-bit) in
        //       parallel; the bottom two bits of the instruction register indicate
        //       which is valid for the IR.
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : decode_rfr_execute_stage__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            decexecrfw_state__enable <= 1'h0;
            decexecrfw_state__valid <= 1'h0;
            decexecrfw_state__instruction__data <= 32'h0;
            decexecrfw_state__instruction__mode <= 3'h0;
            decexecrfw_state__illegal_pc <= 1'h0;
            decexecrfw_state__valid_legal <= 1'h0;
            decexecrfw_state__pc <= 32'h0;
            decexecrfw_state__pc <= 32'h80000000;
            registers[0] <= 32'h0;
            registers[1] <= 32'h0;
            registers[2] <= 32'h0;
            registers[3] <= 32'h0;
            registers[4] <= 32'h0;
            registers[5] <= 32'h0;
            registers[6] <= 32'h0;
            registers[7] <= 32'h0;
            registers[8] <= 32'h0;
            registers[9] <= 32'h0;
            registers[10] <= 32'h0;
            registers[11] <= 32'h0;
            registers[12] <= 32'h0;
            registers[13] <= 32'h0;
            registers[14] <= 32'h0;
            registers[15] <= 32'h0;
            registers[16] <= 32'h0;
            registers[17] <= 32'h0;
            registers[18] <= 32'h0;
            registers[19] <= 32'h0;
            registers[20] <= 32'h0;
            registers[21] <= 32'h0;
            registers[22] <= 32'h0;
            registers[23] <= 32'h0;
            registers[24] <= 32'h0;
            registers[25] <= 32'h0;
            registers[26] <= 32'h0;
            registers[27] <= 32'h0;
            registers[28] <= 32'h0;
            registers[29] <= 32'h0;
            registers[30] <= 32'h0;
            registers[31] <= 32'h0;
        end
        else if (clk__enable)
        begin
            decexecrfw_state__enable <= 1'h1;
            decexecrfw_state__valid <= 1'h0;
            if (((ifetch_req__valid!=1'h0)&&(ifetch_resp__valid!=1'h0)))
            begin
                decexecrfw_state__instruction__data <= ifetch_resp__data;
                decexecrfw_state__instruction__mode <= 3'h3;
                decexecrfw_state__illegal_pc <= 1'h0;
                decexecrfw_state__valid_legal <= 1'h1;
                decexecrfw_state__valid <= 1'h1;
            end //if
            if ((decexecrfw_state__valid!=1'h0))
            begin
                decexecrfw_state__pc <= decexecrfw_combs__next_pc;
            end //if
            if ((((decexecrfw_state__valid_legal!=1'h0)&&(decexecrfw_combs__idecode__rd_written!=1'h0))&&!(decexecrfw_combs__idecode__illegal!=1'h0)))
            begin
                registers[decexecrfw_combs__idecode__rd] <= decexecrfw_combs__rfw_write_data;
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
    reg coproc_controls__dec_idecode__ext__dummy__var;
    reg coproc_controls__dec_to_alu_blocked__var;
    reg [31:0]coproc_controls__alu_rs1__var;
    reg [31:0]coproc_controls__alu_rs2__var;
    reg coproc_controls__alu_flush_pipeline__var;
    reg coproc_controls__alu_cannot_start__var;
    reg coproc_controls__alu_cannot_complete__var;
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
        coproc_controls__dec_idecode__ext__dummy__var = 1'h0;
        coproc_controls__dec_to_alu_blocked__var = 1'h0;
        coproc_controls__alu_rs1__var = 32'h0;
        coproc_controls__alu_rs2__var = 32'h0;
        coproc_controls__alu_flush_pipeline__var = 1'h0;
        coproc_controls__alu_cannot_start__var = 1'h0;
        coproc_controls__alu_cannot_complete__var = 1'h0;
        coproc_controls__dec_idecode_valid__var = decexecrfw_state__valid;
        coproc_controls__dec_idecode__rs1__var = decexecrfw_combs__idecode__rs1;
        coproc_controls__dec_idecode__rs1_valid__var = decexecrfw_combs__idecode__rs1_valid;
        coproc_controls__dec_idecode__rs2__var = decexecrfw_combs__idecode__rs2;
        coproc_controls__dec_idecode__rs2_valid__var = decexecrfw_combs__idecode__rs2_valid;
        coproc_controls__dec_idecode__rd__var = decexecrfw_combs__idecode__rd;
        coproc_controls__dec_idecode__rd_written__var = decexecrfw_combs__idecode__rd_written;
        coproc_controls__dec_idecode__csr_access__access__var = decexecrfw_combs__idecode__csr_access__access;
        coproc_controls__dec_idecode__csr_access__address__var = decexecrfw_combs__idecode__csr_access__address;
        coproc_controls__dec_idecode__immediate__var = decexecrfw_combs__idecode__immediate;
        coproc_controls__dec_idecode__immediate_shift__var = decexecrfw_combs__idecode__immediate_shift;
        coproc_controls__dec_idecode__immediate_valid__var = decexecrfw_combs__idecode__immediate_valid;
        coproc_controls__dec_idecode__op__var = decexecrfw_combs__idecode__op;
        coproc_controls__dec_idecode__subop__var = decexecrfw_combs__idecode__subop;
        coproc_controls__dec_idecode__requires_machine_mode__var = decexecrfw_combs__idecode__requires_machine_mode;
        coproc_controls__dec_idecode__memory_read_unsigned__var = decexecrfw_combs__idecode__memory_read_unsigned;
        coproc_controls__dec_idecode__memory_width__var = decexecrfw_combs__idecode__memory_width;
        coproc_controls__dec_idecode__illegal__var = decexecrfw_combs__idecode__illegal;
        coproc_controls__dec_idecode__is_compressed__var = decexecrfw_combs__idecode__is_compressed;
        coproc_controls__dec_idecode__ext__dummy__var = decexecrfw_combs__idecode__ext__dummy;
        coproc_controls__dec_to_alu_blocked__var = coproc_response__cannot_complete;
        coproc_controls__alu_rs1__var = decexecrfw_combs__rs1;
        coproc_controls__alu_rs2__var = decexecrfw_combs__rs2;
        coproc_controls__alu_flush_pipeline__var = 1'h0;
        coproc_controls__alu_cannot_start__var = coproc_response__cannot_start;
        coproc_controls__alu_cannot_complete__var = coproc_response__cannot_complete;
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
            coproc_controls__dec_idecode__ext__dummy__var = 1'h0;
            coproc_controls__dec_to_alu_blocked__var = 1'h0;
            coproc_controls__alu_rs1__var = 32'h0;
            coproc_controls__alu_rs2__var = 32'h0;
            coproc_controls__alu_flush_pipeline__var = 1'h0;
            coproc_controls__alu_cannot_start__var = 1'h0;
            coproc_controls__alu_cannot_complete__var = 1'h0;
        end //if
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
        coproc_controls__dec_idecode__ext__dummy = coproc_controls__dec_idecode__ext__dummy__var;
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
    reg [2:0]trace__instruction__mode__var;
    reg [31:0]trace__instruction__data__var;
    reg trace__rfw_retire__var;
    reg trace__rfw_data_valid__var;
    reg [4:0]trace__rfw_rd__var;
    reg [31:0]trace__rfw_data__var;
    reg trace__branch_taken__var;
    reg [31:0]trace__branch_target__var;
    reg trace__trap__var;
        trace__instr_valid__var = 1'h0;
        trace__instr_pc__var = 32'h0;
        trace__instruction__mode__var = 3'h0;
        trace__instruction__data__var = 32'h0;
        trace__rfw_retire__var = 1'h0;
        trace__rfw_data_valid__var = 1'h0;
        trace__rfw_rd__var = 5'h0;
        trace__rfw_data__var = 32'h0;
        trace__branch_taken__var = 1'h0;
        trace__branch_target__var = 32'h0;
        trace__trap__var = 1'h0;
        trace__instr_valid__var = decexecrfw_state__valid;
        trace__instr_pc__var = decexecrfw_state__pc;
        trace__instruction__mode__var = decexecrfw_state__instruction__mode;
        trace__instruction__data__var = decexecrfw_state__instruction__data;
        trace__rfw_retire__var = decexecrfw_state__valid;
        trace__rfw_data_valid__var = (((decexecrfw_state__valid_legal!=1'h0)&&(decexecrfw_combs__idecode__rd_written!=1'h0))&&!(decexecrfw_combs__idecode__illegal!=1'h0));
        trace__rfw_rd__var = decexecrfw_combs__idecode__rd;
        trace__rfw_data__var = decexecrfw_combs__rfw_write_data;
        trace__branch_taken__var = decexecrfw_combs__branch_taken;
        trace__trap__var = decexecrfw_combs__trap;
        trace__branch_target__var = decexecrfw_combs__branch_target;
        trace__instr_valid = trace__instr_valid__var;
        trace__instr_pc = trace__instr_pc__var;
        trace__instruction__mode = trace__instruction__mode__var;
        trace__instruction__data = trace__instruction__data__var;
        trace__rfw_retire = trace__rfw_retire__var;
        trace__rfw_data_valid = trace__rfw_data_valid__var;
        trace__rfw_rd = trace__rfw_rd__var;
        trace__rfw_data = trace__rfw_data__var;
        trace__branch_taken = trace__branch_taken__var;
        trace__branch_target = trace__branch_target__var;
        trace__trap = trace__trap__var;
    end //always

endmodule // riscv_i32c_pipeline
