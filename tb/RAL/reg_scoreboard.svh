class reg_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(reg_scoreboard)

 uvm_analysis_imp #(reg_sequence_item, reg_scoreboard) sc_a_imp;
 ral_model m_ral_model;
 logic [31:0] data_o;
 int success_cnt,fail_cnt;
  // Constructor
  function new(string name = "reg_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create the impelmentation port 
    sc_a_imp = new("sc_a_imp", this);
    // Get the RAL model from the config DB
    if (!uvm_config_db#(ral_model)::get(this, "", "ral_model", m_ral_model)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for RAL model");
    end
  endfunction
  


  function void write (reg_sequence_item reg_seq_item);
      if(reg_seq_item.alu_en_i) begin
        data_o = reg_seq_item.alu_result;
      end
      else if (reg_seq_item.mult_en_i) begin
        data_o = reg_seq_item.mult_result;
      end
    else if (reg_seq_item.regfile_we_wb_o == 1'b1) begin
      data_o = reg_seq_item.regfile_wdata_wb_o;
    end
     if (reg_seq_item.ref_o != data_o) begin
        fail_cnt++;
        `uvm_warning("ALU Write", $sformatf("Mismatch in ALU write: in REGFILE %0h, RESULT %0h", reg_seq_item.ref_o, data_o));
      end else begin
        success_cnt++;
        `uvm_info("ALU Write", $sformatf("ALU write successful: %0h RAL write successful: %0h", data_o, reg_seq_item.ref_o), UVM_MEDIUM);
      end
      
    endfunction

    function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(get_full_name(), $sformatf("Scoreboard: Passed cases: %0d", success_cnt), UVM_NONE);
    `uvm_info(get_full_name(), $sformatf("Scoreboard: Failed cases: %0d", fail_cnt), UVM_NONE);
  endfunction
endclass 
