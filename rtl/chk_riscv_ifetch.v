module chk_riscv_ifetch(clk,
                       clk__enable,
                       fetch_req__mode,
                       fetch_req__address,
                       fetch_req__req_type,
                       fetch_req__flush_pipeline,
                       fetch_resp__error,
                       fetch_resp__data,
                       fetch_resp__valid
  );
   
   
   input clk;
   input clk__enable;
   input[1:0] fetch_resp__error;
   input[31:0] fetch_resp__data;
   input fetch_resp__valid;
   input[2:0] fetch_req__mode;
   input[31:0] fetch_req__address;
   input[2:0] fetch_req__req_type;
   input fetch_req__flush_pipeline;
endmodule
   
