package  fetch_agent_pkg; 


  import  fetch_config_obj_pkg::*;  
  import  riscv_driver_pkg::*;   
  import  riscv_sequencer_pkg::*;    
  import  riscv_seq_item_pkg::*;   
  import  fetch_monitor_pkg::*;  // monitor the two entities

  import uvm_pkg::*;    // important to be imort in all packages
  `include "uvm_macros.svh"

class fetch_agent extends uvm_agent;

  `uvm_component_utils(fetch_agent)   // registeration in the factory 

  uvm_analysis_port#(riscv_seq_item)     agt_ap;

   fetch_config_obj  cfg;  
    riscv_driver drv;   
    riscv_sequencer sqr;    
    fetch_monitor mon; 

  function  new(string name = "fetch_agent" , uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
      
    if(!uvm_config_db #(fetch_config_obj)::get(this,"","CFG", cfg))
      `uvm_fatal("build_phase","agent - unable to get configuration object")
    
      
    agt_ap = new("agt_ap" , this ) ; 


      sqr =  riscv_sequencer::type_id::create("sqr",this);    
      mon =  fetch_monitor::type_id::create("mon",this);
      drv = riscv_driver::type_id::create("drv",this);

  endfunction

  function void connect_phase (uvm_phase phase);

    
    super.connect_phase(phase) ;
      drv.riscv_vintf_ =  cfg.riscv_vintf_ ; 
    mon.riscv_vintf_ =  cfg.riscv_vintf_   ;
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.mon_ap.connect(agt_ap)   ;
    

  endfunction 

endclass: fetch_agent


endpackage