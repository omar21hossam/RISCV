`timescale 1ns / 1ps
interface alu_if (
    input bit core_clk
);
  import cv32e40p_pkg::*;
  //==============================================
  //Description: Interface signals
  //==============================================
  logic        rst_n;
  logic        enable_i;  //ALU enable signal  [used on DIV module]***
  alu_opcode_e operator_i;  //ALU operation
  logic        ex_ready_i;  //EX stage ready for next result  [used on DIV module]***
  logic [31:0] operand_a_i, operand_b_i;  //input operands
  logic [ 1:0] vector_mode_i;
  //-------------------------------------------------------------------
  logic [31:0] result_o;  //output result
  logic        comparison_result_o;  //Comparison result(e.g.,for SLT)
  logic        ready_o;  //Result valid/ready handshake to EX stage [used on DIV module]***

  //==============================================
  //Description: Clocking block
  //==============================================
  clocking cb @(posedge core_clk);
    default input #2ns output #2ns;  //this direction related to the testbench
    output enable_i, operator_i, ex_ready_i;
    output operand_a_i, operand_b_i;
    input result_o, comparison_result_o, ready_o;
  endclocking : cb
  //==============================================
  //Description:  sequences
  //==============================================
  sequence comp_op_code;
    (operator_i == (ALU_LTS || ALU_LTU || ALU_GES || ALU_GEU || ALU_EQ || ALU_NE || ALU_SLETS || ALU_SLTU));
  endsequence

  sequence non_comp_op_code;
    (operator_i == ALU_ADD) or
    (operator_i == ALU_SUB) or
    (operator_i == ALU_OR)  or
    (operator_i == ALU_XOR) or
    (operator_i == ALU_SRA) or
    (operator_i == ALU_SRL) or
    (operator_i == ALU_SLL);
  endsequence

  sequence non_comp_op_code_antecedent; //this sequence is used to check the comparison result in case equal operands and non comparison operation
    non_comp_op_code and(operand_a_i == operand_b_i);
  endsequence

  sequence div_rem_antecedent;  //this sequence is used to check the div/rem operation
    (operator_i == (ALU_DIV || ALU_REM || ALU_DIVU || ALU_REMU));
  endsequence

  sequence stable_inps;
    ($stable(
        operator_i
    ) && $stable(
        operand_a_i
    ) && $stable(
        operand_b_i
    ));
  endsequence
  //==============================================
  //Description: Assertions 
  //==============================================
  //control properties:

  property enable_i_check_0; //this property is used to check the enable_i signal for all one cycle operations [in all cases is to be 1]
    @(posedge core_clk) disable iff(!rst_n) (!(operator_i == (ALU_DIV || ALU_REM || ALU_DIVU || ALU_REMU)) && ($changed(
        operator_i
    ) || $changed(
        operand_a_i
    ) || $changed(
        operand_b_i
    ))) |-> (enable_i == 1);
  endproperty

  property enable_i_check_1; //this property is used to check the enable_i signal for all one cycle operations [in all cases is to be falling edge]
    @(posedge core_clk) disable iff(!rst_n || ex_ready_i)  ((comp_op_code or non_comp_op_code) and stable_inps) |-> (enable_i == 0);
  endproperty

  property ready_o_non_comp_check; //this property is used to check ready_o signal for all one cycle operations is asserted
    @(posedge core_clk) disable iff (!rst_n) (comp_op_code or non_comp_op_code) |-> (ready_o == 1);
  endproperty
  //!(operator_i == (ALU_DIV || ALU_REM || ALU_DIVU || ALU_REMU)) 
  property comp_result_eq_operands;  //this property is used to check the comparison result in case equal operands non comparison operation
    @(posedge core_clk) disable iff(!rst_n) (non_comp_op_code_antecedent) |-> ##0 (comparison_result_o);
  endproperty
  //==============================================
  //Timing check properties:
  property ADD_t;  //this property is used to check the ALU ADD operation timing
    @(posedge core_clk) disable iff (!rst_n && !enable_i) (operator_i == ALU_ADD) |-> ($signed(
        result_o
    ) == $signed(
        operand_a_i + operand_b_i
    ) && (ready_o == 1));
  endproperty

  property SUB_t;  //this property is used to check the ALU SUB operation timing
    @(posedge core_clk) disable iff (!rst_n && !enable_i) (operator_i == ALU_SUB) |-> ($signed(
        result_o
    ) == $signed(
        operand_a_i - operand_b_i
    ) && (ready_o == 1));
  endproperty

  property XOR_t;  //this property is used to check the ALU XOR operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (operator_i == ALU_XOR) |-> (result_o == (operand_a_i ^ operand_b_i) && (ready_o == 1));
  endproperty

  property OR_t;  //this property is used to check the ALU OR operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (operator_i == ALU_OR) |-> (result_o == (operand_a_i | operand_b_i) && (ready_o == 1));
  endproperty

  property AND_t;  //this property is used to check the ALU AND operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (operator_i == ALU_AND) |-> (result_o == (operand_a_i & operand_b_i) && (ready_o == 1));
  endproperty

  property SRA_t;  //this property is used to check the ALU SRA operation timing
    @(posedge core_clk) disable iff (!rst_n && !enable_i) (operator_i == ALU_SRA) |-> (($signed(
        result_o
    ) == ($signed(
        operand_a_i
    ) >>> operand_b_i[4:0])) && (ready_o == 1));
  endproperty

  property SRL_t;  //this property is used to check the ALU SRL operation timing
    @(posedge core_clk) disable iff (!rst_n && !enable_i) (operator_i == ALU_SRL) |-> ($signed(
        result_o
    ) == ($signed(
        operand_a_i >> operand_b_i[4:0]
    )) && (ready_o == 1));
  endproperty

  property SLL_t;  //this property is used to check the ALU SLL operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (operator_i == ALU_SLL) |-> (result_o == (operand_a_i << operand_b_i[4:0]) && (ready_o == 1));
  endproperty

  property LTS_t;  //this property is used to check the ALU LTS operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (enable_i && (operator_i == ALU_LTS) &&($signed(
        operand_a_i
    ) < $signed(
        operand_b_i
    ))) |-> ((result_o == 32'hffff_ffff) && (comparison_result_o == 1) && (ready_o == 1));
  endproperty

  property LTU_t;  //this property is used to check the ALU LTU operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (enable_i && (operator_i == ALU_LTU) &&(operand_a_i < operand_b_i)) |-> ((result_o == 32'hffff_ffff) && (comparison_result_o ==1) && (ready_o == 1));
  endproperty

  property GES_t;  //this property is used to check the ALU GES operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (enable_i && (operator_i == ALU_GES) &&($signed(
        operand_a_i
    ) >= $signed(
        operand_b_i
    ))) |-> ((result_o == 32'hffff_ffff) && (comparison_result_o == 1) && (ready_o == 1));
  endproperty

  property GEU_t;  //this property is used to check the ALU GEU operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (enable_i && (operator_i == ALU_GEU) &&(operand_a_i >= operand_b_i)) |-> ((result_o == 32'hffff_ffff) && (comparison_result_o ==1) && (ready_o == 1));
  endproperty

  property EQ_t;  //this property is used to check the ALU EQ operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (enable_i && (operator_i == ALU_EQ) &&(operand_a_i == operand_b_i)) |-> ((result_o == 32'hffff_ffff) && (comparison_result_o ==1) && (ready_o == 1));
  endproperty

  property NE_t;  //this property is used to check the ALU NE operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (enable_i && (operator_i == ALU_NE) &&(operand_a_i != operand_b_i)) |-> ((result_o == 32'hffff_ffff) && (comparison_result_o ==1) && (ready_o == 1));
  endproperty

  property SLTS_t;  //this property is used to check the ALU SLTS operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (enable_i && (operator_i == ALU_SLTS) &&($signed(
        operand_a_i
    ) < $signed(
        operand_b_i
    ))) |-> ((result_o == 1) && (comparison_result_o == 1) && (ready_o == 1));
  endproperty

  property SLTU_t;  //this property is used to check the ALU SLTU operation timing
    @(posedge core_clk) disable iff(!rst_n && !enable_i) (enable_i && (operator_i == ALU_SLTU) &&(operand_a_i < operand_b_i)) |-> ((result_o == 1) && (comparison_result_o ==1) && (ready_o == 1));
  endproperty
  //======================================================================================
  //Description: control Assertions 
  A1_Label :
  assert property (comp_result_eq_operands);
  A2_Label :
  assert property (enable_i_check_0);
  // A3_Label :
  // assert property (enable_i_check_1);
  A4_Label :
  assert property (ready_o_non_comp_check);

  //==============================================
  //Timing check Assertions:
  //Note: no need to cover this properties as it is already covered in the alu coverage collector class
  A5_Label :
  assert property (ADD_t);
  A6_Label :
  assert property (SUB_t);
  A7_Label :
  assert property (XOR_t);
  A8_Label :
  assert property (OR_t);
  A9_Label :
  assert property (AND_t);
  A10_Label :
  assert property (SRA_t);
  // else begin
  //   $display("SRA_t property is not valid");
  //   $display("the value of inp_a_i is %32b", operand_a_i);
  //   $display("the value of inp_b_i is %32b", operand_b_i);
  //   $display("the value of result_o is %32b", result_o);
  //   $display("the value of accuale output %32b",$signed(operand_a_i )>>> operand_b_i[4:0]);
  //   $display("the value of comparison_result_o is %h", comparison_result_o);
  //   $display("the value of operator_i is %s", operator_i);
  //   $stop;
  // end 
  A11_Label :
  assert property (SRL_t);
  A12_Label :
  assert property (SLL_t);
  A13_Label :
  assert property (LTS_t);
  A14_Label :
  assert property (LTU_t);
  A15_Label :
  assert property (GES_t);
  A16_Label :
  assert property (GEU_t);
  A17_Label :
  assert property (EQ_t);
  A18_Label :
  assert property (NE_t);
  A19_Label :
  assert property (SLTS_t);
  A20_Label :
  assert property (SLTU_t);
  //==============================================
  //cover properties:
  cover property (comp_result_eq_operands);
  cover property (enable_i_check_0);
  // cover property (enable_i_check_1);
  cover property (ready_o_non_comp_check);

endinterface : alu_if


//==============================================================================
//Description: needed op-codes for ALU operations
//==============================================================================
/*
  parameter ALU_OP_WIDTH = 7;
  typedef enum logic [ALU_OP_WIDTH-1:0] {

    ALU_ADD   = 7'b0011000,
    ALU_SUB   = 7'b0011001,

    ALU_XOR = 7'b0101111,
    ALU_OR  = 7'b0101110,
    ALU_AND = 7'b0010101,

    // Shifts
    ALU_SRA = 7'b0100100,
    ALU_SRL = 7'b0100101,
    ALU_SLL = 7'b0100111,

    // Comparisons
    ALU_LTS = 7'b0000000,
    ALU_LTU = 7'b0000001,
    ALU_GES = 7'b0001010,
    ALU_GEU = 7'b0001011,
    ALU_EQ  = 7'b0001100,
    ALU_NE  = 7'b0001101,

    // Set Lower Than operations
    ALU_SLTS  = 7'b0000010,  //output = 1 and comprision_result_o = 1
    ALU_SLTS  = 7'b0000010,  //output = 1 and comprision_result_o = 1
    ALU_SLTU  = 7'b0000011,

   if both operands equals then comprision_result_o = 1
   if both operands equals then comprision_result_o = 1
//**************
//OSAMA OP-CODES
//***************
    // div/rem
    ALU_DIVU = 7'b0110000,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    ALU_DIV  = 7'b0110001,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    ALU_REMU = 7'b0110010,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    ALU_REM  = 7'b0110011,  // bit 0 is used for signed mode, bit 1 is used for remdiv

  } alu_opcode_e;

  // vector modes
  parameter VEC_MODE32 = 2'b00;
  parameter VEC_MODE16 = 2'b10;
  parameter VEC_MODE8 = 2'b11;

*/
