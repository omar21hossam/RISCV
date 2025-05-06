module riscv_top_tb ();

  //==================================================================================
  // Packages
  //==================================================================================
  import uvm_pkg::*;
  import riscv_classes_pkg::*;
  import riscv_pkg::*;

  //==================================================================================
  // Interface Instantiation
  //==================================================================================
  riscv_intf riscv_intf_ (clk);
  interface_clk interface_clk_ (clk);
  // Prefetch interface instantiation
  // ALU-DIV interface instasntiation
  ALU_interface alu_intf_ (clk);
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


  //==================================================================================
  // `defines
  //==================================================================================
  `define alu_signals_path        cv32e40p_top.cv32e40p_core.cv32e40p_ex_stage.cv32e40p_alu 
  `define alu_rst_n               `alu_signals_path.rst_n 
  `define alu_enable_i            `alu_signals_path.enable_i
  `define alu_operator_i          `alu_signals_path.operator_i
  `define alu_operand_a_i         `alu_signals_path.operand_a_i
  `define alu_operand_b_i         `alu_signals_path.operand_b_i
  `define alu_ex_ready_i          `alu_signals_path.ex_ready_i
  `define alu_result_o            `alu_signals_path.result_o
  `define alu_ready_o             `alu_signals_path.ready_o
  `define alu_comparison_result_o `alu_signals_path.comparison_result_o
  `define alu_vector_mode_i       `alu_signals_path.vector_mode_i
  //==================================================================================
  // connect alu modules ports to the ALU interface
  //==================================================================================
  assign alu_intf_.rst_n = `alu_rst_n;
  assign alu_intf_.enable_i = `alu_enable_i;
  assign alu_intf_.operator_i = `alu_operator_i;
  assign alu_intf_.operand_a_i = `alu_operand_a_i;
  assign alu_intf_.operand_b_i = `alu_operand_b_i;
  assign alu_intf_.ex_ready_i = `alu_ex_ready_i;
  assign alu_intf_.result_o = `alu_result_o;
  assign alu_intf_.ready_o = `alu_ready_o;
  assign alu_intf_.comparison_result_o = `alu_comparison_result_o;
  assign alu_intf_.vector_mode_i = `alu_vector_mode_i;

  // =====================================================================
  // Connecting the interface to the DUT
  // ======================================================================
  // DUT interface
  bind riscv_instr_mem : inst_mem_DUT inst_mem_intf inst_mem_intf_ (.*);

  // Prefetch interface
  // ALU-DIV interface
  // MUL interface
  // LSU interface


  //==================================================================================
  // Configuration
  //==================================================================================
  initial begin
    uvm_config_db#(virtual riscv_intf)::set(null, "uvm_test_top", "main_intf", riscv_intf_);
    uvm_config_db#(virtual interface_clk)::set(null, "uvm_test_top", "clk_", interface_clk_);
    // Prefetch configuration setup
    // ALU-DIV configuration setup
    uvm_config_db#(virtual ALU_interface)::set(null, "uvm_test_top", "alu_intf_top2test", alu_intf_);
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
  bit clk = 1'b0;
  initial begin
    forever #(CLK_FREQ / 2) clk = ~clk;
  end

endmodule
