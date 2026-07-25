# Alocador Dinâmico de Memória para Matrizes (Assembly x86_64)

> Work in Progress: This project is currently under active development

Projeto de implementação de um alocador de memória manual utilizando a syscall brk em ambiente Linux. 
O objetivo principal foi explorar a arquitetura x86_64 e entender como o sistema operacional gerencia a heap e o endereçamento de memória em baixo nível. 
Em vez de focar apenas no código final, priorizei a documentação do processo mental envolvido no desenvolvimento do código: cada trecho do código contém comentários detalhados que mapeiam a lógica de manipulação de registradores e o controle de fluxo. 
Este projeto serviu para consolidar minha base em sistemas operacionais e organização de computadores.

## Macros e Funções

Para viabilizar a manipulação das matrizes e a interação com o sistema, o projeto foi estruturado em macros e funções modulares, detalhadas abaixo:

### Macros (Syscalls)

As macros foram utilizadas para abstrair as chamadas de sistema (syscalls) do Linux:

- SYS_READ: Interface para a syscall read (rax 0). Gerencia a entrada de dados do usuário via teclado (stdin).

- SYS_WRITE: Interface para a syscall write (rax 1). Responsável pela exibição de mensagens e dos resultados no terminal (stdout).

- SYS_BRK: Esta macro utiliza a syscall brk (rax 12) para manipular o program break. Ela calcula o espaço necessário (linhas×colunas×tamanho_do_elemento) e expande a heap dinamicamente para alocar as matrizes.

### Funções Principais

O controle de fluxo é dividido em sub-rotinas específicas para processamento de dados:

- creatingMatrix: Itera sobre o espaço de memória alocado pela SYS_BRK, capturando o input do usuário e preenchendo cada posição da matriz.
- toNumber: Converte strings ASCII lidas do buffer em valores numéricos inteiros.
- sumMatrix: Realiza a soma aritmética elemento a elemento de duas matrizes, armazenando o resultado no espaço de memória da primeira matriz.
- multiplyMatrix: Implementa a lógica de multiplicação de matrizes através de loops aninhados e cálculos de offset de memória.
- toString: Realiza o processo inverso da toNumber, convertendo os resultados numéricos de volta para caracteres ASCII para que possam ser impressos no terminal.

## Debugging 

Gosto de depurar o binário do programa usando ferramentas de engenharia reversa. Elas facilitam o acompanhamento do fluxo de execução e o monitoramento dos valores na memória.  