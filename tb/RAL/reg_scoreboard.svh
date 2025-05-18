`uvm_analysis_imp_decl(_alu)
`uvm_analysis_imp_decl(_mul)
`uvm_analysis_imp_decl(_lsu)
`uvm_analysis_imp_decl(_jump)

class reg_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(reg_scoreboard)

  uvm_analysis_imp_alu #(reg_sequence_item, reg_scoreboard) sc_alu_a_imp;
  uvm_analysis_imp_mul #(reg_sequence_item, reg_scoreboard) sc_mul_a_imp;
  uvm_analysis_imp_lsu #(reg_sequence_item, reg_scoreboard) sc_lsu_a_imp;
  uvm_analysis_imp_jump #(reg_sequence_item, reg_scoreboard) sc_jump_a_imp;
  ral_model m_ral_model;
  static int success_cnt, fail_cnt;

  // Constructor
  function new(string name = "reg_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create the impelmentation port 
    sc_alu_a_imp  = new("sc_alu_a_imp", this);
    sc_mul_a_imp  = new("sc_mul_a_imp", this);
    sc_lsu_a_imp  = new("sc_lsu_a_imp", this);
    sc_jump_a_imp = new("sc_jump_a_imp", this);
    // Get the RAL model from the config DB
    if (!uvm_config_db#(ral_model)::get(this, "", "ral_model", m_ral_model)) begin
      `uvm_error(get_full_name(), "Failed to get configuration for RAL model");
    end
  endfunction

  function void write_alu(reg_sequence_item reg_seq_item);
    logic [31:0] data_o;
    data_o = reg_seq_item.alu_result;
    if (reg_seq_item.regfile_alu_waddr_fw_o == 6'h0) begin
      data_o = 32'h0;
    end
    compare(reg_seq_item, data_o, "ALU");
  endfunction

  function void write_mul(reg_sequence_item reg_seq_item);
    logic [31:0] data_o;
    data_o = reg_seq_item.mult_result;
    if (reg_seq_item.regfile_alu_waddr_fw_o == 6'h0) begin
      data_o = 32'h0;
    end

    compare(reg_seq_item, data_o, "MUL");
  endfunction

  function void write_lsu(reg_sequence_item reg_seq_item);
    logic [31:0] data_o;
    data_o = reg_seq_item.lsu_rdata_i;
    if (reg_seq_item.regfile_waddr_wb_o == 6'h0) begin
      data_o = 32'h0;
    end

    compare(reg_seq_item, data_o, "LSU");
  endfunction

  function void write_jump(reg_sequence_item reg_seq_item);
    logic [31:0] data_o;
    data_o = reg_seq_item.alu_result;
    if (reg_seq_item.regfile_alu_waddr_fw_o == 6'h0) begin
      data_o = 32'h0;
    end

    compare(reg_seq_item, data_o, "JUMP");
  endfunction

  function void compare(input reg_sequence_item my_seq, input logic [31:0] data_o, string block);
    if (my_seq.ref_o != data_o) begin
      fail_cnt++;
      `uvm_info(block, $sformatf(
                "\nrstn: %0b,\nalu_en: %0b,\nmult_en: %0b,\nregfile_alu_waddr_fw_o: %0d,\nalu_result: 0x%8h,\nmult_result: 0x%8h,\nex_valid_o: %0b,\nregfile_waddr_wb_o: %0d,\ndata_rvalid_i: %0b,\nlsu_rdata_i: 0x%8h",
                my_seq.rst_n,
                my_seq.alu_en_i,
                my_seq.mult_en_i,
                my_seq.regfile_alu_waddr_fw_o,
                my_seq.alu_result,
                my_seq.mult_result,
                my_seq.ex_valid_o,
                my_seq.regfile_waddr_wb_o,
                my_seq.data_rvalid_i,
                my_seq.lsu_rdata_i
                ), UVM_NONE);
      `uvm_error("REGISTER", $sformatf(
                 "Mismatch in REGISTER FILE: in REGFILE 0x%8h, RESULT 0x%8h", my_seq.ref_o, data_o
                 ));
    end else begin
      success_cnt++;
    end
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(get_full_name(), $sformatf("Scoreboard: Passed cases: %0d", success_cnt), UVM_NONE);
    `uvm_info(get_full_name(), $sformatf("Scoreboard: Failed cases: %0d", fail_cnt), UVM_NONE);
  endfunction
endclass
