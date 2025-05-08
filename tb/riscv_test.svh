
class riscv_base_test extends uvm_test;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(riscv_base_test)

  //==================================================================================
  // Class Handle
  //==================================================================================
  riscv_env             m_env;
  fetch_config_obj      m_cfg;
  riscv_vseq            m_vseq;

  //==================================================================================
  // Interfaces
  //==================================================================================
  virtual riscv_intf    riscv_intf_;
  virtual lsu_if        lsu_vif;
  virtual mul_if        mul_intf;
  virtual ALU_interface alu_intf_;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Creation
    // ---------------------------------------------------------------------
    m_env  = riscv_env::type_id::create("m_env", this);
    m_cfg  = fetch_config_obj::type_id::create("m_cfg", this);
    m_vseq = riscv_vseq::type_id::create("m_vseq", this);

    // Configuration
    // ---------------------------------------------------------------------
    // fetch_config
    uvm_config_db#(fetch_config_obj)::set(this, "m_env", "CFG", m_cfg);

    // top interface configuration setup
    if (!uvm_config_db#(virtual riscv_intf)::get(this, "", "main_intf", m_cfg.riscv_vintf_))
      `uvm_fatal(get_full_name(), "Error in get interface in test");

    // MUL configuration setup
    if (!uvm_config_db#(virtual mul_if)::get(this, "", "mul_intf", mul_intf)) begin
      `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), ".mul_intf"});
    end else begin
      uvm_config_db#(virtual mul_if)::set(this, "m_env", "mul_intf", mul_intf);
    end

    // LSU configuration setup
    if (!uvm_config_db#(virtual lsu_if)::get(this, "", "lsu_intf", lsu_vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for lsu_if");
    end else begin
      uvm_config_db#(virtual lsu_if)::set(this, "m_env", "lsu_intf", lsu_vif);
    end

    // ALU configuration setup
    if (!uvm_config_db#(virtual alu_intf_)::get(this, "", "alu_intf_top2test", alu_intf_)) begin
      `uvm_fatal(get_full_name(), "Error in get alu interface in test");
    end else begin
      uvm_config_db#(virtual alu_intf_)::set(this, "m_env", "alu_intf_test2env", alu_intf_);
    end
    //====================================================================
  endfunction

  //==================================================================================
  // Task: Run Phase
  //==================================================================================
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    m_vseq.start(m_env.vseqr);
    phase.phase_done.set_drain_time(this, 50 * riscv_pkg::CLK_FREQ);
    phase.drop_objection(this);
  endtask
endclass

