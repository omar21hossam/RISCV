class mul_sequencer extends uvm_sequencer #(mul_seq_item);
    `uvm_component_utils(mul_sequencer)
    
    // Constructor
    function new(string name = "mul_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
   
   endclass : mul_sequencer