//a Root modules
//m se_sram_srw
module se_sram_srw(sram_clock, sram_clock__enable, write_data, address, read_not_write, select, data_out );
   parameter address_width=16;
   parameter data_width=8;
   parameter initfile="";
  
   input sram_clock, sram_clock__enable, select, read_not_write;
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
        if (!read_not_write && select)
          begin
             ram[address] <= write_data;
          end
        if (read_not_write && select)
          begin
             data_out <= ram[address];
          end
     end
endmodule

//m se_sram_srw_we
module se_sram_srw_we(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
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

//m se_sram_mrw_2
module se_sram_mrw_2( sram_clock_0, sram_clock_0__enable, write_data_0, address_0, read_not_write_0, select_0, data_out_0,
                      sram_clock_1, sram_clock_1__enable, write_data_1, address_1, read_not_write_1, select_1, data_out_1
 );
   parameter address_width=16;
   parameter data_width=8;
   parameter initfile="";
  
   input sram_clock_0, sram_clock_0__enable, select_0, read_not_write_0;
   input [address_width-1:0] address_0;
   input  [data_width-1:0]  write_data_0;
   output [data_width-1:0] data_out_0;
   input sram_clock_1, sram_clock_1__enable, select_1, read_not_write_1;
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
        if (!read_not_write_0 && select_0)
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
        if (!read_not_write_1 && select_1)
          begin
             ram[address_1] <= write_data_1;
          end
        if (read_not_write_1 && select_1)
          begin
             data_out_1 <= ram[address_1];
          end
     end
endmodule

//a Single port SRAMs
//m se_sram_srw_65536x32
module se_sram_srw_65536x32(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="",address_width=16,data_width=32;
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input [address_width-1:0] address;
   input [data_width-1:0]    write_data;
   output [data_width-1:0]   data_out;
   se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule

//m se_sram_srw_65536x8
module se_sram_srw_65536x8(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="",address_width=16,data_width=8;
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input [address_width-1:0] address;
   input [data_width-1:0]    write_data;
   output [data_width-1:0]   data_out;
   se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule

//m se_sram_srw_32768x64
module se_sram_srw_32768x64(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="",address_width=15,data_width=64;
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input [address_width-1:0] address;
   input [data_width-1:0]    write_data;
   output [data_width-1:0]   data_out;
   se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule

//m se_sram_srw_32768x32
module se_sram_srw_32768x32(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="",address_width=15,data_width=32;
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input [address_width-1:0] address;
   input [data_width-1:0]    write_data;
   output [data_width-1:0]   data_out;
   se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule

//m se_sram_srw_16384x8
module se_sram_srw_16384x8(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="",address_width=14,data_width=8;
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input [address_width-1:0] address;
   input [data_width-1:0]    write_data;
   output [data_width-1:0]   data_out;
   se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule

//m se_sram_srw_16384x40
module se_sram_srw_16384x40(sram_clock, sram_clock__enable, write_data, address, read_not_write, select, data_out );
   parameter initfile="",address_width=14,data_width=40;
   input sram_clock, sram_clock__enable, select, read_not_write;
   input [address_width-1:0] address;
   input [data_width-1:0]    write_data;
   output [data_width-1:0]   data_out;
   se_sram_srw #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,read_not_write,select,data_out);
endmodule

//m se_sram_srw_256x40 - no we
module se_sram_srw_256x40(sram_clock, sram_clock__enable, write_data, address, read_not_write, select, data_out );
   parameter initfile="",address_width=8,data_width=40;
   input sram_clock, sram_clock__enable, select, read_not_write;
   input [address_width-1:0] address;
   input [data_width-1:0]    write_data;
   output [data_width-1:0]   data_out;
   se_sram_srw #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,read_not_write,select,data_out);
endmodule

//m se_sram_srw_256x7 - no we
module se_sram_srw_256x7(sram_clock, sram_clock__enable, write_data, address, read_not_write, select, data_out );
   parameter initfile="",address_width=8,data_width=7;
   input sram_clock, sram_clock__enable, select, read_not_write;
   input [address_width-1:0] address;
   input [data_width-1:0]    write_data;
   output [data_width-1:0]   data_out;
   se_sram_srw #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,read_not_write,select,data_out);
endmodule

//m se_sram_srw_128x8
module se_sram_srw_128x8_we(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="",address_width=7,data_width=8;
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input [address_width-1:0] address;
   input [data_width-1:0]    write_data;
   output [data_width-1:0]   data_out;
   se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule

//m se_sram_srw_128x64
module se_sram_srw_128x64(sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
   parameter initfile="",address_width=7,data_width=64;
   input sram_clock, sram_clock__enable, select, read_not_write, write_enable;
   input [address_width-1:0] address;
   input [data_width-1:0]    write_data;
   output [data_width-1:0]   data_out;
   se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule

//m se_sram_srw_128x45 - no we
module se_sram_srw_128x45(sram_clock, sram_clock__enable, write_data, address, read_not_write, select, data_out );
   parameter initfile="",address_width=7,data_width=45;
   input sram_clock, sram_clock__enable, select, read_not_write;
   input [address_width-1:0] address;
   input [data_width-1:0]    write_data;
   output [data_width-1:0]   data_out;
   se_sram_srw #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,read_not_write,select,data_out);
endmodule

//a Dual-port SRAMs
//m se_sram_mrw_2_16384x48
module se_sram_mrw_2_16384x48(sram_clock_0, sram_clock_0__enable, write_data_0, address_0, read_not_write_0, select_0, data_out_0,
                              sram_clock_1, sram_clock_1__enable, write_data_1, address_1, read_not_write_1, select_1, data_out_1 );
   parameter initfile="",address_width=14,data_width=48;
   input sram_clock_0, sram_clock_0__enable, select_0, read_not_write_0;
   input sram_clock_1, sram_clock_1__enable, select_1, read_not_write_1;
   input [address_width-1:0] address_0, address_1;
   input [data_width-1:0]    write_data_0, write_data_1;
   output [data_width-1:0]   data_out_0, data_out_1;
   se_sram_mrw_2 #(address_width,data_width,initfile) ram(sram_clock_0,sram_clock_0__enable,write_data_0,address_0,read_not_write_0,select_0,data_out_0,
                                                          sram_clock_1,sram_clock_1__enable,write_data_1,address_1,read_not_write_1,select_1,data_out_1 );
endmodule

//m se_sram_mrw_2_16384x8
module se_sram_mrw_2_16384x8(sram_clock_0, sram_clock_0__enable, write_data_0, address_0, read_not_write_0, select_0, data_out_0,
                              sram_clock_1, sram_clock_1__enable, write_data_1, address_1, read_not_write_1, select_1, data_out_1 );
   parameter initfile="",address_width=14,data_width=8;
   input sram_clock_0, sram_clock_0__enable, select_0, read_not_write_0;
   input sram_clock_1, sram_clock_1__enable, select_1, read_not_write_1;
   input [address_width-1:0] address_0, address_1;
   input [data_width-1:0]    write_data_0, write_data_1;
   output [data_width-1:0]   data_out_0, data_out_1;
   se_sram_mrw_2 #(address_width,data_width,initfile) ram(sram_clock_0,sram_clock_0__enable,write_data_0,address_0,read_not_write_0,select_0,data_out_0,
                                                          sram_clock_1,sram_clock_1__enable,write_data_1,address_1,read_not_write_1,select_1,data_out_1 );
endmodule
