# Overridable if any of these tools are not in PATH
GTKWAVE  ?= gtkwave
IVERILOG ?= iverilog
VVP 	 ?= vvp
HEXDUMP  ?= hexdump

CROSS_COMPILE ?= mips64-linux-gnu-
AS            := $(CROSS_COMPILE)as
OBJCOPY       := $(CROSS_COMPILE)objcopy

TOPDIR ?= ..
SRCDIR ?= $(TOPDIR)/src
SIMDIR ?= $(TOPDIR)/sim

MODULES = $(wildcard $(SRCDIR)/*.v)
BENCHES = $(wildcard *_tb.v)

VPATH = $(SRCDIR) $(SIMDIR)

all: $(BENCHES:%.v=%)

test: $(BENCHES:%.v=%-test)

$(BENCHES:%.v=%): %: %.vcd

$(BENCHES:%.v=%-test): %-test: %.vvp
	$(VVP) -N $< -none

wave: cpu_tb.vcd
	$(GTKWAVE) $< $(wildcard $(patsubst %.vcd,%.gtkw,$<)) > /dev/null 2>&1 &

clean:
	-$(RM) $(BENCHES:%.v=%.vvp) $(BENCHES:%.v=%.vcd) $(BENCHES:%.v=%.txt)

cpu_tb.vvp cpu_tb.fst: IVERILOG_FLAGS = -Pcpu_tb.MEM_INIT_FILE=\"$(abspath $(SIMDIR)/cpu_tb.txt)\" \
    					-Pcpu_tb.VAR_DUMP_FILE=\"$(abspath $(SIMDIR)/cpu_tb.vcd)\"

%.vcd: %.vvp %.txt
	$(VVP) -n $< -vcd

%.fst: %.vvp %.txt
	$(VVP) -n $< -fst

%.vvp: %.v $(MODULES)
	$(IVERILOG) $(IVERILOG_FLAGS) -Wall -y $(SRCDIR) -t vvp -I$(SRCDIR) -o $@ $<

%.elf: %.s
	$(AS) -EB -mabi=32 -march=mips1 -o $@ $<

%.bin: %.elf
	$(OBJCOPY) -O binary -j .text $< $@

%.txt: %.bin
	$(HEXDUMP) -v -e '4/1 "%.2X" "\n"' $< > $@

%.hex: %.elf
	$(OBJCOPY) -O verilog -j .text $< $@

.SECONDARY: $(BENCHES:%.v=%.txt)

.PHONY: all test $(BENCHES:%.v=%) $(BENCHES:%.v=%-test) wave clean
