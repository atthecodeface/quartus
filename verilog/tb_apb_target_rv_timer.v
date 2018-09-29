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

//a Module tb_apb_target_rv_timer
module tb_apb_target_rv_timer
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

    //b Internal combinatorials
    reg [31:0]timer_apb_request__paddr;
    reg timer_apb_request__penable;
    reg timer_apb_request__psel;
    reg timer_apb_request__pwrite;
    reg [31:0]timer_apb_request__pwdata;
    reg [31:0]apb_response__prdata;
    reg apb_response__pready;
    reg apb_response__perr;

    //b Internal nets
    wire [31:0]timer_apb_response__prdata;
    wire timer_apb_response__pready;
    wire timer_apb_response__perr;
    wire timer_value__irq;
    wire [63:0]timer_value__value;
    wire timer_control__reset_counter;
    wire timer_control__enable_counter;
    wire timer_control__block_writes;
    wire [7:0]timer_control__bonus_subfraction_numer;
    wire [7:0]timer_control__bonus_subfraction_denom;
    wire [3:0]timer_control__fractional_adder;
    wire [7:0]timer_control__integer_adder;
    wire [31:0]apb_request__paddr;
    wire apb_request__penable;
    wire apb_request__psel;
    wire apb_request__pwrite;
    wire [31:0]apb_request__pwdata;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .timer_value__value(timer_value__value),
        .timer_value__irq(timer_value__irq),
        .apb_response__perr(apb_response__perr),
        .apb_response__pready(apb_response__pready),
        .apb_response__prdata(apb_response__prdata),
        .timer_control__integer_adder(            timer_control__integer_adder),
        .timer_control__fractional_adder(            timer_control__fractional_adder),
        .timer_control__bonus_subfraction_denom(            timer_control__bonus_subfraction_denom),
        .timer_control__bonus_subfraction_numer(            timer_control__bonus_subfraction_numer),
        .timer_control__block_writes(            timer_control__block_writes),
        .timer_control__enable_counter(            timer_control__enable_counter),
        .timer_control__reset_counter(            timer_control__reset_counter),
        .apb_request__pwdata(            apb_request__pwdata),
        .apb_request__pwrite(            apb_request__pwrite),
        .apb_request__psel(            apb_request__psel),
        .apb_request__penable(            apb_request__penable),
        .apb_request__paddr(            apb_request__paddr)         );
    apb_target_rv_timer timer(
        .clk(clk),
        .clk__enable(1'b1),
        .timer_control__integer_adder(timer_control__integer_adder),
        .timer_control__fractional_adder(timer_control__fractional_adder),
        .timer_control__bonus_subfraction_denom(timer_control__bonus_subfraction_denom),
        .timer_control__bonus_subfraction_numer(timer_control__bonus_subfraction_numer),
        .timer_control__block_writes(timer_control__block_writes),
        .timer_control__enable_counter(timer_control__enable_counter),
        .timer_control__reset_counter(timer_control__reset_counter),
        .apb_request__pwdata(timer_apb_request__pwdata),
        .apb_request__pwrite(timer_apb_request__pwrite),
        .apb_request__psel(timer_apb_request__psel),
        .apb_request__penable(timer_apb_request__penable),
        .apb_request__paddr(timer_apb_request__paddr),
        .reset_n(reset_n),
        .timer_value__value(            timer_value__value),
        .timer_value__irq(            timer_value__irq),
        .apb_response__perr(            timer_apb_response__perr),
        .apb_response__pready(            timer_apb_response__pready),
        .apb_response__prdata(            timer_apb_response__prdata)         );
    //b instantiations combinatorial process
    always @ ( * )//instantiations
    begin: instantiations__comb_code
    reg timer_apb_request__psel__var;
    reg [31:0]apb_response__prdata__var;
    reg apb_response__pready__var;
    reg apb_response__perr__var;
        timer_apb_request__paddr = apb_request__paddr;
        timer_apb_request__penable = apb_request__penable;
        timer_apb_request__psel__var = apb_request__psel;
        timer_apb_request__pwrite = apb_request__pwrite;
        timer_apb_request__pwdata = apb_request__pwdata;
        timer_apb_request__psel__var = ((apb_request__psel!=1'h0)&&(apb_request__paddr[31:28]==4'h0));
        apb_response__prdata__var = timer_apb_response__prdata;
        apb_response__pready__var = timer_apb_response__pready;
        apb_response__perr__var = timer_apb_response__perr;
        if ((apb_request__paddr[31:28]!=4'h0))
        begin
            apb_response__prdata__var = 32'h0;
            apb_response__pready__var = 1'h0;
            apb_response__perr__var = 1'h0;
        end //if
        timer_apb_request__psel = timer_apb_request__psel__var;
        apb_response__prdata = apb_response__prdata__var;
        apb_response__pready = apb_response__pready__var;
        apb_response__perr = apb_response__perr__var;
    end //always

endmodule // tb_apb_target_rv_timer
