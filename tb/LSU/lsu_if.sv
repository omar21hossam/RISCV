interface lsu_if (
    input logic clk
);
  //==================================================================================
  // Signals
  //==================================================================================
  logic                      rst_n;

  // ======== OBI External Bus Interface Signals ======== //
  // Inputs
  logic               [31:0] data_rdata_i;
  logic                      data_gnt_i;
  logic                      data_rvalid_i;

  // Outputs
  logic                      data_req_o;
  logic               [31:0] data_addr_o;
  logic                      data_we_o;
  logic               [ 3:0] data_be_o;
  logic               [31:0] data_wdata_o;

  // ======== Execute Stage Signals ======== //
  // Inputs
  riscv_pkg::we_e            data_we_ex_i;
  riscv_pkg::type_e          data_type_ex_i;
  logic               [31:0] data_wdata_ex_i;
  riscv_pkg::extend_e        data_sign_ext_ex_i;
  logic                      data_req_ex_i;
  logic               [31:0] operand_a_ex_i;
  logic               [31:0] operand_b_ex_i;
  logic                      data_misaligned_ex_i;

  // Outputs
  logic               [31:0] data_rdata_ex_o;
  logic                      data_misaligned_o;
  logic                      lsu_ready_ex_o;
  logic                      lsu_ready_wb_o;
  logic                      busy_o;

  // ======== Discarded Signals ======== //
  logic                      data_err_i = 1'b0;
  logic                      data_err_pmp_i = 1'b0;
  logic                      data_load_event_ex_i = 1'b0;
  logic                      addr_useincr_ex_i = 1'b1;
  logic               [ 5:0] data_atop_ex_i = 6'b0;
  logic               [ 1:0] data_reg_offset_ex_i = 2'b0;
  logic               [ 5:0] data_atop_o;
  logic                      p_elw_start_o;
  logic                      p_elw_finish_o;


  //==================================================================================
  // Sequences
  //==================================================================================


  //==================================================================================
  // Properties
  //==================================================================================

  //==================================================================================
  // Assertions
  //==================================================================================


endinterface
