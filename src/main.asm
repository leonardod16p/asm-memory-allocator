default rel

%include "inc/macros.inc"
extern toNumber
extern toString

extern sumMatrix
extern multiplyMatrix
extern creatingMatrix


global tamanhoBuffer
global inputBuffer
global byteConverted
global printableMatrixSum

global matriz1PtrInicio
global matriz2PtrInicio
global matriz1PtrFim
global matriz2PtrFim
global numeroColunasA
global numeroColunasB


%define i r13


section .data
	msgNumeroLinhasColunasA: db `Digite o numero de linhas e o numero de colunas da primeira matriz \n`
	msgSize1 equ $-msgNumeroLinhasColunasA
	msgNumeroLinhasColunasB: db `Digite o numero de linhas e o numero de colunas da segunda matriz \n`
	msgSize2 equ $-msgNumeroLinhasColunasB

    pedeOperacao: db `Escolha a operacao que deseja performar (+) ou (*):\n`
	msgSize3 equ $-pedeOperacao

    pedeElementos: db `Insira elemento por elemento: \n`
    msgSize equ $-pedeElementos

section .bss 
	inputBuffer: resb 10
	tamanhoBuffer: resb 1
	operacaoEscolhida: resb 2
    printableMatrixSum: resb 200
    byteConverted: resb 1
	variableAddress: resq 1


section .matrizA bss read write
	numeroLinhasA: resq 1
	numeroColunasA: resq 1
    matriz1PtrInicio: resq 1
    matriz1PtrFim: resq 1

section .matrizB bss read write
	numeroLinhasB: resq 1
    numeroColunasB: resq 1
    matriz2PtrInicio: resq 1
    matriz2PtrFim: resq 1

section .pilha bss read write
	;;a pilha eh uma estrutura simples que permite operacao de push e pop
	;;problema: se eu alocar 8 bytes
	pilhaPtrInicio: resq 1
	pilhaPtrFim: resq 1
	;; tem que ser um endereco entre inicio e fim da pilha
	pilhaPtrInicioTopo: resq 1 ;; inicio do ultimo dado alocado
	pilhaPtrFimTopo: resq 1 ;; fim do ultimo dado alocado
	;;monitorar mais o que?
	

section .text

global _start
_start:
    
    ;;MATRIZ A
	
	SYS_WRITE 1, msgNumeroLinhasColunasA, msgSize1		;;Chamada de sistemas que printa na tela 
	SYS_READ 0, inputBuffer, 2							;;chamada de sistema que le input do usuario e armazena em inputbuffer. retorna o tamanho da string inserida
	mov [tamanhoBuffer], al								;;instrucao que pega o valor de retorno da chamada anterior (tamanho da string) e armazena no endereco de memoria tamanho buffer
	mov al, byte [inputBuffer]							;;vai pegar o valor no endereco inputBuffer e armazena no segmento de registrador al
	;;rax 64 ;; eax 32 ;; ax 16 ;; ah primeiros 8 bits + al segundos 8bits 
	xor rcx, rcx						;;zera rcx
	call toNumber					;;Input vem na codificacao ASCII ;; chamada de sistema que converte para hexadecimal. ;; codigo ascii -> hexadecimal ;;
	mov [numeroLinhasA], al
	SYS_WRITE 1, numeroLinhasA, 1
	
    ;;pq eu faco a msm mensagem duas vezes?

	SYS_WRITE 1, msgNumeroLinhasColunasA, msgSize1
	SYS_READ 0, inputBuffer, 2
	mov [tamanhoBuffer], al
	mov al, byte [inputBuffer]
	mov rcx, 0
	call toNumber
	mov [numeroColunasA], al
	SYS_WRITE 1, numeroColunasA, 1

	;;MATRIZ B

	SYS_WRITE 1, msgNumeroLinhasColunasB, msgSize2
    SYS_READ 0, inputBuffer, 2
	mov [tamanhoBuffer], al
    mov al, byte [inputBuffer]
    mov rcx, 0
	call toNumber
	mov [numeroLinhasB], al
    SYS_WRITE 1, numeroLinhasB, 1
    
	SYS_WRITE 1, msgNumeroLinhasColunasB, msgSize2
    SYS_READ 0, inputBuffer, 2
    mov [tamanhoBuffer], al
	mov al, byte [inputBuffer]
    mov rcx, 0 
	call toNumber
	mov [numeroColunasB], al
    SYS_WRITE 1, numeroColunasB, 1

    ;;------------------------------------------------------------------------------------------------------------------------------------------------
    ;;------------------------------------------------------------------------------------------------------------------------------------------------


    ;;Alocando memoria para matriz A
    mov rcx, numeroLinhasA
	mov rdx, numeroColunasA
	SYS_BRK matriz1PtrInicio, 3, numeroLinhasA, numeroColunasA				;;6 eh o numero de bits deslocados. Com isso, teremos espaco de 2^6 = 64 bytes para cada elementos da matriz
	;;salvando o endereco do ultimo elemento da matriz
	mov [matriz1PtrFim], rax


	mov rcx, numeroLinhasB
    mov rdx, numeroColunasB
	;;Alocando memoria para matriz B
    SYS_BRK matriz2PtrInicio, 3, numeroLinhasB, numeroColunasB
	;;salvando o endereco do ultimo elemento da matriz
	mov [matriz2PtrFim], rax


    ;;-----Vamos inserir os elementos na matriz--------------------------------------------------------------------
    ;;--------------------------------------------------------------------------------------------------------------

	lea rax, [matriz1PtrInicio]			;;Em matriz1Ptr temos um ponteiro. Primeiro carregamos esse endereco em rax
	mov rax, [rax]						;;Carregamos o valor no endereco apontado por esse ponteiro em rax
	push rax

	
	
	SYS_WRITE 1, pedeElementos, msgSize
	
	xor i, i

	;;--MATRIZ-A--------
	mov rcx, [matriz1PtrInicio]
	mov rdx, [matriz1PtrFim] 
	;;push rcx
	;;push rdx

	call creatingMatrix

	xor i, i

	;;--MATRIZ-B--------

    mov rcx, [matriz2PtrInicio]
    mov rdx, [matriz2PtrFim]
    ;;push rcx
    ;;push rdx

    call creatingMatrix




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;-;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    ;;-----Qual operacao ira realizar nas matrizes?----------------------------------------------------------------
    ;;--------------------------------------------------------------------------------------------------------------
    SYS_WRITE 1, pedeOperacao, msgSize3
	
	SYS_READ 0, operacaoEscolhida, 2

	operations:
		
		cmp byte [operacaoEscolhida], 0x2B			;;+ ascii
		jnz .notSum
		call sumMatrix
		.notSum:
		
		cmp byte [operacaoEscolhida], 0x2A			;;* ascii
		jnz .notMultiply
		call multiplyMatrix
		.notMultiply:

    conversao:
		call toString      

	print:
		SYS_WRITE 1, printableMatrixSum, 200

    EXIT 