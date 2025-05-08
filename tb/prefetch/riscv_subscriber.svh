class riscv_subscriber extends uvm_component ;
    `uvm_component_utils(riscv_subscriber)
   
    riscv_seq_item  seq_item;
    uvm_analysis_export#(riscv_seq_item) cov_export ;
uvm_tlm_analysis_fifo#(riscv_seq_item) cov_fifo ; 
covergroup riscv_CP;


endgroup
    function new(string name = "riscv_subscriber", uvm_component parent = null);
        super.new(name, parent);
        riscv_CP =new();
    endfunction

function void build_phase (uvm_phase phase);

    super.build_phase(phase) ; 
    cov_export=new("cov_export",this) ; 
    cov_fifo=new("cov_fifo",this) ; 

endfunction

function void connect_phase(uvm_phase phase) ; 

    super.connect_phase(phase)                   ; 
    cov_export.connect(cov_fifo.analysis_export) ; 
    
endfunction



task run_phase (uvm_phase phase);
    super.run_phase(phase) ;
	      forever 
          		begin
  cov_fifo.get(seq_item) ;
  			riscv_CP.sample();
				
		  end
	endtask

 /*   function void write(my_sequence_item t);
       
    endfunction

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        
    endfunction */
endclass
