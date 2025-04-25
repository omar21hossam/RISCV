class riscv_base_test extends uvm_test;
    `uvm_component_utils(riscv_base_test)
    riscv_env env;
    function new(string name = "riscv_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = riscv_env::type_id::create("env", this);
       
        if(!uvm_config_db #(virtual )::get(this, "", "vif", config_virtual))
            `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), ".config_virtual"});
        uvm_config_db #(virtual )::set(this, "env", "vif", config_virtual);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 5ns);
        phase.drop_objection(this);
    endtask
endclass