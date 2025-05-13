
class riscv_env extends uvm_env;
  `uvm_component_utils(riscv_env)

  fetch_agent      fetch_agnt;
  fetch_scoreboard scoreboard;
  fetch_coverage_collector subscriber;
  fetch_config_obj env_config;


  function new(string name = "riscv_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(fetch_config_obj)::get(this, "", "CFG", env_config))
      `uvm_fatal("build_phase", "End to End env - unable to get configuration object")
    uvm_config_db#(fetch_config_obj)::set(this, "fetch_agnt", "CFG", env_config);


    fetch_agnt = fetch_agent::type_id::create("fetch_agnt", this);
    scoreboard = fetch_scoreboard::type_id::create("scoreboard", this);
    subscriber = fetch_coverage_collector::type_id::create("subscriber", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //connecting the scoreboard and subscriber to the monitor's analysis port
     fetch_agnt.agt_ap_ip.connect(scoreboard.sb_export_ip);
    fetch_agnt.agt_ap_op.connect(scoreboard.sb_export_op);
    fetch_agnt.agt_ap_ip.connect(subscriber.cov_export_ip);
    fetch_agnt.agt_ap_op.connect(subscriber.cov_export_op);
  endfunction

endclass

