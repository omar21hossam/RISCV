package opcodes;
  typedef enum logic [6:0] {
    LOAD  = 'd3,
    STORE = 'd35
  } lsu_opcode_e;
  typedef enum logic [2:0] {
    LB  = 3'b000,
    LH  = 3'b001,
    LW  = 3'b010,
    LBU = 3'b100,
    LHU = 3'b101
  } load_funct3_e;

  typedef enum logic [2:0] {
    SB = 3'b000,
    SH = 3'b001,
    SW = 3'b010
  } store_funct3_e;
endpackage

class lsu_instructions;
  rand logic [6:0] op;
  rand logic [4:0] rd;
  rand logic [2:0] funct3;
  rand logic [4:0] rs1;
  rand logic [4:0] rs2;
  rand logic signed [11:0] imm;
  rand logic [31:0] instr;

  constraint rs1_c {rs1 == 'd0;}

  constraint op_c {op inside {opcodes::LOAD, opcodes::STORE};}

  constraint funct3_c {
    (op == opcodes::LOAD) ->
    funct3 inside {opcodes::LB, opcodes::LBU, opcodes::LH, opcodes::LHU, opcodes::LW};
    (op == opcodes::STORE) -> funct3 inside {opcodes::SB, opcodes::SH, opcodes::SW};

    solve op before funct3;
  }

  constraint rd_c {rd != 'd0;}

  constraint imm_c {imm inside {[0 : 3]};}

  constraint instr_c {
    (op == opcodes::STORE) -> instr == {imm[11:5], rs2, rs1, funct3, imm[4:0], op};
    (op == opcodes::LOAD) -> instr == {imm, rs1, funct3, rd, op};

    solve op before instr;
  }

endclass
