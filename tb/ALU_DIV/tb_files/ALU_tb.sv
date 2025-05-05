`timescale 1ns/1ps  
`include "ALU_interface.svh"
module riscv_alu_top_tb(
);
//==============================================================================
// Description: Parameters
//==============================================================================
parameter ClkPeriod = 10;
//==============================================================================
// Description: Clock
//==============================================================================
bit           clk_tb,rst_n_tb;
//==============================================================================
// Description: Include the packages
//==============================================================================
import uvm_pkg::*;
import package_uvm::*;
//==============================================================================
//Description: Clock generator
//==============================================================================
initial begin:clk_gen
forever begin
#(ClkPeriod/2) clk_tb = ~ clk_tb;
end 
end
//==============================================================================
//Description: active low reset generator
//==============================================================================
initial begin:reset_gen
rst_n_tb =0;
# ClkPeriod
rst_n_tb =1;
end
//==============================================================================
//Description: Interface
//==============================================================================
ALU_interface  intf1(clk_tb,rst_n_tb);
//==============================================================================
//Description: DUT
//==============================================================================
cv32e40p_alu alu_dut(
.clk(intf1.core_clk),
.rst_n(rst_n_tb),
.enable_i(intf1.enable_i),
.operator_i(intf1.operator_i),
.operand_a_i(intf1.operand_a_i),
.operand_b_i(intf1.operand_b_i),
.vector_mode_i(intf1.vector_mode_i),
.operand_c_i('b0),
.bmask_a_i('b0),
.bmask_b_i('b0),
.imm_vec_ext_i('b0),
.is_clpx_i('b0),
.is_subrot_i('b0),
.clpx_shift_i('b0),
//////////////////////////////////////
.result_o(intf1.result_o),
.comparison_result_o(intf1.comparison_result_o),
.ready_o(intf1.ready_o),
.ex_ready_i(intf1.ex_ready_i)
);
//==============================================================================
//Description: Main block
//==============================================================================
initial begin
uvm_config_db#(virtual ALU_interface)::set(null,"uvm_test_top","top2test",intf1);
  run_test("alu_test");		
end

//==============================================================================
 initial begin
    $dumpfile("riscv_top_tb.vcd");
   // $dumpvars(0,riscv_alu_top_tb);
    $dumpvars;
    $display("Starting simulation");
 end

    
endmodule
