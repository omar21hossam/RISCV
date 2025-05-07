package riscv_classes_pkg;
   //`define alu_files_path "ALU_DIV/tb_files/"
    import uvm_pkg::*;
    import riscv_pkg::*;  //need to import the static array of required alu instructions
    `include "uvm_macros.svh"
    `include "prefetch/riscv_fetch_config_obj.svh"
    `include "prefetch/riscv_seqitem.svh"
    `include /*`alu_files_path*/ "ALU_DIV/tb_files/ALU_sequence_item.svh"
    `include /*`alu_files_path*/ "ALU_DIV/tb_files/ALU_driver.svh"
    `include /*`alu_files_path*/ "ALU_DIV/tb_files/ALU_monitor.svh"
    `include /*`alu_files_path*/ "ALU_DIV/tb_files/ALU_agent.svh"
    `include /*`alu_files_path*/ "ALU_DIV/tb_files/ALU_scoreboard.svh"
    // `include "riscv_sequence_b.svh"
    // `include "riscv_sequencer.svh"
    // `include "riscv_main_driver.svh"
    // `include "fetch_monitor.svh"
    // `include "fetch_agent.svh"
    // `include "riscv_scoreboard.svh"
    // `include "riscv_subscriber.svh"
    `include "riscv_env.svh"
    `include "riscv_test.svh"
endpackage : riscv_classes_pkg