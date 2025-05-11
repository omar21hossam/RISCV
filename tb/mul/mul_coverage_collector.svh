class mul_coverage_collector extends uvm_subscriber #(mul_seq_item);

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(mul_coverage_collector)

  //==================================================================================
  // Classes Handles
  //==================================================================================
  mul_seq_item seq_item;

  //==================================================================================
  // Covergroup: Input Transactions
  //==================================================================================
  covergroup cov_inputs;
    operand_a_i: coverpoint seq_item.operand_a_i {
      bins a_0 = {32'h00000000};
      bins a_1 = {32'hFFFFFFFF};
      bins a_2 = {[32'h0000F000 : 32'hF0000000]};
    }

    operand_b_i: coverpoint seq_item.operand_b_i {
      bins b_0 = {32'h00000000};
      bins b_1 = {32'hFFFFFFFF};
      bins b_2 = {[32'h00000001 : 32'h0000F000]};
    }
    operator_i: coverpoint seq_item.operator_i {
      bins mul = {riscv_pkg::MUL_MAC32}; bins mulh = {riscv_pkg::MUL_H};
    }
    short_signed_i: coverpoint seq_item.short_signed_i {
      bins mul_u = {2'b00}; bins mul_su = {2'b01}; bins mul_s = {2'b11};
    }
    cross_all_variants: cross operator_i, operand_a_i, operand_b_i, short_signed_i{
      bins mul_unsigned1 = binsof(operator_i.mul) &&
                          binsof(operand_a_i.a_0) &&
                          binsof(operand_b_i.b_0) &&
                          binsof(short_signed_i.mul_u);
      bins mul_unsigned2 = binsof(operator_i.mul) &&
                        binsof(operand_a_i.a_1) &&
                        binsof(operand_b_i.b_1) &&
                        binsof(short_signed_i.mul_u);
      bins mul_unsigned3 = binsof(operator_i.mul) &&
                        binsof(operand_a_i.a_2) &&
                        binsof(operand_b_i.b_2) &&
                        binsof(short_signed_i.mul_u);
      bins mul_su1 = binsof(operator_i.mul) &&
                          binsof(operand_a_i.a_0) &&
                          binsof(operand_b_i.b_0) &&
                          binsof(short_signed_i.mul_su);
      bins mul_su2 = binsof(operator_i.mul) &&
                        binsof(operand_a_i.a_1) &&
                        binsof(operand_b_i.b_1) &&
                        binsof(short_signed_i.mul_su);
      bins mul_su3 = binsof(operator_i.mul) &&
                        binsof(operand_a_i.a_2) &&
                        binsof(operand_b_i.b_2) &&
                        binsof(short_signed_i.mul_su);
      bins mul_s3 = binsof(operator_i.mul) &&
                        binsof(operand_a_i.a_2) &&
                        binsof(operand_b_i.b_2) &&
                        binsof(short_signed_i.mul_s);
      bins mulh_unsigned = binsof(operator_i.mulh) &&
                           binsof(operand_a_i.a_2) &&
                           binsof(operand_b_i.b_2) &&
                           binsof(short_signed_i.mul_u);
      bins mulh_su = binsof(operator_i.mulh) &&
                           binsof(operand_a_i.a_2) &&
                           binsof(operand_b_i.b_2) &&
                           binsof(short_signed_i.mul_su);
      bins mulh_s = binsof(operator_i.mulh) &&
                           binsof(operand_a_i.a_2) &&
                           binsof(operand_b_i.b_2) &&
                           binsof(short_signed_i.mul_s);
    }
  endgroup
  //==================================================================================
  // Covergroup: Output Transactions
  //==================================================================================
  covergroup cov_outputs;
    result_o: coverpoint seq_item.result_o {bins r_0 = {32'h00000000}; bins r_1 = {32'hFFFFFFFF};}

    multicycle_o: coverpoint seq_item.multicycle_o {
      bins multicycle = {1'b1}; bins singlecycle = {1'b0};
    }

    ready_o: coverpoint seq_item.ready_o {bins ready = {1'b1}; bins not_ready = {1'b0};}

    mulh_active_o: coverpoint seq_item.mulh_active_o {
      bins active = {1'b1}; bins not_active = {1'b0};
    }
  endgroup

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "mul_coverage_collector", uvm_component parent = null);
    super.new(name, parent);
    cov_inputs = new();
    cov_outputs = new();
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building MUL Subscriber", UVM_HIGH);
  endfunction

  //==================================================================================
  // Function: Write
  //==================================================================================
  function void write(mul_seq_item t);
    seq_item = t;
    cov_inputs.sample();
    cov_outputs.sample();
  endfunction

endclass
