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

//a Module riscv_minimal
    //   
    //   This processor tries to keep it as simple as possible, with a 2-stage
    //   pipeline.
    //   
    //   The first stage is instruction fetch; the instruction memory request
    //   is put out just before the middle of the cycle, and a memory (running
    //   either at 2x the clock speed, or off the negedge of the clock)
    //   presents the instruction fetched at the end of the cycle, where it is
    //   registered.
    //   
    //   The second stage takes the fetched instruction, decodes, fetches
    //   register values, and executes the ALU stage; determining in half a
    //   cycle the next instruction fetch, and in the whole cycle the data
    //   memory request, which is valid just before the end
    //   
    //   @timegraph
    //   Mem, CPU , imem_req.7 , imem_resp.9 , ifetch.0, decode.2, RF rd.5 , Exec  , dmem_req.9 , dmem_resp.9 , RFW
    //   0  , 0   ,  fetch A   ,       X     ,         ,         ,         ,       ,            ,             ,       
    //   1  , 0   ,     -      ,    inst A   ,         ,         ,         ,       ,            ,             ,       
    //   2  , 1   ,  fetch B   ,       X     ,  inst A , inst A  , inst A  , inst A, inst A     ,             ,       
    //   3  , 1   ,            ,    inst B   ,         ,         ,         ,       ,            ,  inst A     , inst A
    //   @endtimegraph
    //   
module riscv_minimal
(
    clk,
    clk__enable,

    riscv_config__i32c,
    riscv_config__e32,
    riscv_config__i32m,
    riscv_config__i32m_fuse,
    riscv_config__coproc_disable,
    riscv_config__unaligned_mem,
    imem_access_resp__wait,
    imem_access_resp__read_data,
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
    imem_access_req__address,
    imem_access_req__byte_enable,
    imem_access_req__write_enable,
    imem_access_req__read_enable,
    imem_access_req__write_data,
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
    input imem_access_resp__wait;
    input [31:0]imem_access_resp__read_data;
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
    output [31:0]imem_access_req__address;
    output [3:0]imem_access_req__byte_enable;
    output imem_access_req__write_enable;
    output imem_access_req__read_enable;
    output [31:0]imem_access_req__write_data;
    output [31:0]dmem_access_req__address;
    output [3:0]dmem_access_req__byte_enable;
    output dmem_access_req__write_enable;
    output dmem_access_req__read_enable;
    output [31:0]dmem_access_req__write_data;

// output components here

    //b Output combinatorials
    reg [31:0]imem_access_req__address;
    reg [3:0]imem_access_req__byte_enable;
    reg imem_access_req__write_enable;
    reg imem_access_req__read_enable;
    reg [31:0]imem_access_req__write_data;

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
    reg ifetch_resp__valid;
    reg ifetch_resp__debug;
    reg [31:0]ifetch_resp__data;
    reg [2:0]ifetch_resp__mode;
    reg ifetch_resp__error;
    reg [1:0]ifetch_resp__tag;

    //b Internal nets
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
    wire ifetch_req__valid;
    wire [31:0]ifetch_req__address;
    wire ifetch_req__sequential;
    wire [2:0]ifetch_req__mode;
    wire ifetch_req__flush;

    //b Clock gating module instances
    //b Module instances
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
        .ifetch_resp__tag(ifetch_resp__tag),
        .ifetch_resp__error(ifetch_resp__error),
        .ifetch_resp__mode(ifetch_resp__mode),
        .ifetch_resp__data(ifetch_resp__data),
        .ifetch_resp__debug(ifetch_resp__debug),
        .ifetch_resp__valid(ifetch_resp__valid),
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
        .ifetch_req__flush(            ifetch_req__flush),
        .ifetch_req__mode(            ifetch_req__mode),
        .ifetch_req__sequential(            ifetch_req__sequential),
        .ifetch_req__address(            ifetch_req__address),
        .ifetch_req__valid(            ifetch_req__valid)         );
    //b instruction_fetch_stage combinatorial process
    always @ ( * )//instruction_fetch_stage
    begin: instruction_fetch_stage__comb_code
    reg [31:0]imem_access_req__address__var;
    reg imem_access_req__read_enable__var;
    reg ifetch_resp__valid__var;
    reg [31:0]ifetch_resp__data__var;
        imem_access_req__address__var = 32'h0;
        imem_access_req__byte_enable = 4'h0;
        imem_access_req__write_enable = 1'h0;
        imem_access_req__read_enable__var = 1'h0;
        imem_access_req__write_data = 32'h0;
        imem_access_req__read_enable__var = ifetch_req__valid;
        imem_access_req__address__var = ifetch_req__address;
        ifetch_resp__valid__var = 1'h0;
        ifetch_resp__debug = 1'h0;
        ifetch_resp__data__var = 32'h0;
        ifetch_resp__mode = 3'h0;
        ifetch_resp__error = 1'h0;
        ifetch_resp__tag = 2'h0;
        ifetch_resp__valid__var = ((ifetch_req__valid!=1'h0)&&!(imem_access_resp__wait!=1'h0));
        ifetch_resp__data__var = imem_access_resp__read_data;
        imem_access_req__address = imem_access_req__address__var;
        imem_access_req__read_enable = imem_access_req__read_enable__var;
        ifetch_resp__valid = ifetch_resp__valid__var;
        ifetch_resp__data = ifetch_resp__data__var;
    end //always

    //b pipeline combinatorial process
    always @ ( * )//pipeline
    begin: pipeline__comb_code
        coproc_response__cannot_start = 1'h0;
        coproc_response__result = 32'h0;
        coproc_response__result_valid = 1'h0;
        coproc_response__cannot_complete = 1'h0;
    end //always

endmodule // riscv_minimal
