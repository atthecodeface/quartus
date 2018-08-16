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

//a Module riscv_i32_debug
    //   
    //   This is a RISC-V debug module designed for the RV32I pipelines in the
    //   CDL hardware repo.
    //   
    //   It provides the registers defined in the RISC-V Debug specificaiton
    //   revision 0.13.
    //   
    //   
module riscv_i32_debug
(
    clk,
    clk__enable,

    debug_tgt__valid,
    debug_tgt__selected,
    debug_tgt__halted,
    debug_tgt__resumed,
    debug_tgt__hit_breakpoint,
    debug_tgt__op_was_none,
    debug_tgt__resp,
    debug_tgt__data,
    debug_tgt__attention,
    apb_request__paddr,
    apb_request__penable,
    apb_request__psel,
    apb_request__pwrite,
    apb_request__pwdata,
    reset_n,

    debug_mst__valid,
    debug_mst__select,
    debug_mst__mask,
    debug_mst__op,
    debug_mst__arg,
    debug_mst__data,
    apb_response__prdata,
    apb_response__pready,
    apb_response__perr
);

    //b Clocks
        //   System clock
    input clk;
    input clk__enable;

    //b Inputs
        //   Debug target from PDMs
    input debug_tgt__valid;
    input [5:0]debug_tgt__selected;
    input debug_tgt__halted;
    input debug_tgt__resumed;
    input debug_tgt__hit_breakpoint;
    input debug_tgt__op_was_none;
    input debug_tgt__resp;
    input [31:0]debug_tgt__data;
    input debug_tgt__attention;
        //   APB request
    input [31:0]apb_request__paddr;
    input apb_request__penable;
    input apb_request__psel;
    input apb_request__pwrite;
    input [31:0]apb_request__pwdata;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Debug master to PDMs
    output debug_mst__valid;
    output [5:0]debug_mst__select;
    output [5:0]debug_mst__mask;
    output [3:0]debug_mst__op;
    output [15:0]debug_mst__arg;
    output [31:0]debug_mst__data;
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
    reg [2:0]apb_state__write_action;
    reg [2:0]apb_state__read_select;
    reg debug_state__dmactive;
    reg debug_state__ndmreset;
    reg [5:0]debug_state__hart_sel;
    reg [5:0]debug_state__hart_to_poll;
    reg debug_state__must_set_requests;
    reg debug_state__halt_req;
    reg debug_state__resume_req;
    reg [31:0]debug_state__data0;
    reg [31:0]debug_state__progbuf0;
    reg [63:0]debug_state__halted;
    reg [63:0]debug_state__resumed;
    reg [63:0]debug_state__hit_breakpoint;
    reg debug_mst__valid;
    reg [5:0]debug_mst__select;
    reg [5:0]debug_mst__mask;
    reg [3:0]debug_mst__op;
    reg [15:0]debug_mst__arg;
    reg [31:0]debug_mst__data;

    //b Internal combinatorials
    reg debug_combs__update_status;
    reg debug_combs__dmstatus__impebreak;
    reg debug_combs__dmstatus__have_reset_all;
    reg debug_combs__dmstatus__have_reset_any;
    reg debug_combs__dmstatus__resume_ack_all;
    reg debug_combs__dmstatus__resume_ack_any;
    reg debug_combs__dmstatus__nonexistent_all;
    reg debug_combs__dmstatus__nonexistent_any;
    reg debug_combs__dmstatus__unavail_all;
    reg debug_combs__dmstatus__unavail_any;
    reg debug_combs__dmstatus__running_all;
    reg debug_combs__dmstatus__running_any;
    reg debug_combs__dmstatus__halted_all;
    reg debug_combs__dmstatus__halted_any;
    reg debug_combs__dmstatus__has_reset_halt_req;
    reg debug_combs__dmstatus__authenticate;
    reg debug_combs__dmstatus__auth_busy;
    reg debug_combs__dmstatus__dev_tree_valid;
    reg [3:0]debug_combs__dmstatus__version;
    reg [63:0]debug_combs__hart_sel_mask;
    reg [31:0]debug_combs__haltsum0;
    reg [31:0]debug_combs__haltsum1;
    reg [31:0]debug_combs__dmstatus_data;
    reg [31:0]debug_combs__dmcontrol_data;
    reg [63:0]debug_combs__next_halted;
    reg [63:0]debug_combs__next_resumed;
    reg [63:0]debug_combs__next_hit_breakpoint;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b blah combinatorial process
    always @ ( * )//blah
    begin: blah__comb_code
    reg [63:0]debug_combs__hart_sel_mask__var;
    reg [31:0]debug_combs__haltsum0__var;
    reg [31:0]debug_combs__haltsum1__var;
        debug_combs__hart_sel_mask__var = 64'h0;
        debug_combs__hart_sel_mask__var[debug_state__hart_sel] = 1'h1;
        debug_combs__haltsum0__var = debug_state__halted[31:0];
        if ((debug_state__hart_sel[4]!=1'h0))
        begin
            debug_combs__haltsum0__var = debug_state__halted[63:32];
        end //if
        debug_combs__haltsum1__var = 32'h0;
        debug_combs__haltsum1__var[0] = (debug_state__halted[31:0]!=32'h0);
        debug_combs__haltsum1__var[1] = (debug_state__halted[63:32]!=32'h0);
        debug_combs__dmstatus__impebreak = 1'h1;
        debug_combs__dmstatus__have_reset_all = 1'h0;
        debug_combs__dmstatus__have_reset_any = 1'h0;
        debug_combs__dmstatus__resume_ack_all = ((debug_state__resumed & debug_combs__hart_sel_mask__var)!=64'h0);
        debug_combs__dmstatus__resume_ack_any = ((debug_state__resumed & debug_combs__hart_sel_mask__var)!=64'h0);
        debug_combs__dmstatus__unavail_all = 1'h0;
        debug_combs__dmstatus__unavail_any = 1'h0;
        debug_combs__dmstatus__nonexistent_all = ((debug_combs__hart_sel_mask__var & 64'hffffffffffffffff)==64'h0);
        debug_combs__dmstatus__nonexistent_any = ((debug_combs__hart_sel_mask__var & 64'hffffffffffffffff)==64'h0);
        debug_combs__dmstatus__running_all = ((debug_state__halted & debug_combs__hart_sel_mask__var)==64'h0);
        debug_combs__dmstatus__running_any = ((debug_state__halted & debug_combs__hart_sel_mask__var)==64'h0);
        debug_combs__dmstatus__halted_all = ((debug_state__halted & debug_combs__hart_sel_mask__var)!=64'h0);
        debug_combs__dmstatus__halted_any = ((debug_state__halted & debug_combs__hart_sel_mask__var)!=64'h0);
        debug_combs__dmstatus__authenticate = 1'h0;
        debug_combs__dmstatus__auth_busy = 1'h0;
        debug_combs__dmstatus__has_reset_halt_req = 1'h0;
        debug_combs__dmstatus__dev_tree_valid = 1'h0;
        debug_combs__dmstatus__version = 4'h1;
        debug_combs__dmstatus_data = {{{{{{{{{{{{{{{{{{{9'h0,debug_combs__dmstatus__impebreak},2'h0},debug_combs__dmstatus__have_reset_all},debug_combs__dmstatus__have_reset_any},debug_combs__dmstatus__resume_ack_all},debug_combs__dmstatus__resume_ack_any},debug_combs__dmstatus__nonexistent_all},debug_combs__dmstatus__nonexistent_any},debug_combs__dmstatus__unavail_all},debug_combs__dmstatus__unavail_any},debug_combs__dmstatus__running_all},debug_combs__dmstatus__running_any},debug_combs__dmstatus__halted_all},debug_combs__dmstatus__halted_any},debug_combs__dmstatus__authenticate},debug_combs__dmstatus__auth_busy},debug_combs__dmstatus__has_reset_halt_req},debug_combs__dmstatus__dev_tree_valid},debug_combs__dmstatus__version};
        debug_combs__dmcontrol_data = {31'h0,debug_state__dmactive};
        debug_combs__hart_sel_mask = debug_combs__hart_sel_mask__var;
        debug_combs__haltsum0 = debug_combs__haltsum0__var;
        debug_combs__haltsum1 = debug_combs__haltsum1__var;
    end //always

    //b debug_mst_driving clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : debug_mst_driving__code
        if (reset_n==1'b0)
        begin
            debug_mst__valid <= 1'h0;
            debug_mst__data <= 32'h0;
            debug_mst__mask <= 6'h0;
            debug_mst__select <= 6'h0;
            debug_mst__op <= 4'h0;
            debug_mst__arg <= 16'h0;
            debug_state__hart_to_poll <= 6'h0;
        end
        else if (clk__enable)
        begin
            debug_mst__valid <= 1'h0;
            debug_mst__data <= 32'h0;
            debug_mst__mask <= 6'h3f;
            if ((debug_state__must_set_requests!=1'h0))
            begin
                debug_mst__valid <= 1'h1;
                debug_mst__select <= debug_state__hart_sel;
                debug_mst__op <= 4'h0;
                debug_mst__arg[0] <= debug_state__halt_req;
                debug_mst__arg[1] <= debug_state__resume_req;
            end //if
            else
            
            begin
                if ((debug_tgt__attention!=1'h0))
                begin
                    debug_mst__valid <= 1'h1;
                    debug_mst__select <= debug_state__hart_to_poll;
                    debug_state__hart_to_poll <= (debug_state__hart_to_poll-6'h1);
                    if ((debug_state__hart_to_poll==6'h0))
                    begin
                        debug_state__hart_to_poll <= 6'h3f;
                    end //if
                    debug_mst__op <= 4'h3;
                end //if
            end //else
        end //if
    end //always

    //b debug_tgt_state__comb combinatorial process
        //   
        //       
    always @ ( * )//debug_tgt_state__comb
    begin: debug_tgt_state__comb_code
    reg debug_combs__update_status__var;
    reg [63:0]debug_combs__next_halted__var;
    reg [63:0]debug_combs__next_resumed__var;
    reg [63:0]debug_combs__next_hit_breakpoint__var;
        debug_combs__update_status__var = 1'h0;
        debug_combs__next_halted__var = debug_state__halted;
        debug_combs__next_resumed__var = debug_state__resumed;
        debug_combs__next_hit_breakpoint__var = debug_state__hit_breakpoint;
        if ((debug_tgt__valid!=1'h0))
        begin
            if ((debug_tgt__selected<=6'h3f))
            begin
                debug_combs__update_status__var = 1'h1;
                debug_combs__next_halted__var[debug_tgt__selected] = debug_tgt__halted;
                debug_combs__next_resumed__var[debug_tgt__selected] = debug_tgt__resumed;
                debug_combs__next_hit_breakpoint__var[debug_tgt__selected] = debug_tgt__hit_breakpoint;
            end //if
        end //if
        debug_combs__update_status = debug_combs__update_status__var;
        debug_combs__next_halted = debug_combs__next_halted__var;
        debug_combs__next_resumed = debug_combs__next_resumed__var;
        debug_combs__next_hit_breakpoint = debug_combs__next_hit_breakpoint__var;
    end //always

    //b debug_tgt_state__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : debug_tgt_state__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            debug_state__halted <= 64'h0;
            debug_state__resumed <= 64'h0;
            debug_state__hit_breakpoint <= 64'h0;
        end
        else if (clk__enable)
        begin
            if ((debug_combs__update_status!=1'h0))
            begin
                debug_state__halted <= (debug_combs__next_halted & 64'hffffffffffffffff);
                debug_state__resumed <= (debug_combs__next_resumed & 64'hffffffffffffffff);
                debug_state__hit_breakpoint <= (debug_combs__next_hit_breakpoint & 64'hffffffffffffffff);
            end //if
        end //if
    end //always

    //b apb_interface__comb combinatorial process
    always @ ( * )//apb_interface__comb
    begin: apb_interface__comb_code
    reg [31:0]apb_response__prdata__var;
        apb_response__prdata__var = 32'h0;
        apb_response__perr = 1'h0;
        apb_response__pready = 1'h1;
        case (apb_state__read_select) //synopsys parallel_case
        3'h2: // req 1
            begin
            apb_response__prdata__var = debug_combs__dmcontrol_data;
            end
        3'h1: // req 1
            begin
            apb_response__prdata__var = debug_combs__dmstatus_data;
            end
        3'h3: // req 1
            begin
            apb_response__prdata__var = debug_combs__dmstatus_data;
            end
        3'h4: // req 1
            begin
            apb_response__prdata__var = debug_state__data0;
            end
        3'h5: // req 1
            begin
            apb_response__prdata__var = debug_state__progbuf0;
            end
        3'h6: // req 1
            begin
            apb_response__prdata__var = debug_combs__haltsum0;
            end
        3'h7: // req 1
            begin
            apb_response__prdata__var = debug_combs__haltsum1;
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
    end //always

    //b apb_interface__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : apb_interface__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            apb_state__write_action <= 3'h0;
            apb_state__read_select <= 3'h0;
            debug_state__must_set_requests <= 1'h0;
            debug_state__data0 <= 32'h0;
            debug_state__progbuf0 <= 32'h0;
            debug_state__dmactive <= 1'h0;
            debug_state__ndmreset <= 1'h0;
            debug_state__hart_sel <= 6'h0;
            debug_state__halt_req <= 1'h0;
            debug_state__resume_req <= 1'h0;
        end
        else if (clk__enable)
        begin
            case (apb_request__paddr) //synopsys parallel_case
            32'h10: // req 1
                begin
                apb_state__write_action <= 3'h3;
                apb_state__read_select <= 3'h2;
                end
            32'h11: // req 1
                begin
                apb_state__read_select <= 3'h1;
                end
            32'h16: // req 1
                begin
                apb_state__write_action <= 3'h0;
                end
            32'h17: // req 1
                begin
                apb_state__write_action <= 3'h0;
                end
            32'h4: // req 1
                begin
                apb_state__read_select <= 3'h4;
                end
            32'h20: // req 1
                begin
                apb_state__read_select <= 3'h5;
                end
            32'h40: // req 1
                begin
                apb_state__read_select <= 3'h6;
                end
            32'h13: // req 1
                begin
                apb_state__read_select <= 3'h7;
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
            if (!(apb_request__pwrite!=1'h0))
            begin
                apb_state__write_action <= 3'h0;
            end //if
            else
            
            begin
                apb_state__read_select <= 3'h0;
            end //else
            if ((!(apb_request__psel!=1'h0)||(apb_request__penable!=1'h0)))
            begin
                apb_state__read_select <= 3'h0;
                apb_state__write_action <= 3'h0;
            end //if
            if (!(apb_request__psel!=1'h0))
            begin
                apb_state__read_select <= apb_state__read_select;
                apb_state__write_action <= apb_state__write_action;
            end //if
            debug_state__must_set_requests <= 1'h0;
            debug_state__data0 <= 32'h0;
            debug_state__progbuf0 <= 32'h0;
            case (apb_state__write_action) //synopsys parallel_case
            3'h3: // req 1
                begin
                debug_state__dmactive <= apb_request__pwdata[0];
                debug_state__ndmreset <= apb_request__pwdata[1];
                debug_state__hart_sel <= apb_request__pwdata[21:16];
                debug_state__must_set_requests <= 1'h1;
                debug_state__halt_req <= apb_request__pwdata[31];
                debug_state__resume_req <= apb_request__pwdata[30];
                end
            3'h1: // req 1
                begin
                end
            3'h2: // req 1
                begin
                end
            3'h4: // req 1
                begin
                end
            3'h5: // req 1
                begin
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
        end //if
    end //always

endmodule // riscv_i32_debug
