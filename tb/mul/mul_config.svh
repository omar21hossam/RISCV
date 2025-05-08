class mlu_config extends uvm_object;
  `uvm_object_utils(mlu_config)
  // Determines if the agent is active or passive
  uvm_active_passive_enum is_active;
  function new(string name = "mlu_config");
    super.new(name);
    is_active = UVM_ACTIVE;  // default to active
  endfunction
endclass : mlu_config
