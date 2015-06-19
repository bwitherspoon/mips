CROSS_COMPILE = mips64-linux-gnu-
AS            = $(CROSS_COMPILE)as
OBJCOPY       = $(CROSS_COMPILE)objcopy
HEXDUMP       = hexdump

all: firmware.hex

%.elf: %.s
	$(AS) -EB -mabi=32 -march=mips1 -o $@ $<

%.hex: %.elf
	$(OBJCOPY) -O verilog -j .text $< $@

clean:
	-$(RM) *.hex *.elf

.PHONY: all clean
