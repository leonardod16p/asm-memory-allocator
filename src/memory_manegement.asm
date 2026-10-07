default rel

global malloc
global free

extern pilhaPtrInicio
extern pilhaPtrFim
extern pilhaPtrInicioTopo 
extern pilhaPtrFimTopo 

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

free:

;;vou pegar o endereco do sysbrk, subtrair pelo endereco em pilhaPtrInicioTopo e fzr o brk descer
;; p endereco de pilhaPtrInicioTopo
;;tbm vou precisar atualizar a pilha. agora o inicio Topo
;;ALERTA parece q desse jeito eu perco a informacao quando eu for excluir
;; eu sei qual o tamanho eu teria q reduzir? eu defini como resq, certo?