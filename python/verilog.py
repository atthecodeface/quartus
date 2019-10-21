#!/usr/bin/env python
import sys

#a Parameter and module classes
#c parameter
class parameter:
    name = None
    options = None
    prange = None
    pdefault = None
    def __init__(self, name, values, description):
        self.name = name
        if type(values)==list:
            self.pdefault = values[0]
            self.options = values
            pass
        elif type(values)==tuple:
            self.pdefault = values[0]
            self.prange    = values
            pass
        else:
            self.pdefault = values
            pass
        self.description = description
        pass
    def is_value_permissible(self, value):
        if type(value)==float:
            if type(self.pdefault)!=float: return False
            if self.prange is not None:
                if (value<self.prange[0]) or (value>self.prange[1]): return False
                pass
            return True
        if type(value)==int:
            if type(self.pdefault)!=int: return False
            if self.prange is not None:
                if (value<self.prange[0]) or (value>self.prange[1]): return False
                pass
            if self.options is not None:
                if value not in self.options: return False
                pass
            return True
        return False
    def instance(self, parameter_dict):
        if self.name not in parameter_dict: return None
        value = parameter_dict[self.name]
        if not self.is_value_permissible(value):
            raise Exception("Value '%s' not permissible for parameter '%s'"%(str(value), self.name))
        return parameter_instance(self, value)

#c parameter_instance
class parameter_instance:
    def __init__(self, parameter, value):
        self.parameter = parameter
        self.value = value
        pass
    def verilog_string(self):
        return ".%s(%s), // %s"%(self.parameter.name, str(self.value), self.parameter.description)

#c module
class module:
    def __init__(self, instance_name, parameters={}, signals={}):
        self.signal_names = [x for (x,_) in self.signals]
        self.instance_name = instance_name
        self.parameter_values = []
        for p in self.parameters:
            pv = p.instance(parameters)
            if pv is not None:
                self.parameter_values.append(pv)
                pass
            pass
        self.signal_assignments = signals
        for sn in signals:
            if sn not in self.signal_names:
                raise Exception("Unexpected signal %s"%sn)
            pass
        pass
    def output_verilog(self, f, indent="    "):
        print >>f, "%s%s #("%(indent, self.name)
        for pv in self.parameter_values:
            print >>f, "%s%s%s"%(indent, indent, pv.verilog_string())
            pass
        print >>f, "%s) %s ("%(indent, self.instance_name)
        for (sn, sv) in self.signals:
            if sn in self.signal_assignments: sv=self.signal_assignments[sn]
            if sv is not None:
                print >>f, "%s%s.%s (%s),"%(indent, indent, sn, sv)
                pass
            pass
        print >>f, "%s);"%(indent)
        pass

#a Xilinx primitives
#c mmcme3_base
class mmcme3_base(module):
    name ="MMCME3_BASE"
    parameters = [
        parameter("BANDWIDTH",           ["OPTIMIZED","LOW","HIGH"], "Jitter programming"),
        parameter("STARTUP_WAIT",        ["FALSE", "TRUE"], "Delays DONE until MMCM is locked"),
        parameter("CLKIN1_PERIOD",       10.,     "Input clock period in ns units, ps resolution (i.e. 33.333 is 30 MHz)."),
        parameter("IS_CLKIN1_INVERTED",  [0,1],   "Optional inversion for CLKIN1"),
        parameter("REF_JITTER",          0.,      "Reference input jitter in UI (0.000-0.999)."),
        parameter("DIVCLK_DIVIDE",       (1,106), "Master division value"),
        parameter("CLKFBOUT_MULT_F",     (2,64),  "Multiply value for VCO"), # possibly a float?
        parameter("CLKFBOUT_PHASE",      0.,      "Phase offset in degrees of CLKFB"),
        parameter("CLKOUT0_DIVIDE_F",    (1,128), "Divide amount for CLKOUT0"), # possibly a float?
        parameter("CLKOUT0_DUTY_CYCLE",  0.5,     "Duty cycle"),
        parameter("CLKOUT1_DIVIDE",      (1,128), "Divide amount for CLKOUT1"),
        parameter("CLKOUT2_DIVIDE",      (1,128), "Divide amount for CLKOUT21"),
        parameter("CLKOUT3_DIVIDE",      (1,128), "Divide amount for CLKOUT3"),
        parameter("CLKOUT4_DIVIDE",      (1,128), "Divide amount for CLKOUT4"),
        parameter("CLKOUT5_DIVIDE",      (1,128), "Divide amount for CLKOUT5"),
        parameter("CLKOUT6_DIVIDE",      (1,128), "Divide amount for CLKOUT6"),
        parameter("IS_CLKFBIN_INVERTED", [0,1],   "Optional inversion for CLKFBIN"),
        parameter("IS_PWRDWN_INVERTED",  [0,1],   "Optional inversion for PWRDWN"),
        parameter("IS_RST_INVERTED",     [0,1],   "Optional inversion for RST"),
        ]
    signals = [("RST", None),
               ("PWRDWN", 0),
               ("CLKOUT0", None),
               ("CLKOUT1", None),
               ("CLKOUT2", None),
               ("CLKOUT3", None),
               ("CLKOUT4", None),
               ("CLKOUT5", None),
               ("CLKOUT6", None),
               ("LOCKED", None),
               ("CLKIN1", None),
               ("CLKFBOUT", None),
               ("CLKFBIN", None),
               ]

#c ramb36e2
class ramb36e2(module):
    """
    These can run in 'true dual port mode' with two read-write ports of width up to 36.
    They can also run in 'simple dual port mode' with a single read port of up to 72 and a single write port of up to 72.

    Hence they can be used as an x64 memory with single read/write port.

    For simple single port memories:
    They can be seen as a 512x64 memory (9 address bits)
    They can be seen as a 1kx32  memory (10 address bits)
    They can be seen as a 2kx16  memory (11 address bits)
    They can be seen as a 4kx8   memory (12 address bits)
    """
    name ="RAMB36E2"
    parameters = [
        parameter("CASCASE_ORDER_A",           ["NONE", "FIRST", "MIDDLE", "LAST"], "Order of cascade - first is bottom"),
        parameter("CASCASE_ORDER_B",           ["NONE", "FIRST", "MIDDLE", "LAST"], "Order of cascade - first is bottom"),
        parameter("CLOCK_DOMAINS",        ["INDEPENDENT", "COMMON"], "Whether A and B are the same clock"),

        parameter("DOA_REG",             [1,0],   "Output register for port A"),
        parameter("ENADDRENA",           [0,1],   "Address enable pin for port A"),
        parameter("RDADDRCHANGEA",       [0,1],   "Enable read address change feature port A"),
        parameter("READ_WIDTH_A",        [0,1,2,4,9,16,36,72],   "Read width for port A"),
        parameter("WRITE_WIDTH_A",       [0,1,2,4,9,16,36,72],   "Write width for port A"),

        parameter("DOB_REG",             [1,0],   "Output register for port B"),
        parameter("ENADDRENB",           [0,1],   "Address enable pin for port B"),
        parameter("RDADDRCHANGEB",       [0,1],   "Enable read address change feature port B"),
        parameter("READ_WIDTH_B",        [0,1,2,4,9,16,36,72],   "Read width for port B"),
        parameter("WRITE_WIDTH_B",       [0,1,2,4,9,16,36,72],   "Write width for port B"),

        parameter("EN_ECC_PIPE",         ("FALSE","TRUE"),   "Enable ECC pipeline stage"),
        parameter("EN_ECC_READ",         ("FALSE","TRUE"),   "Enable ECC for reads - read width must be 72"),
        parameter("EN_ECC_WRITE",        ("FALSE","TRUE"),   "Enable ECC for writes - write width must be 72"),

        parameter("IS_CLKARDCLK_INVERTED",  [0,1],   "Optional inversion for read clock for port A"),
        parameter("IS_ENARDEN_INVERTED",    [0,1],   "Optional inversion for enarden for port A"),
        parameter("IS_ENBWREN_INVERTED",    [0,1],   "Optional inversion for enbwren for port A"),
        parameter("IS_RSTRAMARSTRAM_INVERTED",    [0,1],   "Optional inversion for rstramarstram for port A"),
        parameter("IS_RSTREGARSTREG_INVERTED",    [0,1],   "Optional inversion for rstregarstreg for port A"),
        parameter("IS_RSTRAMB_INVERTED",    [0,1],   "Optional inversion for rstramb for port B"),
        parameter("IS_RSTREGB_INVERTED",    [0,1],   "Optional inversion for rstregb for port A"),
        parameter("IS_CLKBWRCLK_INVERTED",  [0,1],   "Optional inversion for write clock for port B"),

        parameter("SLEEP_ASYNC",  [0,1],   "Is sleep async to clkardclk"),
        ]
    signals = [("SLEEP", 0),
               ("RSTRAMARSTRAM", 0),    # reset
               ("RSTREGARSTREG", None), # reset

               ("RSTRAMB", 0),          # reset
               ("RSTREGB", None),       # reset
               
               ("CLKARDCLK", None),     # Clock for reading or for port A
               ("ADDRARDADDR", None),   # Read address or address for port A (15 bits if 32kx1)
               ("ADDRENA", None),       # Address enable for port A if configured
               ("REGCEAREGCE", None),   # only if DOA REG is 1
               ("DINADIN", None),       # 32 bit data in for writing or for port A
               ("DINPADINP", None),     # 4 bit parity data in for writing or for port A
               ("ENARDEN", None),       # Read enable or enable for port A
               ("WEA", None),           # Four byte-write enables for port A
               ("DOUTADOUT", None),     # 32-bit data out for port A or read data
               ("DOUTPADOUTP", None),   # 4-bit data out for port A or read
               
               ("CLKBWRCLK", None),     # Clock for writing or for port B
               ("ADDRBWRADDR", None),   # Write address port B (15 bits if 32kx1)
               ("ADDRENB", None),       # Address enable for port B if configured
               ("ADDRARDADDR", None),   # Read address or address for port A (15 bits if 32kx1)
               ("REGCEB", None),        # only if DOB REG is 1
               ("DINBDIN", None),       # 32 bit data in for writing or for port B
               ("DINPBDINP", None),     # 4 bit parity data in for writing or for port B
               ("ENBWREN", None),       # Write enable or enable for port B
               ("WEBWE", None),         # Four byte-write enables for port B or 8 byte-write enables for write port
               ("DOUTBDOUT", None),     # 32-bit data out for port B or read data
               ("DOUTPBDOUTP", None),   # 4-bit data out for port B or read

               ("ECCPIPECE", None),     # Enable for ECC pipe
               ("INJECTDBITERR", None), # Inject data bit errror
               ("INJECTSBITERR", None), # Inject syndrome bit error
               ("DBITERR", None),       # ECC double bit error
               ("SBITERR", None),       # ECC single bit error
               ("ECCPARITY", None),     # 8-bits
               ("RDADDRECC", None),     # 9-bits

               ("CASDIMUXA", None),        # Cascade port A (use CASDINA when high)
               ("CASDINA", None),          # Cascade port A data 32
               ("CASDINPA", None),         # Cascade port A parity 4
               ("CASDOMUXA", None),        # Cascade port A (use CASDINA when high)
               ("CASDOMUXEN_A", None),     # Cascade port A unregistered output data register enable
               ("CASDOREGIMUXA", None),    # Cascade port A
               ("CASDOREGIMUXEN_A", None), # Cascade port A
               ("CASDOUTA", None),         # Cascade port A data 32
               ("CASDOUTPA", None),        # Cascade port A parity 4

               ("CASDIMUXB", None),        # Cascade port B (use CASDINA when high)
               ("CASDINB", None),          # Cascade port B data 32
               ("CASDINPB", None),         # Cascade port B parity 4
               ("CASDOMUXB", None),        # Cascade port B (use CASDINA when high)
               ("CASDOMUXEN_B", None),     # Cascade port B unregistered output data register enable
               ("CASDOREGIMUXB", None),    # Cascade port B
               ("CASDOREGIMUXEN_B", None), # Cascade port B
               ("CASDOUTB", None),         # Cascade port B data 32
               ("CASDOUTPB", None),        # Cascade port B parity 4
    ]

#a Toplevel
#f PLL
p = mmcme3_base("pll_i",
                parameters={"CLKIN1_PERIOD":3.33, # 300MHz in
                            "DIVCLK_DIVIDE":1,
                            "CLKFBOUT_MULT_F":3,  # FB @ 900MHz
                            "CLKOUT0_DIVIDE_F":4, # clk0 @ 225MHz
                            "CLKOUT1_DIVIDE":6,   # clk1 @ 150MHz
                            "CLKOUT2_DIVIDE":9,   # clk2 @ 100MHz
                            "CLKOUT3_DIVIDE":18,  # clk3 @ 50MHz
                },
                signals = {"RST":"rst",
                           "PWRDWN":"0",
                           "CLKOUT0":"outclk_225",
                           "CLKOUT1":"outclk_150",
                           "CLKOUT2":"outclk_100",
                           "CLKOUT3":"outclk_50",
                           "LOCKED":"locked",
                           "CLKIN1":"refclk",
                           "CLKFBOUT":"clk_fb",
                           "CLKFBIN":"clk_fb",
                           }
                )
p.output_verilog(sys.stdout)

#f Four BSRAMs as 4kx32 with byte write enables - by using one RAM per byte
for i in range(4):
    p = ramb36e2("ram%d"%i,
                parameters={"DOA_REG":0,
                            "READ_WIDTH_A":9,
                            "WRITE_WIDTH_A":9,
                },
                signals = {"CLKARDCLK":"sram_clk",
                           "ENARDEN":"sram_clk__en && select",
                           "ADDRARDADDR":"{2'b0,address}",
                           "WEA":"{3'b0,write_enable[%d] && !read_not_write}"%i,
                           "DINADIN":"{24'b0,write_data[%d:%d]}"%((i*8+7),(i*8)),
                           "DOUTADOUT":"read_data_mem[%d]"%i,
                           }
                )
    p.output_verilog(sys.stdout)

