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

//a Module riscv_i32c_minimal
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
module riscv_i32c_minimal
(
    clk,
    clk__enable,

    imem_access_resp__wait,
    imem_access_resp__read_data,
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
    input imem_access_resp__wait;
    input [31:0]imem_access_resp__read_data;
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
    reg [31:0]imem_access_req__address;
    reg [3:0]imem_access_req__byte_enable;
    reg imem_access_req__write_enable;
    reg imem_access_req__read_enable;
    reg [31:0]imem_access_req__write_data;
    reg [31:0]dmem_access_req__address;
    reg [3:0]dmem_access_req__byte_enable;
    reg dmem_access_req__write_enable;
    reg dmem_access_req__read_enable;
    reg [31:0]dmem_access_req__write_data;

    //b Output nets

    //b Internal and output registers
    reg [31:0]decexecrfw_state__instr_data;
    reg decexecrfw_state__valid;
    reg decexecrfw_state__valid_legal;
    reg decexecrfw_state__illegal_pc;
    reg [31:0]decexecrfw_state__pc;
    reg ifetch_state__enable;
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
    reg [31:0]decexecrfw_combs__rs1;
    reg [31:0]decexecrfw_combs__rs2;
    reg [31:0]decexecrfw_combs__next_pc;
    reg [1:0]decexecrfw_combs__word_offset;
    reg [31:0]decexecrfw_combs__branch_target;
    reg decexecrfw_combs__branch_taken;
    reg decexecrfw_combs__trap;
    reg [3:0]decexecrfw_combs__trap_cause;
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

    //b Clock gating module instances
    //b Module instances
    riscv_i32_decode decode_i32(
        .instruction(decexecrfw_state__instr_data),
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
        .instruction(decexecrfw_state__instr_data),
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
    //b instruction_fetch_stage__comb combinatorial process
        //   
        //       The instruction fetch stage derives a request from the
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
    always @ ( * )//instruction_fetch_stage__comb
    begin: instruction_fetch_stage__comb_code
    reg [31:0]imem_access_req__address__var;
    reg imem_access_req__read_enable__var;
    reg [31:0]ifetch_combs__address__var;
        imem_access_req__address__var = 32'h0;
        imem_access_req__byte_enable = 4'h0;
        imem_access_req__write_enable = 1'h0;
        imem_access_req__read_enable__var = 1'h0;
        imem_access_req__write_data = 32'h0;
        ifetch_combs__address__var = decexecrfw_combs__next_pc;
        if ((!(decexecrfw_state__valid!=1'h0)&&(ifetch_state__enable!=1'h0)))
        begin
            ifetch_combs__address__var = decexecrfw_state__pc;
        end //if
        ifetch_combs__request = ifetch_state__enable;
        imem_access_req__read_enable__var = ifetch_combs__request;
        imem_access_req__address__var = ifetch_combs__address__var;
        imem_access_req__address = imem_access_req__address__var;
        imem_access_req__read_enable = imem_access_req__read_enable__var;
        ifetch_combs__address = ifetch_combs__address__var;
    end //always

    //b instruction_fetch_stage__posedge_clk_active_low_reset_n clock process
        //   
        //       The instruction fetch stage derives a request from the
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
    always @( posedge clk or negedge reset_n)
    begin : instruction_fetch_stage__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            ifetch_state__enable <= 1'h0;
        end
        else if (clk__enable)
        begin
            ifetch_state__enable <= 1'h1;
        end //if
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
    reg csr_controls__retire__var;
    reg csr_controls__timer_inc__var;
    reg csr_controls__trap__var;
    reg [3:0]csr_controls__trap_cause__var;
    reg [2:0]decexecrfw_combs__csr_access__access__var;
    reg dmem_access_req__read_enable__var;
    reg dmem_access_req__write_enable__var;
    reg decexecrfw_combs__dmem_misaligned__var;
    reg [3:0]dmem_access_req__byte_enable__var;
    reg decexecrfw_combs__load_address_misaligned__var;
    reg decexecrfw_combs__store_address_misaligned__var;
    reg decexecrfw_combs__trap__var;
    reg [3:0]decexecrfw_combs__trap_cause__var;
    reg decexecrfw_combs__branch_taken__var;
    reg [31:0]decexecrfw_combs__branch_target__var;
    reg [31:0]decexecrfw_combs__next_pc__var;
    reg [31:0]decexecrfw_combs__memory_data__var;
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
        if ((decexecrfw_state__instr_data[1:0]==2'h3))
        begin
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
        csr_controls__trap_pc = 32'h0;
        csr_controls__trap_value = 32'h0;
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
        end //if
        decexecrfw_combs__next_pc__var = (decexecrfw_state__pc+32'h4);
        if ((decexecrfw_combs__branch_taken__var!=1'h0))
        begin
            decexecrfw_combs__next_pc__var = decexecrfw_combs__branch_target__var;
        end //if
        if ((decexecrfw_combs__trap__var!=1'h0))
        begin
            decexecrfw_combs__next_pc__var = csrs__mtvec;
        end //if
        csr_controls__trap_cause__var = decexecrfw_combs__trap_cause__var;
        csr_controls__trap__var = 1'h0;
        if ((decexecrfw_combs__trap__var!=1'h0))
        begin
            csr_controls__trap__var = decexecrfw_state__valid_legal;
        end //if
        if ((decexecrfw_state__illegal_pc!=1'h0))
        begin
            csr_controls__trap_cause__var = 4'h0;
            csr_controls__trap__var = 1'h1;
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
        decexecrfw_combs__rfw_write_data = ((dmem_access_req__read_enable__var!=1'h0)?decexecrfw_combs__memory_data__var:decexecrfw_alu_result__result);
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
        csr_controls__retire = csr_controls__retire__var;
        csr_controls__timer_inc = csr_controls__timer_inc__var;
        csr_controls__trap = csr_controls__trap__var;
        csr_controls__trap_cause = csr_controls__trap_cause__var;
        decexecrfw_combs__csr_access__access = decexecrfw_combs__csr_access__access__var;
        dmem_access_req__read_enable = dmem_access_req__read_enable__var;
        dmem_access_req__write_enable = dmem_access_req__write_enable__var;
        decexecrfw_combs__dmem_misaligned = decexecrfw_combs__dmem_misaligned__var;
        dmem_access_req__byte_enable = dmem_access_req__byte_enable__var;
        decexecrfw_combs__load_address_misaligned = decexecrfw_combs__load_address_misaligned__var;
        decexecrfw_combs__store_address_misaligned = decexecrfw_combs__store_address_misaligned__var;
        decexecrfw_combs__trap = decexecrfw_combs__trap__var;
        decexecrfw_combs__trap_cause = decexecrfw_combs__trap_cause__var;
        decexecrfw_combs__branch_taken = decexecrfw_combs__branch_taken__var;
        decexecrfw_combs__branch_target = decexecrfw_combs__branch_target__var;
        decexecrfw_combs__next_pc = decexecrfw_combs__next_pc__var;
        decexecrfw_combs__memory_data = decexecrfw_combs__memory_data__var;
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
            decexecrfw_state__instr_data <= 32'h0;
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
            decexecrfw_state__valid <= 1'h0;
            if (((imem_access_req__read_enable!=1'h0)&&!(imem_access_resp__wait!=1'h0)))
            begin
                decexecrfw_state__instr_data <= imem_access_resp__read_data;
                decexecrfw_state__illegal_pc <= 1'h0;
                decexecrfw_state__valid_legal <= 1'h1;
                decexecrfw_state__valid <= 1'h1;
            end //if
            if ((decexecrfw_state__valid!=1'h0))
            begin
                decexecrfw_state__pc <= decexecrfw_combs__next_pc;
            end //if
            if (((decexecrfw_state__valid_legal!=1'h0)&&(decexecrfw_combs__idecode__rd_written!=1'h0)))
            begin
                registers[decexecrfw_combs__idecode__rd] <= decexecrfw_combs__rfw_write_data;
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
    reg [31:0]trace__instr_data__var;
    reg trace__rfw_data_valid__var;
    reg [31:0]trace__rfw_data__var;
    reg trace__branch_taken__var;
    reg [31:0]trace__branch_target__var;
    reg trace__trap__var;
        trace__instr_valid__var = 1'h0;
        trace__instr_pc__var = 32'h0;
        trace__instr_data__var = 32'h0;
        trace__rfw_retire = 1'h0;
        trace__rfw_data_valid__var = 1'h0;
        trace__rfw_rd = 5'h0;
        trace__rfw_data__var = 32'h0;
        trace__branch_taken__var = 1'h0;
        trace__branch_target__var = 32'h0;
        trace__trap__var = 1'h0;
        trace__instr_valid__var = decexecrfw_state__valid;
        trace__instr_pc__var = decexecrfw_state__pc;
        trace__instr_data__var = decexecrfw_state__instr_data;
        trace__rfw_data_valid__var = decexecrfw_state__valid;
        trace__rfw_data__var = decexecrfw_combs__rfw_write_data;
        trace__branch_taken__var = decexecrfw_combs__branch_taken;
        trace__trap__var = decexecrfw_combs__trap;
        trace__branch_target__var = decexecrfw_combs__branch_target;
        trace__instr_valid = trace__instr_valid__var;
        trace__instr_pc = trace__instr_pc__var;
        trace__instr_data = trace__instr_data__var;
        trace__rfw_data_valid = trace__rfw_data_valid__var;
        trace__rfw_data = trace__rfw_data__var;
        trace__branch_taken = trace__branch_taken__var;
        trace__branch_target = trace__branch_target__var;
        trace__trap = trace__trap__var;
    end //always

endmodule // riscv_i32c_minimal
