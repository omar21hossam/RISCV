module riscv_top_tb(
);

     import uvm_pkg::*;
     import  riscv_base_test_pkg ::*;
    `include "uvm_macros.svh"
//********** clk_generation ************//    
    bit   clk= 1'b0 ;
    always #(5) clk = ~clk;
//*************************************** 
//********** intf_DUT_connection_istantiation ************// 
  	riscv_intf    riscv_intf_ (clk);
    interface_clk interface_clk_(clk);
	cv32e40p_top DUT (
        .clk_i(clk),   // explicitly connect clk
   //      .*          // connects riscv_intf_.a to dut.a, riscv_intf_.b to dut.b
    .rst_ni           (riscv_intf_.rst_ni),
    .pulp_clock_en_i  (riscv_intf_.pulp_clock_en_i),
    .scan_cg_en_i     (riscv_intf_.scan_cg_en_i),
    .boot_addr_i      (riscv_intf_.boot_addr_i),
    .mtvec_addr_i     (riscv_intf_.mtvec_addr_i),
    .dm_halt_addr_i   (riscv_intf_.dm_halt_addr_i),
    .hart_id_i        (riscv_intf_.hart_id_i),
    .dm_exception_addr_i (riscv_intf_.dm_exception_addr_i),
    .instr_req_o      (riscv_intf_.instr_req_o),
    .instr_gnt_i      (riscv_intf_.instr_gnt_i),
    .instr_rvalid_i   (riscv_intf_.instr_rvalid_i),
    .instr_addr_o     (riscv_intf_.instr_addr_o),
    .instr_rdata_i    (riscv_intf_.instr_rdata_i),
    .data_req_o       (riscv_intf_.data_req_o),
    .data_gnt_i       (riscv_intf_.data_gnt_i),
    .data_rvalid_i    (riscv_intf_.data_rvalid_i),
    .data_we_o        (riscv_intf_.data_we_o),
    .data_be_o        (riscv_intf_.data_be_o),
    .data_addr_o      (riscv_intf_.data_addr_o),
    .data_wdata_o     (riscv_intf_.data_wdata_o),
    .data_rdata_i     (riscv_intf_.data_rdata_i),
    .irq_i            (riscv_intf_.irq_i),
    .irq_ack_o        (riscv_intf_.irq_ack_o),
    .irq_id_o         (riscv_intf_.irq_id_o),
    .debug_req_i      (riscv_intf_.debug_req_i),
    .debug_havereset_o(riscv_intf_.debug_havereset_o),
    .debug_running_o  (riscv_intf_.debug_running_o),
    .debug_halted_o   (riscv_intf_.debug_halted_o),
    .fetch_enable_i   (riscv_intf_.fetch_enable_i),
    .core_sleep_o     (riscv_intf_.core_sleep_o)



    ); 


    riscv_instr_mem inst_mem_DUT (
    .clk(clk),
    .instr_gnt_o       (riscv_intf_.instr_gnt_i),
    .instr_rvalid_o    (riscv_intf_.instr_rvalid_i),
    .instr_rdata_o     (riscv_intf_.instr_rdata_i),
    .instr_req_i       (riscv_intf_.instr_req_o), 
    .instr_addr_i      (riscv_intf_.instr_addr_o),
    .addr              (riscv_intf_.addr),
    .inst              (riscv_intf_.inst),
    .reset_n           (riscv_intf_.rst_ni)

    );
//*************************************** 
    initial begin
  uvm_config_db#(virtual riscv_intf)::set(null ,"uvm_test_top", "main_intf" ,riscv_intf_); 

  uvm_config_db#(virtual interface_clk)::set(null ,"uvm_test_top", "clk_" ,interface_clk_ ); 
    `uvm_info("top ","clk,main intf were put by top " , UVM_LOW) ;        


    end
//****************************************//   
   
   
    initial begin
        
        run_test("riscv_base_test");
    end

    initial begin
        $dumpfile("riscv_top_tb.vcd");
        $dumpvars(0, riscv_top_tb);
        $display("Starting simulation");
    end

    
endmodule