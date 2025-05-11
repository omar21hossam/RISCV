
class riscv_env extends uvm_env;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(riscv_env)

  //==================================================================================
  // Classes Handles
  //==================================================================================
  // Configuration Classes
  //-----------------------------------------------------------------------------------
  riscv_config_obj         m_riscv_config;
  alu_config               m_alu_config;
  mul_config               m_mul_config;

  // Agents
  //-----------------------------------------------------------------------------------
  fetch_agent              m_fetch_agent;
  mul_agent                m_mul_agent;
  lsu_agent                m_lsu_agent;
  alu_agent                m_alu_agent;
  riscv_main_agent         m_riscv_main_agent;
  // Coverage Collectors
  //-----------------------------------------------------------------------------------
  lsu_coverage_collector   m_lsu_cov_collector;
  alu_coverage_collector   m_alu_cov_collector;
  mul_coverage_collector   m_mul_cov_collector;
  fetch_coverage_collector m_fetch_coverage_collector;

  // Scoreboards
  //-----------------------------------------------------------------------------------
  lsu_scoreboard           m_lsu_scoreboard;
  alu_scoreboard           m_alu_scoreboard;
  mul_scoreboard           m_mul_scoreboard;
  fetch_scoreboard         m_fetch_scoreboard;
  // Virtual Sequencer
  //-----------------------------------------------------------------------------------
  riscv_virtual_sequencer  m_vseqr;

  //==================================================================================
  // Interfaces
  //==================================================================================
  virtual lsu_if           lsu_vif;
  virtual alu_if           alu_vif;
  virtual mul_if           mul_vif;
  virtual riscv_if         riscv_vif;
  virtual fetch_if         fetch_vif;

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
    //-----------------------------------------------------------------------------------
    // Agents
    //------------------------------------------
    m_riscv_main_agent = riscv_main_agent::type_id::create("m_riscv_main_agent", this);
    m_fetch_agent = fetch_agent::type_id::create("m_fetch_agent", this);
    m_alu_agent = alu_agent::type_id::create("m_alu_agent", this);
    m_mul_agent = mul_agent::type_id::create("m_mul_agent", this);
    m_lsu_agent = lsu_agent::type_id::create("m_lsu_agent", this);


    // Coverage Collectors
    //------------------------------------------
    m_lsu_cov_collector = lsu_coverage_collector#()::type_id::create("m_lsu_cov_collector", this);
    m_alu_cov_collector = alu_coverage_collector::type_id::create("m_alu_cov_collector", this);
    m_mul_cov_collector = mul_coverage_collector::type_id::create("m_mul_cov_collector", this);
    m_fetch_coverage_collector =
        fetch_coverage_collector::type_id::create("m_fetch_coverage_collector", this);

    // Scoreboards
    //------------------------------------------
    m_lsu_scoreboard = lsu_scoreboard::type_id::create("m_lsu_scoreboard", this);
    m_alu_scoreboard = alu_scoreboard::type_id::create("m_alu_scoreboard", this);
    m_mul_scoreboard = mul_scoreboard::type_id::create("m_mul_scoreboard", this);
    m_fetch_scoreboard = fetch_scoreboard::type_id::create("m_fetch_scoreboard", this);

    // Virtual Sequencer
    //------------------------------------------
    m_vseqr = riscv_virtual_sequencer::type_id::create("m_vseqr", this);

    // Configuration
    //-----------------------------------------------------------------------------------
    // RISCV Config Class
    //------------------------------------------
    if (!uvm_config_db#(riscv_config_obj)::get(this, "", "riscv_config_obj", m_riscv_config))
      `uvm_fatal("build_phase", "End to End env - unable to get configuration object")
    uvm_config_db#(riscv_config_obj)::set(this, "m_riscv_main_agent", "riscv_config_obj",
                                          m_riscv_config);

    // ALU Config Class
    //------------------------------------------
    if (!uvm_config_db#(alu_config)::get(this, "", "alu_config", m_alu_config)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for alu_config");
    end else begin
      uvm_config_db#(alu_config)::set(this, "m_alu_agent", "alu_config", m_alu_config);
    end

    // MUL Config Class
    //------------------------------------------
    if (!uvm_config_db#(mul_config)::get(this, "", "mul_config", m_mul_config)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for mul_config");
    end else begin
      uvm_config_db#(mul_config)::set(this, "m_mul_agent", "mul_config", m_mul_config);
    end

    // RISCV Main Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual riscv_if)::get(this, "", "riscv_intf", riscv_vif)) begin
      `uvm_fatal(get_full_name(), "Error in get interface in test");
    end else begin
      uvm_config_db#(virtual riscv_if)::set(this, "m_riscv_main_agent", "riscv_intf", riscv_vif);
    end

    // Fetch Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual fetch_if)::get(this, "", "fetch_intf", fetch_vif)) begin
      `uvm_fatal(get_full_name(), "Error in get alu interface in test");
    end else begin
      uvm_config_db#(virtual fetch_if)::set(this, "m_fetch_agent", "fetch_intf", fetch_vif);
    end
    // ALU Inteface
    //------------------------------------------
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_intf", alu_vif)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for alu_if");
    end else begin
      uvm_config_db#(virtual alu_if)::set(this, "m_alu_agent", "alu_intf", alu_vif);
    end

    // MUL Inteface
    //------------------------------------------
    if (!uvm_config_db#(virtual mul_if)::get(this, "", "mul_intf", mul_vif)) begin
      `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), ".mul_intf"});
    end else begin
      uvm_config_db#(virtual mul_if)::set(this, "m_mul_agent", "mul_intf", mul_vif);
    end

    // LSU Inteface
    //------------------------------------------
    if (!uvm_config_db#(virtual lsu_if)::get(this, "", "lsu_intf", lsu_vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for lsu_if");
    end else begin
      uvm_config_db#(virtual lsu_if)::set(this, "m_lsu_agent", "lsu_intf", lsu_vif);
    end
  endfunction

  //==================================================================================
  // Function: Connect Phase
  //==================================================================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // TLM
    //FETCH
    //-----------------------------------------------------------------------------------
    m_fetch_agent.agt_ap.connect(m_fetch_scoreboard.sb_export);
    m_fetch_agent.agt_ap.connect(m_fetch_coverage_collector.cov_export);
    // ALU
    //------------------------------------------
    m_alu_agent.m_monitor.analysis_port.connect(m_alu_scoreboard.sc_analysis_imp);
    m_alu_agent.m_monitor.analysis_port.connect(m_alu_cov_collector.alu_mon2cov);

    // MUL
    //------------------------------------------
    m_mul_agent.monitor.mon_analysis_port.connect(m_mul_scoreboard.sc_analysis_imp);
    m_mul_agent.monitor.mon_analysis_port.connect(m_mul_cov_collector.analysis_export);

    // LSU
    //------------------------------------------
    m_lsu_agent.m_monitor.analysis_port.connect(m_lsu_scoreboard.analysis_fifo.analysis_export);
    m_lsu_agent.m_monitor.analysis_port.connect(m_lsu_cov_collector.analysis_export);

    // Virtual Sequencers Connections
    //-----------------------------------------------------------------------------------
    m_vseqr.m_instr_seqr = m_riscv_main_agent.m_sequencer;
    m_vseqr.m_data_seqr  = m_lsu_agent.m_sequencer;
  endfunction

endclass

