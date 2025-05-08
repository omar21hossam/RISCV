class lsu_test extends uvm_test;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(lsu_test)

  //==================================================================================
  // Class Handle
  //==================================================================================
  lsu_env m_env;
  lsu_master_sequence m_seq;

  //==================================================================================
  // Configurations
  //==================================================================================
  virtual lsu_if config_vif;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "lsu_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building LSU Test", UVM_HIGH)

    // Creation
    // ---------
    m_env = lsu_env::type_id::create("m_env", this);
    m_seq = lsu_master_sequence::type_id::create("m_seq", this);


    // Configuration
    // -------------
    if (!uvm_config_db#(virtual lsu_if)::get(this, "", "vif", config_vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for lsu_if");
    end else begin
      uvm_config_db#(virtual lsu_if)::set(this, "m_env", "vif", config_vif);
    end

    // Factory Overrides
    // --------------------
    set_type_override_by_type(lsu_slave_agent::get_type(), lsu_master_agent::get_type());
  endfunction

  //==================================================================================
  // Task: Run Phase
  //==================================================================================
  task run_phase(uvm_phase phase);
    phase.raise_objection(this, "Starting Sequences");
    m_seq.start(m_env.m_agent.m_sequencer);
    phase.phase_done.set_drain_time(this, 10 * riscv_pkg::CLK_FREQ);
    phase.drop_objection(this, "Finished Sequences");
  endtask
endclass
