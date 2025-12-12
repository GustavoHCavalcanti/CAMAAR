require "rails_helper"

RSpec.describe Respondente::FormulariosController, type: :controller do
  render_views

  let(:user) do
    User.create!(
      nome: "Participante",
      email: "participante@example.com",
      matricula: "PART001",
      password: "123456",
      password_confirmation: "123456",
      role: "participante"
    )
  end

  let(:turma) do
    t = Turma.create!(
      codigo: "TURMA_RESP",
      departamento: "DEP",
      semestre: "2025.1",
      professor: "Prof Responder"
    )
    # Associar o usuário à turma
    TurmaUser.create!(turma: t, user: user)
    t
  end

  # Template com uma pergunta (branch normal com perguntas)
  let(:template_com_perguntas) do
    t = Template.create!(nome: "Template com perguntas", descricao: "desc")
    Question.create!(template: t, texto: "Pergunta 1", tipo: "texto")
    t
  end

  # Template sem perguntas (branch "Formulário sem perguntas.")
  let(:template_sem_perguntas) do
    Template.create!(nome: "Template sem perguntas", descricao: "desc")
  end

  before do
    allow(controller).to receive(:require_login).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  # ========================
  # GET index
  # ========================
  describe "GET #index" do
    it "responde 200 quando usuário ainda não respondeu" do
      form = Formulario.create!(
        titulo: "Form ainda não respondido",
        descricao: "desc",
        template: template_com_perguntas,
        turma: turma
      )

      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Form ainda não respondido")
      # aqui o loop que monta @respondeu_hash roda com valor false
    end

    it "também funciona quando usuário já respondeu" do
      form = Formulario.create!(
        titulo: "Form já respondido",
        descricao: "desc",
        template: template_com_perguntas,
        turma: turma
      )

      pergunta = template_com_perguntas.questions.first
      Resposta.create!(
        formulario: form,
        question: pergunta,
        user: user,
        valor: "Resposta qualquer"
      )

      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Form já respondido")
      # o exists?(user_id: current_user.id) entra como true
    end
  end

  # ========================
  # GET show
  # ========================
  describe "GET #show" do
    it "mostra formulário e perguntas quando usuário ainda não respondeu" do
      form = Formulario.create!(
        titulo: "Form show",
        descricao: "desc",
        template: template_com_perguntas,
        turma: turma
      )

      get :show, params: { id: form.id }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Form show")
      expect(response.body).to include("Pergunta 1")
      # cobre @ja_respondeu = false
    end

    it "passa pelo caminho em que o usuário já respondeu e carrega respostas" do
      form = Formulario.create!(
        titulo: "Form respondido no show",
        descricao: "desc",
        template: template_com_perguntas,
        turma: turma
      )

      pergunta = template_com_perguntas.questions.first
      Resposta.create!(
        formulario: form,
        question: pergunta,
        user: user,
        valor: "Resposta show"
      )

      get :show, params: { id: form.id }

      expect(response).to have_http_status(:ok)
      # aqui @ja_respondeu vira true e o bloco que monta @respostas_user é executado
    end
  end

  # ========================
  # POST submit
  # ========================
  describe "POST #submit" do
    it "redireciona com alerta se usuário já respondeu" do
      form = Formulario.create!(
        titulo: "Form já respondido no submit",
        descricao: "desc",
        template: template_com_perguntas,
        turma: turma
      )

      pergunta = template_com_perguntas.questions.first
      Resposta.create!(
        formulario: form,
        question: pergunta,
        user: user,
        valor: "Resposta anterior"
      )

      post :submit, params: { id: form.id }

      expect(response).to redirect_to(respondente_formulario_path(form))
      expect(flash[:alert]).to eq("Você já respondeu este formulário.")
    end

    it "redireciona com alerta se o formulário não tem perguntas" do
      form_sem_perguntas = Formulario.create!(
        titulo: "Sem perguntas",
        descricao: "desc",
        template: template_sem_perguntas, # template válido, mas sem questions
        turma: turma
      )

      post :submit, params: { id: form_sem_perguntas.id }

      expect(response).to redirect_to(respondente_formulario_path(form_sem_perguntas))
      expect(flash[:alert]).to eq("Formulário sem perguntas.")
    end

    it "salva respostas e redireciona para index quando tudo está ok" do
      form = Formulario.create!(
        titulo: "Form para responder",
        descricao: "desc",
        template: template_com_perguntas,
        turma: turma
      )

      pergunta = template_com_perguntas.questions.first

      post :submit, params: {
        id: form.id,
        "question_#{pergunta.id}" => "Uma resposta qualquer"
      }

      expect(response).to redirect_to(respondente_formularios_path)
      expect(flash[:notice]).to eq("Respostas enviadas com sucesso!")
      expect(Resposta.where(formulario: form, user: user).count).to eq(1)
    end
  end
end
