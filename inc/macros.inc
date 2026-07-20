%macro SYS_READ 3          ;;SYS_READ(file_descritor, endereco do buffer, tamanho do buffer)
    mov rax, 0
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

%macro SYS_WRITE 3          ;;SYS_WRITE(file_descritor, endereco do buffer, tamanho do buffer)
    mov rax, 1
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

%macro SYS_BRK 4
	mov	rax, 12                 ; brk sys_call convention 
    xor rdi, rdi				; Passa 0 como argumento brk(0) 
	push rcx			;;Vamos substituir por left shift
	push rdx
	syscall						; Retorna o endereco do program break
	mov [%1], rax     ;;Passando o endereco do primeiro elemento da matriz  		

	
	mov rcx, [%3]			;;Numero de linhas da matriz
	mov rdx, [%4]			;;Numero de colunas da matriz	
	
	imul rcx, rdx 
	
	shl rcx, %2				;;tamanho de cada elemento na matriz

	mov rdi, [%1]
	add rdi, rcx

	;;lea rdi, [%1+rcx]   ;;Alocando %2*%3*%4 bytes. O segundo argumento serve para passar o tipo de enderecamento. O terceiro e quarto servem sao as dimensoes da matriz
	mov rax, 12
	syscall
	pop rdx
	pop rcx
%endmacro

%macro EXIT 0
	mov rax, 60
	xor rdi, rdi
	syscall
%endmacro