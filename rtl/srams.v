module se_sram_srw(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter address_width=16;
   parameter data_width=8;
   parameter initfile="";
  
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
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
     if (sram_clock__enable)
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
module se_sram_mrw_2( sram_clock_0, sram_clock_0__enable, write_data_0, address_0, write_enable_0, read_not_write_0, select_0, data_out_0,
                      sram_clock_1, sram_clock_1__enable, write_data_1, address_1, write_enable_1, read_not_write_1, select_1, data_out_1
 );
   parameter address_width=16;
   parameter data_width=8;
   parameter initfile="";
  
   input sram_clock_0, sram_clock_0__enable, select_0, read_not_write_0, write_enable_0;
   input [address_width-1:0] address_0;
   input  [data_width-1:0]  write_data_0;
   output [data_width-1:0] data_out_0;
   input sram_clock_1, sram_clock_1__enable, select_1, read_not_write_1, write_enable_1;
   input [address_width-1:0] address_1;
   input  [data_width-1:0]  write_data_1;
   output [data_width-1:0] data_out_1;
   (* ram_init_file = initfile *)   reg [data_width-1:0] ram[(1<<address_width)-1:0];
   reg [data_width-1:0] data_out_0;
   reg [data_width-1:0] data_out_1;
   initial
     begin
        data_out_0 <= 0;
        data_out_1 <= 0;
     end
   always @(posedge sram_clock_0)
     if (sram_clock_0__enable)
     begin
        if (write_enable_0 && !read_not_write_0 && select_0)
          begin
             ram[address_0] <= write_data_0;
          end
        if (read_not_write_0 && select_0)
          begin
             data_out_0 <= ram[address_0];
          end
     end
   always @(posedge sram_clock_1)
     if (sram_clock_1__enable)
     begin
        if (write_enable_1 && !read_not_write_1 && select_1)
          begin
             ram[address_1] <= write_data_1;
          end
        if (read_not_write_1 && select_1)
          begin
             data_out_1 <= ram[address_1];
          end
     end
endmodule
module se_sram_srw_65536x32(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input  [15:0] address;
   input  [31:0]  write_data;
   output [31:0]  data_out;
   se_sram_srw #(16,32,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule
module se_sram_srw_65536x8(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input  [15:0] address;
   input  [7:0]  write_data;
   output [7:0]  data_out;
   se_sram_srw #(16,8,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule
module se_sram_srw_128x8(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input  [6:0] address;
   input  [7:0] write_data;
   output [7:0] data_out;
   se_sram_srw #(7,8,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule
module se_sram_srw_128x64(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input  [6:0] address;
   input  [63:0] write_data;
   output [63:0] data_out;
   se_sram_srw #(7,64,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule
module se_sram_srw_16384x8(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input  [13:0] address;
   input  [7:0]  write_data;
   output [7:0]  data_out;
   se_sram_srw #(14,8,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule
module se_sram_srw_32768x64(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="";
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input  [14:0] address;
   input  [63:0]  write_data;
   output [63:0]  data_out;
   se_sram_srw #(15,64,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule

module se_sram_mrw_2_16384x48(sram_clock_0, sram_clock_0__enable, write_data_0, address_0, read_not_write_0, select_0, data_out_0,
                              sram_clock_1, sram_clock_1__enable, write_data_1, address_1, read_not_write_1, select_1, data_out_1 );
   parameter initfile="";
   input sram_clock_0, sram_clock_0__enable, select_0, read_not_write_0;
   input  [13:0] address_0;
   input  [47:0]  write_data_0;
   output [47:0]  data_out_0;
   input          sram_clock_1, sram_clock_1__enable, select_1, read_not_write_1;
   input  [13:0] address_1;
   input  [47:0]  write_data_1;
   output [47:0]  data_out_1;
   se_sram_mrw_2 #(14,48,initfile) ram(sram_clock_0,sram_clock_0__enable,write_data_0,address_0,1'b1,read_not_write_0,select_0,data_out_0,
                                     sram_clock_1,sram_clock_1__enable,write_data_1,address_1,1'b1,read_not_write_1,select_1,data_out_1 );
endmodule
