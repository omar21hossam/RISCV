`include "riscv_interfaces.svh"
module riscv_top_tb ();

  //==================================================================================
  // Hierarchical  path definitions
  //==================================================================================
  `define MUL_PATH DUT.core_i.ex_stage_i.mult_i
  `define LSU_PATH DUT.core_i.load_store_unit
  `define ALU_PATH DUT.core_i.ex_stage_i.alu_i 

  //==================================================================================
  // Packages
  //==================================================================================
  import uvm_pkg::*;
  import riscv_classes_pkg::*;
  import riscv_pkg::*;

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
  riscv_intf riscv_intf_ (clk);
  mul_if mul_intf (clk);
  ALU_interface alu_intf_ (clk);
  lsu_if lsu_intf (clk);

  //==================================================================================
  // DUT Instantiation
  //==================================================================================
  cv32e40p_top DUT (
      // Clock and Reset
      .clk_i (clk),
      .rst_ni(riscv_intf_.rst_ni),

      .pulp_clock_en_i    (riscv_intf_.pulp_clock_en_i),
      .scan_cg_en_i       (riscv_intf_.scan_cg_en_i),
      .boot_addr_i        (riscv_intf_.boot_addr_i),
      .mtvec_addr_i       (riscv_intf_.mtvec_addr_i),
      .dm_halt_addr_i     (riscv_intf_.dm_halt_addr_i),
      .hart_id_i          (riscv_intf_.hart_id_i),
      .dm_exception_addr_i(riscv_intf_.dm_exception_addr_i),

      // Instruction memory interface
      .instr_req_o   (riscv_intf_.instr_req_o),
      .instr_gnt_i   (riscv_intf_.instr_gnt_i),
      .instr_rvalid_i(riscv_intf_.instr_rvalid_i),
      .instr_addr_o  (riscv_intf_.instr_addr_o),
      .instr_rdata_i (riscv_intf_.instr_rdata_i),

      // Data memory interface
      .data_req_o   (lsu_intf.data_req_o),
      .data_gnt_i   (lsu_intf.data_gnt_i),
      .data_rvalid_i(lsu_intf.data_rvalid_i),
      .data_we_o    (lsu_intf.data_we_o),
      .data_be_o    (lsu_intf.data_be_o),
      .data_addr_o  (lsu_intf.data_addr_o),
      .data_wdata_o (lsu_intf.data_wdata_o),
      .data_rdata_i (lsu_intf.data_rdata_i),

      // Interrupt inputs
      .irq_i    (riscv_intf_.irq_i),
      .irq_ack_o(riscv_intf_.irq_ack_o),
      .irq_id_o (riscv_intf_.irq_id_o),

      // Debug Interface
      .debug_req_i      (riscv_intf_.debug_req_i),
      .debug_havereset_o(riscv_intf_.debug_havereset_o),
      .debug_running_o  (riscv_intf_.debug_running_o),
      .debug_halted_o   (riscv_intf_.debug_halted_o),

      // CPU Control Signals
      .fetch_enable_i(riscv_intf_.fetch_enable_i),
      .core_sleep_o  (riscv_intf_.core_sleep_o)
  );

  //==================================================================================
  // Binding internal interfaces
  //==================================================================================
  // Prefetch interface
  // ---------------------------------------------------------------------
  // ..............
  // ..............
  // ..............
  // ..............

  // ALU-DIV interface
  // ---------------------------------------------------------------------
  assign alu_intf_.rst_n               = `ALU_PATH.rst_n;
  assign alu_intf_.enable_i            = `ALU_PATH.enable_i;
  assign alu_intf_.operator_i          = `ALU_PATH.operator_i;
  assign alu_intf_.operand_a_i         = `ALU_PATH.operand_a_i;
  assign alu_intf_.operand_b_i         = `ALU_PATH.operand_b_i;
  assign alu_intf_.ex_ready_i          = `ALU_PATH.ex_ready_i;
  assign alu_intf_.result_o            = `ALU_PATH.result_o;
  assign alu_intf_.ready_o             = `ALU_PATH.ready_o;
  assign alu_intf_.comparison_result_o = `ALU_PATH.comparison_result_o;
  assign alu_intf_.vector_mode_i       = `ALU_PATH.vector_mode_i;

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

  //==================================================================================
  // Configuration and Test
  //==================================================================================
  initial begin
    // Main Interface configuration setup
    // ---------------------------------------------------------------------
    uvm_config_db#(virtual riscv_intf)::set(null, "uvm_test_top", "main_intf", riscv_intf_);

    // Prefetch configuration setup
    // ...

    // MUL configuration setup
    // ---------------------------------------------------------------------
    uvm_config_db#(virtual mul_if)::set(null, "uvm_test_top", "mul_intf", mul_intf);


    // ALU-DIV configuration setup
    // ---------------------------------------------------------------------
    uvm_config_db#(virtual ALU_interface)::set(null, "uvm_test_top", "alu_intf_top2test",
                                               alu_intf_);

    // LSU configuration setup
    // ---------------------------------------------------------------------
    uvm_config_db#(virtual lsu_if)::set(null, "uvm_test_top", "lsu_intf", lsu_intf);

    // Run the testbench with the specified test
    // ---------------------------------------------------------------------
    run_test("riscv_base_test");
  end

  initial begin
    $dumpfile("riscv_top_tb.vcd");
    $dumpvars(0, riscv_top_tb);
    $display("Starting simulation");
  end

endmodule
