class mul_seq_item extends uvm_sequence_item;
  `uvm_object_utils(mul_seq_item)
  // Declare the data members
  rand logic                          rst_n;
  // input signals
  rand logic                          enable_i;
  rand cv32e40p_pkg::mul_opcode_e        operator_i;

  rand logic                   [ 1:0] short_signed_i;
  rand logic                          short_subword_i;

  rand logic                   [31:0] operand_a_i;
  rand logic                   [31:0] operand_b_i;
  rand logic                   [31:0] operand_c_i;
  rand logic                   [ 4:0] imm_i;
  // is used for dot operations
  rand logic                   [ 1:0] dot_signed_i;
  rand logic                   [31:0] dot_op_a_i;
  rand logic                   [31:0] dot_op_b_i;
  rand logic                   [31:0] dot_op_c_i;
  // used for clpx operations
  rand logic                          is_clpx_i;
  rand logic                   [ 4:0] clpx_shift_i;
  rand logic                          clpx_img_i;

  rand logic                          ex_ready_i;
  // output signals
  logic                        [31:0] result_o;
  logic                               multicycle_o;
  logic                               ready_o;
  logic                               mulh_active_o;

  // Constructor
  function new(string name = "mul_seq_item");
    super.new(name);
  endfunction

endclass : mul_seq_item
