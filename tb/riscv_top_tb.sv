`include "riscv_interfaces.svh"
module riscv_top_tb ();

  //==================================================================================
  // Hierarchical  path definitions
  //==================================================================================
  `define mult_path DUT.core_i.ex_stage_i.mult_i
  string regfile_path = "riscv_top_tb.DUT.core_i.id_stage_i.register_file_i"

  //==================================================================================
  // Packages
  //==================================================================================
  import uvm_pkg::*;
  import riscv_classes_pkg::*;
  import riscv_pkg::*;
  `define LSU_PATH DUT.core_i.load_store_unit
 // import riscv_pkg::*;


  //==================================================================================
  // Clock Generation Block
  //==================================================================================
  bit clk = 1'b0;
  initial begin
    forever #(CLK_FREQ / 2) clk = ~clk;
  end

  //==================================================================================
  // Interface Instantiation
  //==================================================================================
    bit clk = 1'b0;

  riscv_intf riscv_intf_ (clk);
 
  // Prefetch interface instantiation
  // ALU-DIV interface instasntiation
  mul_if mul_intf ();
  ALU_interface alu_intf_ (clk);
  // MUL interface instantiation
  // LSU interface instantiation
  lsu_if lsu_intf (clk);

  //==================================================================================
  // DUT Instantiation
  //==================================================================================
  cv32e40p_top DUT (
      .clk_i              (clk),                              // explicitly connect clk
      .rst_ni             (riscv_intf_.rst_ni),
      .pulp_clock_en_i    (riscv_intf_.pulp_clock_en_i),
      .scan_cg_en_i       (riscv_intf_.scan_cg_en_i),
      .boot_addr_i        (riscv_intf_.boot_addr_i),
      .mtvec_addr_i       (riscv_intf_.mtvec_addr_i),
      .dm_halt_addr_i     (riscv_intf_.dm_halt_addr_i),
      .hart_id_i          (riscv_intf_.hart_id_i),
      .dm_exception_addr_i(riscv_intf_.dm_exception_addr_i),
      .instr_req_o        (riscv_intf_.instr_req_o),
      .instr_gnt_i        (riscv_intf_.instr_gnt_i),
      .instr_rvalid_i     (riscv_intf_.instr_rvalid_i),
      .instr_addr_o       (riscv_intf_.instr_addr_o),
      .instr_rdata_i      (riscv_intf_.instr_rdata_i),
      .data_req_o         (riscv_intf_.data_req_o),
      .data_gnt_i         ('b0),
      .data_rvalid_i      ('b0),
      .data_we_o          (riscv_intf_.data_we_o),
      .data_be_o          (riscv_intf_.data_be_o),
      .data_addr_o        (riscv_intf_.data_addr_o),
      .data_wdata_o       (riscv_intf_.data_wdata_o),
      .data_rdata_i       ('b0),
      .irq_i              (riscv_intf_.irq_i),
      .irq_ack_o          (riscv_intf_.irq_ack_o),
      .irq_id_o           (riscv_intf_.irq_id_o),
      .debug_req_i        (riscv_intf_.debug_req_i),
      .debug_havereset_o  (riscv_intf_.debug_havereset_o),
      .debug_running_o    (riscv_intf_.debug_running_o),
      .debug_halted_o     (riscv_intf_.debug_halted_o),
      .fetch_enable_i     (riscv_intf_.fetch_enable_i),
      .core_sleep_o       (riscv_intf_.core_sleep_o)
  );

  //==================================================================================
  // Instruction Memory Instantiation
  //==================================================================================
  riscv_instr_mem inst_mem_DUT (
      .clk           (clk),
      .instr_gnt_o   (riscv_intf_.instr_gnt_i),
      .instr_rvalid_o(riscv_intf_.instr_rvalid_i),
      .instr_rdata_o (riscv_intf_.instr_rdata_i),
      .instr_req_i   (riscv_intf_.instr_req_o),
      .instr_addr_i  (riscv_intf_.instr_addr_o),
      .addr          (riscv_intf_.addr),
      .inst          (riscv_intf_.inst),
      .reset_n       (riscv_intf_.rst_ni)
  );


  //==================================================================================
  // `defines
  //==================================================================================
  `define alu_signals_path           DUT.core_i.ex_stage_i.alu_i 
  // `define alu_rst_n               `alu_signals_path.rst_n 
  // `define alu_enable_i            `alu_signals_path.enable_i
  // `define alu_operator_i          `alu_signals_path.operator_i
  // `define alu_operand_a_i         `alu_signals_path.operand_a_i
  // `define alu_operand_b_i         `alu_signals_path.operand_b_i
  // `define alu_ex_ready_i          `alu_signals_path.ex_ready_i
  // `define alu_result_o            `alu_signals_path.result_o
  // `define alu_ready_o             `alu_signals_path.ready_o
  // `define alu_comparison_result_o `alu_signals_path.comparison_result_o
  // `define alu_vector_mode_i       `alu_signals_path.vector_mode_i
  //==================================================================================
  // connect alu modules ports to the ALU interface
  //==================================================================================
  assign alu_intf_.rst_n = `alu_signals_path.rst_n;
  assign alu_intf_.enable_i = `alu_signals_path.enable_i;
  assign alu_intf_.operator_i = `alu_signals_path.operator_i;
  assign alu_intf_.operand_a_i = `alu_signals_path.operand_a_i;
  assign alu_intf_.operand_b_i = `alu_signals_path.operand_b_i;
  assign alu_intf_.ex_ready_i = `alu_signals_path.ex_ready_i;
  assign alu_intf_.result_o = `alu_signals_path.result_o;
  assign alu_intf_.ready_o = `alu_signals_path.ready_o;
  assign alu_intf_.comparison_result_o = `alu_signals_path.comparison_result_o;
  assign alu_intf_.vector_mode_i = `alu_signals_path.vector_mode_i;

  // =====================================================================
  // Connecting the interface to the DUT
  // ======================================================================
  // Prefetch interface
  // ALU-DIV interface
  // MUL interface
  // LSU interface
  assign lsu_intf.data_req_o = `LSU_PATH.data_req_o;
  assign lsu_intf.data_gnt_i = `LSU_PATH.data_gnt_i;
  assign lsu_intf.data_rvalid_i = `LSU_PATH.data_rvalid_i;
  assign lsu_intf.data_err_i = `LSU_PATH.data_err_i;
  assign lsu_intf.data_err_pmp_i = `LSU_PATH.data_err_pmp_i;
  assign lsu_intf.data_addr_o = `LSU_PATH.data_addr_o;
  assign lsu_intf.data_we_o = `LSU_PATH.data_we_o;
  assign lsu_intf.data_be_o = `LSU_PATH.data_be_o;
  assign lsu_intf.data_wdata_o = `LSU_PATH.data_wdata_o;
  assign lsu_intf.data_rdata_i = `LSU_PATH.data_rdata_i;
  assign lsu_intf.data_we_ex_i = `LSU_PATH.data_we_ex_i;
  assign lsu_intf.data_type_ex_i = `LSU_PATH.data_type_ex_i;
  assign lsu_intf.data_wdata_ex_i = `LSU_PATH.data_wdata_ex_i;
  assign lsu_intf.data_reg_offset_ex_i = `LSU_PATH.data_reg_offset_ex_i;
  assign lsu_intf.data_load_event_ex_i = `LSU_PATH.data_load_event_ex_i;
  assign lsu_intf.data_sign_ext_ex_i = `LSU_PATH.data_sign_ext_ex_i;
  assign lsu_intf.data_rdata_ex_o = `LSU_PATH.data_rdata_ex_o;
  assign lsu_intf.data_req_ex_i = `LSU_PATH.data_req_ex_i;
  assign lsu_intf.operand_a_ex_i = `LSU_PATH.operand_a_ex_i;
  assign lsu_intf.operand_b_ex_i = `LSU_PATH.operand_b_ex_i;
  assign lsu_intf.addr_useincr_ex_i = `LSU_PATH.addr_useincr_ex_i;
  assign lsu_intf.data_misaligned_ex_i = `LSU_PATH.data_misaligned_ex_i;
  assign lsu_intf.data_misaligned_o = `LSU_PATH.data_misaligned_o;
  assign lsu_intf.data_atop_ex_i = `LSU_PATH.data_atop_ex_i;
  assign lsu_intf.data_atop_o = `LSU_PATH.data_atop_o;
  assign lsu_intf.p_elw_start_o = `LSU_PATH.p_elw_start_o;
  assign lsu_intf.p_elw_finish_o = `LSU_PATH.p_elw_finish_o;
  assign lsu_intf.lsu_ready_ex_o = `LSU_PATH.lsu_ready_ex_o;
  assign lsu_intf.lsu_ready_wb_o = `LSU_PATH.lsu_ready_wb_o;
  assign lsu_intf.busy_o = `LSU_PATH.busy_o;

assign mul_intf.clk             = `mult_path.clk;
assign mul_intf.rst_n           = `mult_path.rst_n;
assign mul_intf.enable_i        = `mult_path.enable_i;
assign mul_intf.operator_i      = `mult_path.operator_i;
assign mul_intf.short_signed_i  = `mult_path.short_signed_i;
assign mul_intf.short_subword_i = `mult_path.short_subword_i;
assign mul_intf.operand_a_i     = `mult_path.op_a_i;
assign mul_intf.operand_b_i     = `mult_path.op_b_i;
assign mul_intf.operand_c_i     = `mult_path.op_c_i;
assign mul_intf.imm_i           = `mult_path.imm_i;
assign mul_intf.dot_signed_i    = `mult_path.dot_signed_i;
assign mul_intf.dot_op_a_i      = `mult_path.dot_op_a_i;
assign mul_intf.dot_op_b_i      = `mult_path.dot_op_b_i;
assign mul_intf.dot_op_c_i      = `mult_path.dot_op_c_i;
assign mul_intf.is_clpx_i       = `mult_path.is_clpx_i;
assign mul_intf.clpx_shift_i    = `mult_path.clpx_shift_i;
assign mul_intf.clpx_img_i      = `mult_path.clpx_img_i;
assign mul_intf.ex_ready_i      = `mult_path.ex_ready_i;
assign mul_intf.result_o        = `mult_path.result_o;
assign mul_intf.multicycle_o    = `mult_path.multicycle_o;
assign mul_intf.ready_o         = `mult_path.ready_o;
assign mul_intf.mulh_active_o   = `mult_path.mulh_active_o;

  //==================================================================================
  // Configuration
  //==================================================================================
  initial begin
    uvm_config_db#(virtual riscv_intf)::set(null, "uvm_test_top", "main_intf", riscv_intf_);
     uvm_config_db#(virtual mul_if)::set(null, "uvm_test_top", "mul_intf", mul_intf);

    // Prefetch configuration setup
    // ALU-DIV configuration setup
    uvm_config_db#(virtual ALU_interface)::set(null, "uvm_test_top", "alu_intf_top2test",alu_intf_);
    // MUL configuration setup
    // LSU configuration setup
    uvm_config_db#(virtual lsu_if)::set(null, "uvm_test_top", "lsu_intf", lsu_intf);

    // Run the testbench with the specified test
    run_test("riscv_base_test");
  end

  initial begin
    $dumpfile("riscv_top_tb.vcd");
    $dumpvars(0, riscv_top_tb);
    $display("Starting simulation");
  end


  //==================================================================================
  // Clock Generation Block
  //==================================================================================
  initial begin
//forever #(CLK_FREQ / 2) clk = ~clk;
    forever #(10 / 2) clk = ~clk;

  end


endmodule
