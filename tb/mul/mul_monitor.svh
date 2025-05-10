class mul_monitor extends uvm_monitor;
  `uvm_component_utils(mul_monitor)
  // Declare the sequence item type
    mul_seq_item seq_item;
  // Declare the virtual interface
    virtual mul_if vif;
  // Declare the analysis port
  uvm_analysis_port#(mul_seq_item) mon_analysis_port;

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
    mon_analysis_port = new("mon_analysis_port", this);
  endfunction

  // Connect phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    //@(posedge vif.clk);
    forever begin
      @(posedge vif.ready_o);
      if (vif.rst_n == 0) begin
        seq_item.rst_n = 0;
        mon_analysis_port.write(seq_item);
      end
      else begin
        #1step;
        seq_item.enable_i = vif.enable_i;
        seq_item.operator_i = vif.operator_i;

        seq_item.short_signed_i = vif.short_signed_i;
        seq_item.short_subword_i = vif.short_subword_i;

        seq_item.operand_a_i = vif.operand_a_i;
        seq_item.operand_b_i = vif.operand_b_i;
        seq_item.operand_c_i = vif.operand_c_i;
        seq_item.imm_i = vif.imm_i;

        seq_item.dot_signed_i = vif.dot_signed_i;
        seq_item.dot_op_a_i = vif.dot_op_a_i;
        seq_item.dot_op_b_i = vif.dot_op_b_i;
        seq_item.dot_op_c_i = vif.dot_op_c_i;

        seq_item.is_clpx_i = vif.is_clpx_i;
        seq_item.clpx_shift_i = vif.clpx_shift_i;
        seq_item.clpx_img_i = vif.clpx_img_i;

        seq_item.ex_ready_i = vif.ex_ready_i;
        seq_item.rst_n = vif.rst_n;
        seq_item.result_o = vif.result_o;
        seq_item.multicycle_o = vif.multicycle_o;
        seq_item.ready_o = vif.ready_o;
        seq_item.mulh_active_o = vif.mulh_active_o;
        // Send the sequence item to the analysis port
        mon_analysis_port.write(seq_item); 
      end
    end
  endtask

endclass : mul_monitor
