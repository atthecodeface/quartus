//a Note: created by CDL 1.4 - do not hand edit without recognizing it will be out of sync with the source
// Output mode 0 (VMOD=1, standard verilog=0)
// Verilog option comb reg suffix '__var'
// Verilog option include_displays 0
// Verilog option include_assertions 1
// Verilog option sv_assertions 0
// Verilog option assert delay string '<NULL>'
// Verilog option include_coverage 0
// Verilog option clock_gate_module_instance_type 'banana'
// Verilog option clock_gate_module_instance_extra_ports ''
// Verilog option use_always_at_star 1
// Verilog option clocks_must_have_enables 1

//a Module apb_target_ps2_host
    //   
    //   
    //   
module apb_target_ps2_host
(
    clk,
    clk__enable,

    ps2_in__data,
    ps2_in__clk,
    apb_request__paddr,
    apb_request__penable,
    apb_request__psel,
    apb_request__pwrite,
    apb_request__pwdata,
    reset_n,

    ps2_out__data,
    ps2_out__clk,
    apb_response__prdata,
    apb_response__pready,
    apb_response__perr
);

    //b Clocks
        //   System clock
    input clk;
    input clk__enable;

    //b Inputs
        //   Pin values from the outside
    input ps2_in__data;
    input ps2_in__clk;
        //   APB request
    input [31:0]apb_request__paddr;
    input apb_request__penable;
    input apb_request__psel;
    input apb_request__pwrite;
    input [31:0]apb_request__pwdata;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Pin values to drive - 1 means float high, 0 means pull low
    output ps2_out__data;
    output ps2_out__clk;
        //   APB response
    output [31:0]apb_response__prdata;
    output apb_response__pready;
    output apb_response__perr;

// output components here

    //b Output combinatorials
        //   APB response
    reg [31:0]apb_response__prdata;
    reg apb_response__pready;
    reg apb_response__perr;

    //b Output nets
        //   Pin values to drive - 1 means float high, 0 means pull low
    wire ps2_out__data;
    wire ps2_out__clk;

    //b Internal and output registers
    reg [7:0]fifo[7:0];
    reg ps2_state__full;
    reg ps2_state__empty;
    reg ps2_state__underflow;
    reg ps2_state__overflow;
    reg ps2_state__protocol_error;
    reg ps2_state__parity_error;
    reg ps2_state__timeout;
    reg [2:0]ps2_state__fifo_rptr;
    reg [2:0]ps2_state__fifo_wptr;
    reg [7:0]ps2_state__rx_data;
    reg [15:0]ps2_state__divider_3us;
        //   Access being performed by APB
    reg [2:0]access;

    //b Internal combinatorials

    //b Internal nets
    wire ps2_rx_data__valid;
    wire [7:0]ps2_rx_data__data;
    wire ps2_rx_data__parity_error;
    wire ps2_rx_data__protocol_error;
    wire ps2_rx_data__timeout;

    //b Clock gating module instances
    //b Module instances
    ps2_host ps2_if(
        .clk(clk),
        .clk__enable(1'b1),
        .divider(ps2_state__divider_3us),
        .ps2_in__clk(ps2_in__clk),
        .ps2_in__data(ps2_in__data),
        .reset_n(reset_n),
        .ps2_rx_data__timeout(            ps2_rx_data__timeout),
        .ps2_rx_data__protocol_error(            ps2_rx_data__protocol_error),
        .ps2_rx_data__parity_error(            ps2_rx_data__parity_error),
        .ps2_rx_data__data(            ps2_rx_data__data),
        .ps2_rx_data__valid(            ps2_rx_data__valid),
        .ps2_out__clk(            ps2_out__clk),
        .ps2_out__data(            ps2_out__data)         );
    //b apb_interface_logic__comb combinatorial process
        //   
        //       The APB interface is decoded to @a access when @p psel is asserted
        //       and @p penable is deasserted - this is the first cycle of an APB
        //       access. This permits the access type to be registered, so that the
        //       APB @p prdata can be driven from registers, and so that writes
        //       will occur correctly when @p penable is asserted.
        //   
        //       The APB read data @p prdata can then be generated based on @a
        //       access.
        //       
    always @ ( * )//apb_interface_logic__comb
    begin: apb_interface_logic__comb_code
    reg [31:0]apb_response__prdata__var;
    reg apb_response__pready__var;
        apb_response__prdata__var = 32'h0;
        apb_response__pready__var = 1'h0;
        apb_response__perr = 1'h0;
        apb_response__pready__var = 1'h1;
        case (access) //synopsys parallel_case
        3'h2: // req 1
            begin
            apb_response__prdata__var = {{{{{{{{{{{ps2_state__divider_3us,1'h0},ps2_state__fifo_wptr},1'h0},ps2_state__fifo_rptr},2'h0},ps2_state__full},ps2_state__empty},ps2_state__overflow},ps2_state__timeout},ps2_state__protocol_error},ps2_state__parity_error};
            end
        3'h3: // req 1
            begin
            apb_response__prdata__var = {{ps2_state__empty,23'h0},ps2_state__rx_data};
            end
        //synopsys  translate_off
        //pragma coverage off
        //synopsys  translate_on
        default:
            begin
            //Need a default case to make Cadence Lint happy, even though this is not a full case
            end
        //synopsys  translate_off
        //pragma coverage on
        //synopsys  translate_on
        endcase
        apb_response__prdata = apb_response__prdata__var;
        apb_response__pready = apb_response__pready__var;
    end //always

    //b apb_interface_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The APB interface is decoded to @a access when @p psel is asserted
        //       and @p penable is deasserted - this is the first cycle of an APB
        //       access. This permits the access type to be registered, so that the
        //       APB @p prdata can be driven from registers, and so that writes
        //       will occur correctly when @p penable is asserted.
        //   
        //       The APB read data @p prdata can then be generated based on @a
        //       access.
        //       
    always @( posedge clk or negedge reset_n)
    begin : apb_interface_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            access <= 3'h0;
        end
        else if (clk__enable)
        begin
            access <= 3'h0;
            case (apb_request__paddr[2:0]) //synopsys parallel_case
            3'h0: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h1:3'h2);
                end
            3'h1: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h0:3'h3);
                end
            //synopsys  translate_off
            //pragma coverage off
            //synopsys  translate_on
            default:
                begin
                //Need a default case to make Cadence Lint happy, even though this is not a full case
                end
            //synopsys  translate_off
            //pragma coverage on
            //synopsys  translate_on
            endcase
            if ((!(apb_request__psel!=1'h0)||(apb_request__penable!=1'h0)))
            begin
                access <= 3'h0;
            end //if
        end //if
    end //always

    //b input_logic clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : input_logic__code
        if (reset_n==1'b0)
        begin
            ps2_state__divider_3us <= 16'h0;
            ps2_state__fifo_rptr <= 3'h0;
            ps2_state__fifo_wptr <= 3'h0;
            ps2_state__full <= 1'h0;
            ps2_state__empty <= 1'h0;
            ps2_state__empty <= 1'h1;
            ps2_state__parity_error <= 1'h0;
            ps2_state__protocol_error <= 1'h0;
            ps2_state__timeout <= 1'h0;
            ps2_state__overflow <= 1'h0;
            ps2_state__underflow <= 1'h0;
            fifo[0] <= 8'h0;
            fifo[1] <= 8'h0;
            fifo[2] <= 8'h0;
            fifo[3] <= 8'h0;
            fifo[4] <= 8'h0;
            fifo[5] <= 8'h0;
            fifo[6] <= 8'h0;
            fifo[7] <= 8'h0;
            ps2_state__rx_data <= 8'h0;
        end
        else if (clk__enable)
        begin
            if ((access==3'h1))
            begin
                ps2_state__divider_3us <= apb_request__pwdata[31:16];
                ps2_state__fifo_rptr <= 3'h0;
                ps2_state__fifo_wptr <= 3'h0;
                ps2_state__full <= 1'h0;
                ps2_state__empty <= 1'h1;
            end //if
            if (((access==3'h2)||(access==3'h1)))
            begin
                ps2_state__parity_error <= 1'h0;
                ps2_state__protocol_error <= 1'h0;
                ps2_state__timeout <= 1'h0;
                ps2_state__overflow <= 1'h0;
                ps2_state__underflow <= 1'h0;
            end //if
            if ((access==3'h3))
            begin
                if ((ps2_state__empty!=1'h0))
                begin
                    ps2_state__underflow <= 1'h1;
                end //if
                else
                
                begin
                    ps2_state__full <= 1'h0;
                    ps2_state__fifo_rptr <= (ps2_state__fifo_rptr+3'h1);
                    if (((ps2_state__fifo_rptr+3'h1)==ps2_state__fifo_wptr))
                    begin
                        ps2_state__empty <= 1'h1;
                    end //if
                end //else
            end //if
            if ((ps2_rx_data__valid!=1'h0))
            begin
                if ((ps2_rx_data__parity_error!=1'h0))
                begin
                    ps2_state__parity_error <= 1'h1;
                end //if
                if ((ps2_rx_data__protocol_error!=1'h0))
                begin
                    ps2_state__protocol_error <= 1'h1;
                end //if
                if ((ps2_rx_data__timeout!=1'h0))
                begin
                    ps2_state__timeout <= 1'h1;
                end //if
                if (((!(ps2_rx_data__parity_error!=1'h0)&&!(ps2_rx_data__protocol_error!=1'h0))&&!(ps2_rx_data__timeout!=1'h0)))
                begin
                    if ((ps2_state__full!=1'h0))
                    begin
                        ps2_state__overflow <= 1'h1;
                    end //if
                    else
                    
                    begin
                        fifo[ps2_state__fifo_wptr] <= ps2_rx_data__data;
                        ps2_state__fifo_wptr <= (ps2_state__fifo_wptr+3'h1);
                        ps2_state__empty <= 1'h0;
                        ps2_state__full <= ((ps2_state__fifo_wptr+3'h1)==ps2_state__fifo_rptr);
                    end //else
                end //if
            end //if
            ps2_state__rx_data <= fifo[ps2_state__fifo_rptr];
        end //if
    end //always

endmodule // apb_target_ps2_host
