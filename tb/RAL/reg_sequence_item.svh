class reg_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(reg_sequence_item)
  // Constructor
  function new(string name = "reg_sequence_item");
    super.new(name);
  endfunction


  logic rst_n;

  // Ex stage interface  
  logic alu_en_i;
  logic mult_en_i;
  logic [5:0] regfile_alu_waddr_fw_o;
  logic regfile_alu_we_fw_o;
  logic [31:0] alu_result;
  logic [31:0] mult_result;
  cv32e40p_pkg::alu_opcode_e alu_operator_i;
  logic ex_valid_o;
  // LSU interface
  logic [5:0] regfile_waddr_wb_o;
  logic regfile_we_wb_power_o;
  logic data_misaligned_ex_i;
  logic data_rvalid_i;
  logic [31:0] lsu_rdata_i;
  // OUTPUT Reference signals
  logic [31:0] ref_o;


endclass
