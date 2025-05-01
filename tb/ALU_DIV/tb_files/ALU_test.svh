class alu_test extends uvm_test;
    `uvm_component_utils(alu_test)
    alu_env env;
    alu_seq seq;
    virtual ALU_interface vinf;
//==============================================================================
//Description: function new
//==============================================================================
    function new(string name = "alu_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
//==============================================================================
//Description: build_phase
//==============================================================================
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = alu_env::type_id::create("env", this);
        seq = alu_seq::type_id::create("seq", this);
        // Create the virtual interface and set it in the config DB
        if(!uvm_config_db #(virtual ALU_interface)::get(this,"", "top2test",vinf))
            `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), "vinf"});
        uvm_config_db #(virtual ALU_interface)::set(this,"env","vif",vinf);
    endfunction:build_phase
//==============================================================================
//Description: run_phase
//==============================================================================
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        seq.start(env.agent.sequencer);
        //#200ns;
        phase.phase_done.set_drain_time(this,30ns);
        phase.drop_objection(this);
    endtask:run_phase
endclass