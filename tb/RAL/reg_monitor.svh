class reg_monitor extends uvm_monitor;
  `uvm_component_utils(reg_monitor)

  // Interface
  virtual reg_if reg_intf;
  
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
    // Create sequence item
    seq_item = reg_sequence_item::type_id::create("seq_item");
  endfunction

  // Run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    @(posedge reg_intf.ex_ready_0 or posedge reg_intf.regfile_we_wb_o) #1step;
    // Sample the Ex stage signals
    seq_item.rst_n = reg_intf.rst_n;
    seq_item.alu_en_i = reg_intf.alu_en_i;
    seq_item.mult_en_i = reg_intf.mult_en_i;
    seq_item.regfile_alu_waddr_fw_o = reg_intf.regfile_alu_waddr_fw_o; 
    seq_item.alu_result = reg_intf.alu_result;
    seq_item.mult_result = reg_intf.mult_result;
    seq_item.ex_ready_0 = reg_intf.ex_ready_0;
    // Sample the LSU signals
    seq_item.regfile_waddr_wb_o = reg_intf.regfile_waddr_wb_o;
    seq_item.regfile_we_wb_o = reg_intf.regfile_we_wb_o;
    seq_item.regfile_wdata_wb_o = reg_intf.regfile_wdata_wb_o;    
    // Send the sequence item to the analysis port
    ap.write(seq_item);
  endtask
  endclass


