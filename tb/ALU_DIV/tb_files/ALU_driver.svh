class alu_driver extends uvm_driver #(alu_seq_item);
  `uvm_component_utils(alu_driver)
  // Declare the sequence item type
    alu_seq_item seq_item;
  // Declare the virtual interface
  virtual ALU_interface vif;

//==============================================================================
//Description: function new
//==============================================================================
  function new(string name = "alu_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

//==============================================================================
//Description: build_phase
//==============================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual ALU_interface)::get(this, "", "vif_d", vif)) begin
      `uvm_fatal("NO_VIF", "Virtual interface not found in config DB")
    end
  endfunction
//==============================================================================
//Description:run_phase
//==============================================================================
 task run_phase(uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(seq_item);

        #1step;
        seq_item_port.item_done();
    end
  endtask

endclass : alu_driver