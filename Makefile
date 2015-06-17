# A list of all the verilog modules to be included in the build
MODULES = $(basename $(notdir $(wildcard $(SRCDIR)/*.v)))

SRCDIR ?= src
SIMDIR ?= sim

VPATH = $(SRCDIR) $(SIMDIR)

# Overridable if any of these tools are not in PATH
GTKWAVE  ?= gtkwave
IVERILOG ?= iverilog
VVP 	 ?= vvp

# Preserve some intermediate files made by implicit rules
.SECONDARY: $(MODULES:%=$(SIMDIR)/%.vvp)

# Rules
all: cpu

test: $(MODULES)

$(MODULES): %: $(SIMDIR)/%.vcd

clean:
	-$(RM) $(MODULES:%=$(SIMDIR)/%.vcd) $(MODULES:%=$(SIMDIR)/%.vvp)

%.vcd: %.vvp
	@echo
	cd $(dir $<) && $(VVP) $(notdir $<)
	@echo

%.vvp: %_tb.v $(MODULES:%=%.v)
	$(IVERILOG) -Wall -t vvp -I$(SRCDIR) -o $@ $^

.PHONY: all test clean $(MODULES)
