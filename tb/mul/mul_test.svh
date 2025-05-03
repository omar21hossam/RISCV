class mul_test extends uvm_test;
    `uvm_component_utils(mul_test)
    mul_env env;
    mul_seq seq;
    virtual mul_if config_virtual;
    function new(string name = "mul_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = mul_env::type_id::create("env", this);
        seq = mul_seq::type_id::create("seq", this);
        // Create the virtual interface and set it in the config DB
        if(!uvm_config_db #(virtual mul_if)::get(this, "", "vif", config_virtual))
            `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), ".config_virtual"});
        uvm_config_db #(virtual mul_if)::set(this, "env", "vif", config_virtual);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        seq.start(env.agent.sequencer);
        phase.phase_done.set_drain_time(this, 90ns);
        phase.drop_objection(this);
    endtask
endclass