class fetch_agent extends uvm_agent;

  `uvm_component_utils(fetch_agent)  

  uvm_analysis_port#(fetch_seq_item)     agt_ap_ip;
    uvm_analysis_port#(fetch_seq_item)     agt_ap_op;
      fetch_config_obj  cfg; 
    fetch_monitor mon; 
 virtual   fetch_if    fetch_intf ;
    riscv_driver drv;   
    riscv_sequencer sqr; 
  function  new(string name = "fetch_agent" , uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
      
    agt_ap_ip = new("agt_ap_ip" , this ) ; 
     agt_ap_op = new("agt_ap_op" , this ) ; 
      sqr =  riscv_sequencer::type_id::create("sqr",this);    
      mon =  fetch_monitor::type_id::create("mon",this);
      drv = riscv_driver::type_id::create("drv",this);

    // Driver and Monitor Configuration


          if(!uvm_config_db #(fetch_config_obj)::get(this,"","CFG", cfg))
      `uvm_fatal("build_phase","agent - unable to get configuration object")
    
  endfunction

      

  function void connect_phase (uvm_phase phase);

    
    super.connect_phase(phase) ;
          drv.riscv_vintf_ =  cfg.riscv_vintf_ ; 
    mon.fetch_intf =  cfg.fetch_interface_   ;
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.mon_ap_ip.connect(agt_ap_ip)   ;
     mon.mon_ap_op.connect(agt_ap_op)   ;  

  endfunction 

endclass: fetch_agent
