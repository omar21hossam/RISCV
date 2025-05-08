class vsequencer extend uvm_sequencer;
  `uvm_component_utils(vsequencer)
    prefetch_sequencer pf_seqr;
    lsu_sequencer lsu_seqr;
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


endclass