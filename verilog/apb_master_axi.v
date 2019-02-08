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

//a Module apb_master_axi
    //   
    //   AXI target mapping to an APB master
    //   
    //   This is a very simple AXI target that handles a single AXI transaction
    //   at any one time; it converts this into an APB read or write
    //   transaction, whose completion allows the completion of the AXI
    //   transaction.
    //   
    //   This module is currently very primitive, and does not checking of
    //   transaction input really.
    //   
module apb_master_axi
(
    aclk,
    aclk__enable,

    apb_response__prdata,
    apb_response__pready,
    apb_response__perr,
    rready,
    bready,
    w__valid,
    w__id,
    w__data,
    w__strb,
    w__last,
    w__user,
    aw__valid,
    aw__id,
    aw__addr,
    aw__len,
    aw__size,
    aw__burst,
    aw__lock,
    aw__cache,
    aw__prot,
    aw__qos,
    aw__region,
    aw__user,
    ar__valid,
    ar__id,
    ar__addr,
    ar__len,
    ar__size,
    ar__burst,
    ar__lock,
    ar__cache,
    ar__prot,
    ar__qos,
    ar__region,
    ar__user,
    areset_n,

    apb_request__paddr,
    apb_request__penable,
    apb_request__psel,
    apb_request__pwrite,
    apb_request__pwdata,
    r__valid,
    r__id,
    r__data,
    r__resp,
    r__last,
    r__user,
    b__valid,
    b__id,
    b__resp,
    b__user,
    wready,
    arready,
    awready
);

    //b Clocks
    input aclk;
    input aclk__enable;

    //b Inputs
    input [31:0]apb_response__prdata;
    input apb_response__pready;
    input apb_response__perr;
    input rready;
    input bready;
    input w__valid;
    input [11:0]w__id;
    input [31:0]w__data;
    input [3:0]w__strb;
    input w__last;
    input [3:0]w__user;
    input aw__valid;
    input [11:0]aw__id;
    input [31:0]aw__addr;
    input [3:0]aw__len;
    input [2:0]aw__size;
    input [1:0]aw__burst;
    input [1:0]aw__lock;
    input [3:0]aw__cache;
    input [2:0]aw__prot;
    input [3:0]aw__qos;
    input [3:0]aw__region;
    input [3:0]aw__user;
    input ar__valid;
    input [11:0]ar__id;
    input [31:0]ar__addr;
    input [3:0]ar__len;
    input [2:0]ar__size;
    input [1:0]ar__burst;
    input [1:0]ar__lock;
    input [3:0]ar__cache;
    input [2:0]ar__prot;
    input [3:0]ar__qos;
    input [3:0]ar__region;
    input [3:0]ar__user;
    input areset_n;

    //b Outputs
    output [31:0]apb_request__paddr;
    output apb_request__penable;
    output apb_request__psel;
    output apb_request__pwrite;
    output [31:0]apb_request__pwdata;
    output r__valid;
    output [11:0]r__id;
    output [31:0]r__data;
    output [1:0]r__resp;
    output r__last;
    output [3:0]r__user;
    output b__valid;
    output [11:0]b__id;
    output [1:0]b__resp;
    output [3:0]b__user;
    output wready;
    output arready;
    output awready;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
        //   Asserted if an APB access is in progress
    reg apb_access_in_progress;
        //   State of the AXI read side
    reg [1:0]axi_rd_state__state;
    reg axi_rd_state__errored;
    reg [11:0]axi_rd_state__id;
    reg [31:0]axi_rd_state__address;
        //   State of the AXI write side
    reg [2:0]axi_wr_state__state;
    reg axi_wr_state__errored;
    reg [11:0]axi_wr_state__id;
    reg [31:0]axi_wr_state__address;
    reg [31:0]axi_wr_state__data;
    reg [31:0]apb_request__paddr;
    reg apb_request__penable;
    reg apb_request__psel;
    reg apb_request__pwrite;
    reg [31:0]apb_request__pwdata;
    reg r__valid;
    reg [11:0]r__id;
    reg [31:0]r__data;
    reg [1:0]r__resp;
    reg r__last;
    reg [3:0]r__user;
    reg b__valid;
    reg [11:0]b__id;
    reg [1:0]b__resp;
    reg [3:0]b__user;
    reg wready;
    reg arready;
    reg awready;

    //b Internal combinatorials
        //   Asserted if an APB access is completing (psel & penable & pready)
    reg apb_access_completing;
        //   Asserted if an APB write access should start
    reg apb_access_start_write;
        //   Asserted if an APB read access should start
    reg apb_access_start_read;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b axi_logic__comb combinatorial process
        //   
        //       The AXI-side logic has two state machines: one handles AXI write
        //       requests, the other AXI read requests.
        //   
        //       A write request must be paired with write data, and this permits
        //       the state machine to then generate a request to the APB side to
        //       perform an APB write transaction; when that completes, the AXI
        //       write response can be returned.
        //   
        //       A read request permits the state machine to generate a request to
        //       the APB side to perform an APB read transaction; when that
        //       completes, the AXI read response can be returned.
        //   
        //   
        //       
    always @ ( * )//axi_logic__comb
    begin: axi_logic__comb_code
    reg apb_access_start_read__var;
    reg apb_access_start_write__var;
        apb_access_start_read__var = 1'h0;
        apb_access_start_write__var = 1'h0;
        case (axi_wr_state__state) //synopsys parallel_case
        3'h0: // req 1
            begin
            end
        3'h1: // req 1
            begin
            end
        3'h2: // req 1
            begin
            if (!(apb_access_in_progress!=1'h0))
            begin
                apb_access_start_write__var = 1'h1;
            end //if
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
                    $display("%t *********CDL ASSERTION FAILURE:apb_master_axi:axi_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        case (axi_rd_state__state) //synopsys parallel_case
        2'h0: // req 1
            begin
            end
        2'h1: // req 1
            begin
            if ((axi_wr_state__state==3'h0))
            begin
                apb_access_start_read__var = 1'h1;
            end //if
            end
        2'h2: // req 1
            begin
            end
        2'h3: // req 1
            begin
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:apb_master_axi:axi_logic: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        apb_access_start_read = apb_access_start_read__var;
        apb_access_start_write = apb_access_start_write__var;
    end //always

    //b axi_logic__posedge_aclk_active_low_areset_n clock process
        //   
        //       The AXI-side logic has two state machines: one handles AXI write
        //       requests, the other AXI read requests.
        //   
        //       A write request must be paired with write data, and this permits
        //       the state machine to then generate a request to the APB side to
        //       perform an APB write transaction; when that completes, the AXI
        //       write response can be returned.
        //   
        //       A read request permits the state machine to generate a request to
        //       the APB side to perform an APB read transaction; when that
        //       completes, the AXI read response can be returned.
        //   
        //   
        //       
    always @( posedge aclk or negedge areset_n)
    begin : axi_logic__posedge_aclk_active_low_areset_n__code
        if (areset_n==1'b0)
        begin
            arready <= 1'h0;
            wready <= 1'h0;
            awready <= 1'h0;
            axi_wr_state__state <= 3'h0;
            axi_wr_state__errored <= 1'h0;
            axi_wr_state__id <= 12'h0;
            axi_wr_state__address <= 32'h0;
            axi_wr_state__data <= 32'h0;
            b__valid <= 1'h0;
            b__id <= 12'h0;
            b__resp <= 2'h0;
            b__user <= 4'h0;
            axi_rd_state__state <= 2'h0;
            axi_rd_state__errored <= 1'h0;
            axi_rd_state__id <= 12'h0;
            axi_rd_state__address <= 32'h0;
            r__valid <= 1'h0;
            r__id <= 12'h0;
            r__data <= 32'h0;
            r__resp <= 2'h0;
            r__last <= 1'h0;
            r__user <= 4'h0;
        end
        else if (aclk__enable)
        begin
            arready <= 1'h0;
            wready <= 1'h0;
            case (axi_wr_state__state) //synopsys parallel_case
            3'h0: // req 1
                begin
                if ((aw__valid!=1'h0))
                begin
                    awready <= 1'h1;
                    wready <= 1'h1;
                    axi_wr_state__state <= 3'h1;
                    axi_wr_state__errored <= 1'h0;
                    axi_wr_state__id <= aw__id;
                    axi_wr_state__address <= aw__addr[31:0];
                end //if
                end
            3'h1: // req 1
                begin
                wready <= 1'h1;
                if ((w__valid!=1'h0))
                begin
                    if (!(w__last!=1'h0))
                    begin
                        axi_wr_state__errored <= 1'h1;
                    end //if
                    if ((w__last!=1'h0))
                    begin
                        wready <= 1'h0;
                        axi_wr_state__state <= 3'h2;
                        axi_wr_state__data <= w__data[31:0];
                    end //if
                end //if
                end
            3'h2: // req 1
                begin
                if (!(apb_access_in_progress!=1'h0))
                begin
                    axi_wr_state__state <= 3'h3;
                end //if
                end
            3'h3: // req 1
                begin
                if ((apb_access_completing!=1'h0))
                begin
                    axi_wr_state__state <= 3'h4;
                    b__valid <= 1'h0;
                    b__id <= 12'h0;
                    b__resp <= 2'h0;
                    b__user <= 4'h0;
                    b__valid <= 1'h1;
                    b__id <= axi_wr_state__id;
                    b__resp <= 2'h0;
                end //if
                end
            3'h4: // req 1
                begin
                b__valid <= 1'h1;
                if ((bready!=1'h0))
                begin
                    b__valid <= 1'h0;
                    axi_wr_state__state <= 3'h0;
                end //if
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:apb_master_axi:axi_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            case (axi_rd_state__state) //synopsys parallel_case
            2'h0: // req 1
                begin
                if ((ar__valid!=1'h0))
                begin
                    arready <= 1'h1;
                    axi_rd_state__state <= 2'h1;
                    axi_rd_state__errored <= 1'h0;
                    axi_rd_state__id <= ar__id;
                    axi_rd_state__address <= ar__addr[31:0];
                end //if
                end
            2'h1: // req 1
                begin
                if ((axi_wr_state__state==3'h0))
                begin
                    axi_rd_state__state <= 2'h2;
                end //if
                end
            2'h2: // req 1
                begin
                if ((apb_access_completing!=1'h0))
                begin
                    axi_rd_state__state <= 2'h3;
                    r__valid <= 1'h0;
                    r__id <= 12'h0;
                    r__data <= 32'h0;
                    r__resp <= 2'h0;
                    r__last <= 1'h0;
                    r__user <= 4'h0;
                    r__valid <= 1'h1;
                    r__id <= axi_rd_state__id;
                    r__resp <= 2'h0;
                    r__data <= apb_response__prdata;
                    r__last <= 1'h1;
                end //if
                end
            2'h3: // req 1
                begin
                r__valid <= 1'h1;
                if ((rready!=1'h0))
                begin
                    r__valid <= 1'h0;
                    axi_rd_state__state <= 2'h0;
                end //if
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:apb_master_axi:axi_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
        end //if
    end //always

    //b apb_access_logic__comb combinatorial process
        //   
        //       An APB access starts with a valid request detected, which drives
        //       out the APB controls with @p psel high, @p penable low.
        //   
        //       If @p psel is high and @p penable is low then an access must have
        //       started, and the next clock tick _must_ have penable high.
        //   
        //       If @p psel is high and @p penable is high then the access will continue
        //       if @p pready is low, but it will complete (with valid read data, if a
        //       read) if @p pready is high.
        //       
    always @ ( * )//apb_access_logic__comb
    begin: apb_access_logic__comb_code
    reg apb_access_completing__var;
        apb_access_completing__var = 1'h0;
        if ((apb_request__psel!=1'h0))
        begin
            if (!(apb_request__penable!=1'h0))
            begin
            end //if
            else
            
            begin
                if ((apb_response__pready!=1'h0))
                begin
                    apb_access_completing__var = 1'h1;
                end //if
            end //else
        end //if
        apb_access_completing = apb_access_completing__var;
    end //always

    //b apb_access_logic__posedge_aclk_active_low_areset_n clock process
        //   
        //       An APB access starts with a valid request detected, which drives
        //       out the APB controls with @p psel high, @p penable low.
        //   
        //       If @p psel is high and @p penable is low then an access must have
        //       started, and the next clock tick _must_ have penable high.
        //   
        //       If @p psel is high and @p penable is high then the access will continue
        //       if @p pready is low, but it will complete (with valid read data, if a
        //       read) if @p pready is high.
        //       
    always @( posedge aclk or negedge areset_n)
    begin : apb_access_logic__posedge_aclk_active_low_areset_n__code
        if (areset_n==1'b0)
        begin
            apb_access_in_progress <= 1'h0;
            apb_request__psel <= 1'h0;
            apb_request__pwrite <= 1'h0;
            apb_request__paddr <= 32'h0;
            apb_request__pwdata <= 32'h0;
            apb_request__penable <= 1'h0;
        end
        else if (aclk__enable)
        begin
            if (((apb_access_start_read!=1'h0)||(apb_access_start_write!=1'h0)))
            begin
                apb_access_in_progress <= 1'h1;
                if ((apb_access_start_write!=1'h0))
                begin
                    apb_request__psel <= 1'h1;
                    apb_request__pwrite <= 1'h1;
                    apb_request__paddr <= axi_wr_state__address;
                    apb_request__pwdata <= axi_wr_state__data;
                end //if
                else
                
                begin
                    apb_request__psel <= 1'h1;
                    apb_request__pwrite <= 1'h0;
                    apb_request__paddr <= axi_rd_state__address;
                end //else
            end //if
            if ((apb_request__psel!=1'h0))
            begin
                if (!(apb_request__penable!=1'h0))
                begin
                    apb_request__penable <= 1'h1;
                end //if
                else
                
                begin
                    if ((apb_response__pready!=1'h0))
                    begin
                        apb_request__penable <= 1'h0;
                        apb_request__psel <= 1'h0;
                        apb_access_in_progress <= 1'h0;
                    end //if
                end //else
            end //if
        end //if
    end //always

endmodule // apb_master_axi
