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

//a Module bbc_micro_clocking
module bbc_micro_clocking
(
    clk,
    clk__enable,

    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    clock_status__cpu_1MHz_access,
    reset_n,

    csr_response__acknowledge,
    csr_response__read_data_valid,
    csr_response__read_data_error,
    csr_response__read_data,
    clock_control__enable_cpu,
    clock_control__will_enable_2MHz_video,
    clock_control__enable_2MHz_video,
    clock_control__enable_1MHz_rising,
    clock_control__enable_1MHz_falling,
    clock_control__phi,
    clock_control__reset_cpu,
    clock_control__debug
);

    //b Clocks
        //   4MHz clock in as a minimum
    input clk;
    input clk__enable;

    //b Inputs
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
    input clock_status__cpu_1MHz_access;
    input reset_n;

    //b Outputs
    output csr_response__acknowledge;
    output csr_response__read_data_valid;
    output csr_response__read_data_error;
    output [31:0]csr_response__read_data;
    output clock_control__enable_cpu;
    output clock_control__will_enable_2MHz_video;
    output clock_control__enable_2MHz_video;
    output clock_control__enable_1MHz_rising;
    output clock_control__enable_1MHz_falling;
    output [1:0]clock_control__phi;
    output clock_control__reset_cpu;
    output [3:0]clock_control__debug;

// output components here

    //b Output combinatorials
    reg clock_control__enable_cpu;
    reg clock_control__will_enable_2MHz_video;
    reg clock_control__enable_2MHz_video;
    reg clock_control__enable_1MHz_rising;
    reg clock_control__enable_1MHz_falling;
    reg [1:0]clock_control__phi;
    reg clock_control__reset_cpu;
    reg [3:0]clock_control__debug;

    //b Output nets
    wire csr_response__acknowledge;
    wire csr_response__read_data_valid;
    wire csr_response__read_data_error;
    wire [31:0]csr_response__read_data;

    //b Internal and output registers
    reg [1:0]phase_of_clock;
    reg divider__phase_ending_cpu;
    reg divider__phase_ending_2MHz;
    reg [7:0]divider__counter;
    reg [7:0]control__clocks_per_2MHz_minus_one;
    reg [7:0]control__cpu_clocks_per_2MHz_minus_one;
    reg control__reset_cpu;
    reg control__disable_cpu;
    reg phi2_extension_required;
    reg cpu_clk_high;
    reg cpu_clk_low;
    reg one_mhz_high;
    reg one_mhz_low;
    reg two_mhz_high;
    reg two_mhz_low;

    //b Internal combinatorials
    reg phi2_completed;
    reg phi1_completed;
    reg [31:0]csr_read_data;
    reg cpu_clk_enable;
    reg phi2;
    reg phi1;
    reg cpu_clk__phase_ending;
    reg cpu_clk__fall_enable;
    reg cpu_clk__rise_enable;
    reg two_mhz__phase_ending;
    reg two_mhz__fall_enable;
    reg two_mhz__rise_enable;
    reg one_mhz__phase_ending;
    reg one_mhz__fall_enable;
    reg one_mhz__rise_enable;

    //b Internal nets
    wire csr_access__valid;
    wire csr_access__read_not_write;
    wire [15:0]csr_access__address;
    wire [31:0]csr_access__data;

    //b Clock gating module instances
    //b Module instances
    csr_target_csr csri(
        .clk(clk),
        .clk__enable(1'b1),
        .csr_select(16'h0),
        .csr_access_data(csr_read_data),
        .csr_request__data(csr_request__data),
        .csr_request__address(csr_request__address),
        .csr_request__select(csr_request__select),
        .csr_request__read_not_write(csr_request__read_not_write),
        .csr_request__valid(csr_request__valid),
        .reset_n(reset_n),
        .csr_access__data(            csr_access__data),
        .csr_access__address(            csr_access__address),
        .csr_access__read_not_write(            csr_access__read_not_write),
        .csr_access__valid(            csr_access__valid),
        .csr_response__read_data(            csr_response__read_data),
        .csr_response__read_data_error(            csr_response__read_data_error),
        .csr_response__read_data_valid(            csr_response__read_data_valid),
        .csr_response__acknowledge(            csr_response__acknowledge)         );
    //b control_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//control_logic__comb
    begin: control_logic__comb_code
        csr_read_data = {{{{14'h0,control__disable_cpu},control__reset_cpu},control__cpu_clocks_per_2MHz_minus_one},control__clocks_per_2MHz_minus_one};
    end //always

    //b control_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : control_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            control__cpu_clocks_per_2MHz_minus_one <= 8'h0;
            control__cpu_clocks_per_2MHz_minus_one <= 8'h2;
            control__clocks_per_2MHz_minus_one <= 8'h0;
            control__clocks_per_2MHz_minus_one <= 8'hb;
            control__reset_cpu <= 1'h0;
            control__disable_cpu <= 1'h0;
        end
        else if (clk__enable)
        begin
            if (((csr_access__valid!=1'h0)&&!(csr_access__read_not_write!=1'h0)))
            begin
                control__cpu_clocks_per_2MHz_minus_one <= csr_access__data[15:8];
                control__clocks_per_2MHz_minus_one <= csr_access__data[7:0];
                control__reset_cpu <= csr_access__data[16];
                control__disable_cpu <= csr_access__data[17];
            end //if
        end //if
    end //always

    //b output_logic combinatorial process
        //   
        //       If clock_status.cpu_1MHz_access is asserted in phi1 then the chip selects,
        //       other than phi2, to some chips will be asserted.
        //       In this case phi2 must not be allowed to start until 1MHz is low.
        //       So if 1MHz is high and phi1 and doing a 1MHz access then CPU must ignore the clock edge
        //       and it will be deemed to be staying in phi1.
        //   
        //       If clock_status.cpu_1MHz_access is asserted in (and at the start of, from above) phi2 then
        //       1MHz bus devices are properly selected, and the next CPU clock edge is coincident with 1MHz
        //       falling. So ignore CPU clock enables until 1MHz_fall_enable.
        //   
        //       Now the actual clock enable for the CPU is the phi2 ending.
        //       
    always @ ( * )//output_logic
    begin: output_logic__comb_code
    reg [3:0]clock_control__debug__var;
        clock_control__enable_cpu = cpu_clk_enable;
        clock_control__will_enable_2MHz_video = two_mhz__rise_enable;
        clock_control__enable_2MHz_video = two_mhz_high;
        clock_control__enable_1MHz_rising = one_mhz__rise_enable;
        clock_control__enable_1MHz_falling = one_mhz__fall_enable;
        clock_control__phi = phase_of_clock;
        clock_control__reset_cpu = control__reset_cpu;
        clock_control__debug__var[0] = cpu_clk_low;
        clock_control__debug__var[1] = divider__phase_ending_cpu;
        clock_control__debug__var[2] = divider__phase_ending_2MHz;
        clock_control__debug__var[3] = control__disable_cpu;
        clock_control__debug = clock_control__debug__var;
    end //always

    //b clocking_logic__comb combinatorial process
        //   
        //       
    always @ ( * )//clocking_logic__comb
    begin: clocking_logic__comb_code
    reg phi1_completed__var;
    reg phi2_completed__var;
        cpu_clk__phase_ending = (((divider__phase_ending_cpu!=1'h0)&&!(control__disable_cpu!=1'h0))||(cpu_clk_high!=1'h0));
        cpu_clk__fall_enable = ((cpu_clk_high!=1'h0)&&(cpu_clk__phase_ending!=1'h0));
        cpu_clk__rise_enable = ((cpu_clk_low!=1'h0)&&(cpu_clk__phase_ending!=1'h0));
        two_mhz__phase_ending = (cpu_clk__phase_ending & divider__phase_ending_2MHz);
        two_mhz__rise_enable = ((cpu_clk_low!=1'h0)&&(two_mhz__phase_ending!=1'h0));
        two_mhz__fall_enable = two_mhz_high;
        one_mhz__phase_ending = two_mhz__rise_enable;
        one_mhz__fall_enable = (!(one_mhz_low!=1'h0)&&(one_mhz__phase_ending!=1'h0));
        one_mhz__rise_enable = ((one_mhz_low!=1'h0)&&(one_mhz__phase_ending!=1'h0));
        phi1 = phase_of_clock[0];
        phi2 = phase_of_clock[1];
        phi1_completed__var = ((phi1!=1'h0)&&(cpu_clk__fall_enable!=1'h0));
        phi2_completed__var = ((phi2!=1'h0)&&(cpu_clk__rise_enable!=1'h0));
        if ((phi2_extension_required!=1'h0))
        begin
            phi2_completed__var = ((phi2!=1'h0)&&(one_mhz__fall_enable!=1'h0));
        end //if
        if (((clock_status__cpu_1MHz_access!=1'h0)&&(phi1!=1'h0)))
        begin
            if ((one_mhz_high!=1'h0))
            begin
                phi1_completed__var = 1'h0;
            end //if
        end //if
        cpu_clk_enable = ((cpu_clk__rise_enable!=1'h0)&&(!(phi2_extension_required!=1'h0)||(phi2_completed__var!=1'h0)));
        phi1_completed = phi1_completed__var;
        phi2_completed = phi2_completed__var;
    end //always

    //b clocking_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : clocking_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            divider__counter <= 8'h0;
            divider__phase_ending_2MHz <= 1'h0;
            divider__phase_ending_cpu <= 1'h0;
            cpu_clk_low <= 1'h0;
            cpu_clk_high <= 1'h0;
            two_mhz_low <= 1'h0;
            two_mhz_high <= 1'h0;
            one_mhz_low <= 1'h0;
            one_mhz_high <= 1'h0;
            phi2_extension_required <= 1'h0;
            phase_of_clock <= 2'h1;
        end
        else if (clk__enable)
        begin
            divider__counter <= (divider__counter+8'h1);
            divider__phase_ending_2MHz <= 1'h0;
            if ((divider__counter==control__cpu_clocks_per_2MHz_minus_one))
            begin
                divider__phase_ending_cpu <= 1'h0;
            end //if
            if ((divider__counter==control__clocks_per_2MHz_minus_one))
            begin
                divider__counter <= 8'h0;
                divider__phase_ending_cpu <= 1'h1;
                divider__phase_ending_2MHz <= 1'h1;
            end //if
            if ((cpu_clk__phase_ending!=1'h0))
            begin
                cpu_clk_low <= !(cpu_clk_low!=1'h0);
                cpu_clk_high <= cpu_clk_low;
            end //if
            two_mhz_low <= 1'h1;
            two_mhz_high <= 1'h0;
            if ((two_mhz__rise_enable!=1'h0))
            begin
                two_mhz_low <= 1'h0;
                two_mhz_high <= 1'h1;
            end //if
            if ((one_mhz__phase_ending!=1'h0))
            begin
                one_mhz_low <= !(one_mhz_low!=1'h0);
                one_mhz_high <= one_mhz_low;
            end //if
            if (((clock_status__cpu_1MHz_access!=1'h0)&&(phi1!=1'h0)))
            begin
                phi2_extension_required <= 1'h1;
            end //if
            if ((((phi2!=1'h0)&&(one_mhz_high!=1'h0))&&(one_mhz__phase_ending!=1'h0)))
            begin
                phi2_extension_required <= 1'h0;
            end //if
            if ((phi1_completed!=1'h0))
            begin
                phase_of_clock <= 2'h2;
            end //if
            if ((phi2_completed!=1'h0))
            begin
                phase_of_clock <= 2'h1;
            end //if
        end //if
    end //always

endmodule // bbc_micro_clocking
