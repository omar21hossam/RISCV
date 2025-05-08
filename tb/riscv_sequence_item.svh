class riscv_sequence_item extends uvm_sequence_item;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(riscv_sequence_item)

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_sequence_item");
    super.new(name);
  endfunction

  //==================================================================================
  // Data Members
  //==================================================================================
  logic                               rst_ni              = 'b1;

  // Instruction Interface Signals
  //----------------------------------------------------------------------------------
  logic                               instr_gnt_i;
  logic                               instr_rvalid_i;
  logic                        [31:0] instr_rdata_i;
  logic                        [31:0] instr_addr_o;
  logic                               instr_req_o;
  logic                        [31:0] instruction;

  // Instruction Encoding Signals
  //----------------------------------------------------------------------------------
  rand bit                     [ 6:0] opcode;
  rand bit                     [ 4:0] rd;
  rand bit                     [ 4:0] rs1;
  rand bit                     [ 4:0] rs2;
  rand bit                     [ 2:0] funct3;
  rand bit                     [ 6:0] funct7;
  rand bit signed              [31:0] imm;
  rand riscv_pkg::instr_type_e        instr_type;
  
  // Temporary instruction memory
  // ---------------------------------------------------
  logic [31:0] instr_mem[logic [31:0]];

  // Discarded Signals
  // ---------------------------------------------------
  logic                               pulp_clock_en_i     = 1'b0;
  logic                               scan_cg_en_i        = 1'b0;
  logic                        [31:0] boot_addr_i         = 'b0;
  logic                        [31:0] mtvec_addr_i        = 'b0;
  logic                        [31:0] dm_halt_addr_i      = 'b0;
  logic                        [31:0] hart_id_i           = 'b0;
  logic                        [31:0] dm_exception_addr_i = 'b0;
  logic                        [31:0] irq_i               = 'b0;
  logic                               debug_req_i         = 1'b0;
  logic                               fetch_enable_i      = 1'b1;


  //==================================================================================
  // Constraints
  //==================================================================================

  //----------------------------------------------------------------------------------
  constraint valid_type_c {
    soft instr_type dist {
      riscv_pkg::R_TYPE := 50,
      riscv_pkg::I_TYPE := 50,
      riscv_pkg::U_TYPE := 50,
      riscv_pkg::S_TYPE := 50,
      riscv_pkg::B_TYPE := 0,
      riscv_pkg::J_TYPE := 0
    };
  }

  //----------------------------------------------------------------------------------
  constraint r_type_c {
    instr_type == riscv_pkg::R_TYPE -> {
      opcode inside {riscv_pkg::OP_RTYPE};
      funct7 inside {riscv_pkg::SUB_SRA, riscv_pkg::M_FUNCT7, riscv_pkg::R_OTHER};
      (funct7 == riscv_pkg::SUB_SRA) -> funct3 inside {riscv_pkg::ADD_SUB, riscv_pkg::SRL_SRA};
      (funct7 == riscv_pkg::R_OTHER) ->
      funct3 inside {
        riscv_pkg::ADD_SUB,
        riscv_pkg::SLL,
        riscv_pkg::SLT,
        riscv_pkg::SLTU,
        riscv_pkg::XOR,
        riscv_pkg::SRL_SRA,
        riscv_pkg::OR,
        riscv_pkg::AND
    };
      (funct7 == riscv_pkg::M_FUNCT7) ->
      funct3 inside {
        riscv_pkg::MUL,
        riscv_pkg::MULH,
        riscv_pkg::MULHSU,
        riscv_pkg::MULHU,
        riscv_pkg::DIV,
        riscv_pkg::DIVU,
        riscv_pkg::REM,
        riscv_pkg::REMU
      };
    }
  }

  //----------------------------------------------------------------------------------
  constraint i_type_c {

    instr_type == riscv_pkg::I_TYPE -> {
      opcode inside {riscv_pkg::OP_ITYPE, riscv_pkg::OP_LOAD, riscv_pkg::OP_JALR};

      // Arithmetic I-Type (ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI)
      (opcode == riscv_pkg::OP_ITYPE) ->
      {
        funct3 inside {
        riscv_pkg::ADDI_JALR,
        riscv_pkg::SLLI,
        riscv_pkg::SLTI,
        riscv_pkg::SLTIU,
        riscv_pkg::XORI,
        riscv_pkg::SRLI_SRAI,
        riscv_pkg::ORI,
        riscv_pkg::ANDI
      }
      };

      // Load instructions (LB, LH, LW, LBU, LHU)
      (opcode == riscv_pkg::OP_LOAD) ->
      {funct3 inside {riscv_pkg::LB, riscv_pkg::LH, riscv_pkg::LW, riscv_pkg::LBU, riscv_pkg::LHU}};

      // JALR
      (opcode == riscv_pkg::OP_JALR) -> {funct3 inside {riscv_pkg::ADDI_JALR}};
    }
  }


  //----------------------------------------------------------------------------------
  constraint u_type_c {
    instr_type == riscv_pkg::U_TYPE ->
    opcode inside {riscv_pkg::OP_LUI, riscv_pkg::OP_AUIPC};
  }

  //----------------------------------------------------------------------------------
  constraint b_type_c {
    instr_type == riscv_pkg::B_TYPE -> {
      opcode inside {riscv_pkg::OP_BRANCH};
      funct3 inside {
        riscv_pkg::BEQ,
        riscv_pkg::BNE,
        riscv_pkg::BLT,
        riscv_pkg::BGE,
        riscv_pkg::BLTU,
        riscv_pkg::BGEU
        };
    }
  }
  //----------------------------------------------------------------------------------
  constraint s_type_c {
    instr_type == riscv_pkg::S_TYPE -> {
      opcode inside {riscv_pkg::OP_STORE};
      funct3 inside {riscv_pkg::SB, riscv_pkg::SH, riscv_pkg::SW};
    }
  }
  //----------------------------------------------------------------------------------
  constraint j_type_c {
    instr_type == riscv_pkg::J_TYPE ->
    opcode inside {riscv_pkg::OP_JAL};
  }

  //----------------------------------------------------------------------------------
  constraint solve_before_c {
    solve opcode before funct7, funct3;
    solve funct7 before funct3;
  }

  //==================================================================================
  // function: pack_instruction
  //==================================================================================
  function bit [31:0] pack_instruction();
    unique case (instr_type)
      riscv_pkg::R_TYPE:  instruction = {funct7, rs2, rs1, funct3, rd, opcode};
      riscv_pkg::I_TYPE:  instruction = {imm[11:0], rs1, funct3, rd, opcode};
      riscv_pkg::S_TYPE:  instruction = {imm[11:5], rs2, rs1, funct3, imm[4:0], opcode};
      riscv_pkg::B_TYPE:  instruction = {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], opcode};
      riscv_pkg::U_TYPE:  instruction = {imm[31:12], rd, opcode};
      riscv_pkg::J_TYPE:  instruction = {imm[20], imm[10:1], imm[11], imm[19:12], rd, opcode};
      default: instruction = 32'h00000013;  // NOP
    endcase
    return instruction;
  endfunction

  //==================================================================================
  // function: post_randomize
  //==================================================================================
  function void post_randomize();
    // pack_instruction();
    $display("Instruction: %s", convert2asm());
  endfunction

  //==================================================================================
  // function: convert2asm
  //==================================================================================
  function string convert2asm();
    unique case (instr_type)
      riscv_pkg::R_TYPE: begin
        if (funct7 == riscv_pkg::M_FUNCT7) begin
          unique case (funct3)
            riscv_pkg::MUL: return $sformatf("mul x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::MULH: return $sformatf("mulh x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::MULHSU: return $sformatf("mulsu x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::MULHU: return $sformatf("mulhu x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::DIV: return $sformatf("div x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::DIVU: return $sformatf("divu x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::REM: return $sformatf("rem x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::REMU: return $sformatf("remu x%0d, x%0d, x%0d", rd, rs1, rs2);
          endcase
        end else if (funct7 == riscv_pkg::SUB_SRA) begin
          unique case (funct3)
            riscv_pkg::ADD_SUB: return $sformatf("sub x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::SRL_SRA: return $sformatf("sra x%0d, x%0d, x%0d", rd, rs1, rs2);
          endcase
        end else if (funct7 == riscv_pkg::R_OTHER) begin
          unique case (funct3)
            riscv_pkg::ADD_SUB: return $sformatf("add x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::SLL: return $sformatf("sll x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::SLT: return $sformatf("slt x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::SLTU: return $sformatf("sltu x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::XOR: return $sformatf("xor x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::SRL_SRA: return $sformatf("srl x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::OR: return $sformatf("or x%0d, x%0d, x%0d", rd, rs1, rs2);
            riscv_pkg::AND: return $sformatf("and x%0d, x%0d, x%0d", rd, rs1, rs2);
          endcase
        end
      end
      riscv_pkg::I_TYPE: begin
        unique case (opcode)
          riscv_pkg::ADDI_JALR: return $sformatf("addi x%0d, x%0d, %0d", rd, rs1, imm[11:0]);
          riscv_pkg::OP_LOAD: begin
            unique case (funct3)
              riscv_pkg::LB:  return $sformatf("lb x%0d, %0d(x%0d)", rd, imm[11:0], rs1);
              riscv_pkg::LH:  return $sformatf("lh x%0d, %0d(x%0d)", rd, imm[11:0], rs1);
              riscv_pkg::LW:  return $sformatf("lw x%0d, %0d(x%0d)", rd, imm[11:0], rs1);
              riscv_pkg::LBU: return $sformatf("lbu x%0d, %0d(x%0d)", rd, imm[11:0], rs1);
              riscv_pkg::LHU: return $sformatf("lhu x%0d, %0d(x%0d)", rd, imm[11:0], rs1);
            endcase
          end
          riscv_pkg::OP_JALR:   return $sformatf("jalr x%0d, %0d(x%0d)", rd, imm[11:0], rs1);
        endcase
      end
      riscv_pkg::U_TYPE: begin
        if (opcode == riscv_pkg::OP_LUI) return $sformatf("lui x%0d, 0x%0h", rd, imm[31:12]);
        else return $sformatf("auipc x%0d, 0x%0h", rd, imm[31:12]);
      end
      riscv_pkg::B_TYPE: begin
        unique case (funct3)
          riscv_pkg::BEQ:  return $sformatf("beq x%0d, x%0d, %0d", rs1, rs2, imm[11:0]);
          riscv_pkg::BNE:  return $sformatf("bne x%0d, x%0d, %0d", rs1, rs2, imm[11:0]);
          riscv_pkg::BLT:  return $sformatf("blt x%0d, x%0d, %0d", rs1, rs2, imm[11:0]);
          riscv_pkg::BGE:  return $sformatf("bge x%0d, x%0d, %0d", rs1, rs2, imm[11:0]);
          riscv_pkg::BLTU: return $sformatf("bltu x%0d, x%0d, %0d", rs1, rs2, imm[11:0]);
          riscv_pkg::BGEU: return $sformatf("bgeu x%0d, x%0d, %0d", rs1, rs2, imm[11:0]);
        endcase
      end
      riscv_pkg::S_TYPE: begin
        unique case (funct3)
          riscv_pkg::SB: return $sformatf("SB x%0d, %0d(x%0d)", rs2, imm[11:0], rs1);
          riscv_pkg::SH: return $sformatf("SH x%0d, %0d(x%0d)", rs2, imm[11:0], rs1);
          riscv_pkg::SW: return $sformatf("SW x%0d, %0d(x%0d)", rs2, imm[11:0], rs1);
        endcase
      end
      riscv_pkg::J_TYPE:  return $sformatf("jal x%0d, %0d", rd, imm[31:12]);
      default: return "nop";
    endcase
  endfunction

endclass : riscv_sequence_item
