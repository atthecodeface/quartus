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

//a Module tb_riscv_i32c_pipeline3
module tb_riscv_i32c_pipeline3
(
    clk,
    clk__enable,

    reset_n

);

    //b Clocks
    input clk;
    input clk__enable;
    wire riscv_clk; // Gated version of clock 'clk' enabled by 'riscv_clk_cycle_2'
    wire riscv_clk__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg [31:0]dmem_write_data;
    reg [13:0]dmem_address;
    reg dmem_read_not_write;
    reg dmem_select;
    reg [31:0]last_imem_mem_read_data;
    reg riscv_clk_cycle_2;
    reg riscv_clk_cycle_1;
    reg riscv_clk_cycle_0;
    reg [1:0]clk_divider;

    //b Internal combinatorials
    reg coproc_response__cannot_start;
    reg [31:0]coproc_response__result;
    reg coproc_response__result_valid;
    reg coproc_response__cannot_complete;
    reg riscv_config__i32c;
    reg riscv_config__e32;
    reg riscv_config__i32m;
    reg riscv_config__i32m_fuse;
    reg riscv_config__coproc_disable;
    reg riscv_config__unaligned_mem;
    reg rv_imem_access_resp__valid;
    reg rv_imem_access_resp__debug;
    reg [31:0]rv_imem_access_resp__data;
    reg [2:0]rv_imem_access_resp__mode;
    reg rv_imem_access_resp__error;
    reg [1:0]rv_imem_access_resp__tag;
    reg imem_access_req__valid;
    reg [31:0]imem_access_req__address;
    reg imem_access_req__sequential;
    reg [2:0]imem_access_req__mode;
    reg imem_access_req__flush;
    reg dmem_access_resp__wait;
    reg [31:0]dmem_access_resp__read_data;

    //b Internal nets
    wire trace__instr_valid;
    wire [31:0]trace__instr_pc;
    wire [2:0]trace__instruction__mode;
    wire [31:0]trace__instruction__data;
    wire trace__rfw_retire;
    wire trace__rfw_data_valid;
    wire [4:0]trace__rfw_rd;
    wire [31:0]trace__rfw_data;
    wire trace__branch_taken;
    wire [31:0]trace__branch_target;
    wire trace__trap;
    wire coproc_controls__dec_idecode_valid;
    wire [4:0]coproc_controls__dec_idecode__rs1;
    wire coproc_controls__dec_idecode__rs1_valid;
    wire [4:0]coproc_controls__dec_idecode__rs2;
    wire coproc_controls__dec_idecode__rs2_valid;
    wire [4:0]coproc_controls__dec_idecode__rd;
    wire coproc_controls__dec_idecode__rd_written;
    wire [2:0]coproc_controls__dec_idecode__csr_access__access;
    wire [11:0]coproc_controls__dec_idecode__csr_access__address;
    wire [31:0]coproc_controls__dec_idecode__immediate;
    wire [4:0]coproc_controls__dec_idecode__immediate_shift;
    wire coproc_controls__dec_idecode__immediate_valid;
    wire [3:0]coproc_controls__dec_idecode__op;
    wire [3:0]coproc_controls__dec_idecode__subop;
    wire coproc_controls__dec_idecode__requires_machine_mode;
    wire coproc_controls__dec_idecode__memory_read_unsigned;
    wire [1:0]coproc_controls__dec_idecode__memory_width;
    wire coproc_controls__dec_idecode__illegal;
    wire coproc_controls__dec_idecode__is_compressed;
    wire coproc_controls__dec_idecode__ext__dummy;
    wire coproc_controls__dec_to_alu_blocked;
    wire [31:0]coproc_controls__alu_rs1;
    wire [31:0]coproc_controls__alu_rs2;
    wire coproc_controls__alu_flush_pipeline;
    wire coproc_controls__alu_cannot_start;
    wire coproc_controls__alu_cannot_complete;
    wire [31:0]main_mem_read_data;
    wire [31:0]imem_mem_read_data;
    wire rv_imem_access_req__valid;
    wire [31:0]rv_imem_access_req__address;
    wire rv_imem_access_req__sequential;
    wire [2:0]rv_imem_access_req__mode;
    wire rv_imem_access_req__flush;
    wire [31:0]dmem_access_req__address;
    wire [3:0]dmem_access_req__byte_enable;
    wire dmem_access_req__write_enable;
    wire dmem_access_req__read_enable;
    wire [31:0]dmem_access_req__write_data;

    //b Clock gating module instances
    assign riscv_clk__enable = (clk__enable && riscv_clk_cycle_2);
    //b Module instances
    se_sram_srw_16384x32 imem(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(32'h0),
        .address(imem_access_req__address[15:2]),
        .write_enable(1'h1),
        .read_not_write(1'h1),
        .select((imem_access_req__valid & ((riscv_clk_cycle_0!=1'h0)||(riscv_clk_cycle_1!=1'h0)))),
        .data_out(            imem_mem_read_data)         );
    se_sram_srw_16384x32_we8 dmem(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(dmem_write_data),
        .address(dmem_address),
        .write_enable(4'hf),
        .read_not_write(dmem_read_not_write),
        .select(dmem_select),
        .data_out(            main_mem_read_data)         );
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .a(1'h0)         );
    riscv_i32c_pipeline3 dut(
        .clk(clk),
        .clk__enable(riscv_clk__enable),
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .coproc_response__cannot_complete(coproc_response__cannot_complete),
        .coproc_response__result_valid(coproc_response__result_valid),
        .coproc_response__result(coproc_response__result),
        .coproc_response__cannot_start(coproc_response__cannot_start),
        .ifetch_resp__tag(rv_imem_access_resp__tag),
        .ifetch_resp__error(rv_imem_access_resp__error),
        .ifetch_resp__mode(rv_imem_access_resp__mode),
        .ifetch_resp__data(rv_imem_access_resp__data),
        .ifetch_resp__debug(rv_imem_access_resp__debug),
        .ifetch_resp__valid(rv_imem_access_resp__valid),
        .dmem_access_resp__read_data(dmem_access_resp__read_data),
        .dmem_access_resp__wait(dmem_access_resp__wait),
        .reset_n(reset_n),
        .trace__trap(            trace__trap),
        .trace__branch_target(            trace__branch_target),
        .trace__branch_taken(            trace__branch_taken),
        .trace__rfw_data(            trace__rfw_data),
        .trace__rfw_rd(            trace__rfw_rd),
        .trace__rfw_data_valid(            trace__rfw_data_valid),
        .trace__rfw_retire(            trace__rfw_retire),
        .trace__instruction__data(            trace__instruction__data),
        .trace__instruction__mode(            trace__instruction__mode),
        .trace__instr_pc(            trace__instr_pc),
        .trace__instr_valid(            trace__instr_valid),
        .coproc_controls__alu_cannot_complete(            coproc_controls__alu_cannot_complete),
        .coproc_controls__alu_cannot_start(            coproc_controls__alu_cannot_start),
        .coproc_controls__alu_flush_pipeline(            coproc_controls__alu_flush_pipeline),
        .coproc_controls__alu_rs2(            coproc_controls__alu_rs2),
        .coproc_controls__alu_rs1(            coproc_controls__alu_rs1),
        .coproc_controls__dec_to_alu_blocked(            coproc_controls__dec_to_alu_blocked),
        .coproc_controls__dec_idecode__ext__dummy(            coproc_controls__dec_idecode__ext__dummy),
        .coproc_controls__dec_idecode__is_compressed(            coproc_controls__dec_idecode__is_compressed),
        .coproc_controls__dec_idecode__illegal(            coproc_controls__dec_idecode__illegal),
        .coproc_controls__dec_idecode__memory_width(            coproc_controls__dec_idecode__memory_width),
        .coproc_controls__dec_idecode__memory_read_unsigned(            coproc_controls__dec_idecode__memory_read_unsigned),
        .coproc_controls__dec_idecode__requires_machine_mode(            coproc_controls__dec_idecode__requires_machine_mode),
        .coproc_controls__dec_idecode__subop(            coproc_controls__dec_idecode__subop),
        .coproc_controls__dec_idecode__op(            coproc_controls__dec_idecode__op),
        .coproc_controls__dec_idecode__immediate_valid(            coproc_controls__dec_idecode__immediate_valid),
        .coproc_controls__dec_idecode__immediate_shift(            coproc_controls__dec_idecode__immediate_shift),
        .coproc_controls__dec_idecode__immediate(            coproc_controls__dec_idecode__immediate),
        .coproc_controls__dec_idecode__csr_access__address(            coproc_controls__dec_idecode__csr_access__address),
        .coproc_controls__dec_idecode__csr_access__access(            coproc_controls__dec_idecode__csr_access__access),
        .coproc_controls__dec_idecode__rd_written(            coproc_controls__dec_idecode__rd_written),
        .coproc_controls__dec_idecode__rd(            coproc_controls__dec_idecode__rd),
        .coproc_controls__dec_idecode__rs2_valid(            coproc_controls__dec_idecode__rs2_valid),
        .coproc_controls__dec_idecode__rs2(            coproc_controls__dec_idecode__rs2),
        .coproc_controls__dec_idecode__rs1_valid(            coproc_controls__dec_idecode__rs1_valid),
        .coproc_controls__dec_idecode__rs1(            coproc_controls__dec_idecode__rs1),
        .coproc_controls__dec_idecode_valid(            coproc_controls__dec_idecode_valid),
        .ifetch_req__flush(            rv_imem_access_req__flush),
        .ifetch_req__mode(            rv_imem_access_req__mode),
        .ifetch_req__sequential(            rv_imem_access_req__sequential),
        .ifetch_req__address(            rv_imem_access_req__address),
        .ifetch_req__valid(            rv_imem_access_req__valid),
        .dmem_access_req__write_data(            dmem_access_req__write_data),
        .dmem_access_req__read_enable(            dmem_access_req__read_enable),
        .dmem_access_req__write_enable(            dmem_access_req__write_enable),
        .dmem_access_req__byte_enable(            dmem_access_req__byte_enable),
        .dmem_access_req__address(            dmem_access_req__address)         );
    riscv_i32_trace trace(
        .clk(clk),
        .clk__enable(riscv_clk__enable),
        .trace__trap(trace__trap),
        .trace__branch_target(trace__branch_target),
        .trace__branch_taken(trace__branch_taken),
        .trace__rfw_data(trace__rfw_data),
        .trace__rfw_rd(trace__rfw_rd),
        .trace__rfw_data_valid(trace__rfw_data_valid),
        .trace__rfw_retire(trace__rfw_retire),
        .trace__instruction__data(trace__instruction__data),
        .trace__instruction__mode(trace__instruction__mode),
        .trace__instr_pc(trace__instr_pc),
        .trace__instr_valid(trace__instr_valid),
        .reset_n(reset_n)         );
    //b clock_divider clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : clock_divider__code
        if (reset_n==1'b0)
        begin
            riscv_clk_cycle_0 <= 1'h1;
            riscv_clk_cycle_1 <= 1'h0;
            riscv_clk_cycle_2 <= 1'h0;
            clk_divider <= 2'h0;
        end
        else if (clk__enable)
        begin
            riscv_clk_cycle_0 <= (clk_divider==2'h2);
            riscv_clk_cycle_1 <= (clk_divider==2'h0);
            riscv_clk_cycle_2 <= (clk_divider==2'h1);
            clk_divider <= (clk_divider+2'h1);
            if ((riscv_clk_cycle_2!=1'h0))
            begin
                clk_divider <= 2'h0;
            end //if
        end //if
    end //always

    //b srams__comb combinatorial process
    always @ ( * )//srams__comb
    begin: srams__comb_code
    reg rv_imem_access_resp__valid__var;
    reg [31:0]rv_imem_access_resp__data__var;
    reg [2:0]rv_imem_access_resp__mode__var;
    reg imem_access_req__valid__var;
    reg [31:0]imem_access_req__address__var;
    reg imem_access_req__sequential__var;
    reg [2:0]imem_access_req__mode__var;
    reg imem_access_req__flush__var;
        rv_imem_access_resp__valid__var = 1'h0;
        rv_imem_access_resp__debug = 1'h0;
        rv_imem_access_resp__data__var = 32'h0;
        rv_imem_access_resp__mode__var = 3'h0;
        rv_imem_access_resp__error = 1'h0;
        rv_imem_access_resp__tag = 2'h0;
        rv_imem_access_resp__valid__var = 1'h1;
        rv_imem_access_resp__data__var = imem_mem_read_data;
        rv_imem_access_resp__mode__var = rv_imem_access_req__mode;
        if (!(rv_imem_access_req__address[1]!=1'h0))
        begin
            imem_access_req__valid__var = rv_imem_access_req__valid;
            imem_access_req__address__var = rv_imem_access_req__address;
            imem_access_req__sequential__var = rv_imem_access_req__sequential;
            imem_access_req__mode__var = rv_imem_access_req__mode;
            imem_access_req__flush__var = rv_imem_access_req__flush;
            rv_imem_access_resp__data__var = imem_mem_read_data;
        end //if
        else
        
        begin
            if ((riscv_clk_cycle_0!=1'h0))
            begin
                imem_access_req__valid__var = rv_imem_access_req__valid;
                imem_access_req__address__var = rv_imem_access_req__address;
                imem_access_req__sequential__var = rv_imem_access_req__sequential;
                imem_access_req__mode__var = rv_imem_access_req__mode;
                imem_access_req__flush__var = rv_imem_access_req__flush;
            end //if
            else
            
            begin
                imem_access_req__valid__var = rv_imem_access_req__valid;
                imem_access_req__address__var = rv_imem_access_req__address;
                imem_access_req__sequential__var = rv_imem_access_req__sequential;
                imem_access_req__mode__var = rv_imem_access_req__mode;
                imem_access_req__flush__var = rv_imem_access_req__flush;
                imem_access_req__address__var = (rv_imem_access_req__address+32'h4);
                rv_imem_access_resp__data__var = {imem_mem_read_data[15:0],last_imem_mem_read_data[31:16]};
            end //else
        end //else
        dmem_access_resp__wait = 1'h0;
        dmem_access_resp__read_data = main_mem_read_data;
        rv_imem_access_resp__valid = rv_imem_access_resp__valid__var;
        rv_imem_access_resp__data = rv_imem_access_resp__data__var;
        rv_imem_access_resp__mode = rv_imem_access_resp__mode__var;
        imem_access_req__valid = imem_access_req__valid__var;
        imem_access_req__address = imem_access_req__address__var;
        imem_access_req__sequential = imem_access_req__sequential__var;
        imem_access_req__mode = imem_access_req__mode__var;
        imem_access_req__flush = imem_access_req__flush__var;
    end //always

    //b srams__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : srams__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            last_imem_mem_read_data <= 32'h0;
            dmem_select <= 1'h0;
            dmem_read_not_write <= 1'h0;
            dmem_address <= 14'h0;
            dmem_write_data <= 32'h0;
        end
        else if (clk__enable)
        begin
            last_imem_mem_read_data <= imem_mem_read_data;
            if ((riscv_clk_cycle_2!=1'h0))
            begin
                dmem_select <= ((dmem_access_req__read_enable!=1'h0)||(dmem_access_req__write_enable!=1'h0));
                dmem_read_not_write <= !(dmem_access_req__write_enable!=1'h0);
                dmem_address <= dmem_access_req__address[15:2];
                dmem_write_data <= dmem_access_req__write_data;
            end //if
        end //if
    end //always

    //b riscv_instance combinatorial process
    always @ ( * )//riscv_instance
    begin: riscv_instance__comb_code
    reg riscv_config__i32c__var;
    reg riscv_config__e32__var;
    reg riscv_config__i32m__var;
        riscv_config__i32c__var = 1'h0;
        riscv_config__e32__var = 1'h0;
        riscv_config__i32m__var = 1'h0;
        riscv_config__i32m_fuse = 1'h0;
        riscv_config__coproc_disable = 1'h0;
        riscv_config__unaligned_mem = 1'h0;
        riscv_config__i32c__var = 1'h1;
        riscv_config__e32__var = 1'h0;
        riscv_config__i32m__var = 1'h0;
        coproc_response__cannot_start = 1'h0;
        coproc_response__result = 32'h0;
        coproc_response__result_valid = 1'h0;
        coproc_response__cannot_complete = 1'h0;
        riscv_config__i32c = riscv_config__i32c__var;
        riscv_config__e32 = riscv_config__e32__var;
        riscv_config__i32m = riscv_config__i32m__var;
    end //always

endmodule // tb_riscv_i32c_pipeline3
