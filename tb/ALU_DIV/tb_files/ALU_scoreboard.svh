`uvm_analysis_imp_decl(_alu_mon)

class alu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alu_scoreboard)
     uvm_analysis_imp_alu_mon #(alu_seq_item, alu_scoreboard) sc_analysis_imp;
    alu_seq_item seq_item_mon_out_q[$], seq_item_model_q[$];
//==============================================================================
//Description: function new
//==============================================================================
    function new(string name = "alu_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction
//==============================================================================
//Description: build_phase
//==============================================================================
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sc_analysis_imp = new("sc_analysis_imp", this);
    endfunction
//==============================================================================
//Description: write function
//==============================================================================
    function void write_alu_mon(alu_seq_item alu_seq_item);
        if(alu_seq_item.in_out == 1'b0) begin:inp_transaction
            `uvm_info(get_type_name(), $sformatf("ALU Scoreboard: Received input transaction: %s", alu_seq_item.convert2string()), UVM_MEDIUM);
            Model(alu_seq_item);
        end
        else begin:out_transaction
        `uvm_info(get_type_name(), $sformatf("ALU Scoreboard: Received output transaction: %s", alu_seq_item.convert2string()), UVM_MEDIUM);
         seq_item_mon_out_q.push_back(alu_seq_item);
        end
        endfunction:write_alu_mon    
//==============================================================================
//Description: model_function
//==============================================================================
 function void Model(alu_seq_item trans);
       alu_seq_item trans_model = alu_seq_item::type_id::create("trans_model");
       if(!trans.rst_n)begin
            trans.result_o = 0;
            trans.comparison_result_o = 0;
            trans.ready_o = 1;
       end 
       else begin
			trans_model.operand_a_i = trans.operand_a_i;
			trans_model.operand_b_i = trans.operand_b_i;
			trans_model.operator_i = trans.operator_i;
			trans_model.enable_i = trans.enable_i;
			trans_model.ex_ready_i = trans.ex_ready_i;
			trans_model.rst_n = trans.rst_n;
            case(trans.operator_i)
            ALU_ADD:begin
                trans_model.result_o = trans.operand_a_i + trans.operand_b_i;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                trans_model.op_type = 1;
            end
            ALU_SUB:begin
                trans_model.result_o = trans.operand_a_i - trans.operand_b_i;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                trans_model.op_type = 1;
            end
            ALU_ADDU:begin
                trans_model.result_o = trans.operand_a_i + trans.operand_b_i;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
            end
            ALU_SUBU:begin
                 trans_model.result_o = trans.operand_a_i - trans.operand_b_i;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
            end
            ALU_XOR:begin
                trans_model.result_o = trans.operand_a_i ^ trans.operand_b_i;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
            end
            ALU_OR:begin
                trans_model.result_o = trans.operand_a_i | trans.operand_b_i;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
            end
            ALU_AND:begin
                trans_model.result_o = trans.operand_a_i & trans.operand_b_i;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
            end
            ALU_SRA:begin
              trans_model.result_o = $signed(trans.operand_a_i) >>> trans.operand_b_i[4:0];
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
            end
            ALU_SRL:begin
              trans_model.result_o = trans.operand_a_i >> trans.operand_b_i[4:0];
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
            end
            ALU_SLL:begin
              trans_model.result_o = trans.operand_a_i << trans.operand_b_i[4:0];
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
            end
            ALU_LTS:begin
                if($signed(trans.operand_a_i ) < $signed(trans.operand_b_i))begin
                trans_model.result_o = 32'hffff_ffff;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                trans_model.op_type = 1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end
            end
            ALU_LTU:begin
                if(trans.operand_a_i  < trans.operand_b_i)begin
                trans_model.result_o = 32'hffff_ffff;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end 
            end
            ALU_LES:begin
                if($signed(trans.operand_a_i ) <= $signed(trans.operand_b_i))begin
                trans_model.result_o = 32'hffff_ffff;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                trans_model.op_type = 1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end
            end
            ALU_LEU:begin
                 if(trans.operand_a_i  <= trans.operand_b_i)begin
                trans_model.result_o = 32'hffff_ffff;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end 
            end
            ALU_GTS:begin
                if($signed(trans.operand_a_i ) > $signed(trans.operand_b_i))begin
                trans_model.result_o = 32'hffff_ffff;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                trans_model.op_type = 1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end
            end
            ALU_GTU:begin
                if(trans.operand_a_i  > trans.operand_b_i)begin
                trans_model.result_o = 32'hffff_ffff;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end 
            end
            ALU_GES:begin
                if($signed(trans.operand_a_i ) >= $signed(trans.operand_b_i))begin
                trans_model.result_o = 32'hffff_ffff;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                trans_model.op_type = 1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end
            end
            ALU_GEU:begin
                if(trans.operand_a_i  >= trans.operand_b_i)begin
                trans_model.result_o = 32'hffff_ffff;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end 
            end
            ALU_EQ:begin
                if(trans.operand_a_i  == trans.operand_b_i)begin
                trans_model.result_o = 32'hffff_ffff;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end
            end
            ALU_NE:begin
                if(trans.operand_a_i  != trans.operand_b_i)begin
                trans_model.result_o = 32'hffff_ffff;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end
            end
            ALU_SLTS:begin
                if($signed(trans.operand_a_i ) < $signed(trans.operand_b_i))begin
                trans_model.result_o = 1;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                trans_model.op_type = 1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end
            end
            ALU_SLTU:begin
                 if(trans.operand_a_i < trans.operand_b_i)begin
                trans_model.result_o = 1;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end 
            end
            ALU_SLETS:begin
                if($signed(trans.operand_a_i ) <= $signed(trans.operand_b_i))begin
                trans_model.result_o = 1;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                trans_model.op_type = 1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end
            end
            ALU_SLETU:begin
                if(trans.operand_a_i <= trans.operand_b_i)begin
                trans_model.result_o = 1;
                trans_model.comparison_result_o  = 1'b1;
                trans_model.ready_o = 1'b1;
                end
                else begin
                trans_model.result_o = 0;
                trans_model.comparison_result_o  = 1'b0;
                trans_model.ready_o = 1'b1;
                end 
            end
            ALU_DIVU:begin
		trans_model.result_o =  trans.operand_b_i / trans.operand_a_i ;
                trans_model.ready_o = 1'b1;
		trans_model.comparison_result_o  = 1'b0;
		end
            ALU_DIV:begin
		trans_model.result_o =  $signed(trans.operand_b_i) / $signed(trans.operand_a_i) ;
                trans_model.ready_o = 1'b1;
		trans_model.comparison_result_o  = 1'b0;
                end
            ALU_REMU:begin
		trans_model.result_o =  trans.operand_b_i % trans.operand_a_i ;
                trans_model.ready_o = 1'b1;
		trans_model.comparison_result_o  = 1'b0;
                end
            ALU_REM:begin
		trans_model.result_o = $signed(trans.operand_b_i) % $signed(trans.operand_a_i) ;
                trans_model.ready_o = 1'b1;
		trans_model.comparison_result_o  = 1'b0;
                end
            default:begin
                `uvm_fatal(get_type_name(), $sformatf("ALU Scoreboard: Invalid operation code:%p",trans.operator_i));
            end
            endcase
            
            seq_item_model_q.push_back(trans_model);
       end
    endfunction:Model

//==============================================================================
//Description: function compare
//==============================================================================
function void check_phase(uvm_phase phase);
    int trans_ID = 0;
    super.check_phase(phase);
    forever begin
        // $display("the value of seq_item_mon_out_q.size :%0d ,seq_item_model_q.size :%0d",seq_item_mon_out_q.size(),seq_item_model_q.size());
        // $stop;
     if(seq_item_mon_out_q.size() > 0) begin
        if(seq_item_mon_out_q[0].compare(seq_item_model_q[0]))begin
            `uvm_info(get_type_name(), $sformatf("ALU Scoreboard: Comparison result: %s", "PASS"), UVM_NONE);
        end
        else begin
           // seq_item_model_q[0].print();
            `uvm_info(get_type_name(), $sformatf("ALU Scoreboard: Comparison model result: %s",seq_item_model_q[0].convert2string()), UVM_NONE);
            `uvm_info(get_type_name(), $sformatf("ALU Scoreboard: Comparison mon_out result: %s",seq_item_mon_out_q[0].convert2string()), UVM_NONE);
            
           // seq_item_mon_out_q[0].print();
            `uvm_error(get_type_name(), $sformatf("ALU Scoreboard: Comparison result: %s with ID :%0d", "FAIL",trans_ID));
            // $stop;
           
        end
    end
        else break;

        trans_ID++;
        seq_item_mon_out_q.delete(0);
        seq_item_model_q.delete(0);
     end
endfunction:check_phase
endclass
