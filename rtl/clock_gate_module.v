module clock_gate_module(
                         CLK_IN, ENABLE, CLK_OUT );
   input CLK_IN, ENABLE;
   output CLK_OUT;
   reg    enable_latch;
   `ifdef CLK_GATE_USE_LATCH
   always @(CLK_IN or ENABLE)
     begin
        if (!CLK_IN)
          begin
             enable_latch = ENABLE;
          end
     end
   `else
   always @(negedge CLK_IN)
     begin
        enable_latch <= ENABLE;
     end
   `endif
   assign CLK_OUT=enable_latch&CLK_IN;
   
endmodule // clock_gate_module

