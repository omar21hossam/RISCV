class riscv_main_agent extends uvm_agent;

  `uvm_component_utils(riscv_main_agent)  // registeration in the factory 

  uvm_analysis_port #(riscv_sequence_item) agt_ap;

  riscv_config_obj                         cfg;
  riscv_main_driver                             drv;
  riscv_main_sequencer                          m_sequencer;
  virtual riscv_intf riscv_vintf_;

  function new(string name = "riscv_main_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(riscv_config_obj)::get(this, "", "CFG", cfg))
      `uvm_fatal("build_phase", "agent - unable to get configuration object")


    agt_ap = new("agt_ap", this);


    m_sequencer = riscv_main_sequencer::type_id::create("m_sequencer", this);
    drv = riscv_main_driver::type_id::create("drv", this);
    
    if (!uvm_config_db#(virtual riscv_intf)::get(this, "", "main_intf", riscv_vintf_))
      `uvm_fatal(get_full_name(), "Error in get interface in agent");begin
    end else begin
      uvm_config_db#(virtual riscv_intf)::set(this, "drv", "main_intf", riscv_vintf_);
    end


  endfunction

  function void connect_phase(uvm_phase phase);


    super.connect_phase(phase);
    drv.seq_item_port.connect(m_sequencer.seq_item_export);
 


  endfunction

endclass : riscv_main_agent
