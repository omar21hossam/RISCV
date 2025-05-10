class fetch_monitor extends uvm_monitor  ; 

`uvm_component_utils(fetch_monitor)
    

 virtual   fetch_interface    fetch_interface_ ;
 fetch_seq_item      seq_item ;

uvm_analysis_port#(fetch_seq_item)     mon_ap;


////////////////////////////////////////////////////////////////////////////////////

    function new (string name = "fetch_monitor" ,uvm_component parent= null ) ; 
        super.new(name , parent) ; 
    endfunction
 //////////////////////////////////////////////////////////////////////
////////////////////////////--build phase--////////////////////////////
    function void build_phase (uvm_phase phase );

        super.build_phase(phase);

        mon_ap= new("mon_ap",this) ;

    endfunction

////////////////////////////--run phase--////////////////////////////
    task run_phase(uvm_phase phase ) ; 
    super.run_phase(phase) ; 

   forever begin
    seq_item =fetch_seq_item::type_id::create("seq_item") ; 

      @(posedge fetch_interface_.clk)
      begin


 if (fetch_interface_.instr_rvalid_i)
 begin

seq_item.instr_rdata_i = fetch_interface_.instr_rdata_i ;
seq_item.pc_id_o = fetch_interface_.pc_id_o ;
seq_item.pc_if_o = fetch_interface_.pc_if_o ;
seq_item.instr_addr_o = fetch_interface_.instr_addr_o ;


 @(negedge fetch_interface_.clk)
      
      begin

seq_item.instr_rdata_id_o = fetch_interface_.instr_rdata_id_o ;
seq_item.instr_valid_id_o = fetch_interface_.instr_valid_id_o ;

 mon_ap.write(seq_item) ;
// $display("time %0t: data_id_o %0d , valid_id_o %0d ,  instr_addr_o %0d ,  pc_id_o %0d ,  pc_if_o %0d ,  instr_rdata_i %0d",  $time,seq_item.instr_rdata_id_o,seq_item.instr_valid_id_o,
// seq_item.instr_addr_o,seq_item.pc_id_o ,seq_item.pc_if_o ,seq_item.instr_rdata_i 

//  );
      end    
      end
      end
   end
    endtask

        endclass
