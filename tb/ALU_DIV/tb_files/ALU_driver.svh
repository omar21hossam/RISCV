class alu_driver extends uvm_driver #(alu_seq_item);
  `uvm_component_utils(alu_driver)
  // Declare the sequence item type
  alu_seq_item seq_item;
  // Declare the virtual interface
  virtual alu_if vif;

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
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "vif_d", vif)) begin
      `uvm_fatal("NO_VIF", "Virtual interface not found in config DB")
    end
  endfunction
  //==============================================================================
  //Description:reseting inputs
  //==============================================================================
  task reset_inputs;
    vif.vector_mode_i = 'b0;
    vif.enable_i = 'b0;
    vif.operator_i = cv32e40p_pkg::ALU_ADD;
    vif.operand_a_i = 'b0;
    vif.operand_b_i = 'b0;
    vif.ex_ready_i = 'b0;
  endtask

  //==============================================================================
  //Description:run_phase
  //==============================================================================
  task run_phase(uvm_phase phase);
    reset_inputs();
    @(posedge vif.rst_n)
      forever begin
        // @(posedge vif.core_clk);
        // vif.cb.enable_i    <= 1'b0;
        seq_item_port.get_next_item(seq_item);
        // Drive the inputs to the DUT              
        @(posedge vif.core_clk);
        // division multicycle (stalling)
        if (!vif.ready_o && vif.enable_i && ((vif.operator_i == riscv_pkg::ALU_DIV) || (vif.operator_i == riscv_pkg::ALU_DIVU)||(vif.operator_i == riscv_pkg::ALU_REM) || (vif.operator_i == riscv_pkg::ALU_REMU)))begin
          wait (vif.ready_o);
          @(posedge vif.core_clk);
        end
        vif.vector_mode_i  <= seq_item.vector_mode_i;
        vif.cb.enable_i    <= seq_item.enable_i;
        vif.cb.operator_i  <= seq_item.operator_i;
        vif.cb.operand_a_i <= seq_item.operand_a_i;
        vif.cb.operand_b_i <= seq_item.operand_b_i;
        vif.cb.ex_ready_i  <= seq_item.ex_ready_i;
        seq_item_port.item_done();
      end
  endtask

endclass : alu_driver
