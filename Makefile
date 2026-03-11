RISCV_GCC = riscv32-unknown-elf-gcc
RISCV_OBJCOPY = riscv32-unknown-elf-objcopy
RISCV_OBJDUMP = riscv32-unknown-elf-objdump

CFLAGS = -march=rv32i -mabi=ilp32 -nostdlib -ffreestanding -O2

all: firmware.hex

firmware.elf: start.S main.c
	$(RISCV_GCC) $(CFLAGS) -T linker.ld start.S main.c -o firmware.elf

firmware.hex: firmware.elf
	$(RISCV_OBJCOPY) -O verilog firmware.elf firmware.hex

dump:
	$(RISCV_OBJDUMP) -d firmware.elf

clean:
	rm -f *.elf *.hex