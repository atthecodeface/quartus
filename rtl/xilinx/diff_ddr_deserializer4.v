module diff_ddr_deserializer4( input       clk,
                               input        clk_div2,
                               input        reset,
                               input        pin__p,
                               input        pin__n,
                               input        data_delay__load,
                               input[8:0]   data_delay__value,
                               input        tracker_delay__load,
                               input[8:0]   tracker_delay__value,
                               output [3:0] data,
                               output [3:0] tracker
                               );
   assign data    = data_out[3:0];
   assign tracker = tracker_out[3:0];
   
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
    IBUFDS_DIFF_OUT  diff_io (
        .I (pin__p),
        .IB (pin__n),
        .O (data__p),
        .OB (data__n)
    );
    IDELAYE3  #(
        .DELAY_TYPE("VAR_LOAD"), // Delay to use - if variable then CE, LOAD and INC are used
        .DELAY_VALUE(0), // Delay if fixed (in psec if DELAY_FORMAT is TIME else taps). Up to 512 if taps.
        .DELAY_FORMAT("COUNT"), // If TIME then REFCLK_FREQUENCY is used to determine initial taps; if COUNT then DELAY_VALUE is in taps
        .UPDATE_MODE("ASYNC"), // ASYNC is preferred - MANUAL requires two toggles of load (one to capture the value, one to make it happen)
        .CASCADE("NONE"), // Cascading - and where in the chain it is
        .DELAY_SRC("IDATAIN") // Source of data - IOB or internal signal
    ) data_delay (
        .RST (reset__sync_clk_div2),
        .CLK (clk_div2),
        .DATAOUT (data_delayed),
        .CE (0),
        .INC (0),
        .LOAD (data_delay__load),
        .CNTVALUEIN (data_delay__value),
        .EN_VTC (0),
        .CASC_IN (0),
        .CASC_RETURN (0),
        .DATAIN (0),
        .IDATAIN (data__p)
    );
    ISERDESE3  #(
        .DATA_WIDTH(4), // Width of parallel data
        .FIFO_ENABLE("FALSE") // FIFO enable option - if true tie FIFO_RD_EN to !FIFO_EMPTY and FIFO_RD_CLK to CLKDIV
    ) data_deserializer (
        .RST (reset__sync_clk_div2),
        .CLK (clk),
        .CLK_B (~clk),
        .CLKDIV (clk_div2),
        .D (data_delayed),
        .Q (data_out),
        .FIFO_RD_CLK (0),
        .FIFO_RD_EN (0)
    );
    IDELAYE3  #(
        .DELAY_TYPE("VAR_LOAD"), // Delay to use - if variable then CE, LOAD and INC are used
        .DELAY_VALUE(0), // Delay if fixed (in psec if DELAY_FORMAT is TIME else taps). Up to 512 if taps.
        .DELAY_FORMAT("COUNT"), // If TIME then REFCLK_FREQUENCY is used to determine initial taps; if COUNT then DELAY_VALUE is in taps
        .UPDATE_MODE("ASYNC"), // ASYNC is preferred - MANUAL requires two toggles of load (one to capture the value, one to make it happen)
        .CASCADE("NONE"), // Cascading - and where in the chain it is
        .DELAY_SRC("IDATAIN") // Source of data - IOB or internal signal
    ) tracker_delay (
        .RST (reset__sync_clk_div2),
        .CLK (clk_div2),
        .DATAOUT (tracker_delayed),
        .CE (0),
        .INC (0),
        .LOAD (tracker_delay__load),
        .CNTVALUEIN (tracker_delay__value),
        .EN_VTC (0),
        .CASC_IN (0),
        .CASC_RETURN (0),
        .DATAIN (0),
        .IDATAIN (data__n)
    );
    ISERDESE3  #(
        .DATA_WIDTH(4), // Width of parallel data
        .FIFO_ENABLE("FALSE") // FIFO enable option - if true tie FIFO_RD_EN to !FIFO_EMPTY and FIFO_RD_CLK to CLKDIV
    ) tracker_deserializer (
        .RST (reset__sync_clk_div2),
        .CLK (clk),
        .CLK_B (~clk),
        .CLKDIV (clk_div2),
        .D (tracker_delayed),
        .Q (tracker_out),
        .FIFO_RD_CLK (0),
        .FIFO_RD_EN (0)
    );
endmodule
