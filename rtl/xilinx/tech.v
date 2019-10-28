module tech_sync_flop( input       clk,
                      input        clk__enable,
                      input        reset_n,
                      input        d,
                      output       q
                               );
    (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
    FDCE  #(
        .INIT(0),
        .IS_CLR_INVERTED(1)
    ) flop (
        .R (reset_n),
        .C (clk),
        .CE (clk__enable),
        .D (d),
        .Q (q)
    );
endmodule // tech_sync_flop

module tech_sync_bit( input       clk,
                      input        clk__enable,
                      input        reset_n,
                      input        d,
                      output       q
                               );
    (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
    FDCE  #(
        .INIT(0),
        .IS_CLR_INVERTED(1)
    ) flop_0 (
        .CLR (reset_n),
        .C (clk),
        .CE (clk__enable),
        .D (d),
        .Q (s)
    );
    (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
    FDCE  #(
        .INIT(0),
        .IS_CLR_INVERTED(1)
    ) flop_1 (
        .CLR (reset_n),
        .C (clk),
        .CE (clk__enable),
        .D (s),
        .Q (q)
    );
endmodule // tech_sync_bit

