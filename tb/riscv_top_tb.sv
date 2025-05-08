module riscv_top_tb ();

  //==================================================================================
  // Packages
  //==================================================================================
  import uvm_pkg::*;
  import riscv_classes_pkg::*;
 // import riscv_pkg::*;

  //==================================================================================
  // Interface Instantiation
  //==================================================================================
    bit clk = 1'b0;

  riscv_intf riscv_intf_ (clk);
 
  // Prefetch interface instantiation
  // ALU-DIV interface instasntiation
  // MUL interface instantiation
  // LSU interface instantiation

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

  // =====================================================================
  // Connecting the interface to the DUT
  // ======================================================================
  // Prefetch interface
  // ALU-DIV interface
  // MUL interface
  // LSU interface


  //==================================================================================
  // Configuration
  //==================================================================================
  initial begin
    uvm_config_db#(virtual riscv_intf)::set(null, "uvm_test_top", "main_intf", riscv_intf_);
    // Prefetch configuration setup
    // ALU-DIV configuration setup
    // MUL configuration setup
    // LSU configuration setup

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
