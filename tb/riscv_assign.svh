//==================================================================================
// Hierarchical  path definitions
//==================================================================================
`define  IF_PATH DUT.core_i.if_stage_i

// Prefetch interface
// ---------------------------------------------------------------------
assign fetch_interface_.instr_req_o               = `IF_PATH.instr_req_o;
assign fetch_interface_.instr_addr_o            = `IF_PATH.instr_addr_o;
assign fetch_interface_.instr_valid_id_o          = `IF_PATH.instr_valid_id_o;
assign fetch_interface_.instr_rdata_id_o         = `IF_PATH.instr_rdata_id_o;
assign fetch_interface_.pc_if_o         = `IF_PATH.pc_if_o;
assign fetch_interface_.pc_id_o          = `IF_PATH.pc_id_o;
assign fetch_interface_.is_fetch_failed_o            = `IF_PATH.is_fetch_failed_o;
assign fetch_interface_.req_i             = `IF_PATH.req_i;
assign fetch_interface_.instr_gnt_i = `IF_PATH.instr_gnt_i;
assign fetch_interface_.instr_rvalid_i       = `IF_PATH.instr_rvalid_i;

assign fetch_interface_.instr_rdata_i          = `IF_PATH.instr_rdata_i;
assign fetch_interface_.jump_target_id_i            = `IF_PATH.jump_target_id_i;
assign fetch_interface_.jump_target_ex_i             = `IF_PATH.jump_target_ex_i;
assign fetch_interface_.clear_instr_valid_i = `IF_PATH.clear_instr_valid_i;
assign fetch_interface_.pc_set_i       = `IF_PATH.pc_set_i;
