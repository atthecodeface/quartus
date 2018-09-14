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

//a Module riscv_i32_minimal
    //   
    //   An instantiation of the single stage pipeline RISC-V with RV32I with a single SRAM
    //   
    //   Compressed instructions are supported IF i32c_force_disable is 0 and riscv_config.i32c is 1
    //   
    //   A single memory is used for instruction and data, at address 0
    //   
    //   Any access outside of the bottom 1MB is passed as a request out of this module.
    //   
module riscv_i32_minimal
(
    clk,
    clk__enable,

    riscv_config__i32c,
    riscv_config__e32,
    riscv_config__i32m,
    riscv_config__i32m_fuse,
    riscv_config__coproc_disable,
    riscv_config__unaligned_mem,
    sram_access_req__valid,
    sram_access_req__id,
    sram_access_req__read_not_write,
    sram_access_req__byte_enable,
    sram_access_req__address,
    sram_access_req__write_data,
    data_access_resp__wait,
    data_access_resp__read_data,
    irqs__nmi,
    irqs__meip,
    irqs__seip,
    irqs__ueip,
    irqs__mtip,
    irqs__msip,
    irqs__time,
    reset_n,

    sram_access_resp__ack,
    sram_access_resp__valid,
    sram_access_resp__id,
    sram_access_resp__data,
    data_access_req__address,
    data_access_req__byte_enable,
    data_access_req__write_enable,
    data_access_req__read_enable,
    data_access_req__write_data,
    trace__instr_valid,
    trace__instr_pc,
    trace__instruction__mode,
    trace__instruction__data,
    trace__rfw_retire,
    trace__rfw_data_valid,
    trace__rfw_rd,
    trace__rfw_data,
    trace__branch_taken,
    trace__branch_target,
    trace__trap
);

    //b Clocks
    input clk;
    input clk__enable;
    wire riscv_clk; // Gated version of clock 'clk' enabled by 'riscv_clk_enable'
    wire riscv_clk__enable;

    //b Inputs
    input riscv_config__i32c;
    input riscv_config__e32;
    input riscv_config__i32m;
    input riscv_config__i32m_fuse;
    input riscv_config__coproc_disable;
    input riscv_config__unaligned_mem;
    input sram_access_req__valid;
    input [3:0]sram_access_req__id;
    input sram_access_req__read_not_write;
    input [7:0]sram_access_req__byte_enable;
    input [31:0]sram_access_req__address;
    input [63:0]sram_access_req__write_data;
    input data_access_resp__wait;
    input [31:0]data_access_resp__read_data;
        //   Interrupts in to the CPU
    input irqs__nmi;
    input irqs__meip;
    input irqs__seip;
    input irqs__ueip;
    input irqs__mtip;
    input irqs__msip;
    input [63:0]irqs__time;
    input reset_n;

    //b Outputs
    output sram_access_resp__ack;
    output sram_access_resp__valid;
    output [3:0]sram_access_resp__id;
    output [63:0]sram_access_resp__data;
    output [31:0]data_access_req__address;
    output [3:0]data_access_req__byte_enable;
    output data_access_req__write_enable;
    output data_access_req__read_enable;
    output [31:0]data_access_req__write_data;
    output trace__instr_valid;
    output [31:0]trace__instr_pc;
    output [2:0]trace__instruction__mode;
    output [31:0]trace__instruction__data;
    output trace__rfw_retire;
    output trace__rfw_data_valid;
    output [4:0]trace__rfw_rd;
    output [31:0]trace__rfw_data;
    output trace__branch_taken;
    output [31:0]trace__branch_target;
    output trace__trap;

// output components here

    //b Output combinatorials
    reg trace__instr_valid;
    reg [31:0]trace__instr_pc;
    reg [2:0]trace__instruction__mode;
    reg [31:0]trace__instruction__data;
    reg trace__rfw_retire;
    reg trace__rfw_data_valid;
    reg [4:0]trace__rfw_rd;
    reg [31:0]trace__rfw_data;
    reg trace__branch_taken;
    reg [31:0]trace__branch_target;
    reg trace__trap;

    //b Output nets

    //b Internal and output registers
    reg riscv_clk_high;
    reg [2:0]riscv_clock_phase;
    reg sram_access_req_r__valid;
    reg [3:0]sram_access_req_r__id;
    reg sram_access_req_r__read_not_write;
    reg [7:0]sram_access_req_r__byte_enable;
    reg [31:0]sram_access_req_r__address;
    reg [63:0]sram_access_req_r__write_data;
        //   Only used if RV32IC is enabled and configured
    reg [31:0]data_access_read_reg;
        //   Only used if RV32IC is enabled and configured
    reg [15:0]ifetch_last16_reg;
    reg [31:0]ifetch_reg;
    reg sram_access_resp__ack;
    reg sram_access_resp__valid;
    reg [3:0]sram_access_resp__id;
    reg [63:0]sram_access_resp__data;
    reg [31:0]data_access_req__address;
    reg [3:0]data_access_req__byte_enable;
    reg data_access_req__write_enable;
    reg data_access_req__read_enable;
    reg [31:0]data_access_req__write_data;

    //b Internal combinatorials
    reg [2:0]riscv_clock_action;
    reg riscv_clk_enable;
    reg sram_access_ack;
    reg [1:0]data_src;
    reg [1:0]ifetch_src;
    reg [31:0]mem_access_req__address;
    reg [3:0]mem_access_req__byte_enable;
    reg mem_access_req__write_enable;
    reg mem_access_req__read_enable;
    reg [31:0]mem_access_req__write_data;
        //   Asserted if either data_access read or write and the response wait is asserted
    reg data_access_wait;
        //   Asserted if either data_access read or write and the response wait is deasserted
    reg data_access_completing;
    reg [31:0]data_sram_access_req__address;
    reg [3:0]data_sram_access_req__byte_enable;
    reg data_sram_access_req__write_enable;
    reg data_sram_access_req__read_enable;
    reg [31:0]data_sram_access_req__write_data;
    reg dmem_access_resp__wait;
    reg [31:0]dmem_access_resp__read_data;
    reg riscv_config_pipe__i32c;
    reg riscv_config_pipe__e32;
    reg riscv_config_pipe__i32m;
    reg riscv_config_pipe__i32m_fuse;
    reg riscv_config_pipe__coproc_disable;
    reg riscv_config_pipe__unaligned_mem;
    reg coproc_response__cannot_start;
    reg [31:0]coproc_response__result;
    reg coproc_response__result_valid;
    reg coproc_response__cannot_complete;
    reg ifetch_resp__valid;
    reg ifetch_resp__debug;
    reg [31:0]ifetch_resp__data;
    reg [2:0]ifetch_resp__mode;
    reg ifetch_resp__error;
    reg [1:0]ifetch_resp__tag;

    //b Internal nets
    wire [31:0]mem_read_data;
    wire [31:0]dmem_access_req__address;
    wire [3:0]dmem_access_req__byte_enable;
    wire dmem_access_req__write_enable;
    wire dmem_access_req__read_enable;
    wire [31:0]dmem_access_req__write_data;
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
    wire trace_pipe__instr_valid;
    wire [31:0]trace_pipe__instr_pc;
    wire [2:0]trace_pipe__instruction__mode;
    wire [31:0]trace_pipe__instruction__data;
    wire trace_pipe__rfw_retire;
    wire trace_pipe__rfw_data_valid;
    wire [4:0]trace_pipe__rfw_rd;
    wire [31:0]trace_pipe__rfw_data;
    wire trace_pipe__branch_taken;
    wire [31:0]trace_pipe__branch_target;
    wire trace_pipe__trap;
    wire ifetch_req__valid;
    wire [31:0]ifetch_req__address;
    wire ifetch_req__sequential;
    wire [2:0]ifetch_req__mode;
    wire ifetch_req__flush;

    //b Clock gating module instances
    assign riscv_clk__enable = (clk__enable && riscv_clk_enable);
    //b Module instances
    se_sram_srw_16384x32_we8 mem(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(mem_access_req__write_data),
        .address(mem_access_req__address[15:2]),
        .write_enable(((mem_access_req__write_enable!=1'h0)?mem_access_req__byte_enable:4'h0)),
        .read_not_write(mem_access_req__read_enable),
        .select(((mem_access_req__read_enable!=1'h0)||(mem_access_req__write_enable!=1'h0))),
        .data_out(            mem_read_data)         );
    riscv_i32c_pipeline pipeline(
        .clk(clk),
        .clk__enable(riscv_clk__enable),
        .riscv_config__unaligned_mem(riscv_config_pipe__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config_pipe__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config_pipe__i32m_fuse),
        .riscv_config__i32m(riscv_config_pipe__i32m),
        .riscv_config__e32(riscv_config_pipe__e32),
        .riscv_config__i32c(riscv_config_pipe__i32c),
        .coproc_response__cannot_complete(coproc_response__cannot_complete),
        .coproc_response__result_valid(coproc_response__result_valid),
        .coproc_response__result(coproc_response__result),
        .coproc_response__cannot_start(coproc_response__cannot_start),
        .dmem_access_resp__read_data(dmem_access_resp__read_data),
        .dmem_access_resp__wait(dmem_access_resp__wait),
        .ifetch_resp__tag(ifetch_resp__tag),
        .ifetch_resp__error(ifetch_resp__error),
        .ifetch_resp__mode(ifetch_resp__mode),
        .ifetch_resp__data(ifetch_resp__data),
        .ifetch_resp__debug(ifetch_resp__debug),
        .ifetch_resp__valid(ifetch_resp__valid),
        .irqs__time(irqs__time),
        .irqs__msip(irqs__msip),
        .irqs__mtip(irqs__mtip),
        .irqs__ueip(irqs__ueip),
        .irqs__seip(irqs__seip),
        .irqs__meip(irqs__meip),
        .irqs__nmi(irqs__nmi),
        .reset_n(reset_n),
        .trace__trap(            trace_pipe__trap),
        .trace__branch_target(            trace_pipe__branch_target),
        .trace__branch_taken(            trace_pipe__branch_taken),
        .trace__rfw_data(            trace_pipe__rfw_data),
        .trace__rfw_rd(            trace_pipe__rfw_rd),
        .trace__rfw_data_valid(            trace_pipe__rfw_data_valid),
        .trace__rfw_retire(            trace_pipe__rfw_retire),
        .trace__instruction__data(            trace_pipe__instruction__data),
        .trace__instruction__mode(            trace_pipe__instruction__mode),
        .trace__instr_pc(            trace_pipe__instr_pc),
        .trace__instr_valid(            trace_pipe__instr_valid),
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
        .dmem_access_req__write_data(            dmem_access_req__write_data),
        .dmem_access_req__read_enable(            dmem_access_req__read_enable),
        .dmem_access_req__write_enable(            dmem_access_req__write_enable),
        .dmem_access_req__byte_enable(            dmem_access_req__byte_enable),
        .dmem_access_req__address(            dmem_access_req__address),
        .ifetch_req__flush(            ifetch_req__flush),
        .ifetch_req__mode(            ifetch_req__mode),
        .ifetch_req__sequential(            ifetch_req__sequential),
        .ifetch_req__address(            ifetch_req__address),
        .ifetch_req__valid(            ifetch_req__valid)         );
    //b data_decode__comb combinatorial process
        //   
        //       Decode a data access. A data access may decode into an SRAM access
        //       request, which remains stable in a riscv_clk period *after* the
        //       first clock cycle riscv_clk_high; or it may decode into a data
        //       access request, which is a registered request that is guaranteed
        //       to be 0 in riscv_clk_high, and may be set for subsequent clock
        //       cycles, until it has completed.
        //       
    always @ ( * )//data_decode__comb
    begin: data_decode__comb_code
    reg data_sram_access_req__write_enable__var;
    reg data_sram_access_req__read_enable__var;
        data_sram_access_req__address = dmem_access_req__address;
        data_sram_access_req__byte_enable = dmem_access_req__byte_enable;
        data_sram_access_req__write_enable__var = dmem_access_req__write_enable;
        data_sram_access_req__read_enable__var = dmem_access_req__read_enable;
        data_sram_access_req__write_data = dmem_access_req__write_data;
        if ((dmem_access_req__address[31:20]!=12'h0))
        begin
            data_sram_access_req__read_enable__var = 1'h0;
            data_sram_access_req__write_enable__var = 1'h0;
        end //if
        data_access_completing = (((data_access_req__read_enable!=1'h0)||(data_access_req__write_enable!=1'h0))&&!(data_access_resp__wait!=1'h0));
        data_access_wait = (((data_access_req__read_enable!=1'h0)||(data_access_req__write_enable!=1'h0))&&(data_access_resp__wait!=1'h0));
        data_sram_access_req__write_enable = data_sram_access_req__write_enable__var;
        data_sram_access_req__read_enable = data_sram_access_req__read_enable__var;
    end //always

    //b data_decode__posedge_clk_active_low_reset_n clock process
        //   
        //       Decode a data access. A data access may decode into an SRAM access
        //       request, which remains stable in a riscv_clk period *after* the
        //       first clock cycle riscv_clk_high; or it may decode into a data
        //       access request, which is a registered request that is guaranteed
        //       to be 0 in riscv_clk_high, and may be set for subsequent clock
        //       cycles, until it has completed.
        //       
    always @( posedge clk or negedge reset_n)
    begin : data_decode__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            data_access_req__read_enable <= 1'h0;
            data_access_req__write_enable <= 1'h0;
            data_access_req__address <= 32'h0;
            data_access_req__byte_enable <= 4'h0;
            data_access_req__write_data <= 32'h0;
        end
        else if (clk__enable)
        begin
            if ((riscv_clk_high!=1'h0))
            begin
                data_access_req__read_enable <= 1'h0;
                data_access_req__write_enable <= 1'h0;
                if (((dmem_access_req__read_enable!=1'h0)||(dmem_access_req__write_enable!=1'h0)))
                begin
                    data_access_req__address <= dmem_access_req__address;
                    data_access_req__byte_enable <= dmem_access_req__byte_enable;
                    data_access_req__write_enable <= dmem_access_req__write_enable;
                    data_access_req__read_enable <= dmem_access_req__read_enable;
                    data_access_req__write_data <= dmem_access_req__write_data;
                end //if
                if ((dmem_access_req__address[31:20]==12'h0))
                begin
                    data_access_req__read_enable <= 1'h0;
                    data_access_req__write_enable <= 1'h0;
                end //if
            end //if
            else
            
            begin
                if ((data_access_completing!=1'h0))
                begin
                    data_access_req__read_enable <= 1'h0;
                    data_access_req__write_enable <= 1'h0;
                end //if
            end //else
        end //if
    end //always

    //b clock_control__comb combinatorial process
        //   
        //       The clock control for a single SRAM implementation could be
        //       performed with three high speed clocks for each RISC-V
        //       clock. However, this is a slightly more sophisticated design.
        //   
        //       A minimal RISC-V clock cycle requires at most one instruction fetch and at
        //       most one of data read or data write.
        //   
        //       With a synchronous memory, a memory read must be presented to the
        //       SRAM at high speed clock cycle n-1 if the data is to be valid at
        //       the end of high speed clock cycle n.
        //   
        //       So if just an instruction fetch is required then a first high
        //       speed cycle is used to present the ifetch, and a second high speed
        //       cycle is the instruction being read. This is presented directly to
        //       the RISC-V core.
        //   
        //       If an instruction fetch and data read/write are required then a
        //       first high speed cycle is used to present the instruction fetch, a
        //       second to present the data read/write and perform the ifetch -
        //       with the data out registered at the start of a third high speed
        //       cycle while the data is being read (for data reads). This is
        //       presented directly to the RISC-V core; the instruction fetched is
        //       presented from its stored register
        //   
        //       If only a data read/write is required then that is presented in
        //       riscv_clk_high, with the data valid (on reads) at the end of the
        //       subsequent cycle.
        //   
        //       
    always @ ( * )//clock_control__comb
    begin: clock_control__comb_code
    reg [2:0]riscv_clock_action__var;
    reg [1:0]ifetch_src__var;
    reg [1:0]data_src__var;
    reg riscv_clk_enable__var;
        riscv_clock_action__var = 3'h0;
        ifetch_src__var = 2'h0;
        data_src__var = 2'h2;
        case (riscv_clock_phase) //synopsys parallel_case
        3'h0: // req 1
            begin
            riscv_clock_action__var = 3'h1;
            if ((ifetch_req__valid!=1'h0))
            begin
                riscv_clock_action__var = 3'h2;
                if ((1'h1||(riscv_config__i32c!=1'h0)))
                begin
                    if ((ifetch_req__address[1]!=1'h0))
                    begin
                        if ((ifetch_req__sequential!=1'h0))
                        begin
                            riscv_clock_action__var = 3'h7;
                        end //if
                        else
                        
                        begin
                            riscv_clock_action__var = 3'h6;
                        end //else
                    end //if
                end //if
            end //if
            else
            
            begin
                if ((data_sram_access_req__read_enable!=1'h0))
                begin
                    riscv_clock_action__var = 3'h3;
                end //if
                else
                
                begin
                    if ((data_sram_access_req__write_enable!=1'h0))
                    begin
                        riscv_clock_action__var = 3'h4;
                    end //if
                end //else
            end //else
            end
        3'h4: // req 1
            begin
            ifetch_src__var = 2'h1;
            riscv_clock_action__var = 3'h0;
            if ((data_access_wait!=1'h0))
            begin
                riscv_clock_action__var = 3'h5;
            end //if
            end
        3'h3: // req 1
            begin
            riscv_clock_action__var = 3'h0;
            if ((data_access_wait!=1'h0))
            begin
                riscv_clock_action__var = 3'h5;
            end //if
            if ((data_sram_access_req__read_enable!=1'h0))
            begin
                riscv_clock_action__var = 3'h3;
            end //if
            else
            
            begin
                if ((data_sram_access_req__write_enable!=1'h0))
                begin
                    riscv_clock_action__var = 3'h4;
                end //if
            end //else
            end
        3'h5: // req 1
            begin
            riscv_clock_action__var = 3'h7;
            end
        3'h6: // req 1
            begin
            data_src__var = 2'h1;
            if ((data_access_completing!=1'h0))
            begin
                data_src__var = 2'h2;
            end //if
            riscv_clock_action__var = 3'h0;
            ifetch_src__var = 2'h2;
            if ((data_access_wait!=1'h0))
            begin
                riscv_clock_action__var = 3'h5;
            end //if
            if ((data_sram_access_req__read_enable!=1'h0))
            begin
                riscv_clock_action__var = 3'h3;
            end //if
            else
            
            begin
                if ((data_sram_access_req__write_enable!=1'h0))
                begin
                    riscv_clock_action__var = 3'h4;
                end //if
            end //else
            end
        3'h2: // req 1
            begin
            riscv_clock_action__var = 3'h0;
            ifetch_src__var = 2'h1;
            end
        3'h1: // req 1
            begin
            riscv_clock_action__var = 3'h0;
            ifetch_src__var = 2'h1;
            data_src__var = 2'h0;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:riscv_i32_minimal:clock_control: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        riscv_clk_enable__var = 1'h0;
        case (riscv_clock_action__var) //synopsys parallel_case
        3'h1: // req 1
            begin
            end
        3'h0: // req 1
            begin
            riscv_clk_enable__var = 1'h1;
            end
        3'h5: // req 1
            begin
            end
        3'h2: // req 1
            begin
            end
        3'h6: // req 1
            begin
            end
        3'h7: // req 1
            begin
            end
        3'h3: // req 1
            begin
            end
        3'h4: // req 1
            begin
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:riscv_i32_minimal:clock_control: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        riscv_clock_action = riscv_clock_action__var;
        ifetch_src = ifetch_src__var;
        data_src = data_src__var;
        riscv_clk_enable = riscv_clk_enable__var;
    end //always

    //b clock_control__posedge_clk_active_low_reset_n clock process
        //   
        //       The clock control for a single SRAM implementation could be
        //       performed with three high speed clocks for each RISC-V
        //       clock. However, this is a slightly more sophisticated design.
        //   
        //       A minimal RISC-V clock cycle requires at most one instruction fetch and at
        //       most one of data read or data write.
        //   
        //       With a synchronous memory, a memory read must be presented to the
        //       SRAM at high speed clock cycle n-1 if the data is to be valid at
        //       the end of high speed clock cycle n.
        //   
        //       So if just an instruction fetch is required then a first high
        //       speed cycle is used to present the ifetch, and a second high speed
        //       cycle is the instruction being read. This is presented directly to
        //       the RISC-V core.
        //   
        //       If an instruction fetch and data read/write are required then a
        //       first high speed cycle is used to present the instruction fetch, a
        //       second to present the data read/write and perform the ifetch -
        //       with the data out registered at the start of a third high speed
        //       cycle while the data is being read (for data reads). This is
        //       presented directly to the RISC-V core; the instruction fetched is
        //       presented from its stored register
        //   
        //       If only a data read/write is required then that is presented in
        //       riscv_clk_high, with the data valid (on reads) at the end of the
        //       subsequent cycle.
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : clock_control__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            riscv_clock_phase <= 3'h0;
            riscv_clk_high <= 1'h0;
        end
        else if (clk__enable)
        begin
            case (riscv_clock_action) //synopsys parallel_case
            3'h1: // req 1
                begin
                riscv_clock_phase <= 3'h4;
                end
            3'h0: // req 1
                begin
                riscv_clock_phase <= 3'h0;
                end
            3'h5: // req 1
                begin
                riscv_clock_phase <= 3'h4;
                end
            3'h2: // req 1
                begin
                riscv_clock_phase <= 3'h3;
                end
            3'h6: // req 1
                begin
                riscv_clock_phase <= 3'h5;
                end
            3'h7: // req 1
                begin
                riscv_clock_phase <= 3'h6;
                end
            3'h3: // req 1
                begin
                riscv_clock_phase <= 3'h1;
                end
            3'h4: // req 1
                begin
                riscv_clock_phase <= 3'h2;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:riscv_i32_minimal:clock_control: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            riscv_clk_high <= riscv_clk_enable;
        end //if
    end //always

    //b srams__comb combinatorial process
    always @ ( * )//srams__comb
    begin: srams__comb_code
    reg sram_access_ack__var;
    reg [31:0]mem_access_req__address__var;
    reg [3:0]mem_access_req__byte_enable__var;
    reg mem_access_req__write_enable__var;
    reg mem_access_req__read_enable__var;
    reg [31:0]mem_access_req__write_data__var;
    reg ifetch_resp__valid__var;
    reg [31:0]ifetch_resp__data__var;
    reg [31:0]dmem_access_resp__read_data__var;
        sram_access_ack__var = 1'h1;
        mem_access_req__address__var = 32'h0;
        mem_access_req__byte_enable__var = 4'h0;
        mem_access_req__write_enable__var = 1'h0;
        mem_access_req__read_enable__var = 1'h0;
        mem_access_req__write_data__var = 32'h0;
        mem_access_req__address__var = data_sram_access_req__address;
        mem_access_req__byte_enable__var = data_sram_access_req__byte_enable;
        mem_access_req__write_data__var = data_sram_access_req__write_data;
        case (riscv_clock_action) //synopsys parallel_case
        3'h3: // req 1
            begin
            mem_access_req__read_enable__var = 1'h1;
            mem_access_req__address__var = data_sram_access_req__address;
            end
        3'h4: // req 1
            begin
            mem_access_req__write_enable__var = 1'h1;
            mem_access_req__byte_enable__var = data_sram_access_req__byte_enable;
            mem_access_req__address__var = data_sram_access_req__address;
            mem_access_req__write_data__var = data_sram_access_req__write_data;
            end
        3'h2: // req 1
            begin
            mem_access_req__read_enable__var = 1'h1;
            mem_access_req__address__var = ifetch_req__address;
            end
        3'h6: // req 1
            begin
            mem_access_req__read_enable__var = 1'h1;
            mem_access_req__address__var = ifetch_req__address;
            end
        3'h7: // req 1
            begin
            mem_access_req__read_enable__var = 1'h1;
            mem_access_req__address__var = (ifetch_req__address+32'h4);
            end
        default: // req 1
            begin
            if ((sram_access_req_r__valid!=1'h0))
            begin
                mem_access_req__address__var = sram_access_req_r__address[31:0];
                mem_access_req__byte_enable__var = sram_access_req_r__byte_enable[3:0];
                mem_access_req__write_data__var = sram_access_req_r__write_data[31:0];
                sram_access_ack__var = 1'h1;
            end //if
            end
        endcase
        ifetch_resp__valid__var = 1'h0;
        ifetch_resp__debug = 1'h0;
        ifetch_resp__data__var = 32'h0;
        ifetch_resp__mode = 3'h0;
        ifetch_resp__error = 1'h0;
        ifetch_resp__tag = 2'h0;
        ifetch_resp__valid__var = ifetch_req__valid;
        ifetch_resp__data__var = mem_read_data;
        if ((ifetch_src==2'h1))
        begin
            ifetch_resp__data__var = ifetch_reg;
        end //if
        if (1'h1)
        begin
            if ((ifetch_src==2'h2))
            begin
                ifetch_resp__data__var = {mem_read_data[15:0],ifetch_reg[31:16]};
                if ((ifetch_req__sequential!=1'h0))
                begin
                    ifetch_resp__data__var = {mem_read_data[15:0],ifetch_last16_reg};
                end //if
            end //if
        end //if
        dmem_access_resp__wait = 1'h0;
        dmem_access_resp__read_data__var = data_access_resp__read_data;
        case (data_src) //synopsys parallel_case
        2'h1: // req 1
            begin
            dmem_access_resp__read_data__var = data_access_read_reg;
            end
        2'h0: // req 1
            begin
            dmem_access_resp__read_data__var = mem_read_data;
            end
        default: // req 1
            begin
            dmem_access_resp__read_data__var = data_access_resp__read_data;
            end
        endcase
        sram_access_ack = sram_access_ack__var;
        mem_access_req__address = mem_access_req__address__var;
        mem_access_req__byte_enable = mem_access_req__byte_enable__var;
        mem_access_req__write_enable = mem_access_req__write_enable__var;
        mem_access_req__read_enable = mem_access_req__read_enable__var;
        mem_access_req__write_data = mem_access_req__write_data__var;
        ifetch_resp__valid = ifetch_resp__valid__var;
        ifetch_resp__data = ifetch_resp__data__var;
        dmem_access_resp__read_data = dmem_access_resp__read_data__var;
    end //always

    //b srams__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : srams__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            sram_access_resp__valid <= 1'h0;
            sram_access_resp__id <= 4'h0;
            sram_access_resp__data <= 64'h0;
            sram_access_req_r__valid <= 1'h0;
            sram_access_req_r__id <= 4'h0;
            sram_access_req_r__read_not_write <= 1'h0;
            sram_access_req_r__byte_enable <= 8'h0;
            sram_access_req_r__address <= 32'h0;
            sram_access_req_r__write_data <= 64'h0;
            sram_access_resp__ack <= 1'h0;
            ifetch_reg <= 32'h0;
            ifetch_last16_reg <= 16'h0;
            data_access_read_reg <= 32'h0;
        end
        else if (clk__enable)
        begin
            if ((sram_access_resp__ack!=1'h0))
            begin
                sram_access_resp__valid <= 1'h1;
                sram_access_resp__id <= sram_access_req_r__id;
                sram_access_resp__data[31:0] <= mem_read_data;
            end //if
            if ((sram_access_req__valid!=1'h0))
            begin
                sram_access_req_r__valid <= sram_access_req__valid;
                sram_access_req_r__id <= sram_access_req__id;
                sram_access_req_r__read_not_write <= sram_access_req__read_not_write;
                sram_access_req_r__byte_enable <= sram_access_req__byte_enable;
                sram_access_req_r__address <= sram_access_req__address;
                sram_access_req_r__write_data <= sram_access_req__write_data;
            end //if
            if ((sram_access_ack!=1'h0))
            begin
                sram_access_req_r__valid <= 1'h0;
            end //if
            if (((sram_access_resp__ack!=1'h0)||(sram_access_ack!=1'h0)))
            begin
                sram_access_resp__ack <= sram_access_ack;
            end //if
            if ((riscv_clock_phase==3'h3))
            begin
                ifetch_reg <= mem_read_data;
            end //if
            if (1'h1)
            begin
                if ((riscv_clock_phase==3'h3))
                begin
                    ifetch_last16_reg <= mem_read_data[31:16];
                end //if
                if ((riscv_clock_phase==3'h5))
                begin
                    ifetch_reg <= mem_read_data;
                end //if
                if ((riscv_clock_phase==3'h6))
                begin
                    ifetch_reg <= {mem_read_data[15:0],ifetch_reg[31:16]};
                    if ((ifetch_req__sequential!=1'h0))
                    begin
                        ifetch_reg <= {mem_read_data[15:0],ifetch_last16_reg};
                    end //if
                    ifetch_last16_reg <= mem_read_data[31:16];
                end //if
            end //if
            if ((1'h1&&(riscv_config__i32c!=1'h0)))
            begin
                if ((data_access_completing!=1'h0))
                begin
                    data_access_read_reg <= data_access_resp__read_data;
                end //if
            end //if
        end //if
    end //always

    //b pipeline combinatorial process
    always @ ( * )//pipeline
    begin: pipeline__comb_code
    reg riscv_config_pipe__i32m__var;
    reg trace__instr_valid__var;
    reg trace__rfw_data_valid__var;
        coproc_response__cannot_start = 1'h0;
        coproc_response__result = 32'h0;
        coproc_response__result_valid = 1'h0;
        coproc_response__cannot_complete = 1'h0;
        riscv_config_pipe__i32c = riscv_config__i32c;
        riscv_config_pipe__e32 = riscv_config__e32;
        riscv_config_pipe__i32m__var = riscv_config__i32m;
        riscv_config_pipe__i32m_fuse = riscv_config__i32m_fuse;
        riscv_config_pipe__coproc_disable = riscv_config__coproc_disable;
        riscv_config_pipe__unaligned_mem = riscv_config__unaligned_mem;
        riscv_config_pipe__i32m__var = 1'h0;
        trace__instr_valid__var = trace_pipe__instr_valid;
        trace__instr_pc = trace_pipe__instr_pc;
        trace__instruction__mode = trace_pipe__instruction__mode;
        trace__instruction__data = trace_pipe__instruction__data;
        trace__rfw_retire = trace_pipe__rfw_retire;
        trace__rfw_data_valid__var = trace_pipe__rfw_data_valid;
        trace__rfw_rd = trace_pipe__rfw_rd;
        trace__rfw_data = trace_pipe__rfw_data;
        trace__branch_taken = trace_pipe__branch_taken;
        trace__branch_target = trace_pipe__branch_target;
        trace__trap = trace_pipe__trap;
        trace__instr_valid__var = ((trace_pipe__instr_valid!=1'h0)&&(riscv_clk_enable!=1'h0));
        trace__rfw_data_valid__var = ((trace_pipe__rfw_data_valid!=1'h0)&&(riscv_clk_enable!=1'h0));
        riscv_config_pipe__i32m = riscv_config_pipe__i32m__var;
        trace__instr_valid = trace__instr_valid__var;
        trace__rfw_data_valid = trace__rfw_data_valid__var;
    end //always

endmodule // riscv_i32_minimal
