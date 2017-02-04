`timescale 1ns/1ps
module harness_tb_6502
(
);
   reg reset_n;
   reg clk;
   initial
     begin
        clk=0;
        reset_n=0;
        #33 reset_n=1;
     end
   always begin
      #5  clk =  ! clk;
   end
   
   tb_6502 tb(.clk(clk), .reset_n(reset_n));

endmodule // harness_tb_6502

