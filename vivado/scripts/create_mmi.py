#!/usr/bin/env python
# ./vivado/scripts/create_mmi.py --py vivado_output/vcu108_riscv__bram_dict.py --ram dut/riscv/mem --out riscv.mmi
# updatemem --meminfo riscv.mmi --proc dut/riscv --data <elffile or memfile> --bit vivado_output/vcu108_riscv.bit --out new.bit

#a Imports
import sys
import importlib
import argparse
import os

#a Class bram
class bram:
    mem_types = {'RAMB36E2':'RAMB32',
                 # Does not work! 'RAMB18E2':'RAMB32', # Will this work?!
                }
    def __init__(self, name, bram_dict):
        self.name = name
        self.parent = bram_dict['PARENT']
        self.bel    = bram_dict['BEL']
        self.loc    = bram_dict['LOC'].split('_')[1]
        # addresses and lsb/msb are inclusive
        self.addr_begin = int(bram_dict['ram_addr_begin'])
        self.addr_end   = int(bram_dict['ram_addr_end'])
        self.lsb        = int(bram_dict['ram_slice_begin'])
        self.msb        = int(bram_dict['ram_slice_end'])
        if bram_dict['REF_NAME'] not in self.mem_types:
            self.mem_type = "MemTypeNotSupported__%s"%bram_dict['REF_NAME']
            pass
        else:
            self.mem_type   = self.mem_types[bram_dict['REF_NAME']]
        pass
    def generate_mmi(self, output):
        output('<BitLane MemType="%s" Placement="%s">'%(self.mem_type, self.loc))
        output('<DataWidth MSB="%d" LSB="%d"/>'%(self.msb, self.lsb))
        output('<AddressRange Begin="%d" End="%d"/>'%(self.addr_begin, self.addr_end))
        output('<Parity ON="false" NumBits="0"/>')
        output('</BitLane>')
class bus_block:
    def __init__(self, brams):
        """
        Create a bus block - all brams must have the same address range
        We need to have a list of them in the correct order (seems to be first byte
        in ELF file goes to first bram - they ignore the lsb/msb etc)
        """
        self.addr_begin = brams[0].addr_begin
        self.addr_end   = brams[0].addr_end
        for b in brams:
            if b.addr_begin != self.addr_begin:
                raise Exception("Mismatch in start addresses for rams in a bus block")
            if b.addr_end != self.addr_end:
                raise Exception("Mismatch in end addresses for rams in a bus block")
            pass
        self.ordered_brams = brams[:] # Copy the list
        self.ordered_brams.sort(cmp=lambda x,y:cmp(x.lsb,y.lsb))
        pass
    def generate_mmi(self, output):
        output('<BusBlock>')
        for b in self.ordered_brams:
            b.generate_mmi(output)
            pass
        output('</BusBlock>')
        pass

#a Class sram
class sram:
    def __init__(self, path):
        self.path = path
        self.brams = {}
        self.address_min = None # inclusive
        self.address_max = None # inclusive
        self.msb = None
        self.lsb = None
        self.bus_blocks = []
        pass
    def add_bram(self, bram, verbose=False):
        if bram.parent != self.path:
            if verbose:
                print >>sys.stderr, "Skipping %s as it has the wrong parent (needs %s got %s)"%(bram.name, bram.parent, self.path)
                pass
            return
        self.brams[bram.name] = bram
        if (self.address_min is None) or (bram.addr_begin < self.address_min):
            self.address_min = bram.addr_begin
            pass
        if (self.address_max is None) or (bram.addr_end > self.address_max):
            self.address_max = bram.addr_end
            pass
        if (self.lsb is None) or (bram.lsb < self.lsb):
            self.lsb = bram.lsb
            pass
        if (self.msb is None) or (bram.msb > self.msb):
            self.msb = bram.msb
            pass
        print >>sys.stderr, "Added %s with bits [%d:%d] address 0x%x to 0x%x"%(bram.name, bram.lsb, bram.msb, bram.addr_begin, bram.addr_end)
        pass
    def create_bus_blocks(self):
        self.bus_blocks = []
        brams_at_addresses = {}
        for (_,b) in self.brams.iteritems():
            addr = b.addr_begin
            if addr not in brams_at_addresses:
                brams_at_addresses[addr] = []
                pass
            brams_at_addresses[addr].append(b)
            pass
        addresses = brams_at_addresses.keys()
        addresses.sort()
        for addr in addresses:
            self.bus_blocks.append(bus_block(brams_at_addresses[addr]))
            pass
        pass
    def generate_mmi(self, output, inst_path, address_space, part):
        self.create_bus_blocks()
        if len(self.bus_blocks)==0:
            print >>sys.stderr, "No BRAM blocks extracted so MMI would be empty"
            sys.exit(4)
            return
        # inst_path = dut/riscv
        # address_space = riscv
        # part = xcvu095-ffva2104-2-e
        bits_per_word = self.msb+1 - self.lsb
        bytes_per_word = bits_per_word / 8
        address_byte_min = self.address_min * bytes_per_word
        address_byte_max = (self.address_max+1) * bytes_per_word
        output('<?xml version="1.0" encoding="UTF-8"?>')
        output('<MemInfo Version="1" Minor="0">')
        output('<Processor Endianness="Little" InstPath="%s">'%(inst_path))
        output('<AddressSpace Name="%s" Begin="%d" End="%d">'%(address_space, address_byte_min, address_byte_max))
        for bb in self.bus_blocks:
            bb.generate_mmi(output)
            pass
        output('</AddressSpace>')
        output('</Processor>')
        output('  <Config>')
        output('    <Option Name="Part" Val="%s"/>'%part)
        output('</Config>')
        output('  <DRC>')
        output('    <Rule Name="RDADDRCHANGE" Val="false"/>')
        output('</DRC>')
        output('</MemInfo>')

#a Functions
#f generate_brams
def generate_brams(bram_cells):
    """
    Generate a dictionary of bram objects for all BRAMs from the output of extract_memory.tcl
    """
    brams = {}
    for (name,bram_dict) in bram_cells.iteritems():
        brams[name] = bram(name, bram_dict)
        pass
    return brams

#f generate_mmi
def generate_mmi(brams, out_file, instance_name, mem_subname, part, verbose=False):
    ram_name = instance_name
    if mem_subname!="": ram_name = instance_name+"/"+mem_subname
    rv_mem = sram(ram_name)
    for (name,bram) in brams.iteritems():
        rv_mem.add_bram(bram, verbose=verbose)
        pass
    def output(s): print >> out_file, s
    rv_mem.generate_mmi(output=output, inst_path=instance_name, address_space='address_space_name', part=part)
    return

#a Toplevel
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate MMI file from extract_memory.tcl data for a memory instance')
    parser.add_argument('--py', type=str, default=None, required=True,
                    help='Python file generated by extract_memory.tcl (e.g. vivado_output/vcu108_riscv__bram_dict.py)')
    parser.add_argument('--ram', type=str, default=None, required=True,
                    help='RAM within the design (e.g. dut/riscv/mem)')
    parser.add_argument('--subpath', type=str, default="ram",
                    help='Path inside RAM to actual BRAM cells')
    parser.add_argument('--part', type=str, default="xcvu095-ffva2104-2-e",
                    help='Xilinx part the design is targeted at')
    parser.add_argument('--out', type=str, default=None,
                    help='Output file')
    parser.add_argument('--quiet', type=bool, default=False,
                    help='Quiet - suppres informational output')
    parser.add_argument('--verbose', type=bool, default=False,
                    help='Make verbose')
    args = parser.parse_args()
    p=os.path.abspath(args.py)
    d=os.path.dirname(p)
    sys.path.append(d)
    b=os.path.basename(p)
    (bn,be)=os.path.splitext(b)
    m=importlib.import_module(bn)
    brams = generate_brams(m.bram_cells)
    if args.out is None:
        out_file = sys.stdout
        out_name = "<mmi file>"
        pass
    else:
        out_name = args.out
        out_file = open(args.out,"w")
        pass
    generate_mmi(brams, out_file, args.ram, args.subpath, args.part, verbose=args.verbose)
    if args.out is not None: out_file.close()
    if not args.quiet:
        print "To update memory, from a shell use:"
        print "updatemem --meminfo %s --proc %s --data <elffile or memfile> --bit <bit>  --out <output bit>"%(out_name,args.ram)
    pass
