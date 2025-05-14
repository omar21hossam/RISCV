all: compile sim coverage

compile:
	vlib work
	vlog -sv -f files.f +cover

sim:
	vsim -wlf riscv.wlf -logfile sim.log -c -coverage -assertdebug -voptargs="+acc" work.riscv_top_tb -do  "coverage save -onexit  riscv.ucdb; run -all; coverage save riscv.ucdb"
	vcd2wlf riscv_top_tb.vcd riscv.wlf

coverage:
		vcover report -html -details -annotate -output coverage_report riscv.ucdb
		#  _____ _____    _    __  __  __     __         
		# |_   _| ____|  / \  |  \/  | \ \   / /         
		#   | | |  _|   / _ \ | |\/| |  \ \ / /          
		#   | | | |___ / ___ \| |  | |   \ V /           
		#   |_| |_____/_/   \_|_|  |_|    \_/            
		#                                                
		#  ____ ___   __     _____ ____ ___ ___  _   _   
		# / ___|_ _|  \ \   / |_ _/ ___|_ _/ _ \| \ | |  
		# \___ \| |____\ \ / / | |\___ \| | | | |  \| |  
		#  ___) | |_____\ V /  | | ___) | | |_| | |\  |  
		# |____|___|     \_/  |___|____|___\___/|_| \_|  
		#                                                
		#     _    ____    _    ____  _____ __  ____   __
		#    / \  / ___|  / \  |  _ \| ____|  \/  \ \ / /
		#   / _ \| |     / _ \ | | | |  _| | |\/| |\ V / 
		#  / ___ | |___ / ___ \| |_| | |___| |  | | | |  
		# /_/   \_\____/_/   \_|____/|_____|_|  |_| |_|  