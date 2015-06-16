# A list of all the verilog modules to be included in the build
MODULES = $(patsubst %.v,%,$(wildcard *.v))

LIBDIR ?= .
SIMDIR ?= sim

VPATH = $(LIBDIR) $(SIMDIR)

# Overridable if any of these tools are not in PATH
GTKWAVE  ?= gtkwave
IVERILOG ?= iverilog
VVP 	 ?= vvp

# Preserve some intermediate files made by implicit rules
.SECONDARY: $(MODULES:%=$(SIMDIR)/%.vvp)

# Declare phony targets
.PHONY: all test clean $(MODULES) $(MODULES:%=%-waveform)

# Rules
all: cpu

test: $(MODULES)

$(MODULES): %: $(SIMDIR)/%.vcd

$(MODULES:%=%-waveform): %-waveform: %.vcd
	$(GTKWAVE) $< $(wildcard $(patsubst %-waveform,$(SIMDIR)/%.gtkw,$@)) > /dev/null 2>&1 &

clean:
	-$(RM) $(MODULES:%=$(SIMDIR)/%.vcd) $(MODULES:%=$(SIMDIR)/%.vvp)

%.vcd: %.vvp
	@echo
	cd $(dir $<) && $(VVP) $(notdir $<)
	@echo

%.vvp: %_tb.v $(MODULES:%=%.v)
	$(IVERILOG) -Wall -t vvp -I$(LIBDIR) -o $@ $^

