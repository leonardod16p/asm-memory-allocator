%include "inc/macros.inc"
extern toNumber

extern sumMatrix
extern multiplyMatrix


global tamanhoBuffer
global inputBuffer
global byteConverted

global matriz1PtrInicio
global matriz2PtrInicio
global matriz1PtrFim
global matriz2PtrFim
global numeroColunasA
global numeroColunasB

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

    EXIT 