onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_i/clk
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_i/rst_n
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_en_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/mult_en_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_result
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/mult_result
add wave -noupdate -color Gold /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_alu_we_fw_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_alu_wdata_fw_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_waddr_wb_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_wdata_wb_o
add wave -noupdate -radix unsigned /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_alu_waddr_fw_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/lsu_ready_ex_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_i/ex_ready_i
add wave -noupdate -color Yellow /riscv_top_tb/DUT/core_i/ex_stage_i/ex_valid_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/data_req_i
add wave -noupdate -color Red /riscv_top_tb/DUT/core_i/ex_stage_i/data_rvalid_i
add wave -noupdate -color Gold /riscv_top_tb/DUT/core_i/ex_stage_i/data_misaligned_ex_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/lsu_en_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/lsu_rdata_i
add wave -noupdate -color Red /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_we_wb_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_waddr_lsu
add wave -noupdate -expand /riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/mem
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/lsu_en_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_en_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/mult_en_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19550001 ps} 1} {{Cursor 2} {19500000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 196
configure wave -valuecolwidth 103
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {17615442 ps} {20744442 ps}
