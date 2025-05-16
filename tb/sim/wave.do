onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_i/clk
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_i/rst_n
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_operand_a_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_operand_b_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_en_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/mult_operand_a_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/mult_operand_b_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/mult_en_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_waddr_wb_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_we_wb_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_wdata_wb_o
add wave -noupdate -radix unsigned /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_alu_waddr_fw_o
add wave -noupdate -color {Medium Blue} /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_alu_we_fw_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_alu_wdata_fw_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/lsu_ready_ex_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_result
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/mult_result
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_ready
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/mult_ready
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_i/ready_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_i/ex_ready_i
add wave -noupdate -color {Slate Blue} /riscv_top_tb/DUT/core_i/ex_stage_i/ex_valid_o
add wave -noupdate -expand /riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20350000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 381
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {20126900 ps} {20773101 ps}
