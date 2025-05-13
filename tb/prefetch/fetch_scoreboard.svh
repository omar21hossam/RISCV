class fetch_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fetch_scoreboard)


  uvm_analysis_export #(fetch_seq_item) sb_export_ip;
  uvm_tlm_analysis_fifo #(fetch_seq_item) sb_fifo_ip;
  fetch_seq_item seq_item_ip,seq_item_op;
  uvm_analysis_export #(fetch_seq_item) sb_export_op;
  uvm_tlm_analysis_fifo #(fetch_seq_item) sb_fifo_op;
  //----------------------------------------------------------------------------
  int branch_expected = 0;
  int jump_expected = 0;
  bit flush_detected = 'b0;
   int num_passed = 0;
  int num_failed = 0;

  fetch_seq_item matched_ip;
  fetch_seq_item matched_op;
  fetch_seq_item ip_queue[$];
  fetch_seq_item op_queue[$];

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
  end

  begin
  sb_fifo_op.get(seq_item_op);  
     op_queue.push_back(seq_item_op);
  end
join_any

      if  (ip_queue.size() > 0 && op_queue.size() > 0) begin
        // Pop the oldest IP and OP items (matched by position)
         matched_ip = ip_queue.pop_front();
         matched_op = op_queue.pop_front();
       $display("sb time %0t: data_id_o %0h , valid_id_o %0d ,  instr_addr_o %0d ,  pc_id_o %0d ,  pc_if_o %0d ,  instr_rdata_i %0h",  $time,matched_op.instr_rdata_id_o,matched_op.instr_valid_id_o,
            matched_ip.instr_addr_o,matched_ip.pc_id_o ,matched_ip.pc_if_o ,matched_ip.instr_rdata_i 
); 
      if (matched_op.instr_valid_id_o) begin

        if (!(matched_ip.instr_rdata_i == matched_op.instr_rdata_id_o)) begin
          `uvm_error("FETCH_SB", $sformatf(
                     "FETCH done wrongly in normal op (no stall or flush),instr_id_o = %0d, instr_i = %0d",
                     matched_op.instr_rdata_id_o,
                     matched_ip.instr_rdata_i
                     ))  
                    num_failed++; 
                     end
                     
        else 
        begin
        `uvm_info("FETCH SB", $sformatf("FETCH done correctly "), UVM_LOW)

      num_passed++;

      end

        info = classify_instruction(matched_op.instr_rdata_id_o);

        check_add(matched_ip.pc_if_o, matched_ip.pc_id_o);
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
    end
  endtask



  virtual function void final_phase(uvm_phase phase);
    super.final_phase(phase);  // Important to call super
    `uvm_info("SCOREBOARD", 
      $sformatf("Final Results: %0d passed, %0d failed", num_passed, num_failed), 
      UVM_LOW)  // Changed from UVM_NONE to UVM_LOW (UVM_NONE is invalid)
  endfunction


//***************************************************************************
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

     `uvm_info("FETCH SB", $sformatf("ADDRESS_CHECK_JB: inst add_f  %0d , inst add_d  %0d ",
                                      matched_ip.pc_if_o, matched_ip.pc_id_o), UVM_LOW)



      flush_detected = 'b0;
    end else begin

      if ((matched_ip.pc_if_o - matched_ip.pc_id_o == 4)) begin
    
       `uvm_info("FETCH SB", $sformatf(
                  "ADDRESS_CHECK_NORMAL: ADDERSS of inst fetched correct"), UVM_LOW)
      num_passed++;

      end
      else if ((matched_ip.pc_id_o != 0) && (matched_ip.pc_if_o != 0)) begin
       `uvm_error("FETCH_SB", $sformatf("Error in instrection address in normal operation"))
       num_failed++;
      end
    end
  endfunction


endclass

