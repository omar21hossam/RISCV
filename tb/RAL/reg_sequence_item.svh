class reg_sequence_item extends uvm_sequence_item;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(reg_sequence_item)

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "reg_sequence_item");
    super.new(name);
  endfunction

  //==================================================================================
  // Data Members
  //==================================================================================
  // Input signals
  // ---------------------------------
  logic                             rst_n;

  // Ex stage interface
  // ---------------------------------
  logic                             alu_en_i;
  logic                             mult_en_i;
  logic                      [ 5:0] regfile_alu_waddr_fw_o;
  logic                             regfile_alu_we_fw_o;
  logic                      [31:0] alu_result;
  logic                      [31:0] mult_result;
  cv32e40p_pkg::alu_opcode_e        alu_operator_i;
  cv32e40p_pkg::mul_opcode_e        mult_operator_i;
  logic                             ex_valid_o;

  // LSU interface
  // ---------------------------------
  logic                      [ 5:0] regfile_waddr_wb_o;
  logic                             regfile_we_wb_power_o;
  logic                             data_misaligned_ex_i;
  logic                             data_rvalid_i;
  logic                      [31:0] lsu_rdata_i;

  // Reference signals
  // ---------------------------------
  logic                      [31:0] actual_gpr;

  // Timestamp Signals
  // ---------------------------------
  time                              first_sample;
  time                              second_sample;

  //==================================================================================
  // Function: Do Print
  //==================================================================================
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    // Control Flags
    printer.print_field("alu_en_i", alu_en_i, $bits(alu_en_i), UVM_BIN);
    printer.print_string("alu_operator_i", alu_operator_i.name());
    printer.print_field("mult_en_i", mult_en_i, $bits(mult_en_i), UVM_BIN);
    printer.print_string("mult_operator_i", mult_operator_i.name());
    printer.print_field("regfile_alu_waddr_fw_o", regfile_alu_waddr_fw_o, $bits(
                        regfile_alu_waddr_fw_o), UVM_DEC);
    printer.print_field("regfile_alu_we_fw_o", regfile_alu_we_fw_o, $bits(regfile_alu_we_fw_o),
                        UVM_BIN);
    printer.print_field("alu_result", alu_result, $bits(alu_result), UVM_HEX);
    printer.print_field("mult_result", mult_result, $bits(mult_result), UVM_HEX);
    printer.print_field("ex_valid_o", ex_valid_o, $bits(ex_valid_o), UVM_BIN);
    printer.print_field("regfile_waddr_wb_o", regfile_waddr_wb_o, $bits(regfile_waddr_wb_o),
                        UVM_DEC);

    // Operation Signals
    printer.print_field("regfile_we_wb_power_o", regfile_we_wb_power_o, $bits(regfile_we_wb_power_o
                        ), UVM_BIN);
    printer.print_field("data_misaligned_ex_i", data_misaligned_ex_i, $bits(data_misaligned_ex_i),
                        UVM_BIN);
    printer.print_field("data_rvalid_i", data_rvalid_i, $bits(data_rvalid_i), UVM_BIN);
    printer.print_field("lsu_rdata_i", lsu_rdata_i, $bits(lsu_rdata_i), UVM_HEX);
    printer.print_field("actual_gpr", actual_gpr, $bits(actual_gpr), UVM_HEX);
    printer.print_field("first_sample", first_sample, $bits(first_sample), UVM_TIME);
    printer.print_field("second_sample", second_sample, $bits(second_sample), UVM_TIME);
  endfunction

endclass
