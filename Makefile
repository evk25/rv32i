# Variables
TOP_MODULE = tb_top
OUT_DIR    = build
OUT        = $(OUT_DIR)/sim.vvp
VCD        = dump.vcd
IVERILOG   = iverilog -g2012 -I src/modules

MODULES    = $(filter-out src/modules/template_module.v, $(wildcard src/modules/*.v))
# SRC        = src/SingleCycleProcessor.v $(MODULES) tb/tb_top.v
SRC        = src/MultiCycleProcessor.v $(MODULES) tb/tb_top.v

# Default target
all: run

# Compile and run default top-level simulation (prog2.hex by default, or override PROG=prog1.hex)
$(OUT): $(SRC)
	@mkdir -p $(OUT_DIR)
	$(IVERILOG) -o $(OUT) -s $(TOP_MODULE) $(SRC)

run: $(OUT)
	vvp $(OUT)
	@surfer $(VCD) > /dev/null 2>&1 &

# Program-specific top-level targets
run-prog1: $(SRC)
	@mkdir -p $(OUT_DIR)
	$(IVERILOG) -P tb_top.MEM_FILE=\"prog1.hex\" -o $(OUT_DIR)/prog1.vvp -s tb_top $(SRC)
	vvp $(OUT_DIR)/prog1.vvp
	@surfer $(VCD) > /dev/null 2>&1 &

run-prog2: $(SRC)
	@mkdir -p $(OUT_DIR)
	$(IVERILOG) -P tb_top.MEM_FILE=\"prog2.hex\" -o $(OUT_DIR)/prog2.vvp -s tb_top $(SRC)
	vvp $(OUT_DIR)/prog2.vvp
	@surfer $(VCD) > /dev/null 2>&1 &

run-fact: $(SRC)
	@mkdir -p $(OUT_DIR)
	$(IVERILOG) -P tb_top.MEM_FILE=\"fact.hex\" -o $(OUT_DIR)/fact.vvp -s tb_top $(SRC)
	vvp $(OUT_DIR)/fact.vvp
	@surfer $(VCD) > /dev/null 2>&1 &

# Individual Submodule Testbench Targets
run-imm: src/modules/ImmGen.v tb/tb_imm_gen.v
	@mkdir -p $(OUT_DIR)
	$(IVERILOG) -o $(OUT_DIR)/imm_gen.vvp -s tb_imm_gen src/modules/ImmGen.v tb/tb_imm_gen.v
	vvp $(OUT_DIR)/imm_gen.vvp
	@surfer $(VCD) > /dev/null 2>&1 &

run-alu: src/modules/ALU.v tb/tb_ALU.v
	@mkdir -p $(OUT_DIR)
	$(IVERILOG) -o $(OUT_DIR)/alu.vvp -s tb_ALU src/modules/ALU.v tb/tb_ALU.v
	vvp $(OUT_DIR)/alu.vvp
	@surfer $(VCD) > /dev/null 2>&1 &

run-ctrl: src/modules/ControlUnit.v tb/tb_control_unit.v
	@mkdir -p $(OUT_DIR)
	$(IVERILOG) -o $(OUT_DIR)/ctrl.vvp -s tb_control_unit src/modules/ControlUnit.v tb/tb_control_unit.v
	vvp $(OUT_DIR)/ctrl.vvp
	@surfer $(VCD) > /dev/null 2>&1 &

run-rf: src/modules/RegisterFile.v tb/tb_reg_file.v
	@mkdir -p $(OUT_DIR)
	$(IVERILOG) -o $(OUT_DIR)/rf.vvp -s tb_reg_file src/modules/RegisterFile.v tb/tb_reg_file.v
	vvp $(OUT_DIR)/rf.vvp
	@surfer $(VCD) > /dev/null 2>&1 &

run-rom: src/modules/InstructionMemory.v tb/tb_reg_rom.v
	@mkdir -p $(OUT_DIR)
	$(IVERILOG) -o $(OUT_DIR)/rom.vvp -s tb_reg_rom src/modules/InstructionMemory.v tb/tb_reg_rom.v
	vvp $(OUT_DIR)/rom.vvp
	@surfer $(VCD) > /dev/null 2>&1 &

run-ram: src/modules/DataMemory.v tb/IP/tb_ram.v
	@mkdir -p $(OUT_DIR)
	$(IVERILOG) -o $(OUT_DIR)/ram.vvp -s tb_ram src/modules/DataMemory.v tb/IP/tb_ram.v
	vvp $(OUT_DIR)/ram.vvp
	@surfer $(VCD) > /dev/null 2>&1 &

# Clean generated files
clean:
	@rm -rf $(OUT_DIR) $(VCD)

.PHONY: all run run-prog1 run-prog2 run-imm run-alu run-ctrl run-rf run-rom run-ram clean
