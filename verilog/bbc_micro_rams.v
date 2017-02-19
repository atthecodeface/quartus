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

//a Module bbc_micro_rams
module bbc_micro_rams
(
    clk,
    clk__enable,

    bbc_micro_host_sram_response__ack,
    bbc_micro_host_sram_response__read_data_valid,
    bbc_micro_host_sram_response__read_data,
    floppy_sram_request__enable,
    floppy_sram_request__read_not_write,
    floppy_sram_request__address,
    floppy_sram_request__write_data,
    display_sram_write__enable,
    display_sram_write__data,
    display_sram_write__address,
    host_sram_request__valid,
    host_sram_request__read_enable,
    host_sram_request__write_enable,
    host_sram_request__select,
    host_sram_request__address,
    host_sram_request__write_data,
    clock_control__enable_cpu,
    clock_control__will_enable_2MHz_video,
    clock_control__enable_2MHz_video,
    clock_control__enable_1MHz_rising,
    clock_control__enable_1MHz_falling,
    clock_control__phi,
    clock_control__reset_cpu,
    clock_control__debug,
    reset_n,

    bbc_micro_host_sram_request__valid,
    bbc_micro_host_sram_request__read_enable,
    bbc_micro_host_sram_request__write_enable,
    bbc_micro_host_sram_request__select,
    bbc_micro_host_sram_request__address,
    bbc_micro_host_sram_request__write_data,
    floppy_sram_response__ack,
    floppy_sram_response__read_data_valid,
    floppy_sram_response__read_data,
    host_sram_response__ack,
    host_sram_response__read_data_valid,
    host_sram_response__read_data
);

    //b Clocks
        //   4MHz clock in as a minimum
    input clk;
    input clk__enable;

    //b Inputs
    input bbc_micro_host_sram_response__ack;
    input bbc_micro_host_sram_response__read_data_valid;
    input [63:0]bbc_micro_host_sram_response__read_data;
    input floppy_sram_request__enable;
    input floppy_sram_request__read_not_write;
    input [19:0]floppy_sram_request__address;
    input [31:0]floppy_sram_request__write_data;
    input display_sram_write__enable;
    input [47:0]display_sram_write__data;
    input [15:0]display_sram_write__address;
    input host_sram_request__valid;
    input host_sram_request__read_enable;
    input host_sram_request__write_enable;
    input [7:0]host_sram_request__select;
    input [23:0]host_sram_request__address;
    input [63:0]host_sram_request__write_data;
    input clock_control__enable_cpu;
    input clock_control__will_enable_2MHz_video;
    input clock_control__enable_2MHz_video;
    input clock_control__enable_1MHz_rising;
    input clock_control__enable_1MHz_falling;
    input [1:0]clock_control__phi;
    input clock_control__reset_cpu;
    input [3:0]clock_control__debug;
    input reset_n;

    //b Outputs
    output bbc_micro_host_sram_request__valid;
    output bbc_micro_host_sram_request__read_enable;
    output bbc_micro_host_sram_request__write_enable;
    output [7:0]bbc_micro_host_sram_request__select;
    output [23:0]bbc_micro_host_sram_request__address;
    output [63:0]bbc_micro_host_sram_request__write_data;
    output floppy_sram_response__ack;
    output floppy_sram_response__read_data_valid;
    output [31:0]floppy_sram_response__read_data;
    output host_sram_response__ack;
    output host_sram_response__read_data_valid;
    output [63:0]host_sram_response__read_data;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg pending_host_sram_request__valid;
    reg pending_host_sram_request__read_enable;
    reg pending_host_sram_request__write_enable;
    reg [7:0]pending_host_sram_request__select;
    reg [23:0]pending_host_sram_request__address;
    reg [63:0]pending_host_sram_request__write_data;
    reg host_sram_pending;
    reg pending_floppy_sram_response__ack;
    reg pending_floppy_sram_response__read_data_valid;
    reg [31:0]pending_floppy_sram_response__read_data;
    reg pending_floppy_sram_request__enable;
    reg pending_floppy_sram_request__read_not_write;
    reg [19:0]pending_floppy_sram_request__address;
    reg [31:0]pending_floppy_sram_request__write_data;
    reg pending_display_sram_write__enable;
    reg [47:0]pending_display_sram_write__data;
    reg [15:0]pending_display_sram_write__address;
    reg display_sram_reading_host;
    reg floppy_sram_reading_host;
    reg sram_reading_floppy;
    reg bbc_micro_host_sram_request__valid;
    reg bbc_micro_host_sram_request__read_enable;
    reg bbc_micro_host_sram_request__write_enable;
    reg [7:0]bbc_micro_host_sram_request__select;
    reg [23:0]bbc_micro_host_sram_request__address;
    reg [63:0]bbc_micro_host_sram_request__write_data;
    reg floppy_sram_response__ack;
    reg floppy_sram_response__read_data_valid;
    reg [31:0]floppy_sram_response__read_data;
    reg host_sram_response__ack;
    reg host_sram_response__read_data_valid;
    reg [63:0]host_sram_response__read_data;

    //b Internal combinatorials
    reg floppy_sram__select;
    reg floppy_sram__read_not_write;
    reg floppy_sram__write_enable;
    reg [19:0]floppy_sram__address;
    reg [63:0]floppy_sram__write_data;
    reg display_sram__select;
    reg display_sram__read_not_write;
    reg display_sram__write_enable;
    reg [19:0]display_sram__address;
    reg [63:0]display_sram__write_data;
    reg [1:0]sram_grant_host_request;
    reg sram_grant_floppy;
    reg sram_grant_display_write;

    //b Internal nets
    wire [63:0]display_sram_read_data;
    wire [31:0]floppy_sram_read_data;

    //b Clock gating module instances
    //b Module instances
    se_sram_srw_32768x64 display(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(display_sram__write_data),
        .address(display_sram__address[14:0]),
        .write_enable(display_sram__write_enable),
        .read_not_write(display_sram__read_not_write),
        .select(display_sram__select),
        .data_out(            display_sram_read_data)         );
    se_sram_srw_32768x32 floppy(
        .sram_clock(clk),
        .sram_clock__enable(1'b1),
        .write_data(floppy_sram__write_data[31:0]),
        .address(floppy_sram__address[14:0]),
        .write_enable(floppy_sram__write_enable),
        .read_not_write(floppy_sram__read_not_write),
        .select(floppy_sram__select),
        .data_out(            floppy_sram_read_data)         );
    //b display_sram_interface clock process
        //   
        //       The display SRAM interface is write-only from the BBC micro
        //       It writes on the 2MHz video clock with 48-bits of RGB data,
        //       which has to be expanded to 64-bits of SRAM write data
        //   
        //       The display SRAM interface assumes that the VIDEO clock is
        //       slower than the main clock (which it has to be) and so if
        //       the display SRAM interface has high priority for its SRAM there is
        //       no need to buffer and acknowledge write requests
        //       
    always @( posedge clk or negedge reset_n)
    begin : display_sram_interface__code
        if (reset_n==1'b0)
        begin
            pending_display_sram_write__enable <= 1'h0;
            pending_display_sram_write__data <= 48'h0;
            pending_display_sram_write__address <= 16'h0;
        end
        else if (clk__enable)
        begin
            if (((clock_control__enable_2MHz_video!=1'h0)&&(display_sram_write__enable!=1'h0)))
            begin
                pending_display_sram_write__enable <= display_sram_write__enable;
                pending_display_sram_write__data <= display_sram_write__data;
                pending_display_sram_write__address <= display_sram_write__address;
            end //if
            if ((sram_grant_display_write!=1'h0))
            begin
                pending_display_sram_write__enable <= 1'h0;
            end //if
        end //if
    end //always

    //b floppy_sram_interface clock process
        //   
        //       The floppy SRAM interface is read-write from the BBC micro,
        //       operating on the CPU clock.
        //   
        //       Requests have to be acknowledged, but the FDC is guaranteed not
        //       to present back-to-back requests (i.e. if ack is asserted for one
        //       cycle then valid && !ack indicates a valid request in).
        //   
        //       A valid read request will not be followed by another request until
        //       valid read data is returned.
        //   
        //       The interface to the BBC micro should only change on the CPU clock,
        //       but the SRAM runs at the faster standard clock. However, the logic
        //       here does not care about SRAM priority access.
        //       
    always @( posedge clk or negedge reset_n)
    begin : floppy_sram_interface__code
        if (reset_n==1'b0)
        begin
            pending_floppy_sram_response__ack <= 1'h0;
            pending_floppy_sram_request__enable <= 1'h0;
            pending_floppy_sram_request__read_not_write <= 1'h0;
            pending_floppy_sram_request__address <= 20'h0;
            pending_floppy_sram_request__write_data <= 32'h0;
            floppy_sram_response__ack <= 1'h0;
            floppy_sram_response__read_data_valid <= 1'h0;
            pending_floppy_sram_response__read_data_valid <= 1'h0;
            floppy_sram_response__read_data <= 32'h0;
            pending_floppy_sram_response__read_data <= 32'h0;
        end
        else if (clk__enable)
        begin
            pending_floppy_sram_response__ack <= 1'h0;
            if ((clock_control__enable_cpu!=1'h0))
            begin
                if ((floppy_sram_request__enable!=1'h0))
                begin
                    pending_floppy_sram_request__enable <= floppy_sram_request__enable;
                    pending_floppy_sram_request__read_not_write <= floppy_sram_request__read_not_write;
                    pending_floppy_sram_request__address <= floppy_sram_request__address;
                    pending_floppy_sram_request__write_data <= floppy_sram_request__write_data;
                    if ((floppy_sram_response__ack!=1'h0))
                    begin
                        pending_floppy_sram_request__enable <= 1'h0;
                    end //if
                end //if
                floppy_sram_response__ack <= floppy_sram_request__enable;
                floppy_sram_response__read_data_valid <= 1'h0;
                if ((pending_floppy_sram_response__read_data_valid!=1'h0))
                begin
                    pending_floppy_sram_response__read_data_valid <= 1'h0;
                    floppy_sram_response__read_data_valid <= 1'h1;
                    floppy_sram_response__read_data <= pending_floppy_sram_response__read_data;
                end //if
            end //if
            if ((sram_grant_floppy!=1'h0))
            begin
                pending_floppy_sram_request__enable <= 1'h0;
            end //if
            if ((sram_reading_floppy!=1'h0))
            begin
                pending_floppy_sram_response__read_data_valid <= 1'h1;
                pending_floppy_sram_response__read_data <= floppy_sram_read_data;
            end //if
        end //if
    end //always

    //b host_access clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : host_access__code
        if (reset_n==1'b0)
        begin
            pending_host_sram_request__valid <= 1'h0;
            pending_host_sram_request__read_enable <= 1'h0;
            pending_host_sram_request__write_enable <= 1'h0;
            pending_host_sram_request__select <= 8'h0;
            pending_host_sram_request__address <= 24'h0;
            pending_host_sram_request__write_data <= 64'h0;
            host_sram_response__ack <= 1'h0;
            host_sram_response__read_data_valid <= 1'h0;
            host_sram_pending <= 1'h0;
            bbc_micro_host_sram_request__valid <= 1'h0;
            bbc_micro_host_sram_request__read_enable <= 1'h0;
            bbc_micro_host_sram_request__write_enable <= 1'h0;
            bbc_micro_host_sram_request__select <= 8'h0;
            bbc_micro_host_sram_request__address <= 24'h0;
            bbc_micro_host_sram_request__write_data <= 64'h0;
            host_sram_response__read_data <= 64'h0;
        end
        else if (clk__enable)
        begin
            if ((((host_sram_request__valid!=1'h0)&&!(host_sram_response__ack!=1'h0))&&!(host_sram_pending!=1'h0)))
            begin
                pending_host_sram_request__valid <= host_sram_request__valid;
                pending_host_sram_request__read_enable <= host_sram_request__read_enable;
                pending_host_sram_request__write_enable <= host_sram_request__write_enable;
                pending_host_sram_request__select <= host_sram_request__select;
                pending_host_sram_request__address <= host_sram_request__address;
                pending_host_sram_request__write_data <= host_sram_request__write_data;
            end //if
            if ((sram_grant_host_request!=2'h0))
            begin
                pending_host_sram_request__valid <= 1'h0;
            end //if
            if (!(host_sram_request__valid!=1'h0))
            begin
                host_sram_response__ack <= 1'h0;
            end //if
            host_sram_response__read_data_valid <= 1'h0;
            if (((sram_grant_host_request==2'h1)||(sram_grant_host_request==2'h2)))
            begin
                host_sram_response__ack <= 1'h1;
                if ((pending_host_sram_request__read_enable!=1'h0))
                begin
                    host_sram_pending <= 1'h1;
                end //if
            end //if
            if ((host_sram_response__ack!=1'h0))
            begin
                host_sram_pending <= 1'h0;
            end //if
            if ((sram_grant_host_request==2'h3))
            begin
                host_sram_pending <= 1'h1;
                bbc_micro_host_sram_request__valid <= pending_host_sram_request__valid;
                bbc_micro_host_sram_request__read_enable <= pending_host_sram_request__read_enable;
                bbc_micro_host_sram_request__write_enable <= pending_host_sram_request__write_enable;
                bbc_micro_host_sram_request__select <= pending_host_sram_request__select;
                bbc_micro_host_sram_request__address <= pending_host_sram_request__address;
                bbc_micro_host_sram_request__write_data <= pending_host_sram_request__write_data;
            end //if
            if ((host_sram_pending!=1'h0))
            begin
                if (((bbc_micro_host_sram_request__valid!=1'h0)&&(bbc_micro_host_sram_response__ack!=1'h0)))
                begin
                    host_sram_response__ack <= 1'h1;
                    bbc_micro_host_sram_request__valid <= 1'h0;
                    if (!(bbc_micro_host_sram_request__read_enable!=1'h0))
                    begin
                        host_sram_pending <= 1'h0;
                    end //if
                end //if
                if ((bbc_micro_host_sram_response__read_data_valid!=1'h0))
                begin
                    host_sram_response__read_data_valid <= 1'h1;
                    host_sram_response__read_data <= bbc_micro_host_sram_response__read_data;
                    host_sram_pending <= 1'h0;
                end //if
            end //if
            if ((floppy_sram_reading_host!=1'h0))
            begin
                host_sram_response__read_data_valid <= 1'h1;
                host_sram_response__read_data <= {32'h0,floppy_sram_read_data};
            end //if
            if ((display_sram_reading_host!=1'h0))
            begin
                host_sram_response__read_data_valid <= 1'h1;
                host_sram_response__read_data <= display_sram_read_data;
            end //if
        end //if
    end //always

    //b sram_arbitration combinatorial process
        //   
        //       For speed of operation the SRAM arbiters or prioritized for the BBC micro
        //       accesses - host accesses are lower priority.
        //       
    always @ ( * )//sram_arbitration
    begin: sram_arbitration__comb_code
    reg [1:0]sram_grant_host_request__var;
    reg sram_grant_floppy__var;
    reg sram_grant_display_write__var;
        sram_grant_host_request__var = 2'h0;
        sram_grant_floppy__var = 1'h0;
        sram_grant_display_write__var = 1'h0;
        if ((pending_display_sram_write__enable!=1'h0))
        begin
            sram_grant_display_write__var = 1'h1;
        end //if
        if ((pending_floppy_sram_request__enable!=1'h0))
        begin
            sram_grant_floppy__var = 1'h1;
        end //if
        if (((pending_host_sram_request__valid!=1'h0)&&!(host_sram_pending!=1'h0)))
        begin
            if (((pending_host_sram_request__select==8'h1)&&!(sram_grant_display_write__var!=1'h0)))
            begin
                sram_grant_host_request__var = 2'h1;
            end //if
            if (((pending_host_sram_request__select==8'h2)&&!(sram_grant_floppy__var!=1'h0)))
            begin
                sram_grant_host_request__var = 2'h2;
            end //if
            if (((pending_host_sram_request__select & 8'h10)!=8'h0))
            begin
                sram_grant_host_request__var = 2'h3;
            end //if
        end //if
        sram_grant_host_request = sram_grant_host_request__var;
        sram_grant_floppy = sram_grant_floppy__var;
        sram_grant_display_write = sram_grant_display_write__var;
    end //always

    //b display_sram_logic__comb combinatorial process
        //   
        //       The display SRAM is 4bpp at a max resolution of (say) 1024x512, so 256kB max
        //       The memory is read/written at 64-bits per cycle, so 32kx64
        //       
    always @ ( * )//display_sram_logic__comb
    begin: display_sram_logic__comb_code
    reg display_sram__select__var;
    reg display_sram__read_not_write__var;
    reg display_sram__write_enable__var;
    reg [19:0]display_sram__address__var;
    reg [63:0]display_sram__write_data__var;
        display_sram__select__var = 1'h0;
        display_sram__read_not_write__var = 1'h0;
        display_sram__write_enable__var = 1'h1;
        display_sram__address__var = {4'h0,pending_display_sram_write__address[15:0]};
        display_sram__write_data__var = {16'h0,pending_display_sram_write__data[47:0]};
        if ((sram_grant_display_write!=1'h0))
        begin
            display_sram__select__var = 1'h1;
        end //if
        if ((sram_grant_host_request==2'h1))
        begin
            display_sram__select__var = 1'h1;
            display_sram__read_not_write__var = pending_host_sram_request__read_enable;
            display_sram__write_enable__var = pending_host_sram_request__write_enable;
            display_sram__address__var = pending_host_sram_request__address[19:0];
            display_sram__write_data__var = pending_host_sram_request__write_data;
        end //if
        display_sram__select = display_sram__select__var;
        display_sram__read_not_write = display_sram__read_not_write__var;
        display_sram__write_enable = display_sram__write_enable__var;
        display_sram__address = display_sram__address__var;
        display_sram__write_data = display_sram__write_data__var;
    end //always

    //b display_sram_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The display SRAM is 4bpp at a max resolution of (say) 1024x512, so 256kB max
        //       The memory is read/written at 64-bits per cycle, so 32kx64
        //       
    always @( posedge clk or negedge reset_n)
    begin : display_sram_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            display_sram_reading_host <= 1'h0;
        end
        else if (clk__enable)
        begin
            display_sram_reading_host <= 1'h0;
            if (((sram_grant_host_request==2'h1)&&(pending_host_sram_request__read_enable!=1'h0)))
            begin
                display_sram_reading_host <= 1'h1;
            end //if
        end //if
    end //always

    //b floppy_sram_logic__comb combinatorial process
        //   
        //       The floppy SRAM is 32 bits wide, and must accommodate at least 100kB plus IDs, so must be at least 128kB
        //       Hence it should be 32kx32, or larger
        //       
    always @ ( * )//floppy_sram_logic__comb
    begin: floppy_sram_logic__comb_code
    reg floppy_sram__select__var;
    reg floppy_sram__read_not_write__var;
    reg floppy_sram__write_enable__var;
    reg [19:0]floppy_sram__address__var;
    reg [63:0]floppy_sram__write_data__var;
        floppy_sram__select__var = 1'h0;
        floppy_sram__read_not_write__var = pending_floppy_sram_request__read_not_write;
        floppy_sram__write_enable__var = pending_host_sram_request__write_enable;
        floppy_sram__address__var = pending_floppy_sram_request__address[19:0];
        floppy_sram__write_data__var = {32'h0,pending_floppy_sram_request__write_data};
        if ((sram_grant_floppy!=1'h0))
        begin
            floppy_sram__select__var = 1'h1;
        end //if
        if ((sram_grant_host_request==2'h2))
        begin
            floppy_sram__select__var = 1'h1;
            floppy_sram__read_not_write__var = pending_host_sram_request__read_enable;
            floppy_sram__write_enable__var = pending_host_sram_request__write_enable;
            floppy_sram__address__var = pending_host_sram_request__address[19:0];
            floppy_sram__write_data__var = pending_host_sram_request__write_data;
        end //if
        floppy_sram__select = floppy_sram__select__var;
        floppy_sram__read_not_write = floppy_sram__read_not_write__var;
        floppy_sram__write_enable = floppy_sram__write_enable__var;
        floppy_sram__address = floppy_sram__address__var;
        floppy_sram__write_data = floppy_sram__write_data__var;
    end //always

    //b floppy_sram_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       The floppy SRAM is 32 bits wide, and must accommodate at least 100kB plus IDs, so must be at least 128kB
        //       Hence it should be 32kx32, or larger
        //       
    always @( posedge clk or negedge reset_n)
    begin : floppy_sram_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            sram_reading_floppy <= 1'h0;
            floppy_sram_reading_host <= 1'h0;
        end
        else if (clk__enable)
        begin
            sram_reading_floppy <= sram_grant_floppy;
            floppy_sram_reading_host <= 1'h0;
            if (((sram_grant_host_request==2'h2)&&(pending_host_sram_request__read_enable!=1'h0)))
            begin
                floppy_sram_reading_host <= 1'h1;
            end //if
        end //if
    end //always

endmodule // bbc_micro_rams
