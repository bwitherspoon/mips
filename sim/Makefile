# Overridable if any of these tools are not in PATH
GTKWAVE  ?= gtkwave
IVERILOG ?= iverilog
VVP 	 ?= vvp

TOPDIR ?= ..
ASMDIR ?= $(TOPDIR)/asm
SRCDIR ?= $(TOPDIR)/src
SIMDIR ?= $(TOPDIR)/sim

MODULES = $(wildcard $(SRCDIR)/*.v)
BENCHES = $(wildcard *_tb.v)

VPATH = $(SRCDIR) $(SIMDIR)

all: $(BENCHES:%.v=%.vvp)

test: $(BENCHES:%.v=%-test)

$(BENCHES:%.v=%-test): %-test: %.vvp
	$(VVP) -N $< -none

wave: cpu_tb.vcd
	$(GTKWAVE) $< $(wildcard $(patsubst %.vcd,%.gtkw,$<)) > /dev/null 2>&1 &

clean:
	-$(RM) $(BENCHES:%.v=%.vcd) $(BENCHES:%.v=%.vvp)

cpu_tb.vvp cpu_tb.fst: IVERILOG_FLAGS = -Pcpu_tb.MEM_INIT_FILE=\"$(abspath $(ASMDIR)/firmware.hex)\" \
    					-Pcpu_tb.VAR_DUMP_FILE=\"$(abspath $(SIMDIR)/cpu_tb.vcd)\"

%.vcd: %.vvp
	$(VVP) -n $< -vcd

%.fst: %.vvp
	$(VVP) -n $< -fst

%.vvp: %.v $(MODULES)
	$(IVERILOG) $(IVERILOG_FLAGS) -Wall -t vvp -I$(SRCDIR) -o $@ $^

.PHONY: all test $(BENCHES:%.v=%-test) wave clean
