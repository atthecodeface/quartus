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

//a Module apb_target_dprintf
    //   
    //   Simple Dprintf requester with an APB interface.
    //   
    //   A dprintf request is an address and, in this case (a @a
    //   t_dprintf_req_4) four 64-bit data words. This is mapped to eight
    //   32-bit data words, with data register 0 mapping to the most
    //   significant word of the @a dprintf_req data 0 (so that data register 0
    //   corresponds to the first text displayed as part of the dprintf).
    //   
    //   The module provides an address register, which is the address
    //   presented in the dprintf request. Usually for a dprintf to a teletext
    //   framebuffer, for example, this is the address of the first character
    //   of the output within the framebuffer.
    //   
    //   The normal operation is to write a number of data registers, starting
    //   with register 0, and then to write to the address register *with
    //   commit* to invoke the dprintf.
    //   
    //   Another method could be to have the address and bulk of the data set
    //   up, and then a single write to a *data with commit* to, for example,
    //   fill out a 32-bit hex value for display, invoking the dprintf (for
    //   example if a dprintf were set up to display 'latest pc %08x', the pc
    //   value can be written to the correct data register with commit).
    //   
    //   The address register can be read back, in which case it has some status also:
    //   
    //   Bits     | Meaning
    //   ---------|---------
    //   31       | dprintf_req valid (i.e. has not been completed by dprintf slave)
    //   15;16    | zero
    //   16;0     | address for dprintf request.
    //   
    //   The top bit of this register is set by a commit and cleared when the
    //   dprintf slave acknowledges the dprintf request.
    //   
    //   For more details on dprintf requests themselves, see the documentation in utils/src/dprintf
    //   
    //   
module apb_target_dprintf
(
    clk,
    clk__enable,

    dprintf_ack,
    apb_request__paddr,
    apb_request__penable,
    apb_request__psel,
    apb_request__pwrite,
    apb_request__pwdata,
    reset_n,

    dprintf_req__valid,
    dprintf_req__address,
    dprintf_req__data_0,
    dprintf_req__data_1,
    dprintf_req__data_2,
    dprintf_req__data_3,
    apb_response__prdata,
    apb_response__pready,
    apb_response__perr
);

    //b Clocks
        //   System clock
    input clk;
    input clk__enable;

    //b Inputs
    input dprintf_ack;
        //   APB request
    input [31:0]apb_request__paddr;
    input apb_request__penable;
    input apb_request__psel;
    input apb_request__pwrite;
    input [31:0]apb_request__pwdata;
        //   Active low reset
    input reset_n;

    //b Outputs
    output dprintf_req__valid;
    output [15:0]dprintf_req__address;
    output [63:0]dprintf_req__data_0;
    output [63:0]dprintf_req__data_1;
    output [63:0]dprintf_req__data_2;
    output [63:0]dprintf_req__data_3;
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

    //b Internal and output registers
        //   Access being performed by APB
    reg [2:0]access;
    reg dprintf_req__valid;
    reg [15:0]dprintf_req__address;
    reg [63:0]dprintf_req__data_0;
    reg [63:0]dprintf_req__data_1;
    reg [63:0]dprintf_req__data_2;
    reg [63:0]dprintf_req__data_3;

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
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
        3'h3: // req 1
            begin
            apb_response__prdata__var = {{dprintf_req__valid,15'h0},dprintf_req__address};
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
            case (apb_request__paddr[4:3]) //synopsys parallel_case
            2'h0: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h1:3'h3);
                end
            2'h2: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h2:3'h3);
                end
            2'h1: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h4:3'h0);
                end
            2'h3: // req 1
                begin
                access <= ((apb_request__pwrite!=1'h0)?3'h5:3'h0);
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

    //b dprintf_req_logic clock process
        //   
        //       The @a dprintf_req is invalidated on an ack; it is written to by an access,
        //       with a commit forcing valid to 1.
        //   
        //       This logic is really just a set of writable registers.
        //       
    always @( posedge clk or negedge reset_n)
    begin : dprintf_req_logic__code
        if (reset_n==1'b0)
        begin
            dprintf_req__valid <= 1'h0;
            dprintf_req__address <= 16'h0;
            dprintf_req__data_0 <= 64'h0;
            dprintf_req__data_1 <= 64'h0;
            dprintf_req__data_2 <= 64'h0;
            dprintf_req__data_3 <= 64'h0;
        end
        else if (clk__enable)
        begin
            if ((dprintf_ack!=1'h0))
            begin
                dprintf_req__valid <= 1'h0;
            end //if
            if (((access==3'h2)||(access==3'h5)))
            begin
                dprintf_req__valid <= 1'h1;
            end //if
            if (((access==3'h1)||(access==3'h2)))
            begin
                dprintf_req__address <= apb_request__pwdata[15:0];
            end //if
            if (((access==3'h4)||(access==3'h5)))
            begin
                case (apb_request__paddr[2:0]) //synopsys parallel_case
                3'h0: // req 1
                    begin
                    dprintf_req__data_0[63:32] <= apb_request__pwdata;
                    end
                3'h1: // req 1
                    begin
                    dprintf_req__data_0[31:0] <= apb_request__pwdata;
                    end
                3'h2: // req 1
                    begin
                    dprintf_req__data_1[63:32] <= apb_request__pwdata;
                    end
                3'h3: // req 1
                    begin
                    dprintf_req__data_1[31:0] <= apb_request__pwdata;
                    end
                3'h4: // req 1
                    begin
                    dprintf_req__data_2[63:32] <= apb_request__pwdata;
                    end
                3'h5: // req 1
                    begin
                    dprintf_req__data_2[31:0] <= apb_request__pwdata;
                    end
                3'h6: // req 1
                    begin
                    dprintf_req__data_3[63:32] <= apb_request__pwdata;
                    end
                3'h7: // req 1
                    begin
                    dprintf_req__data_3[31:0] <= apb_request__pwdata;
                    end
    //synopsys  translate_off
    //pragma coverage off
                default:
                    begin
                        if (1)
                        begin
                            $display("%t *********CDL ASSERTION FAILURE:apb_target_dprintf:dprintf_req_logic: Full switch statement did not cover all values", $time);
                        end
                    end
    //pragma coverage on
    //synopsys  translate_on
                endcase
            end //if
        end //if
    end //always

endmodule // apb_target_dprintf
