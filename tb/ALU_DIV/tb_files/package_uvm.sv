package package_uvm;
    import uvm_pkg::*;
    import cv32e40p_pkg::*;
    //==============================================================================
    //Description: enums and parameters
    //============================================================================== 
      alu_opcode_e req_alu_op[28] ={ALU_ADD, ALU_SUB, ALU_ADDU, ALU_SUBU, ALU_XOR, ALU_OR, ALU_AND, ALU_SRA, ALU_SRL, 
            ALU_SLL, ALU_LTS, ALU_LTU, ALU_LES, ALU_LEU,ALU_GTS , ALU_GTU, ALU_GES, ALU_GEU,
            ALU_EQ , ALU_NE , ALU_SLTS , ALU_SLTU , ALU_SLETS, ALU_SLETU,ALU_DIVU,
            ALU_DIV, ALU_REMU, ALU_REM};
    // parameter ALU_OP_WIDTH = 7;
    // typedef enum logic [ALU_OP_WIDTH-1:0] {

    //     ALU_ADD   = 7'b0011000,
    //     ALU_SUB   = 7'b0011001,
    //     ALU_ADDU  = 7'b0011010,
    //     ALU_SUBU  = 7'b0011011,

    //     ALU_XOR = 7'b0101111,
    //     ALU_OR  = 7'b0101110,
    //     ALU_AND = 7'b0010101,

    //     // Shifts
    //     ALU_SRA = 7'b0100100,
    //     ALU_SRL = 7'b0100101,
    //     ALU_SLL = 7'b0100111,

    //     // Comparisons
    //     ALU_LTS = 7'b0000000,
    //     ALU_LTU = 7'b0000001,
    //     ALU_LES = 7'b0000100,
    //     ALU_LEU = 7'b0000101,
    //     ALU_GTS = 7'b0001000,
    //     ALU_GTU = 7'b0001001,
    //     ALU_GES = 7'b0001010,
    //     ALU_GEU = 7'b0001011,
    //     ALU_EQ  = 7'b0001100,
    //     ALU_NE  = 7'b0001101,

    //     // Set Lower Than operations
    //     ALU_SLTS  = 7'b0000010,
    //     ALU_SLTU  = 7'b0000011,
    //     ALU_SLETS = 7'b0000110,
    //     ALU_SLETU = 7'b0000111,

    // //**************
    // //OSAMA OP-CODES
    // //***************
    //     // div/rem
    //     ALU_DIVU = 7'b0110000,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    //     ALU_DIV  = 7'b0110001,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    //     ALU_REMU = 7'b0110010,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    //     ALU_REM  = 7'b0110011 // bit 0 is used for signed mode, bit 1 is used for remdiv
    // } alu_opcode_enum;
    //==============================================================================
     `include "uvm_macros.svh"
     `include "alu_sequence_item.svh"
     `include "alu_sequence.svh"
     `include "alu_monitor.svh"
     `include "alu_driver.svh"
     `include "alu_sequencer.svh"
     `include "alu_agent.svh"
     `include "alu_scoreboard.svh"
     `include "alu_env.svh"
     `include "alu_test.svh"
endpackage : package_uvm