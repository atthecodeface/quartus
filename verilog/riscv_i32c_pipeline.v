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
    //   A coprocessor can implement, for example, the multiply for i32m (using
    //   riscv_i32_muldiv).  Note that since there is not a separate decode
    //   stage the multiply cannot support fused operations
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
    csr_read_data,
    coproc_response__cannot_start,
    coproc_response__result,
    coproc_response__result_valid,
    coproc_response__cannot_complete,
    pipeline_fetch_data__valid,
    pipeline_fetch_data__pc,
    pipeline_fetch_data__data,
    pipeline_fetch_data__dec_flush_pipeline,
    pipeline_fetch_data__dec_predicted_branch,
    pipeline_fetch_data__dec_pc_if_mispredicted,
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
    dmem_access_resp__wait,
    dmem_access_resp__read_data,
    reset_n,

    csr_access__access_cancelled,
    csr_access__access,
    csr_access__address,
    csr_access__write_data,
    pipeline_response__decode__valid,
    pipeline_response__decode__decode_blocked,
    pipeline_response__decode__branch_target,
    pipeline_response__decode__idecode__rs1,
    pipeline_response__decode__idecode__rs1_valid,
    pipeline_response__decode__idecode__rs2,
    pipeline_response__decode__idecode__rs2_valid,
    pipeline_response__decode__idecode__rd,
    pipeline_response__decode__idecode__rd_written,
    pipeline_response__decode__idecode__csr_access__access_cancelled,
    pipeline_response__decode__idecode__csr_access__access,
    pipeline_response__decode__idecode__csr_access__address,
    pipeline_response__decode__idecode__csr_access__write_data,
    pipeline_response__decode__idecode__immediate,
    pipeline_response__decode__idecode__immediate_shift,
    pipeline_response__decode__idecode__immediate_valid,
    pipeline_response__decode__idecode__op,
    pipeline_response__decode__idecode__subop,
    pipeline_response__decode__idecode__requires_machine_mode,
    pipeline_response__decode__idecode__memory_read_unsigned,
    pipeline_response__decode__idecode__memory_width,
    pipeline_response__decode__idecode__illegal,
    pipeline_response__decode__idecode__illegal_pc,
    pipeline_response__decode__idecode__is_compressed,
    pipeline_response__decode__idecode__ext__dummy,
    pipeline_response__decode__enable_branch_prediction,
    pipeline_response__exec__valid,
    pipeline_response__exec__cannot_start,
    pipeline_response__exec__cannot_complete,
    pipeline_response__exec__interrupt_ack,
    pipeline_response__exec__branch_taken,
    pipeline_response__exec__trap__valid,
    pipeline_response__exec__trap__to_mode,
    pipeline_response__exec__trap__cause,
    pipeline_response__exec__trap__pc,
    pipeline_response__exec__trap__value,
    pipeline_response__exec__trap__mret,
    pipeline_response__exec__trap__vector,
    pipeline_response__exec__is_compressed,
    pipeline_response__exec__instruction__mode,
    pipeline_response__exec__instruction__data,
    pipeline_response__exec__rs1,
    pipeline_response__exec__rs2,
    pipeline_response__exec__pc,
    pipeline_response__exec__predicted_branch,
    pipeline_response__exec__pc_if_mispredicted,
    pipeline_response__rfw__valid,
    pipeline_response__rfw__rd_written,
    pipeline_response__rfw__rd,
    pipeline_response__rfw__data,
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
    input [31:0]csr_read_data;
    input coproc_response__cannot_start;
    input [31:0]coproc_response__result;
    input coproc_response__result_valid;
    input coproc_response__cannot_complete;
    input pipeline_fetch_data__valid;
    input [31:0]pipeline_fetch_data__pc;
    input [31:0]pipeline_fetch_data__data;
    input pipeline_fetch_data__dec_flush_pipeline;
    input pipeline_fetch_data__dec_predicted_branch;
    input [31:0]pipeline_fetch_data__dec_pc_if_mispredicted;
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
    input dmem_access_resp__wait;
    input [31:0]dmem_access_resp__read_data;
    input reset_n;

    //b Outputs
    output csr_access__access_cancelled;
    output [2:0]csr_access__access;
    output [11:0]csr_access__address;
    output [31:0]csr_access__write_data;
    output pipeline_response__decode__valid;
    output pipeline_response__decode__decode_blocked;
    output [31:0]pipeline_response__decode__branch_target;
    output [4:0]pipeline_response__decode__idecode__rs1;
    output pipeline_response__decode__idecode__rs1_valid;
    output [4:0]pipeline_response__decode__idecode__rs2;
    output pipeline_response__decode__idecode__rs2_valid;
    output [4:0]pipeline_response__decode__idecode__rd;
    output pipeline_response__decode__idecode__rd_written;
    output pipeline_response__decode__idecode__csr_access__access_cancelled;
    output [2:0]pipeline_response__decode__idecode__csr_access__access;
    output [11:0]pipeline_response__decode__idecode__csr_access__address;
    output [31:0]pipeline_response__decode__idecode__csr_access__write_data;
    output [31:0]pipeline_response__decode__idecode__immediate;
    output [4:0]pipeline_response__decode__idecode__immediate_shift;
    output pipeline_response__decode__idecode__immediate_valid;
    output [3:0]pipeline_response__decode__idecode__op;
    output [3:0]pipeline_response__decode__idecode__subop;
    output pipeline_response__decode__idecode__requires_machine_mode;
    output pipeline_response__decode__idecode__memory_read_unsigned;
    output [1:0]pipeline_response__decode__idecode__memory_width;
    output pipeline_response__decode__idecode__illegal;
    output pipeline_response__decode__idecode__illegal_pc;
    output pipeline_response__decode__idecode__is_compressed;
    output pipeline_response__decode__idecode__ext__dummy;
    output pipeline_response__decode__enable_branch_prediction;
    output pipeline_response__exec__valid;
    output pipeline_response__exec__cannot_start;
    output pipeline_response__exec__cannot_complete;
    output pipeline_response__exec__interrupt_ack;
    output pipeline_response__exec__branch_taken;
    output pipeline_response__exec__trap__valid;
    output [2:0]pipeline_response__exec__trap__to_mode;
    output [4:0]pipeline_response__exec__trap__cause;
    output [31:0]pipeline_response__exec__trap__pc;
    output [31:0]pipeline_response__exec__trap__value;
    output pipeline_response__exec__trap__mret;
    output pipeline_response__exec__trap__vector;
    output pipeline_response__exec__is_compressed;
    output [2:0]pipeline_response__exec__instruction__mode;
    output [31:0]pipeline_response__exec__instruction__data;
    output [31:0]pipeline_response__exec__rs1;
    output [31:0]pipeline_response__exec__rs2;
    output [31:0]pipeline_response__exec__pc;
    output pipeline_response__exec__predicted_branch;
    output [31:0]pipeline_response__exec__pc_if_mispredicted;
    output pipeline_response__rfw__valid;
    output pipeline_response__rfw__rd_written;
    output [4:0]pipeline_response__rfw__rd;
    output [31:0]pipeline_response__rfw__data;
    output [31:0]dmem_access_req__address;
    output [3:0]dmem_access_req__byte_enable;
    output dmem_access_req__write_enable;
    output dmem_access_req__read_enable;
    output [31:0]dmem_access_req__write_data;

// output components here

    //b Output combinatorials
    reg csr_access__access_cancelled;
    reg [2:0]csr_access__access;
    reg [11:0]csr_access__address;
    reg [31:0]csr_access__write_data;
    reg pipeline_response__decode__valid;
    reg pipeline_response__decode__decode_blocked;
    reg [31:0]pipeline_response__decode__branch_target;
    reg [4:0]pipeline_response__decode__idecode__rs1;
    reg pipeline_response__decode__idecode__rs1_valid;
    reg [4:0]pipeline_response__decode__idecode__rs2;
    reg pipeline_response__decode__idecode__rs2_valid;
    reg [4:0]pipeline_response__decode__idecode__rd;
    reg pipeline_response__decode__idecode__rd_written;
    reg pipeline_response__decode__idecode__csr_access__access_cancelled;
    reg [2:0]pipeline_response__decode__idecode__csr_access__access;
    reg [11:0]pipeline_response__decode__idecode__csr_access__address;
    reg [31:0]pipeline_response__decode__idecode__csr_access__write_data;
    reg [31:0]pipeline_response__decode__idecode__immediate;
    reg [4:0]pipeline_response__decode__idecode__immediate_shift;
    reg pipeline_response__decode__idecode__immediate_valid;
    reg [3:0]pipeline_response__decode__idecode__op;
    reg [3:0]pipeline_response__decode__idecode__subop;
    reg pipeline_response__decode__idecode__requires_machine_mode;
    reg pipeline_response__decode__idecode__memory_read_unsigned;
    reg [1:0]pipeline_response__decode__idecode__memory_width;
    reg pipeline_response__decode__idecode__illegal;
    reg pipeline_response__decode__idecode__illegal_pc;
    reg pipeline_response__decode__idecode__is_compressed;
    reg pipeline_response__decode__idecode__ext__dummy;
    reg pipeline_response__decode__enable_branch_prediction;
    reg pipeline_response__exec__valid;
    reg pipeline_response__exec__cannot_start;
    reg pipeline_response__exec__cannot_complete;
    reg pipeline_response__exec__interrupt_ack;
    reg pipeline_response__exec__branch_taken;
    reg pipeline_response__exec__trap__valid;
    reg [2:0]pipeline_response__exec__trap__to_mode;
    reg [4:0]pipeline_response__exec__trap__cause;
    reg [31:0]pipeline_response__exec__trap__pc;
    reg [31:0]pipeline_response__exec__trap__value;
    reg pipeline_response__exec__trap__mret;
    reg pipeline_response__exec__trap__vector;
    reg pipeline_response__exec__is_compressed;
    reg [2:0]pipeline_response__exec__instruction__mode;
    reg [31:0]pipeline_response__exec__instruction__data;
    reg [31:0]pipeline_response__exec__rs1;
    reg [31:0]pipeline_response__exec__rs2;
    reg [31:0]pipeline_response__exec__pc;
    reg pipeline_response__exec__predicted_branch;
    reg [31:0]pipeline_response__exec__pc_if_mispredicted;
    reg pipeline_response__rfw__valid;
    reg pipeline_response__rfw__rd_written;
    reg [4:0]pipeline_response__rfw__rd;
    reg [31:0]pipeline_response__rfw__data;
    reg [31:0]dmem_access_req__address;
    reg [3:0]dmem_access_req__byte_enable;
    reg dmem_access_req__write_enable;
    reg dmem_access_req__read_enable;
    reg [31:0]dmem_access_req__write_data;

    //b Output nets

    //b Internal and output registers
    reg rfw_state__valid;
    reg rfw_state__rd_written;
    reg [4:0]rfw_state__rd;
    reg [31:0]rfw_state__data;
    reg [2:0]decexecrfw_state__instruction__mode;
    reg [31:0]decexecrfw_state__instruction__data;
    reg decexecrfw_state__valid;
        //   Register 0 is tied to 0 - so it is written on every cycle to zero...
    reg [31:0]registers[31:0];

    //b Internal combinatorials
    reg [4:0]decexecrfw_combs__idecode__rs1;
    reg decexecrfw_combs__idecode__rs1_valid;
    reg [4:0]decexecrfw_combs__idecode__rs2;
    reg decexecrfw_combs__idecode__rs2_valid;
    reg [4:0]decexecrfw_combs__idecode__rd;
    reg decexecrfw_combs__idecode__rd_written;
    reg decexecrfw_combs__idecode__csr_access__access_cancelled;
    reg [2:0]decexecrfw_combs__idecode__csr_access__access;
    reg [11:0]decexecrfw_combs__idecode__csr_access__address;
    reg [31:0]decexecrfw_combs__idecode__csr_access__write_data;
    reg [31:0]decexecrfw_combs__idecode__immediate;
    reg [4:0]decexecrfw_combs__idecode__immediate_shift;
    reg decexecrfw_combs__idecode__immediate_valid;
    reg [3:0]decexecrfw_combs__idecode__op;
    reg [3:0]decexecrfw_combs__idecode__subop;
    reg decexecrfw_combs__idecode__requires_machine_mode;
    reg decexecrfw_combs__idecode__memory_read_unsigned;
    reg [1:0]decexecrfw_combs__idecode__memory_width;
    reg decexecrfw_combs__idecode__illegal;
    reg decexecrfw_combs__idecode__illegal_pc;
    reg decexecrfw_combs__idecode__is_compressed;
    reg decexecrfw_combs__idecode__ext__dummy;
    reg [31:0]decexecrfw_combs__rs1;
    reg [31:0]decexecrfw_combs__rs2;
    reg decexecrfw_combs__exec_committed;
    reg decexecrfw_combs__csr_access__access_cancelled;
    reg [2:0]decexecrfw_combs__csr_access__access;
    reg [11:0]decexecrfw_combs__csr_access__address;
    reg [31:0]decexecrfw_combs__csr_access__write_data;
    reg [31:0]decexecrfw_combs__rfw_write_data;
    reg [4:0]decexecrfw_combs__dmem_exec__idecode__rs1;
    reg decexecrfw_combs__dmem_exec__idecode__rs1_valid;
    reg [4:0]decexecrfw_combs__dmem_exec__idecode__rs2;
    reg decexecrfw_combs__dmem_exec__idecode__rs2_valid;
    reg [4:0]decexecrfw_combs__dmem_exec__idecode__rd;
    reg decexecrfw_combs__dmem_exec__idecode__rd_written;
    reg decexecrfw_combs__dmem_exec__idecode__csr_access__access_cancelled;
    reg [2:0]decexecrfw_combs__dmem_exec__idecode__csr_access__access;
    reg [11:0]decexecrfw_combs__dmem_exec__idecode__csr_access__address;
    reg [31:0]decexecrfw_combs__dmem_exec__idecode__csr_access__write_data;
    reg [31:0]decexecrfw_combs__dmem_exec__idecode__immediate;
    reg [4:0]decexecrfw_combs__dmem_exec__idecode__immediate_shift;
    reg decexecrfw_combs__dmem_exec__idecode__immediate_valid;
    reg [3:0]decexecrfw_combs__dmem_exec__idecode__op;
    reg [3:0]decexecrfw_combs__dmem_exec__idecode__subop;
    reg decexecrfw_combs__dmem_exec__idecode__requires_machine_mode;
    reg decexecrfw_combs__dmem_exec__idecode__memory_read_unsigned;
    reg [1:0]decexecrfw_combs__dmem_exec__idecode__memory_width;
    reg decexecrfw_combs__dmem_exec__idecode__illegal;
    reg decexecrfw_combs__dmem_exec__idecode__illegal_pc;
    reg decexecrfw_combs__dmem_exec__idecode__is_compressed;
    reg decexecrfw_combs__dmem_exec__idecode__ext__dummy;
    reg [31:0]decexecrfw_combs__dmem_exec__arith_result;
    reg [31:0]decexecrfw_combs__dmem_exec__rs2;
    reg decexecrfw_combs__dmem_exec__exec_committed;
    reg decexecrfw_combs__dmem_exec__first_cycle;
    reg decexecrfw_combs__control_data__interrupt_ack;
    reg decexecrfw_combs__control_data__valid;
    reg decexecrfw_combs__control_data__exec_committed;
    reg decexecrfw_combs__control_data__first_cycle;
    reg [4:0]decexecrfw_combs__control_data__idecode__rs1;
    reg decexecrfw_combs__control_data__idecode__rs1_valid;
    reg [4:0]decexecrfw_combs__control_data__idecode__rs2;
    reg decexecrfw_combs__control_data__idecode__rs2_valid;
    reg [4:0]decexecrfw_combs__control_data__idecode__rd;
    reg decexecrfw_combs__control_data__idecode__rd_written;
    reg decexecrfw_combs__control_data__idecode__csr_access__access_cancelled;
    reg [2:0]decexecrfw_combs__control_data__idecode__csr_access__access;
    reg [11:0]decexecrfw_combs__control_data__idecode__csr_access__address;
    reg [31:0]decexecrfw_combs__control_data__idecode__csr_access__write_data;
    reg [31:0]decexecrfw_combs__control_data__idecode__immediate;
    reg [4:0]decexecrfw_combs__control_data__idecode__immediate_shift;
    reg decexecrfw_combs__control_data__idecode__immediate_valid;
    reg [3:0]decexecrfw_combs__control_data__idecode__op;
    reg [3:0]decexecrfw_combs__control_data__idecode__subop;
    reg decexecrfw_combs__control_data__idecode__requires_machine_mode;
    reg decexecrfw_combs__control_data__idecode__memory_read_unsigned;
    reg [1:0]decexecrfw_combs__control_data__idecode__memory_width;
    reg decexecrfw_combs__control_data__idecode__illegal;
    reg decexecrfw_combs__control_data__idecode__illegal_pc;
    reg decexecrfw_combs__control_data__idecode__is_compressed;
    reg decexecrfw_combs__control_data__idecode__ext__dummy;
    reg [31:0]decexecrfw_combs__control_data__pc;
    reg [31:0]decexecrfw_combs__control_data__instruction_data;
    reg [31:0]decexecrfw_combs__control_data__alu_result__result;
    reg [31:0]decexecrfw_combs__control_data__alu_result__arith_result;
    reg decexecrfw_combs__control_data__alu_result__branch_condition_met;
    reg [31:0]decexecrfw_combs__control_data__alu_result__branch_target;
    reg decexecrfw_combs__control_data__alu_result__csr_access__access_cancelled;
    reg [2:0]decexecrfw_combs__control_data__alu_result__csr_access__access;
    reg [11:0]decexecrfw_combs__control_data__alu_result__csr_access__address;
    reg [31:0]decexecrfw_combs__control_data__alu_result__csr_access__write_data;

    //b Internal nets
    wire [31:0]decexecrfw_alu_result__result;
    wire [31:0]decexecrfw_alu_result__arith_result;
    wire decexecrfw_alu_result__branch_condition_met;
    wire [31:0]decexecrfw_alu_result__branch_target;
    wire decexecrfw_alu_result__csr_access__access_cancelled;
    wire [2:0]decexecrfw_alu_result__csr_access__access;
    wire [11:0]decexecrfw_alu_result__csr_access__address;
    wire [31:0]decexecrfw_alu_result__csr_access__write_data;
    wire decexecrfw_control_flow__branch_taken;
    wire decexecrfw_control_flow__jalr;
    wire [31:0]decexecrfw_control_flow__next_pc;
    wire decexecrfw_control_flow__trap__valid;
    wire [2:0]decexecrfw_control_flow__trap__to_mode;
    wire [4:0]decexecrfw_control_flow__trap__cause;
    wire [31:0]decexecrfw_control_flow__trap__pc;
    wire [31:0]decexecrfw_control_flow__trap__value;
    wire decexecrfw_control_flow__trap__mret;
    wire decexecrfw_control_flow__trap__vector;
    wire [31:0]decexecrfw_dmem_read_data;
        //   Data memory request data
    wire [31:0]decexecrfw_dmem_request__access__address;
    wire [3:0]decexecrfw_dmem_request__access__byte_enable;
    wire decexecrfw_dmem_request__access__write_enable;
    wire decexecrfw_dmem_request__access__read_enable;
    wire [31:0]decexecrfw_dmem_request__access__write_data;
    wire decexecrfw_dmem_request__load_address_misaligned;
    wire decexecrfw_dmem_request__store_address_misaligned;
    wire decexecrfw_dmem_request__reading;
    wire [1:0]decexecrfw_dmem_request__read_data_rotation;
    wire [3:0]decexecrfw_dmem_request__read_data_byte_clear;
    wire [3:0]decexecrfw_dmem_request__read_data_byte_enable;
    wire decexecrfw_dmem_request__sign_extend_byte;
    wire decexecrfw_dmem_request__sign_extend_half;
    wire decexecrfw_dmem_request__multicycle;
    wire [4:0]decexecrfw_idecode_i32c__rs1;
    wire decexecrfw_idecode_i32c__rs1_valid;
    wire [4:0]decexecrfw_idecode_i32c__rs2;
    wire decexecrfw_idecode_i32c__rs2_valid;
    wire [4:0]decexecrfw_idecode_i32c__rd;
    wire decexecrfw_idecode_i32c__rd_written;
    wire decexecrfw_idecode_i32c__csr_access__access_cancelled;
    wire [2:0]decexecrfw_idecode_i32c__csr_access__access;
    wire [11:0]decexecrfw_idecode_i32c__csr_access__address;
    wire [31:0]decexecrfw_idecode_i32c__csr_access__write_data;
    wire [31:0]decexecrfw_idecode_i32c__immediate;
    wire [4:0]decexecrfw_idecode_i32c__immediate_shift;
    wire decexecrfw_idecode_i32c__immediate_valid;
    wire [3:0]decexecrfw_idecode_i32c__op;
    wire [3:0]decexecrfw_idecode_i32c__subop;
    wire decexecrfw_idecode_i32c__requires_machine_mode;
    wire decexecrfw_idecode_i32c__memory_read_unsigned;
    wire [1:0]decexecrfw_idecode_i32c__memory_width;
    wire decexecrfw_idecode_i32c__illegal;
    wire decexecrfw_idecode_i32c__illegal_pc;
    wire decexecrfw_idecode_i32c__is_compressed;
    wire decexecrfw_idecode_i32c__ext__dummy;
    wire [4:0]decexecrfw_idecode_i32__rs1;
    wire decexecrfw_idecode_i32__rs1_valid;
    wire [4:0]decexecrfw_idecode_i32__rs2;
    wire decexecrfw_idecode_i32__rs2_valid;
    wire [4:0]decexecrfw_idecode_i32__rd;
    wire decexecrfw_idecode_i32__rd_written;
    wire decexecrfw_idecode_i32__csr_access__access_cancelled;
    wire [2:0]decexecrfw_idecode_i32__csr_access__access;
    wire [11:0]decexecrfw_idecode_i32__csr_access__address;
    wire [31:0]decexecrfw_idecode_i32__csr_access__write_data;
    wire [31:0]decexecrfw_idecode_i32__immediate;
    wire [4:0]decexecrfw_idecode_i32__immediate_shift;
    wire decexecrfw_idecode_i32__immediate_valid;
    wire [3:0]decexecrfw_idecode_i32__op;
    wire [3:0]decexecrfw_idecode_i32__subop;
    wire decexecrfw_idecode_i32__requires_machine_mode;
    wire decexecrfw_idecode_i32__memory_read_unsigned;
    wire [1:0]decexecrfw_idecode_i32__memory_width;
    wire decexecrfw_idecode_i32__illegal;
    wire decexecrfw_idecode_i32__illegal_pc;
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
        .idecode__illegal_pc(            decexecrfw_idecode_i32__illegal_pc),
        .idecode__illegal(            decexecrfw_idecode_i32__illegal),
        .idecode__memory_width(            decexecrfw_idecode_i32__memory_width),
        .idecode__memory_read_unsigned(            decexecrfw_idecode_i32__memory_read_unsigned),
        .idecode__requires_machine_mode(            decexecrfw_idecode_i32__requires_machine_mode),
        .idecode__subop(            decexecrfw_idecode_i32__subop),
        .idecode__op(            decexecrfw_idecode_i32__op),
        .idecode__immediate_valid(            decexecrfw_idecode_i32__immediate_valid),
        .idecode__immediate_shift(            decexecrfw_idecode_i32__immediate_shift),
        .idecode__immediate(            decexecrfw_idecode_i32__immediate),
        .idecode__csr_access__write_data(            decexecrfw_idecode_i32__csr_access__write_data),
        .idecode__csr_access__address(            decexecrfw_idecode_i32__csr_access__address),
        .idecode__csr_access__access(            decexecrfw_idecode_i32__csr_access__access),
        .idecode__csr_access__access_cancelled(            decexecrfw_idecode_i32__csr_access__access_cancelled),
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
        .idecode__illegal_pc(            decexecrfw_idecode_i32c__illegal_pc),
        .idecode__illegal(            decexecrfw_idecode_i32c__illegal),
        .idecode__memory_width(            decexecrfw_idecode_i32c__memory_width),
        .idecode__memory_read_unsigned(            decexecrfw_idecode_i32c__memory_read_unsigned),
        .idecode__requires_machine_mode(            decexecrfw_idecode_i32c__requires_machine_mode),
        .idecode__subop(            decexecrfw_idecode_i32c__subop),
        .idecode__op(            decexecrfw_idecode_i32c__op),
        .idecode__immediate_valid(            decexecrfw_idecode_i32c__immediate_valid),
        .idecode__immediate_shift(            decexecrfw_idecode_i32c__immediate_shift),
        .idecode__immediate(            decexecrfw_idecode_i32c__immediate),
        .idecode__csr_access__write_data(            decexecrfw_idecode_i32c__csr_access__write_data),
        .idecode__csr_access__address(            decexecrfw_idecode_i32c__csr_access__address),
        .idecode__csr_access__access(            decexecrfw_idecode_i32c__csr_access__access),
        .idecode__csr_access__access_cancelled(            decexecrfw_idecode_i32c__csr_access__access_cancelled),
        .idecode__rd_written(            decexecrfw_idecode_i32c__rd_written),
        .idecode__rd(            decexecrfw_idecode_i32c__rd),
        .idecode__rs2_valid(            decexecrfw_idecode_i32c__rs2_valid),
        .idecode__rs2(            decexecrfw_idecode_i32c__rs2),
        .idecode__rs1_valid(            decexecrfw_idecode_i32c__rs1_valid),
        .idecode__rs1(            decexecrfw_idecode_i32c__rs1)         );
    riscv_i32_alu alu(
        .rs2(decexecrfw_combs__rs2),
        .rs1(decexecrfw_combs__rs1),
        .pc(pipeline_control__decode_pc),
        .idecode__ext__dummy(decexecrfw_combs__idecode__ext__dummy),
        .idecode__is_compressed(decexecrfw_combs__idecode__is_compressed),
        .idecode__illegal_pc(decexecrfw_combs__idecode__illegal_pc),
        .idecode__illegal(decexecrfw_combs__idecode__illegal),
        .idecode__memory_width(decexecrfw_combs__idecode__memory_width),
        .idecode__memory_read_unsigned(decexecrfw_combs__idecode__memory_read_unsigned),
        .idecode__requires_machine_mode(decexecrfw_combs__idecode__requires_machine_mode),
        .idecode__subop(decexecrfw_combs__idecode__subop),
        .idecode__op(decexecrfw_combs__idecode__op),
        .idecode__immediate_valid(decexecrfw_combs__idecode__immediate_valid),
        .idecode__immediate_shift(decexecrfw_combs__idecode__immediate_shift),
        .idecode__immediate(decexecrfw_combs__idecode__immediate),
        .idecode__csr_access__write_data(decexecrfw_combs__idecode__csr_access__write_data),
        .idecode__csr_access__address(decexecrfw_combs__idecode__csr_access__address),
        .idecode__csr_access__access(decexecrfw_combs__idecode__csr_access__access),
        .idecode__csr_access__access_cancelled(decexecrfw_combs__idecode__csr_access__access_cancelled),
        .idecode__rd_written(decexecrfw_combs__idecode__rd_written),
        .idecode__rd(decexecrfw_combs__idecode__rd),
        .idecode__rs2_valid(decexecrfw_combs__idecode__rs2_valid),
        .idecode__rs2(decexecrfw_combs__idecode__rs2),
        .idecode__rs1_valid(decexecrfw_combs__idecode__rs1_valid),
        .idecode__rs1(decexecrfw_combs__idecode__rs1),
        .alu_result__csr_access__write_data(            decexecrfw_alu_result__csr_access__write_data),
        .alu_result__csr_access__address(            decexecrfw_alu_result__csr_access__address),
        .alu_result__csr_access__access(            decexecrfw_alu_result__csr_access__access),
        .alu_result__csr_access__access_cancelled(            decexecrfw_alu_result__csr_access__access_cancelled),
        .alu_result__branch_target(            decexecrfw_alu_result__branch_target),
        .alu_result__branch_condition_met(            decexecrfw_alu_result__branch_condition_met),
        .alu_result__arith_result(            decexecrfw_alu_result__arith_result),
        .alu_result__result(            decexecrfw_alu_result__result)         );
    riscv_i32_dmem_request dmem_req(
        .dmem_exec__first_cycle(decexecrfw_combs__dmem_exec__first_cycle),
        .dmem_exec__exec_committed(decexecrfw_combs__dmem_exec__exec_committed),
        .dmem_exec__rs2(decexecrfw_combs__dmem_exec__rs2),
        .dmem_exec__arith_result(decexecrfw_combs__dmem_exec__arith_result),
        .dmem_exec__idecode__ext__dummy(decexecrfw_combs__dmem_exec__idecode__ext__dummy),
        .dmem_exec__idecode__is_compressed(decexecrfw_combs__dmem_exec__idecode__is_compressed),
        .dmem_exec__idecode__illegal_pc(decexecrfw_combs__dmem_exec__idecode__illegal_pc),
        .dmem_exec__idecode__illegal(decexecrfw_combs__dmem_exec__idecode__illegal),
        .dmem_exec__idecode__memory_width(decexecrfw_combs__dmem_exec__idecode__memory_width),
        .dmem_exec__idecode__memory_read_unsigned(decexecrfw_combs__dmem_exec__idecode__memory_read_unsigned),
        .dmem_exec__idecode__requires_machine_mode(decexecrfw_combs__dmem_exec__idecode__requires_machine_mode),
        .dmem_exec__idecode__subop(decexecrfw_combs__dmem_exec__idecode__subop),
        .dmem_exec__idecode__op(decexecrfw_combs__dmem_exec__idecode__op),
        .dmem_exec__idecode__immediate_valid(decexecrfw_combs__dmem_exec__idecode__immediate_valid),
        .dmem_exec__idecode__immediate_shift(decexecrfw_combs__dmem_exec__idecode__immediate_shift),
        .dmem_exec__idecode__immediate(decexecrfw_combs__dmem_exec__idecode__immediate),
        .dmem_exec__idecode__csr_access__write_data(decexecrfw_combs__dmem_exec__idecode__csr_access__write_data),
        .dmem_exec__idecode__csr_access__address(decexecrfw_combs__dmem_exec__idecode__csr_access__address),
        .dmem_exec__idecode__csr_access__access(decexecrfw_combs__dmem_exec__idecode__csr_access__access),
        .dmem_exec__idecode__csr_access__access_cancelled(decexecrfw_combs__dmem_exec__idecode__csr_access__access_cancelled),
        .dmem_exec__idecode__rd_written(decexecrfw_combs__dmem_exec__idecode__rd_written),
        .dmem_exec__idecode__rd(decexecrfw_combs__dmem_exec__idecode__rd),
        .dmem_exec__idecode__rs2_valid(decexecrfw_combs__dmem_exec__idecode__rs2_valid),
        .dmem_exec__idecode__rs2(decexecrfw_combs__dmem_exec__idecode__rs2),
        .dmem_exec__idecode__rs1_valid(decexecrfw_combs__dmem_exec__idecode__rs1_valid),
        .dmem_exec__idecode__rs1(decexecrfw_combs__dmem_exec__idecode__rs1),
        .dmem_request__multicycle(            decexecrfw_dmem_request__multicycle),
        .dmem_request__sign_extend_half(            decexecrfw_dmem_request__sign_extend_half),
        .dmem_request__sign_extend_byte(            decexecrfw_dmem_request__sign_extend_byte),
        .dmem_request__read_data_byte_enable(            decexecrfw_dmem_request__read_data_byte_enable),
        .dmem_request__read_data_byte_clear(            decexecrfw_dmem_request__read_data_byte_clear),
        .dmem_request__read_data_rotation(            decexecrfw_dmem_request__read_data_rotation),
        .dmem_request__reading(            decexecrfw_dmem_request__reading),
        .dmem_request__store_address_misaligned(            decexecrfw_dmem_request__store_address_misaligned),
        .dmem_request__load_address_misaligned(            decexecrfw_dmem_request__load_address_misaligned),
        .dmem_request__access__write_data(            decexecrfw_dmem_request__access__write_data),
        .dmem_request__access__read_enable(            decexecrfw_dmem_request__access__read_enable),
        .dmem_request__access__write_enable(            decexecrfw_dmem_request__access__write_enable),
        .dmem_request__access__byte_enable(            decexecrfw_dmem_request__access__byte_enable),
        .dmem_request__access__address(            decexecrfw_dmem_request__access__address)         );
    riscv_i32_control_flow control_flow(
        .control_data__alu_result__csr_access__write_data(decexecrfw_combs__control_data__alu_result__csr_access__write_data),
        .control_data__alu_result__csr_access__address(decexecrfw_combs__control_data__alu_result__csr_access__address),
        .control_data__alu_result__csr_access__access(decexecrfw_combs__control_data__alu_result__csr_access__access),
        .control_data__alu_result__csr_access__access_cancelled(decexecrfw_combs__control_data__alu_result__csr_access__access_cancelled),
        .control_data__alu_result__branch_target(decexecrfw_combs__control_data__alu_result__branch_target),
        .control_data__alu_result__branch_condition_met(decexecrfw_combs__control_data__alu_result__branch_condition_met),
        .control_data__alu_result__arith_result(decexecrfw_combs__control_data__alu_result__arith_result),
        .control_data__alu_result__result(decexecrfw_combs__control_data__alu_result__result),
        .control_data__instruction_data(decexecrfw_combs__control_data__instruction_data),
        .control_data__pc(decexecrfw_combs__control_data__pc),
        .control_data__idecode__ext__dummy(decexecrfw_combs__control_data__idecode__ext__dummy),
        .control_data__idecode__is_compressed(decexecrfw_combs__control_data__idecode__is_compressed),
        .control_data__idecode__illegal_pc(decexecrfw_combs__control_data__idecode__illegal_pc),
        .control_data__idecode__illegal(decexecrfw_combs__control_data__idecode__illegal),
        .control_data__idecode__memory_width(decexecrfw_combs__control_data__idecode__memory_width),
        .control_data__idecode__memory_read_unsigned(decexecrfw_combs__control_data__idecode__memory_read_unsigned),
        .control_data__idecode__requires_machine_mode(decexecrfw_combs__control_data__idecode__requires_machine_mode),
        .control_data__idecode__subop(decexecrfw_combs__control_data__idecode__subop),
        .control_data__idecode__op(decexecrfw_combs__control_data__idecode__op),
        .control_data__idecode__immediate_valid(decexecrfw_combs__control_data__idecode__immediate_valid),
        .control_data__idecode__immediate_shift(decexecrfw_combs__control_data__idecode__immediate_shift),
        .control_data__idecode__immediate(decexecrfw_combs__control_data__idecode__immediate),
        .control_data__idecode__csr_access__write_data(decexecrfw_combs__control_data__idecode__csr_access__write_data),
        .control_data__idecode__csr_access__address(decexecrfw_combs__control_data__idecode__csr_access__address),
        .control_data__idecode__csr_access__access(decexecrfw_combs__control_data__idecode__csr_access__access),
        .control_data__idecode__csr_access__access_cancelled(decexecrfw_combs__control_data__idecode__csr_access__access_cancelled),
        .control_data__idecode__rd_written(decexecrfw_combs__control_data__idecode__rd_written),
        .control_data__idecode__rd(decexecrfw_combs__control_data__idecode__rd),
        .control_data__idecode__rs2_valid(decexecrfw_combs__control_data__idecode__rs2_valid),
        .control_data__idecode__rs2(decexecrfw_combs__control_data__idecode__rs2),
        .control_data__idecode__rs1_valid(decexecrfw_combs__control_data__idecode__rs1_valid),
        .control_data__idecode__rs1(decexecrfw_combs__control_data__idecode__rs1),
        .control_data__first_cycle(decexecrfw_combs__control_data__first_cycle),
        .control_data__exec_committed(decexecrfw_combs__control_data__exec_committed),
        .control_data__valid(decexecrfw_combs__control_data__valid),
        .control_data__interrupt_ack(decexecrfw_combs__control_data__interrupt_ack),
        .pipeline_control__interrupt_to_mode(pipeline_control__interrupt_to_mode),
        .pipeline_control__interrupt_number(pipeline_control__interrupt_number),
        .pipeline_control__interrupt_req(pipeline_control__interrupt_req),
        .pipeline_control__tag(pipeline_control__tag),
        .pipeline_control__error(pipeline_control__error),
        .pipeline_control__mode(pipeline_control__mode),
        .pipeline_control__decode_pc(pipeline_control__decode_pc),
        .pipeline_control__fetch_action(pipeline_control__fetch_action),
        .pipeline_control__debug(pipeline_control__debug),
        .pipeline_control__valid(pipeline_control__valid),
        .control_flow__trap__vector(            decexecrfw_control_flow__trap__vector),
        .control_flow__trap__mret(            decexecrfw_control_flow__trap__mret),
        .control_flow__trap__value(            decexecrfw_control_flow__trap__value),
        .control_flow__trap__pc(            decexecrfw_control_flow__trap__pc),
        .control_flow__trap__cause(            decexecrfw_control_flow__trap__cause),
        .control_flow__trap__to_mode(            decexecrfw_control_flow__trap__to_mode),
        .control_flow__trap__valid(            decexecrfw_control_flow__trap__valid),
        .control_flow__next_pc(            decexecrfw_control_flow__next_pc),
        .control_flow__jalr(            decexecrfw_control_flow__jalr),
        .control_flow__branch_taken(            decexecrfw_control_flow__branch_taken)         );
    riscv_i32_dmem_read_data dmem_data(
        .dmem_access_resp__read_data(dmem_access_resp__read_data),
        .dmem_access_resp__wait(dmem_access_resp__wait),
        .last_data(32'h0),
        .dmem_request__multicycle(decexecrfw_dmem_request__multicycle),
        .dmem_request__sign_extend_half(decexecrfw_dmem_request__sign_extend_half),
        .dmem_request__sign_extend_byte(decexecrfw_dmem_request__sign_extend_byte),
        .dmem_request__read_data_byte_enable(decexecrfw_dmem_request__read_data_byte_enable),
        .dmem_request__read_data_byte_clear(decexecrfw_dmem_request__read_data_byte_clear),
        .dmem_request__read_data_rotation(decexecrfw_dmem_request__read_data_rotation),
        .dmem_request__reading(decexecrfw_dmem_request__reading),
        .dmem_request__store_address_misaligned(decexecrfw_dmem_request__store_address_misaligned),
        .dmem_request__load_address_misaligned(decexecrfw_dmem_request__load_address_misaligned),
        .dmem_request__access__write_data(decexecrfw_dmem_request__access__write_data),
        .dmem_request__access__read_enable(decexecrfw_dmem_request__access__read_enable),
        .dmem_request__access__write_enable(decexecrfw_dmem_request__access__write_enable),
        .dmem_request__access__byte_enable(decexecrfw_dmem_request__access__byte_enable),
        .dmem_request__access__address(decexecrfw_dmem_request__access__address),
        .dmem_read_data(            decexecrfw_dmem_read_data)         );
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
    reg decexecrfw_combs__idecode__csr_access__access_cancelled__var;
    reg [2:0]decexecrfw_combs__idecode__csr_access__access__var;
    reg [11:0]decexecrfw_combs__idecode__csr_access__address__var;
    reg [31:0]decexecrfw_combs__idecode__csr_access__write_data__var;
    reg [31:0]decexecrfw_combs__idecode__immediate__var;
    reg [4:0]decexecrfw_combs__idecode__immediate_shift__var;
    reg decexecrfw_combs__idecode__immediate_valid__var;
    reg [3:0]decexecrfw_combs__idecode__op__var;
    reg [3:0]decexecrfw_combs__idecode__subop__var;
    reg decexecrfw_combs__idecode__requires_machine_mode__var;
    reg decexecrfw_combs__idecode__memory_read_unsigned__var;
    reg [1:0]decexecrfw_combs__idecode__memory_width__var;
    reg decexecrfw_combs__idecode__illegal__var;
    reg decexecrfw_combs__idecode__illegal_pc__var;
    reg decexecrfw_combs__idecode__is_compressed__var;
    reg decexecrfw_combs__idecode__ext__dummy__var;
    reg decexecrfw_combs__exec_committed__var;
    reg decexecrfw_combs__csr_access__access_cancelled__var;
    reg [31:0]decexecrfw_combs__csr_access__write_data__var;
    reg [31:0]decexecrfw_combs__rfw_write_data__var;
        decexecrfw_combs__idecode__rs1__var = decexecrfw_idecode_i32__rs1;
        decexecrfw_combs__idecode__rs1_valid__var = decexecrfw_idecode_i32__rs1_valid;
        decexecrfw_combs__idecode__rs2__var = decexecrfw_idecode_i32__rs2;
        decexecrfw_combs__idecode__rs2_valid__var = decexecrfw_idecode_i32__rs2_valid;
        decexecrfw_combs__idecode__rd__var = decexecrfw_idecode_i32__rd;
        decexecrfw_combs__idecode__rd_written__var = decexecrfw_idecode_i32__rd_written;
        decexecrfw_combs__idecode__csr_access__access_cancelled__var = decexecrfw_idecode_i32__csr_access__access_cancelled;
        decexecrfw_combs__idecode__csr_access__access__var = decexecrfw_idecode_i32__csr_access__access;
        decexecrfw_combs__idecode__csr_access__address__var = decexecrfw_idecode_i32__csr_access__address;
        decexecrfw_combs__idecode__csr_access__write_data__var = decexecrfw_idecode_i32__csr_access__write_data;
        decexecrfw_combs__idecode__immediate__var = decexecrfw_idecode_i32__immediate;
        decexecrfw_combs__idecode__immediate_shift__var = decexecrfw_idecode_i32__immediate_shift;
        decexecrfw_combs__idecode__immediate_valid__var = decexecrfw_idecode_i32__immediate_valid;
        decexecrfw_combs__idecode__op__var = decexecrfw_idecode_i32__op;
        decexecrfw_combs__idecode__subop__var = decexecrfw_idecode_i32__subop;
        decexecrfw_combs__idecode__requires_machine_mode__var = decexecrfw_idecode_i32__requires_machine_mode;
        decexecrfw_combs__idecode__memory_read_unsigned__var = decexecrfw_idecode_i32__memory_read_unsigned;
        decexecrfw_combs__idecode__memory_width__var = decexecrfw_idecode_i32__memory_width;
        decexecrfw_combs__idecode__illegal__var = decexecrfw_idecode_i32__illegal;
        decexecrfw_combs__idecode__illegal_pc__var = decexecrfw_idecode_i32__illegal_pc;
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
                decexecrfw_combs__idecode__csr_access__access_cancelled__var = decexecrfw_idecode_i32c__csr_access__access_cancelled;
                decexecrfw_combs__idecode__csr_access__access__var = decexecrfw_idecode_i32c__csr_access__access;
                decexecrfw_combs__idecode__csr_access__address__var = decexecrfw_idecode_i32c__csr_access__address;
                decexecrfw_combs__idecode__csr_access__write_data__var = decexecrfw_idecode_i32c__csr_access__write_data;
                decexecrfw_combs__idecode__immediate__var = decexecrfw_idecode_i32c__immediate;
                decexecrfw_combs__idecode__immediate_shift__var = decexecrfw_idecode_i32c__immediate_shift;
                decexecrfw_combs__idecode__immediate_valid__var = decexecrfw_idecode_i32c__immediate_valid;
                decexecrfw_combs__idecode__op__var = decexecrfw_idecode_i32c__op;
                decexecrfw_combs__idecode__subop__var = decexecrfw_idecode_i32c__subop;
                decexecrfw_combs__idecode__requires_machine_mode__var = decexecrfw_idecode_i32c__requires_machine_mode;
                decexecrfw_combs__idecode__memory_read_unsigned__var = decexecrfw_idecode_i32c__memory_read_unsigned;
                decexecrfw_combs__idecode__memory_width__var = decexecrfw_idecode_i32c__memory_width;
                decexecrfw_combs__idecode__illegal__var = decexecrfw_idecode_i32c__illegal;
                decexecrfw_combs__idecode__illegal_pc__var = decexecrfw_idecode_i32c__illegal_pc;
                decexecrfw_combs__idecode__is_compressed__var = decexecrfw_idecode_i32c__is_compressed;
                decexecrfw_combs__idecode__ext__dummy__var = decexecrfw_idecode_i32c__ext__dummy;
            end //if
        end //if
        decexecrfw_combs__exec_committed__var = decexecrfw_state__valid;
        if (((decexecrfw_combs__idecode__illegal__var!=1'h0)||(decexecrfw_combs__idecode__illegal_pc__var!=1'h0)))
        begin
            decexecrfw_combs__exec_committed__var = 1'h0;
        end //if
        if ((pipeline_control__interrupt_req!=1'h0))
        begin
            decexecrfw_combs__exec_committed__var = 1'h0;
        end //if
        decexecrfw_combs__rs1 = registers[decexecrfw_combs__idecode__rs1__var];
        decexecrfw_combs__rs2 = registers[decexecrfw_combs__idecode__rs2__var];
        decexecrfw_combs__csr_access__access_cancelled__var = decexecrfw_combs__idecode__csr_access__access_cancelled__var;
        decexecrfw_combs__csr_access__access = decexecrfw_combs__idecode__csr_access__access__var;
        decexecrfw_combs__csr_access__address = decexecrfw_combs__idecode__csr_access__address__var;
        decexecrfw_combs__csr_access__write_data__var = decexecrfw_combs__idecode__csr_access__write_data__var;
        decexecrfw_combs__csr_access__access_cancelled__var = !(decexecrfw_combs__exec_committed__var!=1'h0);
        decexecrfw_combs__csr_access__write_data__var = ((decexecrfw_combs__idecode__immediate_valid__var!=1'h0)?{27'h0,decexecrfw_combs__idecode__rs1__var}:decexecrfw_combs__rs1);
        csr_access__access_cancelled = decexecrfw_combs__csr_access__access_cancelled__var;
        csr_access__access = decexecrfw_combs__csr_access__access;
        csr_access__address = decexecrfw_combs__csr_access__address;
        csr_access__write_data = decexecrfw_combs__csr_access__write_data__var;
        decexecrfw_combs__dmem_exec__idecode__rs1 = decexecrfw_combs__idecode__rs1__var;
        decexecrfw_combs__dmem_exec__idecode__rs1_valid = decexecrfw_combs__idecode__rs1_valid__var;
        decexecrfw_combs__dmem_exec__idecode__rs2 = decexecrfw_combs__idecode__rs2__var;
        decexecrfw_combs__dmem_exec__idecode__rs2_valid = decexecrfw_combs__idecode__rs2_valid__var;
        decexecrfw_combs__dmem_exec__idecode__rd = decexecrfw_combs__idecode__rd__var;
        decexecrfw_combs__dmem_exec__idecode__rd_written = decexecrfw_combs__idecode__rd_written__var;
        decexecrfw_combs__dmem_exec__idecode__csr_access__access_cancelled = decexecrfw_combs__idecode__csr_access__access_cancelled__var;
        decexecrfw_combs__dmem_exec__idecode__csr_access__access = decexecrfw_combs__idecode__csr_access__access__var;
        decexecrfw_combs__dmem_exec__idecode__csr_access__address = decexecrfw_combs__idecode__csr_access__address__var;
        decexecrfw_combs__dmem_exec__idecode__csr_access__write_data = decexecrfw_combs__idecode__csr_access__write_data__var;
        decexecrfw_combs__dmem_exec__idecode__immediate = decexecrfw_combs__idecode__immediate__var;
        decexecrfw_combs__dmem_exec__idecode__immediate_shift = decexecrfw_combs__idecode__immediate_shift__var;
        decexecrfw_combs__dmem_exec__idecode__immediate_valid = decexecrfw_combs__idecode__immediate_valid__var;
        decexecrfw_combs__dmem_exec__idecode__op = decexecrfw_combs__idecode__op__var;
        decexecrfw_combs__dmem_exec__idecode__subop = decexecrfw_combs__idecode__subop__var;
        decexecrfw_combs__dmem_exec__idecode__requires_machine_mode = decexecrfw_combs__idecode__requires_machine_mode__var;
        decexecrfw_combs__dmem_exec__idecode__memory_read_unsigned = decexecrfw_combs__idecode__memory_read_unsigned__var;
        decexecrfw_combs__dmem_exec__idecode__memory_width = decexecrfw_combs__idecode__memory_width__var;
        decexecrfw_combs__dmem_exec__idecode__illegal = decexecrfw_combs__idecode__illegal__var;
        decexecrfw_combs__dmem_exec__idecode__illegal_pc = decexecrfw_combs__idecode__illegal_pc__var;
        decexecrfw_combs__dmem_exec__idecode__is_compressed = decexecrfw_combs__idecode__is_compressed__var;
        decexecrfw_combs__dmem_exec__idecode__ext__dummy = decexecrfw_combs__idecode__ext__dummy__var;
        decexecrfw_combs__dmem_exec__arith_result = decexecrfw_alu_result__arith_result;
        decexecrfw_combs__dmem_exec__rs2 = decexecrfw_combs__rs2;
        decexecrfw_combs__dmem_exec__exec_committed = decexecrfw_combs__exec_committed__var;
        decexecrfw_combs__dmem_exec__first_cycle = 1'h1;
        dmem_access_req__address = decexecrfw_dmem_request__access__address;
        dmem_access_req__byte_enable = decexecrfw_dmem_request__access__byte_enable;
        dmem_access_req__write_enable = decexecrfw_dmem_request__access__write_enable;
        dmem_access_req__read_enable = decexecrfw_dmem_request__access__read_enable;
        dmem_access_req__write_data = decexecrfw_dmem_request__access__write_data;
        decexecrfw_combs__control_data__instruction_data = decexecrfw_state__instruction__data;
        decexecrfw_combs__control_data__pc = pipeline_control__decode_pc;
        decexecrfw_combs__control_data__alu_result__result = decexecrfw_alu_result__result;
        decexecrfw_combs__control_data__alu_result__arith_result = decexecrfw_alu_result__arith_result;
        decexecrfw_combs__control_data__alu_result__branch_condition_met = decexecrfw_alu_result__branch_condition_met;
        decexecrfw_combs__control_data__alu_result__branch_target = decexecrfw_alu_result__branch_target;
        decexecrfw_combs__control_data__alu_result__csr_access__access_cancelled = decexecrfw_alu_result__csr_access__access_cancelled;
        decexecrfw_combs__control_data__alu_result__csr_access__access = decexecrfw_alu_result__csr_access__access;
        decexecrfw_combs__control_data__alu_result__csr_access__address = decexecrfw_alu_result__csr_access__address;
        decexecrfw_combs__control_data__alu_result__csr_access__write_data = decexecrfw_alu_result__csr_access__write_data;
        decexecrfw_combs__control_data__interrupt_ack = 1'h1;
        decexecrfw_combs__control_data__valid = decexecrfw_state__valid;
        decexecrfw_combs__control_data__exec_committed = decexecrfw_combs__exec_committed__var;
        decexecrfw_combs__control_data__idecode__rs1 = decexecrfw_combs__idecode__rs1__var;
        decexecrfw_combs__control_data__idecode__rs1_valid = decexecrfw_combs__idecode__rs1_valid__var;
        decexecrfw_combs__control_data__idecode__rs2 = decexecrfw_combs__idecode__rs2__var;
        decexecrfw_combs__control_data__idecode__rs2_valid = decexecrfw_combs__idecode__rs2_valid__var;
        decexecrfw_combs__control_data__idecode__rd = decexecrfw_combs__idecode__rd__var;
        decexecrfw_combs__control_data__idecode__rd_written = decexecrfw_combs__idecode__rd_written__var;
        decexecrfw_combs__control_data__idecode__csr_access__access_cancelled = decexecrfw_combs__idecode__csr_access__access_cancelled__var;
        decexecrfw_combs__control_data__idecode__csr_access__access = decexecrfw_combs__idecode__csr_access__access__var;
        decexecrfw_combs__control_data__idecode__csr_access__address = decexecrfw_combs__idecode__csr_access__address__var;
        decexecrfw_combs__control_data__idecode__csr_access__write_data = decexecrfw_combs__idecode__csr_access__write_data__var;
        decexecrfw_combs__control_data__idecode__immediate = decexecrfw_combs__idecode__immediate__var;
        decexecrfw_combs__control_data__idecode__immediate_shift = decexecrfw_combs__idecode__immediate_shift__var;
        decexecrfw_combs__control_data__idecode__immediate_valid = decexecrfw_combs__idecode__immediate_valid__var;
        decexecrfw_combs__control_data__idecode__op = decexecrfw_combs__idecode__op__var;
        decexecrfw_combs__control_data__idecode__subop = decexecrfw_combs__idecode__subop__var;
        decexecrfw_combs__control_data__idecode__requires_machine_mode = decexecrfw_combs__idecode__requires_machine_mode__var;
        decexecrfw_combs__control_data__idecode__memory_read_unsigned = decexecrfw_combs__idecode__memory_read_unsigned__var;
        decexecrfw_combs__control_data__idecode__memory_width = decexecrfw_combs__idecode__memory_width__var;
        decexecrfw_combs__control_data__idecode__illegal = decexecrfw_combs__idecode__illegal__var;
        decexecrfw_combs__control_data__idecode__illegal_pc = decexecrfw_combs__idecode__illegal_pc__var;
        decexecrfw_combs__control_data__idecode__is_compressed = decexecrfw_combs__idecode__is_compressed__var;
        decexecrfw_combs__control_data__idecode__ext__dummy = decexecrfw_combs__idecode__ext__dummy__var;
        decexecrfw_combs__control_data__first_cycle = 1'h1;
        pipeline_response__decode__valid = decexecrfw_state__valid;
        pipeline_response__decode__idecode__rs1 = decexecrfw_combs__idecode__rs1__var;
        pipeline_response__decode__idecode__rs1_valid = decexecrfw_combs__idecode__rs1_valid__var;
        pipeline_response__decode__idecode__rs2 = decexecrfw_combs__idecode__rs2__var;
        pipeline_response__decode__idecode__rs2_valid = decexecrfw_combs__idecode__rs2_valid__var;
        pipeline_response__decode__idecode__rd = decexecrfw_combs__idecode__rd__var;
        pipeline_response__decode__idecode__rd_written = decexecrfw_combs__idecode__rd_written__var;
        pipeline_response__decode__idecode__csr_access__access_cancelled = decexecrfw_combs__idecode__csr_access__access_cancelled__var;
        pipeline_response__decode__idecode__csr_access__access = decexecrfw_combs__idecode__csr_access__access__var;
        pipeline_response__decode__idecode__csr_access__address = decexecrfw_combs__idecode__csr_access__address__var;
        pipeline_response__decode__idecode__csr_access__write_data = decexecrfw_combs__idecode__csr_access__write_data__var;
        pipeline_response__decode__idecode__immediate = decexecrfw_combs__idecode__immediate__var;
        pipeline_response__decode__idecode__immediate_shift = decexecrfw_combs__idecode__immediate_shift__var;
        pipeline_response__decode__idecode__immediate_valid = decexecrfw_combs__idecode__immediate_valid__var;
        pipeline_response__decode__idecode__op = decexecrfw_combs__idecode__op__var;
        pipeline_response__decode__idecode__subop = decexecrfw_combs__idecode__subop__var;
        pipeline_response__decode__idecode__requires_machine_mode = decexecrfw_combs__idecode__requires_machine_mode__var;
        pipeline_response__decode__idecode__memory_read_unsigned = decexecrfw_combs__idecode__memory_read_unsigned__var;
        pipeline_response__decode__idecode__memory_width = decexecrfw_combs__idecode__memory_width__var;
        pipeline_response__decode__idecode__illegal = decexecrfw_combs__idecode__illegal__var;
        pipeline_response__decode__idecode__illegal_pc = decexecrfw_combs__idecode__illegal_pc__var;
        pipeline_response__decode__idecode__is_compressed = decexecrfw_combs__idecode__is_compressed__var;
        pipeline_response__decode__idecode__ext__dummy = decexecrfw_combs__idecode__ext__dummy__var;
        pipeline_response__decode__decode_blocked = 1'h0;
        pipeline_response__decode__branch_target = 32'h0;
        pipeline_response__decode__enable_branch_prediction = 1'h0;
        pipeline_response__exec__valid = decexecrfw_state__valid;
        pipeline_response__exec__cannot_start = !(decexecrfw_combs__exec_committed__var!=1'h0);
        pipeline_response__exec__cannot_complete = !(decexecrfw_combs__exec_committed__var!=1'h0);
        pipeline_response__exec__interrupt_ack = pipeline_control__interrupt_req;
        pipeline_response__exec__is_compressed = decexecrfw_combs__idecode__is_compressed__var;
        pipeline_response__exec__pc = pipeline_control__decode_pc;
        pipeline_response__exec__instruction__mode = decexecrfw_state__instruction__mode;
        pipeline_response__exec__instruction__data = decexecrfw_state__instruction__data;
        pipeline_response__exec__rs1 = decexecrfw_combs__rs1;
        pipeline_response__exec__rs2 = decexecrfw_combs__rs2;
        pipeline_response__exec__predicted_branch = 1'h0;
        pipeline_response__exec__pc_if_mispredicted = decexecrfw_alu_result__branch_target;
        pipeline_response__exec__branch_taken = decexecrfw_control_flow__branch_taken;
        pipeline_response__exec__trap__valid = decexecrfw_control_flow__trap__valid;
        pipeline_response__exec__trap__to_mode = decexecrfw_control_flow__trap__to_mode;
        pipeline_response__exec__trap__cause = decexecrfw_control_flow__trap__cause;
        pipeline_response__exec__trap__pc = decexecrfw_control_flow__trap__pc;
        pipeline_response__exec__trap__value = decexecrfw_control_flow__trap__value;
        pipeline_response__exec__trap__mret = decexecrfw_control_flow__trap__mret;
        pipeline_response__exec__trap__vector = decexecrfw_control_flow__trap__vector;
        pipeline_response__rfw__valid = rfw_state__valid;
        pipeline_response__rfw__rd_written = rfw_state__rd_written;
        pipeline_response__rfw__rd = rfw_state__rd;
        pipeline_response__rfw__data = rfw_state__data;
        decexecrfw_combs__rfw_write_data__var = (decexecrfw_alu_result__result | coproc_response__result);
        if (((1'h0!=64'h0)||(riscv_config__coproc_disable!=1'h0)))
        begin
            decexecrfw_combs__rfw_write_data__var = decexecrfw_alu_result__result;
        end //if
        if ((dmem_access_req__read_enable!=1'h0))
        begin
            decexecrfw_combs__rfw_write_data__var = decexecrfw_dmem_read_data;
        end //if
        if ((decexecrfw_combs__idecode__csr_access__access__var!=3'h0))
        begin
            decexecrfw_combs__rfw_write_data__var = csr_read_data;
        end //if
        decexecrfw_combs__idecode__rs1 = decexecrfw_combs__idecode__rs1__var;
        decexecrfw_combs__idecode__rs1_valid = decexecrfw_combs__idecode__rs1_valid__var;
        decexecrfw_combs__idecode__rs2 = decexecrfw_combs__idecode__rs2__var;
        decexecrfw_combs__idecode__rs2_valid = decexecrfw_combs__idecode__rs2_valid__var;
        decexecrfw_combs__idecode__rd = decexecrfw_combs__idecode__rd__var;
        decexecrfw_combs__idecode__rd_written = decexecrfw_combs__idecode__rd_written__var;
        decexecrfw_combs__idecode__csr_access__access_cancelled = decexecrfw_combs__idecode__csr_access__access_cancelled__var;
        decexecrfw_combs__idecode__csr_access__access = decexecrfw_combs__idecode__csr_access__access__var;
        decexecrfw_combs__idecode__csr_access__address = decexecrfw_combs__idecode__csr_access__address__var;
        decexecrfw_combs__idecode__csr_access__write_data = decexecrfw_combs__idecode__csr_access__write_data__var;
        decexecrfw_combs__idecode__immediate = decexecrfw_combs__idecode__immediate__var;
        decexecrfw_combs__idecode__immediate_shift = decexecrfw_combs__idecode__immediate_shift__var;
        decexecrfw_combs__idecode__immediate_valid = decexecrfw_combs__idecode__immediate_valid__var;
        decexecrfw_combs__idecode__op = decexecrfw_combs__idecode__op__var;
        decexecrfw_combs__idecode__subop = decexecrfw_combs__idecode__subop__var;
        decexecrfw_combs__idecode__requires_machine_mode = decexecrfw_combs__idecode__requires_machine_mode__var;
        decexecrfw_combs__idecode__memory_read_unsigned = decexecrfw_combs__idecode__memory_read_unsigned__var;
        decexecrfw_combs__idecode__memory_width = decexecrfw_combs__idecode__memory_width__var;
        decexecrfw_combs__idecode__illegal = decexecrfw_combs__idecode__illegal__var;
        decexecrfw_combs__idecode__illegal_pc = decexecrfw_combs__idecode__illegal_pc__var;
        decexecrfw_combs__idecode__is_compressed = decexecrfw_combs__idecode__is_compressed__var;
        decexecrfw_combs__idecode__ext__dummy = decexecrfw_combs__idecode__ext__dummy__var;
        decexecrfw_combs__exec_committed = decexecrfw_combs__exec_committed__var;
        decexecrfw_combs__csr_access__access_cancelled = decexecrfw_combs__csr_access__access_cancelled__var;
        decexecrfw_combs__csr_access__write_data = decexecrfw_combs__csr_access__write_data__var;
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
            decexecrfw_state__valid <= 1'h0;
            decexecrfw_state__instruction__data <= 32'h0;
            decexecrfw_state__instruction__mode <= 3'h0;
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
            rfw_state__valid <= 1'h0;
            rfw_state__rd_written <= 1'h0;
            rfw_state__rd <= 5'h0;
            rfw_state__data <= 32'h0;
        end
        else if (clk__enable)
        begin
            decexecrfw_state__valid <= 1'h0;
            if ((pipeline_fetch_data__valid!=1'h0))
            begin
                decexecrfw_state__instruction__data <= pipeline_fetch_data__data;
                decexecrfw_state__instruction__mode <= pipeline_control__mode;
                decexecrfw_state__valid <= 1'h1;
            end //if
            if (((decexecrfw_combs__exec_committed!=1'h0)&&(decexecrfw_combs__idecode__rd_written!=1'h0)))
            begin
                registers[decexecrfw_combs__idecode__rd] <= decexecrfw_combs__rfw_write_data;
            end //if
            registers[0] <= 32'h0;
            rfw_state__valid <= decexecrfw_combs__exec_committed;
            rfw_state__rd_written <= ((decexecrfw_combs__exec_committed!=1'h0)&&(decexecrfw_combs__idecode__rd_written!=1'h0));
            rfw_state__rd <= decexecrfw_combs__idecode__rd;
            rfw_state__data <= decexecrfw_combs__rfw_write_data;
        end //if
    end //always

endmodule // riscv_i32c_pipeline
