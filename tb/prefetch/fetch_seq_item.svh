class fetch_seq_item extends uvm_sequence_item;


`uvm_object_utils(fetch_seq_item)
 function new (string name = "fetch_seq_item");

    super.new(name) ;
    
 endfunction
  logic   instr_req_o   ;
  logic   [31:0] instr_addr_o   ;
  logic   instr_gnt_i   ;
  logic   instr_rvalid_i  ;
  logic   [31:0] instr_rdata_i   ;
  logic   [31:0] jump_target_id_i ;  // jump target address   ;
  logic   [31:0] jump_target_ex_i ;  // jump target address   ;
  logic   [31:0] pc_if_o   ;
  logic   [31:0] pc_id_o   ;
  logic req_i ;
  logic is_fetch_failed_o ;
  logic clear_instr_valid_i ;  // clear instruction valid bit in IF/ID pipe
  logic pc_set_i ;  // set the program counter to a new value
  logic instr_valid_id_o ;
  logic  [31:0] instr_rdata_id_o;

 endclass :fetch_seq_item