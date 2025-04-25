class riscv_env extends uvm_env;
    `uvm_component_utils(riscv_env)
    

    function new(string name = "riscv_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        scoreboard = my_scoreboard::type_id::create("scoreboard", this);
        subscriber = my_subscriber::type_id::create("subscriber", this);
        if(!uvm_config_db #(virtual )::get(this, "", "vif", config_virtual))
            `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), ".config_virtual"});
        uvm_config_db #(virtual )::set(this, "agent", "vif", config_virtual);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        //connecting the scoreboard and subscriber to the monitor's analysis port
        .mon_analysis_port.connect(scoreboard.sc_analysis_imp);
        .mon_analysis_port.connect(subscriber.analysis_export);
    endfunction

endclass