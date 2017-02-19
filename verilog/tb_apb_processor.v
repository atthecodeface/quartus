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

//a Module tb_apb_processor
module tb_apb_processor
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
    wire [39:0]rom_data;
    wire rom_request__enable;
    wire [15:0]rom_request__address;
    wire [31:0]apb_request__paddr;
    wire apb_request__penable;
    wire apb_request__psel;
    wire apb_request__pwrite;
    wire [31:0]apb_request__pwdata;
    wire apb_processor_response__acknowledge;
    wire apb_processor_response__rom_busy;
    wire apb_processor_request__valid;
    wire [15:0]apb_processor_request__address;

    //b Clock gating module instances
    //b Module instances
    se_test_harness th(
        .clk(clk),
        .clk__enable(1'b1),
        .timer_equalled(timer_equalled),
        .apb_processor_response__rom_busy(apb_processor_response__rom_busy),
        .apb_processor_response__acknowledge(apb_processor_response__acknowledge),
        .apb_processor_request__address(            apb_processor_request__address),
        .apb_processor_request__valid(            apb_processor_request__valid)         );
    apb_processor apbp(
        .clk(clk),
        .clk__enable(1'b1),
        .rom_data(rom_data),
        .apb_response__perr(apb_response__perr),
        .apb_response__pready(apb_response__pready),
        .apb_response__prdata(apb_response__prdata),
        .apb_processor_request__address(apb_processor_request__address),
        .apb_processor_request__valid(apb_processor_request__valid),
        .reset_n(reset_n),
        .rom_request__address(            rom_request__address),
        .rom_request__enable(            rom_request__enable),
        .apb_request__pwdata(            apb_request__pwdata),
        .apb_request__pwrite(            apb_request__pwrite),
        .apb_request__psel(            apb_request__psel),
        .apb_request__penable(            apb_request__penable),
        .apb_request__paddr(            apb_request__paddr),
        .apb_processor_response__rom_busy(            apb_processor_response__rom_busy),
        .apb_processor_response__acknowledge(            apb_processor_response__acknowledge)         );
    se_sram_srw_16384x40 apb_rom(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(40'h0),
        .read_not_write(1'h1),
        .address(rom_request__address[13:0]),
        .select(rom_request__enable),
        .data_out(            rom_data)         );
    apb_target_timer timer(
        .clk(clk),
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
        .clk(clk),
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
    //b instantiations combinatorial process
    always @ ( * )//instantiations
    begin: instantiations__comb_code
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

endmodule // tb_apb_processor
