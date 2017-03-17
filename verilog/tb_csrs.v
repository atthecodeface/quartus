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

//a Module tb_csrs
module tb_csrs
(
    clk,
    clk__enable,

    reset_n

);

    //b Clocks
    input clk;
    input clk__enable;
    wire timer_clk; // Gated version of clock 'clk' enabled by 'timer_clk_enable'
    wire timer_clk__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg [31:0]timer_clk_state__counter;
    reg [31:0]timer_clk_state__divider;
    reg timer_clk_state__enable;
    reg master_csr_response_r__acknowledge;
    reg master_csr_response_r__read_data_valid;
    reg master_csr_response_r__read_data_error;
    reg [31:0]master_csr_response_r__read_data;

    //b Internal combinatorials
    reg timer_clk_enable;
    reg [31:0]tgt0_csr_access_data;
    reg master_csr_response__acknowledge;
    reg master_csr_response__read_data_valid;
    reg master_csr_response__read_data_error;
    reg [31:0]master_csr_response__read_data;

    //b Internal nets
    wire [2:0]timer_equalled;
    wire [31:0]tgt1_apb_response__prdata;
    wire tgt1_apb_response__pready;
    wire tgt1_apb_response__perr;
    wire [31:0]tgt1_apb_request__paddr;
    wire tgt1_apb_request__penable;
    wire tgt1_apb_request__psel;
    wire tgt1_apb_request__pwrite;
    wire [31:0]tgt1_apb_request__pwdata;
    wire tgt0_csr_access__valid;
    wire tgt0_csr_access__read_not_write;
    wire [15:0]tgt0_csr_access__address;
    wire [31:0]tgt0_csr_access__data;
    wire tgt1_csr_response__acknowledge;
    wire tgt1_csr_response__read_data_valid;
    wire tgt1_csr_response__read_data_error;
    wire [31:0]tgt1_csr_response__read_data;
    wire tgt0_csr_response__acknowledge;
    wire tgt0_csr_response__read_data_valid;
    wire tgt0_csr_response__read_data_error;
    wire [31:0]tgt0_csr_response__read_data;
    wire master_csr_request__valid;
    wire master_csr_request__read_not_write;
    wire [15:0]master_csr_request__select;
    wire [15:0]master_csr_request__address;
    wire [31:0]master_csr_request__data;
    wire [31:0]th_apb_response__prdata;
    wire th_apb_response__pready;
    wire th_apb_response__perr;
    wire [31:0]th_apb_request__paddr;
    wire th_apb_request__penable;
    wire th_apb_request__psel;
    wire th_apb_request__pwrite;
    wire [31:0]th_apb_request__pwdata;

    //b Clock gating module instances
    assign timer_clk__enable = (clk__enable && timer_clk_enable);
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .apb_response__perr(th_apb_response__perr),
        .apb_response__pready(th_apb_response__pready),
        .apb_response__prdata(th_apb_response__prdata),
        .apb_request__pwdata(            th_apb_request__pwdata),
        .apb_request__pwrite(            th_apb_request__pwrite),
        .apb_request__psel(            th_apb_request__psel),
        .apb_request__penable(            th_apb_request__penable),
        .apb_request__paddr(            th_apb_request__paddr)         );
    csr_master_apb master(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_response__read_data(master_csr_response_r__read_data),
        .csr_response__read_data_error(master_csr_response_r__read_data_error),
        .csr_response__read_data_valid(master_csr_response_r__read_data_valid),
        .csr_response__acknowledge(master_csr_response_r__acknowledge),
        .apb_request__pwdata(th_apb_request__pwdata),
        .apb_request__pwrite(th_apb_request__pwrite),
        .apb_request__psel(th_apb_request__psel),
        .apb_request__penable(th_apb_request__penable),
        .apb_request__paddr(th_apb_request__paddr),
        .reset_n(reset_n),
        .csr_request__data(            master_csr_request__data),
        .csr_request__address(            master_csr_request__address),
        .csr_request__select(            master_csr_request__select),
        .csr_request__read_not_write(            master_csr_request__read_not_write),
        .csr_request__valid(            master_csr_request__valid),
        .apb_response__perr(            th_apb_response__perr),
        .apb_response__pready(            th_apb_response__pready),
        .apb_response__prdata(            th_apb_response__prdata)         );
    csr_target_csr tgt0(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_select(16'hfc00),
        .csr_access_data(tgt0_csr_access_data),
        .csr_request__data(master_csr_request__data),
        .csr_request__address(master_csr_request__address),
        .csr_request__select(master_csr_request__select),
        .csr_request__read_not_write(master_csr_request__read_not_write),
        .csr_request__valid(master_csr_request__valid),
        .reset_n(reset_n),
        .csr_access__data(            tgt0_csr_access__data),
        .csr_access__address(            tgt0_csr_access__address),
        .csr_access__read_not_write(            tgt0_csr_access__read_not_write),
        .csr_access__valid(            tgt0_csr_access__valid),
        .csr_response__read_data(            tgt0_csr_response__read_data),
        .csr_response__read_data_error(            tgt0_csr_response__read_data_error),
        .csr_response__read_data_valid(            tgt0_csr_response__read_data_valid),
        .csr_response__acknowledge(            tgt0_csr_response__acknowledge)         );
    csr_target_apb tgt1(
        .clk(clk),
        .clk__enable(timer_clk__enable),
        .csr_select(16'hab01),
        .apb_response__perr(tgt1_apb_response__perr),
        .apb_response__pready(tgt1_apb_response__pready),
        .apb_response__prdata(tgt1_apb_response__prdata),
        .csr_request__data(master_csr_request__data),
        .csr_request__address(master_csr_request__address),
        .csr_request__select(master_csr_request__select),
        .csr_request__read_not_write(master_csr_request__read_not_write),
        .csr_request__valid(master_csr_request__valid),
        .reset_n(reset_n),
        .apb_request__pwdata(            tgt1_apb_request__pwdata),
        .apb_request__pwrite(            tgt1_apb_request__pwrite),
        .apb_request__psel(            tgt1_apb_request__psel),
        .apb_request__penable(            tgt1_apb_request__penable),
        .apb_request__paddr(            tgt1_apb_request__paddr),
        .csr_response__read_data(            tgt1_csr_response__read_data),
        .csr_response__read_data_error(            tgt1_csr_response__read_data_error),
        .csr_response__read_data_valid(            tgt1_csr_response__read_data_valid),
        .csr_response__acknowledge(            tgt1_csr_response__acknowledge)         );
    apb_target_timer timer(
        .clk(clk),
        .clk__enable(timer_clk__enable),
        .apb_request__pwdata(tgt1_apb_request__pwdata),
        .apb_request__pwrite(tgt1_apb_request__pwrite),
        .apb_request__psel(tgt1_apb_request__psel),
        .apb_request__penable(tgt1_apb_request__penable),
        .apb_request__paddr(tgt1_apb_request__paddr),
        .reset_n(reset_n),
        .timer_equalled(            timer_equalled),
        .apb_response__perr(            tgt1_apb_response__perr),
        .apb_response__pready(            tgt1_apb_response__pready),
        .apb_response__prdata(            tgt1_apb_response__prdata)         );
    //b instantiations__comb combinatorial process
    always @ ( * )//instantiations__comb
    begin: instantiations__comb_code
    reg master_csr_response__acknowledge__var;
    reg master_csr_response__read_data_valid__var;
    reg master_csr_response__read_data_error__var;
    reg [31:0]master_csr_response__read_data__var;
        tgt0_csr_access_data = timer_clk_state__counter;
        timer_clk_enable = timer_clk_state__enable;
        master_csr_response__acknowledge__var = tgt0_csr_response__acknowledge;
        master_csr_response__read_data_valid__var = tgt0_csr_response__read_data_valid;
        master_csr_response__read_data_error__var = tgt0_csr_response__read_data_error;
        master_csr_response__read_data__var = tgt0_csr_response__read_data;
        master_csr_response__acknowledge__var = master_csr_response__acknowledge__var | tgt1_csr_response__acknowledge;
        master_csr_response__read_data_valid__var = master_csr_response__read_data_valid__var | tgt1_csr_response__read_data_valid;
        master_csr_response__read_data_error__var = master_csr_response__read_data_error__var | tgt1_csr_response__read_data_error;
        master_csr_response__read_data__var = master_csr_response__read_data__var | tgt1_csr_response__read_data;
        master_csr_response__acknowledge = master_csr_response__acknowledge__var;
        master_csr_response__read_data_valid = master_csr_response__read_data_valid__var;
        master_csr_response__read_data_error = master_csr_response__read_data_error__var;
        master_csr_response__read_data = master_csr_response__read_data__var;
    end //always

    //b instantiations__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : instantiations__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            timer_clk_state__enable <= 1'h0;
            timer_clk_state__counter <= 32'h0;
            timer_clk_state__divider <= 32'h0;
            master_csr_response_r__acknowledge <= 1'h0;
            master_csr_response_r__read_data_valid <= 1'h0;
            master_csr_response_r__read_data_error <= 1'h0;
            master_csr_response_r__read_data <= 32'h0;
        end
        else if (clk__enable)
        begin
            timer_clk_state__enable <= 1'h0;
            timer_clk_state__counter <= (timer_clk_state__counter-32'h1);
            if ((timer_clk_state__counter==32'h0))
            begin
                timer_clk_state__enable <= 1'h1;
                timer_clk_state__counter <= timer_clk_state__divider;
            end //if
            if (((!(tgt0_csr_access__read_not_write!=1'h0) & tgt0_csr_access__valid)!=1'h0))
            begin
                timer_clk_state__divider <= tgt0_csr_access__data;
            end //if
            master_csr_response_r__acknowledge <= master_csr_response__acknowledge;
            master_csr_response_r__read_data_valid <= master_csr_response__read_data_valid;
            master_csr_response_r__read_data_error <= master_csr_response__read_data_error;
            master_csr_response_r__read_data <= master_csr_response__read_data;
        end //if
    end //always

endmodule // tb_csrs
