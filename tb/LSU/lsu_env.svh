class lsu_env extends uvm_env;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(lsu_env)

  //==================================================================================
  // Classes Handles
  //==================================================================================
  lsu_agent m_agent;
  lsu_scoreboard m_scoreboard;
  lsu_subscriber m_subscriber;

  //==================================================================================
  // Configurations
  //==================================================================================
  virtual lsu_if config_vif;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "lsu_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building LSU Environment", UVM_HIGH)

    // Creation
    // ---------
    m_agent = lsu_agent::type_id::create("m_agent", this);
    m_scoreboard = lsu_scoreboard::type_id::create("m_scoreboard", this);
    m_subscriber = lsu_subscriber#()::type_id::create("m_subscriber", this);


    // Configuration
    // -------------
    if (!uvm_config_db#(virtual lsu_if)::get(this, "", "vif", config_vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for lsu_if");
    end else begin
      uvm_config_db#(virtual lsu_if)::set(this, "m_agent", "vif", config_vif);
    end
  endfunction

  //==================================================================================
  // Function: Connect Phase
  //==================================================================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name(), "Connecting LSU Environment", UVM_HIGH)
    m_agent.m_monitor.analysis_port.connect(m_scoreboard.analysis_fifo.analysis_export);
    m_agent.m_monitor.analysis_port.connect(m_subscriber.analysis_export);
  endfunction
endclass
