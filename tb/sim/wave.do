onerror {resume}
quietly set dataset_list [list sim vsim riscv1 riscv]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate sim:/riscv_top_tb/DUT/rst_ni
add wave -noupdate sim:/riscv_top_tb/DUT/pulp_clock_en_i
add wave -noupdate sim:/riscv_top_tb/DUT/scan_cg_en_i
add wave -noupdate sim:/riscv_top_tb/DUT/mtvec_addr_i
add wave -noupdate sim:/riscv_top_tb/DUT/dm_halt_addr_i
add wave -noupdate sim:/riscv_top_tb/DUT/hart_id_i
add wave -noupdate sim:/riscv_top_tb/DUT/dm_exception_addr_i
add wave -noupdate sim:/riscv_top_tb/DUT/boot_addr_i
add wave -noupdate sim:/riscv_top_tb/DUT/instr_req_o
add wave -noupdate sim:/riscv_top_tb/DUT/instr_gnt_i
add wave -noupdate sim:/riscv_top_tb/DUT/instr_rvalid_i
add wave -noupdate sim:/riscv_top_tb/DUT/instr_addr_o
add wave -noupdate sim:/riscv_top_tb/DUT/instr_rdata_i
add wave -noupdate sim:/riscv_top_tb/DUT/data_req_o
add wave -noupdate sim:/riscv_top_tb/DUT/data_gnt_i
add wave -noupdate sim:/riscv_top_tb/DUT/data_rvalid_i
add wave -noupdate sim:/riscv_top_tb/DUT/data_we_o
add wave -noupdate sim:/riscv_top_tb/DUT/data_be_o
add wave -noupdate sim:/riscv_top_tb/DUT/data_addr_o
add wave -noupdate sim:/riscv_top_tb/DUT/data_wdata_o
add wave -noupdate sim:/riscv_top_tb/DUT/data_rdata_i
add wave -noupdate sim:/riscv_top_tb/DUT/irq_i
add wave -noupdate sim:/riscv_top_tb/DUT/irq_ack_o
add wave -noupdate sim:/riscv_top_tb/DUT/irq_id_o
add wave -noupdate sim:/riscv_top_tb/DUT/debug_req_i
add wave -noupdate sim:/riscv_top_tb/DUT/debug_havereset_o
add wave -noupdate sim:/riscv_top_tb/DUT/debug_running_o
add wave -noupdate sim:/riscv_top_tb/DUT/debug_halted_o
add wave -noupdate sim:/riscv_top_tb/DUT/fetch_enable_i
add wave -noupdate sim:/riscv_top_tb/DUT/core_sleep_o
add wave -noupdate sim:/riscv_top_tb/DUT/core_i/id_stage_i/register_file_i/mem
add wave -noupdate sim:/riscv_top_tb/DUT/clk_i
add wave -noupdate sim:/riscv_top_tb/DUT/core_i/ex_stage_i/mult_i/operator_i
add wave -noupdate -color Salmon sim:/riscv_top_tb/DUT/core_i/ex_stage_i/mult_i/op_a_i
add wave -noupdate sim:/riscv_top_tb/DUT/core_i/ex_stage_i/mult_i/op_b_i
add wave -noupdate -color Yellow sim:/riscv_top_tb/DUT/core_i/ex_stage_i/mult_i/result_o
add wave -noupdate sim:/riscv_top_tb/mul_intf/ready_o
add wave -noupdate sim:/riscv_top_tb/mul_intf/multicycle_o
add wave -noupdate sim:/riscv_top_tb/mul_intf/mulh_active_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 7} {13508895 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 234
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 2
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
WaveRestoreZoom {0 ps} {1100 ns}
