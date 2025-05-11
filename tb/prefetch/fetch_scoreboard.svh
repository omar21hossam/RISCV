class fetch_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fetch_scoreboard)


  uvm_analysis_export #(fetch_seq_item) sb_export;
  uvm_tlm_analysis_fifo #(fetch_seq_item) sb_fifo;
  fetch_seq_item seq_item;
  //----------------------------------------------------------------------------
  int branch_expected = 0;
  int jump_expected = 0;
  bit flush_detected = 'b0;
  int x,y;

  typedef enum logic [1:0] {
    INSTR_NONE   = 2'b00,
    INSTR_JUMP   = 2'b01,
    INSTR_BRANCH = 2'b10
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
    sb_export = new("sb_export", this);
    sb_fifo   = new("sb_fifo", this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);

  endfunction


  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      sb_fifo.get(seq_item);
      if (seq_item.instr_valid_id_o) begin

     /*   if (!(seq_item.instr_rdata_i == seq_item.instr_rdata_id_o))
          `uvm_error("FETCH_SB", $sformatf(
                     "FETCH done wrongly in normal op (no stall or flush),instr_id_o = %0d, instr_i = %0d",
                     seq_item.instr_rdata_id_o,
                     seq_item.instr_rdata_i
                     ))
        else `uvm_info("FETCH SB", $sformatf("FETCH done correctly "), UVM_HIGH)
*/
        info = classify_instruction(seq_item.instr_rdata_id_o);

        check_add(seq_item.pc_if_o, seq_item.pc_id_o);
        case (info.instr_type)
          INSTR_JUMP: begin

            jump_expected = jump_expected + 1;
            `uvm_info("FETCH SB", $sformatf("JUMP detected"), UVM_LOW)

          end
          INSTR_BRANCH: begin
            branch_expected = branch_expected + 1;
            `uvm_info("FETCH SB", $sformatf("BRANCH detected "), UVM_LOW)

          end
          INSTR_NONE: begin

          end
        endcase
      end else begin
        flush_detected  = 'b1;
        branch_expected = 0;
        jump_expected   = 0;
      end

    end

  endtask

  function instr_info_t classify_instruction(input logic [31:0] instruction  // 32-bit instruction
  );
    logic [6:0] opcode;
    instr_info_t result;
    opcode = instruction[6:0];
    case (opcode)
      riscv_pkg::OP_JAL: begin
        result.instr_type = INSTR_JUMP;
      end

      riscv_pkg::OP_JALR: begin
        result.instr_type = INSTR_JUMP;

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
  function check_add(input logic [31:0] add_f, input logic [31:0] add_d);
    if (flush_detected == 'b1) begin

   /*   `uvm_info("FETCH SB", $sformatf("ADDRESS_CHECK_JB: inst add_f  %0d , inst add_d  %0d ",
                                      seq_item.pc_if_o, seq_item.pc_id_o), UVM_LOW)


*/
      flush_detected = 'b0;
    end else begin

      if ((seq_item.pc_if_o - seq_item.pc_id_o == 4))
      x=1;
    /*    `uvm_info("FETCH SB", $sformatf(
                  "ADDRESS_CHECK_NORMAL: Operation of inst fetch done correctly"), UVM_HIGH)*/
      else if ((seq_item.pc_id_o != 0) && (seq_item.pc_if_o != 0))
     /*   `uvm_error("FETCH_SB", $sformatf("Error in instrection address in normal operation"))*/
y=2;
    end
  endfunction


endclass

