# Sprint 1 — Especificação de Testes de Aceitação (BDD)

## Objetivo da Sprint
A Sprint 1 teve como objetivo especificar integralmente os cenários de teste de aceitação (BDD) das histórias de usuário utilizando a linguagem Gherkin. Esta entrega estabelece a base de testes comportamentais para implementação futura, garantindo clareza nos requisitos, padronização dos comportamentos esperados e definição precisa de critérios de aceite.

A sprint concentrou-se exclusivamente na elaboração dos arquivos `.feature`, sem implementação funcional.

---

## Backlog da Sprint 1

Todas as 16 histórias planejadas para o projeto foram especificadas em BDD.

| ID | História | Tipo | Status |
|----|---------|------|--------|
| #98 | Importar dados do SIGAA | Administrador | Concluída (BDD) |
| #99 | Responder formulário | Participante | Concluída (BDD) |
| #100 | Cadastrar usuários do sistema | Administrador | Concluída (BDD) |
| #101 | Gerar relatório (CSV) | Administrador | Concluída (BDD) |
| #102 | Criar template de formulário | Administrador | Concluída (BDD) |
| #103 | Criar formulário de avaliação | Administrador | Concluída (BDD) |
| #104  | Login | Usuário | Concluída (BDD) |
| #105  | Definição de senha | Usuário | Concluída (BDD) |
| #106 | Gerenciamento de turmas por departamento | Administrador | Concluída (BDD) |
| #107 | Redefinição de senha | Usuário | Concluída (BDD) |
| #108 | Atualizar base com dados do SIGAA | Administrador | Concluída (BDD) |
| #109 | Visualizar formulários para responder | Participante | Concluída (BDD) |
| #110 | Visualização de resultados dos formulários | Administrador | Concluída (BDD) |
| #111 | Visualização dos templates criados | Administrador | Concluída (BDD) |
| #112 | Edição e deleção de templates | Administrador | Concluída (BDD) |
| #113 | Criação de formulário para docentes ou dicentes | Administrador | Concluída (BDD) |

---

## Artefatos Entregues

### Arquivos `.feature` elaborados
- `login.feature`
- `definicao_senha.feature`
- `redefinicao_senha.feature`
- `importar_sigaa.feature`
- `atualizar_base_sigaa.feature`
- `visualizar_formularios.feature`
- `responder_formulario.feature`
- `cadastrar_usuarios.feature`
- `gerar_relatorio.feature`
- `criar_template.feature`
- `visualizar_templates.feature`
- `editar_deletar_templates.feature`
- `criar_formulario_avaliacao.feature`
- `criar_formulario_docentes.feature`
- `visualizar_resultados_formularios.feature`
- `gerenciamento_departamento.feature`

### Entregas formais
- Pull Request contendo todos os cenários BDD no repositório principal.
- Arquivo `.txt` entregue conforme solicitado, contendo link para o repositório e identificação dos membros do grupo.

---

## Resumo Técnico da Sprint

- Todas as regras de negócio foram traduzidas para comportamentos verificáveis.
- Casos de sucesso e casos de erro foram contemplados nos cenários.
- Os testes foram escritos utilizando a sintaxe Gherkin em português.
- A organização dos arquivos seguiu boas práticas de BDD e Cucumber.
- As histórias foram separadas por domínio funcional e documentadas de forma independente.

---

## Dificuldades Encontradas

- A necessidade de alinhar o nível de granularidade entre os cenários produzidos pelos membros.
- Interpretação de regras implícitas nas histórias, exigindo reescrita para maior precisão.
- Padronização das estruturas dos arquivos `.feature` para garantir consistência.

---

## Conclusão da Sprint 1

A Sprint 1 foi concluída integralmente, com a especificação de testes comportamentais (BDD) para todas as histórias definidas no backlog inicial. A documentação gerada fornece base sólida para a implementação nas sprints seguintes, garantindo clareza nos requisitos e facilitando o processo de desenvolvimento dirigido por testes.

A equipe encontra-se preparada para avançar para a etapa de desenvolvimento das funcionalidades com suporte completo de testes de aceitação.