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

//a Module tb_riscv_i32_minimal
module tb_riscv_i32_minimal
(
    clk,
    clk__enable,

    reset_n

);

    //b Clocks
    input clk;
    input clk__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg [31:0]apb_request__paddr;
    reg apb_request__penable;
    reg apb_request__psel;
    reg apb_request__pwrite;
    reg [31:0]apb_request__pwdata;

    //b Internal combinatorials
    reg irqs__nmi;
    reg irqs__meip;
    reg irqs__seip;
    reg irqs__ueip;
    reg irqs__mtip;
    reg irqs__msip;
    reg [63:0]irqs__time;
    reg riscv_config__i32c;
    reg riscv_config__e32;
    reg riscv_config__i32m;
    reg riscv_config__i32m_fuse;
    reg riscv_config__coproc_disable;
    reg riscv_config__unaligned_mem;
    reg data_access_resp__wait;
    reg [31:0]data_access_resp__read_data;
    reg sram_access_req__valid;
    reg [3:0]sram_access_req__id;
    reg sram_access_req__read_not_write;
    reg [7:0]sram_access_req__byte_enable;
    reg [31:0]sram_access_req__address;
    reg [63:0]sram_access_req__write_data;

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
    wire [2:0]timer_equalled;
    wire [31:0]apb_response__prdata;
    wire apb_response__pready;
    wire apb_response__perr;
    wire [31:0]data_access_req__address;
    wire [3:0]data_access_req__byte_enable;
    wire data_access_req__write_enable;
    wire data_access_req__read_enable;
    wire [31:0]data_access_req__write_data;
    wire sram_access_resp__ack;
    wire sram_access_resp__valid;
    wire [3:0]sram_access_resp__id;
    wire [63:0]sram_access_resp__data;

    //b Clock gating module instances
    //b Module instances
    apb_target_timer timer(
        .clk(clk),
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
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .a(1'h0)         );
    riscv_i32_minimal dut(
        .clk(clk),
        .clk__enable(1'b1),
        .riscv_config__unaligned_mem(riscv_config__unaligned_mem),
        .riscv_config__coproc_disable(riscv_config__coproc_disable),
        .riscv_config__i32m_fuse(riscv_config__i32m_fuse),
        .riscv_config__i32m(riscv_config__i32m),
        .riscv_config__e32(riscv_config__e32),
        .riscv_config__i32c(riscv_config__i32c),
        .sram_access_req__write_data(sram_access_req__write_data),
        .sram_access_req__address(sram_access_req__address),
        .sram_access_req__byte_enable(sram_access_req__byte_enable),
        .sram_access_req__read_not_write(sram_access_req__read_not_write),
        .sram_access_req__id(sram_access_req__id),
        .sram_access_req__valid(sram_access_req__valid),
        .data_access_resp__read_data(data_access_resp__read_data),
        .data_access_resp__wait(data_access_resp__wait),
        .irqs__time(irqs__time),
        .irqs__msip(irqs__msip),
        .irqs__mtip(irqs__mtip),
        .irqs__ueip(irqs__ueip),
        .irqs__seip(irqs__seip),
        .irqs__meip(irqs__meip),
        .irqs__nmi(irqs__nmi),
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
        .sram_access_resp__data(            sram_access_resp__data),
        .sram_access_resp__id(            sram_access_resp__id),
        .sram_access_resp__valid(            sram_access_resp__valid),
        .sram_access_resp__ack(            sram_access_resp__ack),
        .data_access_req__write_data(            data_access_req__write_data),
        .data_access_req__read_enable(            data_access_req__read_enable),
        .data_access_req__write_enable(            data_access_req__write_enable),
        .data_access_req__byte_enable(            data_access_req__byte_enable),
        .data_access_req__address(            data_access_req__address)         );
    riscv_i32_trace trace(
        .clk(clk),
        .clk__enable(1'b1),
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
    //b riscv_instance__comb combinatorial process
    always @ ( * )//riscv_instance__comb
    begin: riscv_instance__comb_code
    reg riscv_config__i32c__var;
    reg riscv_config__e32__var;
    reg data_access_resp__wait__var;
    reg [31:0]data_access_resp__read_data__var;
        riscv_config__i32c__var = 1'h0;
        riscv_config__e32__var = 1'h0;
        riscv_config__i32m = 1'h0;
        riscv_config__i32m_fuse = 1'h0;
        riscv_config__coproc_disable = 1'h0;
        riscv_config__unaligned_mem = 1'h0;
        riscv_config__e32__var = 1'h0;
        riscv_config__i32c__var = 1'h0;
        irqs__nmi = 1'h0;
        irqs__meip = 1'h0;
        irqs__seip = 1'h0;
        irqs__ueip = 1'h0;
        irqs__mtip = 1'h0;
        irqs__msip = 1'h0;
        irqs__time = 64'h0;
        data_access_resp__wait__var = 1'h0;
        data_access_resp__read_data__var = 32'h0;
        if ((apb_request__psel!=1'h0))
        begin
            data_access_resp__wait__var = 1'h1;
            if (((apb_request__penable!=1'h0)&&(apb_response__pready!=1'h0)))
            begin
                data_access_resp__read_data__var = apb_response__prdata;
                data_access_resp__wait__var = 1'h0;
            end //if
        end //if
        else
        
        begin
            if (((data_access_req__read_enable!=1'h0)||(data_access_req__write_enable!=1'h0)))
            begin
                data_access_resp__wait__var = 1'h1;
            end //if
        end //else
        sram_access_req__valid = 1'h0;
        sram_access_req__id = 4'h0;
        sram_access_req__read_not_write = 1'h0;
        sram_access_req__byte_enable = 8'h0;
        sram_access_req__address = 32'h0;
        sram_access_req__write_data = 64'h0;
        riscv_config__i32c = riscv_config__i32c__var;
        riscv_config__e32 = riscv_config__e32__var;
        data_access_resp__wait = data_access_resp__wait__var;
        data_access_resp__read_data = data_access_resp__read_data__var;
    end //always

    //b riscv_instance__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : riscv_instance__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            apb_request__penable <= 1'h0;
            apb_request__psel <= 1'h0;
            apb_request__paddr <= 32'h0;
            apb_request__pwrite <= 1'h0;
            apb_request__pwdata <= 32'h0;
        end
        else if (clk__enable)
        begin
            if ((apb_request__psel!=1'h0))
            begin
                apb_request__penable <= 1'h1;
                if (((apb_request__penable!=1'h0)&&(apb_response__pready!=1'h0)))
                begin
                    apb_request__psel <= 1'h0;
                    apb_request__penable <= 1'h0;
                end //if
            end //if
            else
            
            begin
                if (((data_access_req__read_enable!=1'h0)||(data_access_req__write_enable!=1'h0)))
                begin
                    apb_request__psel <= 1'h1;
                    apb_request__penable <= 1'h0;
                    apb_request__paddr <= {16'h0,data_access_req__address[17:2]};
                    apb_request__pwrite <= data_access_req__write_enable;
                    apb_request__pwdata <= data_access_req__write_data;
                end //if
            end //else
        end //if
    end //always

endmodule // tb_riscv_i32_minimal
