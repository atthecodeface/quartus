//m se_sram_srw_16384x32_we8
module bram__se_sram_srw_16384x32_we8( sram_clock, sram_clock__enable, write_data, address, write_enable, read_not_write, select, data_out );
    parameter initfile="",address_width=14,data_width=32;
    input sram_clock, sram_clock__enable, select, read_not_write;
    input [3:0]   write_enable;
    input [13:0]  address;
    input [31:0]  write_data;
    output [31:0] data_out;
   wire [31:0]read_data_mem[3:0];
   assign data_out[ 7: 0] = read_data_mem[0][7:0];
   assign data_out[15: 8] = read_data_mem[1][7:0];
   assign data_out[23:16] = read_data_mem[2][7:0];
   assign data_out[31:24] = read_data_mem[3][7:0];
   
    (*  ram_addr_end = "4095",  ram_slice_end = "7",  ram_slice_begin = "0",  ram_addr_begin = "0"   *)
    RAMB36E2 #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA(0), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram0 (
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
        .ADDRARDADDR ({address[11:0],3'b0}),
        .WEBWE (0)
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "15",  ram_slice_begin = "8",  ram_addr_begin = "0"   *)
    RAMB36E2 #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA(0), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram1 (
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
        .ADDRARDADDR ({address[11:0],3'b0}),
        .WEBWE (0)
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "23",  ram_slice_begin = "16",  ram_addr_begin = "0"   *)
    RAMB36E2 #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA(0), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram2 (
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
        .ADDRARDADDR ({address[11:0],3'b0}),
        .WEBWE (0)
    );
    (*  ram_addr_end = "4095",  ram_slice_end = "31",  ram_slice_begin = "24",  ram_addr_begin = "0"   *)
    RAMB36E2 #(
        .DOA_REG(0), // Output register for port A
        .ENADDRENA(0), // Address enable pin for port A
        .READ_WIDTH_A(9), // Read width for port A
        .WRITE_WIDTH_A(9), // Write width for port A
        .DOB_REG(0) // Output register for port B
    ) ram3 (
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
        .ADDRARDADDR ({address[11:0],3'b0}),
        .WEBWE (0)
    );
endmodule // bram__se_sram_srw_16384x32_we8
