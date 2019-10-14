#!/usr/bin/env python

class srw:
    data_width=32
    address_widrth=16
    depth = None
    write_enable=-1
    name = None
    address_width=None
    def __init__(self):
        if self.depth is None:
            self.depth = 1<<self.address_width
            pass
        if self.name is None:
            self.name = "se_sram_srw_%dx%d"%(self.depth, self.data_width)
            pass
        self.write_enable_string=""
        self.write_enable_port = ""
        self.sram_module = "se_sram_srw"
        if self.write_enable is not None:
            self.sram_module = "se_sram_srw_we"
            if self.write_enable<0: self.write_enable=self.data_width
            self.bits_per_we = self.data_width/self.write_enable
            self.write_enable_port = ", write_enable"
            self.write_enable_bus = ""
            if self.bits_per_we>1: self.write_enable_bus = "[%d:0]"%(self.bits_per_we-1)
            pass
            
        pass
    def output_module(self, output):
        output("//m %s"%(self.name))
        output("module %s( sram_clock, sram_clock__enable, write_data, address%s, read_not_write, select, data_out );"%(self.name, self.write_enable_port))
        output("""    parameter initfile="",address_width=%d,data_width=%d;"""%(self.address_width,self.data_width))
        output("    input sram_clock, sram_clock__enable, select, read_not_write;")
        if self.write_enable:
            output("    input %swrite_enable;"%self.write_enable_bus)
        output("    input [address_width-1:0] address;")
        output("    input [data_width-1:0]    write_data;")
        output("    output [data_width-1:0]   data_out;")
        output("    %s #(address_width,data_width,initfile) ram(sram_clock,sram_clock__enable,write_data,address%s,read_not_write,select,data_out);"%(self.sram_module, self.write_enable_port))
        output("endmodule")

class se_sram_srw_65536x16(srw):
    address_width = 16
    data_width    = 16

class se_sram_srw_65536x8(srw):
    address_width = 16
    data_width    = 8

class se_sram_srw_32768x64(srw):
    address_width = 15
    data_width    = 64

class se_sram_srw_32768x40(srw):
    address_width = 15
    data_width    = 40

class se_sram_srw_32768x32(srw):
    address_width = 15
    data_width    = 32

class se_sram_srw_16384x40(srw): # No WE
    address_width = 14
    data_width    = 40
    write_enable = None

class se_sram_srw_16384x8(srw): # No WE
    address_width = 14
    data_width    = 8
    write_enable = None

class se_sram_srw_16384x32_we8(srw):
    address_width = 14
    data_width    = 32
    write_enable  = 8
    name = "se_sram_srw_16384x32_we8"

class se_sram_srw_256x40(srw): # No WE
    address_width = 8
    data_width    = 40
    write_enable = None

class se_sram_srw_256x7(srw): # No WE
    address_width = 8
    data_width    = 7
    write_enable = None

class se_sram_srw_128x64(srw):
    address_width = 7
    data_width    = 64

class se_sram_srw_128x45(srw): # No WE
    address_width = 7
    data_width    = 45
    write_enable = None

class se_sram_srw_128x8_we(srw):
    address_width = 7
    data_width    = 8
    name = "se_sram_srw_128x8_we"

class se_sram_srw_32768x32_we8(srw):
    address_width = 15
    data_width    = 32
    write_enable  = 8


sram_classes = [ se_sram_srw_65536x16,
                 se_sram_srw_65536x8,
                 se_sram_srw_32768x64,
                 se_sram_srw_32768x40,
                 se_sram_srw_32768x32,
                 se_sram_srw_16384x40,
                 se_sram_srw_16384x8,
                 se_sram_srw_16384x32_we8,
                 se_sram_srw_256x40,
                 se_sram_srw_256x7,
                 se_sram_srw_128x64,
                 se_sram_srw_128x45,
                 se_sram_srw_128x8_we,
                 se_sram_srw_32768x32_we8,
                 ]
for sc in sram_classes:
    sram = sc()
    def output(s):
        print s
        pass
    sram.output_module(output)
    pass

