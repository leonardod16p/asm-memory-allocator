default rel

global toNumber
global toString

extern tamanhoBuffer
extern inputBuffer
extern byteConverted
extern printableMatrixSum
extern matriz1PtrInicio
extern matriz1PtrFim


section .text

toNumber:

	;;Condicao de parada = enquanto tamanho for maior ou igual a zero
	;;"numeroFormatoString"
	;;aponta pro final da string (ultimo byte)
	;;subtrai '0'
	;;empilha
	mov rcx, [tamanhoBuffer] 		;;Retorna o que eu digitei + o enter
	dec rcx ;;vamos subtrair o enter
	dec rcx ;;vamos usar o tamanho como indice. comecamos em zero 
	mov rsi, inputBuffer			
    add rsi, rcx						;;Apontando pro final do buffer
	mov al, [rsi]						;;Passando o valor no endereco de rsi para rax
	mov rdi, byteConverted				;;Passando o endereco final do numero convertido

	mov rbx, 10                     ;;Valor de multiplicacao definido
    
	xor r8, r8
    xor r9, r9
	.converterLoop:
        
        sub al, '0'         ;;Converte para ascii
       
        push rax    ;;Empilhando os algorismos para ordena-los
        inc r8      ;;Contando o numero de empilhamentos
        		    ;;armazena em byteConverted printableMatrixSu

		cmp rcx, 0
        je .desempilhar
        dec rsi
        dec rcx
		mov al, [rsi] ;;rsi aponta pro final do buffer - 1
		jmp .converterLoop
			
	.desempilhar:
		mov r10, r8				;;Salvando a potencia	
		dec r10                     ;;Quantas vezes iremos multiplicar rax por 10?

        pop rax                  ;;Vamos desempilhar os valores na pilha em r9
        xor r11, r11
	
        cmp r11, r10
        je .notElevate			;;Seleciona se 
						

		.elevar:
		;;Como eu nao executo a primeira multiplicacao
			mul rbx					;;rax = rax*10^(r8-1)
			inc r11
			cmp r11, r10
			jne .elevar
		;;.naoElevar:

	
	.notElevate:
		;;pop rcx
		;;cmp rcx, 0
		;;je .exit

		add [rdi], rax
		dec r8					;;Decrementa o contador de valores empilhados

		cmp r8, 0               ;;0 - r8
        jne .desempilhar

        inc rcx
	.exit:
		ret


;;Serve para matrizes com elementos entre 0 e 2^64 incluso
;;Devemos estabeler um intervalo de elementos printaveis e cobrir os casos
;;Por exemplo, se tivermos um elemento com 3 algarismo deveremos arrumar uma forma de carregar cada algarismo em 1 byte 
;;Fazemos isso pegando o numero e divindo por 10. O resto da divisao vai para rdx. Pegamos esse valor e somamos '0' para termos o valor ascii correspondente.  
toString:
	;;PARAMETROS DA FUNCAO toString()



    mov rsi, [matriz1PtrInicio]
    mov r11, [matriz1PtrFim]
	mov rdi, printableMatrixSum  
    mov rbx, 10                     ;;Valor de divisao definido
	
    xor rcx, rcx
    xor r8, r8
	xor r9, r9
	xor r10, r10			;;percorre os enderecos dos elementos da matriz
	
	lea r10, [rsi+rcx*8]
	
	.loadNumber:
	mov rax, [r10]			;;carregamos o valor em rsi+rcx*8 ;;rax = 12

    .converterLoop:
        xor rdx, rdx
		div rbx             ;;Dividindo o valor por 10, jogando o quociente em rax e o resto em rdx. ex: rax = 10 e rdx = 2 
		add dl, '0'         ;;Converte para ascii				rdx = 0x32 
        push rdx			;;Empilhando os algorismos para ordena-los	push 0x32
		inc r8				;;Contando o numero de empilhamentos		;;empilhei um	 
        cmp rax, 0
        jne .converterLoop


	.desempilhar:
		pop r9					;;Vamos desempilhar os valores na pilha em r9
		mov [rdi], r9			;;Pega o valor em r9 e taca no endereco da matrizPrintavel 
		inc rdi					;;incrementa o addr em 1
		dec r8					;;Decrementa o contador de valores empilhados
		cmp r8, 0				;;0 - r8
		jne .desempilhar

		mov byte [rdi], 20h			;;adiciona um espaco em branco para formatacao do print
		inc rdi

		inc rcx
        lea r10, [rsi+rcx*8]	;;Temos quad word para cada elemento. Devemos incrementar 8 bytes
        cmp r11, r10			;;verifica se o endereco atual eh o mesmo que 
		jne .loadNumber

    ret
