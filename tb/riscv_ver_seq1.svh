class riscv_vseq extends vseq_base;  
`uvm_object_utils(riscv_vseq)   
  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_vseq", uvm_component parent = null);
    super.new(name, parent);
  endfunction
//==================================================================================
// methods: pre_body
//==================================================================================
 virtual task pre_body();
  //create the our sequences(lsu and prefetch)
  endtask

  virtual task body();
   //randomized and start the sequences
  endtask
endclass:riscv_vseq