class lsu_slave_sequence extends uvm_sequence;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(lsu_slave_sequence)
  `uvm_declare_p_sequencer(lsu_slave_sequencer)

  //==================================================================================
  // Classes Handles
  //==================================================================================
  lsu_sequence_item m_seq_item_req;
  lsu_sequence_item m_seq_item_rsp;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "lsu_slave_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // Task: Pre-body
  //==================================================================================
  task pre_body();
    m_seq_item_req = lsu_sequence_item::type_id::create("m_seq_item_req");
    m_seq_item_rsp = lsu_sequence_item::type_id::create("m_seq_item_rsp");
  endtask

  //==================================================================================
  // Task: Body
  //==================================================================================
  task body();
    forever begin
      // Wait for the request from the LSU
      p_sequencer.req_analysis_fifo.get(m_seq_item_req);

      // Randomize the request item
      start_item(m_seq_item_rsp);
      if (!m_seq_item_rsp.randomize()) `uvm_fatal(get_name(), "Failed to randomize sequence item");
      finish_item(m_seq_item_rsp);
    end
  endtask

endclass
