#!/usr/bin/env python
import re
import os
verilog_paramters = {
    "framebuffer_teletext.v": [("character_rom", {"initfile":'"banana"'} ),],
    "vcu108_debug.v":         [("apb_rom",  {"initfile":'"apb_rom"'} ),],
 }
#    se_sram_srw_128x45 #(.initfile("banana")) character_rom(
#     se_sram_srw_256x40 #(.initfile("apb_rom")) apb_rom(
class parametrize_file:
    filename = "file.v"
    parameters = ["module", {"par_name":"par_value"},
    ]
    def __init__(self, filename=None, parameters=None):
        if filename is not None: self.filename = filename
        if parameters is not None: self.parameters = parameters
        pass
    def rewrite_verilog(self, rtl_dir):
        filename = "%s/%s"%(rtl_dir,self.filename)
        f = open(filename)
        lines = []
        for l in f:
            l = l.rstrip()
            lines.append(l)
            pass
        f.close()
        param_re = re.compile(r"(.*)#(.*)")
        for (mod, args) in self.parameters:
            pre = re.compile(r"(.*)%s\((.*)"%mod)
            pstr = ""
            for pn in args:
                pv = args[pn]
                if pstr=="":
                    pstr = "#(.%s(%s)"%(pn,pv)
                    pass
                else:
                    pstr = "%s, %s(%s)"%(pstr,pn,pv)
                    pass
                pass
            pstr = " %s) "%pstr
            new_lines = []
            for l in lines:
                match = pre.search(l)
                if match is not None:
                    unparam = match.group(1)
                    unparam_match = param_re.match(unparam)
                    if unparam_match is not None: unparam=unparam_match.group(1)
                    unparam = unparam.rstrip(' ')
                    l = "%s %s%s(%s"%(unparam, pstr, mod, match.group(2))
                    pass
                new_lines.append(l)
                pass
            lines = new_lines
            pass
        try:
            os.unlink(filename+".bkp")
            pass
        except:
            pass
        os.rename(filename, filename+".bkp")
        f = open("%s/%s"%(rtl_dir,self.filename),"w")
        for l in lines:
            print >>f, l
            pass
        f.close()
        pass
    pass


for filename in verilog_paramters:
    pf = parametrize_file(filename=filename, parameters=verilog_paramters[filename])
    pf.rewrite_verilog("verilog")
    pass

