
class riscv_env extends uvm_env;

  //==================================================================================
  // Registeration
  //==================================================================================

  `uvm_component_utils(riscv_env)

  //==================================================================================
  // Classes Handles
  //==================================================================================
  fetch_agent      fetch_agnt;
  riscv_scoreboard scoreboard;
  riscv_subscriber subscriber;
  fetch_config_obj env_config;
  lsu_agent        m_lsu_agent;
  lsu_scoreboard   m_lsu_scoreboard;
  lsu_subscriber   m_lsu_subscriber;

  //==================================================================================
  // Interface
  //==================================================================================
  virtual lsu_if lsu_vif;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Creation
    // ---------
    fetch_agnt = fetch_agent::type_id::create("fetch_agnt", this);
    scoreboard = riscv_scoreboard::type_id::create("scoreboard", this);
    subscriber = riscv_subscriber::type_id::create("subscriber", this);
    m_lsu_agent = lsu_agent::type_id::create("m_lsu_agent", this);
    m_lsu_scoreboard = lsu_scoreboard::type_id::create("m_lsu_scoreboard", this);
    m_lsu_subscriber = lsu_subscriber#()::type_id::create("m_lsu_subscriber", this);

    // Configuration
    // -------------
    if (!uvm_config_db#(fetch_config_obj)::get(this, "", "CFG", env_config))
      `uvm_fatal("build_phase", "End to End env - unable to get configuration object")
    uvm_config_db#(fetch_config_obj)::set(this, "fetch_agnt", "CFG", env_config);

    if (!uvm_config_db#(virtual lsu_if)::get(this, "", "lsu_intf", lsu_vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for lsu_if");
    end else begin
      uvm_config_db#(virtual lsu_if)::set(this, "m_agent", "lsu_intf", lsu_vif);
    end
  endfunction

  //==================================================================================
  // Function: Connect Phase
  //==================================================================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //connecting the scoreboard and subscriber to the monitor's analysis port
    fetch_agnt.agt_ap.connect(scoreboard.sb_export);
    fetch_agnt.agt_ap.connect(subscriber.cov_export);

    // LSU TLM
    m_lsu_agent.m_lsu_monitor.analysis_port.connect(m_lsu_scoreboard.analysis_fifo.analysis_export);
    m_lsu_agent.m_lsu_monitor.analysis_port.connect(m_lsu_subscriber.analysis_export);
  endfunction

endclass

