class riscv_virtual_sequencer extends uvm_sequencer;

  //==================================================================================
  // Factory Registration
  //==================================================================================
  `uvm_component_utils(riscv_virtual_sequencer)

  //==================================================================================
  // Class Handles
  //==================================================================================
  riscv_main_sequencer m_instr_seqr;
  lsu_sequencer m_data_seqr;


  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
