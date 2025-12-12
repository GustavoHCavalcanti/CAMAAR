# CAMAAR - Sistema de Avaliação e Formulários

CAMAAR é uma aplicação Rails para gerenciamento de formulários de avaliação, feedback de docentes e coleta de dados estruturada. O sistema permite criar templates de formulários, coletar respostas de participantes e gerar relatórios de análise.

## Tabela de Conteúdos

- [Tecnologias](#-tecnologias)
- [Requisitos](#-requisitos)
- [Instalação](#-instalação)
- [Configuração](#-configuração)
- [Como Usar](#-como-usar)
- [Testes](#-testes)
- [Análise de Código](#-análise-de-código)
- [Deploy](#-deploy)

---

## Tecnologias

### Core Framework
- **Rails 8.1.1** - Framework web Ruby para aplicações MVC
- **Ruby 3.3.5** - Linguagem de programação
- **PostgreSQL** - Banco de dados relacional

### Frontend
- **Bootstrap 5.3** - Framework CSS responsivo
- **Stimulus Rails** - Framework JavaScript leve
- **Turbo Rails** - Navegação rápida sem página inteira
- **Importmap Rails** - Gerenciamento de dependências JavaScript

### Banco de Dados
- **Solid Cache** - Cache em SQL com Rails 8
- **Solid Queue** - Sistema de filas em SQL para jobs
- **Solid Cable** - WebSockets em SQL para real-time

### Segurança & Autenticação
- **BCrypt 3.1.7** - Hash de senhas seguro
- **Dotenv Rails** - Gerenciamento de variáveis de ambiente

### Segurança & Code Quality
- **Rubocop Rails Omakase** - Linter e style guide Rails
- **Brakeman** - Scanner de vulnerabilidades
- **Bundler Audit** - Audit de gems vulneráveis

### Testes & Análise
- **RSpec 3.13** - Framework de testes unitários e integração
- **Cucumber 10.1.1** - Testes de comportamento (BDD)
- **SimpleCov 0.22.0** - Cobertura de código
- **RubyCritic 4.11.0** - Análise de qualidade com Reek, Flog e Flay
- **Flay 2.13.3** - Detecção de código duplicado
- **RDoc 6.17.0** - Geração de documentação

### Infraestrutura
- **Kamal** - Deployment com Docker
- **Puma 5.0+** - Web server
- **Docker** - Containerização

---

## Requisitos

### Sistema Operacional
- macOS, Linux ou Windows (com WSL)

### Dependências Obrigatórias
- **Ruby 3.3.5** (compatível com Rails 8.1.1)
- **Bundler 2.4+**
- **PostgreSQL 12+**
- **Node.js 18+** (para JavaScript)

### Ferramentas Recomendadas
- **rbenv** - Gerenciador de versões Ruby
- **git** - Controle de versão
- **Docker** - Para ambiente isolado

---

## Instalação

### 1. Clonar o Repositório
```bash
git clone https://github.com/seu-usuario/CAMAAR.git
cd CAMAAR
```

### 2. Instalar Ruby 3.3.5 com rbenv
```bash
# Listar versões disponíveis
rbenv install --list | grep 3.3.5

# Instalar
rbenv install 3.3.5

# Definir como padrão neste projeto
rbenv local 3.3.5

# Verificar instalação
rbenv version
# Output esperado: 3.3.5 (set by /path/to/CAMAAR/.ruby-version)
```

### 3. Instalar Dependências do Sistema
```bash
# macOS com Homebrew
brew install openssl@3 readline libyaml gmp postgresql

# Linux (Ubuntu/Debian)
sudo apt-get install build-essential libssl-dev libyaml-dev libreadline-dev zlib1g-dev postgresql postgresql-contrib

# Linux (Fedora)
sudo dnf install gcc openssl-devel libyaml-devel readline-devel gmp-devel postgresql-server postgresql-contrib
```

### 4. Instalar Gems do Projeto
```bash
# Instalar dependências do Gemfile
bundle install

# Se houver erro com bcrypt_pbkdf, reconstituir a gem
gem pristine bcrypt_pbkdf --version 1.1.2
```

### 5. Configurar Banco de Dados
```bash
# Criar arquivo .env com credenciais
cp .env.example .env  # Se existir

# Editar .env com suas credenciais PostgreSQL
# DATABASE_URL=postgresql://usuario:senha@localhost:5432/camaar_development

# Criar banco de dados
rails db:create

# Executar migrações
rails db:migrate

# Carregar dados de seed (opcional)
rails db:seed
```

---

## Configuração

### Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```env
# Banco de Dados
DATABASE_URL=postgresql://postgres:sua_senha@shinkansen.proxy.rlwy.net:48163/railway

# Rails
RAILS_ENV=development
SECRET_KEY_BASE=sua_chave_secreta_aqui

# SMTP (se usar email)
SMTP_HOST=smtp.mailtrap.io
SMTP_PORT=465
SMTP_USER=seu_usuario
SMTP_PASSWORD=sua_senha
```

### Estrutura do Projeto
```
CAMAAR/
├── app/
│   ├── controllers/     # Controladores HTTP
│   ├── models/          # Modelos de dados
│   ├── views/           # Templates HTML
│   ├── services/        # Lógica de negócio
│   └── jobs/            # Jobs assíncronos (Solid Queue)
├── config/
│   ├── routes.rb        # Rotas da aplicação
│   ├── database.yml     # Configuração PostgreSQL
│   └── environments/    # Variáveis por ambiente
├── db/
│   ├── migrate/         # Migrações de banco
│   ├── schema.rb        # Esquema atual
│   └── seeds.rb         # Dados iniciais
├── spec/                # Testes RSpec
├── features/            # Testes Cucumber
└── lib/                 # Código reutilizável
```

---

## Como Usar

### Servidor Web
```bash
# Iniciar servidor local na porta 3000
bin/dev

# Ou manualmente
bundle exec rails server

# Acessar em: http://localhost:3000
```

### Console Rails
```bash
# Abrir console interativo para testar código
bundle exec rails c

# Exemplo: Criar usuário
User.create!(email: "user@example.com", password: "123456", role: "participante")
```

### Credenciais de Teste

Para acessar o sistema após rodar `rails db:seed`, utilize:

#### Administrador
- **Email:** admin@camaar.com
- **Senha:** 123456

#### Alunos (Participantes)
Após importar dados via CSV ou criar manualmente, alguns exemplos de usuários:
- **Matrícula:** 2025001
- **Matrícula:** 2025102
- **Matrícula:** 2025201
- **Matrícula:** 2025405

**Senha padrão:** A própria matrícula (ex: usuário com matrícula `20230001` tem senha `20230001`)

> 💡 **Dica:** Ao importar alunos via CSV sem especificar senha, o sistema automaticamente usa a matrícula como senha padrão.

### Jobs Assíncronos (Solid Queue)
```bash
# Iniciar o processador de filas
bundle exec rake solid_queue:start

# Ou via bin/dev que já inicia automaticamente
```

---

## Testes

### RSpec - Testes Unitários e de Integração
```bash
# Executar todos os testes
bundle exec rspec

# Executar arquivo específico
bundle exec rspec spec/models/user_spec.rb

# Executar com saída detalhada
bundle exec rspec --format documentation

# Com cobertura de código
bundle exec rspec --format RspecJunitFormatter --out rspec.xml

# Coverage report (SimpleCov)
# Abre relatório em coverage/index.html após rodar rspec
```

**Versão:** RSpec 3.13  
**Gems:** rspec-core 3.13.6, rspec-rails 8.0.2

### Cucumber - Testes Comportamentais (BDD)
```bash
# Executar todos os features
bundle exec cucumber

# Feature específica
bundle exec cucumber features/login.feature

# Com tags específicas
bundle exec cucumber --tags @smoke

# Gerar relatório HTML
bundle exec cucumber --format html:cucumber_report.html
```

**Versão:** Cucumber 10.1.1  
**Uso:** Escrever testes em linguagem natural no formato Gherkin

**Estrutura de um Feature:**
```gherkin
Feature: Login
  Scenario: Usuário faz login com sucesso
    Given que estou na página de login
    When preencho "email" com "usuario@teste.com"
    And preencho "senha" com "123456"
    And clico no botão "Login"
    Then devo ver "Bem-vindo!"
```

### SimpleCov - Cobertura de Código
```bash
# Executar rspec (gera relatório automaticamente)
bundle exec rspec

# Abrir relatório
open coverage/index.html

# Meta: Manter cobertura > 80%
```

**Versão:** SimpleCov 0.22.0  
**Configuração:** spec/spec_helper.rb

---

## Análise de Código

### RuboCop - Linting & Style
```bash
# Verificar problemas de style
bundle exec rubocop

# Arquivo específico
bundle exec rubocop app/models/user.rb

# Autocorrigir problemas automaticamente
bundle exec rubocop -A

# Verificar complexidade ciclomática (máx: 10 por método)
bundle exec rubocop --only Metrics/CyclomaticComplexity
```

**Versão:** RuboCop Rails Omakase  
**Regras de Complexidade:**
- Complexidade Ciclomática máxima: **10 por método**
- Complexidade Percebida máxima: **10 por método**

### RubyCritic - Análise Completa de Qualidade
```bash
# Gerar relatório de qualidade (HTML)
bundle exec rubycritic app/

# Analisar arquivo específico
bundle exec rubycritic app/models/user.rb

# Relatório salvo em: tmp/rubycritic/overview.html
```

**Versão:** RubyCritic 4.11.0  
**Inclui:** Reek, Flog, Flay, Churn, SimpleCov  
**Metaas:** Manter score > 80

### Flay - Detecção de Código Duplicado
```bash
# Encontrar código duplicado
bundle exec flay app/

# Exibir máximo de linhas
bundle exec flay -m 20 app/
```

**Versão:** Flay 2.13.3  
**Replaces:** Saikuro (versão antiga, incompatível com Ruby 3.3)

### Brakeman - Vulnerabilidades Rails
```bash
# Escanear por vulnerabilidades de segurança
bundle exec brakeman -q

# Gerar relatório HTML
bundle exec brakeman -o brakeman.html
```

**Versão:** Brakeman (via Omakase)  
**Detecta:** SQL Injection, XSS, CSRF, etc.

### Bundler Audit - Vulnerabilidades em Gems
```bash
# Verificar gems com vulnerabilidades conhecidas
bundle audit

# Atualizar banco de dados de vulnerabilidades
bundle audit update

# Ignorar vulnerabilidades específicas
bundle audit --ignore CVE-2024-XXXXX
```

**Configuração:** config/bundler-audit.yml

### RDoc - Documentação
```bash
# Gerar documentação HTML
bundle exec rdoc

# Documentação salva em: doc/index.html
```

**Versão:** RDoc 6.17.0

---

## Checklist de Qualidade

Antes de fazer commit ou push:

```bash
# 1. Testes passando
bundle exec rspec && bundle exec cucumber

# 2. Sem problemas de style
bundle exec rubocop -A

# 3. Sem vulnerabilidades
bundle audit && bundle exec brakeman -q

# 4. Sem código duplicado
bundle exec flay app/

# 5. Complexidade ok
bundle exec rubocop --only Metrics/CyclomaticComplexity

# 6. Cobertura de testes
bundle exec rspec  # Verifica coverage/index.html
```

---

## Deploy

### Com Kamal (Docker)
```bash
# Instalar Kamal
gem install kamal

# Configurar deploy (editar config/deploy.yml)
kamal env push

# Deploy inicial
kamal deploy

# Deploy de atualizações
kamal redeploy
```

### Com Railway.app (recomendado para este projeto)
```bash
# Conectar Railway (usando variável DATABASE_URL que já está no .env)
railway login

# Deploy
railway up
```

---

## Troubleshooting

### Erro: "rbenv: rails: command not found"
```bash
rbenv rehash
bundle exec rails c
```

### Erro: "cannot load such file -- rdoc/usage"
```bash
gem pristine rdoc
bundle install
```

### Erro de conexão PostgreSQL
```bash
# Verificar URL de conexão no .env
echo $DATABASE_URL

# Testar conexão
psql $DATABASE_URL -c "SELECT 1"
```

### Ports já em uso
```bash
# Mudar porta padrão
rails server -p 3001
```

---

## Versões de Compatibilidade

| Componente | Versão | Mínimo | Máximo | Status |
|---|---|---|---|---|
| Ruby | 3.3.5 | 3.1.0 | 3.3.5 | ✅ Testado |
| Rails | 8.1.1 | 8.0.0 | 8.1.x | ✅ Estável |
| PostgreSQL | 12+ | 12 | 16 | ✅ Compatível |
| Node.js | 18+ | 18 | 20 | ✅ Compatível |
| Bundler | 2.4+ | 2.3 | 2.5 | ✅ Testado |
| RSpec | 3.13 | 3.12 | 3.13 | ✅ Instalado |
| Cucumber | 10.1.1 | 9.0 | 10.x | ✅ Instalado |
| RuboCop | Omakase | - | - | ✅ Instalado |

---

## Contribuindo

1. Fork o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

**Requisitos antes de PR:**
- Testes passando (RSpec + Cucumber)
- RuboCop clean (sem style issues)
- Sem vulnerabilidades (Brakeman + Bundler Audit)
- Complexidade ciclomática < 10

---

## Licença

Este projeto está sob a licença MIT.

---

## Suporte

Para dúvidas ou problemas, abra uma issue no repositório ou entre em contato com a equipe de desenvolvimento.
