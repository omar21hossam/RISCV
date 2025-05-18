class reg_agent extends uvm_agent;
  `uvm_component_utils(reg_agent)

  // Interface
  virtual reg_if reg_intf;

  // Monitor
  reg_monitor m_monitor;

  // Constructor
  function new(string name = "reg_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create the monitor
    m_monitor = reg_monitor::type_id::create("m_monitor", this);
    // Register the interface
    if (!uvm_config_db#(virtual reg_if)::get(this, "", "reg_intf", reg_intf)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for reg_if");
    end
    uvm_config_db#(virtual reg_if)::set(this, "m_monitor", "reg_intf", reg_intf);
  endfunction


endclass
