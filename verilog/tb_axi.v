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

//a Module tb_axi
module tb_axi
(
    aclk,
    aclk__enable,

    reset_n

);

    //b Clocks
    input aclk;
    input aclk__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers

    //b Internal combinatorials
    reg [15:0]gpio_input;
    reg [31:0]gpio_apb_request__paddr;
    reg gpio_apb_request__penable;
    reg gpio_apb_request__psel;
    reg gpio_apb_request__pwrite;
    reg [31:0]gpio_apb_request__pwdata;
    reg [31:0]timer_apb_request__paddr;
    reg timer_apb_request__penable;
    reg timer_apb_request__psel;
    reg timer_apb_request__pwrite;
    reg [31:0]timer_apb_request__pwdata;
    reg [31:0]apb_response__prdata;
    reg apb_response__pready;
    reg apb_response__perr;

    //b Internal nets
    wire gpio_input_event;
    wire [15:0]gpio_output_enable;
    wire [15:0]gpio_output;
    wire [2:0]timer_equalled;
    wire [31:0]gpio_apb_response__prdata;
    wire gpio_apb_response__pready;
    wire gpio_apb_response__perr;
    wire [31:0]timer_apb_response__prdata;
    wire timer_apb_response__pready;
    wire timer_apb_response__perr;
    wire [31:0]apb_request__paddr;
    wire apb_request__penable;
    wire apb_request__psel;
    wire apb_request__pwrite;
    wire [31:0]apb_request__pwdata;
    wire r__valid;
    wire [11:0]r__id;
    wire [31:0]r__data;
    wire [1:0]r__resp;
    wire r__last;
    wire [3:0]r__user;
    wire b__valid;
    wire [11:0]b__id;
    wire [1:0]b__resp;
    wire [3:0]b__user;
    wire wready;
    wire arready;
    wire awready;
    wire rready;
    wire bready;
    wire w__valid;
    wire [11:0]w__id;
    wire [31:0]w__data;
    wire [3:0]w__strb;
    wire w__last;
    wire [3:0]w__user;
    wire aw__valid;
    wire [11:0]aw__id;
    wire [31:0]aw__addr;
    wire [3:0]aw__len;
    wire [2:0]aw__size;
    wire [1:0]aw__burst;
    wire [1:0]aw__lock;
    wire [3:0]aw__cache;
    wire [2:0]aw__prot;
    wire [3:0]aw__qos;
    wire [3:0]aw__region;
    wire [3:0]aw__user;
    wire ar__valid;
    wire [11:0]ar__id;
    wire [31:0]ar__addr;
    wire [3:0]ar__len;
    wire [2:0]ar__size;
    wire [1:0]ar__burst;
    wire [1:0]ar__lock;
    wire [3:0]ar__cache;
    wire [2:0]ar__prot;
    wire [3:0]ar__qos;
    wire [3:0]ar__region;
    wire [3:0]ar__user;

    //b Clock gating module instances
    //b Module instances
    axi_master axim(
        .aclk(aclk),
        .aclk__enable(1'b1),
        .r__user(r__user),
        .r__last(r__last),
        .r__resp(r__resp),
        .r__data(r__data),
        .r__id(r__id),
        .r__valid(r__valid),
        .b__user(b__user),
        .b__resp(b__resp),
        .b__id(b__id),
        .b__valid(b__valid),
        .wready(wready),
        .awready(awready),
        .arready(arready),
        .areset_n(reset_n),
        .rready(            rready),
        .bready(            bready),
        .w__user(            w__user),
        .w__last(            w__last),
        .w__strb(            w__strb),
        .w__data(            w__data),
        .w__id(            w__id),
        .w__valid(            w__valid),
        .aw__user(            aw__user),
        .aw__region(            aw__region),
        .aw__qos(            aw__qos),
        .aw__prot(            aw__prot),
        .aw__cache(            aw__cache),
        .aw__lock(            aw__lock),
        .aw__burst(            aw__burst),
        .aw__size(            aw__size),
        .aw__len(            aw__len),
        .aw__addr(            aw__addr),
        .aw__id(            aw__id),
        .aw__valid(            aw__valid),
        .ar__user(            ar__user),
        .ar__region(            ar__region),
        .ar__qos(            ar__qos),
        .ar__prot(            ar__prot),
        .ar__cache(            ar__cache),
        .ar__lock(            ar__lock),
        .ar__burst(            ar__burst),
        .ar__size(            ar__size),
        .ar__len(            ar__len),
        .ar__addr(            ar__addr),
        .ar__id(            ar__id),
        .ar__valid(            ar__valid)         );
    apb_master_axi apbm(
        .aclk(aclk),
        .aclk__enable(1'b1),
        .apb_response__perr(apb_response__perr),
        .apb_response__pready(apb_response__pready),
        .apb_response__prdata(apb_response__prdata),
        .rready(rready),
        .bready(bready),
        .w__user(w__user),
        .w__last(w__last),
        .w__strb(w__strb),
        .w__data(w__data),
        .w__id(w__id),
        .w__valid(w__valid),
        .aw__user(aw__user),
        .aw__region(aw__region),
        .aw__qos(aw__qos),
        .aw__prot(aw__prot),
        .aw__cache(aw__cache),
        .aw__lock(aw__lock),
        .aw__burst(aw__burst),
        .aw__size(aw__size),
        .aw__len(aw__len),
        .aw__addr(aw__addr),
        .aw__id(aw__id),
        .aw__valid(aw__valid),
        .ar__user(ar__user),
        .ar__region(ar__region),
        .ar__qos(ar__qos),
        .ar__prot(ar__prot),
        .ar__cache(ar__cache),
        .ar__lock(ar__lock),
        .ar__burst(ar__burst),
        .ar__size(ar__size),
        .ar__len(ar__len),
        .ar__addr(ar__addr),
        .ar__id(ar__id),
        .ar__valid(ar__valid),
        .areset_n(reset_n),
        .apb_request__pwdata(            apb_request__pwdata),
        .apb_request__pwrite(            apb_request__pwrite),
        .apb_request__psel(            apb_request__psel),
        .apb_request__penable(            apb_request__penable),
        .apb_request__paddr(            apb_request__paddr),
        .r__user(            r__user),
        .r__last(            r__last),
        .r__resp(            r__resp),
        .r__data(            r__data),
        .r__id(            r__id),
        .r__valid(            r__valid),
        .b__user(            b__user),
        .b__resp(            b__resp),
        .b__id(            b__id),
        .b__valid(            b__valid),
        .wready(            wready),
        .awready(            awready),
        .arready(            arready)         );
    apb_target_timer timer(
        .clk(aclk),
        .clk__enable(1'b1),
        .apb_request__pwdata(timer_apb_request__pwdata),
        .apb_request__pwrite(timer_apb_request__pwrite),
        .apb_request__psel(timer_apb_request__psel),
        .apb_request__penable(timer_apb_request__penable),
        .apb_request__paddr(timer_apb_request__paddr),
        .reset_n(reset_n),
        .timer_equalled(            timer_equalled),
        .apb_response__perr(            timer_apb_response__perr),
        .apb_response__pready(            timer_apb_response__pready),
        .apb_response__prdata(            timer_apb_response__prdata)         );
    apb_target_gpio gpio(
        .clk(aclk),
        .clk__enable(1'b1),
        .gpio_input(gpio_input),
        .apb_request__pwdata(gpio_apb_request__pwdata),
        .apb_request__pwrite(gpio_apb_request__pwrite),
        .apb_request__psel(gpio_apb_request__psel),
        .apb_request__penable(gpio_apb_request__penable),
        .apb_request__paddr(gpio_apb_request__paddr),
        .reset_n(reset_n),
        .gpio_input_event(            gpio_input_event),
        .gpio_output_enable(            gpio_output_enable),
        .gpio_output(            gpio_output),
        .apb_response__perr(            gpio_apb_response__perr),
        .apb_response__pready(            gpio_apb_response__pready),
        .apb_response__prdata(            gpio_apb_response__prdata)         );
    //b dut_instance combinatorial process
    always @ ( * )//dut_instance
    begin: dut_instance__comb_code
    reg timer_apb_request__psel__var;
    reg gpio_apb_request__psel__var;
    reg [31:0]apb_response__prdata__var;
    reg apb_response__pready__var;
    reg apb_response__perr__var;
        timer_apb_request__paddr = apb_request__paddr;
        timer_apb_request__penable = apb_request__penable;
        timer_apb_request__psel__var = apb_request__psel;
        timer_apb_request__pwrite = apb_request__pwrite;
        timer_apb_request__pwdata = apb_request__pwdata;
        gpio_apb_request__paddr = apb_request__paddr;
        gpio_apb_request__penable = apb_request__penable;
        gpio_apb_request__psel__var = apb_request__psel;
        gpio_apb_request__pwrite = apb_request__pwrite;
        gpio_apb_request__pwdata = apb_request__pwdata;
        timer_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request__paddr[31:28]==4'h0));
        gpio_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request__paddr[31:28]==4'h1));
        apb_response__prdata__var = timer_apb_response__prdata;
        apb_response__pready__var = timer_apb_response__pready;
        apb_response__perr__var = timer_apb_response__perr;
        if ((apb_request__paddr[31:28]==4'h1))
        begin
            apb_response__prdata__var = gpio_apb_response__prdata;
            apb_response__pready__var = gpio_apb_response__pready;
            apb_response__perr__var = gpio_apb_response__perr;
        end //if
        gpio_input = {13'h0,timer_equalled};
        timer_apb_request__psel = timer_apb_request__psel__var;
        gpio_apb_request__psel = gpio_apb_request__psel__var;
        apb_response__prdata = apb_response__prdata__var;
        apb_response__pready = apb_response__pready__var;
        apb_response__perr = apb_response__perr__var;
    end //always

endmodule // tb_axi
