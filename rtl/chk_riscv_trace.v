module chk_riscv_trace(clk,
                       clk__enable,
                       trace__bkpt_reason,
                       trace__bkpt_valid,
                       trace__rfw_data,
                       trace__rfw_rd,
                       trace__rfw_data_valid,
                       trace__rfw_retire,
                       trace__jalr,
                       trace__ret,
                       trace__trap,
                       trace__branch_target,
                       trace__branch_taken,
                       trace__instruction,
                       trace__instr_pc,
                       trace__mode,
                       trace__instr_valid );

   
   input clk;
   input clk__enable;
   input[3:0] trace__bkpt_reason;
   input trace__bkpt_valid;
   input[31:0] trace__rfw_data;
   input[4:0] trace__rfw_rd;
   input trace__rfw_data_valid;
   input trace__rfw_retire;
   input trace__jalr;
   input trace__ret;
   input trace__trap;
   input[31:0] trace__branch_target;
   input trace__branch_taken;
   input[31:0] trace__instruction;
   input[31:0] trace__instr_pc;
   input[2:0] trace__mode;
   input trace__instr_valid;
endmodule
   
