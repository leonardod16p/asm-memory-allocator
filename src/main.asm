%include "inc/macros.inc"
extern toNumber


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


section .matrizA read write
	numeroLinhasA: resq 1
	numeroColunasA: resq 1
    matriz1PtrInicio: resq 1
    matriz1PtrFim: resq 1

section .matrizB read write
	numeroLinhasB: resq 1
    numeroColunasB: resq 1
    matriz2PtrInicio: resq 1
    matriz2PtrFim: resq 1

section .text

global _start
_start:

    EXIT 