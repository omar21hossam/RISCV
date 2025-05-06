
class riscv_env extends uvm_env;
  `uvm_component_utils(riscv_env)

  fetch_agent      fetch_agnt;
  mul_agent        mul_agnt;
  riscv_scoreboard scoreboard;
  riscv_subscriber subscriber;
  fetch_config_obj env_config;


  function new(string name = "riscv_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(fetch_config_obj)::get(this, "", "CFG", env_config))
      `uvm_fatal("build_phase", "End to End env - unable to get configuration object")
    uvm_config_db#(fetch_config_obj)::set(this, "fetch_agnt", "CFG", env_config);

    if(!uvm_config_db #(virtual mul_if)::get(this, "", "mul_intf", mul_intf))
            `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), ".mul_intf"});
    uvm_config_db #(virtual mul_if)::set(this, "mul_agnt", "mul_intf", mul_intf);

    fetch_agnt = fetch_agent::type_id::create("fetch_agnt", this);
    scoreboard = riscv_scoreboard::type_id::create("scoreboard", this);
    subscriber = riscv_subscriber::type_id::create("subscriber", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //connecting the scoreboard and subscriber to the monitor's analysis port
    fetch_agnt.agt_ap.connect(scoreboard.sb_export);
    fetch_agnt.agt_ap.connect(subscriber.cov_export);

  endfunction

endclass

