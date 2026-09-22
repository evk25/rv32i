# Variables
TOP_MODULE = tb_top
SRC        = $(wildcard src/*.v) $(wildcard tb/*.v) $(wildcard tb/*.sv)
OUT_DIR    = build
OUT        = $(OUT_DIR)/sim.vvp
VCD        = dump.vcd

# ImmGen specific files
IMM_TOP    = tb_imm_gen
IMM_SRC    = src/modules/ImmGen.v tb/tb_imm_gen.v
IMM_OUT    = $(OUT_DIR)/imm_gen.vvp

# Default target
all: run

# Ensure directory exists and compile default simulation
$(OUT): $(SRC)
	@mkdir -p $(OUT_DIR)
	iverilog -g2012 -o $(OUT) -s $(TOP_MODULE) $(SRC)

# Compile ImmGen testbench only
$(IMM_OUT): $(IMM_SRC)
	@mkdir -p $(OUT_DIR)
	iverilog -g2012 -o $(IMM_OUT) -s $(IMM_TOP) $(IMM_SRC)

# Run default simulation
run: $(OUT)
	vvp $(OUT)
	@surfer $(VCD) > /dev/null 2>&1 &

# Run ImmGen simulation and launch Surfer
run-imm: $(IMM_OUT)
	vvp $(IMM_OUT)
	@surfer $(VCD) > /dev/null 2>&1 &

# Clean generated files
clean:
	@rm -rf $(OUT_DIR) $(VCD)

.PHONY: all run run-imm clean
