module tech_sync_bit
(
    clk,
    clk__enable,

    d,
    reset_n,

    q
);

    //b Clocks
        //   Clock to synchronize to
    input clk;
    input clk__enable;

    //b Inputs
        //   Data in
    input d;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Data out
    output q;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg s;
    reg q;

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b logic clock process
    always @( posedge clk or negedge reset_n)
    begin : logic__code
        if (reset_n==1'b0)
        begin
            s <= 1'h0;
            q <= 1'h0;
        end
        else if (clk__enable)
        begin
            s <= d;
            q <= s;
        end //if
    end //always

endmodule // tech_sync_bit
module tech_sync_flop
(
    clk,
    clk__enable,

    d,
    reset_n,

    q
);

    //b Clocks
        //   Clock to synchronize to
    input clk;
    input clk__enable;

    //b Inputs
        //   Data in
    input d;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Data out
    output q;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg q;

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b logic clock process
    always @( posedge clk or negedge reset_n)
    begin : logic__code
        if (reset_n==1'b0)
        begin
            q <= 1'h0;
        end
        else if (clk__enable)
        begin
            q <= d;
        end //if
    end //always

endmodule // tech_sync_flop
