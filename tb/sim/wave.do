onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/rst_n
add wave -noupdate -divider -height 20 {Register File}
add wave -noupdate /riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/mem
add wave -noupdate /riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/raddr_a_i
add wave -noupdate /riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/raddr_b_i
add wave -noupdate /riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/waddr_a_i
add wave -noupdate /riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/wdata_a_i
add wave -noupdate /riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/we_a_i
add wave -noupdate /riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/we_b_i
add wave -noupdate -divider -height 20 {ALU Signals}
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/clk
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_en_i
add wave -noupdate -color {Medium Orchid} /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_alu_we_fw_power_o
add wave -noupdate -color {Sky Blue} /riscv_top_tb/DUT/core_i/ex_stage_i/ex_valid_o
add wave -noupdate -color Yellow /riscv_top_tb/reg_intf/alu_filter_valid
add wave -noupdate -color Gray80 /riscv_top_tb/DUT/core_i/id_stage_i/controller_i/jump_done
add wave -noupdate -color {Orange Red} -radix unsigned /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_alu_waddr_fw_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_alu_wdata_fw_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/alu_operator_i
add wave -noupdate -color Sienna -radix hexadecimal /riscv_top_tb/DUT/core_i/ex_stage_i/alu_result
add wave -noupdate {/riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/mem[4]}
add wave -noupdate {/riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/mem[8]}
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/mult_operator_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/mult_en_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/mult_result
add wave -noupdate /riscv_top_tb/DUT/core_i/id_stage_i/decoder_i/instr_rdata_i
add wave -noupdate -divider -height 20 {LSU Signals}
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/lsu_en_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/data_req_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/data_misaligned_ex_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/data_misaligned_i
add wave -noupdate -color {Sky Blue} /riscv_top_tb/DUT/core_i/ex_stage_i/data_rvalid_i
add wave -noupdate -color Yellow /riscv_top_tb/reg_intf/lsu_filter_valid
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/lsu_rdata_i
add wave -noupdate -color {Orange Red} -radix unsigned /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_waddr_wb_o
add wave -noupdate -color {Medium Orchid} /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_we_wb_power_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_we_lsu
add wave -noupdate -radix unsigned /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_waddr_lsu
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/regfile_wdata_wb_o
add wave -noupdate -divider -height 20 Branch/Jump
add wave -noupdate -radix unsigned /riscv_top_tb/fetch_intf/pc_if_o
add wave -noupdate -radix unsigned /riscv_top_tb/fetch_intf/pc_id_o
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/branch_in_ex_i
add wave -noupdate /riscv_top_tb/DUT/core_i/ex_stage_i/jump_target_o
add wave -noupdate /riscv_top_tb/DUT/core_i/id_stage_i/controller_i/branch_taken_ex_i
add wave -noupdate /riscv_top_tb/DUT/core_i/id_stage_i/pc_set_o
add wave -noupdate /riscv_top_tb/DUT/core_i/id_stage_i/jump_target_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 7} {625350001 ps} 1}
quietly wave cursor active 1
configure wave -namecolwidth 187
configure wave -valuecolwidth 100
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
WaveRestoreZoom {523026848 ps} {985973152 ps}
