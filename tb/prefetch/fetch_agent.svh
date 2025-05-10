class fetch_agent extends uvm_agent;

  `uvm_component_utils(fetch_agent)  

  uvm_analysis_port#(fetch_seq_item)     agt_ap;
   
    fetch_monitor mon; 
 virtual   fetch_interface    fetch_interface_ ;

  function  new(string name = "fetch_agent" , uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
      
    agt_ap = new("agt_ap" , this ) ; 

      mon =  fetch_monitor::type_id::create("mon",this);
    // Driver and Monitor Configuration
    if (!uvm_config_db#(virtual fetch_interface)::get(this, "", "fetch_intf", fetch_interface_)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for fetch_if");
    end else begin
      uvm_config_db#(virtual fetch_interface)::set(this, "mon", "fetch_intf", fetch_interface_);
    end
  endfunction

  function void connect_phase (uvm_phase phase);

    
    super.connect_phase(phase) ;
    mon.mon_ap.connect(agt_ap)   ;
    

  endfunction 

endclass: fetch_agent
