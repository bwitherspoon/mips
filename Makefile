# A list of all the verilog modules to be included in the build
MODULES = $(basename $(notdir $(wildcard $(SRCDIR)/*.v)))

ASMDIR ?= asm
SRCDIR ?= src
SIMDIR ?= sim

VPATH = $(SRCDIR) $(SIMDIR) $(ASMDIR)

# Overridable if any of these tools are not in PATH
GTKWAVE  ?= gtkwave
IVERILOG ?= iverilog
VVP 	 ?= vvp

# Preserve some intermediate files made by implicit rules
.SECONDARY: $(MODULES:%=$(SIMDIR)/%.vvp)

# Rules
test: cpu.vcd

all: $(MODULES)

$(MODULES): %: $(SIMDIR)/%.vcd

wave: cpu.vcd
	$(GTKWAVE) $< $(wildcard $(patsubst %.vcd,%.gtkw,$<)) > /dev/null 2>&1 &

clean:
	-$(RM) $(MODULES:%=$(SIMDIR)/%.vcd) $(MODULES:%=$(SIMDIR)/%.vvp)

%.vcd: %.vvp
	@echo
	$(VVP) $<
	@echo

%.vvp: %_tb.v $(MODULES:%=%.v)
	$(IVERILOG) -Wall -t vvp -I$(SRCDIR) -o $@ $^

.PHONY: all test clean wave $(MODULES)
