# ─────────────────────────────────────────────────────────────
#  User-tweakable variables
# ─────────────────────────────────────────────────────────────
DEFAULT_TESTS   := riscv_rand_test riscv_direct_test
UCDBS           := $(addsuffix .ucdb,$(DEFAULT_TESTS))
MERGED_UCDB     := riscv_merged.ucdb
TOP             := work.riscv_top_tb
VOPTARGS        := +acc
EXTRA_VSIM_OPTS := -coverage -assertdebug -voptargs="$(VOPTARGS)"
SEED 						?= $(shell date +%s)


# ─────────────────────────────────────────────────────────────
#  Phony targets
# ─────────────────────────────────────────────────────────────
.PHONY: all compile merge coverage clean \
        riscv_base_test riscv_rand_test riscv_direct_test

# One-off alias (not in 'all'):
riscv_base_test: riscv_base_test.ucdb

# Friendly aliases
riscv_rand_test  : riscv_rand_test.ucdb
riscv_direct_test: riscv_direct_test.ucdb

# Default/full-parallel flow
all: compile $(UCDBS) merge coverage

# ─────────────────────────────────────────────────────────────
#  1. Compile
# ─────────────────────────────────────────────────────────────
compile:
	#
	#
	#		  _____ _____    _    __  __  __     __         
	#		 |_   _| ____|  / \  |  \/  | \ \   / /         
	#		   | | |  _|   / _ \ | |\/| |  \ \ / /          
	#		   | | | |___ / ___ \| |  | |   \ V /           
	#		   |_| |_____/_/   \_|_|  |_|    \_/            
	#		                                                
	#		  ____ ___   __     _____ ____ ___ ___  _   _   
	#		 / ___|_ _|  \ \   / |_ _/ ___|_ _/ _ \| \ | |  
	#		 \___ \| |____\ \ / / | |\___ \| | | | |  \| |  
	#		  ___) | |_____\ V /  | | ___) | | |_| | |\  |  
	#		 |____|___|     \_/  |___|____|___\___/|_| \_|  
	#		                                                
	#		     _    ____    _    ____  _____ __  ____   __
	#		    / \  / ___|  / \  |  _ \| ____|  \/  \ \ / /
	#		   / _ \| |     / _ \ | | | |  _| | |\/| |\ V / 
	#		  / ___ | |___ / ___ \| |_| | |___| |  | | | |  
	#		 /_/   \_\____/_/   \_|____/|_____|_|  |_| |_|
	#
	#
	vlib work
	vlog -sv -f files.f +cover

# ─────────────────────────────────────────────────────────────
#  2. Simulate each test (pattern rule)
# ─────────────────────────────────────────────────────────────
%.ucdb: compile
	@echo "===> Running $* with seed $(SEED) ..."
	vsim -c -wlf $*.wlf -logfile $*.log $(EXTRA_VSIM_OPTS) \
	     $(TOP) +UVM_TESTNAME=$* +sv_seed=$(SEED) \
	     -do "vcd file $*.vcd; vcd add -r /*; coverage save -onexit $@; run -all; quit -f"
	vcd2wlf $*.vcd $*.wlf
	@echo "===> $* finished, UCDB saved as $@"


# ─────────────────────────────────────────────────────────────
# 3. Merge coverage (only the defaults)
# ─────────────────────────────────────────────────────────────
merge: $(UCDBS)
	@echo "===> Merging UCDB files into $(MERGED_UCDB)"
	vcover merge $(MERGED_UCDB) $(UCDBS)

# ─────────────────────────────────────────────────────────────
# 4. Generate HTML report + ASCII art at the end
# ─────────────────────────────────────────────────────────────
coverage: merge
	@echo "===> Generating HTML coverage report (coverage_report/)"
	vcover report -html -details -annotate -output coverage_report $(MERGED_UCDB)

# ─────────────────────────────────────────────────────────────
# 5. Clean up
# ─────────────────────────────────────────────────────────────
clean:
	rm -rf work *.wlf *.log *.ucdb coverage_report
