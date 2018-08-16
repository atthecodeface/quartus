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

//a Module tb_jtag_apb_timer
module tb_jtag_apb_timer
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
    reg tck_enable_fix;

    //b Internal nets
    wire tck_enable;
    wire [2:0]timer_equalled;
    wire [31:0]apb_response__prdata;
    wire apb_response__pready;
    wire apb_response__perr;
    wire [31:0]apb_request__paddr;
    wire apb_request__penable;
    wire apb_request__psel;
    wire apb_request__pwrite;
    wire [31:0]apb_request__pwdata;
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
    apb_target_timer timer(
        .clk(apb_clock),
        .clk__enable(1'b1),
        .apb_request__pwdata(apb_request__pwdata),
        .apb_request__pwrite(apb_request__pwrite),
        .apb_request__psel(apb_request__psel),
        .apb_request__penable(apb_request__penable),
        .apb_request__paddr(apb_request__paddr),
        .reset_n(reset_n),
        .timer_equalled(            timer_equalled),
        .apb_response__perr(            apb_response__perr),
        .apb_response__pready(            apb_response__pready),
        .apb_response__prdata(            apb_response__prdata)         );
    jtag_apb apb(
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
    //b dut_instance combinatorial process
    always @ ( * )//dut_instance
    begin: dut_instance__comb_code
        tck_enable_fix = tck_enable;
    end //always

endmodule // tb_jtag_apb_timer
