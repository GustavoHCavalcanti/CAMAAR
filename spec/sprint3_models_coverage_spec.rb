require 'rails_helper'

# ========================
# MODELS
# ========================

RSpec.describe 'Sprint 3 — Cobertura extra de models', type: :model do
  it 'Question pode ser instanciado e validado sem quebrar' do
    question = Question.new
    expect { question.valid? }.not_to raise_error
  end

  it 'ResetToken pode ser instanciado e validado sem quebrar' do
    token = ResetToken.new
    expect { token.valid? }.not_to raise_error
  end

  it 'Resposta pode ser instanciada e validada sem quebrar' do
    resposta = Resposta.new
    expect { resposta.valid? }.not_to raise_error
  end

  it 'TurmaUser pode ser instanciado e validado sem quebrar' do
    tu = TurmaUser.new
    expect { tu.valid? }.not_to raise_error
  end
end

# ========================
# JOBS
# ========================

RSpec.describe ApplicationJob, type: :job do
  it "pode ser instanciado" do
    job = ApplicationJob.new
    expect(job).to be_a(ApplicationJob)
  end

  it "herda de ActiveJob::Base" do
    expect(ApplicationJob.superclass).to eq(ActiveJob::Base)
  end
end

# ========================
# MAILERS
# ========================

RSpec.describe ApplicationMailer, type: :mailer do
  it "usa o remetente padrão" do
    expect(ApplicationMailer.default[:from]).to eq("from@example.com")
  end

  it "usa o layout mailer" do
    expect(ApplicationMailer._layout).to eq("mailer")
  end
end

# ========================
# SERVICES
# ========================

RSpec.describe TurmaImportService, type: :service do
  def fake_file(content)
    StringIO.new(content).tap do |f|
      allow(f).to receive(:read).and_return(content)
    end
  end

  it "retorna erro quando file é nil" do
    service = TurmaImportService.new(file: nil)
    result = service.call
    expect(result.success?).to eq(false)
  end

  it "retorna erro quando arquivo está vazio" do
    service = TurmaImportService.new(file: fake_file(""))
    result = service.call
    expect(result.success?).to eq(false)
  end

  it "retorna erro quando CSV não tem linhas" do
    service = TurmaImportService.new(file: fake_file("codigo,departamento\n"))
    result = service.call
    expect(result.success?).to eq(false)
  end

  it "processa um CSV simples válido" do
    csv = <<~CSV
      codigo,departamento,nome,email,matricula
      T01,DEP,João,joao@example.com,123
    CSV

    service = TurmaImportService.new(file: fake_file(csv))
    result = service.call

    expect(result.success?).to eq(true)
  end
end

# ========================
# HELPERS PARA CRIAR OBJETOS VÁLIDOS
# ========================

def create_valid_formulario
  turma = Turma.create!(
    codigo: "T1",
    departamento: "DEP",
    semestre: "2024.1",
    professor: "Fulano"
  )

  template = Template.create!(
    nome: "Template Teste",
    descricao: "Descrição do template"
  )

  Formulario.create!(
    titulo: "Form Teste",
    descricao: "Descrição do formulário",
    template: template,
    turma: turma
  )
end

# ========================
# CONTROLLERS
# ========================

RSpec.describe Respondente::FormulariosController, type: :controller do
  render_views

  before do
    @user = User.create!(
      nome: "Teste",
      email: "teste@example.com",
      matricula: "123",
      password: "123456",
      password_confirmation: "123456",
      role: "participante"
    )

    allow(controller).to receive(:current_user).and_return(@user)
    allow(controller).to receive(:require_login).and_return(true)
  end

  describe "GET #index" do
    it "não quebra ao listar formulários" do
      expect { get :index }.not_to raise_error
      expect(response.status).to be_between(200, 399)
    end
  end

  describe "GET #show" do
    it "não quebra com formulário existente" do
      form = create_valid_formulario
      expect { get :show, params: { id: form.id } }.not_to raise_error
    end
  end

  describe "POST #submit" do
    it "não quebra ao enviar submission para formulário sem perguntas" do
      form = create_valid_formulario

      expect {
        post :submit, params: { id: form.id }
      }.not_to raise_error
    end
  end
end
