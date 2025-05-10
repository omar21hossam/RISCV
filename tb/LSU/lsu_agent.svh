class lsu_agent extends uvm_agent;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(lsu_agent)

  //==================================================================================
  // Classes Handles
  //==================================================================================
  lsu_sequencer m_sequencer;
  lsu_driver m_driver;
  lsu_monitor m_monitor;

  //==================================================================================
  // Configurations
  //==================================================================================
  virtual lsu_if config_vif;


  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building LSU Agent", UVM_HIGH);

    // Creation
    // ---------
    m_sequencer = lsu_sequencer#()::type_id::create("m_sequencer", this);
    m_driver = lsu_driver#()::type_id::create("m_driver", this);
    m_monitor = lsu_monitor::type_id::create("m_monitor", this);

    // Driver and Monitor Configuration
    if (!uvm_config_db#(virtual lsu_if)::get(this, "", "lsu_intf", config_vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for lsu_if");
    end else begin
      uvm_config_db#(virtual lsu_if)::set(this, "m_driver", "vif", config_vif);
      uvm_config_db#(virtual lsu_if)::set(this, "m_monitor", "vif", config_vif);
    end

  endfunction

  //==================================================================================
  // Function: Connect Phase
  //==================================================================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name(), "Connecting LSU Agent", UVM_HIGH);
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  endfunction
endclass
