
class riscv_test extends uvm_test;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(riscv_test)

  //==================================================================================
  // Class Handle
  //==================================================================================
  riscv_env              m_env;
  riscv_virtual_sequence m_vsequence;
  riscv_config_obj       m_riscv_config;
  alu_config             m_alu_config;
  mul_config             m_mul_config;

  //==================================================================================
  // Interfaces
  //==================================================================================
  virtual riscv_if       riscv_vif;
  virtual lsu_if         lsu_vif;
  virtual mul_if         mul_vif;
  virtual alu_if         alu_vif;
  virtual fetch_if       fetch_vif;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Creation
    // ---------------------------------------------------------------------
    m_env = riscv_env::type_id::create("m_env", this);
    m_riscv_config = riscv_config_obj::type_id::create("m_riscv_config", this);
    m_vsequence = riscv_virtual_sequence::type_id::create("m_vsequence", this);

    // Configs
    //------------------------------------------
    m_alu_config = alu_config::type_id::create("m_alu_config", this);
    m_alu_config.is_active = UVM_PASSIVE;
    m_mul_config = mul_config::type_id::create("m_mul_config", this);
    m_mul_config.is_active = UVM_PASSIVE;

    // Configuration
    // ---------------------------------------------------------------------
    // RISCV Config Class
    //------------------------------------------
    uvm_config_db#(riscv_config_obj)::set(this, "m_env", "riscv_config_obj", m_riscv_config);

    // ALU Config Class
    //------------------------------------------
    uvm_config_db#(alu_config)::set(this, "m_env", "alu_config", m_alu_config);

    // MUL Config Class
    //------------------------------------------
    uvm_config_db#(mul_config)::set(this, "m_env", "mul_config", m_mul_config);

    // RISCV Top Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual riscv_if)::get(this, "", "riscv_intf", riscv_vif)) begin
      `uvm_fatal(get_full_name(), "Error in get interface in test");
    end else begin
      uvm_config_db#(virtual riscv_if)::set(this, "m_env", "riscv_intf", riscv_vif);
    end

    // Fetch Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual fetch_if)::get(this, "", "fetch_intf", fetch_vif)) begin
      `uvm_fatal(get_full_name(), "Error in get alu interface in test");
    end else begin
      uvm_config_db#(virtual fetch_if)::set(this, "m_env", "fetch_intf", fetch_vif);
    end

    // ALU Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_intf", alu_vif)) begin
      `uvm_fatal(get_full_name(), "Error in get alu interface in test");
    end else begin
      uvm_config_db#(virtual alu_if)::set(this, "m_env", "alu_intf", alu_vif);
    end

    // MUL Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual mul_if)::get(this, "", "mul_intf", mul_vif)) begin
      `uvm_fatal("NO_INTF", {"Config not found for ", get_full_name(), ".mul_vif"});
    end else begin
      uvm_config_db#(virtual mul_if)::set(this, "m_env", "mul_intf", mul_vif);
    end

    // LSU Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual lsu_if)::get(this, "", "lsu_intf", lsu_vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for lsu_if");
    end else begin
      uvm_config_db#(virtual lsu_if)::set(this, "m_env", "lsu_intf", lsu_vif);
    end

  endfunction

  //==================================================================================
  // Task: Run Phase
  //==================================================================================
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    m_vsequence.start(m_env.m_vseqr);
    phase.phase_done.set_drain_time(this, 10ns * (riscv_pkg::CLK_FREQ));
    phase.drop_objection(this);
  endtask
endclass

