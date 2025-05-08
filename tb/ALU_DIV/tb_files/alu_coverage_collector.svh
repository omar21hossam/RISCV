class alu_coverage_collector extends uvm_scoreboard;
  `uvm_component_utils(alu_coverage_collector)
  //==============================================================================
  //Description: Declare my transactions here
  //==============================================================================
  alu_seq_item trans_in;
  //==============================================================================
  //Description: Declare mailboxs
  //==============================================================================
  uvm_analysis_imp #(alu_seq_item, alu_coverage_collector) alu_mon2cov;
  //==============================================================================
  //Description: Declare my output coverage collector here
  //==============================================================================
  covergroup alu_output_group;
  endgroup : alu_output_group
  ;
  //==============================================================================
  //Description: Declare my input coverage collector here
  //==============================================================================
  covergroup alu_input_group;
  endgroup : alu_input_group
  ;
  //==============================================================================

  //======================================
  //declare constructor
  //======================================
  function new(string name = "alu_coverage_collector", uvm_component parent = null);
    super.new(name, parent);
    alu_mon2cov = new("alu_mon2cov", this);
    //=======================================================
    trans_in = alu_seq_item::type_id::create("trans_in");
    //=======================================================
    alu_output_group = new();
    alu_input_group = new();
  endfunction : new
  //======================================
  //declare extern methods
  //======================================
  extern function void write(alu_seq_item alu_trans);
endclass : alu_coverage_collector

//======================================
//extern methods
//======================================
function void alu_coverage_collector::write(alu_seq_item alu_trans);
  trans_in = alu_trans;
  if (trans_in.in_out) begin : output_trans

  end else begin : input_trans

  end



  //$cast(trans_in,slv_pkt.clone());  //TODO:check the clone method not work correctly
  // trans_in =slv_pkt;
  // slave_group.sample();
  // `uvm_info(get_type_name(),$sformatf("sampling is slave success"),UVM_NONE);
endfunction
