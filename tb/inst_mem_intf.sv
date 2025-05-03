interface inst_mem_intf(input logic clk,
  input   logic        reset_n,
    
    // OBI Instruction Interface
   input   logic        instr_req_i,    // Request
   input   logic [31:0] instr_addr_i,   // Address
   input  logic        instr_gnt_o,    // Grant
   input  logic        instr_rvalid_o, // Response valid
   input  logic [31:0] instr_rdata_o






);


endinterface