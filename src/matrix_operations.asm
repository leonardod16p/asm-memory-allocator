default rel

global sumMatrix
global multiplyMatrix

extern matriz1PtrInicio
extern matriz2PtrInicio
extern matriz1PtrFim
extern matriz2PtrFim
extern numeroColunasA
extern numeroColunasB

%define ACUMULADOR r12
%define i r13
%define k r15
%define j r14

section .text

;;Como eu coloco parametros para chamar a função?
sumMatrix:
    ;Vamos iterar nos enderecos de memoria e somar os valores
    ; Carregando os enderecos de memoria nos registradores
    ;Origem dos dados
    mov rsi, [matriz1PtrInicio]
    mov r8, [matriz2PtrInicio]

    ;;loop de somar
    ;;Condicao de parada tamanho da matriz
    xor rcx, rcx      ;;Counter
    
    .loop:
		
		;Destino dos dados - na propria matriz1
		lea rdi, [rsi+rcx*8]
		
		cmp [matriz1PtrFim], rdi 
        je .exit 

		mov rax, [rsi+rcx*8]
        mov r9, [r8+rcx*8]
    
		mov [rdi], rax
        add [rdi], r9

        inc rcx		
		jmp .loop

	.exit:

    ret

multiplyMatrix:
	xor r12, r12
	xor i, i
	xor j, j
	xor k, k

	while1:
		cmp i, 5
		je break
		while2:
			cmp j, 4 
			je while1
			
			mov rax, i
            mov r11, [numeroColunasB]
            mul r11             ;;i*numeroColunas
            add rax, j          ;;i*numeroColunasB + j
            ;;push rax
            mov r8, rax
	
			push r12
			lea r12, [matriz1PtrInicio]
			mov [r12+r8], ACUMULADOR
			pop r12

			xor ACUMULADOR, ACUMULADOR		;;sum = 0
			while3:
				cmp k, 3
				je acumular
				
				mov rax, i
				mov r10, [numeroColunasA]
				mul r10				;;i*numeroColunasA
				add rax, k			;;i*numeroColunasA + k
				;;push rax
				mov r8, rax		

				mov rax, k			;;rax = k
				mov r11, [numeroColunasB]	;;
				mul r11						;;k*numeroColunasB
				add rax, j					;;k*numeroColunasB + j
				mov r9, rax
				

				push r12
				push r13
				lea r12, [matriz1PtrInicio]
				lea r13, [matriz2PtrInicio]
				mov rax, [r12+r8]		
				mov rbx, [r13+r9]
				pop r13
				pop r12

				mul rbx					;;rax = a_ik*b_kj
				add ACUMULADOR, rax		;;ACUMULADOR += a_ik*b_kj	
				inc k
			
				jmp while3
			
		acumular:
			mov rax, i
           	mov r11, [numeroColunasB]
           	mul r11             ;;i*numeroColunas
           	add rax, j          ;;i*numeroColunasB + j
           	;;push rax
           	mov r8, rax
			
			push r12
			lea r12, [matriz1PtrInicio]
			mov [r12+r8], ACUMULADOR
			jmp while2
	break:
		ret