module diff_ddr_deserializer4( input       clk,
                               input        clk_div2,
                               input        clk_delay,
                               input        reset,
                               input        pin__p,
                               input        pin__n,
                               input[1:0]   delay_config__op,
                               input        delay_config__select,
                               input[8:0]   delay_config__value,
                               output [3:0] data,
                               output [3:0] tracker
                               );
   wire [7:0] data_out;
   wire [7:0] tracker_out;
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


    (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
    FDPE  #(
        .INIT(1) // Reset value of serial output
    ) reset_sync_0b (
        .PRE (reset),
        .C (clk_delay),
        .CE (1),
        .D (reset),
        .Q (reset__0b)
    );
    (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
    FDPE  #(
        .INIT(1) // Reset value of serial output
    ) reset_sync_1b (
        .PRE (reset),
        .C (clk_delay),
        .CE (1),
        .D (reset__0b),
        .Q (reset__1b)
    );
    (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
    FDPE  #(
        .INIT(1) // Reset value of serial output
    ) reset_sync_2b (
        .PRE (reset),
        .C (clk_delay),
        .CE (1),
        .D (reset__1b),
        .Q (reset__2b)
    );
    (*  ASYNC_REG = "TRUE",  shreg_extract = "no"   *)
    FDPE  #(
        .INIT(1) // Reset value of serial output
    ) reset_sync_3b (
        .PRE (0),
        .C (clk_delay),
        .CE (1),
        .D (reset__2b),
        .Q (reset__sync_clk_delay)
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
        .RST (reset__sync_clk_delay),
        .CLK (clk_delay),
        .DATAOUT (data_delayed),
        .CE ((delay_config__op[1]) && (delay_config__select==0)),
        .INC ((!delay_config__op[0]) && (delay_config__select==0)),
        .LOAD ((delay_config__op==1) && (delay_config__select==0)),
        .CNTVALUEIN (delay_config__value),
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
        .RST (reset__sync_clk_delay),
        .CLK (clk_delay),
        .DATAOUT (tracker_delayed),
        .CE ((delay_config__op[1]) && (delay_config__select==1)),
        .INC ((!delay_config__op[0]) && (delay_config__select==1)),
        .LOAD ((delay_config__op==1) && (delay_config__select==1)),
        .CNTVALUEIN (delay_config__value),
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
