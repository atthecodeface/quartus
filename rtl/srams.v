module se_sram_srw(sram_clock, write_data, address, write_enable, read_not_write, select, data_out );
   parameter address_width=16;
   parameter data_width=16;
   parameter initfile="";
  
   input sram_clock, select, read_not_write, write_enable;
   input [address_width-1:0] address;
   input  [data_width-1:0]  write_data;
   output [data_width-1:0] data_out;
   (* ram_init_file = initfile *)   reg [data_width-1:0] ram[(1<<address_width)-1:0];
   reg [data_width-1:0] data_out;
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
endmodule
module se_sram_srw_65536x32(sram_clock, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, select, read_not_write, write_enable;
   input  [15:0] address;
   input  [31:0]  write_data;
   output [31:0]  data_out;
   se_sram_srw #(16,32,initfile) (.sram_clock(sram_clock),
                                    .write_data(write_data),
                                    .address(address),
                                    .write_enable(write_enable),
                                    .read_not_write(read_not_write),
                                    .data_out(data_out));
endmodule
module se_sram_srw_65536x8(sram_clock, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, select, read_not_write, write_enable;
   input  [15:0] address;
   input  [7:0]  write_data;
   output [7:0]  data_out;
   se_sram_srw #(16,8,initfile) (.sram_clock(sram_clock),
                                    .write_data(write_data),
                                    .address(address),
                                    .write_enable(write_enable),
                                    .read_not_write(read_not_write),
                                    .data_out(data_out));
endmodule
module se_sram_srw_128x8(sram_clock, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, select, read_not_write, write_enable;
   input  [6:0] address;
   input  [7:0] write_data;
   output [7:0] data_out;
   se_sram_srw #(7,8,initfile) (.sram_clock(sram_clock),
                                    .write_data(write_data),
                                    .address(address),
                                    .write_enable(write_enable),
                                    .read_not_write(read_not_write),
                                    .data_out(data_out));
endmodule
module se_sram_srw_128x64(sram_clock, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, select, read_not_write, write_enable;
   input  [6:0] address;
   input  [63:0] write_data;
   output [63:0] data_out;
   se_sram_srw #(7,64,initfile) (.sram_clock(sram_clock),
                                    .write_data(write_data),
                                    .address(address),
                                    .write_enable(write_enable),
                                    .read_not_write(read_not_write),
                                    .data_out(data_out));
endmodule
module se_sram_srw_16384x8(sram_clock, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, select, read_not_write, write_enable;
   input  [13:0] address;
   input  [7:0]  write_data;
   output [7:0]  data_out;
   se_sram_srw #(14,8,initfile) (.sram_clock(sram_clock),
                                    .write_data(write_data),
                                    .address(address),
                                    .write_enable(write_enable),
                                    .read_not_write(read_not_write),
                                    .data_out(data_out));
endmodule
module se_sram_srw_32768x64(sram_clock, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, select, read_not_write, write_enable;
   input  [14:0] address;
   input  [63:0]  write_data;
   output [63:0]  data_out;
   se_sram_srw #(15,64,initfile) (.sram_clock(sram_clock),
                                    .write_data(write_data),
                                    .address(address),
                                    .write_enable(write_enable),
                                    .read_not_write(read_not_write),
                                    .data_out(data_out));
endmodule
