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

//a Module tb_6502
module tb_6502
(
    clk,
    clk__enable,

    reset_n

);

    //b Clocks
    input clk;
    input clk__enable;
    wire sram_clk; // Gated version of clock 'clk' enabled by 'enable_sram_clk'
    wire sram_clk__enable;
    wire cpu_clk; // Gated version of clock 'clk' enabled by 'enable_cpu_clk'
    wire cpu_clk__enable;

    //b Inputs
    input reset_n;

    //b Outputs

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg [15:0]cycle_counter;
    reg nmi_n;
    reg irq_n;

    //b Internal combinatorials
    reg enable_sram_clk;
    reg enable_cpu_clk;

    //b Internal nets
        //   Captured at the end of phase 2 (rising clock with phi[1] high)
    wire [7:0]data_in;
        //   Changes during phase 2 (phi[1] high) with data to write
    wire [7:0]data_out;
        //   Changes during phase 1 (phi[0] high) with whether to read or write
    wire read_not_write;
        //   Changes during phase 1 (phi[0] high) with address to read or write
    wire [15:0]address;
        //   Goes high during phase 2 if ready was low in phase 1 if read_not_write is 1, to permit someone else to use the memory bus
    wire ba;

    //b Clock gating module instances
    assign sram_clk__enable = (clk__enable && enable_sram_clk);
    assign cpu_clk__enable = (clk__enable && enable_cpu_clk);
    //b Module instances
    se_sram_srw_65536x8 imem(
        .sram_clock(clk),
        .sram_clock__enable(sram_clk__enable),
        .write_data(data_out),
        .address(address),
        .write_enable(!(read_not_write!=1'h0)),
        .read_not_write(read_not_write),
        .select(1'h1),
        .data_out(            data_in)         );
    cpu6502 cpu6502_0(
        .clk(clk),
        .clk__enable(cpu_clk__enable),
        .data_in(data_in),
        .nmi_n(nmi_n),
        .irq_n(irq_n),
        .ready(1'h1),
        .reset_n(reset_n),
        .data_out(            data_out),
        .read_not_write(            read_not_write),
        .address(            address),
        .ba(            ba)         );
    //b interrupt_and_nmi__comb combinatorial process
        //   
        //       The interrupt and NMI are not currently configured to fire - they perhaps ought to be controlled.
        //   
        //       The clock gating is to ping-pong the CPU and the SRAM - to mimick the 6502 phi 1 / 2 latch operation.
        //       
    always @ ( * )//interrupt_and_nmi__comb
    begin: interrupt_and_nmi__comb_code
        enable_sram_clk = cycle_counter[0];
        enable_cpu_clk = !(cycle_counter[0]!=1'h0);
    end //always

    //b interrupt_and_nmi__posedge_clk_active_low_reset_n clock process
        //   
        //       The interrupt and NMI are not currently configured to fire - they perhaps ought to be controlled.
        //   
        //       The clock gating is to ping-pong the CPU and the SRAM - to mimick the 6502 phi 1 / 2 latch operation.
        //       
    always @( posedge clk or negedge reset_n)
    begin : interrupt_and_nmi__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            cycle_counter <= 16'h0;
            irq_n <= 1'h1;
            nmi_n <= 1'h1;
        end
        else if (clk__enable)
        begin
            cycle_counter <= (cycle_counter+16'h1);
            if ((cycle_counter[7:0]==8'hff))
            begin
                irq_n <= 1'h1;
                nmi_n <= 1'h1;
            end //if
        end //if
    end //always

endmodule // tb_6502
