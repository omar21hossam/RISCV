class riscv_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(riscv_scoreboard)
    


uvm_analysis_export#(fetch_seq_item) sb_export ;
uvm_tlm_analysis_fifo#(fetch_seq_item) sb_fifo ; 
fetch_seq_item seq_item  ;

    function new(string name = "riscv_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
       sb_export=new("sb_export",this) ; 
       sb_fifo = new("sb_fifo",this) ; 
    endfunction
function void connect_phase(uvm_phase phase ) ; 
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export) ;

endfunction


task run_phase(uvm_phase phase ) ; 
    super.run_phase(phase) ; 

      forever begin
      sb_fifo.get(seq_item) ; 
 /* check inst_fetch done correctly from: 
 mem(driver) >- prefetch buffer >- aligner >- c.decoder >- ifstage op
 */

     
//seq_item






      end

      endtask



 /*   function void write(my_sequence_item t);
        
    endfunction

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        
    endfunction  */
        
endclass

