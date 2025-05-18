interface reg_if (
    input bit clk
);
  logic rst_n;
  // Ex stage interface signals
  logic alu_en_i;
  logic mult_en_i;
  logic [5:0] regfile_alu_waddr_fw_o;
  logic regfile_alu_we_fw_o;
  logic [31:0] alu_result;
  logic [31:0] mult_result;
  logic ex_valid_o;
  logic alu_filter_valid;
  cv32e40p_pkg::mul_opcode_e mult_operator_i;
  cv32e40p_pkg::alu_opcode_e alu_operator_i;

  // LSU interface signals
  logic [5:0] regfile_waddr_wb_o;
  logic regfile_we_wb_power_o;
  logic data_misaligned_ex_i;
  logic data_rvalid_i;
  logic [31:0] lsu_rdata_i;
  logic lsu_filter_valid;

  // Jump signals
  logic jump_done;

endinterface
