class alu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alu_scoreboard)
    uvm_analysis_imp #(alu_seq_item, alu_scoreboard) sc_analysis_imp;
//==============================================================================
//Description: function new
//==============================================================================
    function new(string name = "alu_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction
//==============================================================================
//Description: build_phase
//==============================================================================
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sc_analysis_imp = new("sc_analysis_imp", this);
    endfunction
//==============================================================================
//Description: write function
//==============================================================================
    function void write(alu_seq_item t);
        
    endfunction:write    
endclass