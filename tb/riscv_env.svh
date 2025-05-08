
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
  fetch_config_obj       env_config;
  alu_config             m_alu_config;
  mul_config             m_mul_config;

  // Agents
  //-----------------------------------------------------------------------------------
  fetch_agent            m_fetch_agent;
  mul_agent              m_mul_agent;
  lsu_agent              m_lsu_agent;
  alu_agent              m_alu_agent;

  // Coverage Collectors
  //-----------------------------------------------------------------------------------
  lsu_coverage_collector m_lsu_cov_collector;
  alu_coverage_collector m_alu_cov_collector;
  mul_coverage_collector m_mul_cov_collector;

  // Scoreboards
  //-----------------------------------------------------------------------------------
  lsu_scoreboard         m_lsu_scoreboard;
  alu_scoreboard         m_alu_scoreboard;
  mul_scoreboard         m_mul_scoreboard;

  // Virtual Sequencer
  //-----------------------------------------------------------------------------------
  riscv_vseqr            m_vseqr;

  //==================================================================================
  // Interfaces
  //==================================================================================
  virtual lsu_if         lsu_vif;
  virtual ALU_interface  alu_intf_;
  virtual mul_if         mul_intf;
  virtual riscv_intf     riscv_intf_;

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

    // Configs
    //------------------------------------------
    m_alu_config = alu_config::type_id::create("m_alu_config", this);
    m_mul_config = mul_config::type_id::create("m_mul_config", this);

    // Agents
    //------------------------------------------
    m_vseqr = riscv_vseqr::type_id::create("m_vseqr", this);
    m_fetch_agent = fetch_agent::type_id::create("m_fetch_agent", this);
    m_alu_agent = alu_agent::type_id::create("m_alu_agent", this);
    m_mul_agent = mul_agent::type_id::create("m_mul_agent", this);
    m_lsu_agent = lsu_agent::type_id::create("m_lsu_agent", this);


    // Coverage Collectors
    //------------------------------------------
    m_lsu_cov_collector = lsu_coverage_collector#()::type_id::create("m_lsu_cov_collector", this);
    m_alu_cov_collector = alu_coverage_collector::type_id::create("m_alu_cov_collector", this);
    m_mul_cov_collector = mul_coverage_collector::type_id::create("m_mul_cov_collector", this);

    // Scoreboards
    //------------------------------------------
    m_lsu_scoreboard = lsu_scoreboard::type_id::create("m_lsu_scoreboard", this);
    m_alu_scoreboard = alu_scoreboard::type_id::create("m_alu_scoreboard", this);
    m_mul_scoreboard = mul_scoreboard::type_id::create("m_mul_scoreboard", this);

    // Virtual Sequencer
    //------------------------------------------
    m_vseqr = riscv_vseqr::type_id::create("m_vseqr", this);

    // Configuration
    //-----------------------------------------------------------------------------------

    // Fetch Config Class
    //------------------------------------------
    if (!uvm_config_db#(fetch_config_obj)::get(this, "", "CFG", env_config))
      `uvm_fatal("build_phase", "End to End env - unable to get configuration object")
    uvm_config_db#(fetch_config_obj)::set(this, "m_fetch_agent", "CFG", env_config);

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

    // ALU Configurations
    //------------------------------------------
    if (!uvm_config_db#(virtual alu_intf_)::get(this, "", "alu_intf_top2test", alu_intf_)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for alu_if");
    end else begin
      uvm_config_db#(virtual alu_intf_)::set(this, "m_alu_agent", "alu_intf_test2env", alu_intf_);
    end

    // MUL Configurations
    //------------------------------------------
    if (!uvm_config_db#(virtual mul_if)::get(this, "", "mul_intf", mul_intf)) begin
      `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), ".mul_intf"});
    end else begin
      uvm_config_db#(virtual mul_if)::set(this, "m_mul_agnt", "mul_intf", mul_intf);
    end

    // LSU Configurations
    //------------------------------------------
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

    // TLM
    //-----------------------------------------------------------------------------------

    // ALU
    //------------------------------------------
    m_alu_agent.monitor.analysis_port.connect(m_alu_scoreboard.sc_analysis_imp);

    // MUL
    //------------------------------------------

    // LSU
    //------------------------------------------
    m_lsu_agent.m_monitor.analysis_port.connect(m_lsu_scoreboard.analysis_fifo.analysis_export);
    m_lsu_agent.m_monitor.analysis_port.connect(m_lsu_cov_collector.analysis_export);

    // Virtual Sequencers Connections
    //-----------------------------------------------------------------------------------
    m_vseqr.m_instr_seqr = m_fetch_agent.m_sequencer;
    m_vseqr.m_data_seqr  = m_lsu_agent.m_sequencer;
  endfunction

endclass

