module riscv_top_tb ();

  //==================================================================================
  // Packages
  //==================================================================================
  import uvm_pkg::*;
  import riscv_classes_pkg::*;
  import riscv_pkg::*;
  `define LSU_PATH DUT.core_i.load_store_unit

  //==================================================================================
  // Interface Instantiation
  //==================================================================================
  riscv_intf riscv_intf_ (clk);
  interface_clk interface_clk_ (clk);
  // Prefetch interface instantiation
  // ALU-DIV interface instasntiation
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
      .data_gnt_i         (0),
      .data_rvalid_i      (0),
      .data_we_o          (riscv_intf_.data_we_o),
      .data_be_o          (riscv_intf_.data_be_o),
      .data_addr_o        (riscv_intf_.data_addr_o),
      .data_wdata_o       (riscv_intf_.data_wdata_o),
      .data_rdata_i       (0),
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

  // =====================================================================
  // Connecting the interface to the DUT
  // ======================================================================
  // DUT interface
  bind riscv_instr_mem : inst_mem_DUT inst_mem_intf inst_mem_intf_ (.*);

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


  //==================================================================================
  // Configuration
  //==================================================================================
  initial begin
    uvm_config_db#(virtual riscv_intf)::set(null, "uvm_test_top", "main_intf", riscv_intf_);
    uvm_config_db#(virtual interface_clk)::set(null, "uvm_test_top", "clk_", interface_clk_);
    // Prefetch configuration setup
    // ALU-DIV configuration setup
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
  bit clk = 1'b0;
  initial begin
    forever #(CLK_FREQ / 2) clk = ~clk;
  end

endmodule
