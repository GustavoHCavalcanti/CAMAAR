require "rails_helper"

# =========================================================
# Respondente::PerfilController
# =========================================================
RSpec.describe Respondente::PerfilController, type: :controller do
  render_views

  let(:user) do
    User.create!(
      nome: "Participante",
      email: "participante@test.com",
      matricula: "P001",
      password: "senha123",
      password_confirmation: "senha123",
      role: "participante"
    )
  end

  before do
    # Evita depender de sessão / login real
    allow(controller).to receive(:require_login).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #show" do
    it "retorna sucesso" do
      get :show
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #edit_password" do
    it "renderiza formulário de edição" do
      get :edit_password
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH #update_password" do
    it "falha se senha atual estiver incorreta" do
      patch :update_password, params: {
        current_password: "errada",
        new_password: "nova123",
        password_confirmation: "nova123"
      }

      expect(response).to have_http_status(422)
      expect(response.body).to include("Senha atual incorreta")
    end

    it "falha se confirmação não bater" do
      patch :update_password, params: {
        current_password: "senha123",
        new_password: "nova123",
        password_confirmation: "diferente"
      }

      expect(response).to have_http_status(422)
      expect(response.body).to include("não coincidem")
    end

    it "altera senha com sucesso" do
      patch :update_password, params: {
        current_password: "senha123",
        new_password: "nova123",
        password_confirmation: "nova123"
      }

      expect(response).to redirect_to(respondente_perfil_path)
      expect(flash[:notice]).to eq("Senha alterada com sucesso!")
      expect(user.reload.authenticate("nova123")).to be_truthy
    end
  end
end

# =========================================================
# Admin::PerfilController
# =========================================================
RSpec.describe Admin::PerfilController, type: :controller do
  render_views

  let(:admin) do
    User.create!(
      nome: "Admin",
      email: "admin@test.com",
      matricula: "ADM001",
      password: "senha123",
      password_confirmation: "senha123",
      role: "administrador"
    )
  end

  let(:non_admin) do
    User.create!(
      nome: "Participante 2",
      email: "participante2@test.com",
      matricula: "P002",
      password: "senha123",
      password_confirmation: "senha123",
      role: "participante"
    )
  end

  before do
    allow(controller).to receive(:require_login).and_return(true)
  end

  describe "GET #show" do
    it "permite acesso para admin" do
      allow(controller).to receive(:current_user).and_return(admin)

      get :show
      expect(response).to have_http_status(:ok)
    end

    it "bloqueia acesso para não admin" do
      allow(controller).to receive(:current_user).and_return(non_admin)

      get :show
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Acesso negado.")
    end
  end

  describe "GET #edit_password" do
    it "renderiza tela para admin" do
      allow(controller).to receive(:current_user).and_return(admin)

      get :edit_password
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH #update_password" do
    before do
      allow(controller).to receive(:current_user).and_return(admin)
    end

    it "falha com senha atual incorreta" do
      patch :update_password, params: {
        current_password: "errada",
        new_password: "nova123",
        password_confirmation: "nova123"
      }

      expect(response).to have_http_status(422)
      expect(response.body).to include("Senha atual incorreta")
    end

    it "falha com confirmação diferente" do
      patch :update_password, params: {
        current_password: "senha123",
        new_password: "nova123",
        password_confirmation: "outra"
      }

      expect(response).to have_http_status(422)
      expect(response.body).to include("não coincidem")
    end

    it "altera senha com sucesso" do
      patch :update_password, params: {
        current_password: "senha123",
        new_password: "nova123",
        password_confirmation: "nova123"
      }

      expect(response).to redirect_to(admin_perfil_path)
      expect(flash[:notice]).to eq("Senha alterada com sucesso!")
      expect(admin.reload.authenticate("nova123")).to be_truthy
    end
  end
end
