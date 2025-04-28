class mul_driver extends uvm_driver #(mul_seq_item);
  `uvm_component_utils(mul_driver)
  // Declare the sequence item type
    mul_seq_item seq_item;
  // Declare the virtual interface
  virtual mul_if vif;

  // Constructor
  function new(string name = "mul_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual mul_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", "Virtual interface not found in config DB")
    end
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(seq_item);

        #1step;
        seq_item_port.item_done();
    end
  endtask

endclass : mul_driver