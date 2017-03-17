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

//a Module riscv_i32_trace
    //   
    //   Trace instruction execution
    //   
module riscv_i32_trace
(
    clk,
    clk__enable,

    branch_target,
    branch_taken,
    pc,
    result,
    idecode__rs1,
    idecode__rs1_valid,
    idecode__rs2,
    idecode__rs2_valid,
    idecode__rd,
    idecode__rd_written,
    idecode__csr_access__access,
    idecode__csr_access__address,
    idecode__immediate,
    idecode__immediate_valid,
    idecode__op,
    idecode__subop,
    idecode__requires_machine_mode,
    idecode__memory_read_unsigned,
    idecode__memory_width,
    idecode__illegal,
    clk_enable,
    reset_n

);

    //b Clocks
        //   Clock for the CPU
    input clk;
    input clk__enable;
    wire trace_clk; // Gated version of clock 'clk' enabled by 'clk_enable'
    wire trace_clk__enable;

    //b Inputs
        //   Asserted if a branch is being taken
    input [31:0]branch_target;
        //   Asserted if a branch is being taken
    input branch_taken;
        //   Program counter of the instruction
    input [31:0]pc;
        //   Result of ALU/memory operation for the instruction
    input [31:0]result;
        //   Decoded instruction being traced
    input [4:0]idecode__rs1;
    input idecode__rs1_valid;
    input [4:0]idecode__rs2;
    input idecode__rs2_valid;
    input [4:0]idecode__rd;
    input idecode__rd_written;
    input [2:0]idecode__csr_access__access;
    input [11:0]idecode__csr_access__address;
    input [31:0]idecode__immediate;
    input idecode__immediate_valid;
    input [3:0]idecode__op;
    input [3:0]idecode__subop;
    input idecode__requires_machine_mode;
    input idecode__memory_read_unsigned;
    input [1:0]idecode__memory_width;
    input idecode__illegal;
        //   Active high clock enable for the tracing
    input clk_enable;
        //   Active low reset
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    assign trace_clk__enable = (clk__enable && clk_enable);
    //b Module instances
endmodule // riscv_i32_trace
