class mul_config extends uvm_object;
  `uvm_object_utils(mul_config)
  // Determines if the agent is active or passive
  uvm_active_passive_enum is_active;
  function new(string name = "mul_config");
    super.new(name);
    is_active = UVM_ACTIVE;  // default to active
  endfunction
endclass : mul_config
