#!/usr/bin/env python
import sys
mif_filename = sys.argv[1]
hex_filename = sys.argv[2]
mem_contents = [0]*65536
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
l=len(mem_contents)
print >> mif_hex, "DEPTH = %d;" % l
print >> mif_hex, "WIDTH = 8;"
print >> mif_hex, "ADDRESS_RADIX = HEX;"
print >> mif_hex, "DATA_RADIX = HEX;"
print >> mif_hex, "CONTENT"
print >> mif_hex, "BEGIN"
a=-1
for d in mem_contents:
    a = a+1
    if d==0: continue
    print >> mif_hex, "%x:%02x;"%(a,d)
    pass
print >> mif_hex, "END;"
mif_hex.close()
