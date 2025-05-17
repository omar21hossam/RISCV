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
   logic [31:0] alu_result;
   logic [31:0] mult_result;
   logic ex_valid_o;
  // LSU interface
   logic [5:0] regfile_waddr_wb_o;
   logic regfile_we_wb_o;
   logic [31:0] regfile_wdata_wb_o;
   // OUTPUT Reference signals
   logic [31:0] ref_o;

  

endclass 
