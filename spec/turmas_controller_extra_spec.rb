require "rails_helper"

RSpec.describe Admin::TurmasController, type: :controller do
  render_views

  let(:admin) do
    User.create!(
      nome: "Admin Turmas",
      email: "admin_turmas@example.com",
      matricula: "ADM_TURMAS",
      password: "123456",
      password_confirmation: "123456",
      role: "administrador"
    )
  end

  before do
    allow(controller).to receive(:require_login).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin)
  end

  def create_turma(attrs = {})
    Turma.create!(
      {
        codigo: "TURMA1",
        departamento: "DEP",
        semestre: "2025.1",
        professor: "Professor X"
      }.merge(attrs)
    )
  end

  describe "GET #index" do
    it "responde 200 e renderiza a lista de turmas" do
      turma = create_turma(codigo: "LISTA1")

      get :index

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("LISTA1")
    end
  end

  describe "GET #show" do
    it "responde 200 para uma turma existente" do
      turma = create_turma(codigo: "SHOW1")

      get :show, params: { id: turma.id }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("SHOW1")
    end
  end

  describe "GET #new" do
    it "renderiza o formulário de nova turma" do
      get :new

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "com parâmetros válidos" do
      it "cria uma turma e redireciona para index" do
        expect {
          post :create, params: {
            turma: {
              codigo: "CRIAR1",
              departamento: "DEP",
              semestre: "2025.1",
              professor: "Prof Criar"
            }
          }
        }.to change(Turma, :count).by(1)

        expect(response).to redirect_to(admin_turmas_path)
      end
    end

    context "com parâmetros inválidos" do
      it "não cria turma e retorna 422" do
        expect {
          post :create, params: {
            turma: {
              codigo: "",              # inválido
              departamento: "DEP"
            }
          }
        }.not_to change(Turma, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #edit" do
    it "abre a tela de edição da turma" do
      turma = create_turma(codigo: "EDIT1")

      get :edit, params: { id: turma.id }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("EDIT1")
    end
  end

  describe "PATCH #update" do
    context "com parâmetros válidos" do
      it "atualiza a turma e redireciona" do
        turma = create_turma(codigo: "UPD1")

        patch :update, params: {
          id: turma.id,
          turma: { professor: "Prof Atualizado" }
        }

        expect(response).to redirect_to(admin_turmas_path)
        expect(turma.reload.professor).to eq("Prof Atualizado")
      end
    end

    context "com parâmetros inválidos" do
      it "não explode e retorna 422" do
        turma = create_turma(codigo: "UPD_ERR")

        patch :update, params: {
          id: turma.id,
          turma: { codigo: "" }       # inválido
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "remove a turma e redireciona para index" do
      turma = create_turma(codigo: "DEL1")

      expect {
        delete :destroy, params: { id: turma.id }
      }.to change(Turma, :count).by(-1)

      expect(response).to redirect_to(admin_turmas_path)
    end
  end

  describe "filtro de admin" do
    it "redireciona para root_path quando usuário não é administrador" do
      non_admin = User.create!(
        nome: "Participante",
        email: "participante_turmas@example.com",
        matricula: "PART_TURMAS",
        password: "123456",
        password_confirmation: "123456",
        role: "participante" # válido para o enum
      )

      allow(controller).to receive(:current_user).and_return(non_admin)

      get :index

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Acesso negado.")
    end
  end
end
