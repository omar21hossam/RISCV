all: compile sim coverage

compile:
	vlib work
	vlog -sv -f files.f +cover

sim:
	vsim -wlf mul_top.wlf -logfile sim.log -c -coverage -assertdebug -voptargs="+acc" work.mul_top -do  "coverage save -onexit -directive -codeAll mul_top.ucdb; run -all"
	vcd2wlf mul_top.vcd mul_top.wlf

coverage:
	vcover report -html -htmldir coverage_report mul_top.ucdb

