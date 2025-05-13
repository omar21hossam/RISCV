class fetch_coverage_collector extends uvm_component;
  `uvm_component_utils(fetch_coverage_collector)

  fetch_seq_item seq_item;
  uvm_analysis_export #(fetch_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(fetch_seq_item) cov_fifo;
//--------------------------------------------------
  uvm_analysis_export #(fetch_seq_item) cov_export_ip;
  uvm_tlm_analysis_fifo #(fetch_seq_item) cov_fifo_ip;
  fetch_seq_item seq_item_ip,seq_item_op;
  uvm_analysis_export #(fetch_seq_item) cov_export_op;
  uvm_tlm_analysis_fifo #(fetch_seq_item) cov_fifo_op;


//--------------------------------------------------


  covergroup riscv_CP;


  endgroup
  function new(string name = "fetch_coverage_collector", uvm_component parent = null);
    super.new(name, parent);
    riscv_CP = new();
  endfunction

  function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    cov_export_ip = new("cov_export_ip", this);
    cov_fifo_ip   = new("cov_fifo_ip", this);
    cov_export_op = new("cov_export_op", this);
    cov_fifo_op   = new("cov_fifo_op", this);

  endfunction

  function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);
       cov_export_ip.connect(cov_fifo_ip.analysis_export);
       cov_export_op.connect(cov_fifo_op.analysis_export);


  endfunction



  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
  cov_fifo_op.get(seq_item_op);
  cov_fifo_ip.get(seq_item_ip);
        riscv_CP.sample();

    end
  endtask

  /*   function void write(my_sequence_item t);
       
    endfunction

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        
    endfunction */
endclass
