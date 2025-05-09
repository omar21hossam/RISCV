class fetch_monitor extends uvm_monitor  ; 

`uvm_component_utils(fetch_monitor)
    

 virtual   fetch_if    fetch_intf ;
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

 
    if (!uvm_config_db#(virtual fetch_if)::get(this, "", "fetch_intf", fetch_intf)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for fetch intf in mon");
    end
   

    endfunction

////////////////////////////--run phase--////////////////////////////
    task run_phase(uvm_phase phase ) ; 
    super.run_phase(phase) ; 

   forever begin
    seq_item =fetch_seq_item::type_id::create("seq_item") ; 

      @(posedge fetch_intf.clk)
      begin


 if (fetch_intf.instr_rvalid_i)
 begin

seq_item.instr_rdata_i = fetch_intf.instr_rdata_i ;
seq_item.pc_id_o = fetch_intf.pc_id_o ;
seq_item.pc_if_o = fetch_intf.pc_if_o ;
seq_item.instr_addr_o = fetch_intf.instr_addr_o ;


 @(negedge fetch_intf.clk)
      
      begin

seq_item.instr_rdata_id_o = fetch_intf.instr_rdata_id_o ;
seq_item.instr_valid_id_o = fetch_intf.instr_valid_id_o ;

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
