module cascaded_delay_pair( input       clk,
                            input       reset,
                            input       delay__load,
                            input [8:0] delay__value,
                            input       data_in,
                            output      data_out);

    IDELAYE3  #(
        .DELAY_TYPE("VAR_LOAD"), // Delay to use - if variable then CE, LOAD and INC are used
        .DELAY_VALUE(0), // Delay if fixed (in psec if DELAY_FORMAT is TIME else taps). Up to 512 if taps.
        .DELAY_FORMAT("COUNT"), // If TIME then REFCLK_FREQUENCY is used to determine initial taps; if COUNT then DELAY_VALUE is in taps
        .UPDATE_MODE("ASYNC"), // ASYNC is preferred - MANUAL requires two toggles of load (one to capture the value, one to make it happen)
        .CASCADE("MASTER"), // Cascading - and where in the chain it is
        .DELAY_SRC("DATAIN") // Source of data - IOB or internal signal
    ) idelay (
        .RST (reset),
        .CLK (clk),
        .DATAOUT (data_out),
        .CE (0),
        .INC (0),
        .LOAD (delay__load),
        .CNTVALUEIN (delay__value),
        .EN_VTC (0),
        .CASC_IN (0),
        .CASC_OUT (casc_to_odelay),
        .CASC_RETURN (casc_to_idelay),
        .DATAIN (data_in),
        .IDATAIN (0)
    );
    ODELAYE3  #(
        .DELAY_TYPE("VAR_LOAD"), // Delay to use - if variable then CE, LOAD and INC are used
        .DELAY_VALUE(0), // Delay if fixed (in psec if DELAY_FORMAT is TIME else taps). Up to 512 if taps.
        .DELAY_FORMAT("COUNT"), // If TIME then REFCLK_FREQUENCY is used to determine initial taps; if COUNT then DELAY_VALUE is in taps
        .UPDATE_MODE("ASYNC"), // ASYNC is preferred - MANUAL requires two toggles of load (one to capture the value, one to make it happen)
        .CASCADE("SLAVE_END") // Cascading - and where in the chain it is
    ) odelay (
        .RST (reset),
        .CLK (clk),
        .DATAOUT (casc_to_idelay),
        .CE (0),
        .INC (0),
        .LOAD (delay__load),
        .CNTVALUEIN (delay__value),
        .EN_VTC (0),
        .CASC_IN (casc_to_odelay),
        .CASC_RETURN (0),
        .ODATAIN (0)
    );
endmodule
