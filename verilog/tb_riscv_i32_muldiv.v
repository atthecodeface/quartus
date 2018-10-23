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

//a Module tb_riscv_i32_muldiv
module tb_riscv_i32_muldiv
(
    clk,
    clk__enable,

    reset_n

);

    //b Clocks
    input clk;
    input clk__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials
    reg coproc_controls_with_feedback__dec_idecode_valid;
    reg [4:0]coproc_controls_with_feedback__dec_idecode__rs1;
    reg coproc_controls_with_feedback__dec_idecode__rs1_valid;
    reg [4:0]coproc_controls_with_feedback__dec_idecode__rs2;
    reg coproc_controls_with_feedback__dec_idecode__rs2_valid;
    reg [4:0]coproc_controls_with_feedback__dec_idecode__rd;
    reg coproc_controls_with_feedback__dec_idecode__rd_written;
    reg coproc_controls_with_feedback__dec_idecode__csr_access__access_cancelled;
    reg [2:0]coproc_controls_with_feedback__dec_idecode__csr_access__access;
    reg [11:0]coproc_controls_with_feedback__dec_idecode__csr_access__address;
    reg [31:0]coproc_controls_with_feedback__dec_idecode__csr_access__write_data;
    reg [31:0]coproc_controls_with_feedback__dec_idecode__immediate;
    reg [4:0]coproc_controls_with_feedback__dec_idecode__immediate_shift;
    reg coproc_controls_with_feedback__dec_idecode__immediate_valid;
    reg [3:0]coproc_controls_with_feedback__dec_idecode__op;
    reg [3:0]coproc_controls_with_feedback__dec_idecode__subop;
    reg coproc_controls_with_feedback__dec_idecode__requires_machine_mode;
    reg coproc_controls_with_feedback__dec_idecode__memory_read_unsigned;
    reg [1:0]coproc_controls_with_feedback__dec_idecode__memory_width;
    reg coproc_controls_with_feedback__dec_idecode__illegal;
    reg coproc_controls_with_feedback__dec_idecode__illegal_pc;
    reg coproc_controls_with_feedback__dec_idecode__is_compressed;
    reg coproc_controls_with_feedback__dec_idecode__ext__dummy;
    reg coproc_controls_with_feedback__dec_to_alu_blocked;
    reg [31:0]coproc_controls_with_feedback__alu_rs1;
    reg [31:0]coproc_controls_with_feedback__alu_rs2;
    reg coproc_controls_with_feedback__alu_flush_pipeline;
    reg coproc_controls_with_feedback__alu_cannot_start;
    reg coproc_controls_with_feedback__alu_cannot_complete;

    //b Internal nets
    wire riscv_config__i32c;
    wire riscv_config__e32;
    wire riscv_config__i32m;
    wire riscv_config__i32m_fuse;
    wire riscv_config__coproc_disable;
    wire riscv_config__unaligned_mem;
    wire coproc_response__cannot_start;
    wire [31:0]coproc_response__result;
    wire coproc_response__result_valid;
    wire coproc_response__cannot_complete;
    wire coproc_controls__dec_idecode_valid;
    wire [4:0]coproc_controls__dec_idecode__rs1;
    wire coproc_controls__dec_idecode__rs1_valid;
    wire [4:0]coproc_controls__dec_idecode__rs2;
    wire coproc_controls__dec_idecode__rs2_valid;
    wire [4:0]coproc_controls__dec_idecode__rd;
    wire coproc_controls__dec_idecode__rd_written;
    wire coproc_controls__dec_idecode__csr_access__access_cancelled;
    wire [2:0]coproc_controls__dec_idecode__csr_access__access;
    wire [11:0]coproc_controls__dec_idecode__csr_access__address;
    wire [31:0]coproc_controls__dec_idecode__csr_access__write_data;
    wire [31:0]coproc_controls__dec_idecode__immediate;
    wire [4:0]coproc_controls__dec_idecode__immediate_shift;
    wire coproc_controls__dec_idecode__immediate_valid;
    wire [3:0]coproc_controls__dec_idecode__op;
    wire [3:0]coproc_controls__dec_idecode__subop;
    wire coproc_controls__dec_idecode__requires_machine_mode;
    wire coproc_controls__dec_idecode__memory_read_unsigned;
    wire [1:0]coproc_controls__dec_idecode__memory_width;
    wire coproc_controls__dec_idecode__illegal;
    wire coproc_controls__dec_idecode__illegal_pc;
    wire coproc_controls__dec_idecode__is_compressed;
    wire coproc_controls__dec_idecode__ext__dummy;
    wire coproc_controls__dec_to_alu_blocked;
    wire [31:0]coproc_controls__alu_rs1;
    wire [31:0]coproc_controls__alu_rs2;
    wire coproc_controls__alu_flush_pipeline;
    wire coproc_controls__alu_cannot_start;
    wire coproc_controls__alu_cannot_complete;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .coproc_response__cannot_complete(coproc_response__cannot_complete),
        .coproc_response__result_valid(coproc_response__result_valid),
        .coproc_response__result(coproc_response__result),
        .coproc_response__cannot_start(coproc_response__cannot_start),
        .riscv_config__unaligned_mem(            riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(            riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(            riscv_config__i32m_fuse),
        .riscv_config__i32m(            riscv_config__i32m),
        .riscv_config__e32(            riscv_config__e32),
        .riscv_config__i32c(            riscv_config__i32c),
        .coproc_controls__alu_cannot_complete(            coproc_controls__alu_cannot_complete),
        .coproc_controls__alu_cannot_start(            coproc_controls__alu_cannot_start),
        .coproc_controls__alu_flush_pipeline(            coproc_controls__alu_flush_pipeline),
        .coproc_controls__alu_rs2(            coproc_controls__alu_rs2),
        .coproc_controls__alu_rs1(            coproc_controls__alu_rs1),
        .coproc_controls__dec_to_alu_blocked(            coproc_controls__dec_to_alu_blocked),
        .coproc_controls__dec_idecode__ext__dummy(            coproc_controls__dec_idecode__ext__dummy),
        .coproc_controls__dec_idecode__is_compressed(            coproc_controls__dec_idecode__is_compressed),
        .coproc_controls__dec_idecode__illegal_pc(            coproc_controls__dec_idecode__illegal_pc),
        .coproc_controls__dec_idecode__illegal(            coproc_controls__dec_idecode__illegal),
        .coproc_controls__dec_idecode__memory_width(            coproc_controls__dec_idecode__memory_width),
        .coproc_controls__dec_idecode__memory_read_unsigned(            coproc_controls__dec_idecode__memory_read_unsigned),
        .coproc_controls__dec_idecode__requires_machine_mode(            coproc_controls__dec_idecode__requires_machine_mode),
        .coproc_controls__dec_idecode__subop(            coproc_controls__dec_idecode__subop),
        .coproc_controls__dec_idecode__op(            coproc_controls__dec_idecode__op),
        .coproc_controls__dec_idecode__immediate_valid(            coproc_controls__dec_idecode__immediate_valid),
        .coproc_controls__dec_idecode__immediate_shift(            coproc_controls__dec_idecode__immediate_shift),
        .coproc_controls__dec_idecode__immediate(            coproc_controls__dec_idecode__immediate),
        .coproc_controls__dec_idecode__csr_access__write_data(            coproc_controls__dec_idecode__csr_access__write_data),
        .coproc_controls__dec_idecode__csr_access__address(            coproc_controls__dec_idecode__csr_access__address),
        .coproc_controls__dec_idecode__csr_access__access(            coproc_controls__dec_idecode__csr_access__access),
        .coproc_controls__dec_idecode__csr_access__access_cancelled(            coproc_controls__dec_idecode__csr_access__access_cancelled),
        .coproc_controls__dec_idecode__rd_written(            coproc_controls__dec_idecode__rd_written),
        .coproc_controls__dec_idecode__rd(            coproc_controls__dec_idecode__rd),
        .coproc_controls__dec_idecode__rs2_valid(            coproc_controls__dec_idecode__rs2_valid),
        .coproc_controls__dec_idecode__rs2(            coproc_controls__dec_idecode__rs2),
        .coproc_controls__dec_idecode__rs1_valid(            coproc_controls__dec_idecode__rs1_valid),
        .coproc_controls__dec_idecode__rs1(            coproc_controls__dec_idecode__rs1),
        .coproc_controls__dec_idecode_valid(            coproc_controls__dec_idecode_valid)         );
    riscv_i32_muldiv dut(
        .clk(clk),
        .clk__enable(1'b1),
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .coproc_controls__alu_cannot_complete(coproc_controls_with_feedback__alu_cannot_complete),
        .coproc_controls__alu_cannot_start(coproc_controls_with_feedback__alu_cannot_start),
        .coproc_controls__alu_flush_pipeline(coproc_controls_with_feedback__alu_flush_pipeline),
        .coproc_controls__alu_rs2(coproc_controls_with_feedback__alu_rs2),
        .coproc_controls__alu_rs1(coproc_controls_with_feedback__alu_rs1),
        .coproc_controls__dec_to_alu_blocked(coproc_controls_with_feedback__dec_to_alu_blocked),
        .coproc_controls__dec_idecode__ext__dummy(coproc_controls_with_feedback__dec_idecode__ext__dummy),
        .coproc_controls__dec_idecode__is_compressed(coproc_controls_with_feedback__dec_idecode__is_compressed),
        .coproc_controls__dec_idecode__illegal_pc(coproc_controls_with_feedback__dec_idecode__illegal_pc),
        .coproc_controls__dec_idecode__illegal(coproc_controls_with_feedback__dec_idecode__illegal),
        .coproc_controls__dec_idecode__memory_width(coproc_controls_with_feedback__dec_idecode__memory_width),
        .coproc_controls__dec_idecode__memory_read_unsigned(coproc_controls_with_feedback__dec_idecode__memory_read_unsigned),
        .coproc_controls__dec_idecode__requires_machine_mode(coproc_controls_with_feedback__dec_idecode__requires_machine_mode),
        .coproc_controls__dec_idecode__subop(coproc_controls_with_feedback__dec_idecode__subop),
        .coproc_controls__dec_idecode__op(coproc_controls_with_feedback__dec_idecode__op),
        .coproc_controls__dec_idecode__immediate_valid(coproc_controls_with_feedback__dec_idecode__immediate_valid),
        .coproc_controls__dec_idecode__immediate_shift(coproc_controls_with_feedback__dec_idecode__immediate_shift),
        .coproc_controls__dec_idecode__immediate(coproc_controls_with_feedback__dec_idecode__immediate),
        .coproc_controls__dec_idecode__csr_access__write_data(coproc_controls_with_feedback__dec_idecode__csr_access__write_data),
        .coproc_controls__dec_idecode__csr_access__address(coproc_controls_with_feedback__dec_idecode__csr_access__address),
        .coproc_controls__dec_idecode__csr_access__access(coproc_controls_with_feedback__dec_idecode__csr_access__access),
        .coproc_controls__dec_idecode__csr_access__access_cancelled(coproc_controls_with_feedback__dec_idecode__csr_access__access_cancelled),
        .coproc_controls__dec_idecode__rd_written(coproc_controls_with_feedback__dec_idecode__rd_written),
        .coproc_controls__dec_idecode__rd(coproc_controls_with_feedback__dec_idecode__rd),
        .coproc_controls__dec_idecode__rs2_valid(coproc_controls_with_feedback__dec_idecode__rs2_valid),
        .coproc_controls__dec_idecode__rs2(coproc_controls_with_feedback__dec_idecode__rs2),
        .coproc_controls__dec_idecode__rs1_valid(coproc_controls_with_feedback__dec_idecode__rs1_valid),
        .coproc_controls__dec_idecode__rs1(coproc_controls_with_feedback__dec_idecode__rs1),
        .coproc_controls__dec_idecode_valid(coproc_controls_with_feedback__dec_idecode_valid),
        .reset_n(reset_n),
        .coproc_response__cannot_complete(            coproc_response__cannot_complete),
        .coproc_response__result_valid(            coproc_response__result_valid),
        .coproc_response__result(            coproc_response__result),
        .coproc_response__cannot_start(            coproc_response__cannot_start)         );
    //b riscv_instance combinatorial process
    always @ ( * )//riscv_instance
    begin: riscv_instance__comb_code
    reg coproc_controls_with_feedback__dec_to_alu_blocked__var;
    reg coproc_controls_with_feedback__alu_cannot_start__var;
    reg coproc_controls_with_feedback__alu_cannot_complete__var;
        coproc_controls_with_feedback__dec_idecode_valid = coproc_controls__dec_idecode_valid;
        coproc_controls_with_feedback__dec_idecode__rs1 = coproc_controls__dec_idecode__rs1;
        coproc_controls_with_feedback__dec_idecode__rs1_valid = coproc_controls__dec_idecode__rs1_valid;
        coproc_controls_with_feedback__dec_idecode__rs2 = coproc_controls__dec_idecode__rs2;
        coproc_controls_with_feedback__dec_idecode__rs2_valid = coproc_controls__dec_idecode__rs2_valid;
        coproc_controls_with_feedback__dec_idecode__rd = coproc_controls__dec_idecode__rd;
        coproc_controls_with_feedback__dec_idecode__rd_written = coproc_controls__dec_idecode__rd_written;
        coproc_controls_with_feedback__dec_idecode__csr_access__access_cancelled = coproc_controls__dec_idecode__csr_access__access_cancelled;
        coproc_controls_with_feedback__dec_idecode__csr_access__access = coproc_controls__dec_idecode__csr_access__access;
        coproc_controls_with_feedback__dec_idecode__csr_access__address = coproc_controls__dec_idecode__csr_access__address;
        coproc_controls_with_feedback__dec_idecode__csr_access__write_data = coproc_controls__dec_idecode__csr_access__write_data;
        coproc_controls_with_feedback__dec_idecode__immediate = coproc_controls__dec_idecode__immediate;
        coproc_controls_with_feedback__dec_idecode__immediate_shift = coproc_controls__dec_idecode__immediate_shift;
        coproc_controls_with_feedback__dec_idecode__immediate_valid = coproc_controls__dec_idecode__immediate_valid;
        coproc_controls_with_feedback__dec_idecode__op = coproc_controls__dec_idecode__op;
        coproc_controls_with_feedback__dec_idecode__subop = coproc_controls__dec_idecode__subop;
        coproc_controls_with_feedback__dec_idecode__requires_machine_mode = coproc_controls__dec_idecode__requires_machine_mode;
        coproc_controls_with_feedback__dec_idecode__memory_read_unsigned = coproc_controls__dec_idecode__memory_read_unsigned;
        coproc_controls_with_feedback__dec_idecode__memory_width = coproc_controls__dec_idecode__memory_width;
        coproc_controls_with_feedback__dec_idecode__illegal = coproc_controls__dec_idecode__illegal;
        coproc_controls_with_feedback__dec_idecode__illegal_pc = coproc_controls__dec_idecode__illegal_pc;
        coproc_controls_with_feedback__dec_idecode__is_compressed = coproc_controls__dec_idecode__is_compressed;
        coproc_controls_with_feedback__dec_idecode__ext__dummy = coproc_controls__dec_idecode__ext__dummy;
        coproc_controls_with_feedback__dec_to_alu_blocked__var = coproc_controls__dec_to_alu_blocked;
        coproc_controls_with_feedback__alu_rs1 = coproc_controls__alu_rs1;
        coproc_controls_with_feedback__alu_rs2 = coproc_controls__alu_rs2;
        coproc_controls_with_feedback__alu_flush_pipeline = coproc_controls__alu_flush_pipeline;
        coproc_controls_with_feedback__alu_cannot_start__var = coproc_controls__alu_cannot_start;
        coproc_controls_with_feedback__alu_cannot_complete__var = coproc_controls__alu_cannot_complete;
        coproc_controls_with_feedback__alu_cannot_start__var = coproc_controls_with_feedback__alu_cannot_start__var | coproc_response__cannot_start;
        coproc_controls_with_feedback__alu_cannot_complete__var = coproc_controls_with_feedback__alu_cannot_complete__var | coproc_response__cannot_complete;
        coproc_controls_with_feedback__dec_to_alu_blocked__var = coproc_controls_with_feedback__dec_to_alu_blocked__var | coproc_response__cannot_start;
        coproc_controls_with_feedback__dec_to_alu_blocked__var = coproc_controls_with_feedback__dec_to_alu_blocked__var | coproc_response__cannot_complete;
        coproc_controls_with_feedback__dec_to_alu_blocked = coproc_controls_with_feedback__dec_to_alu_blocked__var;
        coproc_controls_with_feedback__alu_cannot_start = coproc_controls_with_feedback__alu_cannot_start__var;
        coproc_controls_with_feedback__alu_cannot_complete = coproc_controls_with_feedback__alu_cannot_complete__var;
    end //always

endmodule // tb_riscv_i32_muldiv
