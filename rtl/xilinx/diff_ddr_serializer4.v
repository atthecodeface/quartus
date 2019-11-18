module diff_ddr_serializer4( input       clk,
                             input       clk__enable,
                             input       clk_div2,
                             input       clk_div2__enable,
                             input       reset_n,
                             input [3:0] data,
                             output      pin__p,
                             output      pin__n);

    wire reset = !reset_n;
    (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
    FDPE  #(
        .INIT(1) // Reset value of serial output
    ) reset_sync_0 (
        .PRE (reset),
        .C (clk_div2),
        .CE (1),
        .D (reset),
        .Q (reset__0)
    );
    (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
    FDPE  #(
        .INIT(1) // Reset value of serial output
    ) reset_sync_1 (
        .PRE (reset),
        .C (clk_div2),
        .CE (1),
        .D (reset__0),
        .Q (reset__1)
    );
    (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
    FDPE  #(
        .INIT(1) // Reset value of serial output
    ) reset_sync_2 (
        .PRE (reset),
        .C (clk_div2),
        .CE (1),
        .D (reset__1),
        .Q (reset__2)
    );
    (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
    FDPE  #(
        .INIT(1) // Reset value of serial output
    ) reset_sync_3 (
        .PRE (0),
        .C (clk_div2),
        .CE (1),
        .D (reset__2),
        .Q (reset__sync_clk_div2)
    );
    OSERDESE3  #(
        .DATA_WIDTH(4) // Width of parallel data
    ) serializer (
        .RST (reset__sync_clk_div2),
        .CLK (clk),
        .CLKDIV (clk_div2),
        .D ({4'b0, data}),
        .T (0),
        .OQ (serial_data)
    );
    OBUFDS  diff_io (
        .I (serial_data),
        .O (pin__p),
        .OB (pin__n)
    );

endmodule
