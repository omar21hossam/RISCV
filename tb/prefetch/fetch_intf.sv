interface fetch_interface (

input logic   instr_req_o  ,
input logic   [31:0] instr_addr_o  ,
input logic   instr_gnt_i  ,
input logic   instr_rvalid_i ,
input logic   [31:0] instr_rdata_i  ,
input logic   [31:0] jump_target_id_i,  // jump target address  ,
input logic   [31:0] jump_target_ex_i,  // jump target address  ,
input logic   [31:0] pc_if_o  ,
input logic   [31:0] pc_id_o  ,
input logic req_i,
input logic is_fetch_failed_o,
input logic clear_instr_valid_i,  // clear instruction valid bit in IF/ID pipe
input logic pc_set_i,  // set the program counter to a new value
input logic instr_valid_id_o,
input logic instr_rdata_id_o

);
    
endinterface