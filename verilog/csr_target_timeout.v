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

//a Module csr_target_timeout
    //   
    //   This module provides a CSR target interface which never directly
    //   responds to a request, but which will complete a read or write if the
    //   request stays for a specified period of time.
    //   
    //   This permits any transaction to be attempted by a CSR interface
    //   master, even if no target decodes the transaction. Such transactions
    //   will be handled by this module.
    //   
module csr_target_timeout
(
    clk,
    clk__enable,

    csr_timeout,
    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    reset_n,

    csr_response__acknowledge,
    csr_response__read_data_valid,
    csr_response__read_data_error,
    csr_response__read_data
);

    //b Clocks
        //   Clock for the CSR interface, possibly gated version of master CSR clock
    input clk;
    input clk__enable;

    //b Inputs
        //   Number of cycles to wait for until auto-acknowledging a request
    input [15:0]csr_timeout;
        //   Pipelined csr request interface input
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Pipelined csr request interface response
    output csr_response__acknowledge;
    output csr_response__read_data_valid;
    output csr_response__read_data_error;
    output [31:0]csr_response__read_data;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
        //   Asserted if a CSR request is in progress
    reg csr_request_in_progress;
        //   Timeout counter, set to csr_timeout on a valid CSR request, and generating a response on timeout
    reg [15:0]timeout_counter;
    reg csr_response__acknowledge;
    reg csr_response__read_data_valid;
    reg csr_response__read_data_error;
    reg [31:0]csr_response__read_data;

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b csr_interface_logic clock process
        //   
        //       This target detects any valid CSR request, and when it starts it
        //       sets the @a timeout_counter.  While the request is still present
        //       the @a timeout_counter decrements, until it is about to expire. At
        //       this point the module claims the CSR request by driving the @a
        //       csr_response.acknowledge signal back.
        //   
        //       Since no transaction is really taking place, the steps thereafter
        //       are automatic; @a acknowledge is removed after one cycle, and if the
        //       request had been a read then valid read data of 0 is returned in
        //       the following cycle too.
        //       
    always @( posedge clk or negedge reset_n)
    begin : csr_interface_logic__code
        if (reset_n==1'b0)
        begin
            csr_response__read_data <= 32'h0;
            csr_response__read_data_valid <= 1'h0;
            csr_response__read_data_error <= 1'h0;
            csr_response__acknowledge <= 1'h0;
            timeout_counter <= 16'h0;
            csr_request_in_progress <= 1'h0;
        end
        else if (clk__enable)
        begin
            csr_response__read_data <= 32'h0;
            if ((csr_response__read_data_valid!=1'h0))
            begin
                csr_response__read_data_valid <= 1'h0;
                csr_response__read_data_error <= 1'h0;
            end //if
            if ((csr_response__acknowledge!=1'h0))
            begin
                csr_response__acknowledge <= 1'h0;
                if ((csr_request__read_not_write!=1'h0))
                begin
                    csr_response__read_data_valid <= 1'h1;
                    csr_response__read_data_error <= 1'h1;
                end //if
            end //if
            if ((csr_request_in_progress!=1'h0))
            begin
                timeout_counter <= (timeout_counter-16'h1);
                if ((timeout_counter==16'h0))
                begin
                    timeout_counter <= 16'h0;
                end //if
                if ((timeout_counter==16'h1))
                begin
                    csr_response__acknowledge <= 1'h1;
                end //if
                if (!(csr_request__valid!=1'h0))
                begin
                    csr_request_in_progress <= 1'h0;
                end //if
            end //if
            else
            
            begin
                if ((csr_request__valid!=1'h0))
                begin
                    csr_request_in_progress <= 1'h1;
                    timeout_counter <= csr_timeout;
                end //if
            end //else
        end //if
    end //always

endmodule // csr_target_timeout
