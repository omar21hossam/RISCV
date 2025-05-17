class reg_monitor extends uvm_monitor;
  `uvm_component_utils(reg_monitor)

  // Interface
  virtual reg_if reg_intf;
  ral_model m_ral_model;
  uvm_status_e status;
  
  // sequence item 
  reg_sequence_item seq_item;

  // Monitor signals
  uvm_analysis_port#(reg_sequence_item) ap;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction


  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Regfile interface
    //------------------------------------------
    if (!uvm_config_db#(virtual reg_if)::get(this, "", "reg_intf", reg_intf)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for reg_if");
    end 

    if (!uvm_config_db#(ral_model)::get(this, "", "ral_model", m_ral_model)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for RAL model");
    end
    // Create sequence item
    seq_item = reg_sequence_item::type_id::create("seq_item");
  endfunction

  // Run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin      
    //   @(posedge reg_intf.alu_en_i or posedge reg_intf.mult_en_i or posedge reg_intf.regfile_we_wb_o) #1step;
    //  @(negegde reg_intf.regfile_alu_we_fw_o or negedge reg_intf.regfile_we_wb_o) #1step;
     @(posedge reg_intf.ex_valid_o or posedge reg_intf.regfile_we_wb_o) #1step;
     // Sample the Ex stage signals
     seq_item.rst_n                  = reg_intf.rst_n;
     seq_item.alu_en_i               = reg_intf.alu_en_i;
     seq_item.mult_en_i              = reg_intf.mult_en_i;
     seq_item.regfile_alu_waddr_fw_o = reg_intf.regfile_alu_waddr_fw_o; 
     seq_item.ex_valid_o             = reg_intf.ex_valid_o;
     // Sample the LSU signals
     seq_item.regfile_waddr_wb_o     = reg_intf.regfile_waddr_wb_o;
     seq_item.regfile_we_wb_o        = reg_intf.regfile_we_wb_o;
     @(negedge reg_intf.ex_valid_o or negedge reg_intf.regfile_we_wb_o) #1step;
     // Sampling the results 
     seq_item.alu_result             = reg_intf.alu_result;
     seq_item.mult_result            = reg_intf.mult_result;
     seq_item.regfile_wdata_wb_o     = reg_intf.regfile_wdata_wb_o;   
     if (seq_item.regfile_we_wb_o == 1'b1) begin
      m_ral_model.regs[seq_item.regfile_waddr_wb_o].read(status, seq_item.ref_o, UVM_BACKDOOR);
     end
     else begin
     m_ral_model.regs[seq_item.regfile_alu_waddr_fw_o].read(status, seq_item.ref_o, UVM_BACKDOOR);
     end
     // Send the sequence item to the analysis port
     ap.write(seq_item);
    //   `uvm_info(get_full_name(), $sformatf("ref_o: %0h", ref_o), UVM_NONE);
    //  `uvm_info(get_full_name(), $sformatf("rstn: %0b,alu_en: %0b,mult_en: %0b,regfile_alu_waddr_fw_o: %0h,alu_result: %0h,mult_result: %0h,ex_valid_o: %0b,regfile_waddr_wb_o: %0h,regfile_we_wb_o: %0b,regfile_wdata_wb_o: %0h",
    //    seq_item.rst_n, seq_item.alu_en_i, seq_item.mult_en_i, seq_item.regfile_alu_waddr_fw_o, seq_item.alu_result, seq_item.mult_result, seq_item.ex_valid_o,
    //    seq_item.regfile_waddr_wb_o, seq_item.regfile_we_wb_o, seq_item.regfile_wdata_wb_o), UVM_NONE);
    end
  endtask
  endclass


