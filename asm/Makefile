CROSS_COMPILE = mips64-linux-gnu-
AS            = $(CROSS_COMPILE)as
OBJCOPY       = $(CROSS_COMPILE)objcopy
HEXDUMP       = hexdump

all: firmware.hex

%.elf: %.s
	$(AS) -EB -mabi=32 -march=mips1 -o $@ $<

%.bin: %.elf
	$(OBJCOPY) -O binary -j .text $< $@

%.hex: %.bin
	$(HEXDUMP) -v -e '4/1 "%.2X" "\n"' $< > $@

#%.hex: %.elf
#	$(OBJCOPY) -O verilog -j .text $< $@

clean:
	-$(RM) firmware.hex firmware.elf firmware.bin

.PHONY: all clean
