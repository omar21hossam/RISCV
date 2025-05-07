
class riscv_base_test extends uvm_test;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(riscv_base_test)

  //==================================================================================
  // Class Handle
  //==================================================================================
  riscv_env             env;
  riscv_sequenceb       seq;
  fetch_config_obj      cfg;

  //==================================================================================
  // Interfaces
  //==================================================================================
  virtual riscv_intf    riscv_intf_;
  virtual interface_clk interface_clk_;
  virtual lsu_if        lsu_vif;

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
    // ---------
    env = riscv_env::type_id::create("env", this);
    cfg = fetch_config_obj::type_id::create("cfg", this);
    seq = riscv_sequenceb::type_id::create("seq");
    if (seq == null) `uvm_info("build_phase", "sequence = null ", UVM_LOW);


    //  cfg.agents_are_active = 1;
    //  cfg.has_sb = 1       ;
    //  cfg.has_subsc = 1    ;

    // Configuration
    // -------------
    if (!uvm_config_db#(virtual riscv_intf)::get(this, "", "main_intf", cfg.riscv_vintf_))
      `uvm_fatal(get_full_name(), "Error in get interface in test");

    if (!uvm_config_db#(virtual interface_clk)::get(this, "", "clk_", cfg.interface_clk_))
      `uvm_fatal(get_full_name(), "Error in get interface in test");

    uvm_config_db#(virtual interface_clk)::set(this, "*", "clk_", interface_clk_);


    uvm_config_db#(fetch_config_obj)::set(this, "env", "CFG", cfg);


    if (!uvm_config_db#(virtual lsu_if)::get(this, "", "lsu_intf", lsu_vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for lsu_if");
    end else begin
      uvm_config_db#(virtual lsu_if)::set(this, "env", "lsu_intf", lsu_vif);
    end
  endfunction

  //==================================================================================
  // Task: Run Phase
  //==================================================================================
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq.start(env.fetch_agnt.sqr);
    phase.phase_done.set_drain_time(this, 50 * riscv_pkg::CLK_FREQ);
    phase.drop_objection(this);
  endtask
endclass

