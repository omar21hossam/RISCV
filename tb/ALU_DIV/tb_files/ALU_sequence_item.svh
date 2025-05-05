class alu_seq_item extends uvm_sequence_item;
  `uvm_object_utils(alu_seq_item)
//============================================
// Declare the data members
//============================================
  rand alu_opcode_e operator_i; // ALU operation code
  rand logic [31:0] operand_a_i,operand_b_i; //  operands
  rand bit rst_n; // Active low reset signal
  rand logic   enable_i; // ALU enable signal
  rand logic   ex_ready_i; // EX stage ready for next result
  logic [1:0]  vector_mode_i = 2'b00; // Vector mode for 32-bit operations
  logic [31:0] result_o; // output result
  logic comparison_result_o; // Comparison result (e.g., for SLT)
  logic ready_o; // Result valid/ready handshake to EX stage
//============================================
//Declare internal signals
//============================================
  logic in_out;   //zero input to ALU, one output from ALU [between monitor and scoreboard]
  bit op_type;  //it is refer to the operation is signed or unsigned[signed = 1, unsigned = 0]
  //requested op-codes for ALU operations 
//==========================================
// Constructor
//==========================================
  function new(string name = "alu_seq_item");
    super.new(name);
  endfunction

//==========================================
//Description: constraints
//============================================
constraint opcode_values{
operator_i inside {req_alu_op};
}
  
constraint shifting_op{
  operator_i ==(ALU_SRA | ALU_SRL | ALU_SLL) -> operand_b_i[31] == 0 ;
}
//==========================================
//Description: extern methods
//==========================================
function string convert2string();
string str;
str = super.convert2string();
$sformat(str,"%s-->operator_i:%s, rst_n:%0b, enable_i:%0b, ex_ready_i:%0b, operand_a_i:%0h, operand_b_i:%0h, result_o:%0h ,comparison_result_o:%0b ,ready_o:%0b",
  str,operator_i,rst_n,enable_i,ex_ready_i,operand_a_i,operand_b_i,result_o,comparison_result_o,ready_o);
return str;
endfunction:convert2string
//==========================================
function void do_print(uvm_printer printer);
super.do_print(printer);
$display(convert2string());
endfunction:do_print
//==========================================
//function for collect all the possible op-codes
//==========================================
function bit do_compare(uvm_object rhs, uvm_comparer comparer);
alu_seq_item rhs_;
if(!$cast(rhs_,rhs)) begin
    `uvm_fatal("[trans_compare]", "Error in casting");
    return 0;
end
if(rhs_.op_type)begin
  return(super.do_compare(rhs_,comparer) && $signed(result_o) == $signed(rhs_.result_o) && 
      comparison_result_o ==rhs_.comparison_result_o && ready_o == rhs_.ready_o); //compare the input values
end
else begin
  return(super.do_compare(rhs_,comparer) && result_o == rhs_.result_o && 
      comparison_result_o ==rhs_.comparison_result_o && ready_o == rhs_.ready_o); //compare the output values
end



endfunction:do_compare
 
endclass : alu_seq_item
