# Sprint 1 — Especificação de Testes de Aceitação (BDD)

## Integrantes
- Gabriel Caixeta Romero – 232036896  
- Gustavo Henrique Andrade Cavalcanti – 222034109  
- Vitor Amorim Mello – 231037048  

## Projeto
CAMAAR – Sistema de Avaliação de Turmas da UnB

## Escopo do Projeto
O CAMAAR é um sistema para avaliação institucional de turmas, permitindo que administradores gerenciem turmas, formulários e dados do SIGAA, enquanto participantes respondem formulários vinculados às turmas em que estão matriculados. O sistema também possibilita geração de relatórios e controle por departamento.

---

## Papéis da Equipe na Sprint
- **Scrum Master:** Gabriel Caixeta Romero  
- **Product Owner:** Gustavo Henrique Andrade Cavalcanti  

---

## Objetivo da Sprint
A Sprint 1 teve como objetivo especificar todos os cenários de teste de aceitação (BDD) do projeto utilizando a linguagem Gherkin.  
A sprint concentrou-se exclusivamente na documentação comportamental, sem implementação funcional.

---

## Funcionalidades e Regras de Negócio

### Autenticação e Acesso
- Login por e-mail ou matrícula.
- Definição e redefinição de senha via link seguro.
- Administradores visualizam menus adicionais.

### Integração com SIGAA
- Importação de turmas, docentes e discentes via JSON.
- Atualização incremental da base, evitando duplicidades.
- Cadastro automático de usuários importados.

### Formulários
- Participantes visualizam e respondem formulários pendentes.
- Administradores criam templates, podem editá-los e excluí-los.
- Formularios podem ser criados para discentes e docentes.

### Relatórios
- Visualização agregada das respostas.
- Exportação de relatórios em CSV.

### Departamentos
- Administradores só gerenciam turmas de seu próprio departamento.

---

## Responsáveis por Cada Funcionalidade

### Gustavo — Issues #98 a #103
- [#98 Importar dados do SIGAA](https://github.com/GustavoHCavalcanti/CAMAAR/issues/98)  
- [#99 Responder formulário](https://github.com/GustavoHCavalcanti/CAMAAR/issues/99)  
- [#100 Cadastrar usuários](https://github.com/GustavoHCavalcanti/CAMAAR/issues/100)  
- [#101 Gerar relatório (CSV)](https://github.com/GustavoHCavalcanti/CAMAAR/issues/101)  
- [#102 Criar template de formulário](https://github.com/GustavoHCavalcanti/CAMAAR/issues/102)  
- [#103 Criar formulário de avaliação](https://github.com/GustavoHCavalcanti/CAMAAR/issues/103)  

### Gabriel — Issues #104 a #109
- [#104 Login](https://github.com/GustavoHCavalcanti/CAMAAR/issues/104)  
- [#105 Definição de senha](https://github.com/GustavoHCavalcanti/CAMAAR/issues/105)  
- [#106 Gerenciamento por departamento](https://github.com/GustavoHCavalcanti/CAMAAR/issues/106)  
- [#107 Redefinição de senha](https://github.com/GustavoHCavalcanti/CAMAAR/issues/107)  
- [#108 Atualizar base com dados do SIGAA](https://github.com/GustavoHCavalcanti/CAMAAR/issues/108)  
- [#109 Visualizar formulários para responder](https://github.com/GustavoHCavalcanti/CAMAAR/issues/109)  

### Vitor — Issues #110 a #113
- [#110 Visualização de resultados dos formulários](https://github.com/GustavoHCavalcanti/CAMAAR/issues/110)  
- [#111 Visualização dos templates criados](https://github.com/GustavoHCavalcanti/CAMAAR/issues/111)  
- [#112 Edição e deleção de templates](https://github.com/GustavoHCavalcanti/CAMAAR/issues/112)  
- [#113 Criação de formulário para docentes ou dicentes](https://github.com/GustavoHCavalcanti/CAMAAR/issues/113)  

---

## Política de Branching Utilizada Pelo Grupo
A política adotada foi a seguinte:

- Branch principal: `main`  
- Branch da sprint: `sprint-1`  
- Cada integrante adicionava seus arquivos `.feature` diretamente à branch `sprint-1`  
- Sem criação de branches individuais por funcionalidade  
- Ao final, um Pull Request consolidou a sprint no repositório principal  

---

## Backlog da Sprint 1 (Todas Concluídas)

| ID   | História                                      | Tipo          | Status            |
|------|-----------------------------------------------|---------------|-------------------|
| [#98](https://github.com/GustavoHCavalcanti/CAMAAR/issues/98)  | Importar dados do SIGAA                       | Administrador | Concluída (BDD) |
| [#99](https://github.com/GustavoHCavalcanti/CAMAAR/issues/99)  | Responder formulário                          | Participante  | Concluída (BDD) |
| [#100](https://github.com/GustavoHCavalcanti/CAMAAR/issues/100) | Cadastrar usuários do sistema                 | Administrador | Concluída (BDD) |
| [#101](https://github.com/GustavoHCavalcanti/CAMAAR/issues/101) | Gerar relatório (CSV)                         | Administrador | Concluída (BDD) |
| [#102](https://github.com/GustavoHCavalcanti/CAMAAR/issues/102) | Criar template de formulário                  | Administrador | Concluída (BDD) |
| [#103](https://github.com/GustavoHCavalcanti/CAMAAR/issues/103) | Criar formulário de avaliação                 | Administrador | Concluída (BDD) |
| [#104](https://github.com/GustavoHCavalcanti/CAMAAR/issues/104) | Login                                         | Usuário       | Concluída (BDD) |
| [#105](https://github.com/GustavoHCavalcanti/CAMAAR/issues/105) | Definição de senha                            | Usuário       | Concluída (BDD) |
| [#106](https://github.com/GustavoHCavalcanti/CAMAAR/issues/106) | Gerenciamento de turmas por departamento      | Administrador | Concluída (BDD) |
| [#107](https://github.com/GustavoHCavalcanti/CAMAAR/issues/107) | Redefinição de senha                          | Usuário       | Concluída (BDD) |
| [#108](https://github.com/GustavoHCavalcanti/CAMAAR/issues/108) | Atualizar base com dados do SIGAA             | Administrador | Concluída (BDD) |
| [#109](https://github.com/GustavoHCavalcanti/CAMAAR/issues/109) | Visualizar formulários para responder         | Participante  | Concluída (BDD) |
| [#110](https://github.com/GustavoHCavalcanti/CAMAAR/issues/110) | Visualização de resultados dos formulários    | Administrador | Concluída (BDD) |
| [#111](https://github.com/GustavoHCavalcanti/CAMAAR/issues/111) | Visualização dos templates criados            | Administrador | Concluída (BDD) |
| [#112](https://github.com/GustavoHCavalcanti/CAMAAR/issues/112) | Edição e deleção de templates                 | Administrador | Concluída (BDD) |
| [#113](https://github.com/GustavoHCavalcanti/CAMAAR/issues/113) | Criar formulário para docentes ou dicentes    | Administrador | Concluída (BDD) |

---

## Pontuação (Velocity)
Cada história recebeu **1 ponto**.  
Total da Sprint 1: **16 pontos entregues**.

---

## Artefatos Entregues
- Todos os 16 arquivos `.feature` concluídos.  
- Pull Request consolidando a sprint.  
- Arquivo `.txt` entregue com dados do grupo e link para o repositório.  

---

## Resumo Técnico da Sprint
- Todas as regras de negócio foram traduzidas para cenários BDD claros e verificáveis.  
- Cenários completos incluem fluxos felizes e casos de erro.  
- Estrutura padronizada (Given/When/Then).  
- Divisão de responsabilidades mantida conforme as issues da sprint.  

---

## Dificuldades Encontradas
- Nivelamento da granularidade entre membros.  
- Interpretação de regras implícitas nas issues.  
- Padronização dos arquivos `.feature`.  

---

## Conclusão
A Sprint 1 cumpriu integralmente seu objetivo, entregando a especificação comportamental completa do sistema.  
A equipe encontra-se preparada para iniciar a etapa de implementação com base sólida de critérios de aceite.