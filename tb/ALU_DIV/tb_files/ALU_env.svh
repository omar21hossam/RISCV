class alu_env extends uvm_env;
    `uvm_component_utils(alu_env)
    alu_agent agent;
    alu_scoreboard scoreboard;
    virtual ALU_interface config_virtual;
//==============================================================================
//Description: function new
//==============================================================================
    function new(string name = "alu_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction
//==============================================================================
//Description: build_phase
//==============================================================================
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = alu_agent::type_id::create("agent", this);
        scoreboard = alu_scoreboard::type_id::create("scoreboard", this);
        if(!uvm_config_db #(virtual ALU_interface)::get(this, "", "vif", config_virtual))
            `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), ".config_virtual"});
        uvm_config_db #(virtual ALU_interface)::set(this, "agent", "vif", config_virtual);
    endfunction
//==============================================================================
//Description: run_phase
//==============================================================================
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.analysis_port.connect(scoreboard.sc_analysis_imp);
    endfunction

endclass