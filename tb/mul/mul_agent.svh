class mul_agent extends uvm_agent;
  `uvm_component_utils(mul_agent)
  // Declare the sequencer and driver
  mul_sequencer sequencer;
  mul_driver driver;
  mul_monitor monitor;
  mul_config m_config;
  // Declare the virtual interface
  virtual mul_if config_virtual;
  // Constructor
  function new(string name = "mul_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = mul_monitor::type_id::create("monitor", this);

    if (!uvm_config_db#(mul_config)::get(this, "", "mul_config", m_config)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for mul_config");
    end

    if (m_config.is_active) begin
      sequencer = mul_sequencer::type_id::create("sequencer", this);
      driver = mul_driver::type_id::create("driver", this);
    end

    // Get the virtual interface from the config DB
    if (!uvm_config_db#(virtual mul_if)::get(this, "", "mul_intf", config_virtual))
      `uvm_fatal("NO_CONFIG", {"Config not found for ", get_full_name(), ".mul_intf"});
    uvm_config_db#(virtual mul_if)::set(this, "monitor", "vif", config_virtual);
  endfunction

  // Connect phase
  // function void connect_phase(uvm_phase phase);
  //   super.connect_phase(phase);
  //   driver.seq_item_port.connect(sequencer.seq_item_export);
  // endfunction

endclass : mul_agent
