#!/usr/bin/env python
import sys
mif_filename = sys.argv[1]
hex_filename = sys.argv[2]
mem_contents = []
mif = open(mif_filename)
for l in mif:
    l.strip()
    for k in l.split():
        if k[-1]==':':
            address = int(k[:-1],16)
            pass
        else:
            data = int(k,16)
            while address>=len(mem_contents):
                mem_contents.append(0)
                pass
            mem_contents[address]=data
            address += 1
            pass
        pass
    pass
mif_hex = open(hex_filename,"w")
for d in mem_contents:
    print >> mif_hex, "%x" % d
    pass
mif_hex.close()
