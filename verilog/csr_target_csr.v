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

//a Module csr_target_csr
    //   
    //   This CSR interface is designed to provide a simple CSR access (select,
    //   read/write, address, data) to a client from a pipelined request from a
    //   master.
    //   
    //   The initial design motiviation was to permit a pipelined CSR access
    //   from a master to a number of targets, to run off a single fast clock
    //   in an FPGA. This requires registering the read data in response to
    //   access requests, and registering the request to the targets; the
    //   simplest variant being a fixed latency master-to-target and a fixed
    //   latency target-to-master. The current design uses a
    //   valid/acknowledgement system to replace the fixed latency.
    //   
    //   A valid request is received, and if it matches the @a csr_select field
    //   then the request is acknowledged. Since the master is a fair distance
    //   away, and the @a valid signal will not be removed until an @a ack is seen,
    //   the handshake is effectively: valid low, ack low; valid high, ack low;
    //   valid high, ack high; valid high, ack low; valid low, ack low.
    //   
    //   Hence a valid request starts with valid high in, and ack out low. If
    //   this matches the select, then this interface responds with a single
    //   cycle of ack high, and the CSR access is performed.
    //   
    //   The clock for the client must be based on the same clock as the
    //   master. However, it may be a derived clock - in which case the ack
    //   will appear to the master to be more than one clock cycle long. The
    //   master must manage this, by removing valid when it sees the ack, and
    //   waiting until it sees ack is low before starting another transaction.
    //   
    //   Read transactions have a further stage, though, compared to writes. A
    //   read transaction will follow an 'ack' with a 'read_data_valid' cycle;
    //   if a master performs a read then the handshake will be: valid low, ack
    //   low; valid high, ack low; valid high, ack high (one target cycle);
    //   valid high, ack low, read_data_valid high (one target cycle); valid
    //   low, ack low.
    //   
    //   In this case the master must again wait until it sees read_data_valid
    //   high and then low before starting a new transaction, to allow the
    //   target to use a derived clock.
    //   
    //   
module csr_target_csr
(
    clk,
    clk__enable,

    csr_select,
    csr_access_data,
    csr_request__valid,
    csr_request__read_not_write,
    csr_request__select,
    csr_request__address,
    csr_request__data,
    reset_n,

    csr_access__valid,
    csr_access__read_not_write,
    csr_access__address,
    csr_access__data,
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
        //   Hard-wired select value for the client
    input [15:0]csr_select;
        //   Read data valid combinatorially based on csr_access
    input [31:0]csr_access_data;
        //   Pipelined csr request interface input
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Registered CSR access request to client
    output csr_access__valid;
    output csr_access__read_not_write;
    output [15:0]csr_access__address;
    output [31:0]csr_access__data;
        //   Pipelined csr request interface response
    output csr_response__acknowledge;
    output csr_response__read_data_valid;
    output csr_response__read_data_error;
    output [31:0]csr_response__read_data;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
        //   Asserted if a CSR access is in progress
    reg csr_request_in_progress;
    reg csr_access__valid;
    reg csr_access__read_not_write;
    reg [15:0]csr_access__address;
    reg [31:0]csr_access__data;
    reg csr_response__acknowledge;
    reg csr_response__read_data_valid;
    reg csr_response__read_data_error;
    reg [31:0]csr_response__read_data;

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b access_logic clock process
        //   
        //       If a CSR read transaction is completing (@p read_data_valid is
        //       asserted), then that indication can be cleared, and the @p
        //       read_data must be zeroed (to permit a wired-or bus upstream).
        //   
        //       If a CSR access is in progress (should be exclusive to the read
        //       transaction completing), then remove the upstream @a ack and
        //       remove the downstream @a csr_access; if it is a read, then drive
        //       the read data valid upstream.
        //   
        //       If a CSR request is being handled (i.e. the @p csr_request.valid
        //       was asserted and targeted at this CSR target), and the @p
        //       csr_request.valid has been taken away (presumably in response to
        //       the upstream @p ack being asserted by this module) then the CSR
        //       access has completed as far as this module is concerned, so kill
        //       @a csr_request_in_progress.
        //   
        //       Finally, if a request does come in (which should be exclusive to
        //       all the previous cases) and it targets this CSR target - as
        //       determined by the @p csr_select field matching - then start the
        //       CSR access downstream, and acknowledge the request upstream.
        //       
    always @( posedge clk or negedge reset_n)
    begin : access_logic__code
        if (reset_n==1'b0)
        begin
            csr_response__read_data_valid <= 1'h0;
            csr_response__read_data <= 32'h0;
            csr_access__valid <= 1'h0;
            csr_response__acknowledge <= 1'h0;
            csr_response__read_data_error <= 1'h0;
            csr_request_in_progress <= 1'h0;
            csr_access__read_not_write <= 1'h0;
            csr_access__address <= 16'h0;
            csr_access__data <= 32'h0;
        end
        else if (clk__enable)
        begin
            if ((csr_response__read_data_valid!=1'h0))
            begin
                csr_response__read_data_valid <= 1'h0;
                csr_response__read_data <= 32'h0;
            end //if
            if ((csr_access__valid!=1'h0))
            begin
                csr_access__valid <= 1'h0;
                csr_response__acknowledge <= 1'h0;
                if ((csr_access__read_not_write!=1'h0))
                begin
                    csr_response__read_data_valid <= 1'h1;
                    csr_response__read_data <= csr_access_data;
                    csr_response__read_data_error <= 1'h0;
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
                    csr_request_in_progress <= 1'h1;
                    if ((csr_request__select==csr_select))
                    begin
                        csr_access__valid <= 1'h1;
                        csr_access__read_not_write <= csr_request__read_not_write;
                        csr_access__address <= csr_request__address;
                        csr_access__data <= csr_request__data;
                        csr_response__acknowledge <= 1'h1;
                    end //if
                end //if
            end //else
        end //if
    end //always

endmodule // csr_target_csr
