class riscv_vsequ_arith extends riscv_vsequ_base;

  //=================================================================================
  // Factory Registration
  //==================================================================================
  `uvm_object_utils(riscv_vsequ_arith)

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_vsequ_arith");
    super.new(name);
  endfunction

  //==================================================================================
  // task: pre_body
  //==================================================================================
  virtual task pre_body();
    super.pre_body();  //call the base class pre_body
  endtask

  //==================================================================================
  // task: body
  //==================================================================================
  virtual task body();
    super.body();  //call the base class body
    fork
      //start the sequences
      //
      //
    join_any
  endtask
endclass : riscv_vsequ_arith
