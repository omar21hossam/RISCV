class mul_coverage_collector extends uvm_subscriber #(mul_seq_item);

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(mul_coverage_collector)

  //==================================================================================
  // Classes Handles
  //==================================================================================
  mul_seq_item m_seq_item;

  //==================================================================================
  // Covergroup: Input Transactions
  //==================================================================================
  covergroup cov_inputs;

  endgroup



  //==================================================================================
  // Covergroup: Output Transactions
  //==================================================================================
  covergroup cov_outputs;

  endgroup

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "mul_coverage_collector", uvm_component parent = null);
    super.new(name, parent);
    cov_inputs  = new();
    cov_outputs = new();
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building MUL Subscriber", UVM_HIGH);
  endfunction

  //==================================================================================
  // Function: Write
  //==================================================================================
  function void write(T t);
    m_seq_item = t;
    cov_inputs.sample();
    cov_outputs.sample();
  endfunction

endclass
