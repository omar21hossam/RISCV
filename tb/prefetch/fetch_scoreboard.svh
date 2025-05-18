class fetch_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fetch_scoreboard)


  uvm_analysis_export #(fetch_seq_item) sb_export_ip;
  uvm_tlm_analysis_fifo #(fetch_seq_item) sb_fifo_ip;
  fetch_seq_item seq_item_ip, seq_item_op;
  uvm_analysis_export #(fetch_seq_item) sb_export_op;
  uvm_tlm_analysis_fifo #(fetch_seq_item) sb_fifo_op;
  //----------------------------------------------------------------------------
  int branch_expected = 0;
  int jump_expected = 0;
  bit flush_detected = 'b0;
  int num_passed = 0;
  int num_failed = 0;
  int num_ip = 0;
  int num_op = 0;
  int num_flush = 0;
  int num_op_total = 0;  //as we alwyas count after op change , and finally , op will not change.
  bit misaligned = 'b0;
  bit x = 0;
  bit y = 0;

  logic [31:0] misaligned_inst;
  //**************************************************************************************************
  int MUL_cnt = 0, MULH_cnt = 0, MULHSU_cnt = 0, MULHU_cnt = 0;
  int DIV_cnt = 0, DIVU_cnt = 0, REM_cnt = 0, REMU_cnt = 0;
  int ADD_cnt = 0, SUB_cnt = 0, SLL_cnt = 0, SLT_cnt = 0;
  int SLTU_cnt = 0, XOR_cnt = 0, SRL_cnt = 0, SRA_cnt = 0;
  int OR_cnt = 0, AND_cnt = 0;
  int ADDI_cnt = 0, SLLI_cnt = 0, SLTI_cnt = 0, SLTIU_cnt = 0;
  int XORI_cnt = 0, SRLI_cnt = 0, SRAI_cnt = 0, ORI_cnt = 0, ANDI_cnt = 0;
  int LB_cnt = 0, LH_cnt = 0, LW_cnt = 0, LBU_cnt = 0, LHU_cnt = 0;
  int SB_cnt = 0, SH_cnt = 0, SW_cnt = 0;
  int BEQ_cnt = 0, BNE_cnt = 0, BLT_cnt = 0, BGE_cnt = 0;
  int BLTU_cnt = 0, BGEU_cnt = 0;
  int LUI_cnt = 0, AUIPC_cnt = 0;
  int JALR_cnt = 0, JAL_cnt = 0;
  int R_TYPE_cnt = 0;
  int I_TYPE_cnt = 0;
  int B_TYPE_cnt = 0;
  int J_TYPE_cnt = 0;
  int U_TYPE_cnt = 0;
  int S_TYPE_cnt = 0;
  //******************************************************************************************************
  fetch_seq_item matched_ip;
  fetch_seq_item matched_ip_2;
  fetch_seq_item matched_op;
  fetch_seq_item ip_queue[$];
  fetch_seq_item op_queue[$];

  typedef enum logic [2:0] {
    INSTR_NONE   = 3'b00,
    INSTR_JUMP   = 3'b01,
    INSTR_BRANCH = 3'b10,
    INSTR_JUMP_R = 3'b11
  } instr_type_e;

  // Struct to hold the function return values
  typedef struct packed {instr_type_e instr_type;} instr_info_t;


  instr_info_t info;
  //----------------------------------------------------------

  function new(string name = "fetch_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export_ip = new("sb_export_ip", this);
    sb_fifo_ip   = new("sb_fifo_ip", this);
    sb_export_op = new("sb_export_op", this);
    sb_fifo_op   = new("sb_fifo_op", this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export_ip.connect(sb_fifo_ip.analysis_export);
    sb_export_op.connect(sb_fifo_op.analysis_export);

  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      fork
        begin
          sb_fifo_ip.get(seq_item_ip);
          ip_queue.push_back(seq_item_ip);
          num_ip = num_ip + 1;
        end

        begin
          sb_fifo_op.get(seq_item_op);
          op_queue.push_back(seq_item_op);
          num_op = num_op + 1;
          num_op_total = num_op_total + 1;
        end
      join_any

      if ((ip_queue.size() > 0) && (op_queue.size() > 0)) begin


        // Pop the oldest IP and OP items (matched by position)
        matched_ip = ip_queue.pop_front();
        matched_op = op_queue.pop_front();

        //----------------------------------------------------------------------------------
        if (matched_op.instr_valid_id_o) begin

          if (!(matched_ip.instr_rdata_i == matched_op.instr_rdata_id_o)) begin
            matched_ip = ip_queue.pop_front();

            if (!(matched_ip.instr_rdata_i == matched_op.instr_rdata_id_o)) begin

              if (misaligned) begin
                x = 'b1;
                y = 'b1;

                misaligned_inst[15:0] = matched_ip.instr_rdata_i[31:16];
                matched_ip_2 = ip_queue.pop_front();
                misaligned_inst[31:16] = matched_ip_2.instr_rdata_i[15:0];
                if ((misaligned_inst == matched_op.instr_rdata_id_o)) begin

                  `uvm_info("FETCH", $sformatf("Misalignment done correctly "), UVM_HIGH)
                  misaligned = 'b0;
                  num_passed++;
                  num_op = num_op + 1;
                  num_op_total = num_op_total + 1;
                end else begin
                  `uvm_error("FETCH_SB", $sformatf(
                             "FETCH Misaligned done wrongly op time %0t", $time,))
                  ip_queue.push_front(matched_ip);
                  ip_queue.push_front(matched_ip_2);
                end

              end else begin

                `uvm_error("FETCH_SB", $sformatf(
                           "FETCH done wrongly in normal op time %0t (no stall or flush),instr_id_o = %0h, instr_i = %0h",
                           $time,
                           matched_op.instr_rdata_id_o,
                           matched_ip.instr_rdata_i

                           ))
                ip_queue.push_front(seq_item_ip);

                num_failed++;
              end
            end else begin
              `uvm_info("FETCH", $sformatf("FETCH done correctly and flush detected "), UVM_HIGH)
              flush_detected = 'b1;
              branch_expected = 0;
              jump_expected = 0;
              num_op_total = num_op_total + 1;
              num_flush = num_flush + 1;
              num_passed++;
            end
          end else begin
            `uvm_info("FETCH", $sformatf("FETCH done correctly "), UVM_HIGH)

            num_passed++;

          end


          info = classify_instruction(matched_op.instr_rdata_id_o);
          check_add(matched_ip.pc_if_o, matched_ip.pc_id_o);
          instruction_types(matched_op.instr_rdata_id_o);

          case (info.instr_type)
            INSTR_JUMP: begin
              jump_expected = jump_expected + 1;
              `uvm_info("FETCH", $sformatf("JUMP detected"), UVM_HIGH)
              if (matched_op.instr_rdata_id_o[21] == 1'b1) begin

                `uvm_info("FETCH", $sformatf("JUMP detected , misaligned add"), UVM_HIGH)

                misaligned = 'b1;
              end



            end
            INSTR_BRANCH: begin
              branch_expected = branch_expected + 1;
              `uvm_info("FETCH", $sformatf("BRANCH detected "), UVM_HIGH)

            end
            INSTR_NONE: begin

            end
            INSTR_JUMP_R: begin
              jump_expected = jump_expected + 1;
              `uvm_info("FETCH", $sformatf("JUMP_R detected"), UVM_HIGH)
            end

          endcase
        end else begin
          flush_detected  = 'b1;
          branch_expected = 0;
          jump_expected   = 0;

        end

      end
    end
  endtask
  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);

    `uvm_info("FETCH", $sformatf("\n\n%s TEST SUMMARY %s", `SHORT_EQ_LINE, `SHORT_EQ_LINE),
              UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "\nPassed: %0d | Failed: %0d | Completion: %0.1f%%",
              num_passed,
              num_failed,
              (num_passed * 100.0) / (num_passed + num_failed)
              ), UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "\nInputs: %0d | Outputs: %0d | Flushes: %0d | Total Ops: %0d",
              num_ip,
              num_op + x + y,
              num_flush,
              num_op_total + x + y
              ), UVM_LOW)
    `uvm_info("FETCH", $sformatf("\n%s", `DASH_LINE), UVM_MEDIUM);


    // Print instruction type breakdown
    `uvm_info("FETCH", $sformatf(
              "\n\n%s INSTRUCTION TYPE COUNTS %s", `SHORT_EQ_LINE, `SHORT_EQ_LINE), UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "R-Type: %0d (%0.1f%%)", R_TYPE_cnt, (R_TYPE_cnt * 100.0) / num_op_total), UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "I-Type: %0d (%0.1f%%)", I_TYPE_cnt, (I_TYPE_cnt * 100.0) / num_op_total), UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "S-Type: %0d (%0.1f%%)", S_TYPE_cnt, (S_TYPE_cnt * 100.0) / num_op_total), UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "B-Type: %0d (%0.1f%%)", B_TYPE_cnt, (B_TYPE_cnt * 100.0) / num_op_total), UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "U-Type: %0d (%0.1f%%)", U_TYPE_cnt, (U_TYPE_cnt * 100.0) / num_op_total), UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "J-Type: %0d (%0.1f%%)", J_TYPE_cnt, (J_TYPE_cnt * 100.0) / num_op_total), UVM_LOW)
    `uvm_info("FETCH", $sformatf("\n%s", `DASH_LINE), UVM_MEDIUM);


    // Print detailed function code counts
    `uvm_info("FETCH", $sformatf(
              "\n\n%s DETAILED INSTRUCTION COUNTS %s", `SHORT_EQ_LINE, `SHORT_EQ_LINE), UVM_LOW)

    // R-Type Instructions
    `uvm_info("FETCH", $sformatf("\n\nR-Type Instructions:\n%s", `DASH_LINE), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  ADD: %0d | SUB: %0d", ADD_cnt, SUB_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  SLL: %0d | SRL: %0d | SRA: %0d", SLL_cnt, SRL_cnt, SRA_cnt
              ), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  SLT: %0d | SLTU: %0d", SLT_cnt, SLTU_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  XOR: %0d | OR: %0d | AND: %0d", XOR_cnt, OR_cnt, AND_cnt),
              UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "  MUL: %0d | MULH: %0d | MULHU: %0d | MULHSU: %0d",
              MUL_cnt,
              MULH_cnt,
              MULHU_cnt,
              MULHSU_cnt
              ), UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "  DIV: %0d | DIVU: %0d | REM: %0d | REMU: %0d", DIV_cnt, DIVU_cnt, REM_cnt, REMU_cnt
              ), UVM_LOW)
    `uvm_info("FETCH", $sformatf("\n%s", `DASH_LINE), UVM_MEDIUM);


    // I-Type Instructions
    `uvm_info("FETCH", $sformatf("\n\nI-Type Instructions:\n%s", `DASH_LINE), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  ADDI: %0d | SLLI: %0d", ADDI_cnt, SLLI_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  SLTI: %0d | SLTIU: %0d", SLTI_cnt, SLTIU_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "  XORI: %0d | ORI: %0d | ANDI: %0d", XORI_cnt, ORI_cnt, ANDI_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  SRLI: %0d | SRAI: %0d", SRLI_cnt, SRAI_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  JALR: %0d", JALR_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf(
              "  LB: %0d | LH: %0d | LW: %0d | LBU: %0d | LHU: %0d",
              LB_cnt,
              LH_cnt,
              LW_cnt,
              LBU_cnt,
              LHU_cnt
              ), UVM_LOW)
    `uvm_info("FETCH", $sformatf("\n%s", `DASH_LINE), UVM_MEDIUM);


    // S-Type Instructions
    `uvm_info("FETCH", $sformatf("\n\nS-Type Instructions:\n%s", `DASH_LINE), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  SB: %0d | SH: %0d | SW: %0d", SB_cnt, SH_cnt, SW_cnt),
              UVM_LOW)
    `uvm_info("FETCH", $sformatf("\n%s", `DASH_LINE), UVM_MEDIUM);


    // B-Type Instructions
    `uvm_info("FETCH", $sformatf("\n\nB-Type Instructions:\n%s", `DASH_LINE), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  BEQ: %0d | BNE: %0d", BEQ_cnt, BNE_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  BLT: %0d | BGE: %0d", BLT_cnt, BGE_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  BLTU: %0d | BGEU: %0d", BLTU_cnt, BGEU_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf("\n%s", `DASH_LINE), UVM_MEDIUM);

    // U-Type and J-Type Instructions
    `uvm_info("FETCH", $sformatf("\n\nU/J-Type Instructions:\n%s", `DASH_LINE), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  LUI: %0d | AUIPC: %0d", LUI_cnt, AUIPC_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf("  JAL: %0d", JAL_cnt), UVM_LOW)
    `uvm_info("FETCH", $sformatf("\n%s", `DASH_LINE), UVM_MEDIUM);
  endfunction

  //***************************************************************************
  function instr_info_t classify_instruction(input logic [31:0] instruction);  // 32-bit instruction
    logic [6:0] opcode;
    instr_info_t result;
    opcode = instruction[6:0];
    case (opcode)
      riscv_pkg::OP_JAL: begin
        result.instr_type = INSTR_JUMP;
      end

      riscv_pkg::OP_JALR: begin
        result.instr_type = INSTR_JUMP_R;

      end

      riscv_pkg::OP_BRANCH: begin
        result.instr_type = INSTR_BRANCH;
      end
      // All other opcodes (LUI, AUIPC, LOAD, STORE, OP_IMM, OP)
      default: begin
        result.instr_type = INSTR_NONE;
      end
    endcase

    return result;
  endfunction
  function void check_add(input logic [31:0] add_f, input logic [31:0] add_d);
    if (flush_detected == 'b1) begin

      `uvm_info("FETCH", $sformatf("ADDRESS_CHECK_JB:time %0t inst add_f  %0d , inst add_d  %0d ",
                                   $time, matched_ip.pc_if_o, matched_ip.pc_id_o), UVM_HIGH)

      flush_detected = 'b0;
    end else begin

      if ((matched_ip.pc_if_o - matched_ip.pc_id_o == 4)) begin

        `uvm_info("FETCH", $sformatf("ADDRESS_CHECK_NORMAL: ADDERSS of inst fetched correct"),
                  UVM_HIGH)
        num_passed++;

      end else if ((matched_ip.pc_id_o != 0) && (matched_ip.pc_if_o != 0)) begin

        `uvm_info(
            "FETCH",
            $sformatf(
                "ADDRESS_CHECK_NORMAL_after flush: ADDERSS of inst fetched correct time %0t  pc_if: %0d   pc_id: %0d ",
                $time, matched_ip.pc_if_o, matched_ip.pc_id_o), UVM_HIGH)

      end
    end
  endfunction
  function void instruction_types(input logic [31:0] instruction);
    bit [6:0] opcode = instruction[6:0];
    bit [2:0] funct3 = instruction[14:12];
    bit [6:0] funct7 = instruction[31:25];
    unique case (opcode)
      riscv_pkg::OP_RTYPE: begin
        R_TYPE_cnt++;
        if (funct7 == riscv_pkg::M_FUNCT7) begin
          unique case (funct3)
            riscv_pkg::MUL:    MUL_cnt++;
            riscv_pkg::MULH:   MULH_cnt++;
            riscv_pkg::MULHSU: MULHSU_cnt++;
            riscv_pkg::MULHU:  MULHU_cnt++;
            riscv_pkg::DIV:    DIV_cnt++;
            riscv_pkg::DIVU:   DIVU_cnt++;
            riscv_pkg::REM:    REM_cnt++;
            riscv_pkg::REMU:   REMU_cnt++;
          endcase
        end else if (funct7 == riscv_pkg::SUB_SRA) begin
          unique case (funct3)
            riscv_pkg::ADD_SUB: begin

              SUB_cnt++;  // SUB
            end
            riscv_pkg::SRL_SRA: begin

              SRA_cnt++;  // SRA
            end
          endcase
        end else if (funct7 == riscv_pkg::R_OTHER) begin
          unique case (funct3)
            riscv_pkg::ADD_SUB: ADD_cnt++;
            riscv_pkg::SLL:     SLL_cnt++;
            riscv_pkg::SLT:     SLT_cnt++;
            riscv_pkg::SLTU:    SLTU_cnt++;
            riscv_pkg::XOR:     XOR_cnt++;
            riscv_pkg::SRL_SRA: SRL_cnt++;  // SRL (funct7=0)
            riscv_pkg::OR:      OR_cnt++;
            riscv_pkg::AND:     AND_cnt++;
          endcase
        end
      end

      riscv_pkg::OP_ITYPE: begin  // I-Type (ALU immediate)
        I_TYPE_cnt++;
        unique case (funct3)
          riscv_pkg::ADDI_JALR: ADDI_cnt++;
          riscv_pkg::SLLI:      SLLI_cnt++;
          riscv_pkg::SLTI:      SLTI_cnt++;
          riscv_pkg::SLTIU:     SLTIU_cnt++;
          riscv_pkg::XORI:      XORI_cnt++;
          riscv_pkg::SRLI_SRAI: begin
            if (instruction[31:25] == 'b0) SRLI_cnt++;
            else SRAI_cnt++;
          end
          riscv_pkg::ORI:       ORI_cnt++;
          riscv_pkg::ANDI:      ANDI_cnt++;
        endcase
      end

      riscv_pkg::OP_LOAD: begin  // I-Type (Load)
        I_TYPE_cnt++;
        unique case (funct3)
          riscv_pkg::LB:  LB_cnt++;
          riscv_pkg::LH:  LH_cnt++;
          riscv_pkg::LW:  LW_cnt++;
          riscv_pkg::LBU: LBU_cnt++;
          riscv_pkg::LHU: LHU_cnt++;
        endcase
      end

      riscv_pkg::OP_JALR: begin  // I-Type (JALR)
        I_TYPE_cnt++;
        JALR_cnt++;
      end

      riscv_pkg::OP_STORE: begin  // S-Type
        S_TYPE_cnt++;
        unique case (funct3)
          riscv_pkg::SB: SB_cnt++;
          riscv_pkg::SH: SH_cnt++;
          riscv_pkg::SW: SW_cnt++;
        endcase
      end

      riscv_pkg::OP_BRANCH: begin  // B-Type
        B_TYPE_cnt++;
        unique case (funct3)
          riscv_pkg::BEQ:  BEQ_cnt++;
          riscv_pkg::BNE:  BNE_cnt++;
          riscv_pkg::BLT:  BLT_cnt++;
          riscv_pkg::BGE:  BGE_cnt++;
          riscv_pkg::BLTU: BLTU_cnt++;
          riscv_pkg::BGEU: BGEU_cnt++;
        endcase
      end

      riscv_pkg::OP_LUI: begin  // U-Type
        U_TYPE_cnt++;
        LUI_cnt++;
      end

      riscv_pkg::OP_AUIPC: begin  // U-Type
        U_TYPE_cnt++;
        AUIPC_cnt++;
      end

      riscv_pkg::OP_JAL: begin  // J-Type
        J_TYPE_cnt++;
        JAL_cnt++;
      end

      default: begin
      end
    endcase
  endfunction

endclass

