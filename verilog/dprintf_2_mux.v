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

//a Module dprintf_2_mux
    //   
    //   Generic multiplexer for two identical requesters (with a valid signal
    //   each), to arbitrate for an output request, with a response with an
    //   'ack' signal.
    //   
    //   This module may be used with a different type (using type remapping)
    //   to generate a specific multiplexer for two validated requests, which
    //   have just an ack in response (e.g. the teletext dprintf requests).
    //   
    //   The module registers its output request; it remembers which requester
    //   it consumed from last, and will preferentially consue from the other
    //   port next - hence supplying some degree of fairness.
    //   
    //   When its output is not valid, or is being acknowledged, it may take a
    //   new request from one of the two requesting masters, using the desired
    //   priority. It will also then acknowledge that requester.
    //   
    //   If its output is valid and is not acknowledged, then it will not
    //   consumer another request.
    //   
module dprintf_2_mux
(
    clk,
    clk__enable,

    ack,
    req_b__valid,
    req_b__address,
    req_b__data_0,
    req_b__data_1,
    req_a__valid,
    req_a__address,
    req_a__data_0,
    req_a__data_1,
    reset_n,

    req__valid,
    req__address,
    req__data_0,
    req__data_1,
    ack_b,
    ack_a
);

    //b Clocks
        //   Clock for logic
    input clk;
    input clk__enable;

    //b Inputs
        //   Acknowledge from downstream
    input ack;
        //   Request from upstream 'B' port, which must have a @p valid bit
    input req_b__valid;
    input [15:0]req_b__address;
    input [63:0]req_b__data_0;
    input [63:0]req_b__data_1;
        //   Request from upstream 'A' port, which must have a @p valid bit
    input req_a__valid;
    input [15:0]req_a__address;
    input [63:0]req_a__data_0;
    input [63:0]req_a__data_1;
        //   Active low reset
    input reset_n;

    //b Outputs
        //   Request out downstream, which must have a @p valid bit
    output req__valid;
    output [15:0]req__address;
    output [63:0]req__data_0;
    output [63:0]req__data_1;
        //   Acknowledge to upstream 'B' port
    output ack_b;
        //   Acknowledge to upstream 'A' port
    output ack_a;

// output components here

    //b Output combinatorials

    //b Output nets

    //b Internal and output registers
        //   Arbiter state - which port was last consumed
    reg arbiter_state__last_request_from_port_a;
    reg req__valid;
    reg [15:0]req__address;
    reg [63:0]req__data_0;
    reg [63:0]req__data_1;
    reg ack_b;
    reg ack_a;

    //b Internal combinatorials
        //   Combinatorial decode of acks and requests
    reg arbiter_combs__new_request_permitted;
    reg arbiter_combs__take_req_a;
    reg arbiter_combs__take_req_b;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b arbiter_logic__comb combinatorial process
        //   
        //       First determine if a new request may be presented.
        //       If it may, then chose one of the incoming requests, if either is valid.
        //   
        //       Maintain a record of the last requester that was granted, for fairness.
        //       
    always @ ( * )//arbiter_logic__comb
    begin: arbiter_logic__comb_code
    reg arbiter_combs__new_request_permitted__var;
    reg arbiter_combs__take_req_a__var;
    reg arbiter_combs__take_req_b__var;
        arbiter_combs__new_request_permitted__var = 1'h0;
        if ((!(req__valid!=1'h0)||(ack!=1'h0)))
        begin
            arbiter_combs__new_request_permitted__var = 1'h1;
        end //if
        arbiter_combs__take_req_a__var = 1'h0;
        arbiter_combs__take_req_b__var = 1'h0;
        if ((arbiter_combs__new_request_permitted__var!=1'h0))
        begin
            if ((((req_a__valid!=1'h0)&&!(ack_a!=1'h0))&&((req_b__valid!=1'h0)&&!(ack_b!=1'h0))))
            begin
                arbiter_combs__take_req_a__var = !(arbiter_state__last_request_from_port_a!=1'h0);
                arbiter_combs__take_req_b__var = arbiter_state__last_request_from_port_a;
            end //if
            else
            
            begin
                arbiter_combs__take_req_a__var = ((req_a__valid!=1'h0)&&!(ack_a!=1'h0));
                arbiter_combs__take_req_b__var = ((req_b__valid!=1'h0)&&!(ack_b!=1'h0));
            end //else
        end //if
        arbiter_combs__new_request_permitted = arbiter_combs__new_request_permitted__var;
        arbiter_combs__take_req_a = arbiter_combs__take_req_a__var;
        arbiter_combs__take_req_b = arbiter_combs__take_req_b__var;
    end //always

    //b arbiter_logic__posedge_clk_active_low_reset_n clock process
        //   
        //       First determine if a new request may be presented.
        //       If it may, then chose one of the incoming requests, if either is valid.
        //   
        //       Maintain a record of the last requester that was granted, for fairness.
        //       
    always @( posedge clk or negedge reset_n)
    begin : arbiter_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            arbiter_state__last_request_from_port_a <= 1'h0;
        end
        else if (clk__enable)
        begin
            if ((arbiter_combs__take_req_a!=1'h0))
            begin
                arbiter_state__last_request_from_port_a <= 1'h1;
            end //if
            else
            
            begin
                if ((arbiter_combs__take_req_b!=1'h0))
                begin
                    arbiter_state__last_request_from_port_a <= 1'h0;
                end //if
            end //else
        end //if
    end //always

    //b input_ack_and_request_out_logic clock process
        //   
        //       Clear current request out if it is being acked.
        //       If taking a new request, then register that.
        //       Register the taking of a request as the ack to that requester.
        //       If a new request may not be presented then hold the output request
        //       stable and do not chose another request.
        //       
    always @( posedge clk or negedge reset_n)
    begin : input_ack_and_request_out_logic__code
        if (reset_n==1'b0)
        begin
            ack_a <= 1'h0;
            ack_b <= 1'h0;
            req__valid <= 1'h0;
            req__address <= 16'h0;
            req__data_0 <= 64'h0;
            req__data_1 <= 64'h0;
        end
        else if (clk__enable)
        begin
            ack_a <= arbiter_combs__take_req_a;
            ack_b <= arbiter_combs__take_req_b;
            if ((ack!=1'h0))
            begin
                req__valid <= 1'h0;
            end //if
            if ((arbiter_combs__take_req_a!=1'h0))
            begin
                req__valid <= req_a__valid;
                req__address <= req_a__address;
                req__data_0 <= req_a__data_0;
                req__data_1 <= req_a__data_1;
            end //if
            if ((arbiter_combs__take_req_b!=1'h0))
            begin
                req__valid <= req_b__valid;
                req__address <= req_b__address;
                req__data_0 <= req_b__data_0;
                req__data_1 <= req_b__data_1;
            end //if
        end //if
    end //always

endmodule // dprintf_2_mux
