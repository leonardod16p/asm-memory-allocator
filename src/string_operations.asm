global toNumber
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