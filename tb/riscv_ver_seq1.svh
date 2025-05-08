class vsequ1 extends vseq_base;  
`uvm_object_utils(vsequ1)   
  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "vsequ1", uvm_component parent = null);
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
endclass:vsequ1