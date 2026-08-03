default rel

%include "inc/macros.inc"

global creatingMatrix

extern inputBuffer
extern tamanhoBuffer
extern byteConverted

extern toNumber

%define i r13

creatingMatrix:

	;;pop rcx   ;;ponteiro para o inicio
	;;pop rdx	;;ponteiro para o fim

	.loop:
		lea rdi, [rcx+i*8]
		cmp rdi, rdx
    	jz .exit

		push rcx 	;;ponteiro para o inicio
		push rdx	;;ponteiro para o fim
		push rdi

		SYS_READ 0, inputBuffer, 10

		pop rdi
		pop rdx ;;ponteiro para o fim
		pop rcx	;;ponteiro para o inicio

    	mov [tamanhoBuffer], rax                ;;SYS_READ retorna a quantidade de caracteres efetivamente lidos

    	

    	;;nao ta atualizando o endereco

		push rcx 	;;ponteiro para o inicio
		push rdx	;;ponteiro para o fim
		push rdi 	;;salva endereco do elemento da matriz

		mov byte [byteConverted], 0			;;Zerando o valor em byteConverted

    	call toNumber

		pop rdi
		pop rdx ;;ponteiro para o fim
		pop rcx	;;ponteiro para o inicio

		mov rax, [byteConverted]
		mov [rdi], rax
		
		;;Temos quad word para cada elemento. Devemos incrementar 8 bytes

		inc i
		;;Checka se o endereco percorrido eh igual ao endereco final da matriz
    	jmp .loop
	
	.exit:

	ret
