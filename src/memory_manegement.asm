default rel

global malloc
global free

extern pilhaPtrInicio
extern pilhaPtrFim
extern pilhaPtrInicioTopo 
extern pilhaPtrFimTopo 

%define MAX_ALLOCS 100
%define RECORD_BYTES 16
%define REC_USER_PTR 0
%define REC_OLD_BRK 8

section .bss
align 8
allocStack: resb MAX_ALLOCS * RECORD_BYTES
allocCount: resq 1

section .text

;;nossa alocacao de memomria deve responder a nossa estrutura de dados pilha
malloc: 

;;verificar o tamanho solicitado e ver se ainda tem espaco na tabela de registros
;;ver qual eh o break atual com brk(0)
;;preparar o endereco de retorno e o novo break, respeitando o alinhamento
;;guardar o antigo break antes de avancar
;;pedir p kernel mover o break 
;;confirmar que a chamada funcionou
;;guardar o registro e retornar rax
malloc:

    test rdi, rdi
    jz .null

    cmp qword [rel allocCount], MAX_ALLOCS
    jae .null

    mov r8, rdi                  ; guardar o tamanho pedido
    mov eax, 12                  ; syscall brk
    xor edi, edi                 ; brk(0): consultar o break atual
    syscall

    mov rsi, rax                 ; salvar o break antigo
    mov r9, rax                  ; começar a região nesse endereço

    add r9, 7
    and r9, -8                   ; alinhar o endereço a 8 bytes
    add r8, 7
    and r8, -8                   ; arredondar o tamanho a 8 bytes

    mov r10, r9
    add r10, r8                  ; novo break = início + tamanho
    mov eax, 12
    mov rdi, r10
    syscall                      ; pedir ao kernel para expandir o heap

    cmp rax, r10
    jne .null                    ; se o break não chegou ao pedido, falhou

    mov rcx, [rel allocCount]
    shl rcx, 4                   ; índice × 16 bytes por registro
    lea rdx, [rel allocStack]
    add rdx, rcx                 ; endereço do próximo registro

    mov [rdx + REC_USER_PTR], r9
    mov [rdx + REC_OLD_BRK], rsi
    inc qword [rel allocCount]

    mov rax, r9                   ; retornar o ponteiro
    ret

.null:
    xor eax, eax                  ; retornar NULL
    ret


free:

;;vou pegar o endereco do sysbrk, subtrair pelo endereco em pilhaPtrInicioTopo e fzr o brk descer
;; p endereco de pilhaPtrInicioTopo
;;tbm vou precisar atualizar a pilha. agora o inicio Topo
;;ALERTA parece q desse jeito eu perco a informacao quando eu for excluir
;; eu sei qual o tamanho eu teria q reduzir? eu defini como resq, certo?

    test rdi, rdi
    jz .done                     ; free(null) não faz nada

    mov rcx, [rel allocCount]
    test rcx, rcx
    jz .done                     ; não tem alocacoes ativas

    dec rcx                      ; indice do registro no topo
    shl rcx, 4                   ; indice x 16 bytes
    lea rdx, [rel allocStack]
    add rdx, rcx                 ; endereco do registro do topo

    cmp [rdx + REC_USER_PTR], rdi
    jne .done                    ; so aceita o ponteiro do topo

    mov rsi, [rdx + REC_OLD_BRK] ; recuperar o break anterior
    mov eax, 12
    mov rdi, rsi
    syscall                      ; pedir ao kernel para recuar o heap

    cmp rax, rsi
    jne .done                    ; se falhar manter o registro

    dec qword [rel allocCount]   ; retirar o registro do topo

.done:
    ret
