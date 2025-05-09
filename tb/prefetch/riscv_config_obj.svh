class fetch_config_obj extends uvm_object;
  `uvm_object_utils(fetch_config_obj);


  virtual riscv_intf    riscv_vintf_ ;
   virtual   fetch_interface    fetch_interface_ ;
  //enum curries the agent state {active or passive}
  uvm_active_passive_enum active;

  /////////////////////////function new//////////////////////// 
  function new(string name = "fetch_config_obj");
    super.new(name);
  endfunction

endclass : fetch_config_obj