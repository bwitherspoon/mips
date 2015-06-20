ASMDIR ?= asm
SIMDIR ?= sim

SUBDIRS = $(ASMDIR) $(SIMDIR)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

test:
	$(MAKE) -C $(SIMDIR) $@

clean:
	$(MAKE) -C $(SIMDIR) $@
	$(MAKE) -C $(ASMDIR) $@

.PHONY: all $(SUBDIRS) test clean
