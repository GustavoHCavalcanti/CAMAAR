# Sprint 2 — Implementação de Funcionalidades e Testes Automatizados
Integrantes:
  . Gabriel Caixeta Romero – 232036896
  . Gustavo Henrique Andrade Cavalcanti – 222034109
  . Vitor Amorim Mello – 231037048


Projeto:
CAMAAR – Sistema de Avaliação de Turmas da UnB


Objetivo da Sprint:
A Sprint 2 teve como objetivo implementar funcionalidades reais do sistema descritas no BDD da Sprint 1, garantindo:
  ✔ Execução lógica das regras de negócio
  ✔ Cobertura com testes RSpec (unitários e de integração simples)
  ✔ Organização do backlog em Kanban

link da sprint: https://github.com/GustavoHCavalcanti/CAMAAR/tree/sprint-2

Papéis da Equipe:
  . Scrum Master: Gustavo Henrique Andrade Cavalcanti
  . Product Owner: Gabriel Caixeta Romero


Backlog da Sprint 2:
Nesta sprint implementamos funcionalidades-chave do sistema, todas acompanhadas de testes e controladas no Kanban do GitHub Projects.


Funcionalidades Implementadas:

Gustavo
🔹 [Sistema de Login (#7)]
🔹 [Sistema de definição de senha (#8)]
🔹 [Redefinição de senha (#10)]
🔹 [Visualização de formulários pendentes (#12 / Issue 109)]
🔹 [Gerar relatório CSV do administrador (#4)]
🔹 [Template Manager – gerenciamento de templates (#11)]
➡️ Implementação envolvendo validações, filtros, persistência em memória e testes.

Gabriel
🔹 [Importação de dados SIGAA (#1)]
🔹 [Cadastro de usuários (#3)]
🔹 [Atualização incremental da base SIGAA (#108)]
🔹 [Sistema de respostas do formulário (#2)]
🔹 [Controle de acesso por departamento (#106)]
➡️ Foco em lógica condicional, modelos e consistência da base.

Vitor
🔹 [Listagem de formulários para relatórios (#110)]
🔹 [Visualização de templates e permissões (#111)]
🔹 [Criação do template e vinculação (#102/#112)]
🔹 [Criação de formulário (docentes/discentes) (#113)]
🔹 [Visualização de resultados de avaliação (#110 complementares)]
➡️ Foco em exibição, filtragem e regras de autorização.


Artefatos Entregues
✔ Código Ruby funcional na pasta lib/
✔ Testes unitários e comportamentais em spec/
✔ Projeto Kanban configurado com colunas: Backlog → Doing → Done → Accepted
✔ Movimentação automática das issues
✔ Relatório .txt com link repositório enviado


Política de Branching
Branch principal: main
Branch de desenvolvimento: sprint-2
Cada integrante implementou diretamente na branch sprint-2


Funcionalidades com Testes e Critérios de Aceite
Cada funcionalidade implementada possui:
✔ testes RSpec
✔ cenários felizes e tristes
✔ regras de negócio traduzidas no código


Resumo Técnico da Sprint
  . Desenvolvimento orientado por testes (TDD simplificado)
  . Modelagem mínima para suportar regras da sprint
  . Testes cobrindo fluxo completo de autenticação, permissões, criação, visualização e filtros
  . Design modular permitindo reaproveitamento
  . Refatorações periódicas conforme falhas detectadas nos testes


Pontuação (Velocity)
16 funcionalidades implementadas com testes
Total do backlog completado
➡️ Velocity final: 16 pontos entregues


Kanban
O controle do fluxo foi feito no GitHub Projects, utilizando:
✔ Backlog
✔ Doing
✔ Done
✔ Accepted
Todas as issues foram movimentadas automaticamente conforme commits e revisões.
link: https://github.com/users/GustavoHCavalcanti/projects/1/views/1


Dificuldades Encontradas
  . Conflitos iniciais com leitura dos testes por inconsistência de nome de classes
  . Ajustes na modelagem para alinhar com cenários BDD
  . Erros de sintaxe e interpretação de RSpec
  . Refatorar funcionalidades sem quebrar outras dependentes

Conclusão
A Sprint 2 atingiu seu objetivo principal:
➡️ transformar especificações BDD em código executável, testado e validado.