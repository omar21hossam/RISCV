interface ALU_interface(input bit core_clk);
import cv32e40p_pkg::*;
//==============================================
//Description: Interface signals
//==============================================
logic rst_n;              //Active low reset
logic enable_i;           //ALU enable signal  [used on DIV module]***
alu_opcode_e operator_i;  //ALU operation
logic signed ex_ready_i;  //EX stage ready for next result  [used on DIV module]***
logic signed [31:0] operand_a_i,operand_b_i;  //input operands
logic signed [31:0] result_o;				  //output result
logic comparison_result_o;					  //Comparison result(e.g.,for SLT)
logic ready_o;								  //Result valid/ready handshake to EX stage [used on DIV module]***

//==============================================
//Description: Clocking block
//==============================================
 clocking cb @(posedge sys_clk);
		default input #2ns output #2ns ; //this direction related to the testbench
		output rst_n ,enable_i ,operator_i ,ex_ready_i;
        output operand_a_i ,operand_b_i;
		input  result_o , comparison_result_o ,ready_o;
	endclocking:cb   
//==============================================
//Description: internal signals
//==============================================
//==============================================
//Description: Assertions and Covergroups
//==============================================
endinterface:ALU_interface