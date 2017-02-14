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

//a Module csr_target_apb
    //   
    //   The documentation of the CSR interface itself is in other files (at
    //   this time, csr_target_csr.cdl).
    //   
    //   This module provides a CSR target interface to an APB master, hence
    //   providing the ability to connect an APB slave to the CSR bus.
    //   
module csr_target_apb
(
    clk,
    clk__enable,

    csr_select,
    apb_response__prdata,
    apb_response__pready,
    apb_response__perr,
    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    reset_n,

    apb_request__paddr,
    apb_request__penable,
    apb_request__psel,
    apb_request__pwrite,
    apb_request__pwdata,
    csr_response__ack,
    csr_response__read_data_valid,
    csr_response__read_data
);

    //b Clocks
        //   Clock for the CSR interface, possibly gated version of master CSR clock
    input clk;
    input clk__enable;

    //b Inputs
        //   Hard-wired select value for the client
    input [15:0]csr_select;
        //   APB response from target
    input [31:0]apb_response__prdata;
    input apb_response__pready;
    input apb_response__perr;
        //   Pipelined csr request interface input
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
    input reset_n;

    //b Outputs
        //   APB request to target
    output [31:0]apb_request__paddr;
    output apb_request__penable;
    output apb_request__psel;
    output apb_request__pwrite;
    output [31:0]apb_request__pwdata;
        //   Pipelined csr request interface response
    output csr_response__ack;
    output csr_response__read_data_valid;
    output [31:0]csr_response__read_data;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg csr_request_in_progress;
    reg [31:0]apb_request__paddr;
    reg apb_request__penable;
    reg apb_request__psel;
    reg apb_request__pwrite;
    reg [31:0]apb_request__pwdata;
    reg csr_response__ack;
    reg csr_response__read_data_valid;
    reg [31:0]csr_response__read_data;

    //b Internal combinatorials
        //   Asserted if an APB access is completing (psel & penable & pready)
    reg apb_access_completing;
        //   Asserted if an APB access should start
    reg apb_access_start;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b csr_interface_logic__comb combinatorial process
        //   
        //       This target detects access to this selected CSR target, and
        //       asserts ack at this point. It only removes ack when the APB
        //       request completes - since an APB target may insert wait states
        //       into writes.
        //   
        //       This will hold the master from performing another transaction;
        //       this may slow down the bus, but it ensures that back-to-back
        //       writes to this target can be handled correctly even if the APB
        //       target inserts wait states.
        //       
    always @ ( * )//csr_interface_logic__comb
    begin: csr_interface_logic__comb_code
    reg apb_access_start__var;
        apb_access_start__var = 1'h0;
        if ((csr_request_in_progress!=1'h0))
        begin
        end //if
        else
        
        begin
            if ((csr_request__valid!=1'h0))
            begin
                if ((csr_request__select==csr_select))
                begin
                    apb_access_start__var = 1'h1;
                end //if
            end //if
        end //else
        apb_access_start = apb_access_start__var;
    end //always

    //b csr_interface_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       This target detects access to this selected CSR target, and
        //       asserts ack at this point. It only removes ack when the APB
        //       request completes - since an APB target may insert wait states
        //       into writes.
        //   
        //       This will hold the master from performing another transaction;
        //       this may slow down the bus, but it ensures that back-to-back
        //       writes to this target can be handled correctly even if the APB
        //       target inserts wait states.
        //       
    always @( posedge clk or negedge reset_n)
    begin : csr_interface_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            csr_response__read_data_valid <= 1'h0;
            csr_response__read_data <= 32'h0;
            csr_response__ack <= 1'h0;
            csr_request_in_progress <= 1'h0;
        end
        else if (clk__enable)
        begin
            if ((csr_response__read_data_valid!=1'h0))
            begin
                csr_response__read_data_valid <= 1'h0;
                csr_response__read_data <= 32'h0;
            end //if
            if ((apb_access_completing!=1'h0))
            begin
                csr_response__ack <= 1'h0;
                if (!(apb_request__pwrite!=1'h0))
                begin
                    csr_response__read_data_valid <= 1'h1;
                    csr_response__read_data <= apb_response__prdata;
                end //if
            end //if
            if ((csr_request_in_progress!=1'h0))
            begin
                if (!(csr_request__valid!=1'h0))
                begin
                    csr_request_in_progress <= 1'h0;
                end //if
            end //if
            else
            
            begin
                if ((csr_request__valid!=1'h0))
                begin
                    if ((csr_request__select==csr_select))
                    begin
                        csr_response__ack <= 1'h1;
                        csr_request_in_progress <= 1'h1;
                    end //if
                end //if
            end //else
        end //if
    end //always

    //b apb_access_logic__comb combinatorial process
        //   
        //       An APB access starts with a valid request detected, which drives
        //       out the APB controls with psel high, penable low.
        //   
        //       If psel is high and penable is low then an access must have
        //       started, and the next clock tick _must_ have penable high.
        //   
        //       If psel is high and penable is high then the access will continue
        //       if pready is low, but it will complete (with valid read data, if a
        //       read) if pready is high.
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

    //b apb_access_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       An APB access starts with a valid request detected, which drives
        //       out the APB controls with psel high, penable low.
        //   
        //       If psel is high and penable is low then an access must have
        //       started, and the next clock tick _must_ have penable high.
        //   
        //       If psel is high and penable is high then the access will continue
        //       if pready is low, but it will complete (with valid read data, if a
        //       read) if pready is high.
        //       
    always @( posedge clk or negedge reset_n)
    begin : apb_access_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            apb_request__psel <= 1'h0;
            apb_request__pwrite <= 1'h0;
            apb_request__paddr <= 32'h0;
            apb_request__pwdata <= 32'h0;
            apb_request__penable <= 1'h0;
        end
        else if (clk__enable)
        begin
            if ((apb_access_start!=1'h0))
            begin
                apb_request__psel <= 1'h1;
                apb_request__pwrite <= !(csr_request__read_not_write!=1'h0);
                apb_request__paddr <= {16'h0,csr_request__address};
                apb_request__pwdata <= csr_request__data;
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
                    end //if
                end //else
            end //if
        end //if
    end //always

endmodule // csr_target_apb
