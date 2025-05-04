class lsu_sequencer #(
    type REQ = lsu_sequence_item,
    type RSP = REQ
) extends uvm_sequencer #(lsu_sequence_item);

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(lsu_sequencer)

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "lsu_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass
