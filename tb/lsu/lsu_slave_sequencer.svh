class lsu_slave_sequencer #(
    type REQ = lsu_sequence_item,
    type RSP = REQ
) extends uvm_sequencer #(lsu_sequence_item);

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(lsu_slave_sequencer)

  //==================================================================================
  // TLM
  //==================================================================================
  uvm_analysis_export #(lsu_sequence_item)   req_analysis_export;
  uvm_tlm_analysis_fifo #(lsu_sequence_item) req_analysis_fifo;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "lsu_slave_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building LSU Sequencer", UVM_HIGH);

    // TLM
    // -------
    req_analysis_export = new("req_analysis_export", this);
    req_analysis_fifo   = new("req_analysis_fifo", this);
  endfunction

  //==================================================================================
  // Function: Connect Phase
  //==================================================================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_name(), "Connecting LSU Sequencer", UVM_HIGH);
    req_analysis_export.connect(req_analysis_fifo.analysis_export);
  endfunction

endclass
