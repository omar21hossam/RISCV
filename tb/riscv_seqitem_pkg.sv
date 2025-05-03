package riscv_seq_item_pkg;

import uvm_pkg ::* ; 
`include "uvm_macros.svh"

class riscv_seq_item extends uvm_sequence_item;


`uvm_object_utils(riscv_seq_item)
 function new (string name = "riscv_seq_item");

    super.new(name) ;
    
 endfunction

//////////__signals on main intf must be driven__////
     logic    rst_ni;
     logic [31:0] boot_addr_i=0;
     logic [31:0] mtvec_addr_i=0;
     logic [31:0] dm_halt_addr_i=0;
     logic [31:0] hart_id_i=0;
     logic [31:0] dm_exception_addr_i=0;
     logic [31:0] irq_i=0;
     logic debug_req_i=0;
     logic fetch_enable_i=1;
////////__signals for int mem to write on__//////////
 bit [31:0] instruction;
 bit [31:0] addr;
    int min_addr = 0;
    int max_addr = 1023;
    int num_instr = 256;
   static int x =0;
/////////////////////////////////////////////////////



typedef enum {R_TYPE, I_TYPE, U_TYPE, B_TYPE, S_TYPE, J_TYPE} riscv_instr_type_t;

 rand riscv_instr_type_t instr_type;
    rand bit [6:0]  opcode;
    rand bit [4:0]  rd;
    rand bit [4:0]  rs1;
    rand bit [4:0]  rs2;
    rand bit [2:0]  funct3;
    rand bit [6:0]  funct7;
    rand bit [11:0] imm12;
    rand bit [19:0] imm20;

    constraint valid_type {
instr_type dist {R_TYPE :/ 20, I_TYPE :/ 30, U_TYPE :/ 10, B_TYPE :/ 10, S_TYPE :/ 20, J_TYPE :/ 10};
    }

   constraint valid_r_type {
        instr_type == R_TYPE ->{
        
         opcode inside {7'b0110011};
           // Ensure no other funct7 values are used
    funct7 inside {7'b0000000, 7'b0100000, 7'b0000001};

// // Base RV32I R-type instructions
//             (funct7 == 7'b0000000) -> {
//                 funct3 inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111}; // ADD, SLL, SLT, SLTU, XOR, SRL, OR, AND
//             };
//             (funct7 == 7'b0100000) -> {
//                 funct3 inside {3'b000, 3'b101}; // SUB, SRA
//             };
//             // RV32M Multiply/Divide instructions
//             (funct7 == 7'b0000001) -> {
//                 funct3 inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111}; // MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU
//             };
 

        }


    }

 // I-type constraints
 constraint valid_I_type {
        instr_type == I_TYPE -> opcode inside {7'b0010011, 7'b0000011, 7'b1100111} ;
    }

        // U-type constraints
 constraint valid_U_type {       
        instr_type == U_TYPE -> opcode inside {7'b0110111, 7'b0010111};
    }

        // B-type constraints
 constraint valid_B_type {       
        instr_type == B_TYPE ->  opcode inside{7'b1100011} ;
    } 

        // S-type constraints
 constraint valid_S_type {       
        instr_type == S_TYPE -> opcode inside{7'b0100011}; 
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
            U_TYPE: instruction = {imm20, rs1, opcode};
            J_TYPE: instruction = {imm20[19], imm20[9:0], imm20[10], imm20[18:11], rd, opcode};
            default: instruction = 32'h00000013; // NOP
        endcase
        return instruction;    endfunction

function bit [31:0] calc_add();

            //Calculate address (word aligned)
            addr = ((min_addr + (x % (max_addr - min_addr + 1))) <<2 );
             // Convert to byte address
            //Shifting left by 2 bits is equivalent to multiplying by 4
            x=x+1;
            $display("calc_add called: x=%0d addr=0x%0h", x, addr);
return addr;
endfunction

function void post_randomize();
      pack_instruction();
        calc_add();  
        //convert2asm();  
         
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
  ///////////////////////////////////////////////////////////////////










/*

(instr_type == R_TYPE) -> {
    solve opcode before funct7, funct3;
    opcode == 7'b0110011;
    // Distribute funct7 to balance base RV32I and RV32M instructions
    funct7 dist {7'b0000000 :/ 40, 7'b0100000 :/ 20, 7'b0000001 :/ 40};
    // Base RV32I R-type instructions
    (funct7 inside {7'b0000000, 7'b0100000}) -> {
        (funct7 == 7'b0000000) -> {
            funct3 inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111};
        };
        (funct7 == 7'b0100000) -> {
            funct3 inside {3'b000, 3'b101};
        };
    };
    // RV32M Multiply/Divide instructions
    (funct7 == 7'b0000001) -> {
        funct3 inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111};
    };
    // Ensure no other funct7 values are used for R-type
    !(funct7 inside {7'b0000000, 7'b0100000, 7'b0000001});
};










// Constraints
    constraint valid_instruction {
        instr_type dist {R_TYPE :/ 20, I_TYPE :/ 30, U_TYPE :/ 10, B_TYPE :/ 10, S_TYPE :/ 20, J_TYPE :/ 10};

        // R-type constraints
        (instr_type == R_TYPE) -> {
            opcode == 7'b0110011; // Shared opcode for R-type instructions
            // Base R-type instructions (funct7 = 0x00 or 0x20)
            (funct7 inside {7'b0000000, 7'b0100000}) -> {
                funct3 inside {[0:7]}; // ADD, SUB, XOR, OR, AND, SLL, SRL, SRA, SLT
            };
            // RV32M Multiply/Divide instructions (funct7 = 0x01)
            (funct7 == 7'b0000001) -> {
                funct3 inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111}; // MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU
            };
        };

        // I-type constraints
        (instr_type == I_TYPE) -> {
            (opcode inside {7'b0010011, 7'b0000011, 7'b1100111}) -> { // ADDI, LB, LH, LW, LBU, LHU, JALR
                funct3 inside {[0:7]}; // ADDI: 0x0, LB: 0x0, LH: 0x1, LW: 0x2, LBU: 0x4, LHU: 0x5, JALR: 0x0
                funct7 == 7'b0000000; // No funct7 for most I-type
            };
            (opcode == 7'b0010011 && funct3 inside {3'b001, 3'b101}) -> { // SLLI, SRLI, SRAI
                funct7 == 7'b0000000; // Shift immediate
            };
        };

        // U-type constraints
        (instr_type == U_TYPE) -> {
            opcode inside {7'b0110111, 7'b0010111}; // LUI, AUIPC
            funct3 == 3'b000; // No funct3
            funct7 == 7'b0000000; // No funct7
        };

        // B-type constraints
        (instr_type == B_TYPE) -> {
            opcode == 7'b1100011; // BEQ, BNE, BLT, BGE, BLTU, BGEU
            funct3 inside {3'b000, 3'b001, 3'b100, 3'b101, 3'b110, 3'b111}; // BEQ: 0x0, BNE: 0x1, BLT: 0x4, BGE: 0x5, BLTU: 0x6, BGEU: 0x7
            funct7 == 7'b0000000; // No funct7
        };

        // S-type constraints
        (instr_type == S_TYPE) -> {
            opcode == 7'b0100011; // SB, SH, SW
            funct3 inside {3'b000, 3'b001, 3'b010}; // SB: 0x0, SH: 0x1, SW: 0x2
            funct7 == 7'b0000000; // No funct7
        };

        // J-type constraints
        (instr_type == J_TYPE) -> {
            opcode == 7'b1101111; // JAL
            funct3 == 3'b000; // No funct3
            funct7 == 7'b0000000; // No funct7
        };

        // Register constraints
        rd inside {[0:31]};
        rs1 inside {[0:31]};
        rs2 inside {[0:31]};
    }














    
    // Constraints
constraint valid_instruction {
        instr_type dist {R_TYPE :/ 20, I_TYPE :/ 30, U_TYPE :/ 10, B_TYPE :/ 10, S_TYPE :/ 20, J_TYPE :/ 10};
}
    constraint valid_r_type {
        instr_type == R_TYPE -> opcode inside {7'b0110011};
    }
// Valid I-type opcodes
    constraint valid_i_type {
        instr_type == I_TYPE -> opcode inside {
            7'b0000011, // LOAD
            7'b0010011, // OP-IMM
            7'b1100111, // JALR
            7'b1110011  // SYSTEM
        };
    }

    // Valid S-type opcodes
    constraint valid_s_type {
        instr_type == S_TYPE -> opcode == 7'b0100011; // STORE
    }

    // Valid B-type opcodes
    constraint valid_b_type {
        instr_type == B_TYPE -> opcode == 7'b1100011; // BRANCH
    }

    // Valid U-type opcodes
    constraint valid_u_type {
        instr_type == U_TYPE -> opcode inside {
            7'b0010111, // AUIPC
            7'b0110111  // LUI
        };
    }

    // Valid J-type opcodes
    constraint valid_j_type {
        instr_type == J_TYPE -> opcode == 7'b1101111; // JAL
    }

    // Valid register constraints (x0-x31)
    constraint valid_registers {
        rd inside {[0:31]};
        rs1 inside {[0:31]};
        rs2 inside {[0:31]};
    }
// Function code constraints for common instructions
    constraint common_funct3 {
        if (instr_type == R_TYPE || instr_type == I_TYPE) {
            funct3 inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110, 3'b111};
        }
        if (instr_type == B_TYPE) {
            funct3 inside {3'b000, 3'b001, 3'b100, 3'b101, 3'b110, 3'b111}; // BEQ, BNE, BLT, BGE, BLTU, BGEU
        }
    }

    // Immediate value constraints
    constraint imm_constraints {
        if (instr_type == I_TYPE && opcode == 7'b0000011) { // LOAD
            imm12 inside {[0:4095]};
        }
        if (instr_type == S_TYPE) { // STORE
            imm12[11:5] == 0; // Only using lower 7 bits for simplicity
        }
    }
*/




endclass

endpackage