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
  //==============================================
  //Description: Assertions and Covergroups
  //==============================================
endinterface : alu_if


//==============================================================================
//Description: needed op-codes for ALU operations
//==============================================================================
/*
  parameter ALU_OP_WIDTH = 7;
  typedef enum logic [ALU_OP_WIDTH-1:0] {

    ALU_ADD   = 7'b0011000,
    ALU_SUB   = 7'b0011001,
    ALU_ADDU  = 7'b0011010,
    ALU_SUBU  = 7'b0011011,

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
    ALU_LES = 7'b0000100,
    ALU_LEU = 7'b0000101,
    ALU_GTS = 7'b0001000,
    ALU_GTU = 7'b0001001,
    ALU_GES = 7'b0001010,
    ALU_GEU = 7'b0001011,
    ALU_EQ  = 7'b0001100,
    ALU_NE  = 7'b0001101,

    // Set Lower Than operations
    ALU_SLTS  = 7'b0000010,
    ALU_SLTU  = 7'b0000011,
    ALU_SLETS = 7'b0000110,
    ALU_SLETU = 7'b0000111,

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
