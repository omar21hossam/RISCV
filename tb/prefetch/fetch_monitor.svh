// package fetch_monitor_pkg ; 
    
// import uvm_pkg::* ; 
//  import riscv_seq_item_pkg::*;
//  `include "uvm_macros.svh"

class fetch_monitor extends uvm_monitor  ; 

`uvm_component_utils(fetch_monitor)
    

 virtual   riscv_intf    riscv_vintf_ ;
 riscv_seq_item      seq_item ;

uvm_analysis_port#(riscv_seq_item)     mon_ap;


////////////////////////////////////////////////////////////////////////////////////

    function new (string name = "fetch_monitor" ,uvm_component parent= null ) ; 
        super.new(name , parent) ; 
    endfunction
 //////////////////////////////////////////////////////////////////////
////////////////////////////--build phase--////////////////////////////
    function void build_phase (uvm_phase phase );

        super.build_phase(phase);

        mon_ap= new("mon_ap",this) ;
        
        //        if(!uvm_config_db#(virtual interface_clk)::get(this,"","clk_",vinterface_clk))
        //  begin
        //      `uvm_fatal(get_full_name(),"Error in get clk interface in test");
        //  end

    endfunction

////////////////////////////--run phase--////////////////////////////
    task run_phase(uvm_phase phase ) ; 
    super.run_phase(phase) ; 

   forever begin
    seq_item =riscv_seq_item::type_id::create("seq_item") ; 

      @(negedge riscv_vintf_.clk)
      begin
      seq_item.rst_ni  = riscv_vintf_.rst_ni;

      end
    @(riscv_vintf_.ckb_p)
      begin
        mon_ap.write(seq_item) ;
     end
      end

    endtask

        endclass

//endpackage