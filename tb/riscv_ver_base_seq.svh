class vseq_base extends uvm_sequence;
`uvm_object_utils(vseq_base)
`uvm_declare_p_sequencer(vsequencer)
    prefetch_sequencer pf_seqr;
    lsu_sequencer lsu_seqr;
  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "vseq_base", uvm_component parent = null);
    super.new(name, parent);
  endfunction
//==================================================================================
// Connecting the sequencer handles in the sequence to the sequencer handles in the virtual sequencer
//==================================================================================
  virtual task body();
    pf_seqr = p_sequencer.pf_seqr;
    lsu_seqr = p_sequencer.lsu_seqr;
  endtask
endclass