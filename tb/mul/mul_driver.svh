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

  function void reset();
    vif.rst_n <= 0;
    vif.enable_i <= 0;
    vif.operator_i <= MUL_I;

    vif.short_signed_i <= 0;
    vif.short_subword_i <= 0;

    vif.operand_a_i <= 0;
    vif.operand_b_i <= 0;
    vif.operand_c_i <= 0;
    vif.imm_i <= 0;

    vif.dot_signed_i <= 0;
    vif.dot_op_a_i <= 0;
    vif.dot_op_b_i <= 0;
    vif.dot_op_c_i <= 0;

    vif.is_clpx_i <= 0;
    vif.clpx_shift_i <= 0;
    vif.clpx_img_i <= 0;

    vif.ex_ready_i <= 0;
  endfunction
  // Run phase
  task run_phase(uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(seq_item);
        // Drive the signals to the DUT
        @(negedge vif.clk);
        if (seq_item.rst_n == 0) begin 
        reset();
        end
        else begin
            vif.rst_n <= seq_item.rst_n;
            vif.enable_i <= seq_item.enable_i;
            vif.operator_i <= seq_item.operator_i;

            vif.short_signed_i <= seq_item.short_signed_i;
            vif.short_subword_i <= seq_item.short_subword_i;

            vif.operand_a_i <= seq_item.operand_a_i;
            vif.operand_b_i <= seq_item.operand_b_i;
            vif.operand_c_i <= seq_item.operand_c_i;
            vif.imm_i <= seq_item.imm_i;

            vif.dot_signed_i <= seq_item.dot_signed_i;
            vif.dot_op_a_i <= seq_item.dot_op_a_i;
            vif.dot_op_b_i <= seq_item.dot_op_b_i;
            vif.dot_op_c_i <= seq_item.dot_op_c_i;

            vif.is_clpx_i <= seq_item.is_clpx_i;
            vif.clpx_shift_i <= seq_item.clpx_shift_i;
            vif.clpx_img_i <= seq_item.clpx_img_i;

            vif.ex_ready_i <= seq_item.ex_ready_i;
        end
        #1step;
        seq_item_port.item_done();
    end
  endtask

endclass : mul_driver