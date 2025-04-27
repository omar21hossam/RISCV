all: compile sim coverage

compile:
	vlib work
	vlog -sv -f files.f +cover

sim:
	vsim -wlf riscv.wlf -logfile sim.log -c -coverage -voptargs="+acc" work.riscv_top_tb -do  "coverage save -onexit -directive -codeAll riscv.ucdb; run -all"
	vcd2wlf tb.vcd riscv.wlf

coverage:
	vcover report -html -htmldir coverage_report riscv.ucdb