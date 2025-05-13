class fetch_agent extends uvm_agent;

  `uvm_component_utils(fetch_agent)  

  uvm_analysis_port#(fetch_seq_item)     agt_ap_ip;
    uvm_analysis_port#(fetch_seq_item)     agt_ap_op;
   
    fetch_monitor mon; 
 virtual   fetch_if    fetch_intf ;

  function  new(string name = "fetch_agent" , uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
      
    agt_ap_ip = new("agt_ap_ip" , this ) ; 
     agt_ap_op = new("agt_ap_op" , this ) ; 

      mon =  fetch_monitor::type_id::create("mon",this);
    // Driver and Monitor Configuration
    if (!uvm_config_db#(virtual fetch_if)::get(this, "", "fetch_intf", fetch_intf)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for fetch_if");
    end else begin
      uvm_config_db#(virtual fetch_if)::set(this, "mon", "fetch_intf", fetch_intf);
    end
  endfunction

  function void connect_phase (uvm_phase phase);

    
    super.connect_phase(phase) ;
    mon.mon_ap_ip.connect(agt_ap_ip)   ;
     mon.mon_ap_op.connect(agt_ap_op)   ;  

  endfunction 

endclass: fetch_agent
