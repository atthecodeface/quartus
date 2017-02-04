module      se_sram_srw_65536x8(
                                sram_clock, write_data, address, write_enable, read_not_write, select, data_out );
   input sram_clock, select, read_not_write, write_enable;
   input [15:0] address;
   input [7:0]  write_data;
   output [7:0] data_out;
   reg [7:0] data_out;
   reg [7:0] ram[65535:0];
   initial
     begin
        data_out <= 0;
     end
   always @(posedge sram_clock)
     begin
        if (write_enable && !read_not_write && select)
          begin
             ram[address] <= write_data;
          end
        if (read_not_write && select)
          begin
             data_out <= ram[address];
          end
     end
endmodule // se_sram_srw_65536x8
