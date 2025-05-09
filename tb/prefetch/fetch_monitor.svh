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

      @(negedge fetch_interface_.clk)
      begin

      end
   @( posedge fetch_interface_.clk)
      begin
        mon_ap.write(seq_item) ;
     end
      end

    endtask

        endclass