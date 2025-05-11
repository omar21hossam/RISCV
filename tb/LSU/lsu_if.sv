interface lsu_if (
    input logic clk
);
  //==================================================================================
  // Signals
  //==================================================================================
  logic        rst_n;

  // ======== OBI External Bus Interface Signals ======== //
  // Inputs
  logic [31:0] data_rdata_i;
  logic        data_gnt_i;
  logic        data_rvalid_i;

  // Outputs
  logic        data_req_o;
  logic [31:0] data_addr_o;
  logic        data_we_o;
  logic [ 3:0] data_be_o;
  logic [31:0] data_wdata_o;

  // ======== Execute Stage Signals ======== //
  // Inputs
  logic        data_we_ex_i;
  logic [ 1:0] data_type_ex_i;
  logic [31:0] data_wdata_ex_i;
  logic [ 1:0] data_sign_ext_ex_i;
  logic        data_req_ex_i;
  logic [31:0] operand_a_ex_i;
  logic [31:0] operand_b_ex_i;
  logic        data_misaligned_ex_i;

  // Outputs
  logic [31:0] data_rdata_ex_o;
  logic        data_misaligned_o;
  logic        lsu_ready_ex_o;
  logic        lsu_ready_wb_o;
  logic        busy_o;

  // ======== Discarded Signals ======== //
  logic        data_err_i;
  logic        data_err_pmp_i;
  logic        data_load_event_ex_i;
  logic        addr_useincr_ex_i;
  logic [ 5:0] data_atop_ex_i;
  logic [ 1:0] data_reg_offset_ex_i;
  logic [ 5:0] data_atop_o;
  logic        p_elw_start_o;
  logic        p_elw_finish_o;


  //==================================================================================
  // Sequences
  //==================================================================================

  // OBI handshake protocol sequence
  sequence obi_handshake; ##[0:$] data_req_o ##[0:$] data_gnt_i ##[0:$] data_rvalid_i; endsequence

  // Misaligned word-aligned address sequence
  sequence word_misaligned;
    (data_addr_o[1:0] != 2'b00) && (data_type_ex_i == riscv_pkg::WORD);
  endsequence

  // Misaligned halfword-aligned address sequence
  sequence halfword_misaligned;
    (data_addr_o[1:0] == 2'b11) && (data_type_ex_i == riscv_pkg::HALF);
  endsequence


  //==================================================================================
  // Properties
  //==================================================================================
  property p_obi_transaction;
    @(posedge clk) disable iff (!rst_n) data_req_ex_i |-> obi_handshake;
  endproperty

  property p_word_misaligned;
    @(posedge clk) disable iff (!rst_n) word_misaligned |-> ##[0:$] data_misaligned_o;
  endproperty

  property p_halfword_misaligned;
    @(posedge clk) disable iff (!rst_n) halfword_misaligned |-> ##[0:$] data_misaligned_o;
  endproperty

  property p_misaligned_transaction;
    @(posedge clk) disable iff (!rst_n) $fell(
        data_misaligned_o
    ) |-> ##0 $rose(
        data_misaligned_ex_i
    );
  endproperty

  //==================================================================================
  // Assertions
  //==================================================================================
  assert property (p_obi_transaction)
  else $error("OBI transaction failed!");

  assert property (p_word_misaligned)
  else $error("Word misalignment failed!");

  assert property (p_halfword_misaligned)
  else $error("Halfword misalignment failed!");

  assert property (p_misaligned_transaction)
  else $error("Misalignment flags failed!");

endinterface
