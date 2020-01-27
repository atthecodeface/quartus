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
//m se_sram_mrw_2_16384x32
module se_sram_mrw_2_2048x32(sram_clock_0, sram_clock_0__enable, write_data_0, address_0, read_not_write_0, select_0, data_out_0,
                              sram_clock_1, sram_clock_1__enable, write_data_1, address_1, read_not_write_1, select_1, data_out_1 );
   parameter initfile="",address_width=11,data_width=32;
   input sram_clock_0, sram_clock_0__enable, select_0, read_not_write_0;
   input sram_clock_1, sram_clock_1__enable, select_1, read_not_write_1;
   input [address_width-1:0] address_0, address_1;
   input [data_width-1:0]    write_data_0, write_data_1;
   output [data_width-1:0]   data_out_0, data_out_1;
   se_sram_mrw_2 #(address_width,data_width,initfile) ram(sram_clock_0,sram_clock_0__enable,write_data_0,address_0,read_not_write_0,select_0,data_out_0,
                                                          sram_clock_1,sram_clock_1__enable,write_data_1,address_1,read_not_write_1,select_1,data_out_1 );
endmodule

//m se_sram_mrw_2_512x32
module se_sram_mrw_2_512x32(sram_clock_0, sram_clock_0__enable, write_data_0, address_0, read_not_write_0, select_0, data_out_0,
                              sram_clock_1, sram_clock_1__enable, write_data_1, address_1, read_not_write_1, select_1, data_out_1 );
   parameter initfile="",address_width=9,data_width=32;
   input sram_clock_0, sram_clock_0__enable, select_0, read_not_write_0;
   input sram_clock_1, sram_clock_1__enable, select_1, read_not_write_1;
   input [address_width-1:0] address_0, address_1;
   input [data_width-1:0]    write_data_0, write_data_1;
   output [data_width-1:0]   data_out_0, data_out_1;
   se_sram_mrw_2 #(address_width,data_width,initfile) ram(sram_clock_0,sram_clock_0__enable,write_data_0,address_0,read_not_write_0,select_0,data_out_0,
                                                          sram_clock_1,sram_clock_1__enable,write_data_1,address_1,read_not_write_1,select_1,data_out_1 );
endmodule

//m se_sram_mrw_2_512x64
module se_sram_mrw_2_512x64(sram_clock_0, sram_clock_0__enable, write_data_0, address_0, read_not_write_0, select_0, data_out_0,
                              sram_clock_1, sram_clock_1__enable, write_data_1, address_1, read_not_write_1, select_1, data_out_1 );
   parameter initfile="",address_width=9,data_width=64;
   input sram_clock_0, sram_clock_0__enable, select_0, read_not_write_0;
   input sram_clock_1, sram_clock_1__enable, select_1, read_not_write_1;
   input [address_width-1:0] address_0, address_1;
   input [data_width-1:0]    write_data_0, write_data_1;
   output [data_width-1:0]   data_out_0, data_out_1;
   se_sram_mrw_2 #(address_width,data_width,initfile) ram(sram_clock_0,sram_clock_0__enable,write_data_0,address_0,read_not_write_0,select_0,data_out_0,
                                                          sram_clock_1,sram_clock_1__enable,write_data_1,address_1,read_not_write_1,select_1,data_out_1 );
endmodule
