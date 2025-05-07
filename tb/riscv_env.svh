
class riscv_env extends uvm_env;
  `uvm_component_utils(riscv_env)

  //fetch_agent      fetch_agnt;
  // riscv_scoreboard scoreboard;
  // riscv_subscriber subscriber;
  fetch_config_obj env_config;


  virtual ALU_interface alu_intf_;



  function new(string name = "riscv_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(fetch_config_obj)::get(this, "", "CFG", env_config))
      `uvm_fatal("build_phase", "End to End env - unable to get configuration object")
    uvm_config_db#(fetch_config_obj)::set(this, "fetch_agnt", "CFG", env_config);
//====================================================================
//Description: get alu interface then set it to agent
//====================================================================
 if (!uvm_config_db#(virtual alu_intf_)::get(this, "", "alu_intf_top2test", alu_intf_))
      `uvm_fatal(get_full_name(), "Error in get alu interface in test");
//-----------------------------------------------------------
uvm_config_db#(virtual alu_intf_)::set(this, "env", "alu_intf_test2env", alu_intf_);
//====================================================================

    // fetch_agnt = fetch_agent::type_id::create("fetch_agnt", this);
    // scoreboard = riscv_scoreboard::type_id::create("scoreboard", this);
    // subscriber = riscv_subscriber::type_id::create("subscriber", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //connecting the scoreboard and subscriber to the monitor's analysis port
    // fetch_agnt.agt_ap.connect(scoreboard.sb_export);
    // fetch_agnt.agt_ap.connect(subscriber.cov_export);

  endfunction

endclass

