class riscv_seq_item extends uvm_sequence_item;


`uvm_object_utils(riscv_seq_item)
 function new (string name = "riscv_seq_item");

    super.new(name) ;
    
 endfunction

//////////__signals on main intf must be driven__////
     logic pulp_clock_en_i=0; 
     logic scan_cg_en_i=0;  
     logic rst_ni='b1;
     logic [31:0] boot_addr_i=0;
     logic [31:0] mtvec_addr_i=0;
     logic [31:0] dm_halt_addr_i=0;
     logic [31:0] hart_id_i=0;
     logic [31:0] dm_exception_addr_i=0;
     logic [31:0] irq_i=0;
     logic debug_req_i=0;
     logic fetch_enable_i=1;
////////__signals for int mem to write on__//////////
 logic [31:0] instruction;
 logic        instr_gnt_i; //op of driver
 logic        instr_rvalid_i; //op of driver 
 logic [31:0] instr_rdata_i; //op of driver
 logic        instr_req_o;   //ip to driver
 logic [31:0] instr_addr_o;   //ip to driver

/////////////////////////////////////////////////////



typedef enum {R_TYPE, I_TYPE, U_TYPE, B_TYPE, S_TYPE, J_TYPE} riscv_instr_type_t;

 rand riscv_instr_type_t instr_type;
    rand bit [6:0]  opcode;
    rand bit [4:0]  rd;
    rand bit [4:0]  rs1;
    rand bit [4:0]  rs2;
    rand bit [2:0]  funct3;
    rand bit [6:0]  funct7;
    rand bit signed  [11:0] imm12;
    rand bit signed  [19:0] imm20;

    constraint valid_type {
instr_type dist {R_TYPE :/ 20, I_TYPE :/ 30, U_TYPE :/ 10, B_TYPE :/ 10, S_TYPE :/ 20, J_TYPE :/ 10};
    }

   constraint valid_r_type {
        instr_type == R_TYPE ->{
        
         opcode inside {7'b0110011};
    funct7 inside {7'b0000000, 7'b0100000, 7'b0000001};

 (funct7 == 7'b0000000) -> funct3 inside {[0:7]}; //  ADD, SLL, SLT, SLTU, XOR, SRL, OR, AND
    (funct7 == 7'b0100000) -> funct3 inside {3'b000, 3'b101}; // SUB, SRA
    (funct7 == 7'b0000001) -> funct3 inside {[0:7]}; // MUL/DIV

        }


    }

 // I-type constraints
 constraint valid_I_type {
 
  instr_type == I_TYPE -> {
    opcode inside {7'b0010011, 7'b0000011, 7'b1100111}; // ADDI, Loads, JALR

    // Arithmetic I-Type (ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI)
    (opcode == 7'b0010011) -> {
      funct3 inside {3'b000, 3'b010, 3'b011, 3'b100, 3'b110, 3'b111, 3'b001, 3'b101}
    };

    // Load instructions (LB, LH, LW, LBU, LHU)
    (opcode == 7'b0000011) -> {
      funct3 inside {3'b000, 3'b001, 3'b010, 3'b100, 3'b101}
    };

    // JALR
    (opcode == 7'b1100111) -> {
      funct3 inside {3'b000}
    };
  }
}


////u need to add imm for I type //////



        // U-type constraints
 constraint valid_U_type {       
        instr_type == U_TYPE -> opcode inside {7'b0110111, 7'b0010111};
    }

        // B-type constraints
 constraint valid_B_type {       
        instr_type == B_TYPE -> { opcode inside{7'b1100011} ;
   funct3 inside {3'b000, 3'b001, 3'b100, 3'b101, 3'b110, 3'b111}; // BEQ: 0x0, BNE: 0x1, BLT: 0x4, BGE: 0x5, BLTU: 0x6, BGEU: 0x7


    } 
 }
        // S-type constraints
 constraint valid_S_type {       
        instr_type == S_TYPE -> {opcode inside{7'b0100011}; 
        funct3 inside {3'b000, 3'b001, 3'b010}; // SB: 0x0, SH: 0x1, SW: 0x2
    }
 }
        // J-type constraints
 constraint valid_J_type {   
        instr_type == J_TYPE -> opcode inside{7'b1101111}; 
    }

        // Register constraints
 constraint valid_Registers {        
        rd  inside  {[0:31]};
        rs1 inside {[0:31]};
        rs2 inside {[0:31]};
    }

  constraint handling_before {
 
  solve opcode before funct7, funct3;

  solve funct7 before funct3;
  }  
//************____imporant functions____******************//

    function bit [31:0] pack_instruction();

        case (instr_type)

            R_TYPE: instruction = {funct7, rs2, rs1, funct3, rd, opcode};
            I_TYPE: instruction = {imm12, rs1, funct3, rd, opcode};
            S_TYPE: instruction = {imm12[11:5], rs2, rs1, funct3, imm12[4:0], opcode};
            B_TYPE: instruction = {imm12[12], imm12[10:5], rs2, rs1, funct3, imm12[4:1], imm12[11], opcode};
            U_TYPE: instruction = {imm20, rd, opcode};
            J_TYPE: instruction = {imm20[19], imm20[9:0], imm20[10], imm20[18:11], rd, opcode};
            default: instruction = 32'h00000013; // NOP
        endcase
        return instruction;    endfunction

function void post_randomize();
      pack_instruction();  
     $display("Instruction: %s", convert2asm());     
    endfunction
    


  /******************************************************************/
function string convert2asm();
        case (instr_type)
            R_TYPE: begin
                if (funct7 == 7'b0000001) begin
                    case (funct3)
                        3'b000: return $sformatf("MUL x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b001: return $sformatf("MULH x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b010: return $sformatf("MULHSU x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b011: return $sformatf("MULHU x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b100: return $sformatf("DIV x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b101: return $sformatf("DIVU x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b110: return $sformatf("REM x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b111: return $sformatf("REMU x%0d, x%0d, x%0d", rd, rs1, rs2);
                    endcase
                end else begin
                    case (funct3)
                        3'b000: return (funct7 == 7'b0100000) ? $sformatf("SUB x%0d, x%0d, x%0d", rd, rs1, rs2) : $sformatf("ADD x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b001: return $sformatf("SLL x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b010: return $sformatf("SLT x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b011: return $sformatf("SLTU x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b100: return $sformatf("XOR x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b101: return (funct7 == 7'b0100000) ? $sformatf("SRA x%0d, x%0d, x%0d", rd, rs1, rs2) : $sformatf("SRL x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b110: return $sformatf("OR x%0d, x%0d, x%0d", rd, rs1, rs2);
                        3'b111: return $sformatf("AND x%0d, x%0d, x%0d", rd, rs1, rs2);
                    endcase
                end
            end
            I_TYPE: begin
                case (opcode)
                    7'b0010011: return $sformatf("ADDI x%0d, x%0d, %0d", rd, rs1, imm12);
                    7'b0000011: begin
                        case (funct3)
                            3'b000: return $sformatf("LB x%0d, %0d(x%0d)", rd, imm12, rs1);
                            3'b001: return $sformatf("LH x%0d, %0d(x%0d)", rd, imm12, rs1);
                            3'b010: return $sformatf("LW x%0d, %0d(x%0d)", rd, imm12, rs1);
                            3'b100: return $sformatf("LBU x%0d, %0d(x%0d)", rd, imm12, rs1);
                            3'b101: return $sformatf("LHU x%0d, %0d(x%0d)", rd, imm12, rs1);
                        endcase
                    end
                    7'b1100111: return $sformatf("JALR x%0d, %0d(x%0d)", rd, imm12, rs1);
                endcase
            end
            U_TYPE: begin
                if (opcode == 7'b0110111) return $sformatf("LUI x%0d, 0x%0h", rd, imm20);
                else return $sformatf("AUIPC x%0d, 0x%0h", rd, imm20);
            end
            B_TYPE: begin
                case (funct3)
                    3'b000: return $sformatf("BEQ x%0d, x%0d, %0d", rs1, rs2, imm12);
                    3'b001: return $sformatf("BNE x%0d, x%0d, %0d", rs1, rs2, imm12);
                    3'b100: return $sformatf("BLT x%0d, x%0d, %0d", rs1, rs2, imm12);
                    3'b101: return $sformatf("BGE x%0d, x%0d, %0d", rs1, rs2, imm12);
                    3'b110: return $sformatf("BLTU x%0d, x%0d, %0d", rs1, rs2, imm12);
                    3'b111: return $sformatf("BGEU x%0d, x%0d, %0d", rs1, rs2, imm12);
                endcase
            end
            S_TYPE: begin
                case (funct3)
                    3'b000: return $sformatf("SB x%0d, %0d(x%0d)", rs2, imm12, rs1);
                    3'b001: return $sformatf("SH x%0d, %0d(x%0d)", rs2, imm12, rs1);
                    3'b010: return $sformatf("SW x%0d, %0d(x%0d)", rs2, imm12, rs1);
                endcase
            end
            J_TYPE: return $sformatf("JAL x%0d, %0d", rd, imm20);
            default: return "NOP";
        endcase
    endfunction

endclass :riscv_seq_item
