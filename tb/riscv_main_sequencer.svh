
class riscv_main_sequencer extends uvm_sequencer #(riscv_sequence_item);
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(riscv_main_sequencer)

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_main_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass

