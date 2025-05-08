class riscv_vsequ_base extends uvm_sequence;

  //==================================================================================
  // Factory Registration
  //==================================================================================
  `uvm_object_utils(riscv_vsequ_base)
  `uvm_declare_p_sequencer(riscv_vseqr_base)

  //==================================================================================
  // Class Handles
  //==================================================================================
  prefetch_sequencer m_instr_seqr;
  lsu_sequencer m_data_seqr;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_vsequ_base", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // task: body
  //==================================================================================
  virtual task pre_body();
    // Connecting the sequencer handles in the sequence to the sequencer handles in the virtual sequencer
    m_instr_seqr = p_sequencer.pf_seqr;
    m_data_seqr = p_sequencer.lsu_seqr;
  endtask

  //==================================================================================
  // task: body
  //==================================================================================
  virtual task body();
    // Start the sequences
  endtask
endclass
