all: compile sim coverage

compile:
	vlib work
	vlog -sv -f files.f +cover

sim:
	vsim -wlf riscv.wlf -logfile sim.log -c -coverage -assertdebug -voptargs="+acc" work.riscv_top_tb -do  "coverage save -onexit  riscv.ucdb; run -all; coverage save riscv.ucdb"
	vcd2wlf riscv_top_tb.vcd riscv.wlf

coverage:
		vcover report -html -details -annotate -output coverage_report riscv.ucdb