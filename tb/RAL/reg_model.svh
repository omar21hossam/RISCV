class register_RAL  extends uvm_reg
  `uvm_object_utils(register_RAL)

  // Register fields
  uvm_reg_field field1;
  
  // Constructor
  function new(string name = "register_RAL");
    super.new(name, 32, UVM_NO_COVERAGE);
    field1 = uvm_reg_field::type_id::create("field1", this);
  endfunction

  // Build phase
  function void build();
    super.build();
    field1.configure(this, 32, 0, "RW", 0, 32'b0, 1, 1, 1);
  endfunction
  endclass

  class PC_reg extends uvm_reg;
  `uvm_object_utils(PC_reg)

  // Register fields
  uvm_reg_field field1;

  // Constructor
  function new(string name = "PC_reg");
    super.new(name, 32, UVM_NO_COVERAGE);
    field1 = uvm_reg_field::type_id::create("field1", this);
  endfunction

  // Build phase
  function void build();
    super.build();
    field1.configure(this, 32, 0, "RW", 0, 32'b0, 1, 1, 1);
  endfunction
  endclass
