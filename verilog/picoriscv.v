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

//a Module picoriscv
module picoriscv
(
    video_clk,
    video_clk__enable,
    clk,
    clk__enable,

    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    keyboard__keys_low,
    video_reset_n,
    reset_n,

    csr_response__acknowledge,
    csr_response__read_data_valid,
    csr_response__read_data_error,
    csr_response__read_data,
    video_bus__vsync,
    video_bus__hsync,
    video_bus__display_enable,
    video_bus__red,
    video_bus__green,
    video_bus__blue
);

    //b Clocks
        //   Video clock, independent of CPU clock
    input video_clk;
    input video_clk__enable;
        //   Clock, divided down for CPU
    input clk;
    input clk__enable;
    wire riscv_clk; // Gated version of clock 'clk' enabled by 'riscv_clk_enable'
    wire riscv_clk__enable;

    //b Inputs
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
    input [63:0]keyboard__keys_low;
        //   Active low reset
    input video_reset_n;
        //   Active low reset
    input reset_n;

    //b Outputs
    output csr_response__acknowledge;
    output csr_response__read_data_valid;
    output csr_response__read_data_error;
    output [31:0]csr_response__read_data;
    output video_bus__vsync;
    output video_bus__hsync;
    output video_bus__display_enable;
    output [7:0]video_bus__red;
    output [7:0]video_bus__green;
    output [7:0]video_bus__blue;

// output components here

    //b Output combinatorials
    reg csr_response__acknowledge;
    reg csr_response__read_data_valid;
    reg csr_response__read_data_error;
    reg [31:0]csr_response__read_data;

    //b Output nets
    wire video_bus__vsync;
    wire video_bus__hsync;
    wire video_bus__display_enable;
    wire [7:0]video_bus__red;
    wire [7:0]video_bus__green;
    wire [7:0]video_bus__blue;

    //b Internal and output registers
    reg [31:0]ifetch_reg;
    reg [31:0]read_data_reg;

    //b Internal combinatorials
    reg riscv_clk_enable;
    reg clock_status__imem_request;
    reg clock_status__io_request;
    reg clock_status__io_ready;
    reg clock_status__dmem_read_enable;
    reg clock_status__dmem_write_enable;
    reg [31:0]mem_access_req__address;
    reg [3:0]mem_access_req__byte_enable;
    reg mem_access_req__write_enable;
    reg mem_access_req__read_enable;
    reg [31:0]mem_access_req__write_data;
    reg tt_display_sram_write__enable;
    reg [47:0]tt_display_sram_write__data;
    reg [15:0]tt_display_sram_write__address;
    reg imem_access_resp__wait;
    reg [31:0]imem_access_resp__read_data;
    reg dmem_access_resp__wait;
    reg [31:0]dmem_access_resp__read_data;

    //b Internal nets
    wire clock_control__riscv_clk_enable;
    wire [3:0]clock_control__debug;
    wire mem_control__dmem_request;
    wire mem_control__ifetch_request;
    wire mem_control__dmem_set_reg;
    wire mem_control__ifetch_set_reg;
    wire mem_control__ifetch_use_reg;
    wire mem_control__io_enable;
    wire [31:0]mem_read_data;
    wire tt_csr_response__acknowledge;
    wire tt_csr_response__read_data_valid;
    wire tt_csr_response__read_data_error;
    wire [31:0]tt_csr_response__read_data;
    wire clk_csr_response__acknowledge;
    wire clk_csr_response__read_data_valid;
    wire clk_csr_response__read_data_error;
    wire [31:0]clk_csr_response__read_data;
    wire [31:0]imem_access_req__address;
    wire [3:0]imem_access_req__byte_enable;
    wire imem_access_req__write_enable;
    wire imem_access_req__read_enable;
    wire [31:0]imem_access_req__write_data;
    wire [31:0]dmem_access_req__address;
    wire [3:0]dmem_access_req__byte_enable;
    wire dmem_access_req__write_enable;
    wire dmem_access_req__read_enable;
    wire [31:0]dmem_access_req__write_data;

    //b Clock gating module instances
    assign riscv_clk__enable = (clk__enable && riscv_clk_enable);
    //b Module instances
    picoriscv_clocking clocking(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .clock_status__dmem_write_enable(clock_status__dmem_write_enable),
        .clock_status__dmem_read_enable(clock_status__dmem_read_enable),
        .clock_status__io_ready(clock_status__io_ready),
        .clock_status__io_request(clock_status__io_request),
        .clock_status__imem_request(clock_status__imem_request),
        .reset_n(reset_n),
        .csr_response__read_data(            clk_csr_response__read_data),
        .csr_response__read_data_error(            clk_csr_response__read_data_error),
        .csr_response__read_data_valid(            clk_csr_response__read_data_valid),
        .csr_response__acknowledge(            clk_csr_response__acknowledge),
        .clock_control__debug(            clock_control__debug),
        .clock_control__riscv_clk_enable(            clock_control__riscv_clk_enable),
        .mem_control__io_enable(            mem_control__io_enable),
        .mem_control__ifetch_use_reg(            mem_control__ifetch_use_reg),
        .mem_control__ifetch_set_reg(            mem_control__ifetch_set_reg),
        .mem_control__dmem_set_reg(            mem_control__dmem_set_reg),
        .mem_control__ifetch_request(            mem_control__ifetch_request),
        .mem_control__dmem_request(            mem_control__dmem_request)         );
    se_sram_srw_16384x32_we8 mem(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(mem_access_req__write_data),
        .address(mem_access_req__address[15:2]),
        .write_enable(((mem_access_req__write_enable!=1'h0)?mem_access_req__byte_enable:4'h0)),
        .read_not_write(mem_access_req__read_enable),
        .select(((mem_access_req__read_enable!=1'h0)||(mem_access_req__write_enable!=1'h0))),
        .data_out(            mem_read_data)         );
    riscv_minimal riscv(
        .clk(clk),
        .clk__enable(riscv_clk__enable),
        .imem_access_resp__read_data(imem_access_resp__read_data),
        .imem_access_resp__wait(imem_access_resp__wait),
        .dmem_access_resp__read_data(dmem_access_resp__read_data),
        .dmem_access_resp__wait(dmem_access_resp__wait),
        .reset_n(reset_n),
        .imem_access_req__write_data(            imem_access_req__write_data),
        .imem_access_req__read_enable(            imem_access_req__read_enable),
        .imem_access_req__write_enable(            imem_access_req__write_enable),
        .imem_access_req__byte_enable(            imem_access_req__byte_enable),
        .imem_access_req__address(            imem_access_req__address),
        .dmem_access_req__write_data(            dmem_access_req__write_data),
        .dmem_access_req__read_enable(            dmem_access_req__read_enable),
        .dmem_access_req__write_enable(            dmem_access_req__write_enable),
        .dmem_access_req__byte_enable(            dmem_access_req__byte_enable),
        .dmem_access_req__address(            dmem_access_req__address)         );
    framebuffer_teletext ftb(
        .video_clk(video_clk),
        .video_clk__enable(1'b1),
        .sram_clk(clk),
        .sram_clk__enable(1'b1),
        .csr_clk(clk),
        .csr_clk__enable(1'b1),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .display_sram_write__address(tt_display_sram_write__address),
        .display_sram_write__data(tt_display_sram_write__data),
        .display_sram_write__enable(tt_display_sram_write__enable),
        .reset_n(video_reset_n),
        .csr_response__read_data(            tt_csr_response__read_data),
        .csr_response__read_data_error(            tt_csr_response__read_data_error),
        .csr_response__read_data_valid(            tt_csr_response__read_data_valid),
        .csr_response__acknowledge(            tt_csr_response__acknowledge),
        .video_bus__blue(            video_bus__blue),
        .video_bus__green(            video_bus__green),
        .video_bus__red(            video_bus__red),
        .video_bus__display_enable(            video_bus__display_enable),
        .video_bus__hsync(            video_bus__hsync),
        .video_bus__vsync(            video_bus__vsync)         );
    //b clock_control combinatorial process
        //   
        //       
    always @ ( * )//clock_control
    begin: clock_control__comb_code
    reg csr_response__acknowledge__var;
    reg csr_response__read_data_valid__var;
    reg csr_response__read_data_error__var;
    reg [31:0]csr_response__read_data__var;
        riscv_clk_enable = clock_control__riscv_clk_enable;
        csr_response__acknowledge__var = 1'h0;
        csr_response__read_data_valid__var = 1'h0;
        csr_response__read_data_error__var = 1'h0;
        csr_response__read_data__var = 32'h0;
        csr_response__acknowledge__var = csr_response__acknowledge__var | clk_csr_response__acknowledge;
        csr_response__read_data_valid__var = csr_response__read_data_valid__var | clk_csr_response__read_data_valid;
        csr_response__read_data_error__var = csr_response__read_data_error__var | clk_csr_response__read_data_error;
        csr_response__read_data__var = csr_response__read_data__var | clk_csr_response__read_data;
        csr_response__acknowledge__var = csr_response__acknowledge__var | tt_csr_response__acknowledge;
        csr_response__read_data_valid__var = csr_response__read_data_valid__var | tt_csr_response__read_data_valid;
        csr_response__read_data_error__var = csr_response__read_data_error__var | tt_csr_response__read_data_error;
        csr_response__read_data__var = csr_response__read_data__var | tt_csr_response__read_data;
        csr_response__acknowledge = csr_response__acknowledge__var;
        csr_response__read_data_valid = csr_response__read_data_valid__var;
        csr_response__read_data_error = csr_response__read_data_error__var;
        csr_response__read_data = csr_response__read_data__var;
    end //always

    //b srams__comb combinatorial process
    always @ ( * )//srams__comb
    begin: srams__comb_code
    reg [31:0]mem_access_req__address__var;
    reg [3:0]mem_access_req__byte_enable__var;
    reg mem_access_req__write_enable__var;
    reg mem_access_req__read_enable__var;
    reg [31:0]mem_access_req__write_data__var;
        mem_access_req__address__var = 32'h0;
        mem_access_req__byte_enable__var = 4'h0;
        mem_access_req__write_enable__var = 1'h0;
        mem_access_req__read_enable__var = 1'h0;
        mem_access_req__write_data__var = 32'h0;
        mem_access_req__address__var = dmem_access_req__address;
        mem_access_req__byte_enable__var = dmem_access_req__byte_enable;
        mem_access_req__write_data__var = dmem_access_req__write_data;
        if ((mem_control__dmem_request!=1'h0))
        begin
            mem_access_req__read_enable__var = dmem_access_req__read_enable;
            mem_access_req__write_enable__var = dmem_access_req__write_enable;
        end //if
        if ((mem_control__ifetch_request!=1'h0))
        begin
            mem_access_req__read_enable__var = imem_access_req__read_enable;
            mem_access_req__address__var = imem_access_req__address;
        end //if
        imem_access_resp__wait = 1'h0;
        dmem_access_resp__wait = 1'h0;
        imem_access_resp__read_data = ((mem_control__ifetch_use_reg!=1'h0)?ifetch_reg:mem_read_data);
        dmem_access_resp__read_data = read_data_reg;
        mem_access_req__address = mem_access_req__address__var;
        mem_access_req__byte_enable = mem_access_req__byte_enable__var;
        mem_access_req__write_enable = mem_access_req__write_enable__var;
        mem_access_req__read_enable = mem_access_req__read_enable__var;
        mem_access_req__write_data = mem_access_req__write_data__var;
    end //always

    //b srams__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : srams__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            read_data_reg <= 32'h0;
            ifetch_reg <= 32'h0;
        end
        else if (clk__enable)
        begin
            if ((mem_control__dmem_set_reg!=1'h0))
            begin
                read_data_reg <= mem_read_data;
            end //if
            if ((mem_control__ifetch_set_reg!=1'h0))
            begin
                ifetch_reg <= mem_read_data;
            end //if
        end //if
    end //always

    //b cpu_and_addressing combinatorial process
        //   
        //       
    always @ ( * )//cpu_and_addressing
    begin: cpu_and_addressing__comb_code
    reg clock_status__io_request__var;
    reg clock_status__dmem_read_enable__var;
    reg clock_status__dmem_write_enable__var;
    reg tt_display_sram_write__enable__var;
    reg [47:0]tt_display_sram_write__data__var;
    reg [15:0]tt_display_sram_write__address__var;
        clock_status__imem_request = imem_access_req__read_enable;
        clock_status__io_request__var = 1'h0;
        clock_status__io_ready = 1'h1;
        clock_status__dmem_read_enable__var = dmem_access_req__read_enable;
        clock_status__dmem_write_enable__var = dmem_access_req__write_enable;
        case (dmem_access_req__address[31:28]) //synopsys parallel_case
        4'hf: // req 1
            begin
            clock_status__dmem_read_enable__var = 1'h0;
            clock_status__dmem_write_enable__var = 1'h0;
            clock_status__io_request__var = ((dmem_access_req__read_enable!=1'h0)||(dmem_access_req__write_enable!=1'h0));
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
        tt_display_sram_write__enable__var = 1'h0;
        tt_display_sram_write__data__var = 48'h0;
        tt_display_sram_write__address__var = 16'h0;
        tt_display_sram_write__address__var = dmem_access_req__address[15:0];
        tt_display_sram_write__data__var = {16'h0,dmem_access_req__write_data};
        if (((clock_status__io_request__var!=1'h0)&&(mem_control__io_enable!=1'h0)))
        begin
            tt_display_sram_write__enable__var = (dmem_access_req__address[27:24]==4'h0);
        end //if
        clock_status__io_request = clock_status__io_request__var;
        clock_status__dmem_read_enable = clock_status__dmem_read_enable__var;
        clock_status__dmem_write_enable = clock_status__dmem_write_enable__var;
        tt_display_sram_write__enable = tt_display_sram_write__enable__var;
        tt_display_sram_write__data = tt_display_sram_write__data__var;
        tt_display_sram_write__address = tt_display_sram_write__address__var;
    end //always

endmodule // picoriscv
