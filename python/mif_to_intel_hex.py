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
bpl=1
for i in range((l+bpl-1)/bpl):
    n = l-i*bpl
    if n>bpl: n=bpl
    csum = 0
    text = ":%02x%04x00"%(n,i*bpl)
    csum += n
    csum += ((i*bpl)>>8)&0xff
    csum += (i*bpl)&0xff
    for j in range(n):
        d = mem_contents[i*bpl+j]
        csum = csum + d
        text = text + ("%02x"%d)
        pass
    csum = (256-csum)&0xff
    text = text + ("%02x"%csum)
    print >> mif_hex, text
    pass
mif_hex.close()
