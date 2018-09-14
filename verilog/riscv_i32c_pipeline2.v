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

//a Module riscv_i32c_pipeline2
    //   
    //   
module riscv_i32c_pipeline2
(
    clk,
    clk__enable,

    riscv_config__i32c,
    riscv_config__e32,
    riscv_config__i32m,
    riscv_config__i32m_fuse,
    riscv_config__coproc_disable,
    riscv_config__unaligned_mem,
    ifetch_resp__valid,
    ifetch_resp__debug,
    ifetch_resp__data,
    ifetch_resp__mode,
    ifetch_resp__error,
    ifetch_resp__tag,
    dmem_access_resp__wait,
    dmem_access_resp__read_data,
    irqs__nmi,
    irqs__meip,
    irqs__seip,
    irqs__ueip,
    irqs__mtip,
    irqs__msip,
    irqs__time,
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
    input ifetch_resp__valid;
    input ifetch_resp__debug;
    input [31:0]ifetch_resp__data;
    input [2:0]ifetch_resp__mode;
    input ifetch_resp__error;
    input [1:0]ifetch_resp__tag;
    input dmem_access_resp__wait;
    input [31:0]dmem_access_resp__read_data;
        //   Interrupts in to the CPU
    input irqs__nmi;
    input irqs__meip;
    input irqs__seip;
    input irqs__ueip;
    input irqs__mtip;
    input irqs__msip;
    input [63:0]irqs__time;
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
    reg [4:0]rfw_state__idecode__rs1;
    reg rfw_state__idecode__rs1_valid;
    reg [4:0]rfw_state__idecode__rs2;
    reg rfw_state__idecode__rs2_valid;
    reg [4:0]rfw_state__idecode__rd;
    reg rfw_state__idecode__rd_written;
    reg [2:0]rfw_state__idecode__csr_access__access;
    reg [11:0]rfw_state__idecode__csr_access__address;
    reg [31:0]rfw_state__idecode__immediate;
    reg [4:0]rfw_state__idecode__immediate_shift;
    reg rfw_state__idecode__immediate_valid;
    reg [3:0]rfw_state__idecode__op;
    reg [3:0]rfw_state__idecode__subop;
    reg rfw_state__idecode__requires_machine_mode;
    reg rfw_state__idecode__memory_read_unsigned;
    reg [1:0]rfw_state__idecode__memory_width;
    reg rfw_state__idecode__illegal;
    reg rfw_state__idecode__is_compressed;
    reg rfw_state__idecode__ext__dummy;
    reg rfw_state__valid;
    reg rfw_state__memory_read;
    reg [1:0]rfw_state__word_offset;
    reg [31:0]rfw_state__result;
    reg [2:0]decexec_state__instruction__mode;
    reg [31:0]decexec_state__instruction__data;
    reg decexec_state__valid;
    reg [31:0]decexec_state__pc;
        //   Register 0 is tied to 0 - so it is written on every cycle to zero...
    reg [31:0]registers[31:0];

    //b Internal combinatorials
    reg [2:0]csr_controls__exec_mode;
    reg csr_controls__retire;
    reg csr_controls__timer_inc;
    reg csr_controls__timer_clear;
    reg csr_controls__timer_load;
    reg [63:0]csr_controls__timer_value;
    reg csr_controls__interrupt;
    reg csr_controls__trap;
    reg [3:0]csr_controls__trap_cause;
    reg [31:0]csr_controls__trap_pc;
    reg [31:0]csr_controls__trap_value;
    reg [31:0]rfw_combs__write_data;
    reg [31:0]rfw_combs__memory_data;
    reg [4:0]decexec_combs__idecode__rs1;
    reg decexec_combs__idecode__rs1_valid;
    reg [4:0]decexec_combs__idecode__rs2;
    reg decexec_combs__idecode__rs2_valid;
    reg [4:0]decexec_combs__idecode__rd;
    reg decexec_combs__idecode__rd_written;
    reg [2:0]decexec_combs__idecode__csr_access__access;
    reg [11:0]decexec_combs__idecode__csr_access__address;
    reg [31:0]decexec_combs__idecode__immediate;
    reg [4:0]decexec_combs__idecode__immediate_shift;
    reg decexec_combs__idecode__immediate_valid;
    reg [3:0]decexec_combs__idecode__op;
    reg [3:0]decexec_combs__idecode__subop;
    reg decexec_combs__idecode__requires_machine_mode;
    reg decexec_combs__idecode__memory_read_unsigned;
    reg [1:0]decexec_combs__idecode__memory_width;
    reg decexec_combs__idecode__illegal;
    reg decexec_combs__idecode__is_compressed;
    reg decexec_combs__idecode__ext__dummy;
    reg [31:0]decexec_combs__rs1;
    reg [31:0]decexec_combs__rs2;
    reg [31:0]decexec_combs__next_pc;
    reg [1:0]decexec_combs__word_offset;
    reg decexec_combs__branch_taken;
    reg [2:0]decexec_combs__csr_access__access;
    reg [11:0]decexec_combs__csr_access__address;

    //b Internal nets
    wire [31:0]csr_data__read_data;
    wire csr_data__take_interrupt;
    wire [2:0]csr_data__interrupt_mode;
    wire [3:0]csr_data__interrupt_cause;
    wire csr_data__illegal_access;
    wire [31:0]decexec_alu_result__result;
    wire [31:0]decexec_alu_result__arith_result;
    wire decexec_alu_result__branch_condition_met;
    wire [31:0]decexec_alu_result__branch_target;
    wire [2:0]decexec_alu_result__csr_access__access;
    wire [11:0]decexec_alu_result__csr_access__address;
    wire [4:0]decexec_idecode_i32c__rs1;
    wire decexec_idecode_i32c__rs1_valid;
    wire [4:0]decexec_idecode_i32c__rs2;
    wire decexec_idecode_i32c__rs2_valid;
    wire [4:0]decexec_idecode_i32c__rd;
    wire decexec_idecode_i32c__rd_written;
    wire [2:0]decexec_idecode_i32c__csr_access__access;
    wire [11:0]decexec_idecode_i32c__csr_access__address;
    wire [31:0]decexec_idecode_i32c__immediate;
    wire [4:0]decexec_idecode_i32c__immediate_shift;
    wire decexec_idecode_i32c__immediate_valid;
    wire [3:0]decexec_idecode_i32c__op;
    wire [3:0]decexec_idecode_i32c__subop;
    wire decexec_idecode_i32c__requires_machine_mode;
    wire decexec_idecode_i32c__memory_read_unsigned;
    wire [1:0]decexec_idecode_i32c__memory_width;
    wire decexec_idecode_i32c__illegal;
    wire decexec_idecode_i32c__is_compressed;
    wire decexec_idecode_i32c__ext__dummy;
    wire [4:0]decexec_idecode_i32__rs1;
    wire decexec_idecode_i32__rs1_valid;
    wire [4:0]decexec_idecode_i32__rs2;
    wire decexec_idecode_i32__rs2_valid;
    wire [4:0]decexec_idecode_i32__rd;
    wire decexec_idecode_i32__rd_written;
    wire [2:0]decexec_idecode_i32__csr_access__access;
    wire [11:0]decexec_idecode_i32__csr_access__address;
    wire [31:0]decexec_idecode_i32__immediate;
    wire [4:0]decexec_idecode_i32__immediate_shift;
    wire decexec_idecode_i32__immediate_valid;
    wire [3:0]decexec_idecode_i32__op;
    wire [3:0]decexec_idecode_i32__subop;
    wire decexec_idecode_i32__requires_machine_mode;
    wire decexec_idecode_i32__memory_read_unsigned;
    wire [1:0]decexec_idecode_i32__memory_width;
    wire decexec_idecode_i32__illegal;
    wire decexec_idecode_i32__is_compressed;
    wire decexec_idecode_i32__ext__dummy;

    //b Clock gating module instances
    //b Module instances
    riscv_i32_decode decode_i32(
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .instruction__data(decexec_state__instruction__data),
        .instruction__mode(decexec_state__instruction__mode),
        .idecode__ext__dummy(            decexec_idecode_i32__ext__dummy),
        .idecode__is_compressed(            decexec_idecode_i32__is_compressed),
        .idecode__illegal(            decexec_idecode_i32__illegal),
        .idecode__memory_width(            decexec_idecode_i32__memory_width),
        .idecode__memory_read_unsigned(            decexec_idecode_i32__memory_read_unsigned),
        .idecode__requires_machine_mode(            decexec_idecode_i32__requires_machine_mode),
        .idecode__subop(            decexec_idecode_i32__subop),
        .idecode__op(            decexec_idecode_i32__op),
        .idecode__immediate_valid(            decexec_idecode_i32__immediate_valid),
        .idecode__immediate_shift(            decexec_idecode_i32__immediate_shift),
        .idecode__immediate(            decexec_idecode_i32__immediate),
        .idecode__csr_access__address(            decexec_idecode_i32__csr_access__address),
        .idecode__csr_access__access(            decexec_idecode_i32__csr_access__access),
        .idecode__rd_written(            decexec_idecode_i32__rd_written),
        .idecode__rd(            decexec_idecode_i32__rd),
        .idecode__rs2_valid(            decexec_idecode_i32__rs2_valid),
        .idecode__rs2(            decexec_idecode_i32__rs2),
        .idecode__rs1_valid(            decexec_idecode_i32__rs1_valid),
        .idecode__rs1(            decexec_idecode_i32__rs1)         );
    riscv_i32c_decode decode_i32c(
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .instruction__data(decexec_state__instruction__data),
        .instruction__mode(decexec_state__instruction__mode),
        .idecode__ext__dummy(            decexec_idecode_i32c__ext__dummy),
        .idecode__is_compressed(            decexec_idecode_i32c__is_compressed),
        .idecode__illegal(            decexec_idecode_i32c__illegal),
        .idecode__memory_width(            decexec_idecode_i32c__memory_width),
        .idecode__memory_read_unsigned(            decexec_idecode_i32c__memory_read_unsigned),
        .idecode__requires_machine_mode(            decexec_idecode_i32c__requires_machine_mode),
        .idecode__subop(            decexec_idecode_i32c__subop),
        .idecode__op(            decexec_idecode_i32c__op),
        .idecode__immediate_valid(            decexec_idecode_i32c__immediate_valid),
        .idecode__immediate_shift(            decexec_idecode_i32c__immediate_shift),
        .idecode__immediate(            decexec_idecode_i32c__immediate),
        .idecode__csr_access__address(            decexec_idecode_i32c__csr_access__address),
        .idecode__csr_access__access(            decexec_idecode_i32c__csr_access__access),
        .idecode__rd_written(            decexec_idecode_i32c__rd_written),
        .idecode__rd(            decexec_idecode_i32c__rd),
        .idecode__rs2_valid(            decexec_idecode_i32c__rs2_valid),
        .idecode__rs2(            decexec_idecode_i32c__rs2),
        .idecode__rs1_valid(            decexec_idecode_i32c__rs1_valid),
        .idecode__rs1(            decexec_idecode_i32c__rs1)         );
    riscv_i32_alu alu(
        .rs2(decexec_combs__rs2),
        .rs1(decexec_combs__rs1),
        .pc(decexec_state__pc),
        .idecode__ext__dummy(decexec_combs__idecode__ext__dummy),
        .idecode__is_compressed(decexec_combs__idecode__is_compressed),
        .idecode__illegal(decexec_combs__idecode__illegal),
        .idecode__memory_width(decexec_combs__idecode__memory_width),
        .idecode__memory_read_unsigned(decexec_combs__idecode__memory_read_unsigned),
        .idecode__requires_machine_mode(decexec_combs__idecode__requires_machine_mode),
        .idecode__subop(decexec_combs__idecode__subop),
        .idecode__op(decexec_combs__idecode__op),
        .idecode__immediate_valid(decexec_combs__idecode__immediate_valid),
        .idecode__immediate_shift(decexec_combs__idecode__immediate_shift),
        .idecode__immediate(decexec_combs__idecode__immediate),
        .idecode__csr_access__address(decexec_combs__idecode__csr_access__address),
        .idecode__csr_access__access(decexec_combs__idecode__csr_access__access),
        .idecode__rd_written(decexec_combs__idecode__rd_written),
        .idecode__rd(decexec_combs__idecode__rd),
        .idecode__rs2_valid(decexec_combs__idecode__rs2_valid),
        .idecode__rs2(decexec_combs__idecode__rs2),
        .idecode__rs1_valid(decexec_combs__idecode__rs1_valid),
        .idecode__rs1(decexec_combs__idecode__rs1),
        .alu_result__csr_access__address(            decexec_alu_result__csr_access__address),
        .alu_result__csr_access__access(            decexec_alu_result__csr_access__access),
        .alu_result__branch_target(            decexec_alu_result__branch_target),
        .alu_result__branch_condition_met(            decexec_alu_result__branch_condition_met),
        .alu_result__arith_result(            decexec_alu_result__arith_result),
        .alu_result__result(            decexec_alu_result__result)         );
    riscv_csrs_minimal csrs(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_controls__trap_value(csr_controls__trap_value),
        .csr_controls__trap_pc(csr_controls__trap_pc),
        .csr_controls__trap_cause(csr_controls__trap_cause),
        .csr_controls__trap(csr_controls__trap),
        .csr_controls__interrupt(csr_controls__interrupt),
        .csr_controls__timer_value(csr_controls__timer_value),
        .csr_controls__timer_load(csr_controls__timer_load),
        .csr_controls__timer_clear(csr_controls__timer_clear),
        .csr_controls__timer_inc(csr_controls__timer_inc),
        .csr_controls__retire(csr_controls__retire),
        .csr_controls__exec_mode(csr_controls__exec_mode),
        .csr_access__address(decexec_combs__csr_access__address),
        .csr_access__access(decexec_combs__csr_access__access),
        .irqs__time(irqs__time),
        .irqs__msip(irqs__msip),
        .irqs__mtip(irqs__mtip),
        .irqs__ueip(irqs__ueip),
        .irqs__seip(irqs__seip),
        .irqs__meip(irqs__meip),
        .irqs__nmi(irqs__nmi),
        .reset_n(reset_n),
        .csr_data__illegal_access(            csr_data__illegal_access),
        .csr_data__interrupt_cause(            csr_data__interrupt_cause),
        .csr_data__interrupt_mode(            csr_data__interrupt_mode),
        .csr_data__take_interrupt(            csr_data__take_interrupt),
        .csr_data__read_data(            csr_data__read_data)         );
    //b instruction_fetch_stage combinatorial process
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
    always @ ( * )//instruction_fetch_stage
    begin: instruction_fetch_stage__comb_code
    reg ifetch_req__valid__var;
    reg [31:0]ifetch_req__address__var;
        ifetch_req__valid__var = 1'h0;
        ifetch_req__address__var = 32'h0;
        ifetch_req__sequential = 1'h0;
        ifetch_req__mode = 3'h0;
        ifetch_req__flush = 1'h0;
        ifetch_req__valid__var = 1'h1;
        ifetch_req__address__var = decexec_combs__next_pc;
        if (!(decexec_state__valid!=1'h0))
        begin
            ifetch_req__address__var = decexec_state__pc;
        end //if
        ifetch_req__valid = ifetch_req__valid__var;
        ifetch_req__address = ifetch_req__address__var;
    end //always

    //b decode_rfr_execute_stage__comb combinatorial process
    always @ ( * )//decode_rfr_execute_stage__comb
    begin: decode_rfr_execute_stage__comb_code
    reg [4:0]decexec_combs__idecode__rs1__var;
    reg decexec_combs__idecode__rs1_valid__var;
    reg [4:0]decexec_combs__idecode__rs2__var;
    reg decexec_combs__idecode__rs2_valid__var;
    reg [4:0]decexec_combs__idecode__rd__var;
    reg decexec_combs__idecode__rd_written__var;
    reg [2:0]decexec_combs__idecode__csr_access__access__var;
    reg [11:0]decexec_combs__idecode__csr_access__address__var;
    reg [31:0]decexec_combs__idecode__immediate__var;
    reg [4:0]decexec_combs__idecode__immediate_shift__var;
    reg decexec_combs__idecode__immediate_valid__var;
    reg [3:0]decexec_combs__idecode__op__var;
    reg [3:0]decexec_combs__idecode__subop__var;
    reg decexec_combs__idecode__requires_machine_mode__var;
    reg decexec_combs__idecode__memory_read_unsigned__var;
    reg [1:0]decexec_combs__idecode__memory_width__var;
    reg decexec_combs__idecode__illegal__var;
    reg decexec_combs__idecode__is_compressed__var;
    reg decexec_combs__idecode__ext__dummy__var;
    reg [31:0]decexec_combs__rs1__var;
    reg [31:0]decexec_combs__rs2__var;
    reg csr_controls__retire__var;
    reg csr_controls__timer_inc__var;
    reg [2:0]decexec_combs__csr_access__access__var;
    reg [3:0]dmem_access_req__byte_enable__var;
    reg decexec_combs__branch_taken__var;
    reg [31:0]decexec_combs__next_pc__var;
        decexec_combs__idecode__rs1__var = decexec_idecode_i32__rs1;
        decexec_combs__idecode__rs1_valid__var = decexec_idecode_i32__rs1_valid;
        decexec_combs__idecode__rs2__var = decexec_idecode_i32__rs2;
        decexec_combs__idecode__rs2_valid__var = decexec_idecode_i32__rs2_valid;
        decexec_combs__idecode__rd__var = decexec_idecode_i32__rd;
        decexec_combs__idecode__rd_written__var = decexec_idecode_i32__rd_written;
        decexec_combs__idecode__csr_access__access__var = decexec_idecode_i32__csr_access__access;
        decexec_combs__idecode__csr_access__address__var = decexec_idecode_i32__csr_access__address;
        decexec_combs__idecode__immediate__var = decexec_idecode_i32__immediate;
        decexec_combs__idecode__immediate_shift__var = decexec_idecode_i32__immediate_shift;
        decexec_combs__idecode__immediate_valid__var = decexec_idecode_i32__immediate_valid;
        decexec_combs__idecode__op__var = decexec_idecode_i32__op;
        decexec_combs__idecode__subop__var = decexec_idecode_i32__subop;
        decexec_combs__idecode__requires_machine_mode__var = decexec_idecode_i32__requires_machine_mode;
        decexec_combs__idecode__memory_read_unsigned__var = decexec_idecode_i32__memory_read_unsigned;
        decexec_combs__idecode__memory_width__var = decexec_idecode_i32__memory_width;
        decexec_combs__idecode__illegal__var = decexec_idecode_i32__illegal;
        decexec_combs__idecode__is_compressed__var = decexec_idecode_i32__is_compressed;
        decexec_combs__idecode__ext__dummy__var = decexec_idecode_i32__ext__dummy;
        if ((1'h1&&(riscv_config__i32c!=1'h0)))
        begin
            if ((decexec_state__instruction__data[1:0]!=2'h3))
            begin
                decexec_combs__idecode__rs1__var = decexec_idecode_i32c__rs1;
                decexec_combs__idecode__rs1_valid__var = decexec_idecode_i32c__rs1_valid;
                decexec_combs__idecode__rs2__var = decexec_idecode_i32c__rs2;
                decexec_combs__idecode__rs2_valid__var = decexec_idecode_i32c__rs2_valid;
                decexec_combs__idecode__rd__var = decexec_idecode_i32c__rd;
                decexec_combs__idecode__rd_written__var = decexec_idecode_i32c__rd_written;
                decexec_combs__idecode__csr_access__access__var = decexec_idecode_i32c__csr_access__access;
                decexec_combs__idecode__csr_access__address__var = decexec_idecode_i32c__csr_access__address;
                decexec_combs__idecode__immediate__var = decexec_idecode_i32c__immediate;
                decexec_combs__idecode__immediate_shift__var = decexec_idecode_i32c__immediate_shift;
                decexec_combs__idecode__immediate_valid__var = decexec_idecode_i32c__immediate_valid;
                decexec_combs__idecode__op__var = decexec_idecode_i32c__op;
                decexec_combs__idecode__subop__var = decexec_idecode_i32c__subop;
                decexec_combs__idecode__requires_machine_mode__var = decexec_idecode_i32c__requires_machine_mode;
                decexec_combs__idecode__memory_read_unsigned__var = decexec_idecode_i32c__memory_read_unsigned;
                decexec_combs__idecode__memory_width__var = decexec_idecode_i32c__memory_width;
                decexec_combs__idecode__illegal__var = decexec_idecode_i32c__illegal;
                decexec_combs__idecode__is_compressed__var = decexec_idecode_i32c__is_compressed;
                decexec_combs__idecode__ext__dummy__var = decexec_idecode_i32c__ext__dummy;
            end //if
        end //if
        decexec_combs__rs1__var = registers[decexec_combs__idecode__rs1__var];
        decexec_combs__rs2__var = registers[decexec_combs__idecode__rs2__var];
        if (((rfw_state__valid!=1'h0)&&(rfw_state__idecode__rd_written!=1'h0)))
        begin
            if ((decexec_combs__idecode__rs1__var==rfw_state__idecode__rd))
            begin
                decexec_combs__rs1__var = rfw_combs__write_data;
            end //if
            if ((decexec_combs__idecode__rs2__var==rfw_state__idecode__rd))
            begin
                decexec_combs__rs2__var = rfw_combs__write_data;
            end //if
        end //if
        csr_controls__exec_mode = 3'h0;
        csr_controls__retire__var = 1'h0;
        csr_controls__timer_inc__var = 1'h0;
        csr_controls__timer_clear = 1'h0;
        csr_controls__timer_load = 1'h0;
        csr_controls__timer_value = 64'h0;
        csr_controls__interrupt = 1'h0;
        csr_controls__trap = 1'h0;
        csr_controls__trap_cause = 4'h0;
        csr_controls__trap_pc = 32'h0;
        csr_controls__trap_value = 32'h0;
        csr_controls__retire__var = decexec_state__valid;
        csr_controls__timer_inc__var = 1'h1;
        decexec_combs__csr_access__access__var = decexec_combs__idecode__csr_access__access__var;
        decexec_combs__csr_access__address = decexec_combs__idecode__csr_access__address__var;
        if ((!(decexec_state__valid!=1'h0)||(decexec_combs__idecode__illegal__var!=1'h0)))
        begin
            decexec_combs__csr_access__access__var = 3'h0;
        end //if
        dmem_access_req__read_enable = (decexec_combs__idecode__op__var==4'h6);
        dmem_access_req__write_enable = (decexec_combs__idecode__op__var==4'h7);
        dmem_access_req__address = decexec_alu_result__arith_result;
        decexec_combs__word_offset = decexec_alu_result__arith_result[1:0];
        dmem_access_req__byte_enable__var = (4'hf<<decexec_combs__word_offset);
        case (decexec_combs__idecode__memory_width__var) //synopsys parallel_case
        2'h0: // req 1
            begin
            dmem_access_req__byte_enable__var = (4'h1<<decexec_combs__word_offset);
            end
        2'h1: // req 1
            begin
            dmem_access_req__byte_enable__var = (4'h3<<decexec_combs__word_offset);
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
        dmem_access_req__write_data = (decexec_combs__rs2__var<<{decexec_combs__word_offset,3'h0});
        decexec_combs__branch_taken__var = 1'h0;
        case (decexec_combs__idecode__op__var) //synopsys parallel_case
        4'h0: // req 1
            begin
            decexec_combs__branch_taken__var = decexec_alu_result__branch_condition_met;
            end
        4'h1: // req 1
            begin
            decexec_combs__branch_taken__var = 1'h1;
            end
        4'h2: // req 1
            begin
            decexec_combs__branch_taken__var = 1'h1;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:riscv_i32c_pipeline2:decode_rfr_execute_stage: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        decexec_combs__next_pc__var = (decexec_state__pc+32'h4);
        if ((decexec_combs__branch_taken__var!=1'h0))
        begin
            decexec_combs__next_pc__var = decexec_alu_result__branch_target;
        end //if
        decexec_combs__idecode__rs1 = decexec_combs__idecode__rs1__var;
        decexec_combs__idecode__rs1_valid = decexec_combs__idecode__rs1_valid__var;
        decexec_combs__idecode__rs2 = decexec_combs__idecode__rs2__var;
        decexec_combs__idecode__rs2_valid = decexec_combs__idecode__rs2_valid__var;
        decexec_combs__idecode__rd = decexec_combs__idecode__rd__var;
        decexec_combs__idecode__rd_written = decexec_combs__idecode__rd_written__var;
        decexec_combs__idecode__csr_access__access = decexec_combs__idecode__csr_access__access__var;
        decexec_combs__idecode__csr_access__address = decexec_combs__idecode__csr_access__address__var;
        decexec_combs__idecode__immediate = decexec_combs__idecode__immediate__var;
        decexec_combs__idecode__immediate_shift = decexec_combs__idecode__immediate_shift__var;
        decexec_combs__idecode__immediate_valid = decexec_combs__idecode__immediate_valid__var;
        decexec_combs__idecode__op = decexec_combs__idecode__op__var;
        decexec_combs__idecode__subop = decexec_combs__idecode__subop__var;
        decexec_combs__idecode__requires_machine_mode = decexec_combs__idecode__requires_machine_mode__var;
        decexec_combs__idecode__memory_read_unsigned = decexec_combs__idecode__memory_read_unsigned__var;
        decexec_combs__idecode__memory_width = decexec_combs__idecode__memory_width__var;
        decexec_combs__idecode__illegal = decexec_combs__idecode__illegal__var;
        decexec_combs__idecode__is_compressed = decexec_combs__idecode__is_compressed__var;
        decexec_combs__idecode__ext__dummy = decexec_combs__idecode__ext__dummy__var;
        decexec_combs__rs1 = decexec_combs__rs1__var;
        decexec_combs__rs2 = decexec_combs__rs2__var;
        csr_controls__retire = csr_controls__retire__var;
        csr_controls__timer_inc = csr_controls__timer_inc__var;
        decexec_combs__csr_access__access = decexec_combs__csr_access__access__var;
        dmem_access_req__byte_enable = dmem_access_req__byte_enable__var;
        decexec_combs__branch_taken = decexec_combs__branch_taken__var;
        decexec_combs__next_pc = decexec_combs__next_pc__var;
    end //always

    //b decode_rfr_execute_stage__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : decode_rfr_execute_stage__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            decexec_state__valid <= 1'h0;
            decexec_state__instruction__data <= 32'h0;
            decexec_state__instruction__mode <= 3'h0;
            decexec_state__pc <= 32'h0;
            decexec_state__pc <= 32'h0;
        end
        else if (clk__enable)
        begin
            decexec_state__valid <= 1'h0;
            if (((ifetch_req__valid!=1'h0)&&(ifetch_resp__valid!=1'h0)))
            begin
                decexec_state__valid <= 1'h1;
                decexec_state__instruction__data <= ifetch_resp__data;
                decexec_state__instruction__mode <= 3'h3;
            end //if
            if ((decexec_state__valid!=1'h0))
            begin
                decexec_state__pc <= decexec_combs__next_pc;
            end //if
        end //if
    end //always

    //b rfw_stage__comb combinatorial process
    always @ ( * )//rfw_stage__comb
    begin: rfw_stage__comb_code
    reg [31:0]rfw_combs__memory_data__var;
        rfw_combs__memory_data__var = dmem_access_resp__read_data;
        case (rfw_state__idecode__memory_width) //synopsys parallel_case
        2'h0: // req 1
            begin
            rfw_combs__memory_data__var = ((dmem_access_resp__read_data>>{rfw_state__word_offset,3'h0}) & 32'hff);
            if ((!(rfw_state__idecode__memory_read_unsigned!=1'h0)&&(rfw_combs__memory_data__var[7]!=1'h0)))
            begin
                rfw_combs__memory_data__var[31:8] = 24'hffffff;
            end //if
            end
        2'h1: // req 1
            begin
            rfw_combs__memory_data__var = ((dmem_access_resp__read_data>>{rfw_state__word_offset,3'h0}) & 32'hffff);
            if ((!(rfw_state__idecode__memory_read_unsigned!=1'h0)&&(rfw_combs__memory_data__var[15]!=1'h0)))
            begin
                rfw_combs__memory_data__var[31:16] = 16'hffff;
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
        rfw_combs__write_data = ((rfw_state__memory_read!=1'h0)?rfw_combs__memory_data__var:rfw_state__result);
        rfw_combs__memory_data = rfw_combs__memory_data__var;
    end //always

    //b rfw_stage__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : rfw_stage__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            rfw_state__valid <= 1'h0;
            rfw_state__idecode__rs1 <= 5'h0;
            rfw_state__idecode__rs1_valid <= 1'h0;
            rfw_state__idecode__rs2 <= 5'h0;
            rfw_state__idecode__rs2_valid <= 1'h0;
            rfw_state__idecode__rd <= 5'h0;
            rfw_state__idecode__rd_written <= 1'h0;
            rfw_state__idecode__csr_access__access <= 3'h0;
            rfw_state__idecode__csr_access__address <= 12'h0;
            rfw_state__idecode__immediate <= 32'h0;
            rfw_state__idecode__immediate_shift <= 5'h0;
            rfw_state__idecode__immediate_valid <= 1'h0;
            rfw_state__idecode__op <= 4'h0;
            rfw_state__idecode__subop <= 4'h0;
            rfw_state__idecode__requires_machine_mode <= 1'h0;
            rfw_state__idecode__memory_read_unsigned <= 1'h0;
            rfw_state__idecode__memory_width <= 2'h0;
            rfw_state__idecode__illegal <= 1'h0;
            rfw_state__idecode__is_compressed <= 1'h0;
            rfw_state__idecode__ext__dummy <= 1'h0;
            rfw_state__memory_read <= 1'h0;
            rfw_state__word_offset <= 2'h0;
            rfw_state__result <= 32'h0;
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
            rfw_state__valid <= 1'h0;
            if ((decexec_state__valid!=1'h0))
            begin
                rfw_state__valid <= 1'h1;
                rfw_state__idecode__rs1 <= decexec_combs__idecode__rs1;
                rfw_state__idecode__rs1_valid <= decexec_combs__idecode__rs1_valid;
                rfw_state__idecode__rs2 <= decexec_combs__idecode__rs2;
                rfw_state__idecode__rs2_valid <= decexec_combs__idecode__rs2_valid;
                rfw_state__idecode__rd <= decexec_combs__idecode__rd;
                rfw_state__idecode__rd_written <= decexec_combs__idecode__rd_written;
                rfw_state__idecode__csr_access__access <= decexec_combs__idecode__csr_access__access;
                rfw_state__idecode__csr_access__address <= decexec_combs__idecode__csr_access__address;
                rfw_state__idecode__immediate <= decexec_combs__idecode__immediate;
                rfw_state__idecode__immediate_shift <= decexec_combs__idecode__immediate_shift;
                rfw_state__idecode__immediate_valid <= decexec_combs__idecode__immediate_valid;
                rfw_state__idecode__op <= decexec_combs__idecode__op;
                rfw_state__idecode__subop <= decexec_combs__idecode__subop;
                rfw_state__idecode__requires_machine_mode <= decexec_combs__idecode__requires_machine_mode;
                rfw_state__idecode__memory_read_unsigned <= decexec_combs__idecode__memory_read_unsigned;
                rfw_state__idecode__memory_width <= decexec_combs__idecode__memory_width;
                rfw_state__idecode__illegal <= decexec_combs__idecode__illegal;
                rfw_state__idecode__is_compressed <= decexec_combs__idecode__is_compressed;
                rfw_state__idecode__ext__dummy <= decexec_combs__idecode__ext__dummy;
                if ((decexec_combs__idecode__rd==5'h0))
                begin
                    rfw_state__idecode__rd_written <= 1'h0;
                end //if
                rfw_state__memory_read <= (decexec_combs__idecode__op==4'h6);
                rfw_state__word_offset <= decexec_combs__word_offset;
                rfw_state__result <= decexec_alu_result__result;
                if ((decexec_combs__idecode__csr_access__access!=3'h0))
                begin
                    rfw_state__result <= csr_data__read_data;
                end //if
            end //if
            if (((rfw_state__valid!=1'h0)&&(rfw_state__idecode__rd_written!=1'h0)))
            begin
                registers[rfw_state__idecode__rd] <= rfw_combs__write_data;
            end //if
            registers[0] <= 32'h0;
        end //if
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
        trace__instr_valid__var = decexec_state__valid;
        trace__instr_pc__var = decexec_state__pc;
        trace__instruction__mode__var = decexec_state__instruction__mode;
        trace__instruction__data__var = decexec_state__instruction__data;
        trace__rfw_retire__var = rfw_state__valid;
        trace__rfw_data_valid__var = rfw_state__idecode__rd_written;
        trace__rfw_rd__var = rfw_state__idecode__rd;
        trace__rfw_data__var = rfw_combs__write_data;
        trace__branch_taken__var = decexec_combs__branch_taken;
        trace__trap__var = 1'h0;
        trace__branch_target__var = decexec_alu_result__branch_target;
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

endmodule // riscv_i32c_pipeline2
