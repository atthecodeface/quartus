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

//a Module riscv_e32_decode
    //   
    //   Instruction decoder for RISC-V RV32E instruction set.
    //   
    //   This is based on the RISC-V v2.1 specification (hence figure numbers
    //   are from that specification)
    //   
module riscv_e32_decode
(

    riscv_config__i32c,
    riscv_config__e32,
    riscv_config__i32m,
    riscv_config__i32m_fuse,
    riscv_config__coproc_disable,
    riscv_config__unaligned_mem,
    instruction__mode,
    instruction__data,

    idecode__rs1,
    idecode__rs1_valid,
    idecode__rs2,
    idecode__rs2_valid,
    idecode__rd,
    idecode__rd_written,
    idecode__csr_access__access,
    idecode__csr_access__address,
    idecode__immediate,
    idecode__immediate_shift,
    idecode__immediate_valid,
    idecode__op,
    idecode__subop,
    idecode__requires_machine_mode,
    idecode__memory_read_unsigned,
    idecode__memory_width,
    idecode__illegal,
    idecode__is_compressed,
    idecode__ext__dummy
);

    //b Clocks

    //b Inputs
    input riscv_config__i32c;
    input riscv_config__e32;
    input riscv_config__i32m;
    input riscv_config__i32m_fuse;
    input riscv_config__coproc_disable;
    input riscv_config__unaligned_mem;
    input [2:0]instruction__mode;
    input [31:0]instruction__data;

    //b Outputs
    output [4:0]idecode__rs1;
    output idecode__rs1_valid;
    output [4:0]idecode__rs2;
    output idecode__rs2_valid;
    output [4:0]idecode__rd;
    output idecode__rd_written;
    output [2:0]idecode__csr_access__access;
    output [11:0]idecode__csr_access__address;
    output [31:0]idecode__immediate;
    output [4:0]idecode__immediate_shift;
    output idecode__immediate_valid;
    output [3:0]idecode__op;
    output [3:0]idecode__subop;
    output idecode__requires_machine_mode;
    output idecode__memory_read_unsigned;
    output [1:0]idecode__memory_width;
    output idecode__illegal;
    output idecode__is_compressed;
    output idecode__ext__dummy;

// output components here

    //b Output combinatorials
    reg [4:0]idecode__rs1;
    reg idecode__rs1_valid;
    reg [4:0]idecode__rs2;
    reg idecode__rs2_valid;
    reg [4:0]idecode__rd;
    reg idecode__rd_written;
    reg [2:0]idecode__csr_access__access;
    reg [11:0]idecode__csr_access__address;
    reg [31:0]idecode__immediate;
    reg [4:0]idecode__immediate_shift;
    reg idecode__immediate_valid;
    reg [3:0]idecode__op;
    reg [3:0]idecode__subop;
    reg idecode__requires_machine_mode;
    reg idecode__memory_read_unsigned;
    reg [1:0]idecode__memory_width;
    reg idecode__illegal;
    reg idecode__is_compressed;
    reg idecode__ext__dummy;

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials

    //b Internal nets
    wire [4:0]rv32i_idecode__rs1;
    wire rv32i_idecode__rs1_valid;
    wire [4:0]rv32i_idecode__rs2;
    wire rv32i_idecode__rs2_valid;
    wire [4:0]rv32i_idecode__rd;
    wire rv32i_idecode__rd_written;
    wire [2:0]rv32i_idecode__csr_access__access;
    wire [11:0]rv32i_idecode__csr_access__address;
    wire [31:0]rv32i_idecode__immediate;
    wire [4:0]rv32i_idecode__immediate_shift;
    wire rv32i_idecode__immediate_valid;
    wire [3:0]rv32i_idecode__op;
    wire [3:0]rv32i_idecode__subop;
    wire rv32i_idecode__requires_machine_mode;
    wire rv32i_idecode__memory_read_unsigned;
    wire [1:0]rv32i_idecode__memory_width;
    wire rv32i_idecode__illegal;
    wire rv32i_idecode__is_compressed;
    wire rv32i_idecode__ext__dummy;

    //b Clock gating module instances
    //b Module instances
    riscv_i32_decode rv32i_decode(
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .instruction__data(instruction__data),
        .instruction__mode(instruction__mode),
        .idecode__ext__dummy(            rv32i_idecode__ext__dummy),
        .idecode__is_compressed(            rv32i_idecode__is_compressed),
        .idecode__illegal(            rv32i_idecode__illegal),
        .idecode__memory_width(            rv32i_idecode__memory_width),
        .idecode__memory_read_unsigned(            rv32i_idecode__memory_read_unsigned),
        .idecode__requires_machine_mode(            rv32i_idecode__requires_machine_mode),
        .idecode__subop(            rv32i_idecode__subop),
        .idecode__op(            rv32i_idecode__op),
        .idecode__immediate_valid(            rv32i_idecode__immediate_valid),
        .idecode__immediate_shift(            rv32i_idecode__immediate_shift),
        .idecode__immediate(            rv32i_idecode__immediate),
        .idecode__csr_access__address(            rv32i_idecode__csr_access__address),
        .idecode__csr_access__access(            rv32i_idecode__csr_access__access),
        .idecode__rd_written(            rv32i_idecode__rd_written),
        .idecode__rd(            rv32i_idecode__rd),
        .idecode__rs2_valid(            rv32i_idecode__rs2_valid),
        .idecode__rs2(            rv32i_idecode__rs2),
        .idecode__rs1_valid(            rv32i_idecode__rs1_valid),
        .idecode__rs1(            rv32i_idecode__rs1)         );
    //b instruction_decode combinatorial process
        //   
        //       Decode the instruction
        //       
    always @ ( * )//instruction_decode
    begin: instruction_decode__comb_code
    reg idecode__illegal__var;
        idecode__rs1 = rv32i_idecode__rs1;
        idecode__rs1_valid = rv32i_idecode__rs1_valid;
        idecode__rs2 = rv32i_idecode__rs2;
        idecode__rs2_valid = rv32i_idecode__rs2_valid;
        idecode__rd = rv32i_idecode__rd;
        idecode__rd_written = rv32i_idecode__rd_written;
        idecode__csr_access__access = rv32i_idecode__csr_access__access;
        idecode__csr_access__address = rv32i_idecode__csr_access__address;
        idecode__immediate = rv32i_idecode__immediate;
        idecode__immediate_shift = rv32i_idecode__immediate_shift;
        idecode__immediate_valid = rv32i_idecode__immediate_valid;
        idecode__op = rv32i_idecode__op;
        idecode__subop = rv32i_idecode__subop;
        idecode__requires_machine_mode = rv32i_idecode__requires_machine_mode;
        idecode__memory_read_unsigned = rv32i_idecode__memory_read_unsigned;
        idecode__memory_width = rv32i_idecode__memory_width;
        idecode__illegal__var = rv32i_idecode__illegal;
        idecode__is_compressed = rv32i_idecode__is_compressed;
        idecode__ext__dummy = rv32i_idecode__ext__dummy;
        if (((rv32i_idecode__rs1_valid!=1'h0)&&(rv32i_idecode__rs1[4]!=1'h0)))
        begin
            idecode__illegal__var = 1'h1;
        end //if
        if (((rv32i_idecode__rs2_valid!=1'h0)&&(rv32i_idecode__rs2[4]!=1'h0)))
        begin
            idecode__illegal__var = 1'h1;
        end //if
        if (((rv32i_idecode__rd_written!=1'h0)&&(rv32i_idecode__rd[4]!=1'h0)))
        begin
            idecode__illegal__var = 1'h1;
        end //if
        idecode__illegal = idecode__illegal__var;
    end //always

endmodule // riscv_e32_decode
