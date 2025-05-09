//==================================================================================
// Hierarchical  path definitions
//==================================================================================
`define MUL_PATH DUT.core_i.ex_stage_i.mult_i
`define LSU_PATH DUT.core_i.load_store_unit_i
`define ALU_PATH DUT.core_i.ex_stage_i.alu_i
`define  IF_PATH DUT.core_i.if_stage_i

// Prefetch interface
// ---------------------------------------------------------------------
assign fetch_intf.instr_req_o               = `IF_PATH.instr_req_o;
assign fetch_intf.instr_addr_o              = `IF_PATH.instr_addr_o;
assign fetch_intf.instr_valid_id_o          = `IF_PATH.instr_valid_id_o;
assign fetch_intf.instr_rdata_id_o          = `IF_PATH.instr_rdata_id_o;
assign fetch_intf.pc_if_o                   = `IF_PATH.pc_if_o;
assign fetch_intf.pc_id_o                   = `IF_PATH.pc_id_o;
assign fetch_intf.is_fetch_failed_o         = `IF_PATH.is_fetch_failed_o;
assign fetch_intf.req_i                     = `IF_PATH.req_i;
assign fetch_intf.instr_gnt_i               = `IF_PATH.instr_gnt_i;
assign fetch_intf.instr_rvalid_i            = `IF_PATH.instr_rvalid_i;
assign fetch_intf.instr_rdata_i             = `IF_PATH.instr_rdata_i;
assign fetch_intf.jump_target_id_i          = `IF_PATH.jump_target_id_i;
assign fetch_intf.jump_target_ex_i          = `IF_PATH.jump_target_ex_i;
assign fetch_intf.clear_instr_valid_i       = `IF_PATH.clear_instr_valid_i;
assign fetch_intf.pc_set_i                  = `IF_PATH.pc_set_i;


// ALU-DIV interface
// ---------------------------------------------------------------------
assign alu_intf.rst_n               = `ALU_PATH.rst_n;
assign alu_intf.enable_i            = `ALU_PATH.enable_i;
assign alu_intf.operator_i          = `ALU_PATH.operator_i;
assign alu_intf.operand_a_i         = `ALU_PATH.operand_a_i;
assign alu_intf.operand_b_i         = `ALU_PATH.operand_b_i;
assign alu_intf.ex_ready_i          = `ALU_PATH.ex_ready_i;
assign alu_intf.result_o            = `ALU_PATH.result_o;
assign alu_intf.ready_o             = `ALU_PATH.ready_o;
assign alu_intf.comparison_result_o = `ALU_PATH.comparison_result_o;
assign alu_intf.vector_mode_i       = `ALU_PATH.vector_mode_i;

// LSU interface
// ---------------------------------------------------------------------
assign lsu_intf.data_err_i           = `LSU_PATH.data_err_i;
assign lsu_intf.data_err_pmp_i       = `LSU_PATH.data_err_pmp_i;
assign lsu_intf.data_we_ex_i         = `LSU_PATH.data_we_ex_i;
assign lsu_intf.data_type_ex_i       = `LSU_PATH.data_type_ex_i;
assign lsu_intf.data_wdata_ex_i      = `LSU_PATH.data_wdata_ex_i;
assign lsu_intf.data_reg_offset_ex_i = `LSU_PATH.data_reg_offset_ex_i;
assign lsu_intf.data_load_event_ex_i = `LSU_PATH.data_load_event_ex_i;
assign lsu_intf.data_sign_ext_ex_i   = `LSU_PATH.data_sign_ext_ex_i;
assign lsu_intf.data_rdata_ex_o      = `LSU_PATH.data_rdata_ex_o;
assign lsu_intf.data_req_ex_i        = `LSU_PATH.data_req_ex_i;
assign lsu_intf.operand_a_ex_i       = `LSU_PATH.operand_a_ex_i;
assign lsu_intf.operand_b_ex_i       = `LSU_PATH.operand_b_ex_i;
assign lsu_intf.addr_useincr_ex_i    = `LSU_PATH.addr_useincr_ex_i;
assign lsu_intf.data_misaligned_ex_i = `LSU_PATH.data_misaligned_ex_i;
assign lsu_intf.data_misaligned_o    = `LSU_PATH.data_misaligned_o;
assign lsu_intf.data_atop_ex_i       = `LSU_PATH.data_atop_ex_i;
assign lsu_intf.data_atop_o          = `LSU_PATH.data_atop_o;
assign lsu_intf.p_elw_start_o        = `LSU_PATH.p_elw_start_o;
assign lsu_intf.p_elw_finish_o       = `LSU_PATH.p_elw_finish_o;
assign lsu_intf.lsu_ready_ex_o       = `LSU_PATH.lsu_ready_ex_o;
assign lsu_intf.lsu_ready_wb_o       = `LSU_PATH.lsu_ready_wb_o;
assign lsu_intf.busy_o               = `LSU_PATH.busy_o;

// MUL interface
// ---------------------------------------------------------------------
assign mul_intf.rst_n                = `MUL_PATH.rst_n;
assign mul_intf.enable_i             = `MUL_PATH.enable_i;
assign mul_intf.operator_i           = `MUL_PATH.operator_i;
assign mul_intf.short_signed_i       = `MUL_PATH.short_signed_i;
assign mul_intf.short_subword_i      = `MUL_PATH.short_subword_i;
assign mul_intf.operand_a_i          = `MUL_PATH.op_a_i;
assign mul_intf.operand_b_i          = `MUL_PATH.op_b_i;
assign mul_intf.operand_c_i          = `MUL_PATH.op_c_i;
assign mul_intf.imm_i                = `MUL_PATH.imm_i;
assign mul_intf.dot_signed_i         = `MUL_PATH.dot_signed_i;
assign mul_intf.dot_op_a_i           = `MUL_PATH.dot_op_a_i;
assign mul_intf.dot_op_b_i           = `MUL_PATH.dot_op_b_i;
assign mul_intf.dot_op_c_i           = `MUL_PATH.dot_op_c_i;
assign mul_intf.is_clpx_i            = `MUL_PATH.is_clpx_i;
assign mul_intf.clpx_shift_i         = `MUL_PATH.clpx_shift_i;
assign mul_intf.clpx_img_i           = `MUL_PATH.clpx_img_i;
assign mul_intf.ex_ready_i           = `MUL_PATH.ex_ready_i;
assign mul_intf.result_o             = `MUL_PATH.result_o;
assign mul_intf.multicycle_o         = `MUL_PATH.multicycle_o;
assign mul_intf.ready_o              = `MUL_PATH.ready_o;
assign mul_intf.mulh_active_o        = `MUL_PATH.mulh_active_o;
