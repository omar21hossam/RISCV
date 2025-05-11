class riscv_main_agent extends uvm_agent;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(riscv_main_agent)  // registeration in the factory 

  //==================================================================================
  // TLM
  //==================================================================================
  uvm_analysis_port #(riscv_sequence_item) agt_ap;

  //==================================================================================
  // Classes Handles
  //==================================================================================
  riscv_config_obj                         m_config;
  riscv_main_driver                        m_driver;
  riscv_main_sequencer                     m_sequencer;
  virtual riscv_if                         riscv_vif;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_main_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(riscv_config_obj)::get(this, "", "riscv_config_obj", m_config))
      `uvm_fatal("build_phase", "agent - unable to get configuration object")


    agt_ap = new("agt_ap", this);


    m_sequencer = riscv_main_sequencer::type_id::create("m_sequencer", this);
    m_driver = riscv_main_driver::type_id::create("m_driver", this);

    if (!uvm_config_db#(virtual riscv_if)::get(this, "", "riscv_intf", riscv_vif)) begin
      `uvm_fatal(get_full_name(), "Error in get interface in agent");
    end else begin
      uvm_config_db#(virtual riscv_if)::set(this, "m_driver", "riscv_intf", riscv_vif);
    end


  endfunction

  //==================================================================================
  // Function: Connect Phase
  //==================================================================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  endfunction

endclass : riscv_main_agent
