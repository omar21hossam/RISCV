
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
  riscv_config_obj         env_config;
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
  riscv_vseqr              m_vseqr;

  //==================================================================================
  // Interfaces
  //==================================================================================
  virtual lsu_if           lsu_vif;
  virtual ALU_interface    alu_intf_;
  virtual mul_if           mul_intf;
  virtual riscv_intf       riscv_intf_;
  virtual fetch_interface  fetch_interface_;

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
    m_vseqr = riscv_vseqr::type_id::create("m_vseqr", this);

    // Configuration
    //-----------------------------------------------------------------------------------
    // riscv Config Class
    //------------------------------------------
    if (!uvm_config_db#(riscv_config_obj)::get(this, "", "CFG", env_config))
      `uvm_fatal("build_phase", "End to End env - unable to get configuration object")
    uvm_config_db#(riscv_config_obj)::set(this, "m_riscv_main_agent", "CFG", env_config);

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

    // RISCV MAIN interface
    //------------------------------------------
    if (!uvm_config_db#(virtual riscv_intf)::get(this, "", "main_intf", riscv_intf_)) begin
      `uvm_fatal(get_full_name(), "Error in get interface in test");
    end else begin
      uvm_config_db#(virtual riscv_intf)::set(this, "m_riscv_main_agent", "main_intf", riscv_intf_);
    end

    // FETCH intf
    //------------------------------------------
    if (!uvm_config_db#(virtual fetch_interface)::get(
            this, "", "fetch_intf", fetch_interface_
        )) begin
      `uvm_fatal(get_full_name(), "Error in get alu interface in test");
    end else begin
      uvm_config_db#(virtual fetch_interface)::set(this, "m_fetch_agent", "fetch_intf",
                                                   fetch_interface_);
    end
    // ALU intf
    //------------------------------------------
    if (!uvm_config_db#(virtual ALU_interface)::get(this, "", "alu_intf_top2test", alu_intf_)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for alu_if");
    end else begin
      uvm_config_db#(virtual ALU_interface)::set(this, "m_alu_agent", "alu_intf_test2env", alu_intf_);
    end

    // MUL intf
    //------------------------------------------
    if (!uvm_config_db#(virtual mul_if)::get(this, "", "mul_intf", mul_intf)) begin
      `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), ".mul_intf"});
    end else begin
      uvm_config_db#(virtual mul_if)::set(this, "m_mul_agnt", "mul_intf", mul_intf);
    end

    // LSU intf
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

