class alu_agent extends uvm_agent;
  `uvm_component_utils(alu_agent)
  //==============================================================================
  //Description: declarations
  //============================================================================== 
  alu_sequencer m_sequencer;
  alu_driver m_driver;
  alu_monitor m_monitor;
  alu_config m_config;
  virtual alu_if vinf;

  //==============================================================================
  //Description: function new
  //==============================================================================
  function new(string name = "alu_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==============================================================================
  //Description: build_phase
  //==============================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_config  = alu_config::type_id::create("m_config", this);
    m_monitor = alu_monitor::type_id::create("m_monitor", this);

    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_intf", vinf)) begin
      `uvm_fatal(get_full_name(), "Error on interface connectivity")
    end

    if (!uvm_config_db#(alu_config)::get(this, "", "alu_config", m_config)) begin
      `uvm_fatal(get_full_name(), "Failed to get the alu_config")
    end

    if (m_config.is_active) begin
      m_sequencer = alu_sequencer::type_id::create("m_sequencer", this);
      m_driver    = alu_driver::type_id::create("m_driver", this);
    end

    uvm_config_db#(virtual alu_if)::set(this, "m_driver", "vif_d", vinf);
    uvm_config_db#(virtual alu_if)::set(this, "m_monitor", "vif_m", vinf);
  endfunction : build_phase

  //==============================================================================
  //Description:Connect phase
  //==============================================================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  endfunction

endclass : alu_agent
