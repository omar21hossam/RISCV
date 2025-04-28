class mul_agent extends uvm_agent;
  `uvm_component_utils(mul_agent)
  // Declare the sequencer and driver
  mul_sequencer sequencer;
  mul_driver driver;
  mul_monitor monitor;
  // Declare the virtual interface
    virtual mul_if config_virtual;
  // Constructor
  function new(string name = "mul_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer = mul_sequencer::type_id::create("sequencer", this);
    driver = mul_driver::type_id::create("driver", this);
    monitor = mul_monitor::type_id::create("monitor", this);
    // Get the virtual interface from the config DB
    if (!uvm_config_db #(virtual mul_if)::get(this, "", "vif", config_virtual)) begin
      `uvm_fatal("NO_VIF", "Virtual interface not found in config DB")
    end
    uvm_config_db #(virtual mul_if)::set(this, "*", "vif", config_virtual);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

  endclass : mul_agent