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
    reg riscv_config__i32c;
    reg riscv_config__e32;
    reg riscv_config__i32m;
    reg riscv_config__i32m_fuse;
    reg riscv_config__debug_enable;
    reg riscv_config__coproc_disable;
    reg riscv_config__unaligned_mem;
    reg [63:0]csrs__cycles;
    reg [63:0]csrs__instret;
    reg [63:0]csrs__time;
    reg [31:0]csrs__mscratch;
    reg [31:0]csrs__mepc;
    reg [31:0]csrs__mcause;
    reg [31:0]csrs__mtval;
    reg [29:0]csrs__mtvec__base;
    reg csrs__mtvec__vectored;
    reg csrs__mstatus__sd;
    reg csrs__mstatus__tsr;
    reg csrs__mstatus__tw;
    reg csrs__mstatus__tvm;
    reg csrs__mstatus__mxr;
    reg csrs__mstatus__sum;
    reg csrs__mstatus__mprv;
    reg [1:0]csrs__mstatus__xs;
    reg [1:0]csrs__mstatus__fs;
    reg [1:0]csrs__mstatus__mpp;
    reg csrs__mstatus__spp;
    reg csrs__mstatus__mpie;
    reg csrs__mstatus__spie;
    reg csrs__mstatus__upie;
    reg csrs__mstatus__mie;
    reg csrs__mstatus__sie;
    reg csrs__mstatus__uie;
    reg csrs__mip__meip;
    reg csrs__mip__seip;
    reg csrs__mip__ueip;
    reg csrs__mip__seip_sw;
    reg csrs__mip__ueip_sw;
    reg csrs__mip__mtip;
    reg csrs__mip__stip;
    reg csrs__mip__utip;
    reg csrs__mip__msip;
    reg csrs__mip__ssip;
    reg csrs__mip__usip;
    reg csrs__mie__meip;
    reg csrs__mie__seip;
    reg csrs__mie__ueip;
    reg csrs__mie__mtip;
    reg csrs__mie__stip;
    reg csrs__mie__utip;
    reg csrs__mie__msip;
    reg csrs__mie__ssip;
    reg csrs__mie__usip;
    reg [3:0]csrs__dcsr__xdebug_ver;
    reg csrs__dcsr__ebreakm;
    reg csrs__dcsr__ebreaks;
    reg csrs__dcsr__ebreaku;
    reg csrs__dcsr__stepie;
    reg csrs__dcsr__stopcount;
    reg csrs__dcsr__stoptime;
    reg [2:0]csrs__dcsr__cause;
    reg csrs__dcsr__mprven;
    reg csrs__dcsr__nmip;
    reg csrs__dcsr__step;
    reg [1:0]csrs__dcsr__prv;
    reg [31:0]csrs__depc;
    reg [31:0]csrs__dscratch0;
    reg [31:0]csrs__dscratch1;
    reg trace__instr_valid;
    reg [31:0]trace__instr_pc;
    reg [31:0]trace__instruction__data;
    reg trace__instruction__debug__valid;
    reg [1:0]trace__instruction__debug__debug_op;
    reg [15:0]trace__instruction__debug__data;
    reg trace__rfw_retire;
    reg trace__rfw_data_valid;
    reg [4:0]trace__rfw_rd;
    reg [31:0]trace__rfw_data;
    reg trace__branch_taken;
    reg [31:0]trace__branch_target;
    reg trace__trap;
    reg pipeline_fetch_data__valid;
    reg [31:0]pipeline_fetch_data__pc;
    reg [31:0]pipeline_fetch_data__instruction__data;
    reg pipeline_fetch_data__instruction__debug__valid;
    reg [1:0]pipeline_fetch_data__instruction__debug__debug_op;
    reg [15:0]pipeline_fetch_data__instruction__debug__data;
    reg pipeline_fetch_data__dec_flush_pipeline;
    reg pipeline_fetch_data__dec_predicted_branch;
    reg [31:0]pipeline_fetch_data__dec_pc_if_mispredicted;
    reg pipeline_response__decode__valid;
    reg pipeline_response__decode__blocked;
    reg [31:0]pipeline_response__decode__branch_target;
    reg [4:0]pipeline_response__decode__idecode__rs1;
    reg pipeline_response__decode__idecode__rs1_valid;
    reg [4:0]pipeline_response__decode__idecode__rs2;
    reg pipeline_response__decode__idecode__rs2_valid;
    reg [4:0]pipeline_response__decode__idecode__rd;
    reg pipeline_response__decode__idecode__rd_written;
    reg pipeline_response__decode__idecode__csr_access__access_cancelled;
    reg [2:0]pipeline_response__decode__idecode__csr_access__access;
    reg [11:0]pipeline_response__decode__idecode__csr_access__address;
    reg [31:0]pipeline_response__decode__idecode__csr_access__write_data;
    reg [31:0]pipeline_response__decode__idecode__immediate;
    reg [4:0]pipeline_response__decode__idecode__immediate_shift;
    reg pipeline_response__decode__idecode__immediate_valid;
    reg [3:0]pipeline_response__decode__idecode__op;
    reg [3:0]pipeline_response__decode__idecode__subop;
    reg pipeline_response__decode__idecode__requires_machine_mode;
    reg pipeline_response__decode__idecode__memory_read_unsigned;
    reg [1:0]pipeline_response__decode__idecode__memory_width;
    reg pipeline_response__decode__idecode__illegal;
    reg pipeline_response__decode__idecode__illegal_pc;
    reg pipeline_response__decode__idecode__is_compressed;
    reg pipeline_response__decode__idecode__ext__dummy;
    reg pipeline_response__decode__enable_branch_prediction;
    reg pipeline_response__exec__valid;
    reg pipeline_response__exec__cannot_start;
    reg pipeline_response__exec__cannot_complete;
    reg pipeline_response__exec__interrupt_ack;
    reg pipeline_response__exec__branch_taken;
    reg pipeline_response__exec__trap__valid;
    reg [2:0]pipeline_response__exec__trap__to_mode;
    reg [3:0]pipeline_response__exec__trap__cause;
    reg [31:0]pipeline_response__exec__trap__pc;
    reg [31:0]pipeline_response__exec__trap__value;
    reg pipeline_response__exec__trap__ret;
    reg pipeline_response__exec__trap__vector;
    reg pipeline_response__exec__trap__ebreak_to_dbg;
    reg pipeline_response__exec__is_compressed;
    reg [31:0]pipeline_response__exec__instruction__data;
    reg pipeline_response__exec__instruction__debug__valid;
    reg [1:0]pipeline_response__exec__instruction__debug__debug_op;
    reg [15:0]pipeline_response__exec__instruction__debug__data;
    reg [31:0]pipeline_response__exec__rs1;
    reg [31:0]pipeline_response__exec__rs2;
    reg [31:0]pipeline_response__exec__pc;
    reg pipeline_response__exec__predicted_branch;
    reg [31:0]pipeline_response__exec__pc_if_mispredicted;
    reg pipeline_response__rfw__valid;
    reg pipeline_response__rfw__rd_written;
    reg [4:0]pipeline_response__rfw__rd;
    reg [31:0]pipeline_response__rfw__data;
    reg pipeline_response__pipeline_empty;
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
    reg [1:0]debug_tgt__resp;
    reg [31:0]debug_tgt__data;
    reg debug_tgt__attention;
    reg tck_enable_fix;

    //b Internal nets
    wire pipeline_control1__valid;
    wire [2:0]pipeline_control1__fetch_action;
    wire [31:0]pipeline_control1__decode_pc;
    wire [2:0]pipeline_control1__mode;
    wire pipeline_control1__error;
    wire [1:0]pipeline_control1__tag;
    wire pipeline_control1__halt;
    wire pipeline_control1__ebreak_to_dbg;
    wire pipeline_control1__interrupt_req;
    wire [3:0]pipeline_control1__interrupt_number;
    wire [2:0]pipeline_control1__interrupt_to_mode;
    wire [31:0]pipeline_control1__instruction_data;
    wire pipeline_control1__instruction_debug__valid;
    wire [1:0]pipeline_control1__instruction_debug__debug_op;
    wire [15:0]pipeline_control1__instruction_debug__data;
    wire pipeline_control0__valid;
    wire [2:0]pipeline_control0__fetch_action;
    wire [31:0]pipeline_control0__decode_pc;
    wire [2:0]pipeline_control0__mode;
    wire pipeline_control0__error;
    wire [1:0]pipeline_control0__tag;
    wire pipeline_control0__halt;
    wire pipeline_control0__ebreak_to_dbg;
    wire pipeline_control0__interrupt_req;
    wire [3:0]pipeline_control0__interrupt_number;
    wire [2:0]pipeline_control0__interrupt_to_mode;
    wire [31:0]pipeline_control0__instruction_data;
    wire pipeline_control0__instruction_debug__valid;
    wire [1:0]pipeline_control0__instruction_debug__debug_op;
    wire [15:0]pipeline_control0__instruction_debug__data;
    wire debug_tgt1__valid;
    wire [5:0]debug_tgt1__selected;
    wire debug_tgt1__halted;
    wire debug_tgt1__resumed;
    wire debug_tgt1__hit_breakpoint;
    wire debug_tgt1__op_was_none;
    wire [1:0]debug_tgt1__resp;
    wire [31:0]debug_tgt1__data;
    wire debug_tgt1__attention;
    wire debug_tgt0__valid;
    wire [5:0]debug_tgt0__selected;
    wire debug_tgt0__halted;
    wire debug_tgt0__resumed;
    wire debug_tgt0__hit_breakpoint;
    wire debug_tgt0__op_was_none;
    wire [1:0]debug_tgt0__resp;
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
    riscv_i32_pipeline_control pc0(
        .clk(apb_clock),
        .clk__enable(1'b1),
        .rv_select(6'h0),
        .debug_mst__data(debug_mst__data),
        .debug_mst__arg(debug_mst__arg),
        .debug_mst__op(debug_mst__op),
        .debug_mst__mask(debug_mst__mask),
        .debug_mst__select(debug_mst__select),
        .debug_mst__valid(debug_mst__valid),
        .trace__trap(trace__trap),
        .trace__branch_target(trace__branch_target),
        .trace__branch_taken(trace__branch_taken),
        .trace__rfw_data(trace__rfw_data),
        .trace__rfw_rd(trace__rfw_rd),
        .trace__rfw_data_valid(trace__rfw_data_valid),
        .trace__rfw_retire(trace__rfw_retire),
        .trace__instruction__debug__data(trace__instruction__debug__data),
        .trace__instruction__debug__debug_op(trace__instruction__debug__debug_op),
        .trace__instruction__debug__valid(trace__instruction__debug__valid),
        .trace__instruction__data(trace__instruction__data),
        .trace__instr_pc(trace__instr_pc),
        .trace__instr_valid(trace__instr_valid),
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__debug_enable(riscv_config__debug_enable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .pipeline_fetch_data__dec_pc_if_mispredicted(pipeline_fetch_data__dec_pc_if_mispredicted),
        .pipeline_fetch_data__dec_predicted_branch(pipeline_fetch_data__dec_predicted_branch),
        .pipeline_fetch_data__dec_flush_pipeline(pipeline_fetch_data__dec_flush_pipeline),
        .pipeline_fetch_data__instruction__debug__data(pipeline_fetch_data__instruction__debug__data),
        .pipeline_fetch_data__instruction__debug__debug_op(pipeline_fetch_data__instruction__debug__debug_op),
        .pipeline_fetch_data__instruction__debug__valid(pipeline_fetch_data__instruction__debug__valid),
        .pipeline_fetch_data__instruction__data(pipeline_fetch_data__instruction__data),
        .pipeline_fetch_data__pc(pipeline_fetch_data__pc),
        .pipeline_fetch_data__valid(pipeline_fetch_data__valid),
        .pipeline_response__pipeline_empty(pipeline_response__pipeline_empty),
        .pipeline_response__rfw__data(pipeline_response__rfw__data),
        .pipeline_response__rfw__rd(pipeline_response__rfw__rd),
        .pipeline_response__rfw__rd_written(pipeline_response__rfw__rd_written),
        .pipeline_response__rfw__valid(pipeline_response__rfw__valid),
        .pipeline_response__exec__pc_if_mispredicted(pipeline_response__exec__pc_if_mispredicted),
        .pipeline_response__exec__predicted_branch(pipeline_response__exec__predicted_branch),
        .pipeline_response__exec__pc(pipeline_response__exec__pc),
        .pipeline_response__exec__rs2(pipeline_response__exec__rs2),
        .pipeline_response__exec__rs1(pipeline_response__exec__rs1),
        .pipeline_response__exec__instruction__debug__data(pipeline_response__exec__instruction__debug__data),
        .pipeline_response__exec__instruction__debug__debug_op(pipeline_response__exec__instruction__debug__debug_op),
        .pipeline_response__exec__instruction__debug__valid(pipeline_response__exec__instruction__debug__valid),
        .pipeline_response__exec__instruction__data(pipeline_response__exec__instruction__data),
        .pipeline_response__exec__is_compressed(pipeline_response__exec__is_compressed),
        .pipeline_response__exec__trap__ebreak_to_dbg(pipeline_response__exec__trap__ebreak_to_dbg),
        .pipeline_response__exec__trap__vector(pipeline_response__exec__trap__vector),
        .pipeline_response__exec__trap__ret(pipeline_response__exec__trap__ret),
        .pipeline_response__exec__trap__value(pipeline_response__exec__trap__value),
        .pipeline_response__exec__trap__pc(pipeline_response__exec__trap__pc),
        .pipeline_response__exec__trap__cause(pipeline_response__exec__trap__cause),
        .pipeline_response__exec__trap__to_mode(pipeline_response__exec__trap__to_mode),
        .pipeline_response__exec__trap__valid(pipeline_response__exec__trap__valid),
        .pipeline_response__exec__branch_taken(pipeline_response__exec__branch_taken),
        .pipeline_response__exec__interrupt_ack(pipeline_response__exec__interrupt_ack),
        .pipeline_response__exec__cannot_complete(pipeline_response__exec__cannot_complete),
        .pipeline_response__exec__cannot_start(pipeline_response__exec__cannot_start),
        .pipeline_response__exec__valid(pipeline_response__exec__valid),
        .pipeline_response__decode__enable_branch_prediction(pipeline_response__decode__enable_branch_prediction),
        .pipeline_response__decode__idecode__ext__dummy(pipeline_response__decode__idecode__ext__dummy),
        .pipeline_response__decode__idecode__is_compressed(pipeline_response__decode__idecode__is_compressed),
        .pipeline_response__decode__idecode__illegal_pc(pipeline_response__decode__idecode__illegal_pc),
        .pipeline_response__decode__idecode__illegal(pipeline_response__decode__idecode__illegal),
        .pipeline_response__decode__idecode__memory_width(pipeline_response__decode__idecode__memory_width),
        .pipeline_response__decode__idecode__memory_read_unsigned(pipeline_response__decode__idecode__memory_read_unsigned),
        .pipeline_response__decode__idecode__requires_machine_mode(pipeline_response__decode__idecode__requires_machine_mode),
        .pipeline_response__decode__idecode__subop(pipeline_response__decode__idecode__subop),
        .pipeline_response__decode__idecode__op(pipeline_response__decode__idecode__op),
        .pipeline_response__decode__idecode__immediate_valid(pipeline_response__decode__idecode__immediate_valid),
        .pipeline_response__decode__idecode__immediate_shift(pipeline_response__decode__idecode__immediate_shift),
        .pipeline_response__decode__idecode__immediate(pipeline_response__decode__idecode__immediate),
        .pipeline_response__decode__idecode__csr_access__write_data(pipeline_response__decode__idecode__csr_access__write_data),
        .pipeline_response__decode__idecode__csr_access__address(pipeline_response__decode__idecode__csr_access__address),
        .pipeline_response__decode__idecode__csr_access__access(pipeline_response__decode__idecode__csr_access__access),
        .pipeline_response__decode__idecode__csr_access__access_cancelled(pipeline_response__decode__idecode__csr_access__access_cancelled),
        .pipeline_response__decode__idecode__rd_written(pipeline_response__decode__idecode__rd_written),
        .pipeline_response__decode__idecode__rd(pipeline_response__decode__idecode__rd),
        .pipeline_response__decode__idecode__rs2_valid(pipeline_response__decode__idecode__rs2_valid),
        .pipeline_response__decode__idecode__rs2(pipeline_response__decode__idecode__rs2),
        .pipeline_response__decode__idecode__rs1_valid(pipeline_response__decode__idecode__rs1_valid),
        .pipeline_response__decode__idecode__rs1(pipeline_response__decode__idecode__rs1),
        .pipeline_response__decode__branch_target(pipeline_response__decode__branch_target),
        .pipeline_response__decode__blocked(pipeline_response__decode__blocked),
        .pipeline_response__decode__valid(pipeline_response__decode__valid),
        .csrs__dscratch1(csrs__dscratch1),
        .csrs__dscratch0(csrs__dscratch0),
        .csrs__depc(csrs__depc),
        .csrs__dcsr__prv(csrs__dcsr__prv),
        .csrs__dcsr__step(csrs__dcsr__step),
        .csrs__dcsr__nmip(csrs__dcsr__nmip),
        .csrs__dcsr__mprven(csrs__dcsr__mprven),
        .csrs__dcsr__cause(csrs__dcsr__cause),
        .csrs__dcsr__stoptime(csrs__dcsr__stoptime),
        .csrs__dcsr__stopcount(csrs__dcsr__stopcount),
        .csrs__dcsr__stepie(csrs__dcsr__stepie),
        .csrs__dcsr__ebreaku(csrs__dcsr__ebreaku),
        .csrs__dcsr__ebreaks(csrs__dcsr__ebreaks),
        .csrs__dcsr__ebreakm(csrs__dcsr__ebreakm),
        .csrs__dcsr__xdebug_ver(csrs__dcsr__xdebug_ver),
        .csrs__mie__usip(csrs__mie__usip),
        .csrs__mie__ssip(csrs__mie__ssip),
        .csrs__mie__msip(csrs__mie__msip),
        .csrs__mie__utip(csrs__mie__utip),
        .csrs__mie__stip(csrs__mie__stip),
        .csrs__mie__mtip(csrs__mie__mtip),
        .csrs__mie__ueip(csrs__mie__ueip),
        .csrs__mie__seip(csrs__mie__seip),
        .csrs__mie__meip(csrs__mie__meip),
        .csrs__mip__usip(csrs__mip__usip),
        .csrs__mip__ssip(csrs__mip__ssip),
        .csrs__mip__msip(csrs__mip__msip),
        .csrs__mip__utip(csrs__mip__utip),
        .csrs__mip__stip(csrs__mip__stip),
        .csrs__mip__mtip(csrs__mip__mtip),
        .csrs__mip__ueip_sw(csrs__mip__ueip_sw),
        .csrs__mip__seip_sw(csrs__mip__seip_sw),
        .csrs__mip__ueip(csrs__mip__ueip),
        .csrs__mip__seip(csrs__mip__seip),
        .csrs__mip__meip(csrs__mip__meip),
        .csrs__mstatus__uie(csrs__mstatus__uie),
        .csrs__mstatus__sie(csrs__mstatus__sie),
        .csrs__mstatus__mie(csrs__mstatus__mie),
        .csrs__mstatus__upie(csrs__mstatus__upie),
        .csrs__mstatus__spie(csrs__mstatus__spie),
        .csrs__mstatus__mpie(csrs__mstatus__mpie),
        .csrs__mstatus__spp(csrs__mstatus__spp),
        .csrs__mstatus__mpp(csrs__mstatus__mpp),
        .csrs__mstatus__fs(csrs__mstatus__fs),
        .csrs__mstatus__xs(csrs__mstatus__xs),
        .csrs__mstatus__mprv(csrs__mstatus__mprv),
        .csrs__mstatus__sum(csrs__mstatus__sum),
        .csrs__mstatus__mxr(csrs__mstatus__mxr),
        .csrs__mstatus__tvm(csrs__mstatus__tvm),
        .csrs__mstatus__tw(csrs__mstatus__tw),
        .csrs__mstatus__tsr(csrs__mstatus__tsr),
        .csrs__mstatus__sd(csrs__mstatus__sd),
        .csrs__mtvec__vectored(csrs__mtvec__vectored),
        .csrs__mtvec__base(csrs__mtvec__base),
        .csrs__mtval(csrs__mtval),
        .csrs__mcause(csrs__mcause),
        .csrs__mepc(csrs__mepc),
        .csrs__mscratch(csrs__mscratch),
        .csrs__time(csrs__time),
        .csrs__instret(csrs__instret),
        .csrs__cycles(csrs__cycles),
        .riscv_clk_enable(1'h1),
        .reset_n(reset_n),
        .debug_tgt__attention(            debug_tgt0__attention),
        .debug_tgt__data(            debug_tgt0__data),
        .debug_tgt__resp(            debug_tgt0__resp),
        .debug_tgt__op_was_none(            debug_tgt0__op_was_none),
        .debug_tgt__hit_breakpoint(            debug_tgt0__hit_breakpoint),
        .debug_tgt__resumed(            debug_tgt0__resumed),
        .debug_tgt__halted(            debug_tgt0__halted),
        .debug_tgt__selected(            debug_tgt0__selected),
        .debug_tgt__valid(            debug_tgt0__valid),
        .pipeline_control__instruction_debug__data(            pipeline_control0__instruction_debug__data),
        .pipeline_control__instruction_debug__debug_op(            pipeline_control0__instruction_debug__debug_op),
        .pipeline_control__instruction_debug__valid(            pipeline_control0__instruction_debug__valid),
        .pipeline_control__instruction_data(            pipeline_control0__instruction_data),
        .pipeline_control__interrupt_to_mode(            pipeline_control0__interrupt_to_mode),
        .pipeline_control__interrupt_number(            pipeline_control0__interrupt_number),
        .pipeline_control__interrupt_req(            pipeline_control0__interrupt_req),
        .pipeline_control__ebreak_to_dbg(            pipeline_control0__ebreak_to_dbg),
        .pipeline_control__halt(            pipeline_control0__halt),
        .pipeline_control__tag(            pipeline_control0__tag),
        .pipeline_control__error(            pipeline_control0__error),
        .pipeline_control__mode(            pipeline_control0__mode),
        .pipeline_control__decode_pc(            pipeline_control0__decode_pc),
        .pipeline_control__fetch_action(            pipeline_control0__fetch_action),
        .pipeline_control__valid(            pipeline_control0__valid)         );
    riscv_i32_pipeline_control pc1(
        .clk(apb_clock),
        .clk__enable(1'b1),
        .rv_select(6'h1),
        .debug_mst__data(debug_mst__data),
        .debug_mst__arg(debug_mst__arg),
        .debug_mst__op(debug_mst__op),
        .debug_mst__mask(debug_mst__mask),
        .debug_mst__select(debug_mst__select),
        .debug_mst__valid(debug_mst__valid),
        .trace__trap(trace__trap),
        .trace__branch_target(trace__branch_target),
        .trace__branch_taken(trace__branch_taken),
        .trace__rfw_data(trace__rfw_data),
        .trace__rfw_rd(trace__rfw_rd),
        .trace__rfw_data_valid(trace__rfw_data_valid),
        .trace__rfw_retire(trace__rfw_retire),
        .trace__instruction__debug__data(trace__instruction__debug__data),
        .trace__instruction__debug__debug_op(trace__instruction__debug__debug_op),
        .trace__instruction__debug__valid(trace__instruction__debug__valid),
        .trace__instruction__data(trace__instruction__data),
        .trace__instr_pc(trace__instr_pc),
        .trace__instr_valid(trace__instr_valid),
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__debug_enable(riscv_config__debug_enable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .pipeline_fetch_data__dec_pc_if_mispredicted(pipeline_fetch_data__dec_pc_if_mispredicted),
        .pipeline_fetch_data__dec_predicted_branch(pipeline_fetch_data__dec_predicted_branch),
        .pipeline_fetch_data__dec_flush_pipeline(pipeline_fetch_data__dec_flush_pipeline),
        .pipeline_fetch_data__instruction__debug__data(pipeline_fetch_data__instruction__debug__data),
        .pipeline_fetch_data__instruction__debug__debug_op(pipeline_fetch_data__instruction__debug__debug_op),
        .pipeline_fetch_data__instruction__debug__valid(pipeline_fetch_data__instruction__debug__valid),
        .pipeline_fetch_data__instruction__data(pipeline_fetch_data__instruction__data),
        .pipeline_fetch_data__pc(pipeline_fetch_data__pc),
        .pipeline_fetch_data__valid(pipeline_fetch_data__valid),
        .pipeline_response__pipeline_empty(pipeline_response__pipeline_empty),
        .pipeline_response__rfw__data(pipeline_response__rfw__data),
        .pipeline_response__rfw__rd(pipeline_response__rfw__rd),
        .pipeline_response__rfw__rd_written(pipeline_response__rfw__rd_written),
        .pipeline_response__rfw__valid(pipeline_response__rfw__valid),
        .pipeline_response__exec__pc_if_mispredicted(pipeline_response__exec__pc_if_mispredicted),
        .pipeline_response__exec__predicted_branch(pipeline_response__exec__predicted_branch),
        .pipeline_response__exec__pc(pipeline_response__exec__pc),
        .pipeline_response__exec__rs2(pipeline_response__exec__rs2),
        .pipeline_response__exec__rs1(pipeline_response__exec__rs1),
        .pipeline_response__exec__instruction__debug__data(pipeline_response__exec__instruction__debug__data),
        .pipeline_response__exec__instruction__debug__debug_op(pipeline_response__exec__instruction__debug__debug_op),
        .pipeline_response__exec__instruction__debug__valid(pipeline_response__exec__instruction__debug__valid),
        .pipeline_response__exec__instruction__data(pipeline_response__exec__instruction__data),
        .pipeline_response__exec__is_compressed(pipeline_response__exec__is_compressed),
        .pipeline_response__exec__trap__ebreak_to_dbg(pipeline_response__exec__trap__ebreak_to_dbg),
        .pipeline_response__exec__trap__vector(pipeline_response__exec__trap__vector),
        .pipeline_response__exec__trap__ret(pipeline_response__exec__trap__ret),
        .pipeline_response__exec__trap__value(pipeline_response__exec__trap__value),
        .pipeline_response__exec__trap__pc(pipeline_response__exec__trap__pc),
        .pipeline_response__exec__trap__cause(pipeline_response__exec__trap__cause),
        .pipeline_response__exec__trap__to_mode(pipeline_response__exec__trap__to_mode),
        .pipeline_response__exec__trap__valid(pipeline_response__exec__trap__valid),
        .pipeline_response__exec__branch_taken(pipeline_response__exec__branch_taken),
        .pipeline_response__exec__interrupt_ack(pipeline_response__exec__interrupt_ack),
        .pipeline_response__exec__cannot_complete(pipeline_response__exec__cannot_complete),
        .pipeline_response__exec__cannot_start(pipeline_response__exec__cannot_start),
        .pipeline_response__exec__valid(pipeline_response__exec__valid),
        .pipeline_response__decode__enable_branch_prediction(pipeline_response__decode__enable_branch_prediction),
        .pipeline_response__decode__idecode__ext__dummy(pipeline_response__decode__idecode__ext__dummy),
        .pipeline_response__decode__idecode__is_compressed(pipeline_response__decode__idecode__is_compressed),
        .pipeline_response__decode__idecode__illegal_pc(pipeline_response__decode__idecode__illegal_pc),
        .pipeline_response__decode__idecode__illegal(pipeline_response__decode__idecode__illegal),
        .pipeline_response__decode__idecode__memory_width(pipeline_response__decode__idecode__memory_width),
        .pipeline_response__decode__idecode__memory_read_unsigned(pipeline_response__decode__idecode__memory_read_unsigned),
        .pipeline_response__decode__idecode__requires_machine_mode(pipeline_response__decode__idecode__requires_machine_mode),
        .pipeline_response__decode__idecode__subop(pipeline_response__decode__idecode__subop),
        .pipeline_response__decode__idecode__op(pipeline_response__decode__idecode__op),
        .pipeline_response__decode__idecode__immediate_valid(pipeline_response__decode__idecode__immediate_valid),
        .pipeline_response__decode__idecode__immediate_shift(pipeline_response__decode__idecode__immediate_shift),
        .pipeline_response__decode__idecode__immediate(pipeline_response__decode__idecode__immediate),
        .pipeline_response__decode__idecode__csr_access__write_data(pipeline_response__decode__idecode__csr_access__write_data),
        .pipeline_response__decode__idecode__csr_access__address(pipeline_response__decode__idecode__csr_access__address),
        .pipeline_response__decode__idecode__csr_access__access(pipeline_response__decode__idecode__csr_access__access),
        .pipeline_response__decode__idecode__csr_access__access_cancelled(pipeline_response__decode__idecode__csr_access__access_cancelled),
        .pipeline_response__decode__idecode__rd_written(pipeline_response__decode__idecode__rd_written),
        .pipeline_response__decode__idecode__rd(pipeline_response__decode__idecode__rd),
        .pipeline_response__decode__idecode__rs2_valid(pipeline_response__decode__idecode__rs2_valid),
        .pipeline_response__decode__idecode__rs2(pipeline_response__decode__idecode__rs2),
        .pipeline_response__decode__idecode__rs1_valid(pipeline_response__decode__idecode__rs1_valid),
        .pipeline_response__decode__idecode__rs1(pipeline_response__decode__idecode__rs1),
        .pipeline_response__decode__branch_target(pipeline_response__decode__branch_target),
        .pipeline_response__decode__blocked(pipeline_response__decode__blocked),
        .pipeline_response__decode__valid(pipeline_response__decode__valid),
        .csrs__dscratch1(csrs__dscratch1),
        .csrs__dscratch0(csrs__dscratch0),
        .csrs__depc(csrs__depc),
        .csrs__dcsr__prv(csrs__dcsr__prv),
        .csrs__dcsr__step(csrs__dcsr__step),
        .csrs__dcsr__nmip(csrs__dcsr__nmip),
        .csrs__dcsr__mprven(csrs__dcsr__mprven),
        .csrs__dcsr__cause(csrs__dcsr__cause),
        .csrs__dcsr__stoptime(csrs__dcsr__stoptime),
        .csrs__dcsr__stopcount(csrs__dcsr__stopcount),
        .csrs__dcsr__stepie(csrs__dcsr__stepie),
        .csrs__dcsr__ebreaku(csrs__dcsr__ebreaku),
        .csrs__dcsr__ebreaks(csrs__dcsr__ebreaks),
        .csrs__dcsr__ebreakm(csrs__dcsr__ebreakm),
        .csrs__dcsr__xdebug_ver(csrs__dcsr__xdebug_ver),
        .csrs__mie__usip(csrs__mie__usip),
        .csrs__mie__ssip(csrs__mie__ssip),
        .csrs__mie__msip(csrs__mie__msip),
        .csrs__mie__utip(csrs__mie__utip),
        .csrs__mie__stip(csrs__mie__stip),
        .csrs__mie__mtip(csrs__mie__mtip),
        .csrs__mie__ueip(csrs__mie__ueip),
        .csrs__mie__seip(csrs__mie__seip),
        .csrs__mie__meip(csrs__mie__meip),
        .csrs__mip__usip(csrs__mip__usip),
        .csrs__mip__ssip(csrs__mip__ssip),
        .csrs__mip__msip(csrs__mip__msip),
        .csrs__mip__utip(csrs__mip__utip),
        .csrs__mip__stip(csrs__mip__stip),
        .csrs__mip__mtip(csrs__mip__mtip),
        .csrs__mip__ueip_sw(csrs__mip__ueip_sw),
        .csrs__mip__seip_sw(csrs__mip__seip_sw),
        .csrs__mip__ueip(csrs__mip__ueip),
        .csrs__mip__seip(csrs__mip__seip),
        .csrs__mip__meip(csrs__mip__meip),
        .csrs__mstatus__uie(csrs__mstatus__uie),
        .csrs__mstatus__sie(csrs__mstatus__sie),
        .csrs__mstatus__mie(csrs__mstatus__mie),
        .csrs__mstatus__upie(csrs__mstatus__upie),
        .csrs__mstatus__spie(csrs__mstatus__spie),
        .csrs__mstatus__mpie(csrs__mstatus__mpie),
        .csrs__mstatus__spp(csrs__mstatus__spp),
        .csrs__mstatus__mpp(csrs__mstatus__mpp),
        .csrs__mstatus__fs(csrs__mstatus__fs),
        .csrs__mstatus__xs(csrs__mstatus__xs),
        .csrs__mstatus__mprv(csrs__mstatus__mprv),
        .csrs__mstatus__sum(csrs__mstatus__sum),
        .csrs__mstatus__mxr(csrs__mstatus__mxr),
        .csrs__mstatus__tvm(csrs__mstatus__tvm),
        .csrs__mstatus__tw(csrs__mstatus__tw),
        .csrs__mstatus__tsr(csrs__mstatus__tsr),
        .csrs__mstatus__sd(csrs__mstatus__sd),
        .csrs__mtvec__vectored(csrs__mtvec__vectored),
        .csrs__mtvec__base(csrs__mtvec__base),
        .csrs__mtval(csrs__mtval),
        .csrs__mcause(csrs__mcause),
        .csrs__mepc(csrs__mepc),
        .csrs__mscratch(csrs__mscratch),
        .csrs__time(csrs__time),
        .csrs__instret(csrs__instret),
        .csrs__cycles(csrs__cycles),
        .riscv_clk_enable(1'h1),
        .reset_n(reset_n),
        .debug_tgt__attention(            debug_tgt1__attention),
        .debug_tgt__data(            debug_tgt1__data),
        .debug_tgt__resp(            debug_tgt1__resp),
        .debug_tgt__op_was_none(            debug_tgt1__op_was_none),
        .debug_tgt__hit_breakpoint(            debug_tgt1__hit_breakpoint),
        .debug_tgt__resumed(            debug_tgt1__resumed),
        .debug_tgt__halted(            debug_tgt1__halted),
        .debug_tgt__selected(            debug_tgt1__selected),
        .debug_tgt__valid(            debug_tgt1__valid),
        .pipeline_control__instruction_debug__data(            pipeline_control1__instruction_debug__data),
        .pipeline_control__instruction_debug__debug_op(            pipeline_control1__instruction_debug__debug_op),
        .pipeline_control__instruction_debug__valid(            pipeline_control1__instruction_debug__valid),
        .pipeline_control__instruction_data(            pipeline_control1__instruction_data),
        .pipeline_control__interrupt_to_mode(            pipeline_control1__interrupt_to_mode),
        .pipeline_control__interrupt_number(            pipeline_control1__interrupt_number),
        .pipeline_control__interrupt_req(            pipeline_control1__interrupt_req),
        .pipeline_control__ebreak_to_dbg(            pipeline_control1__ebreak_to_dbg),
        .pipeline_control__halt(            pipeline_control1__halt),
        .pipeline_control__tag(            pipeline_control1__tag),
        .pipeline_control__error(            pipeline_control1__error),
        .pipeline_control__mode(            pipeline_control1__mode),
        .pipeline_control__decode_pc(            pipeline_control1__decode_pc),
        .pipeline_control__fetch_action(            pipeline_control1__fetch_action),
        .pipeline_control__valid(            pipeline_control1__valid)         );
    //b dut_instance combinatorial process
    always @ ( * )//dut_instance
    begin: dut_instance__comb_code
    reg riscv_config__debug_enable__var;
    reg debug_tgt__valid__var;
    reg [5:0]debug_tgt__selected__var;
    reg debug_tgt__halted__var;
    reg debug_tgt__resumed__var;
    reg debug_tgt__hit_breakpoint__var;
    reg debug_tgt__op_was_none__var;
    reg [1:0]debug_tgt__resp__var;
    reg [31:0]debug_tgt__data__var;
    reg debug_tgt__attention__var;
        tck_enable_fix = tck_enable;
        riscv_config__i32c = 1'h0;
        riscv_config__e32 = 1'h0;
        riscv_config__i32m = 1'h0;
        riscv_config__i32m_fuse = 1'h0;
        riscv_config__debug_enable__var = 1'h0;
        riscv_config__coproc_disable = 1'h0;
        riscv_config__unaligned_mem = 1'h0;
        riscv_config__debug_enable__var = 1'h1;
        pipeline_response__decode__valid = 1'h0;
        pipeline_response__decode__blocked = 1'h0;
        pipeline_response__decode__branch_target = 32'h0;
        pipeline_response__decode__idecode__rs1 = 5'h0;
        pipeline_response__decode__idecode__rs1_valid = 1'h0;
        pipeline_response__decode__idecode__rs2 = 5'h0;
        pipeline_response__decode__idecode__rs2_valid = 1'h0;
        pipeline_response__decode__idecode__rd = 5'h0;
        pipeline_response__decode__idecode__rd_written = 1'h0;
        pipeline_response__decode__idecode__csr_access__access_cancelled = 1'h0;
        pipeline_response__decode__idecode__csr_access__access = 3'h0;
        pipeline_response__decode__idecode__csr_access__address = 12'h0;
        pipeline_response__decode__idecode__csr_access__write_data = 32'h0;
        pipeline_response__decode__idecode__immediate = 32'h0;
        pipeline_response__decode__idecode__immediate_shift = 5'h0;
        pipeline_response__decode__idecode__immediate_valid = 1'h0;
        pipeline_response__decode__idecode__op = 4'h0;
        pipeline_response__decode__idecode__subop = 4'h0;
        pipeline_response__decode__idecode__requires_machine_mode = 1'h0;
        pipeline_response__decode__idecode__memory_read_unsigned = 1'h0;
        pipeline_response__decode__idecode__memory_width = 2'h0;
        pipeline_response__decode__idecode__illegal = 1'h0;
        pipeline_response__decode__idecode__illegal_pc = 1'h0;
        pipeline_response__decode__idecode__is_compressed = 1'h0;
        pipeline_response__decode__idecode__ext__dummy = 1'h0;
        pipeline_response__decode__enable_branch_prediction = 1'h0;
        pipeline_response__exec__valid = 1'h0;
        pipeline_response__exec__cannot_start = 1'h0;
        pipeline_response__exec__cannot_complete = 1'h0;
        pipeline_response__exec__interrupt_ack = 1'h0;
        pipeline_response__exec__branch_taken = 1'h0;
        pipeline_response__exec__trap__valid = 1'h0;
        pipeline_response__exec__trap__to_mode = 3'h0;
        pipeline_response__exec__trap__cause = 4'h0;
        pipeline_response__exec__trap__pc = 32'h0;
        pipeline_response__exec__trap__value = 32'h0;
        pipeline_response__exec__trap__ret = 1'h0;
        pipeline_response__exec__trap__vector = 1'h0;
        pipeline_response__exec__trap__ebreak_to_dbg = 1'h0;
        pipeline_response__exec__is_compressed = 1'h0;
        pipeline_response__exec__instruction__data = 32'h0;
        pipeline_response__exec__instruction__debug__valid = 1'h0;
        pipeline_response__exec__instruction__debug__debug_op = 2'h0;
        pipeline_response__exec__instruction__debug__data = 16'h0;
        pipeline_response__exec__rs1 = 32'h0;
        pipeline_response__exec__rs2 = 32'h0;
        pipeline_response__exec__pc = 32'h0;
        pipeline_response__exec__predicted_branch = 1'h0;
        pipeline_response__exec__pc_if_mispredicted = 32'h0;
        pipeline_response__rfw__valid = 1'h0;
        pipeline_response__rfw__rd_written = 1'h0;
        pipeline_response__rfw__rd = 5'h0;
        pipeline_response__rfw__data = 32'h0;
        pipeline_response__pipeline_empty = 1'h0;
        pipeline_fetch_data__valid = 1'h0;
        pipeline_fetch_data__pc = 32'h0;
        pipeline_fetch_data__instruction__data = 32'h0;
        pipeline_fetch_data__instruction__debug__valid = 1'h0;
        pipeline_fetch_data__instruction__debug__debug_op = 2'h0;
        pipeline_fetch_data__instruction__debug__data = 16'h0;
        pipeline_fetch_data__dec_flush_pipeline = 1'h0;
        pipeline_fetch_data__dec_predicted_branch = 1'h0;
        pipeline_fetch_data__dec_pc_if_mispredicted = 32'h0;
        trace__instr_valid = 1'h0;
        trace__instr_pc = 32'h0;
        trace__instruction__data = 32'h0;
        trace__instruction__debug__valid = 1'h0;
        trace__instruction__debug__debug_op = 2'h0;
        trace__instruction__debug__data = 16'h0;
        trace__rfw_retire = 1'h0;
        trace__rfw_data_valid = 1'h0;
        trace__rfw_rd = 5'h0;
        trace__rfw_data = 32'h0;
        trace__branch_taken = 1'h0;
        trace__branch_target = 32'h0;
        trace__trap = 1'h0;
        csrs__cycles = 64'h0;
        csrs__instret = 64'h0;
        csrs__time = 64'h0;
        csrs__mscratch = 32'h0;
        csrs__mepc = 32'h0;
        csrs__mcause = 32'h0;
        csrs__mtval = 32'h0;
        csrs__mtvec__base = 30'h0;
        csrs__mtvec__vectored = 1'h0;
        csrs__mstatus__sd = 1'h0;
        csrs__mstatus__tsr = 1'h0;
        csrs__mstatus__tw = 1'h0;
        csrs__mstatus__tvm = 1'h0;
        csrs__mstatus__mxr = 1'h0;
        csrs__mstatus__sum = 1'h0;
        csrs__mstatus__mprv = 1'h0;
        csrs__mstatus__xs = 2'h0;
        csrs__mstatus__fs = 2'h0;
        csrs__mstatus__mpp = 2'h0;
        csrs__mstatus__spp = 1'h0;
        csrs__mstatus__mpie = 1'h0;
        csrs__mstatus__spie = 1'h0;
        csrs__mstatus__upie = 1'h0;
        csrs__mstatus__mie = 1'h0;
        csrs__mstatus__sie = 1'h0;
        csrs__mstatus__uie = 1'h0;
        csrs__mip__meip = 1'h0;
        csrs__mip__seip = 1'h0;
        csrs__mip__ueip = 1'h0;
        csrs__mip__seip_sw = 1'h0;
        csrs__mip__ueip_sw = 1'h0;
        csrs__mip__mtip = 1'h0;
        csrs__mip__stip = 1'h0;
        csrs__mip__utip = 1'h0;
        csrs__mip__msip = 1'h0;
        csrs__mip__ssip = 1'h0;
        csrs__mip__usip = 1'h0;
        csrs__mie__meip = 1'h0;
        csrs__mie__seip = 1'h0;
        csrs__mie__ueip = 1'h0;
        csrs__mie__mtip = 1'h0;
        csrs__mie__stip = 1'h0;
        csrs__mie__utip = 1'h0;
        csrs__mie__msip = 1'h0;
        csrs__mie__ssip = 1'h0;
        csrs__mie__usip = 1'h0;
        csrs__dcsr__xdebug_ver = 4'h0;
        csrs__dcsr__ebreakm = 1'h0;
        csrs__dcsr__ebreaks = 1'h0;
        csrs__dcsr__ebreaku = 1'h0;
        csrs__dcsr__stepie = 1'h0;
        csrs__dcsr__stopcount = 1'h0;
        csrs__dcsr__stoptime = 1'h0;
        csrs__dcsr__cause = 3'h0;
        csrs__dcsr__mprven = 1'h0;
        csrs__dcsr__nmip = 1'h0;
        csrs__dcsr__step = 1'h0;
        csrs__dcsr__prv = 2'h0;
        csrs__depc = 32'h0;
        csrs__dscratch0 = 32'h0;
        csrs__dscratch1 = 32'h0;
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
        riscv_config__debug_enable = riscv_config__debug_enable__var;
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
