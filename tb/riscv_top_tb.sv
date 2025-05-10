`timescale 1ns / 1ps
module riscv_top_tb ();
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
  riscv_if riscv_intf (clk);
  mul_if mul_intf (clk);
  alu_if alu_intf (clk);
  lsu_if lsu_intf (clk);
  fetch_if fetch_intf (clk);

  //==================================================================================
  // DUT Instantiation
  //==================================================================================
  cv32e40p_top DUT (
      // Clock and Reset
      .clk_i (clk),
      .rst_ni(riscv_intf.rst_ni),

      .pulp_clock_en_i    (riscv_intf.pulp_clock_en_i),
      .scan_cg_en_i       (riscv_intf.scan_cg_en_i),
      .boot_addr_i        (riscv_intf.boot_addr_i),
      .mtvec_addr_i       (riscv_intf.mtvec_addr_i),
      .dm_halt_addr_i     (riscv_intf.dm_halt_addr_i),
      .hart_id_i          (riscv_intf.hart_id_i),
      .dm_exception_addr_i(riscv_intf.dm_exception_addr_i),

      // Instruction memory interface
      .instr_req_o   (riscv_intf.instr_req_o),
      .instr_gnt_i   (riscv_intf.instr_gnt_i),
      .instr_rvalid_i(riscv_intf.instr_rvalid_i),
      .instr_addr_o  (riscv_intf.instr_addr_o),
      .instr_rdata_i (riscv_intf.instr_rdata_i),

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
      .irq_i    (riscv_intf.irq_i),
      .irq_ack_o(riscv_intf.irq_ack_o),
      .irq_id_o (riscv_intf.irq_id_o),

      // Debug Interface
      .debug_req_i      (riscv_intf.debug_req_i),
      .debug_havereset_o(riscv_intf.debug_havereset_o),
      .debug_running_o  (riscv_intf.debug_running_o),
      .debug_halted_o   (riscv_intf.debug_halted_o),

      // CPU Control Signals
      .fetch_enable_i(riscv_intf.fetch_enable_i),
      .core_sleep_o  (riscv_intf.core_sleep_o)
  );

  //==================================================================================
  // Binding internal interfaces
  //==================================================================================
  `include "riscv_assign.svh"

  //==================================================================================
  // Configuration and Test
  //==================================================================================
  initial begin
    // Main Interface configuration setup
    // ---------------------------------------------------------------------
    uvm_config_db#(virtual riscv_if)::set(null, "uvm_test_top", "riscv_intf", riscv_intf);

    // Prefetch configuration setup
    uvm_config_db#(virtual fetch_if)::set(null, "uvm_test_top", "fetch_intf", fetch_intf);

    // MUL configuration setup
    // ---------------------------------------------------------------------
    uvm_config_db#(virtual mul_if)::set(null, "uvm_test_top", "mul_intf", mul_intf);


    // ALU-DIV configuration setup
    // ---------------------------------------------------------------------
    uvm_config_db#(virtual alu_if)::set(null, "uvm_test_top", "alu_intf", alu_intf);

    // LSU configuration setup
    // ---------------------------------------------------------------------
    uvm_config_db#(virtual lsu_if)::set(null, "uvm_test_top", "lsu_intf", lsu_intf);

    // Run the testbench with the specified test
    // ---------------------------------------------------------------------
    run_test("riscv_test");
  end

  initial begin
    $dumpfile("riscv_top_tb.vcd");
    $dumpvars(0, riscv_top_tb);
    $display("Starting simulation");
  end

endmodule
