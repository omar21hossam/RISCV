interface fetch_interface (
input logic               clk,
input logic               instr_req_o  , //Indicates a request to fetch an instruction from memory. "op"
input logic               [31:0] instr_addr_o,//The address of the instruction being requested (aligned PC)."op"
input logic               instr_valid_id_o, //Indicates a valid instruction is in the IF/ID pipeline. "op"
input logic               [31:0] instr_rdata_id_o ,//The instruction data latched into the IF/ID pipeline (after decompression)."op"
input logic               [31:0] pc_if_o  , //Current program counter in the IF stage. "op"
input logic               [31:0] pc_id_o  ,//PC value latched into the IF/ID pipeline register (sent to Decode stage). "op"
input logic               is_fetch_failed_o, //Indicates a fetch failure (not supported in CV32E40P, typically 0). "op"
input logic               req_i, //Request to fetch an instruction (driven by the core’s control unit). "ip"
input logic               instr_gnt_i  , //"ip"
input logic               instr_rvalid_i , //"ip"
input logic               [31:0] instr_rdata_i  , //"ip"
input logic   [31:0] jump_target_id_i,  // Jump target address from the Decode stage (used for PC_JUMP) "ip" unconditional
input logic   [31:0] jump_target_ex_i,  // Branch target address from the Execute stage  "ip" conditional
input logic   clear_instr_valid_i,  // clear instruction valid bit in IF/ID pipe (during a flush affects op valid and will make it 0). "ip" 
input logic   pc_set_i // set the program counter to a new value raise @ first , and when new brach , jump came

);
    
endinterface