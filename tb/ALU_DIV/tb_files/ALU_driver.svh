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
        
        // @(posedge vif.core_clk);
        // vif.cb.enable_i    <= 1'b0;
        seq_item_port.get_next_item(seq_item);
        // Drive the inputs to the DUT
        //wait(vif.ready_o == 1'b0);
        @(posedge vif.core_clk);
        `uvm_info(get_type_name(), $sformatf("ALU Driver: Driving inputs: %s", seq_item.convert2string()), UVM_MEDIUM);
        vif.cb.rst_n       <= seq_item.rst_n;
        vif.vector_mode_i  <= seq_item.vector_mode_i;
        vif.cb.enable_i    <= seq_item.enable_i;
        vif.cb.operator_i  <= seq_item.operator_i;
        vif.cb.operand_a_i <= seq_item.operand_a_i;
        vif.cb.operand_b_i <= seq_item.operand_b_i;
        vif.cb.ex_ready_i  <= seq_item.ex_ready_i;
        seq_item_port.item_done();
        `uvm_info(get_type_name(), $sformatf("ALU Driver: Driving inputs done"), UVM_NONE);
    end
  endtask

endclass : alu_driver