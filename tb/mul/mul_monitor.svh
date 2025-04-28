class mul_monitor extends uvm_monitor;
  `uvm_component_utils(mul_monitor)
  // Declare the sequence item type
    mul_seq_item seq_item;
  // Declare the virtual interface
    virtual mul_if vif;
  // Declare the analysis port
  uvm_analysis_port#(mul_seq_item) analysis_port;

  // Constructor
  function new(string name = "mul_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq_item = mul_seq_item::type_id::create("seq_item", this);
    // Get the virtual interface from the config DB
    if (!uvm_config_db #(virtual mul_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", "Virtual interface not found in config DB")
    end
    analysis_port = new("analysis_port", this);
  endfunction

  // Connect phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge vif.clk);
      if (vif.rst == 1) begin 
        seq_item.rst = 1;
        analysis_port.write(seq_item);
      end
      else begin
        
        #1step;
        analysis_port.write(seq_item); 
      end
    end
  endtask

endclass : mul_monitor