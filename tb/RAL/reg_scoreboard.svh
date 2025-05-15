class reg_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(reg_scoreboard)

 uvm_analysis_imp #(reg_sequence_item, reg_scoreboard) sc_a_imp;
 ral_model m_ral_model;
 logic [31:0] ref_o,data_o;
 int success_cnt,fail_cnt;
  // Constructor
  function new(string name = "reg_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create the impelmentation port 
    sc_a_imp = new(this, "sc_a_imp");
  endfunction


  function void write (reg_sequence_item reg_seq_item);
   if(reg_seq_item.ex_ready_0 == 1) begin
     ref_o = m_ral_model.regs[reg_seq_item.regfile_alu_waddr_fw_o].get_mirrored_value();
      if(reg_seq_item.alu_en_i)
        data_o = reg_seq_item.alu_result;
      else if (reg_seq_item.mult_en_i)
        data_o = reg_seq_item.mult_result;
     if (ref_o != data_o) begin
        fail_cnt++;
        `uvm_warning("ALU Write", $sformatf("Mismatch in ALU write: expected %0h, got %0h", ref_o, data_o));
      end else begin
        success_cnt++;
        `uvm_info("ALU Write", $sformatf("ALU write successful: %0h", data_o), UVM_HIGH);
      end
    end
    else if (reg_seq_item.regfile_we_wb_o == 1'b1) begin
      ref_o = m_ral_model.regs[reg_seq_item.regfile_waddr_wb_o].get_mirrored_value();
      data_o = reg_seq_item.regfile_wdata_wb_o;
      if (ref_o != data_o) begin
        fail_cnt++;
        `uvm_warning("Regfile Write", $sformatf("Mismatch in Regfile write: expected %0h, got %0h", ref_o, data_o));
      end else begin
        success_cnt++;
        `uvm_info("Regfile Write", $sformatf("Regfile write successful: %0h", data_o), UVM_HIGH);
      end
    end
    endfunction
endclass 