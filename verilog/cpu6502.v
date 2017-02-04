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

//a Module cpu6502
module cpu6502
(
    clk,

    data_in,
    nmi_n,
    irq_n,
    ready,
    reset_n,

    data_out,
    read_not_write,
    address,
    ba
);

    //b Clocks
        //   Clock, rising edge is start of phi1, end of phi2 - the phi1/phi2 boundary is not required
    input clk;

    //b Inputs
        //   Captured at the end of phi2 (rising clock in here)
    input [7:0]data_in;
        //   Active low non-maskable interrupt in
    input nmi_n;
        //   Active low interrupt in
    input irq_n;
        //   Stops processor during current instruction. Does not stop a write phase. Address bus reflects current address being read. Stops the phase 2 from happening.
    input ready;
    input reset_n;

    //b Outputs
        //   In real 6502, valid at end of phi2 with data to write
    output [7:0]data_out;
        //   In real 6502, changes during phi 1 with whether to read or write
    output read_not_write;
        //   In real 6502, changes during phi 1 with address to read or write
    output [15:0]address;
        //   Goes high during phase 2 if ready was low in phase 1 if read_not_write is 1, to permit someone else to use the memory bus
    output ba;

// output components here

    //b Output combinatorials
        //   In real 6502, valid at end of phi2 with data to write
    reg [7:0]data_out;
        //   In real 6502, changes during phi 1 with whether to read or write
    reg read_not_write;
        //   In real 6502, changes during phi 1 with address to read or write
    reg [15:0]address;
        //   Goes high during phase 2 if ready was low in phase 1 if read_not_write is 1, to permit someone else to use the memory bus
    reg ba;

    //b Output nets

    //b Internal and output registers
    reg interrupt_state__nmi_last;
    reg interrupt_state__nmi_pending;
    reg interrupt_state__irq_pending;
    reg [7:0]state__acc;
    reg [7:0]state__x;
    reg [7:0]state__y;
    reg [7:0]state__sp;
    reg [7:0]state__pcl;
    reg [7:0]state__pch;
    reg [7:0]state__ir;
    reg [7:0]state__dl;
    reg state__psr__z;
    reg state__psr__n;
    reg state__psr__c;
    reg state__psr__v;
    reg state__psr__i;
    reg state__psr__d;
    reg state__psr__b;
    reg [7:0]state__adl;
    reg [7:0]state__adh;
    reg [4:0]state__cycle;
    reg [1:0]state__interrupt_reason;

    //b Internal combinatorials
    reg data_path__carry_in;
    reg [7:0]data_path__src_data;
    reg [15:0]data_path__ids_data_in;
    reg [15:0]data_path__ids_data_out;
    reg [7:0]data_path__add_a_in;
    reg [7:0]data_path__add_b_in;
    reg data_path__add_carry_in;
    reg [7:0]data_path__add_sum_lower;
    reg [1:0]data_path__add_sum_higher;
    reg [7:0]data_path__logical_result;
    reg [7:0]data_path__mem_data_out;
    reg [7:0]data_path__add_result__data;
    reg data_path__add_result__carry;
    reg data_path__add_result__overflow;
    reg data_path__add_result__zero;
    reg data_path__add_result__negative;
    reg data_path__add_result__irq;
    reg data_path__add_result__decimal;
    reg [7:0]data_path__result__data;
    reg data_path__result__carry;
    reg data_path__result__overflow;
    reg data_path__result__zero;
    reg data_path__result__negative;
    reg data_path__result__irq;
    reg data_path__result__decimal;
    reg ir_decode__bcc_passed;
    reg [3:0]ir_decode__addressing_mode;
    reg ir_decode__memory_read;
    reg ir_decode__memory_write;
    reg ir_decode__index_is_x;
    reg [4:0]ir_decode__ids_enable;
    reg [7:0]ir_decode__srcs;
    reg [5:0]ir_decode__src_write_enable;
    reg [2:0]ir_decode__ids_op;
    reg [1:0]ir_decode__add_a_in_op;
    reg [1:0]ir_decode__add_b_in_op;
    reg ir_decode__alu_carry_in_zero;
    reg ir_decode__alu_carry_in_one;
    reg [3:0]ir_decode__alu_op;
    reg [4:0]useq_decode__next_cycle;
    reg useq_decode__last_cycle;
    reg [2:0]useq_decode__pc_op;
    reg [7:0]useq_decode__src_enable;
    reg [5:0]useq_decode__src_write_enable;
    reg [4:0]useq_decode__ids_enable;
    reg [2:0]useq_decode__ids_op;
    reg [1:0]useq_decode__dl_src;
    reg [1:0]useq_decode__mem_data_src;
    reg useq_decode__mem_request__enable;
    reg useq_decode__mem_request__read_not_write;
    reg [15:0]useq_decode__mem_request__address;
    reg [1:0]useq_decode__add_a_in_op;
    reg [1:0]useq_decode__add_b_in_op;
    reg [3:0]useq_decode__alu_op;
    reg ir_fetch_brk;
    reg ir_fetch_required;
    reg mem_request__enable;
    reg mem_request__read_not_write;
    reg [15:0]mem_request__address;
    reg irq_will_be_disabled;
    reg clock_complete;

    //b Internal nets

    //b Clock gating module instances
    //b Module instances
    //b clock_control combinatorial process
        //   Clock control logic - phase 0 is always one tick, phase 1 can be extended for reads by 'ready'
    always @( //clock_control
        ready or
        mem_request__enable or
        mem_request__read_not_write )
    begin: clock_control__comb_code
    reg clock_complete__var;
        clock_complete__var = ready;
        if (((mem_request__enable!=1'h0)&&!(mem_request__read_not_write!=1'h0)))
        begin
            clock_complete__var = 1'h1;
        end //if
        clock_complete = clock_complete__var;
    end //always

    //b memory_interface__comb combinatorial process
    always @( //memory_interface__comb
        useq_decode__mem_request__enable or
        ir_fetch_required or
        useq_decode__mem_request__read_not_write or
        useq_decode__mem_request__address or
        state__pch or
        state__pcl or
        data_path__mem_data_out )
    begin: memory_interface__comb_code
    reg mem_request__enable__var;
    reg mem_request__read_not_write__var;
    reg [15:0]mem_request__address__var;
        ba = 1'h0;
        mem_request__enable__var = useq_decode__mem_request__enable;
        mem_request__read_not_write__var = useq_decode__mem_request__read_not_write;
        mem_request__address__var = useq_decode__mem_request__address;
        if ((ir_fetch_required!=1'h0))
        begin
            mem_request__enable__var = 1'h1;
            mem_request__read_not_write__var = 1'h1;
            mem_request__address__var = {state__pch,state__pcl};
        end //if
        read_not_write = ((mem_request__read_not_write__var!=1'h0)||!(mem_request__enable__var!=1'h0));
        address = mem_request__address__var;
        data_out = data_path__mem_data_out;
        mem_request__enable = mem_request__enable__var;
        mem_request__read_not_write = mem_request__read_not_write__var;
        mem_request__address = mem_request__address__var;
    end //always

    //b memory_interface__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : memory_interface__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            state__ir <= 8'h0;
            state__ir <= 8'h0;
        end
        else
        begin
            if ((clock_complete!=1'h0))
            begin
                if ((ir_fetch_required!=1'h0))
                begin
                    state__ir <= data_in;
                end //if
                if ((ir_fetch_brk!=1'h0))
                begin
                    state__ir <= 8'h0;
                end //if
            end //if
        end //if
    end //always

    //b interrupt_logic__comb combinatorial process
    always @( //interrupt_logic__comb
        useq_decode__last_cycle or
        interrupt_state__nmi_pending or
        interrupt_state__irq_pending or
        irq_will_be_disabled )
    begin: interrupt_logic__comb_code
    reg ir_fetch_required__var;
    reg ir_fetch_brk__var;
        ir_fetch_required__var = 1'h0;
        ir_fetch_brk__var = 1'h0;
        if ((useq_decode__last_cycle!=1'h0))
        begin
            ir_fetch_required__var = 1'h1;
            ir_fetch_brk__var = 1'h0;
            if ((interrupt_state__nmi_pending!=1'h0))
            begin
                ir_fetch_required__var = 1'h0;
                ir_fetch_brk__var = 1'h1;
            end //if
            else
            
            begin
                if (((interrupt_state__irq_pending!=1'h0)&&!(irq_will_be_disabled!=1'h0)))
                begin
                    ir_fetch_required__var = 1'h0;
                    ir_fetch_brk__var = 1'h1;
                end //if
            end //else
        end //if
        ir_fetch_required = ir_fetch_required__var;
        ir_fetch_brk = ir_fetch_brk__var;
    end //always

    //b interrupt_logic__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : interrupt_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            interrupt_state__nmi_last <= 1'h0;
            interrupt_state__nmi_pending <= 1'h0;
            interrupt_state__irq_pending <= 1'h0;
            state__interrupt_reason <= 2'h0;
            state__interrupt_reason <= 2'h0;
        end
        else
        begin
            interrupt_state__nmi_last <= !(nmi_n!=1'h0);
            if ((!(nmi_n!=1'h0)&&!(interrupt_state__nmi_last!=1'h0)))
            begin
                interrupt_state__nmi_pending <= 1'h1;
            end //if
            interrupt_state__irq_pending <= !(irq_n!=1'h0);
            if ((useq_decode__last_cycle!=1'h0))
            begin
                state__interrupt_reason <= 2'h3;
                if ((interrupt_state__nmi_pending!=1'h0))
                begin
                    state__interrupt_reason <= 2'h1;
                end //if
                else
                
                begin
                    if (((interrupt_state__irq_pending!=1'h0)&&!(irq_will_be_disabled!=1'h0)))
                    begin
                        state__interrupt_reason <= 2'h2;
                    end //if
                end //else
            end //if
            if ((state__interrupt_reason==2'h1))
            begin
                interrupt_state__nmi_pending <= 1'h0;
            end //if
            if (!(clock_complete!=1'h0))
            begin
                state__interrupt_reason <= state__interrupt_reason;
            end //if
        end //if
    end //always

    //b state_update_logic__comb combinatorial process
    always @( //state_update_logic__comb
        state__psr__i or
        useq_decode__src_write_enable or
        data_path__result__irq or
        state__cycle )
    begin: state_update_logic__comb_code
    reg irq_will_be_disabled__var;
        irq_will_be_disabled__var = state__psr__i;
        if ((useq_decode__src_write_enable[5]!=1'h0))
        begin
            irq_will_be_disabled__var = data_path__result__irq;
        end //if
        if ((state__cycle==5'h12))
        begin
            irq_will_be_disabled__var = 1'h1;
        end //if
        irq_will_be_disabled = irq_will_be_disabled__var;
    end //always

    //b state_update_logic__posedge_clk_active_low_reset_n clock process
    always @( posedge clk or negedge reset_n)
    begin : state_update_logic__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            state__acc <= 8'h0;
            state__x <= 8'h0;
            state__y <= 8'h0;
            state__sp <= 8'h0;
            state__psr__c <= 1'h0;
            state__psr__v <= 1'h0;
            state__psr__z <= 1'h0;
            state__psr__n <= 1'h0;
            state__psr__i <= 1'h0;
            state__psr__d <= 1'h0;
            state__pcl <= 8'h0;
            state__pch <= 8'h0;
            state__adl <= 8'h0;
            state__adh <= 8'h0;
            state__dl <= 8'h0;
            state__psr__b <= 1'h0;
        end
        else
        begin
            if ((useq_decode__src_write_enable[0]!=1'h0))
            begin
                state__acc <= data_path__result__data;
            end //if
            if ((useq_decode__src_write_enable[1]!=1'h0))
            begin
                state__x <= data_path__result__data;
            end //if
            if ((useq_decode__src_write_enable[2]!=1'h0))
            begin
                state__y <= data_path__result__data;
            end //if
            if ((useq_decode__src_write_enable[3]!=1'h0))
            begin
                state__sp <= data_path__result__data;
            end //if
            if ((useq_decode__src_write_enable[5]!=1'h0))
            begin
                state__psr__c <= data_path__result__carry;
                state__psr__v <= data_path__result__overflow;
                state__psr__z <= data_path__result__zero;
                state__psr__n <= data_path__result__negative;
                state__psr__i <= data_path__result__irq;
                state__psr__d <= data_path__result__decimal;
            end //if
            if ((state__cycle==5'h17))
            begin
                state__psr__c <= state__dl[0];
                state__psr__z <= state__dl[1];
                state__psr__i <= state__dl[2];
                state__psr__v <= state__dl[6];
                state__psr__n <= state__dl[7];
            end //if
            if ((state__cycle==5'h12))
            begin
                state__psr__i <= 1'h1;
            end //if
            state__pcl <= state__pcl;
            state__pch <= state__pch;
            state__adl <= state__adl;
            state__adh <= state__adh;
            if ((useq_decode__mem_request__enable!=1'h0))
            begin
                state__adl <= useq_decode__mem_request__address[7:0];
                state__adh <= useq_decode__mem_request__address[15:8];
            end //if
            if ((state__cycle==5'h5))
            begin
                state__adl <= (state__dl+8'h1);
            end //if
            if ((state__cycle==5'h9))
            begin
                state__adl <= data_path__result__data;
            end //if
            if ((state__cycle==5'h6))
            begin
                state__adl <= data_path__result__data;
            end //if
            case (useq_decode__dl_src) //synopsys parallel_case
            2'h1: // req 1
                begin
                state__dl <= data_path__result__data;
                end
            2'h0: // req 1
                begin
                state__dl <= data_in;
                end
            2'h2: // req 1
                begin
                state__dl <= state__dl;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:cpu6502:state_update_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            case (useq_decode__pc_op) //synopsys parallel_case
            3'h0: // req 1
                begin
                state__pcl <= state__pcl;
                state__pch <= state__pch;
                end
            3'h1: // req 1
                begin
                state__pcl <= (state__pcl+8'h1);
                state__pch <= (state__pch+((state__pcl==8'hff)?64'h1:64'h0));
                end
            3'h2: // req 1
                begin
                state__pcl <= data_path__result__data;
                state__pch <= state__pch;
                end
            3'h3: // req 1
                begin
                state__pcl <= state__pcl;
                state__pch <= data_path__result__data;
                end
            3'h4: // req 1
                begin
                state__pcl <= state__dl;
                state__pch <= data_in;
                end
            3'h5: // req 1
                begin
                state__pcl <= 8'hfe;
                if ((state__interrupt_reason==2'h0))
                begin
                    state__pcl <= 8'hfc;
                end //if
                else
                
                begin
                    if ((state__interrupt_reason==2'h1))
                    begin
                        state__pcl <= 8'hfa;
                    end //if
                end //else
                state__pch <= 8'hff;
                end
    //synopsys  translate_off
    //pragma coverage off
            default:
                begin
                    if (1)
                    begin
                        $display("%t *********CDL ASSERTION FAILURE:cpu6502:state_update_logic: Full switch statement did not cover all values", $time);
                    end
                end
    //pragma coverage on
    //synopsys  translate_on
            endcase
            if (!(clock_complete!=1'h0))
            begin
                state__dl <= state__dl;
                state__acc <= state__acc;
                state__x <= state__x;
                state__y <= state__y;
                state__psr__z <= state__psr__z;
                state__psr__n <= state__psr__n;
                state__psr__c <= state__psr__c;
                state__psr__v <= state__psr__v;
                state__psr__i <= state__psr__i;
                state__psr__d <= state__psr__d;
                state__psr__b <= state__psr__b;
                state__sp <= state__sp;
                state__pcl <= state__pcl;
                state__pch <= state__pch;
                state__adl <= state__adl;
                state__adh <= state__adh;
            end //if
        end //if
    end //always

    //b instruction_decode__comb combinatorial process
        //   Decode 'ir' register (and other state, but not microsequencer)
    always @( //instruction_decode__comb
        state__ir or
        state__psr__n or
        state__psr__v or
        state__psr__c or
        state__psr__z )
    begin: instruction_decode__comb_code
    reg [3:0]ir_decode__addressing_mode__var;
    reg [2:0]ir_decode__ids_op__var;
    reg [3:0]ir_decode__alu_op__var;
    reg ir_decode__alu_carry_in_one__var;
    reg [4:0]ir_decode__ids_enable__var;
    reg [7:0]ir_decode__srcs__var;
    reg [5:0]ir_decode__src_write_enable__var;
    reg ir_decode__index_is_x__var;
    reg ir_decode__memory_read__var;
    reg ir_decode__memory_write__var;
    reg ir_decode__bcc_passed__var;
        ir_decode__addressing_mode__var = 4'h0;
        case (state__ir[4:0]) //synopsys parallel_case
        5'h0: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h1;
            end
        5'h2: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h1;
            end
        5'h1: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h6;
            end
        5'h3: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h6;
            end
        5'h4: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h2;
            end
        5'h5: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h2;
            end
        5'h6: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h2;
            end
        5'h7: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h2;
            end
        5'h8: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h0;
            end
        5'ha: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h0;
            end
        5'h9: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h1;
            end
        5'hb: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h1;
            end
        5'hc: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h3;
            end
        5'hd: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h3;
            end
        5'he: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h3;
            end
        5'hf: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h3;
            end
        5'h10: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h8;
            end
        5'h11: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h7;
            end
        5'h13: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h7;
            end
        5'h12: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h0;
            end
        5'h14: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h4;
            end
        5'h15: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h4;
            end
        5'h16: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h4;
            end
        5'h17: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h4;
            end
        5'h18: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h0;
            end
        5'h1a: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h0;
            end
        5'h19: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h5;
            end
        5'h1b: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h5;
            end
        5'h1c: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h5;
            end
        5'h1d: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h5;
            end
        5'h1e: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h5;
            end
        5'h1f: // req 1
            begin
            ir_decode__addressing_mode__var = 4'h5;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:cpu6502:instruction_decode: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        if ((state__ir==8'h0))
        begin
            ir_decode__addressing_mode__var = 4'h9;
        end //if
        if ((state__ir==8'h20))
        begin
            ir_decode__addressing_mode__var = 4'hc;
        end //if
        if ((state__ir==8'h40))
        begin
            ir_decode__addressing_mode__var = 4'hb;
        end //if
        if ((state__ir==8'h60))
        begin
            ir_decode__addressing_mode__var = 4'ha;
        end //if
        if ((state__ir==8'h4c))
        begin
            ir_decode__addressing_mode__var = 4'hd;
        end //if
        if ((state__ir==8'h6c))
        begin
            ir_decode__addressing_mode__var = 4'he;
        end //if
        ir_decode__ids_op__var = 3'h4;
        case (state__ir[7:5]) //synopsys parallel_case
        3'h0: // req 1
            begin
            ir_decode__ids_op__var = 3'h0;
            end
        3'h1: // req 1
            begin
            ir_decode__ids_op__var = 3'h1;
            end
        3'h2: // req 1
            begin
            ir_decode__ids_op__var = 3'h2;
            end
        3'h3: // req 1
            begin
            ir_decode__ids_op__var = 3'h3;
            end
        3'h6: // req 1
            begin
            ir_decode__ids_op__var = 3'h6;
            end
        3'h7: // req 1
            begin
            ir_decode__ids_op__var = 3'h7;
            end
        //synopsys  translate_off
        //pragma coverage off
        //synopsys  translate_on
        default:
            begin
            //Need a default case to make Cadence Lint happy, even though this is not a full case
            end
        //synopsys  translate_off
        //pragma coverage on
        //synopsys  translate_on
        endcase
        if ((state__ir[1]==1'h0))
        begin
            ir_decode__ids_op__var = 3'h4;
        end //if
        if ((state__ir==8'h88))
        begin
            ir_decode__ids_op__var = 3'h6;
        end //if
        if ((state__ir==8'hc8))
        begin
            ir_decode__ids_op__var = 3'h7;
        end //if
        if ((state__ir==8'he8))
        begin
            ir_decode__ids_op__var = 3'h7;
        end //if
        ir_decode__add_a_in_op = 2'h1;
        ir_decode__add_b_in_op = 2'h1;
        ir_decode__alu_op__var = 4'h4;
        case (state__ir[7:5]) //synopsys parallel_case
        3'h0: // req 1
            begin
            ir_decode__alu_op__var = 4'h0;
            end
        3'h1: // req 1
            begin
            ir_decode__alu_op__var = 4'h1;
            end
        3'h2: // req 1
            begin
            ir_decode__alu_op__var = 4'h3;
            end
        3'h3: // req 1
            begin
            ir_decode__alu_op__var = 4'h6;
            end
        3'h4: // req 1
            begin
            ir_decode__alu_op__var = 4'h4;
            end
        3'h5: // req 1
            begin
            ir_decode__alu_op__var = 4'h5;
            end
        3'h6: // req 1
            begin
            ir_decode__alu_op__var = 4'h8;
            end
        3'h7: // req 1
            begin
            ir_decode__alu_op__var = 4'h7;
            end
        //synopsys  translate_off
        //pragma coverage off
        //synopsys  translate_on
        default:
            begin
            //Need a default case to make Cadence Lint happy, even though this is not a full case
            end
        //synopsys  translate_off
        //pragma coverage on
        //synopsys  translate_on
        endcase
        if ((state__ir[7:0]==8'h24))
        begin
            ir_decode__alu_op__var = 4'h2;
        end //if
        if ((state__ir[7:0]==8'h2c))
        begin
            ir_decode__alu_op__var = 4'h2;
        end //if
        if ((state__ir[7:0]==8'he0))
        begin
            ir_decode__alu_op__var = 4'h8;
        end //if
        if ((state__ir[7:0]==8'he4))
        begin
            ir_decode__alu_op__var = 4'h8;
        end //if
        if ((state__ir[7:0]==8'hec))
        begin
            ir_decode__alu_op__var = 4'h8;
        end //if
        if ((state__ir[1:0]==2'h2))
        begin
            ir_decode__alu_op__var = 4'h5;
        end //if
        if ((state__ir[4:0]==5'h18))
        begin
            ir_decode__alu_op__var = 4'h9;
        end //if
        if ((state__ir==8'h98))
        begin
            ir_decode__alu_op__var = 4'h5;
        end //if
        if ((state__ir[4:0]==5'h8))
        begin
            ir_decode__alu_op__var = 4'h5;
        end //if
        ir_decode__alu_carry_in_zero = 1'h0;
        ir_decode__alu_carry_in_one__var = 1'h0;
        if (((state__ir[7:6]==2'h3)&&(state__ir[1:0]==2'h0)))
        begin
            ir_decode__alu_carry_in_one__var = 1'h1;
        end //if
        if ((state__ir[7:5]==3'h6))
        begin
            if ((state__ir[1:0]!=2'h2))
            begin
                ir_decode__alu_carry_in_one__var = 1'h1;
            end //if
        end //if
        if ((state__ir[3:0]==4'h8))
        begin
            ir_decode__alu_carry_in_one__var = 1'h0;
        end //if
        ir_decode__ids_enable__var = 5'h0;
        ir_decode__ids_enable__var[4] = 1'h1;
        if ((state__ir[3:0]==4'ha))
        begin
            ir_decode__ids_enable__var = 5'h0;
            ir_decode__ids_enable__var[1] = 1'h1;
        end //if
        if ((state__ir[7:5]==3'h4))
        begin
            ir_decode__ids_enable__var = 5'h0;
            ir_decode__ids_enable__var[1] = 1'h1;
        end //if
        if ((state__ir[3:0]==4'h8))
        begin
            ir_decode__ids_enable__var = 5'h0;
            if ((state__ir[7]==1'h0))
            begin
                ir_decode__ids_enable__var[4] = 1'h1;
            end //if
            else
            
            begin
                ir_decode__ids_enable__var[1] = 1'h1;
            end //else
        end //if
        ir_decode__srcs__var = 8'h0;
        if ((state__ir[7]==1'h0))
        begin
            ir_decode__srcs__var[0] = 1'h1;
        end //if
        if ((state__ir[1:0]==2'h1))
        begin
            ir_decode__srcs__var[0] = 1'h1;
        end //if
        if ((state__ir[1:0]==2'h3))
        begin
            ir_decode__srcs__var[0] = 1'h1;
        end //if
        if ((state__ir[7:4]==4'ha))
        begin
            ir_decode__srcs__var[0] = 1'h1;
        end //if
        if ((state__ir[7:5]==3'h4))
        begin
            if ((state__ir[1]!=1'h0))
            begin
                ir_decode__srcs__var[1] = 1'h1;
            end //if
            if ((state__ir[1:0]==2'h0))
            begin
                ir_decode__srcs__var[2] = 1'h1;
            end //if
        end //if
        if ((state__ir[7:1]==7'h65))
        begin
            ir_decode__srcs__var[1] = 1'h1;
        end //if
        if ((state__ir[1:0]==2'h0))
        begin
            if ((state__ir[7:5]==3'h6))
            begin
                ir_decode__srcs__var[2] = 1'h1;
            end //if
            if ((state__ir[7:5]==3'h7))
            begin
                ir_decode__srcs__var[1] = 1'h1;
            end //if
        end //if
        if ((state__ir[7:4]==4'hb))
        begin
            ir_decode__srcs__var = 8'h0;
            ir_decode__srcs__var[3] = 1'h1;
        end //if
        if (((state__ir[7:6]==2'h0)&&(state__ir[3:0]==4'h8)))
        begin
            ir_decode__srcs__var = 8'h0;
            ir_decode__srcs__var[4] = 1'h1;
        end //if
        ir_decode__src_write_enable__var = 6'h0;
        ir_decode__src_write_enable__var[5] = 1'h1;
        if (((state__ir[7:5]!=3'h6)&&(state__ir[0]==1'h1)))
        begin
            ir_decode__src_write_enable__var[0] = 1'h1;
        end //if
        if ((state__ir[7]==1'h0))
        begin
            if ((state__ir[3:0]==4'ha))
            begin
                ir_decode__src_write_enable__var[0] = 1'h1;
            end //if
        end //if
        if ((state__ir==8'h8a))
        begin
            ir_decode__src_write_enable__var[0] = 1'h1;
        end //if
        if ((state__ir==8'h98))
        begin
            ir_decode__src_write_enable__var[0] = 1'h1;
        end //if
        if ((state__ir==8'h68))
        begin
            ir_decode__src_write_enable__var[0] = 1'h1;
        end //if
        if (((state__ir[7:5]==3'h5)&&(state__ir[1]==1'h1)))
        begin
            ir_decode__src_write_enable__var[1] = 1'h1;
        end //if
        if ((state__ir==8'hca))
        begin
            ir_decode__src_write_enable__var[1] = 1'h1;
        end //if
        if ((state__ir==8'hcb))
        begin
            ir_decode__src_write_enable__var[1] = 1'h1;
        end //if
        if ((state__ir==8'he8))
        begin
            ir_decode__src_write_enable__var[1] = 1'h1;
        end //if
        if (((state__ir==8'h88)||(state__ir==8'hc8)))
        begin
            ir_decode__src_write_enable__var[2] = 1'h1;
        end //if
        if (((state__ir==8'hb4)||(state__ir==8'hbc)))
        begin
            ir_decode__src_write_enable__var[2] = 1'h1;
        end //if
        if (((state__ir[7:4]==4'ha)&&(state__ir[1:0]==2'h0)))
        begin
            ir_decode__src_write_enable__var[2] = 1'h1;
        end //if
        if ((state__ir==8'h9a))
        begin
            ir_decode__src_write_enable__var[3] = 1'h1;
        end //if
        if ((state__ir==8'h9a))
        begin
            ir_decode__src_write_enable__var[5] = 1'h0;
        end //if
        if ((state__ir==8'h48))
        begin
            ir_decode__src_write_enable__var[5] = 1'h0;
        end //if
        if ((state__ir==8'h8))
        begin
            ir_decode__src_write_enable__var[5] = 1'h0;
        end //if
        if ((state__ir==8'hea))
        begin
            ir_decode__src_write_enable__var[5] = 1'h0;
        end //if
        ir_decode__index_is_x__var = 1'h1;
        if (((state__ir[4]!=1'h0)&&(state__ir[3:2]==2'h0)))
        begin
            ir_decode__index_is_x__var = 1'h0;
        end //if
        if (((state__ir[4]!=1'h0)&&(state__ir[3:2]==2'h2)))
        begin
            ir_decode__index_is_x__var = 1'h0;
        end //if
        if (((state__ir[7:6]==2'h2)&&(state__ir[2:1]==2'h3)))
        begin
            ir_decode__index_is_x__var = 1'h0;
        end //if
        ir_decode__memory_read__var = 1'h1;
        ir_decode__memory_write__var = 1'h0;
        if ((state__ir[7:5]==3'h4))
        begin
            ir_decode__memory_read__var = 1'h0;
            ir_decode__memory_write__var = 1'h1;
        end //if
        else
        
        begin
            if ((state__ir[7:5]==3'h5))
            begin
                ir_decode__memory_read__var = 1'h1;
                ir_decode__memory_write__var = 1'h0;
            end //if
            else
            
            begin
                ir_decode__memory_read__var = 1'h1;
                ir_decode__memory_write__var = 1'h0;
                if ((state__ir[1]!=1'h0))
                begin
                    ir_decode__memory_write__var = 1'h1;
                end //if
            end //else
        end //else
        ir_decode__bcc_passed__var = 1'h0;
        case (state__ir[7:5]) //synopsys parallel_case
        3'h0: // req 1
            begin
            ir_decode__bcc_passed__var = !(state__psr__n!=1'h0);
            end
        3'h1: // req 1
            begin
            ir_decode__bcc_passed__var = state__psr__n;
            end
        3'h2: // req 1
            begin
            ir_decode__bcc_passed__var = !(state__psr__v!=1'h0);
            end
        3'h3: // req 1
            begin
            ir_decode__bcc_passed__var = state__psr__v;
            end
        3'h4: // req 1
            begin
            ir_decode__bcc_passed__var = !(state__psr__c!=1'h0);
            end
        3'h5: // req 1
            begin
            ir_decode__bcc_passed__var = state__psr__c;
            end
        3'h6: // req 1
            begin
            ir_decode__bcc_passed__var = !(state__psr__z!=1'h0);
            end
        3'h7: // req 1
            begin
            ir_decode__bcc_passed__var = state__psr__z;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:cpu6502:instruction_decode: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        ir_decode__addressing_mode = ir_decode__addressing_mode__var;
        ir_decode__ids_op = ir_decode__ids_op__var;
        ir_decode__alu_op = ir_decode__alu_op__var;
        ir_decode__alu_carry_in_one = ir_decode__alu_carry_in_one__var;
        ir_decode__ids_enable = ir_decode__ids_enable__var;
        ir_decode__srcs = ir_decode__srcs__var;
        ir_decode__src_write_enable = ir_decode__src_write_enable__var;
        ir_decode__index_is_x = ir_decode__index_is_x__var;
        ir_decode__memory_read = ir_decode__memory_read__var;
        ir_decode__memory_write = ir_decode__memory_write__var;
        ir_decode__bcc_passed = ir_decode__bcc_passed__var;
    end //always

    //b instruction_decode__posedge_clk_active_low_reset_n clock process
        //   Decode 'ir' register (and other state, but not microsequencer)
    always @( posedge clk or negedge reset_n)
    begin : instruction_decode__posedge_clk_active_low_reset_n__code
        if (reset_n==1'b0)
        begin
            state__cycle <= 5'h0;
            state__cycle <= 5'h0;
        end
        else
        begin
            if ((clock_complete!=1'h0))
            begin
                state__cycle <= useq_decode__next_cycle;
                if ((useq_decode__last_cycle!=1'h0))
                begin
                    state__cycle <= 5'h0;
                end //if
            end //if
        end //if
    end //always

    //b microsequencer_decode combinatorial process
    always @( //microsequencer_decode
        ir_decode__index_is_x or
        state__cycle or
        ir_decode__srcs or
        ir_decode__ids_enable or
        ir_decode__ids_op or
        ir_decode__addressing_mode or
        ir_decode__alu_op or
        ir_decode__src_write_enable or
        state__pch or
        state__pcl or
        state__dl or
        state__adl or
        state__adh or
        state__sp or
        state__ir or
        ir_decode__bcc_passed or
        ir_decode__memory_read or
        ir_decode__memory_write or
        data_path__result__carry or
        state__interrupt_reason or
        ir_fetch_brk )
    begin: microsequencer_decode__comb_code
    reg [7:0]useq_decode__src_enable__var;
    reg [4:0]useq_decode__ids_enable__var;
    reg [2:0]useq_decode__ids_op__var;
    reg [1:0]useq_decode__add_a_in_op__var;
    reg [1:0]useq_decode__add_b_in_op__var;
    reg [3:0]useq_decode__alu_op__var;
    reg [1:0]useq_decode__dl_src__var;
    reg [5:0]useq_decode__src_write_enable__var;
    reg useq_decode__mem_request__enable__var;
    reg useq_decode__mem_request__read_not_write__var;
    reg [15:0]useq_decode__mem_request__address__var;
    reg [1:0]useq_decode__mem_data_src__var;
    reg [4:0]useq_decode__next_cycle__var;
    reg useq_decode__last_cycle__var;
    reg [2:0]useq_decode__pc_op__var;
        useq_decode__src_enable__var = 8'h0;
        if ((ir_decode__index_is_x!=1'h0))
        begin
            useq_decode__src_enable__var[1] = 1'h1;
        end //if
        else
        
        begin
            useq_decode__src_enable__var[2] = 1'h1;
        end //else
        case (state__cycle) //synopsys parallel_case
        5'h7: // req 1
            begin
            useq_decode__src_enable__var = ir_decode__srcs;
            end
        5'h2: // req 1
            begin
            useq_decode__src_enable__var = ir_decode__srcs;
            end
        5'h8: // req 1
            begin
            useq_decode__src_enable__var = ir_decode__srcs;
            end
        5'hc: // req 1
            begin
            useq_decode__src_enable__var = ir_decode__srcs;
            end
        5'h11: // req 1
            begin
            useq_decode__src_enable__var = ir_decode__srcs;
            end
        5'h19: // req 1
            begin
            useq_decode__src_enable__var = 8'h0;
            useq_decode__src_enable__var[6] = 1'h1;
            end
        5'h14: // req 1
            begin
            useq_decode__src_enable__var = 8'h0;
            useq_decode__src_enable__var[6] = 1'h1;
            end
        5'h13: // req 1
            begin
            useq_decode__src_enable__var = 8'h0;
            useq_decode__src_enable__var[7] = 1'h1;
            end
        5'h12: // req 1
            begin
            useq_decode__src_enable__var = 8'h0;
            useq_decode__src_enable__var[4] = 1'h1;
            end
        //synopsys  translate_off
        //pragma coverage off
        //synopsys  translate_on
        default:
            begin
            //Need a default case to make Cadence Lint happy, even though this is not a full case
            end
        //synopsys  translate_off
        //pragma coverage on
        //synopsys  translate_on
        endcase
        useq_decode__ids_enable__var = 5'h0;
        if ((state__cycle==5'h2))
        begin
            useq_decode__ids_enable__var = ir_decode__ids_enable;
        end //if
        if ((state__cycle==5'h7))
        begin
            useq_decode__ids_enable__var = ir_decode__ids_enable;
        end //if
        if ((state__cycle==5'h3))
        begin
            useq_decode__ids_enable__var[4] = 1'h1;
        end //if
        if ((state__cycle==5'h9))
        begin
            useq_decode__ids_enable__var[4] = 1'h1;
        end //if
        if ((state__cycle==5'h6))
        begin
            useq_decode__ids_enable__var[4] = 1'h1;
        end //if
        if ((state__cycle==5'ha))
        begin
            useq_decode__ids_enable__var[4] = 1'h1;
        end //if
        if ((state__cycle==5'h19))
        begin
            useq_decode__ids_enable__var[4] = 1'h1;
        end //if
        if ((state__cycle==5'h1a))
        begin
            useq_decode__ids_enable__var[3] = 1'h1;
        end //if
        if ((state__cycle==5'h1b))
        begin
            useq_decode__ids_enable__var[3] = 1'h1;
        end //if
        if (((((state__cycle==5'h11)||(state__cycle==5'h12))||(state__cycle==5'h14))||(state__cycle==5'h13)))
        begin
            useq_decode__ids_enable__var[2] = 1'h1;
        end //if
        if ((((state__cycle==5'h15)||(state__cycle==5'h17))||(state__cycle==5'h16)))
        begin
            useq_decode__ids_enable__var[2] = 1'h1;
        end //if
        useq_decode__ids_op__var = 3'h4;
        if ((state__cycle==5'h2))
        begin
            useq_decode__ids_op__var = ir_decode__ids_op;
        end //if
        if ((state__cycle==5'h7))
        begin
            useq_decode__ids_op__var = ir_decode__ids_op;
        end //if
        if ((state__cycle==5'h1a))
        begin
            useq_decode__ids_op__var = 3'h6;
        end //if
        if ((state__cycle==5'h1b))
        begin
            useq_decode__ids_op__var = 3'h7;
        end //if
        if ((state__cycle==5'ha))
        begin
            useq_decode__ids_op__var = 3'h7;
        end //if
        if (((((state__cycle==5'h11)||(state__cycle==5'h12))||(state__cycle==5'h14))||(state__cycle==5'h13)))
        begin
            useq_decode__ids_op__var = 3'h6;
        end //if
        if ((((state__cycle==5'h15)||(state__cycle==5'h17))||(state__cycle==5'h16)))
        begin
            useq_decode__ids_op__var = 3'h7;
        end //if
        useq_decode__add_a_in_op__var = 2'h1;
        useq_decode__add_b_in_op__var = 2'h1;
        useq_decode__alu_op__var = 4'h4;
        if (((state__cycle==5'h2)||(state__cycle==5'h7)))
        begin
            useq_decode__alu_op__var = ir_decode__alu_op;
            if ((ir_decode__alu_op==4'h7))
            begin
                useq_decode__add_b_in_op__var = 2'h2;
            end //if
            if ((ir_decode__alu_op==4'h8))
            begin
                useq_decode__add_b_in_op__var = 2'h2;
            end //if
        end //if
        if ((state__cycle==5'h3))
        begin
            useq_decode__alu_op__var = 4'h6;
            if ((ir_decode__addressing_mode==4'h2))
            begin
                useq_decode__add_a_in_op__var = 2'h2;
            end //if
        end //if
        if ((state__cycle==5'h9))
        begin
            useq_decode__alu_op__var = 4'h6;
            if ((ir_decode__addressing_mode==4'h3))
            begin
                useq_decode__add_a_in_op__var = 2'h2;
            end //if
        end //if
        if ((state__cycle==5'h6))
        begin
            useq_decode__alu_op__var = 4'h6;
            if ((ir_decode__addressing_mode==4'h6))
            begin
                useq_decode__add_a_in_op__var = 2'h2;
            end //if
        end //if
        if ((state__cycle==5'h19))
        begin
            useq_decode__alu_op__var = 4'h6;
        end //if
        if ((state__cycle==5'h1a))
        begin
            useq_decode__alu_op__var = 4'h5;
        end //if
        if ((state__cycle==5'h1b))
        begin
            useq_decode__alu_op__var = 4'h5;
        end //if
        if ((state__cycle==5'ha))
        begin
            useq_decode__alu_op__var = 4'h5;
        end //if
        if (((((state__cycle==5'h11)||(state__cycle==5'h12))||(state__cycle==5'h14))||(state__cycle==5'h13)))
        begin
            useq_decode__alu_op__var = 4'h5;
        end //if
        if ((((state__cycle==5'h15)||(state__cycle==5'h17))||(state__cycle==5'h16)))
        begin
            useq_decode__alu_op__var = 4'h5;
        end //if
        useq_decode__dl_src__var = 2'h0;
        if ((state__cycle==5'h3))
        begin
            useq_decode__dl_src__var = 2'h1;
        end //if
        if ((state__cycle==5'ha))
        begin
            useq_decode__dl_src__var = 2'h1;
        end //if
        if ((state__cycle==5'h7))
        begin
            useq_decode__dl_src__var = 2'h1;
        end //if
        if (((state__cycle==5'h14)||(state__cycle==5'h13)))
        begin
            useq_decode__dl_src__var = 2'h2;
        end //if
        useq_decode__src_write_enable__var = 6'h0;
        if (((state__cycle==5'h2)||(state__cycle==5'h7)))
        begin
            useq_decode__src_write_enable__var = ir_decode__src_write_enable;
        end //if
        if (((((state__cycle==5'h11)||(state__cycle==5'h12))||(state__cycle==5'h14))||(state__cycle==5'h13)))
        begin
            useq_decode__src_write_enable__var[3] = 1'h1;
        end //if
        if ((state__cycle==5'h15))
        begin
            useq_decode__src_write_enable__var[3] = 1'h1;
        end //if
        if ((state__cycle==5'h16))
        begin
            if ((ir_decode__addressing_mode==4'ha))
            begin
                useq_decode__src_write_enable__var[3] = 1'h1;
            end //if
            if ((ir_decode__addressing_mode==4'hb))
            begin
                useq_decode__src_write_enable__var[3] = 1'h1;
            end //if
        end //if
        if ((state__cycle==5'h17))
        begin
            useq_decode__src_write_enable__var[3] = 1'h1;
        end //if
        useq_decode__mem_request__enable__var = 1'h0;
        useq_decode__mem_request__read_not_write__var = 1'h1;
        useq_decode__mem_request__address__var = {state__pch,state__pcl};
        useq_decode__mem_data_src__var = 2'h0;
        case (state__cycle) //synopsys parallel_case
        5'h0: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            end
        5'hf: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            end
        5'h1: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            end
        5'h9: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            end
        5'h2: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h0;
            end
        5'h3: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h0;
            end
        5'h4: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h1;
            useq_decode__mem_request__address__var = {8'h0,state__dl};
            end
        5'h5: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h1;
            useq_decode__mem_request__address__var = {8'h0,state__dl};
            end
        5'h8: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h0;
            useq_decode__mem_request__address__var = {8'h0,state__dl};
            end
        5'h6: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h1;
            useq_decode__mem_request__address__var = {8'h0,state__adl};
            end
        5'hb: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h1;
            useq_decode__mem_request__address__var = {state__dl,state__adl};
            end
        5'hc: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h0;
            useq_decode__mem_request__address__var = {state__dl,state__adl};
            end
        5'hd: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h0;
            useq_decode__mem_request__address__var = {state__adh,state__adl};
            useq_decode__mem_data_src__var = 2'h3;
            end
        5'h10: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            end
        5'he: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            end
        5'h11: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h0;
            useq_decode__mem_request__address__var = {8'h1,state__sp};
            end
        5'h12: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h0;
            useq_decode__mem_request__address__var = {8'h1,state__sp};
            end
        5'h14: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h0;
            useq_decode__mem_request__address__var = {8'h1,state__sp};
            end
        5'h13: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h0;
            useq_decode__mem_request__address__var = {8'h1,state__sp};
            end
        5'h16: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h1;
            useq_decode__mem_request__address__var = {8'h1,state__sp};
            end
        5'h17: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h1;
            useq_decode__mem_request__address__var = {8'h1,state__sp};
            end
        5'h18: // req 1
            begin
            useq_decode__mem_request__enable__var = 1'h1;
            useq_decode__mem_request__read_not_write__var = 1'h1;
            useq_decode__mem_request__address__var = {8'h1,state__sp};
            end
        //synopsys  translate_off
        //pragma coverage off
        //synopsys  translate_on
        default:
            begin
            //Need a default case to make Cadence Lint happy, even though this is not a full case
            end
        //synopsys  translate_off
        //pragma coverage on
        //synopsys  translate_on
        endcase
        useq_decode__next_cycle__var = 5'h0;
        useq_decode__last_cycle__var = 1'h0;
        useq_decode__pc_op__var = 3'h0;
        case (state__cycle) //synopsys parallel_case
        5'h0: // req 1
            begin
            useq_decode__pc_op__var = 3'h1;
            if ((ir_decode__addressing_mode==4'h0))
            begin
                useq_decode__pc_op__var = 3'h0;
            end //if
            if (((ir_decode__addressing_mode==4'h9)&&(state__interrupt_reason!=2'h3)))
            begin
                useq_decode__pc_op__var = 3'h0;
            end //if
            useq_decode__next_cycle__var = 5'h2;
            case (ir_decode__addressing_mode) //synopsys parallel_case
            4'h0: // req 1
                begin
                useq_decode__next_cycle__var = 5'h2;
                if (((state__ir==8'h8)||(state__ir==8'h48)))
                begin
                    useq_decode__next_cycle__var = 5'h11;
                end //if
                if (((state__ir==8'h28)||(state__ir==8'h68)))
                begin
                    useq_decode__next_cycle__var = 5'h15;
                end //if
                end
            4'h1: // req 1
                begin
                useq_decode__next_cycle__var = 5'h2;
                end
            4'h8: // req 1
                begin
                useq_decode__next_cycle__var = ((ir_decode__bcc_passed!=1'h0)?5'h19:5'h1);
                end
            4'h2: // req 1
                begin
                useq_decode__next_cycle__var = ((ir_decode__memory_read!=1'h0)?5'h4:5'h8);
                end
            4'h4: // req 1
                begin
                useq_decode__next_cycle__var = 5'h3;
                end
            4'h6: // req 1
                begin
                useq_decode__next_cycle__var = 5'h3;
                end
            4'h7: // req 1
                begin
                useq_decode__next_cycle__var = 5'h5;
                end
            4'h3: // req 1
                begin
                useq_decode__next_cycle__var = 5'h9;
                end
            4'h5: // req 1
                begin
                useq_decode__next_cycle__var = 5'h9;
                end
            4'h9: // req 1
                begin
                useq_decode__next_cycle__var = 5'h13;
                end
            4'hb: // req 1
                begin
                useq_decode__next_cycle__var = 5'h15;
                end
            4'ha: // req 1
                begin
                useq_decode__next_cycle__var = 5'h15;
                end
            4'hc: // req 1
                begin
                useq_decode__next_cycle__var = 5'h13;
                end
            4'hd: // req 1
                begin
                useq_decode__next_cycle__var = 5'h10;
                end
            4'he: // req 1
                begin
                useq_decode__next_cycle__var = 5'he;
                end
            //synopsys  translate_off
            //pragma coverage off
            //synopsys  translate_on
            default:
                begin
                //Need a default case to make Cadence Lint happy, even though this is not a full case
                end
            //synopsys  translate_off
            //pragma coverage on
            //synopsys  translate_on
            endcase
            end
        5'h1: // req 1
            begin
            useq_decode__pc_op__var = 3'h1;
            useq_decode__last_cycle__var = 1'h1;
            end
        5'h2: // req 1
            begin
            useq_decode__pc_op__var = 3'h1;
            useq_decode__last_cycle__var = 1'h1;
            end
        5'h3: // req 1
            begin
            useq_decode__next_cycle__var = ((ir_decode__memory_read!=1'h0)?5'h4:5'h8);
            if ((ir_decode__addressing_mode==4'h6))
            begin
                useq_decode__next_cycle__var = 5'h5;
            end //if
            end
        5'h4: // req 1
            begin
            useq_decode__next_cycle__var = 5'h2;
            if ((ir_decode__memory_write!=1'h0))
            begin
                useq_decode__next_cycle__var = 5'h7;
            end //if
            end
        5'h5: // req 1
            begin
            useq_decode__next_cycle__var = 5'h6;
            end
        5'h6: // req 1
            begin
            useq_decode__next_cycle__var = 5'ha;
            if ((data_path__result__carry==1'h0))
            begin
                useq_decode__next_cycle__var = 5'hb;
                if ((!(ir_decode__memory_read!=1'h0)&&(ir_decode__memory_write!=1'h0)))
                begin
                    useq_decode__next_cycle__var = 5'hc;
                end //if
            end //if
            end
        5'h19: // req 1
            begin
            useq_decode__pc_op__var = 3'h2;
            useq_decode__next_cycle__var = ((state__dl[7]!=1'h0)?5'h1a:5'h1b);
            if ((data_path__result__carry==state__dl[7]))
            begin
                useq_decode__next_cycle__var = 5'h1;
            end //if
            end
        5'h1b: // req 1
            begin
            useq_decode__pc_op__var = 3'h3;
            useq_decode__next_cycle__var = 5'h1;
            end
        5'h1a: // req 1
            begin
            useq_decode__pc_op__var = 3'h3;
            useq_decode__next_cycle__var = 5'h1;
            end
        5'h7: // req 1
            begin
            useq_decode__next_cycle__var = 5'hd;
            end
        5'h8: // req 1
            begin
            useq_decode__next_cycle__var = 5'h1;
            end
        5'hc: // req 1
            begin
            useq_decode__next_cycle__var = 5'h1;
            end
        5'hd: // req 1
            begin
            useq_decode__next_cycle__var = 5'h1;
            end
        5'h9: // req 1
            begin
            useq_decode__pc_op__var = 3'h1;
            useq_decode__next_cycle__var = 5'ha;
            if ((data_path__result__carry==1'h0))
            begin
                useq_decode__next_cycle__var = 5'hb;
                if ((!(ir_decode__memory_read!=1'h0)&&(ir_decode__memory_write!=1'h0)))
                begin
                    useq_decode__next_cycle__var = 5'hc;
                end //if
            end //if
            end
        5'ha: // req 1
            begin
            useq_decode__next_cycle__var = 5'hb;
            if ((!(ir_decode__memory_read!=1'h0)&&(ir_decode__memory_write!=1'h0)))
            begin
                useq_decode__next_cycle__var = 5'hc;
            end //if
            end
        5'hb: // req 1
            begin
            useq_decode__next_cycle__var = 5'h2;
            if ((ir_decode__memory_write!=1'h0))
            begin
                useq_decode__next_cycle__var = 5'h7;
            end //if
            end
        5'h11: // req 1
            begin
            useq_decode__next_cycle__var = 5'h1;
            end
        5'h13: // req 1
            begin
            useq_decode__next_cycle__var = 5'h14;
            end
        5'h14: // req 1
            begin
            useq_decode__next_cycle__var = 5'h10;
            if ((ir_decode__addressing_mode==4'h9))
            begin
                useq_decode__next_cycle__var = 5'h12;
            end //if
            end
        5'h12: // req 1
            begin
            useq_decode__pc_op__var = 3'h5;
            useq_decode__next_cycle__var = 5'hf;
            end
        5'h15: // req 1
            begin
            useq_decode__next_cycle__var = 5'h16;
            end
        5'h16: // req 1
            begin
            useq_decode__next_cycle__var = 5'h2;
            if ((ir_decode__addressing_mode==4'ha))
            begin
                useq_decode__next_cycle__var = 5'h18;
            end //if
            if ((ir_decode__addressing_mode==4'hb))
            begin
                useq_decode__next_cycle__var = 5'h17;
            end //if
            end
        5'h17: // req 1
            begin
            useq_decode__next_cycle__var = 5'h18;
            end
        5'h18: // req 1
            begin
            useq_decode__pc_op__var = 3'h4;
            useq_decode__next_cycle__var = 5'hf;
            if ((ir_decode__addressing_mode==4'hb))
            begin
                useq_decode__next_cycle__var = 5'h1;
            end //if
            end
        5'he: // req 1
            begin
            useq_decode__pc_op__var = 3'h4;
            useq_decode__next_cycle__var = 5'hf;
            end
        5'hf: // req 1
            begin
            useq_decode__pc_op__var = 3'h1;
            useq_decode__next_cycle__var = 5'h10;
            if ((state__ir==8'h60))
            begin
                useq_decode__next_cycle__var = 5'h1;
            end //if
            end
        5'h10: // req 1
            begin
            useq_decode__pc_op__var = 3'h4;
            useq_decode__next_cycle__var = 5'h1;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:cpu6502:microsequencer_decode: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        if ((ir_fetch_brk!=1'h0))
        begin
            useq_decode__pc_op__var = 3'h0;
        end //if
        useq_decode__src_enable = useq_decode__src_enable__var;
        useq_decode__ids_enable = useq_decode__ids_enable__var;
        useq_decode__ids_op = useq_decode__ids_op__var;
        useq_decode__add_a_in_op = useq_decode__add_a_in_op__var;
        useq_decode__add_b_in_op = useq_decode__add_b_in_op__var;
        useq_decode__alu_op = useq_decode__alu_op__var;
        useq_decode__dl_src = useq_decode__dl_src__var;
        useq_decode__src_write_enable = useq_decode__src_write_enable__var;
        useq_decode__mem_request__enable = useq_decode__mem_request__enable__var;
        useq_decode__mem_request__read_not_write = useq_decode__mem_request__read_not_write__var;
        useq_decode__mem_request__address = useq_decode__mem_request__address__var;
        useq_decode__mem_data_src = useq_decode__mem_data_src__var;
        useq_decode__next_cycle = useq_decode__next_cycle__var;
        useq_decode__last_cycle = useq_decode__last_cycle__var;
        useq_decode__pc_op = useq_decode__pc_op__var;
    end //always

    //b datapath combinatorial process
        //   Data path - drive buses, perform shift, inc/dec, ALU operations
    always @( //datapath
        useq_decode__src_enable or
        state__acc or
        state__x or
        state__y or
        state__sp or
        state__pcl or
        state__pch or
        state__psr__n or
        state__psr__v or
        ir_decode__addressing_mode or
        state__interrupt_reason or
        state__psr__d or
        state__psr__i or
        state__psr__z or
        state__psr__c or
        useq_decode__ids_enable or
        state__dl or
        state__cycle or
        ir_decode__alu_carry_in_zero or
        ir_decode__alu_carry_in_one or
        useq_decode__ids_op or
        useq_decode__add_a_in_op or
        useq_decode__add_b_in_op or
        useq_decode__alu_op or
        state__ir or
        useq_decode__mem_data_src )
    begin: datapath__comb_code
    reg [7:0]data_path__src_data__var;
    reg [15:0]data_path__ids_data_in__var;
    reg data_path__carry_in__var;
    reg [15:0]data_path__ids_data_out__var;
    reg [7:0]data_path__add_a_in__var;
    reg [7:0]data_path__add_b_in__var;
    reg [7:0]data_path__add_result__data__var;
    reg data_path__add_result__carry__var;
    reg data_path__add_result__overflow__var;
    reg [7:0]data_path__logical_result__var;
    reg [7:0]data_path__result__data__var;
    reg data_path__result__carry__var;
    reg data_path__result__overflow__var;
    reg data_path__result__zero__var;
    reg data_path__result__negative__var;
    reg data_path__result__decimal__var;
    reg data_path__result__irq__var;
    reg [7:0]data_path__mem_data_out__var;
        data_path__src_data__var = 8'h0;
        if ((useq_decode__src_enable[0]!=1'h0))
        begin
            data_path__src_data__var = data_path__src_data__var | ~state__acc;
        end //if
        if ((useq_decode__src_enable[1]!=1'h0))
        begin
            data_path__src_data__var = data_path__src_data__var | ~state__x;
        end //if
        if ((useq_decode__src_enable[2]!=1'h0))
        begin
            data_path__src_data__var = data_path__src_data__var | ~state__y;
        end //if
        if ((useq_decode__src_enable[3]!=1'h0))
        begin
            data_path__src_data__var = data_path__src_data__var | ~state__sp;
        end //if
        if ((useq_decode__src_enable[6]!=1'h0))
        begin
            data_path__src_data__var = data_path__src_data__var | ~state__pcl;
        end //if
        if ((useq_decode__src_enable[7]!=1'h0))
        begin
            data_path__src_data__var = data_path__src_data__var | ~state__pch;
        end //if
        if ((useq_decode__src_enable[4]!=1'h0))
        begin
            data_path__src_data__var = data_path__src_data__var | ~{{{{{{{state__psr__n,state__psr__v},1'h0},(1'h1 & ((ir_decode__addressing_mode==4'h9) & (state__interrupt_reason==2'h3)))},state__psr__d},state__psr__i},state__psr__z},state__psr__c};
        end //if
        if ((useq_decode__src_enable[5]!=1'h0))
        begin
            data_path__src_data__var = data_path__src_data__var | 8'hff;
        end //if
        data_path__src_data__var = ~data_path__src_data__var;
        data_path__ids_data_in__var = 16'h0;
        data_path__carry_in__var = 1'h0;
        if (((state__cycle==5'h7)||(state__cycle==5'h2)))
        begin
            data_path__carry_in__var = state__psr__c;
            if ((ir_decode__alu_carry_in_zero!=1'h0))
            begin
                data_path__carry_in__var = 1'h0;
            end //if
            if ((ir_decode__alu_carry_in_one!=1'h0))
            begin
                data_path__carry_in__var = 1'h1;
            end //if
        end //if
        if ((useq_decode__ids_enable[0]!=1'h0))
        begin
            data_path__ids_data_in__var = data_path__ids_data_in__var | ~{state__pch,state__pcl};
        end //if
        if ((useq_decode__ids_enable[2]!=1'h0))
        begin
            data_path__ids_data_in__var = data_path__ids_data_in__var | ~{8'h1,state__sp};
        end //if
        if ((useq_decode__ids_enable[1]!=1'h0))
        begin
            data_path__ids_data_in__var = data_path__ids_data_in__var | ~{{7'h1,data_path__carry_in__var},data_path__src_data__var};
        end //if
        if ((useq_decode__ids_enable[3]!=1'h0))
        begin
            data_path__ids_data_in__var = data_path__ids_data_in__var | ~{state__pch,state__pch};
        end //if
        if ((useq_decode__ids_enable[4]!=1'h0))
        begin
            data_path__ids_data_in__var = data_path__ids_data_in__var | ~{{7'h1,data_path__carry_in__var},state__dl};
        end //if
        data_path__ids_data_in__var = ~data_path__ids_data_in__var;
        data_path__ids_data_out__var = data_path__ids_data_in__var;
        case (useq_decode__ids_op) //synopsys parallel_case
        3'h7: // req 1
            begin
            data_path__ids_data_out__var = {data_path__ids_data_in__var[15:8],(data_path__ids_data_in__var[7:0]+8'h1)};
            end
        3'h6: // req 1
            begin
            data_path__ids_data_out__var = {data_path__ids_data_in__var[15:8],(data_path__ids_data_in__var[7:0]-8'h1)};
            end
        3'h0: // req 1
            begin
            data_path__ids_data_out__var = {{data_path__ids_data_in__var[14:8],data_path__ids_data_in__var[7:0]},1'h0};
            end
        3'h1: // req 1
            begin
            data_path__ids_data_out__var = {{data_path__ids_data_in__var[14:8],data_path__ids_data_in__var[7:0]},data_path__ids_data_in__var[8]};
            end
        3'h2: // req 1
            begin
            data_path__ids_data_out__var = {{{data_path__ids_data_in__var[14:8],data_path__ids_data_in__var[0]},1'h0},data_path__ids_data_in__var[7:1]};
            end
        3'h3: // req 1
            begin
            data_path__ids_data_out__var = {{data_path__ids_data_in__var[14:8],data_path__ids_data_in__var[0]},data_path__ids_data_in__var[8:1]};
            end
        default: // req 1
            begin
            data_path__ids_data_out__var = data_path__ids_data_in__var;
            end
        endcase
        data_path__add_carry_in = data_path__ids_data_out__var[8];
        data_path__add_a_in__var = data_path__src_data__var;
        case (useq_decode__add_a_in_op) //synopsys parallel_case
        2'h1: // req 1
            begin
            data_path__add_a_in__var = data_path__src_data__var;
            end
        2'h2: // req 1
            begin
            data_path__add_a_in__var = 8'h0;
            end
        2'h0: // req 1
            begin
            data_path__add_a_in__var = state__pcl;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:cpu6502:datapath: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        data_path__add_b_in__var = state__dl;
        case (useq_decode__add_b_in_op) //synopsys parallel_case
        2'h0: // req 1
            begin
            data_path__add_b_in__var = state__dl;
            end
        2'h1: // req 1
            begin
            data_path__add_b_in__var = data_path__ids_data_out__var[7:0];
            end
        2'h2: // req 1
            begin
            data_path__add_b_in__var = ~data_path__ids_data_out__var[7:0];
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:cpu6502:datapath: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        data_path__add_sum_lower = (({1'h0,data_path__add_a_in__var[6:0]}+{1'h0,data_path__add_b_in__var[6:0]})+{7'h0,data_path__add_carry_in});
        data_path__add_sum_higher = (({1'h0,data_path__add_a_in__var[7]}+{1'h0,data_path__add_b_in__var[7]})+{1'h0,data_path__add_sum_lower[7]});
        data_path__add_result__data__var = 8'h0;
        data_path__add_result__carry__var = 1'h0;
        data_path__add_result__overflow__var = 1'h0;
        data_path__add_result__zero = 1'h0;
        data_path__add_result__negative = 1'h0;
        data_path__add_result__irq = 1'h0;
        data_path__add_result__decimal = 1'h0;
        data_path__add_result__data__var = {data_path__add_sum_higher[0],data_path__add_sum_lower[6:0]};
        data_path__add_result__carry__var = data_path__add_sum_higher[1];
        data_path__add_result__overflow__var = (((data_path__add_a_in__var[7] & data_path__add_b_in__var[7]) & !(data_path__add_sum_higher[0]!=1'h0)) | ((!(data_path__add_a_in__var[7]!=1'h0) & !(data_path__add_b_in__var[7]!=1'h0)) & data_path__add_sum_higher[0]));
        data_path__logical_result__var = state__dl;
        case (useq_decode__alu_op) //synopsys parallel_case
        4'h4: // req 1
            begin
            data_path__logical_result__var = data_path__add_a_in__var;
            end
        4'h1: // req 1
            begin
            data_path__logical_result__var = (data_path__add_a_in__var & data_path__add_b_in__var);
            end
        4'h2: // req 1
            begin
            data_path__logical_result__var = (data_path__add_a_in__var & data_path__add_b_in__var);
            end
        4'h0: // req 1
            begin
            data_path__logical_result__var = (data_path__add_a_in__var | data_path__add_b_in__var);
            end
        4'h3: // req 1
            begin
            data_path__logical_result__var = (data_path__add_a_in__var ^ data_path__add_b_in__var);
            end
        //synopsys  translate_off
        //pragma coverage off
        //synopsys  translate_on
        default:
            begin
            //Need a default case to make Cadence Lint happy, even though this is not a full case
            end
        //synopsys  translate_off
        //pragma coverage on
        //synopsys  translate_on
        endcase
        data_path__result__data__var = data_path__add_result__data__var;
        data_path__result__carry__var = data_path__add_result__carry__var;
        data_path__result__overflow__var = data_path__add_result__overflow__var;
        data_path__result__zero__var = (data_path__add_result__data__var==8'h0);
        data_path__result__negative__var = data_path__add_result__data__var[7];
        data_path__result__decimal__var = state__psr__d;
        data_path__result__irq__var = state__psr__i;
        case (useq_decode__alu_op) //synopsys parallel_case
        4'h5: // req 1
            begin
            data_path__result__data__var = data_path__ids_data_out__var[7:0];
            data_path__result__carry__var = data_path__ids_data_out__var[8];
            data_path__result__overflow__var = state__psr__v;
            data_path__result__zero__var = (data_path__ids_data_out__var[7:0]==8'h0);
            data_path__result__negative__var = data_path__ids_data_out__var[7];
            if ((state__ir==8'h28))
            begin
                data_path__result__negative__var = data_path__ids_data_out__var[7];
                data_path__result__overflow__var = data_path__ids_data_out__var[6];
                data_path__result__decimal__var = data_path__ids_data_out__var[3];
                data_path__result__irq__var = data_path__ids_data_out__var[2];
                data_path__result__zero__var = data_path__ids_data_out__var[1];
                data_path__result__carry__var = data_path__ids_data_out__var[0];
            end //if
            end
        4'h8: // req 1
            begin
            data_path__result__overflow__var = state__psr__v;
            end
        4'h3: // req 1
            begin
            data_path__result__data__var = data_path__logical_result__var;
            data_path__result__carry__var = data_path__add_carry_in;
            data_path__result__overflow__var = state__psr__v;
            data_path__result__zero__var = (data_path__logical_result__var==8'h0);
            data_path__result__negative__var = data_path__logical_result__var[7];
            end
        4'h1: // req 1
            begin
            data_path__result__data__var = data_path__logical_result__var;
            data_path__result__carry__var = data_path__add_carry_in;
            data_path__result__overflow__var = state__psr__v;
            data_path__result__zero__var = (data_path__logical_result__var==8'h0);
            data_path__result__negative__var = data_path__logical_result__var[7];
            end
        4'h0: // req 1
            begin
            data_path__result__data__var = data_path__logical_result__var;
            data_path__result__carry__var = data_path__add_carry_in;
            data_path__result__overflow__var = state__psr__v;
            data_path__result__zero__var = (data_path__logical_result__var==8'h0);
            data_path__result__negative__var = data_path__logical_result__var[7];
            end
        4'h2: // req 1
            begin
            data_path__result__data__var = data_path__logical_result__var;
            data_path__result__carry__var = data_path__add_carry_in;
            data_path__result__overflow__var = data_path__add_b_in__var[6];
            data_path__result__zero__var = (data_path__logical_result__var==8'h0);
            data_path__result__negative__var = data_path__add_b_in__var[7];
            end
        4'h9: // req 1
            begin
            data_path__result__data__var = data_path__add_a_in__var;
            data_path__result__carry__var = state__psr__c;
            data_path__result__overflow__var = state__psr__v;
            data_path__result__zero__var = state__psr__z;
            data_path__result__negative__var = state__psr__n;
            if ((state__ir==8'h18))
            begin
                data_path__result__carry__var = 1'h0;
            end //if
            if ((state__ir==8'h38))
            begin
                data_path__result__carry__var = 1'h1;
            end //if
            if ((state__ir==8'h58))
            begin
                data_path__result__irq__var = 1'h0;
            end //if
            if ((state__ir==8'h78))
            begin
                data_path__result__irq__var = 1'h1;
            end //if
            if ((state__ir==8'hb8))
            begin
                data_path__result__overflow__var = 1'h0;
            end //if
            if ((state__ir==8'hd8))
            begin
                data_path__result__decimal__var = 1'h0;
            end //if
            if ((state__ir==8'hf8))
            begin
                data_path__result__decimal__var = 1'h1;
            end //if
            end
        //synopsys  translate_off
        //pragma coverage off
        //synopsys  translate_on
        default:
            begin
            //Need a default case to make Cadence Lint happy, even though this is not a full case
            end
        //synopsys  translate_off
        //pragma coverage on
        //synopsys  translate_on
        endcase
        data_path__mem_data_out__var = data_path__src_data__var;
        case (useq_decode__mem_data_src) //synopsys parallel_case
        2'h0: // req 1
            begin
            data_path__mem_data_out__var = data_path__src_data__var;
            end
        2'h1: // req 1
            begin
            data_path__mem_data_out__var = state__pcl;
            end
        2'h2: // req 1
            begin
            data_path__mem_data_out__var = state__pch;
            end
        2'h3: // req 1
            begin
            data_path__mem_data_out__var = state__dl;
            end
    //synopsys  translate_off
    //pragma coverage off
        default:
            begin
                if (1)
                begin
                    $display("%t *********CDL ASSERTION FAILURE:cpu6502:datapath: Full switch statement did not cover all values", $time);
                end
            end
    //pragma coverage on
    //synopsys  translate_on
        endcase
        data_path__src_data = data_path__src_data__var;
        data_path__ids_data_in = data_path__ids_data_in__var;
        data_path__carry_in = data_path__carry_in__var;
        data_path__ids_data_out = data_path__ids_data_out__var;
        data_path__add_a_in = data_path__add_a_in__var;
        data_path__add_b_in = data_path__add_b_in__var;
        data_path__add_result__data = data_path__add_result__data__var;
        data_path__add_result__carry = data_path__add_result__carry__var;
        data_path__add_result__overflow = data_path__add_result__overflow__var;
        data_path__logical_result = data_path__logical_result__var;
        data_path__result__data = data_path__result__data__var;
        data_path__result__carry = data_path__result__carry__var;
        data_path__result__overflow = data_path__result__overflow__var;
        data_path__result__zero = data_path__result__zero__var;
        data_path__result__negative = data_path__result__negative__var;
        data_path__result__decimal = data_path__result__decimal__var;
        data_path__result__irq = data_path__result__irq__var;
        data_path__mem_data_out = data_path__mem_data_out__var;
    end //always

endmodule // cpu6502
