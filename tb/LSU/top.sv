module top;
  //==================================================================================
  // Packages
  //==================================================================================
  import uvm_pkg::*;
  import classes_pkg::*;
  import riscv_pkg::*;
  bit clk;

  //==================================================================================
  // Interface Instantiation
  //==================================================================================
  lsu_if intf (.clk(clk));

  //==================================================================================
  // DUT Instantiation
  //==================================================================================
  cv32e40p_load_store_unit dut (
    .clk(clk),
    .rst_n(intf.rst_n),
    .data_req_o(intf.data_req_o),
    .data_gnt_i(intf.data_gnt_i),
    .data_rvalid_i(intf.data_rvalid_i),
    .data_err_i(intf.data_err_i),
    .data_err_pmp_i(intf.data_err_pmp_i),
    .data_addr_o(intf.data_addr_o),
    .data_we_o(intf.data_we_o),
    .data_be_o(intf.data_be_o),
    .data_wdata_o(intf.data_wdata_o),
    .data_rdata_i(intf.data_rdata_i),
    .data_we_ex_i(intf.data_we_ex_i),
    .data_type_ex_i(intf.data_type_ex_i),
    .data_wdata_ex_i(intf.data_wdata_ex_i),
    .data_reg_offset_ex_i(intf.data_reg_offset_ex_i),
    .data_load_event_ex_i(intf.data_load_event_ex_i),
    .data_sign_ext_ex_i(intf.data_sign_ext_ex_i),
    .data_rdata_ex_o(intf.data_rdata_ex_o),
    .data_req_ex_i(intf.data_req_ex_i),
    .operand_a_ex_i(intf.operand_a_ex_i),
    .operand_b_ex_i(intf.operand_b_ex_i),
    .addr_useincr_ex_i(intf.addr_useincr_ex_i),
    .data_misaligned_ex_i(intf.data_misaligned_ex_i),
    .data_misaligned_o(intf.data_misaligned_o),
    .data_atop_ex_i(intf.data_atop_ex_i),
    .data_atop_o(intf.data_atop_o),
    .p_elw_start_o(intf.p_elw_start_o),
    .p_elw_finish_o(intf.p_elw_finish_o),
    .lsu_ready_ex_o(intf.lsu_ready_ex_o),
    .lsu_ready_wb_o(intf.lsu_ready_wb_o),
    .busy_o(intf.busy_o)
  );

  //==================================================================================
  // Configuration
  //==================================================================================
  initial begin
    uvm_config_db#(virtual lsu_if)::set(null, "uvm_test_top", "vif", intf);
    run_test("lsu_test");
  end

  //==================================================================================
  // Clock Generation Block
  //==================================================================================
  initial begin
    forever #(CLK_FREQ / 2) clk = ~clk;
  end

endmodule
