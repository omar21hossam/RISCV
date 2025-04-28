class mul_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(mul_scoreboard)
    
    uvm_analysis_imp #(mul_seq_item, mul_scoreboard) sc_analysis_imp;
    

    function new(string name = "mul_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sc_analysis_imp = new("sc_analysis_imp", this);
    endfunction

    function void write(mul_seq_item t);
        
    endfunction

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        
    endfunction
        
endclass