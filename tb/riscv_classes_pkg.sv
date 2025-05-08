package riscv_classes_pkg;
  //==================================================================================
  // UVM inclusion
  //==================================================================================
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //==================================================================================
  // ALU classes inclusion
  //==================================================================================
  `include "ALU_DIV/tb_files/alu_sequence_item.svh"
  `include "ALU_DIV/tb_files/alu_driver.svh"
  `include "ALU_DIV/tb_files/alu_monitor.svh"
  `include "ALU_DIV/tb_files/alu_config.svh"
  `include "ALU_DIV/tb_files/alu_agent.svh"
  `include "ALU_DIV/tb_files/alu_scoreboard.svh"
  `include "ALU_DIV/tb_files/alu_coverage_collector.svh"

  //==================================================================================
  // MUL classes inclusion
  //==================================================================================
  `include "mul/mul_sequence_item.svh"
  `include "mul/mul_coverage_collector.svh"
  `include "mul/mul_sequencer.svh"
  `include "mul/mul_monitor.svh"
  `include "mul/mul_driver.svh"
  `include "mul/mul_config.svh"
  `include "mul/mul_agent.svh"
  `include "mul/mul_scoreboard.svh"

  //==================================================================================
  // LSU classes inclusion
  //==================================================================================
  `include "lsu/lsu_sequence_item.svh"
  `include "lsu/lsu_sequence.svh"
  `include "lsu/lsu_sequencer.svh"
  `include "lsu/lsu_coverage_collector.svh"
  `include "lsu/lsu_scoreboard.svh"
  `include "lsu/lsu_driver.svh"
  `include "lsu/lsu_monitor.svh"
  `include "lsu/lsu_agent.svh"

  //==================================================================================
  // Prefetch classes inclusion
  //==================================================================================
  `include "riscv_sequence_item.svh"
  `include "prefetch/fetch_config_obj.svh"
  `include "prefetch/fetch_driver.svh"
  `include "prefetch/fetch_monitor.svh"
  `include "prefetch/fetch_scoreboard.svh"
  `include "prefetch/fetch_sequencer.svh"
  `include "prefetch/fetch_agent.svh"

  //==================================================================================
  // RISCV TOP classes inclusion
  //==================================================================================
  `include "riscv_vseqr.svh"
  `include "riscv_base_sequence.svh"
  `include "riscv_vsequ_base.svh"
  `include "riscv_vsequ_arith.svh"
  `include "riscv_env.svh"
  `include "riscv_base_test.svh"

endpackage
