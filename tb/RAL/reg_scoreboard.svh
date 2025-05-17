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
      
    if (reg_seq_item.data_rvalid_i == 1'b1) begin
      data_o = reg_seq_item.regfile_wdata_wb_o;
      if (reg_seq_item.regfile_waddr_wb_o == 6'h0) begin
        data_o = 32'h0;
      end
    end
      else if (reg_seq_item.mult_en_i) begin
        data_o = reg_seq_item.mult_result;
        if (reg_seq_item.regfile_alu_waddr_fw_o == 6'h0) begin
          data_o = 32'h0;
        end
      end
  
    else if(reg_seq_item.alu_en_i) begin
        data_o = reg_seq_item.alu_result;
        if (reg_seq_item.regfile_alu_waddr_fw_o == 6'h0) begin
          data_o = 32'h0;
        end
      end
     if (reg_seq_item.ref_o != data_o) begin
        fail_cnt++;
        `uvm_warning("REGISTER", $sformatf("Mismatch in REGISTER FILE: in REGFILE %0h, RESULT %0h", reg_seq_item.ref_o, data_o));
         `uvm_info(get_full_name(), $sformatf("rstn: %0b,alu_en: %0b,mult_en: %0b,regfile_alu_waddr_fw_o: %0h,alu_result: %0h,mult_result: %0h,ex_valid_o: %0b,regfile_waddr_wb_o: %0h,data_rvalid_i: %0b,regfile_wdata_wb_o: %0h",
       reg_seq_item.rst_n, reg_seq_item.alu_en_i, reg_seq_item.mult_en_i, reg_seq_item.regfile_alu_waddr_fw_o, reg_seq_item.alu_result, reg_seq_item.mult_result, reg_seq_item.ex_valid_o,
       reg_seq_item.regfile_waddr_wb_o, reg_seq_item.data_rvalid_i, reg_seq_item.regfile_wdata_wb_o), UVM_NONE);
      end else begin
        success_cnt++;
       // `uvm_info("REGISTER", $sformatf("ALU write successful: %0h RAL write successful: %0h", data_o, reg_seq_item.ref_o), UVM_MEDIUM);
      end
      
    endfunction

    function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(get_full_name(), $sformatf("Scoreboard: Passed cases: %0d", success_cnt), UVM_NONE);
    `uvm_info(get_full_name(), $sformatf("Scoreboard: Failed cases: %0d", fail_cnt), UVM_NONE);
  endfunction
endclass 
