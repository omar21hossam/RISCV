class riscv_virtual_base_sequence extends uvm_sequence;

  //==================================================================================
  // Factory Registration
  //==================================================================================
  `uvm_object_utils(riscv_virtual_base_sequence)
  `uvm_declare_p_sequencer(riscv_virtual_sequencer)

  //==================================================================================
  // Class Handles
  //==================================================================================
  riscv_main_sequencer m_instr_seqr;
  lsu_sequencer m_data_seqr;
  
  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_virtual_base_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // task: body
  //==================================================================================
  virtual task body();
    m_instr_seqr = p_sequencer.m_instr_seqr;
    m_data_seqr  = p_sequencer.m_data_seqr;
  endtask
endclass
