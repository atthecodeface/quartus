//a Note: created by CDL 1.4 - do not hand edit without recognizing it will be out of sync with the source
// Output mode 0 (VMOD=1, standard verilog=0)
// Verilog option comb reg suffix '__var'
// Verilog option include_displays 0
// Verilog option include_assertions 1
// Verilog option sv_assertions 0
// Verilog option assert delay string '<NULL>'
// Verilog option include_coverage 0
// Verilog option clock_gate_module_instance_type 'clock_gate_module'
// Verilog option clock_gate_module_instance_extra_ports ''

//a Module bbc_csr_interface
module bbc_csr_interface
(
    clk,

    csr_select,
    csr_read_data,
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
    csr_response__ack,
    csr_response__read_data_valid,
    csr_response__read_data
);

    //b Clocks
        //   4MHz clock in as a minimum
    input clk;

    //b Inputs
    input [15:0]csr_select;
    input [31:0]csr_read_data;
    input csr_request__valid;
    input csr_request__read_not_write;
    input [15:0]csr_request__select;
    input [15:0]csr_request__address;
    input [31:0]csr_request__data;
    input reset_n;

    //b Outputs
    output csr_access__valid;
    output csr_access__read_not_write;
    output [15:0]csr_access__address;
    output [31:0]csr_access__data;
    output csr_response__ack;
    output csr_response__read_data_valid;
    output [31:0]csr_response__read_data;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
    reg last_csr_request_valid;
    reg csr_access__valid;
    reg csr_access__read_not_write;
    reg [15:0]csr_access__address;
    reg [31:0]csr_access__data;
    reg csr_response__ack;
    reg csr_response__read_data_valid;
    reg [31:0]csr_response__read_data;

    //b Internal combinatorials

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b access clock process
        //   
        //       
    always @( posedge clk or negedge reset_n)
    begin : access__code
        if (reset_n==1'b0)
        begin
            csr_response__read_data_valid <= 1'h0;
            csr_response__read_data <= 32'h0;
            csr_access__valid <= 1'h0;
            csr_response__ack <= 1'h0;
            last_csr_request_valid <= 1'h0;
            csr_access__read_not_write <= 1'h0;
            csr_access__address <= 16'h0;
            csr_access__data <= 32'h0;
        end
        else
        begin
            if ((csr_response__read_data_valid!=1'h0))
            begin
                csr_response__read_data_valid <= 1'h0;
                csr_response__read_data <= 32'h0;
            end //if
            if ((csr_access__valid!=1'h0))
            begin
                csr_access__valid <= 1'h0;
                csr_response__ack <= 1'h0;
                if ((csr_access__read_not_write!=1'h0))
                begin
                    csr_response__read_data_valid <= 1'h1;
                    csr_response__read_data <= csr_read_data;
                end //if
            end //if
            if ((!(csr_request__valid!=1'h0)&&(last_csr_request_valid!=1'h0)))
            begin
                last_csr_request_valid <= 1'h0;
            end //if
            if (((csr_request__valid!=1'h0)&&!(last_csr_request_valid!=1'h0)))
            begin
                last_csr_request_valid <= 1'h1;
                if ((csr_request__select==csr_select))
                begin
                    csr_access__valid <= 1'h1;
                    csr_access__read_not_write <= csr_request__read_not_write;
                    csr_access__address <= csr_request__address;
                    csr_access__data <= csr_request__data;
                    csr_response__ack <= 1'h1;
                end //if
            end //if
        end //if
    end //always

endmodule // bbc_csr_interface
