class riscv_virtual_sequence extends riscv_virtual_base_sequence;

  //=================================================================================
  // Factory Registration
  //==================================================================================
  `uvm_object_utils(riscv_virtual_sequence)

  //==================================================================================
  // Class Handles
  //==================================================================================
  riscv_init_sequence m_init_sequence;
  lsu_sequence m_lsu_sequence;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_virtual_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // task: pre_body
  //==================================================================================
  virtual task pre_body();
    super.pre_body();  //call the base class pre_body
    m_init_sequence = riscv_init_sequence::type_id::create("m_init_sequence");
    m_lsu_sequence = lsu_sequence::type_id::create("m_lsu_sequence");
  endtask

  //==================================================================================
  // task: body
  //==================================================================================
  virtual task body();
    super.body();  //call the base class body
    fork
      //start the sequences
      begin
        m_init_sequence.start(m_instr_seqr);
      end
      m_lsu_sequence.start(m_data_seqr);
    join_any
  endtask
endclass
