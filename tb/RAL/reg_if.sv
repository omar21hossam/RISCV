interface reg_if
(
    input bit clk
);
  logic rst_n;
  // Ex stage interface signals
  logic alu_en_i;
  logic mult_en_i;
  logic [5:0] regfile_alu_waddr_fw_o;
  logic [31:0] alu_result;
  logic [31:0] mult_result;
  logic ex_valid_o;
  // LSU interface signals
  logic [5:0] regfile_waddr_wb_o;
  logic regfile_we_wb_o;
  logic [31:0] regfile_wdata_wb_o;

endinterface
