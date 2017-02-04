module clock_gate_module(
                         CLK_IN, ENABLE, CLK_OUT );
   input CLK_IN, ENABLE;
   output CLK_OUT;
   reg    enable_latch;
   always @(CLK_IN or ENABLE)
     begin
        if (!CLK_IN)
          begin
             enable_latch = ENABLE;
          end
     end
   assign CLK_OUT=enable_latch?CLK_IN:0;
   
endmodule // clock_gate_module

