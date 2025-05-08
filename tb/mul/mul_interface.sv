interface mul_if (
    input logic clk
);
  // clk and reset signals
  logic                          rst_n;
  // input signals
  logic                          enable_i;
  // operator_i is used for mul, mac, and dot operations
  riscv_pkg::mul_opcode_e        operator_i;

  logic                   [ 1:0] short_signed_i;
  logic                          short_subword_i;
  //
  logic                   [31:0] operand_a_i;
  logic                   [31:0] operand_b_i;
  logic                   [31:0] operand_c_i;
  logic                   [ 4:0] imm_i;
  //  used for dot operations
  logic                          dot_signed_i;
  logic                   [31:0] dot_op_a_i;
  logic                   [31:0] dot_op_b_i;
  logic                   [31:0] dot_op_c_i;
  //  used for clpx operations
  logic                          is_clpx_i;
  logic                   [ 1:0] clpx_shift_i;
  logic                          clpx_img_i;

  logic                          ex_ready_i;
  // output signals
  logic                   [31:0] result_o;
  logic                          multicycle_o;
  logic                          ready_o;
  logic                          mulh_active_o;

endinterface
