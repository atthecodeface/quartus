module bbc_project(clk, reset_n, leds);
   
  input clk, reset_n;
   output [7:0] leds;
   wire         host_sram_request__valid;
   wire         host_sram_request__read_enable;
   wire         host_sram_request__write_enable;
   wire[7:0]    host_sram_request__select;
   wire[23:0]   host_sram_request__address;
   wire[63:0]   host_sram_request__write_data;
   wire         csr_request__valid;
   wire         csr_request__read_not_write;
   wire[15:0]   csr_request__select;
   wire[15:0]   csr_request__address;
   wire[31:0]   csr_request__data;

   wire         display_sram_write__enable;
   wire[47:0]   display_sram_write__data;
   wire[15:0]   display_sram_write__address;
   wire         host_sram_response__ack;
   wire         host_sram_response__read_data_valid;
   wire[63:0]   host_sram_response__read_data;
   wire         csr_response__ack;
   wire         csr_response__read_data_valid;
   wire[31:0]   csr_response__read_data;


    assign host_sram_request__valid=0;
    assign host_sram_request__read_enable=0;
    assign host_sram_request__write_enable=0;
    assign host_sram_request__select=0;
    assign host_sram_request__address=0;
    assign host_sram_request__write_data=0;

    assign csr_request__valid=0;
    assign csr_request__read_not_write=0;
    assign csr_request__select=0;
    assign csr_request__address=0;
    assign csr_request__data=0;

    assign leds = display_sram_write__data[7:0];

    bbc_micro_with_rams bbc( .clk(clk),
                             .clk__enable(1'b1),
                         .reset_n(reset_n),

                         .host_sram_request__valid(host_sram_request__valid),
                         .host_sram_request__read_enable(host_sram_request__read_enable),
                         .host_sram_request__write_enable(host_sram_request__write_enable),
                         .host_sram_request__select(host_sram_request__select),
                         .host_sram_request__address(host_sram_request__address),
                         .host_sram_request__write_data(host_sram_request__write_data),
                         .csr_request__valid(csr_request__valid),
                         .csr_request__read_not_write(csr_request__read_not_write),
                         .csr_request__select(csr_request__select),
                         .csr_request__address(csr_request__address),
                         .csr_request__data(csr_request__data),

                         .display_sram_write__enable(display_sram_write__enable),
                         .display_sram_write__data(display_sram_write__data),
                         .display_sram_write__address(display_sram_write__address),
                         .host_sram_response__ack(host_sram_response__ack),
                         .host_sram_response__read_data_valid(host_sram_response__read_data_valid),
                         .host_sram_response__read_data(host_sram_response__read_data),
                         .csr_response__ack(csr_response__ack),
                         .csr_response__read_data_valid(csr_response__read_data_valid),
                         .csr_response__read_data(csr_response__read_data)
                         );
   
endmodule
