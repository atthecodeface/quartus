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

//a Module tb_riscv_jtag_debug
module tb_riscv_jtag_debug
(
    apb_clock,
    apb_clock__enable,
    jtag_tck,
    jtag_tck__enable,

    reset_n

);

    //b Clocks
    input apb_clock;
    input apb_clock__enable;
    input jtag_tck;
    input jtag_tck__enable;
    wire jtag_tck_gated; // Gated version of clock 'jtag_tck' enabled by 'tck_enable_fix'
    wire jtag_tck_gated__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials
    reg debug_response1__exec_valid;
    reg debug_response1__exec_halting;
    reg debug_response1__exec_dret;
    reg debug_response0__exec_valid;
    reg debug_response0__exec_halting;
    reg debug_response0__exec_dret;
    reg debug_tgt__valid;
    reg [5:0]debug_tgt__selected;
    reg debug_tgt__halted;
    reg debug_tgt__resumed;
    reg debug_tgt__hit_breakpoint;
    reg debug_tgt__op_was_none;
    reg debug_tgt__resp;
    reg [31:0]debug_tgt__data;
    reg debug_tgt__attention;
    reg tck_enable_fix;

    //b Internal nets
    wire debug_control1__valid;
    wire debug_control1__kill_fetch;
    wire debug_control1__halt_request;
    wire debug_control1__fetch_dret;
    wire [31:0]debug_control1__data;
    wire debug_control0__valid;
    wire debug_control0__kill_fetch;
    wire debug_control0__halt_request;
    wire debug_control0__fetch_dret;
    wire [31:0]debug_control0__data;
    wire debug_tgt1__valid;
    wire [5:0]debug_tgt1__selected;
    wire debug_tgt1__halted;
    wire debug_tgt1__resumed;
    wire debug_tgt1__hit_breakpoint;
    wire debug_tgt1__op_was_none;
    wire debug_tgt1__resp;
    wire [31:0]debug_tgt1__data;
    wire debug_tgt1__attention;
    wire debug_tgt0__valid;
    wire [5:0]debug_tgt0__selected;
    wire debug_tgt0__halted;
    wire debug_tgt0__resumed;
    wire debug_tgt0__hit_breakpoint;
    wire debug_tgt0__op_was_none;
    wire debug_tgt0__resp;
    wire [31:0]debug_tgt0__data;
    wire debug_tgt0__attention;
    wire debug_mst__valid;
    wire [5:0]debug_mst__select;
    wire [5:0]debug_mst__mask;
    wire [3:0]debug_mst__op;
    wire [15:0]debug_mst__arg;
    wire [31:0]debug_mst__data;
        //   APB response
    wire [31:0]apb_response__prdata;
    wire apb_response__pready;
    wire apb_response__perr;
        //   APB request
    wire [31:0]apb_request__paddr;
    wire apb_request__penable;
    wire apb_request__psel;
    wire apb_request__pwrite;
    wire [31:0]apb_request__pwdata;
    wire tck_enable;
    wire [49:0]dr_out;
    wire [49:0]dr_tdi_mask;
    wire [49:0]dr_in;
    wire [1:0]dr_action;
    wire [4:0]ir;
    wire tdo;
    wire jtag__ntrst;
    wire jtag__tms;
    wire jtag__tdi;

    //b Clock gating module instances
    assign jtag_tck_gated__enable = (jtag_tck__enable && tck_enable_fix);
    //b Module instances
    se_test_harness th(
        .clk(jtag_tck),
        .clk__enable(1'b1),
        .tdo(tdo),
        .tck_enable(            tck_enable),
        .jtag__tdi(            jtag__tdi),
        .jtag__tms(            jtag__tms),
        .jtag__ntrst(            jtag__ntrst)         );
    jtag_tap tap(
        .jtag_tck(jtag_tck),
        .jtag_tck__enable(jtag_tck_gated__enable),
        .dr_out(dr_out),
        .dr_tdi_mask(dr_tdi_mask),
        .jtag__tdi(jtag__tdi),
        .jtag__tms(jtag__tms),
        .jtag__ntrst(jtag__ntrst),
        .reset_n(reset_n),
        .dr_in(            dr_in),
        .dr_action(            dr_action),
        .ir(            ir),
        .tdo(            tdo)         );
    riscv_jtag_apb_dm dm_apb(
        .apb_clock(apb_clock),
        .apb_clock__enable(1'b1),
        .jtag_tck(jtag_tck),
        .jtag_tck__enable(jtag_tck_gated__enable),
        .apb_response__perr(apb_response__perr),
        .apb_response__pready(apb_response__pready),
        .apb_response__prdata(apb_response__prdata),
        .dr_in(dr_in),
        .dr_action(dr_action),
        .ir(ir),
        .reset_n(reset_n),
        .apb_request__pwdata(            apb_request__pwdata),
        .apb_request__pwrite(            apb_request__pwrite),
        .apb_request__psel(            apb_request__psel),
        .apb_request__penable(            apb_request__penable),
        .apb_request__paddr(            apb_request__paddr),
        .dr_out(            dr_out),
        .dr_tdi_mask(            dr_tdi_mask)         );
    riscv_i32_debug dm(
        .clk(apb_clock),
        .clk__enable(1'b1),
        .debug_tgt__attention(debug_tgt__attention),
        .debug_tgt__data(debug_tgt__data),
        .debug_tgt__resp(debug_tgt__resp),
        .debug_tgt__op_was_none(debug_tgt__op_was_none),
        .debug_tgt__hit_breakpoint(debug_tgt__hit_breakpoint),
        .debug_tgt__resumed(debug_tgt__resumed),
        .debug_tgt__halted(debug_tgt__halted),
        .debug_tgt__selected(debug_tgt__selected),
        .debug_tgt__valid(debug_tgt__valid),
        .apb_request__pwdata(apb_request__pwdata),
        .apb_request__pwrite(apb_request__pwrite),
        .apb_request__psel(apb_request__psel),
        .apb_request__penable(apb_request__penable),
        .apb_request__paddr(apb_request__paddr),
        .reset_n(reset_n),
        .debug_mst__data(            debug_mst__data),
        .debug_mst__arg(            debug_mst__arg),
        .debug_mst__op(            debug_mst__op),
        .debug_mst__mask(            debug_mst__mask),
        .debug_mst__select(            debug_mst__select),
        .debug_mst__valid(            debug_mst__valid),
        .apb_response__perr(            apb_response__perr),
        .apb_response__pready(            apb_response__pready),
        .apb_response__prdata(            apb_response__prdata)         );
    riscv_i32_pipeline_debug pd0(
        .clk(apb_clock),
        .clk__enable(1'b1),
        .rv_select(6'h0),
        .debug_response__exec_dret(debug_response0__exec_dret),
        .debug_response__exec_halting(debug_response0__exec_halting),
        .debug_response__exec_valid(debug_response0__exec_valid),
        .debug_mst__data(debug_mst__data),
        .debug_mst__arg(debug_mst__arg),
        .debug_mst__op(debug_mst__op),
        .debug_mst__mask(debug_mst__mask),
        .debug_mst__select(debug_mst__select),
        .debug_mst__valid(debug_mst__valid),
        .reset_n(reset_n),
        .debug_control__data(            debug_control0__data),
        .debug_control__fetch_dret(            debug_control0__fetch_dret),
        .debug_control__halt_request(            debug_control0__halt_request),
        .debug_control__kill_fetch(            debug_control0__kill_fetch),
        .debug_control__valid(            debug_control0__valid),
        .debug_tgt__attention(            debug_tgt0__attention),
        .debug_tgt__data(            debug_tgt0__data),
        .debug_tgt__resp(            debug_tgt0__resp),
        .debug_tgt__op_was_none(            debug_tgt0__op_was_none),
        .debug_tgt__hit_breakpoint(            debug_tgt0__hit_breakpoint),
        .debug_tgt__resumed(            debug_tgt0__resumed),
        .debug_tgt__halted(            debug_tgt0__halted),
        .debug_tgt__selected(            debug_tgt0__selected),
        .debug_tgt__valid(            debug_tgt0__valid)         );
    riscv_i32_pipeline_debug pd1(
        .clk(apb_clock),
        .clk__enable(1'b1),
        .rv_select(6'h1),
        .debug_response__exec_dret(debug_response1__exec_dret),
        .debug_response__exec_halting(debug_response1__exec_halting),
        .debug_response__exec_valid(debug_response1__exec_valid),
        .debug_mst__data(debug_mst__data),
        .debug_mst__arg(debug_mst__arg),
        .debug_mst__op(debug_mst__op),
        .debug_mst__mask(debug_mst__mask),
        .debug_mst__select(debug_mst__select),
        .debug_mst__valid(debug_mst__valid),
        .reset_n(reset_n),
        .debug_control__data(            debug_control1__data),
        .debug_control__fetch_dret(            debug_control1__fetch_dret),
        .debug_control__halt_request(            debug_control1__halt_request),
        .debug_control__kill_fetch(            debug_control1__kill_fetch),
        .debug_control__valid(            debug_control1__valid),
        .debug_tgt__attention(            debug_tgt1__attention),
        .debug_tgt__data(            debug_tgt1__data),
        .debug_tgt__resp(            debug_tgt1__resp),
        .debug_tgt__op_was_none(            debug_tgt1__op_was_none),
        .debug_tgt__hit_breakpoint(            debug_tgt1__hit_breakpoint),
        .debug_tgt__resumed(            debug_tgt1__resumed),
        .debug_tgt__halted(            debug_tgt1__halted),
        .debug_tgt__selected(            debug_tgt1__selected),
        .debug_tgt__valid(            debug_tgt1__valid)         );
    //b dut_instance combinatorial process
    always @ ( * )//dut_instance
    begin: dut_instance__comb_code
    reg debug_tgt__valid__var;
    reg [5:0]debug_tgt__selected__var;
    reg debug_tgt__halted__var;
    reg debug_tgt__resumed__var;
    reg debug_tgt__hit_breakpoint__var;
    reg debug_tgt__op_was_none__var;
    reg debug_tgt__resp__var;
    reg [31:0]debug_tgt__data__var;
    reg debug_tgt__attention__var;
        tck_enable_fix = tck_enable;
        debug_response0__exec_valid = 1'h0;
        debug_response0__exec_halting = 1'h0;
        debug_response0__exec_dret = 1'h0;
        debug_response1__exec_valid = 1'h0;
        debug_response1__exec_halting = 1'h0;
        debug_response1__exec_dret = 1'h0;
        debug_tgt__valid__var = debug_tgt0__valid;
        debug_tgt__selected__var = debug_tgt0__selected;
        debug_tgt__halted__var = debug_tgt0__halted;
        debug_tgt__resumed__var = debug_tgt0__resumed;
        debug_tgt__hit_breakpoint__var = debug_tgt0__hit_breakpoint;
        debug_tgt__op_was_none__var = debug_tgt0__op_was_none;
        debug_tgt__resp__var = debug_tgt0__resp;
        debug_tgt__data__var = debug_tgt0__data;
        debug_tgt__attention__var = debug_tgt0__attention;
        debug_tgt__valid__var = debug_tgt__valid__var | debug_tgt1__valid;
        debug_tgt__selected__var = debug_tgt__selected__var | debug_tgt1__selected;
        debug_tgt__halted__var = debug_tgt__halted__var | debug_tgt1__halted;
        debug_tgt__resumed__var = debug_tgt__resumed__var | debug_tgt1__resumed;
        debug_tgt__hit_breakpoint__var = debug_tgt__hit_breakpoint__var | debug_tgt1__hit_breakpoint;
        debug_tgt__op_was_none__var = debug_tgt__op_was_none__var | debug_tgt1__op_was_none;
        debug_tgt__resp__var = debug_tgt__resp__var | debug_tgt1__resp;
        debug_tgt__data__var = debug_tgt__data__var | debug_tgt1__data;
        debug_tgt__attention__var = debug_tgt__attention__var | debug_tgt1__attention;
        debug_tgt__valid = debug_tgt__valid__var;
        debug_tgt__selected = debug_tgt__selected__var;
        debug_tgt__halted = debug_tgt__halted__var;
        debug_tgt__resumed = debug_tgt__resumed__var;
        debug_tgt__hit_breakpoint = debug_tgt__hit_breakpoint__var;
        debug_tgt__op_was_none = debug_tgt__op_was_none__var;
        debug_tgt__resp = debug_tgt__resp__var;
        debug_tgt__data = debug_tgt__data__var;
        debug_tgt__attention = debug_tgt__attention__var;
    end //always

endmodule // tb_riscv_jtag_debug
