# Makefile

SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES = sandbox.sv

# enable waveform dumping
WAVES = 1

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = sandbox

# MODULE is the basename of the Python test file
MODULE = test_sandbox

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# make clean
clean::
	$(RM) -r __pycache__
	$(RM) results.xml
