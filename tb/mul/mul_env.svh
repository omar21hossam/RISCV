class mul_env extends uvm_env;
    `uvm_component_utils(mul_env)
    mul_agent agent;
    mul_scoreboard scoreboard;
    virtual mul_if config_virtual;

    function new(string name = "mul_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = mul_agent::type_id::create("agent", this);
        scoreboard = mul_scoreboard::type_id::create("scoreboard", this);
        if(!uvm_config_db #(virtual mul_if)::get(this, "", "vif", config_virtual))
            `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), ".config_virtual"});
        uvm_config_db #(virtual mul_if)::set(this, "agent", "vif", config_virtual);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        //connecting the scoreboard and subscriber to the monitor's analysis port
        agent.monitor.mon_analysis_port.connect(scoreboard.sc_analysis_imp);
    endfunction

endclass