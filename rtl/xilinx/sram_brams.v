module bram__se_sram_srw_4096x32_we8 ( input          sram_clock,
                                       input          sram_clock__enable,
                                       input  [ 3:0]  write_enable,
                                       input  [31:0]  write_data,
                                       input          read_not_write,
                                       input          select,
                                       input  [11:0]  address,
                                       output [31:0]  data_out
);
    parameter address_width=12;
    parameter initfile="";
    parameter data_width=32;
    wire [31:0]  read_data_mem[3:0];
    assign data_out[23:16] = read_data_mem[2][7:0];
    assign data_out[ 7: 0] = read_data_mem[0][7:0];
    assign data_out[31:24] = read_data_mem[3][7:0];
    assign data_out[15: 8] = read_data_mem[1][7:0];
    (*  ram_addr_end = "4095",  ram_slice_end = "7",  ram_slice_begin = "0",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_0 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[7:0]}),
        .ENARDEN (sram_clock__enable && select),
        .WEA ({3'b0,write_enable[0] && !read_not_write}),
        .DOUTADOUT (read_data_mem[0]),
        .CLKBWRCLK (0),
        .WEBWE (0)
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "15",  ram_slice_begin = "8",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_1 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[15:8]}),
        .ENARDEN (sram_clock__enable && select),
        .WEA ({3'b0,write_enable[1] && !read_not_write}),
        .DOUTADOUT (read_data_mem[1]),
        .CLKBWRCLK (0),
        .WEBWE (0)
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "23",  ram_slice_begin = "16",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_2 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[23:16]}),
        .ENARDEN (sram_clock__enable && select),
        .WEA ({3'b0,write_enable[2] && !read_not_write}),
        .DOUTADOUT (read_data_mem[2]),
        .CLKBWRCLK (0),
        .WEBWE (0)
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "31",  ram_slice_begin = "24",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_3 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[31:24]}),
        .ENARDEN (sram_clock__enable && select),
        .WEA ({3'b0,write_enable[3] && !read_not_write}),
        .DOUTADOUT (read_data_mem[3]),
        .CLKBWRCLK (0),
        .WEBWE (0)
    );
endmodule

module bram__se_sram_srw_16384x32_we8_onlt_16kB ( input          sram_clock,
                                       input          sram_clock__enable,
                                       input  [ 3:0]  write_enable,
                                       input  [31:0]  write_data,
                                       input          read_not_write,
                                       input          select,
                                       input  [13:0]  address,
                                       output [31:0]  data_out
);
    parameter address_width=12;
    parameter initfile="";
    parameter data_width=32;
    wire [31:0]  read_data_mem[3:0];
    assign data_out[23:16] = read_data_mem[2][7:0];
    assign data_out[ 7: 0] = read_data_mem[0][7:0];
    assign data_out[31:24] = read_data_mem[3][7:0];
    assign data_out[15: 8] = read_data_mem[1][7:0];
    (*  ram_addr_end = "4095",  ram_slice_end = "7",  ram_slice_begin = "0",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_0 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[7:0]}),
        .ENARDEN (sram_clock__enable && select),
        .WEA ({3'b0,write_enable[0] && !read_not_write}),
        .DOUTADOUT (read_data_mem[0]),
        .CLKBWRCLK (0),
        .WEBWE (0)
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "15",  ram_slice_begin = "8",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_1 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[15:8]}),
        .ENARDEN (sram_clock__enable && select),
        .WEA ({3'b0,write_enable[1] && !read_not_write}),
        .DOUTADOUT (read_data_mem[1]),
        .CLKBWRCLK (0),
        .WEBWE (0)
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "23",  ram_slice_begin = "16",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_2 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[23:16]}),
        .ENARDEN (sram_clock__enable && select),
        .WEA ({3'b0,write_enable[2] && !read_not_write}),
        .DOUTADOUT (read_data_mem[2]),
        .CLKBWRCLK (0),
        .WEBWE (0)
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "31",  ram_slice_begin = "24",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_3 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[31:24]}),
        .ENARDEN (sram_clock__enable && select),
        .WEA ({3'b0,write_enable[3] && !read_not_write}),
        .DOUTADOUT (read_data_mem[3]),
        .CLKBWRCLK (0),
        .WEBWE (0)
    );
endmodule

module bram__se_sram_srw_16384x32_we8 ( input          sram_clock,
                                        input          sram_clock__enable,
                                        input  [ 3:0]  write_enable,
                                        input  [31:0]  write_data,
                                        input          read_not_write,
                                        input          select,
                                        input  [13:0]  address,
                                        output [31:0]  data_out
);
    parameter address_width=14;
    parameter initfile="";
    parameter data_width=32;
    wire [31:0]  read_data_mem[15:0];
    wire [ 3:0]  word_sel;
    wire [ 3:0]  casc_data_out_p[19:0];
    wire [31:0]  casc_data_out[19:0];
    assign casc_data_out_p[18] = 0;
    assign casc_data_out[16] = 0;
    assign word_sel[3] = (address[13:12]==3) && select;
    assign casc_data_out_p[17] = 0;
    assign casc_data_out_p[16] = 0;
    assign casc_data_out[17] = 0;
    assign data_out[23:16] = read_data_mem[2][7:0];
    assign data_out[ 7: 0] = read_data_mem[0][7:0];
    assign casc_data_out_p[19] = 0;
    assign word_sel[0] = (address[13:12]==0) && select;
    assign data_out[31:24] = read_data_mem[3][7:0];
    assign word_sel[2] = (address[13:12]==2) && select;
    assign casc_data_out[18] = 0;
    assign word_sel[1] = (address[13:12]==1) && select;
    assign data_out[15: 8] = read_data_mem[1][7:0];
    assign casc_data_out[19] = 0;
    (*  ram_addr_end = "4095",  ram_slice_end = "7",  ram_slice_begin = "0",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("LAST"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_0_0 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[7:0]}),
        .ENARDEN (sram_clock__enable && word_sel[0]),
        .WEA ({3'b0,write_enable[0] && !read_not_write && word_sel[0]}),
        .DOUTADOUT (read_data_mem[0]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[4]),
        .CASDINPA (casc_data_out_p[4]),
        .CASDOMUXA (!word_sel[0]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[0]),
        .CASDOUTPA (casc_data_out_p[0])
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "15",  ram_slice_begin = "8",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("LAST"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_0_1 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[15:8]}),
        .ENARDEN (sram_clock__enable && word_sel[0]),
        .WEA ({3'b0,write_enable[1] && !read_not_write && word_sel[0]}),
        .DOUTADOUT (read_data_mem[1]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[5]),
        .CASDINPA (casc_data_out_p[5]),
        .CASDOMUXA (!word_sel[0]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[1]),
        .CASDOUTPA (casc_data_out_p[1])
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "23",  ram_slice_begin = "16",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("LAST"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_0_2 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[23:16]}),
        .ENARDEN (sram_clock__enable && word_sel[0]),
        .WEA ({3'b0,write_enable[2] && !read_not_write && word_sel[0]}),
        .DOUTADOUT (read_data_mem[2]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[6]),
        .CASDINPA (casc_data_out_p[6]),
        .CASDOMUXA (!word_sel[0]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[2]),
        .CASDOUTPA (casc_data_out_p[2])
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "31",  ram_slice_begin = "24",  ram_addr_begin = "0"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("LAST"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_0_3 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[31:24]}),
        .ENARDEN (sram_clock__enable && word_sel[0]),
        .WEA ({3'b0,write_enable[3] && !read_not_write && word_sel[0]}),
        .DOUTADOUT (read_data_mem[3]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[7]),
        .CASDINPA (casc_data_out_p[7]),
        .CASDOMUXA (!word_sel[0]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[3]),
        .CASDOUTPA (casc_data_out_p[3])
    );
    (*  ram_addr_end = "8191",  ram_slice_end = "7",  ram_slice_begin = "0",  ram_addr_begin = "4096"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("MIDDLE"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_1_0 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[7:0]}),
        .ENARDEN (sram_clock__enable && word_sel[1]),
        .WEA ({3'b0,write_enable[0] && !read_not_write && word_sel[1]}),
        .DOUTADOUT (read_data_mem[4]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[8]),
        .CASDINPA (casc_data_out_p[8]),
        .CASDOMUXA (!word_sel[1]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[4]),
        .CASDOUTPA (casc_data_out_p[4])
    );
    (*  ram_addr_end = "8191",  ram_slice_end = "15",  ram_slice_begin = "8",  ram_addr_begin = "4096"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("MIDDLE"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_1_1 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[15:8]}),
        .ENARDEN (sram_clock__enable && word_sel[1]),
        .WEA ({3'b0,write_enable[1] && !read_not_write && word_sel[1]}),
        .DOUTADOUT (read_data_mem[5]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[9]),
        .CASDINPA (casc_data_out_p[9]),
        .CASDOMUXA (!word_sel[1]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[5]),
        .CASDOUTPA (casc_data_out_p[5])
    );
    (*  ram_addr_end = "8191",  ram_slice_end = "23",  ram_slice_begin = "16",  ram_addr_begin = "4096"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("MIDDLE"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_1_2 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[23:16]}),
        .ENARDEN (sram_clock__enable && word_sel[1]),
        .WEA ({3'b0,write_enable[2] && !read_not_write && word_sel[1]}),
        .DOUTADOUT (read_data_mem[6]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[10]),
        .CASDINPA (casc_data_out_p[10]),
        .CASDOMUXA (!word_sel[1]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[6]),
        .CASDOUTPA (casc_data_out_p[6])
    );
    (*  ram_addr_end = "8191",  ram_slice_end = "31",  ram_slice_begin = "24",  ram_addr_begin = "4096"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("MIDDLE"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_1_3 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[31:24]}),
        .ENARDEN (sram_clock__enable && word_sel[1]),
        .WEA ({3'b0,write_enable[3] && !read_not_write && word_sel[1]}),
        .DOUTADOUT (read_data_mem[7]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[11]),
        .CASDINPA (casc_data_out_p[11]),
        .CASDOMUXA (!word_sel[1]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[7]),
        .CASDOUTPA (casc_data_out_p[7])
    );
    (*  ram_addr_end = "12287",  ram_slice_end = "7",  ram_slice_begin = "0",  ram_addr_begin = "8192"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("MIDDLE"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_2_0 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[7:0]}),
        .ENARDEN (sram_clock__enable && word_sel[2]),
        .WEA ({3'b0,write_enable[0] && !read_not_write && word_sel[2]}),
        .DOUTADOUT (read_data_mem[8]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[12]),
        .CASDINPA (casc_data_out_p[12]),
        .CASDOMUXA (!word_sel[2]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[8]),
        .CASDOUTPA (casc_data_out_p[8])
    );
    (*  ram_addr_end = "12287",  ram_slice_end = "15",  ram_slice_begin = "8",  ram_addr_begin = "8192"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("MIDDLE"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_2_1 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[15:8]}),
        .ENARDEN (sram_clock__enable && word_sel[2]),
        .WEA ({3'b0,write_enable[1] && !read_not_write && word_sel[2]}),
        .DOUTADOUT (read_data_mem[9]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[13]),
        .CASDINPA (casc_data_out_p[13]),
        .CASDOMUXA (!word_sel[2]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[9]),
        .CASDOUTPA (casc_data_out_p[9])
    );
    (*  ram_addr_end = "12287",  ram_slice_end = "23",  ram_slice_begin = "16",  ram_addr_begin = "8192"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("MIDDLE"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_2_2 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[23:16]}),
        .ENARDEN (sram_clock__enable && word_sel[2]),
        .WEA ({3'b0,write_enable[2] && !read_not_write && word_sel[2]}),
        .DOUTADOUT (read_data_mem[10]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[14]),
        .CASDINPA (casc_data_out_p[14]),
        .CASDOMUXA (!word_sel[2]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[10]),
        .CASDOUTPA (casc_data_out_p[10])
    );
    (*  ram_addr_end = "12287",  ram_slice_end = "31",  ram_slice_begin = "24",  ram_addr_begin = "8192"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("MIDDLE"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_2_3 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[31:24]}),
        .ENARDEN (sram_clock__enable && word_sel[2]),
        .WEA ({3'b0,write_enable[3] && !read_not_write && word_sel[2]}),
        .DOUTADOUT (read_data_mem[11]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[15]),
        .CASDINPA (casc_data_out_p[15]),
        .CASDOMUXA (!word_sel[2]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[11]),
        .CASDOUTPA (casc_data_out_p[11])
    );
    (*  ram_addr_end = "16383",  ram_slice_end = "7",  ram_slice_begin = "0",  ram_addr_begin = "12288"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("FIRST"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_3_0 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[7:0]}),
        .ENARDEN (sram_clock__enable && word_sel[3]),
        .WEA ({3'b0,write_enable[0] && !read_not_write && word_sel[3]}),
        .DOUTADOUT (read_data_mem[12]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[16]),
        .CASDINPA (casc_data_out_p[16]),
        .CASDOMUXA (!word_sel[3]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[12]),
        .CASDOUTPA (casc_data_out_p[12])
    );
    (*  ram_addr_end = "16383",  ram_slice_end = "15",  ram_slice_begin = "8",  ram_addr_begin = "12288"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("FIRST"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_3_1 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[15:8]}),
        .ENARDEN (sram_clock__enable && word_sel[3]),
        .WEA ({3'b0,write_enable[1] && !read_not_write && word_sel[3]}),
        .DOUTADOUT (read_data_mem[13]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[17]),
        .CASDINPA (casc_data_out_p[17]),
        .CASDOMUXA (!word_sel[3]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[13]),
        .CASDOUTPA (casc_data_out_p[13])
    );
    (*  ram_addr_end = "16383",  ram_slice_end = "23",  ram_slice_begin = "16",  ram_addr_begin = "12288"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("FIRST"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_3_2 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[23:16]}),
        .ENARDEN (sram_clock__enable && word_sel[3]),
        .WEA ({3'b0,write_enable[2] && !read_not_write && word_sel[3]}),
        .DOUTADOUT (read_data_mem[14]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[18]),
        .CASDINPA (casc_data_out_p[18]),
        .CASDOMUXA (!word_sel[3]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[14]),
        .CASDOUTPA (casc_data_out_p[14])
    );
    (*  ram_addr_end = "16383",  ram_slice_end = "31",  ram_slice_begin = "24",  ram_addr_begin = "12288"   *)
    RAMB36E2  #(
        .CASCADE_ORDER_A("FIRST"), // Order of cascade - first is bottom
        .DOA_REG(0), // Output register for port A
        .ENADDRENA("FALSE"), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram_3_3 (
        .SLEEP (0),
        .RSTRAMARSTRAM (0),
        .RSTRAMB (0),
        .CLKARDCLK (sram_clock),
        .ADDRARDADDR ({address[11:0],3'b0}),
        .DINADIN ({24'b0,write_data[31:24]}),
        .ENARDEN (sram_clock__enable && word_sel[3]),
        .WEA ({3'b0,write_enable[3] && !read_not_write && word_sel[3]}),
        .DOUTADOUT (read_data_mem[15]),
        .CLKBWRCLK (0),
        .WEBWE (0),
        .CASDIMUXA (0),
        .CASDINA (casc_data_out[19]),
        .CASDINPA (casc_data_out_p[19]),
        .CASDOMUXA (!word_sel[3]),
        .CASDOMUXEN_A (sram_clock__enable),
        .CASDOUTA (casc_data_out[15]),
        .CASDOUTPA (casc_data_out_p[15])
    );
endmodule
