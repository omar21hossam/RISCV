`timescale 1ns/1ps
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
  //Description: internal signals
  //==============================================
  sequence comparison_result_antecedent; //this sequence is used to check the comparison result in case equal operands and non comparison operation
     (operator_i == (ALU_ADD || ALU_SUB || ALU_XOR || ALU_AND || ALU_SRA || ALU_SRL || ALU_SLL)) && (operand_a_i == operand_b_i);
  endsequence;
  //==============================================
  //Description: Assertions 
  //==============================================
  //properties:
  property comp_result_eq_operands;
    @(posedge core_clk) disable iff(!rst_n) (comparison_result_antecedent) |-> (comparison_result_o == 1);
  endproperty
   property ADD_t;  //this property is used to check the ALU ADD operation timing
    @(posedge core_clk) (operator_i == ALU_ADD) |-> ($signed(result_o) == $signed(operand_a_i + operand_b_i));
   endproperty

    property SUB_t;  //this property is used to check the ALU SUB operation timing
     @(posedge core_clk) (operator_i == ALU_SUB) |-> ($signed(result_o) == $signed(operand_a_i - operand_b_i));
    endproperty

    property XOR_t;  //this property is used to check the ALU XOR operation timing
     @(posedge core_clk) (operator_i == ALU_XOR) |-> (result_o == (operand_a_i ^ operand_b_i));
    endproperty

    property AND_t;  //this property is used to check the ALU ADD operation timing
     @(posedge core_clk) (operator_i == ALU_AND) |-> (result_o == (operand_a_i & operand_b_i));
    endproperty

    property SRA_t;  //this property is used to check the ALU ADD operation timing
     @(posedge core_clk) (operator_i == ALU_SRA) |-> (result_o == (operand_a_i >>> operand_b_i[4:0]));
    endproperty

    property SRL_t;  //this property is used to check the ALU ADD operation timing
     @(posedge core_clk) (operator_i == ALU_SRL) |-> (result_o == (operand_a_i >> operand_b_i[4:0]));
    endproperty

    property SLL_t;  //this property is used to check the ALU ADD operation timing
     @(posedge core_clk) (operator_i == ALU_SLL) |-> (result_o == (operand_a_i << operand_b_i[4:0]));
    endproperty

    property LTS_t;  //this property is used to check the ALU ADD operation timing
     @(posedge core_clk) ((operator_i == ALU_LTS) &&($signed(operand_a_i) < $signed(operand_b_i))) |-> ((result_o == 32'hffff_ffff) && (comparison_result_o ==1));
    endproperty

    property LTU_t;  //this property is used to check the ALU ADD operation timing
     @(posedge core_clk) ((operator_i == ALU_ADD) ) |-> (result_o == (operand_a_i + operand_b_i));
    endproperty

    // property GES_t;  //this property is used to check the ALU ADD operation timing
    //  @(posedge core_clk) (operator_i == ALU_ADD) |-> (result_o == (operand_a_i + operand_b_i));
    // endproperty

    // property GEU_t;  //this property is used to check the ALU ADD operation timing
    // @(posedge core_clk) (operator_i == ALU_ADD) |-> (result_o == (operand_a_i + operand_b_i));
    // endproperty

    // property EQ_t;  //this property is used to check the ALU ADD operation timing
    // @(posedge core_clk) (operator_i == ALU_ADD) |-> (result_o == (operand_a_i + operand_b_i));
    // endproperty

    // property NE_t;  //this property is used to check the ALU ADD operation timing
    // @(posedge core_clk) (operator_i == ALU_ADD) |-> (result_o == (operand_a_i + operand_b_i));
    // endproperty
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
    ALU_SLTU  = 7'b0000011,

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
