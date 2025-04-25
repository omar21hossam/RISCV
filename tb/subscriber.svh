class riscv_subscriber extends uvm_subscriber #(my_sequence_item);
    `uvm_component_utils(riscv_subscriber)
   
    
    function new(string name = "riscv_subscriber", uvm_component parent = null);
        super.new(name, parent);
        
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    function void write(my_sequence_item t);
       
    endfunction

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        
    endfunction
endclass