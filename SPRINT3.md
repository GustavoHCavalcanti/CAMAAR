# Sprint 3 — Implementação de Interface Web e Testes de Cobertura

**Integrantes**  
- Gabriel Caixeta Romero – 232036896  
- Gustavo Henrique Andrade Cavalcanti – 222034109  
- Vitor Amorim Mello – 231037048  

**Projeto:**  
CAMAAR – Sistema de Avaliação de Turmas da UnB

## Objetivo da Sprint
A Sprint 3 teve como objetivo materializar a aplicação Rails completa com:

- Interface web funcional com Bootstrap 5.3  
- Sistema de autenticação robusto com login/logout e reset de senha  
- CRUD completo de formulários, templates e turmas  
- Geração e coleta de respostas de formulários  
- Relatórios em CSV  
- Cobertura de testes RSpec em modelos e controllers  
- Documentação automática com RDoc  

**Link da sprint:**  
https://github.com/GustavoHCavalcanti/CAMAAR/tree/sprint-3

## Papéis da Equipe
- **Scrum Master:** Gustavo Henrique Andrade Cavalcanti  
- **Product Owner:** Gabriel Caixeta Romero  

## Resumo Técnico

### Stack Tecnológico Implementado
- **Rails 8.1.1** – Framework web MVC  
- **Ruby 3.3.5** – Linguagem de programação  
- **PostgreSQL** – Banco de dados relacional  
- **Bootstrap 5.3** – Interface responsiva  
- **Stimulus Rails** – Interatividade JavaScript  
- **Turbo Rails** – Navegação rápida (turbo-drive)  
- **RSpec 3.13** – Testes automatizados  
- **SimpleCov 0.22.0** – Análise de cobertura  
- **Brakeman** – Segurança (vulnerabilidades)  
- **Rubocop Rails** – Linting e code style  

## Backlog da Sprint 3

### Funcionalidades Implementadas

#### Autenticação e Segurança
- Sistema de login com email/senha  
- Autenticação baseada em sessões  
- Definição e redefinição de senha  
- Reset de senha via token temporário  
- Edição de senha pelo usuário autenticado  
- Controle de acesso por departamento  
- Autenticação e autorização em controllers  

#### Gerenciamento de Templates
- CRUD de templates de formulários  
- Campos de questões parametrizáveis  
- Vinculação de templates a turmas/departamentos  
- Visualização e edição de templates  
- Permissões de acesso por departamento  
- Remoção de templates com cascata  

#### Gerenciamento de Formulários
- Criação de formulários a partir de templates  
- Coleta de respostas (respondentes)  
- Restrição de resposta única por usuário  
- Validação de todas as questões obrigatórias  
- Visualização de respostas após submissão  
- Formulários com status de publicação  

#### Gerenciamento de Turmas
- CRUD de turmas (criar, listar, editar, deletar)  
- Importação de turmas via CSV  
- Relação muitos-para-muitos entre alunos e turmas  
- Atualização incremental de dados SIGAA  
- Listagem de alunos por turma  

#### Relatórios e Visualização
- Geração de relatórios em CSV para administrador  
- Visualização de respostas anônimas  
- Listagem de formulários para relatórios  
- Visualização de resultados de avaliação  
- Logs de importação com status e descrição  

#### Interface Gráfica
- Layout responsivo com Bootstrap 5.3  
- Página de login  
- Dashboard do administrador  
- Menu de navegação com controle de acesso  
- Formulários estilizados  
- Tabelas com dados  
- Modal para ações críticas  

### Commits Principais (42 commits entre sprint-2 e sprint-3)

1. **Estrutura Rails Inicial**
   - Instalação e configuração do Rails 8.1.1
   - Criação de modelos, controllers e views
   - Configuração do banco de dados PostgreSQL

2. **Autenticação**
   - Implementação de login com BCrypt
   - Redefinição de senha com tokens
   - Edição de senha autenticada

3. **Gerenciamento de Dados**
   - CRUD de templates
   - CRUD de formulários
   - CRUD de turmas
   - Importação de CSV

4. **Funcionalidades Avançadas**
   - Sistema de respostas de formulários
   - Geração de relatórios CSV
   - Visualização de resultados
   - Logs de importação

5. **Polimento**
   - Ajustes de performance (turmas demorando)
   - Correção de bugs em formulários
   - Estilo da navegação
   - Documentação RDoc

## Modelos Implementados

### User
- Email, password, nome, departamento
- Autenticação e recuperação de senha
- Relações com turmas e respostas

### Formulario
- Título, descrição, template_id
- Status (publicado/rascunho)
- Questões vinculadas
- Respostas de respondentes

### Template
- Nome, descrição, departamento
- Questões parametrizáveis
- Vinculações com formulários

### Question
- Enunciado, tipo, obrigatoriedade
- Pertence a um template
- Respostas coletáveis

### Resposta
- Conteúdo da resposta
- Usuário respondente
- Formulário respondido
- Validação de unicidade

### Turma
- Nome, semestre, departamento
- Relação muitos-para-muitos com usuários
- Logs de importação

### TurmaUser
- Relação entre usuários e turmas
- Rastro de vinculações

### ImportLog
- Registro de importações SIGAA
- Status e descrição
- Data e hora

### ResetToken
- Tokens para redefinição de senha
- Expiração em 24h

## Controllers Implementados

### Admin
- **BaseController** – Autenticação de admin
- **FormulariosController** – CRUD de formulários
- **TemplatesController** – CRUD de templates
- **TurmasController** – CRUD de turmas
- **GerenciamentoController** – Relatórios e importações
- **RespostasController** – Visualização de respostas

### Respondente
- **FormulariosController** – Listagem e resposta de formulários

### Sessions
- **SessionsController** – Login, logout e gerenciamento de sessão

### Application
- **ApplicationController** – Controle central de autenticação

## Testes Implementados

### Cobertura de Testes
- **Total de exemplos (testes):** 126
- **Cobertura de linhas:** 56.53% (437/773 linhas cobertas)
- **Força média:** 0.95 hits/line

### Arquivos de Teste (23 spec files)

**Testes de Serviço:**
- `sigaa_importer_spec.rb` – Importação de dados SIGAA
- `template_manager_spec.rb` – Gerenciamento de templates
- `form_manager_spec.rb` – Gerenciamento de formulários
- `form_responder_spec.rb` – Sistema de respostas
- `password_manager_spec.rb` – Gerenciamento de senhas
- `authenticator_spec.rb` – Autenticação de usuários
- `report_generator_spec.rb` – Geração de relatórios

**Testes de Comportamento (BDD):**
- `criar_template_formulario_spec.rb` – Criação de templates
- `criar_formulario_avaliacao_spec.rb` – Criação de formulários
- `criacao_formulario_publico_alvo_spec.rb` – Criação de formulários direcionados
- `listar_formularios_relatorio_spec.rb` – Listagem para relatórios
- `edicao_delecao_templates_spec.rb` – Edição e deleção
- `gerenciamento_turmas_departamento_spec.rb` – Gerenciamento de turmas
- `atualizacao_base_sigaa_spec.rb` – Atualização incremental
- `cadastrar_usuarios_sistema_spec.rb` – Cadastro de usuários
- `gerar_relatorio_administrador_spec.rb` – Geração de relatórios

**Testes de Controllers:**
- `turmas_controller_extra_spec.rb` – Controller de turmas
- `formularios_controller_extra_spec.rb` – Controller de formulários
- `sprint3_admin_controllers_coverage_spec.rb` – Cobertura geral de controllers
- `sprint3_models_coverage_spec.rb` – Cobertura de modelos

**Testes de Modelos:**
- `import_log_spec.rb` – Validações do ImportLog

### Resultados dos Testes
- **126 exemplos executados**
- **1 falha** (bug em turmas_controller esperado para correção)
- **Tempo total:** ~5 minutos 56 segundos
- **Cobertura:** 56.53% de linhas cobertas

### Análise de Cobertura por Tipo

**Controllers com 100% de cobertura:**
- `admin/base_controller.rb`

**Controllers com boa cobertura (>80%):**
- `admin/gerenciamento_controller.rb` – 88.89%
- `admin/turmas_controller.rb` – 85%+

**Áreas com cobertura menor (<50%):**
- `admin/formularios_controller.rb` – 35.29% (complexidade alta)
- `respondente/formularios_controller.rb` – Precisa de testes

## Artefatos Entregues

**Código Rails Funcional**
- Estrutura MVC completa
- Models, controllers e views implementados
- Services para lógica de negócio

**Testes Automatizados**
- 23 arquivos de especificação
- 126 exemplos de teste
- Cobertura de 56.53% com SimpleCov

**Documentação**
- Documentação RDoc gerada (`/doc`)
- README.md com instruções de instalação
- Comentários em métodos críticos

**Interface Web**
- Layout Bootstrap responsivo
- CRUD completo com formulários
- Dashboard administrativo
- Navegação com controle de acesso

**Banco de Dados**
- Schema PostgreSQL com migrations
- Relacionamentos MxN
- Validações em nível de modelo

## Política de Branching
- **Branch principal:** `main`  
- **Branch de desenvolvimento:** `sprint-3`  

## Como Executar

### Instalação
```bash
bundle install
rails db:create db:migrate
rails db:seed
```

### Rodar Testes
```bash
bundle exec rspec spec/ --fail-fast
```

### Análise de Cobertura
```bash
bundle exec rspec spec/
# Abre: coverage/index.html
```

### Gerar Documentação
```bash
bundle exec rdoc app lib config \
  --exclude 'vendor|tmp|log|coverage|spec|features' \
  -o doc --verbose
```

### Iniciar Servidor
```bash
bin/rails server
```

## Dificuldades Encontradas e Resolvidas

### 1. Performance
- **Problema:** Carregamento lento de turmas
- **Solução:** Otimização de queries, eager loading com `includes()`

### 2. Bugs em Formulários
- **Problema:** Erro ao renderizar formulário com parâmetros inválidos
- **Solução:** Inicialização correta de variáveis de instância

### 3. Cobertura de Testes
- **Problema:** Começou em ~90% mas regrediu para 56.53%
- **Razão:** Foco em funcionalidades de UI (controllers), que têm testes complexos
- **Status:** Esperado; focus em controllers admin nos próximos sprints

### 4. Erros de Navegação
- **Problema:** Menu quebrado após integração
- **Solução:** Ajuste de partials e helpers de autenticação

## Principais Conquistas

**Aplicação Rails Completa e Funcional**
- Sistema end-to-end operacional
- Interface web responsiva
- Fluxos de autenticação e autorização

**Base de Testes Sólida**
- 126 testes implementados
- Cobertura de 56.53%
- Services com testes unitários bem cobertos

**Documentação Completa**
- RDoc automático de todos os métodos públicos
- README com instruções técnicas
- Código comentado nas seções críticas

**Segurança Implementada**
- Hash seguro de senhas com BCrypt
- Autenticação baseada em sessão
- Controle de acesso por departamento
- Tokens seguros para reset de senha

## Conclusão

A Sprint 3 transformou a estrutura de backend da Sprint 2 em uma aplicação Rails completa, funcional e interativa. Com 42 commits, 42 funcionalidades implementadas e uma base de 126 testes, o sistema CAMAAR agora está pronto para:

- Coletar formulários de avaliação
- Gerar relatórios em CSV
- Gerenciar turmas e usuários
- Garantir segurança e autenticação
- Ser testado de forma automatizada

O projeto atingiu maturidade suficiente para testes em produção com as melhorias incremental de cobertura nos sprints seguintes.

---

**Repositório:** https://github.com/GustavoHCavalcanti/CAMAAR/tree/sprint-3  
**Kanban:** https://github.com/users/GustavoHCavalcanti/projects/1/views/1  
**Wiki:** https://github.com/GustavoHCavalcanti/CAMAAR/wiki  
**Data:** 12 de dezembro de 2025  
