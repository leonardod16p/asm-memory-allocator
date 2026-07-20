ASM = nasm
ASM_FLAGS = -f elf64
LD = ld

all: bin/memory_allocator

bin/memory_allocator: obj/main.o 
	$(LD) -o bin/memory_allocator obj/main.o

obj/%.o: src/%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

clean:
	rm -f obj/*.o bin/memory_allocator