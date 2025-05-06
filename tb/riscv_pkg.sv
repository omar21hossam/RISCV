package riscv_pkg;
  parameter int CLK_FREQ = 100;

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  //                                 ___                      _                                     //
  //                                / _ \ _ __   ___ ___   __| | ___  ___                           //
  //                               | | | | '_ \ / __/ _ \ / _` |/ _ \/ __|                          //
  //                               | |_| | |_) | (_| (_) | (_| |  __/\__ \                          //
  //                                \___/| .__/ \___\___/ \__,_|\___||___/                          //
  //                                     |_|                                                        //
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  typedef enum logic [6:0] {
    OPCODE_LUI    = 7'b0110111,  //  (55)  : LUI Instruction
    OPCODE_AUIPC  = 7'b0010111,  //  (23)  : AUIPC Instruction
    OPCODE_JAL    = 7'b1101111,  //  (111) : JAL Instruction
    OPCODE_JALR   = 7'b1100111,  //  (103) : JALR Instruction
    OPCODE_BRANCH = 7'b1100011,  //  (99)  : Branch Instructions
    OPCODE_LOAD   = 7'b0000011,  //  (3)   : Load instructions
    OPCODE_STORE  = 7'b0100011,  //  (35)  : Store Instructions
    OPCODE_OP_IMM = 7'b0010011,  //  (19)  : I-type instructions
    OPCODE_OP     = 7'b0110011   //  (51)  : R-type Instructions
  } opcode_e;

  typedef enum logic [2:0] {
    ADD_SUB = 3'b000,
    SLL     = 3'b001,
    SLT     = 3'b010,
    SLTU    = 3'b011,
    XOR     = 3'b100,
    SRL_SRA = 3'b101,
    OR      = 3'b110,
    AND     = 3'b111
  } r_funct3_e;

  typedef enum logic [2:0] {
    ADDI      = 3'b000,
    SLLI      = 3'b001,
    SLTI      = 3'b010,
    SLTIU     = 3'b011,
    XORI      = 3'b100,
    SRLI_SRAI = 3'b101,
    ORI       = 3'b110,
    ANDI      = 3'b111
  } i_funct3_e;


  typedef enum logic [2:0] {
    SB = 3'b000,
    SH = 3'b001,
    SW = 3'b010
  } s_funct3_e;

  typedef enum logic [2:0] {
    LB  = 3'b000,
    LH  = 3'b001,
    LW  = 3'b010,
    LBU = 3'b100,
    LHU = 3'b101
  } l_funct3_e;

  typedef enum logic [2:0] {
    BEQ  = 3'b000,
    BNE  = 3'b001,
    BLT  = 3'b100,
    BGE  = 3'b101,
    BLTU = 3'b110,
    BGEU = 3'b111
  } b_funct3_e;

  typedef enum logic [2:0] {JALR = 3'b000} j_funct3_e;

  typedef enum logic [7:0] {
    SUB_SRA = 7'b0100000,
    OTHER   = 7'b0000000
  } r_funct7_e;

  typedef enum logic [7:0] {
    SRAI  = 7'b0100000,
    OTHER = 7'b0000000
  } i_funct7_e;

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  //                                   _    _    _   _       ____ _____     __                      //
  //                                  / \  | |  | | | |     |  _ \_ _\ \   / /                      //
  //                                 / _ \ | |  | | | |     | | | | | \ \ / /                       //
  //                                / ___ \| |__| |_| |     | |_| | |  \ V /                        //
  //                               /_/   \_\_____\___/      |____/___|  \_/                         //
  ////////////////////////////////////////////////////////////////////////////////////////////////////


  parameter ALU_OP_WIDTH = 7;

  typedef enum logic [ALU_OP_WIDTH-1:0] {

    ALU_ADD   = 7'b0011000,
    ALU_SUB   = 7'b0011001,
    ALU_ADDU  = 7'b0011010,
    ALU_SUBU  = 7'b0011011,
    ALU_ADDR  = 7'b0011100,
    ALU_SUBR  = 7'b0011101,
    ALU_ADDUR = 7'b0011110,
    ALU_SUBUR = 7'b0011111,

    ALU_XOR = 7'b0101111,
    ALU_OR  = 7'b0101110,
    ALU_AND = 7'b0010101,

    // Shifts
    ALU_SRA = 7'b0100100,
    ALU_SRL = 7'b0100101,
    ALU_ROR = 7'b0100110,
    ALU_SLL = 7'b0100111,

    // bit manipulation
    ALU_BEXT  = 7'b0101000,
    ALU_BEXTU = 7'b0101001,
    ALU_BINS  = 7'b0101010,
    ALU_BCLR  = 7'b0101011,
    ALU_BSET  = 7'b0101100,
    ALU_BREV  = 7'b1001001,

    // Bit counting
    ALU_FF1 = 7'b0110110,
    ALU_FL1 = 7'b0110111,
    ALU_CNT = 7'b0110100,
    ALU_CLB = 7'b0110101,

    // Sign-/zero-extensions
    ALU_EXTS = 7'b0111110,
    ALU_EXT  = 7'b0111111,

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

    // Absolute value
    ALU_ABS   = 7'b0010100,
    ALU_CLIP  = 7'b0010110,
    ALU_CLIPU = 7'b0010111,

    // Insert/extract
    ALU_INS = 7'b0101101,

    // min/max
    ALU_MIN  = 7'b0010000,
    ALU_MINU = 7'b0010001,
    ALU_MAX  = 7'b0010010,
    ALU_MAXU = 7'b0010011,

    // div/rem
    ALU_DIVU = 7'b0110000,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    ALU_DIV  = 7'b0110001,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    ALU_REMU = 7'b0110010,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    ALU_REM  = 7'b0110011,  // bit 0 is used for signed mode, bit 1 is used for remdiv

    ALU_SHUF  = 7'b0111010,
    ALU_SHUF2 = 7'b0111011,
    ALU_PCKLO = 7'b0111000,
    ALU_PCKHI = 7'b0111001

  } alu_opcode_e;

  ////////////////////////////////////////////////////////////////////////////////////////////////////
  //                                          __  __ _   _ _                                        //
  //                                         |  \/  | | | | |                                       //
  //                                         | |\/| | | | | |                                       //
  //                                         | |  | | |_| | |___                                    //
  //                                         |_|  |_|\___/|_____|                                   //
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  parameter MUL_OP_WIDTH = 3;

  typedef enum logic [MUL_OP_WIDTH-1:0] {

    MUL_MAC32 = 3'b000,
    MUL_MSU32 = 3'b001,
    MUL_I     = 3'b010,
    MUL_IR    = 3'b011,
    MUL_DOT8  = 3'b100,
    MUL_DOT16 = 3'b101,
    MUL_H     = 3'b110

  } mul_opcode_e;




  ////////////////////////////////////////////////////////////////////////////////////////////////////
  //                                         _     ____  _   _                                      //
  //                                        | |   / ___|| | | |                                     //
  //                                        | |   \___ \| | | |                                     //
  //                                        | |___ ___) | |_| |                                     //
  //                                        |_____|____/ \___/                                      //
  ////////////////////////////////////////////////////////////////////////////////////////////////////

  typedef enum bit {
    LOAD  = 1'b0,
    STORE = 1'b1
  } we_e;
  typedef enum bit [1:0] {
    WORD  = 2'b00,
    HALF  = 2'b01,
    BYTE1 = 2'b10,
    BYTE2 = 2'b11
  } type_e;
  typedef enum bit [1:0] {
    ZERO_EXT = 2'b00,
    SIGN_EXT = 2'b01
  } extend_e;

endpackage
