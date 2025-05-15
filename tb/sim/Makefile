# ─────────────────────────────────────────────────────────────
#  User-tweakable variables
# ─────────────────────────────────────────────────────────────
TESTS          := riscv_base_test riscv_rand_test riscv_direct_test
UCDBS          := $(addsuffix .ucdb,$(TESTS))
MERGED_UCDB    := riscv_merged.ucdb
TOP            := work.riscv_top_tb
VOPTARGS       := +acc
EXTRA_VSIM_OPTS:= -coverage -assertdebug -voptargs="$(VOPTARGS)"

# ─────────────────────────────────────────────────────────────
#  Phony targets
# ─────────────────────────────────────────────────────────────
.PHONY: all compile merge coverage clean \
        riscv_base_test riscv_rand_test riscv_direct_test

# Friendly aliases ─ run just one test if you like
riscv_base_test  : riscv_base_test.ucdb
riscv_rand_test  : riscv_rand_test.ucdb
riscv_direct_test: riscv_direct_test.ucdb

# Default full flow
all: compile $(UCDBS) merge coverage

# ─────────────────────────────────────────────────────────────
#  1. Compile
# ─────────────────────────────────────────────────────────────
compile:
	vlib work
	vlog -sv -f files.f +cover

# ─────────────────────────────────────────────────────────────
#  2. Simulate each test (pattern rule)
# ─────────────────────────────────────────────────────────────
%.ucdb: compile
	@echo "===> Running $* ..."
	vsim -c -wlf $*.wlf -logfile $*.log $(EXTRA_VSIM_OPTS) \
	     $(TOP) +UVM_TESTNAME=$* \
	     -do "coverage save -onexit $@; run -all; quit -f"
	@echo "===> $* finished, UCDB saved as $@"

# ─────────────────────────────────────────────────────────────
# 3. Merge coverage
# ─────────────────────────────────────────────────────────────
merge: $(UCDBS)
	@echo "===> Merging UCDB files into $(MERGED_UCDB)"
	vcover merge $(MERGED_UCDB) $(UCDBS)

# ─────────────────────────────────────────────────────────────
# 4. Generate HTML report
# ─────────────────────────────────────────────────────────────
coverage: merge
	@echo "===> Generating HTML coverage report (coverage_report/)"
	vcover report -html -details -annotate -output coverage_report $(MERGED_UCDB)

# ─────────────────────────────────────────────────────────────
# 5. House-keeping
# ─────────────────────────────────────────────────────────────
clean:
	rm -rf work *.wlf *.log *.ucdb coverage_report
