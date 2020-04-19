//m se_sram_srw_65536x16
module se_sram_srw_65536x16( sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
    parameter initfile="",address_width=16,data_width=16;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input write_enable;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address, write_enable,read_not_write,select,data_out);
endmodule
//m se_sram_srw_65536x8
module se_sram_srw_65536x8( sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
    parameter initfile="",address_width=16,data_width=8;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input write_enable;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address, write_enable,read_not_write,select,data_out);
endmodule
//m se_sram_srw_32768x64
module se_sram_srw_32768x64( sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
    parameter initfile="",address_width=15,data_width=64;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input write_enable;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address, write_enable,read_not_write,select,data_out);
endmodule
//m se_sram_srw_32768x40
module se_sram_srw_32768x40( sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
    parameter initfile="",address_width=15,data_width=40;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input write_enable;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address, write_enable,read_not_write,select,data_out);
endmodule
//m se_sram_srw_32768x32
module se_sram_srw_32768x32( sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
    parameter initfile="",address_width=15,data_width=32;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input write_enable;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address, write_enable,read_not_write,select,data_out);
endmodule
//m se_sram_srw_16384x40
module se_sram_srw_16384x40( sram_clock, sram_clock__enable, write_data, address, read_not_write, select, data_out );
    parameter initfile="",address_width=14,data_width=40;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,read_not_write,select,data_out);
endmodule
//m se_sram_srw_16384x8
module se_sram_srw_16384x8( sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
    parameter initfile="",address_width=14,data_width=8;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input write_enable;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,write_enable,read_not_write,select,data_out);
endmodule
//m se_sram_srw_16384x32_we8
module se_sram_srw_16384x32_we8( sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
    parameter initfile="",address_width=14,data_width=32;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input [3:0]write_enable;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address, write_enable,read_not_write,select,data_out);
endmodule
//m se_sram_srw_256x40
module se_sram_srw_256x40( sram_clock, sram_clock__enable, write_data, address, read_not_write, select, data_out );
    parameter initfile="",address_width=8,data_width=40;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,read_not_write,select,data_out);
endmodule
//m se_sram_srw_256x7
module se_sram_srw_256x7( sram_clock, sram_clock__enable, write_data, address, read_not_write, select, data_out );
    parameter initfile="",address_width=8,data_width=7;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,read_not_write,select,data_out);
endmodule
//m se_sram_srw_128x64
module se_sram_srw_128x64( sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
    parameter initfile="",address_width=7,data_width=64;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input write_enable;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address, write_enable,read_not_write,select,data_out);
endmodule
//m se_sram_srw_128x45
module se_sram_srw_128x45( sram_clock, sram_clock__enable, write_data, address, read_not_write, select, data_out );
    parameter initfile="",address_width=7,data_width=45;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address,read_not_write,select,data_out);
endmodule
//m se_sram_srw_128x8_we
module se_sram_srw_128x8_we( sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
    parameter initfile="",address_width=7,data_width=8;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input write_enable;
    input [address_width-1:0] address;
    input [data_width-1:0]    write_data;
    output [data_width-1:0]   data_out;
    se_sram_srw_we #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address, write_enable,read_not_write,select,data_out);
endmodule
