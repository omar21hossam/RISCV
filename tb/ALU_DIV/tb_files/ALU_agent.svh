class alu_agent extends uvm_agent;
`uvm_component_utils(alu_agent)
//==============================================================================
//Description: declarations
//============================================================================== 
alu_sequencer sequencer;
alu_driver driver;
alu_monitor monitor;
virtual ALU_interface vinf;

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
    sequencer = alu_sequencer::type_id::create("sequencer", this);
    driver    = alu_driver::type_id::create("driver", this);
    monitor   = alu_monitor::type_id::create("monitor", this);

    if (!uvm_config_db #(virtual ALU_interface)::get(this, "", "vif", vinf)) begin
      `uvm_fatal(get_full_name(),"Error on interface connectivity")
    end
    uvm_config_db #(virtual ALU_interface)::set(this, "driver", "vif_d", vinf);
    uvm_config_db #(virtual ALU_interface)::set(this, "monitor", "vif_m", vinf);
  endfunction:build_phase

//==============================================================================
//Description:Connect phase
//==============================================================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

  endclass : alu_agent