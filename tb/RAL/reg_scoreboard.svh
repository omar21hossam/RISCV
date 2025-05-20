//==================================================================================
// UVM Analysis Implementation Declaration
//==================================================================================
`uvm_analysis_imp_decl(_alu)
`uvm_analysis_imp_decl(_mul)
`uvm_analysis_imp_decl(_lsu)
`uvm_analysis_imp_decl(_jump)

class reg_scoreboard extends uvm_scoreboard;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(reg_scoreboard)

  //==================================================================================
  // Classes Handles
  //==================================================================================
  ral_model m_ral_model;

  //==================================================================================
  // Data Members
  //==================================================================================
  static int success_cnt, fail_cnt;

  //==================================================================================
  // TLM
  //==================================================================================
  uvm_analysis_imp_alu #(reg_sequence_item, reg_scoreboard) sc_alu_a_imp;
  uvm_analysis_imp_mul #(reg_sequence_item, reg_scoreboard) sc_mul_a_imp;
  uvm_analysis_imp_lsu #(reg_sequence_item, reg_scoreboard) sc_lsu_a_imp;
  uvm_analysis_imp_jump #(reg_sequence_item, reg_scoreboard) sc_jump_a_imp;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "reg_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Creation
    // ----------------------------------------------------------------------------
    sc_alu_a_imp  = new("sc_alu_a_imp", this);
    sc_mul_a_imp  = new("sc_mul_a_imp", this);
    sc_lsu_a_imp  = new("sc_lsu_a_imp", this);
    sc_jump_a_imp = new("sc_jump_a_imp", this);

    // Configuration
    // ----------------------------------------------------------------------------
    // get the RAL model
    // ----------------------
    if (!uvm_config_db#(ral_model)::get(this, "", "ral_model", m_ral_model)) begin
      `uvm_error(get_full_name(), "Failed to get configuration for RAL model");
    end
  endfunction

  //==================================================================================
  // Function: ALU TLM Callback
  //==================================================================================
  function void write_alu(reg_sequence_item reg_seq_item);
    logic [31:0] expected_gpr;
    expected_gpr = reg_seq_item.alu_result;
    if (reg_seq_item.regfile_alu_waddr_fw_o == 6'h0) begin
      expected_gpr = 32'h0;
    end
    compare(reg_seq_item, expected_gpr, "ALU");
  endfunction

  //==================================================================================
  // Function: MUL TLM Callback
  //==================================================================================
  function void write_mul(reg_sequence_item reg_seq_item);
    logic [31:0] expected_gpr;
    expected_gpr = reg_seq_item.mult_result;
    if (reg_seq_item.regfile_alu_waddr_fw_o == 6'h0) begin
      expected_gpr = 32'h0;
    end
    compare(reg_seq_item, expected_gpr, "MUL");
  endfunction

  //==================================================================================
  // Function: LSU TLM Callback
  //==================================================================================
  function void write_lsu(reg_sequence_item reg_seq_item);
    logic [31:0] expected_gpr;
    expected_gpr = reg_seq_item.lsu_rdata_i;
    if (reg_seq_item.regfile_waddr_wb_o == 6'h0) begin
      expected_gpr = 32'h0;
    end

    compare(reg_seq_item, expected_gpr, "LSU");
  endfunction

  //==================================================================================
  // Function: Jump TLM Callback
  //==================================================================================
  function void write_jump(reg_sequence_item reg_seq_item);
    logic [31:0] expected_gpr;
    expected_gpr = reg_seq_item.alu_result;
    if (reg_seq_item.regfile_alu_waddr_fw_o == 6'h0) begin
      expected_gpr = 32'h0;
    end
    compare(reg_seq_item, expected_gpr, "JUMP");
  endfunction

  //==================================================================================
  // Function: Compare
  //==================================================================================
  // Compare the data from the DUT with the reference data
  function void compare(input reg_sequence_item my_seq, input logic [31:0] expected_gpr,
                        string block);
    if (my_seq.actual_gpr != expected_gpr) begin
      fail_cnt++;
      my_seq.print();
      `uvm_fatal(block, $sformatf(
                 "Mismatch in REGISTER FILE: in REGFILE 0x%8h, RESULT 0x%8h",
                 my_seq.actual_gpr,
                 expected_gpr
                 ));
    end else begin
      success_cnt++;
    end
  endfunction

  //==================================================================================
  // Function: Report Phase
  //==================================================================================
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("REGISTER_FILE", $sformatf("\n\nRegister File Scoreboard Summary:\n%s", `DASH_LINE),
              UVM_NONE);
    `uvm_info("REGISTER_FILE", $sformatf("Passed cases: %0d", success_cnt), UVM_NONE);
    `uvm_info("REGISTER_FILE", $sformatf("Failed cases: %0d", fail_cnt), UVM_NONE);
    `uvm_info("REGISTER_FILE", $sformatf("\n%s", `DASH_LINE), UVM_NONE);

  endfunction
endclass
