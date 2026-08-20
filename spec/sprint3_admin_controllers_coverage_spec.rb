require "rails_helper"

# =========================================================
#  Sprint 3 - Cobertura extra dos controllers de Admin
# =========================================================

RSpec.describe Admin::TemplatesController, type: :controller do
  render_views

  before do
    @admin = User.create!(
      nome: "Admin",
      email: "admin@example.com",
      matricula: "999",
      password: "123456",
      password_confirmation: "123456",
      role: "administrador"
    )

    allow(controller).to receive(:current_user).and_return(@admin)
    allow(controller).to receive(:require_login).and_return(true)
  end

  let!(:template) do
    Template.create!(
      nome: "Template Base",
      descricao: "Template para testes"
    )
  end

  describe "GET #index" do
    it "não quebra ao listar templates" do
      expect { get :index }.not_to raise_error
    end
  end

  describe "GET #show" do
    it "não quebra ao exibir um template" do
      expect { get :show, params: { id: template.id } }.not_to raise_error
    end
  end

  describe "GET #new" do
    it "não quebra ao abrir o formulário de novo template" do
      expect { get :new }.not_to raise_error
    end
  end

  describe "POST #create" do
    it "não quebra ao criar um template (params simples)" do
      expect {
        post :create, params: {
          template: {
            nome: "Template Novo",
            descricao: "Descrição qualquer"
          }
        }
      }.not_to raise_error
    end
  end

  describe "GET #edit" do
    it "não quebra ao abrir a edição de template" do
      expect { get :edit, params: { id: template.id } }.not_to raise_error
    end
  end

  describe "PATCH #update" do
    it "não quebra ao atualizar um template" do
      expect {
        patch :update, params: {
          id: template.id,
          template: { nome: "Template Atualizado" }
        }
      }.not_to raise_error
    end
  end

  describe "DELETE #destroy" do
    it "não quebra ao remover um template" do
      expect {
        delete :destroy, params: { id: template.id }
      }.not_to raise_error
    end
  end
end

# =========================================================
#  Admin::FormulariosController
# =========================================================

RSpec.describe Admin::FormulariosController, type: :controller do
  render_views

  before do
    @admin = User.create!(
      nome: "Admin",
      email: "admin2@example.com",
      matricula: "998",
      password: "123456",
      password_confirmation: "123456",
      role: "administrador"
    )

    allow(controller).to receive(:current_user).and_return(@admin)
    allow(controller).to receive(:require_login).and_return(true)
  end

  let!(:turma) do
    Turma.create!(
      codigo: "TURMA1",
      departamento: "DEP",
      semestre: "2024.1",
      professor: "Professor X"
    )
  end

  let!(:template) do
    Template.create!(
      nome: "Template Avaliação",
      descricao: "Template para avaliações"
    )
  end

  let!(:formulario) do
    Formulario.create!(
      titulo: "Avaliação Sprint 3",
      descricao: "Form para testes de cobertura",
      template: template,
      turma: turma
    )
  end

  describe "GET #index" do
    it "não quebra ao listar formulários" do
      expect { get :index }.not_to raise_error
    end
  end

  describe "GET #show" do
    it "não quebra ao exibir um formulário" do
      expect { get :show, params: { id: formulario.id } }.not_to raise_error
    end
  end

  describe "GET #new" do
    it "não quebra ao abrir o formulário de novo formulário" do
      expect { get :new }.not_to raise_error
    end
  end

  describe "POST #create" do
    it "não quebra ao criar um formulário válido" do
      expect {
        post :create, params: {
          formulario: {
            titulo: "Nova Avaliação",
            descricao: "Descrição qualquer",
            template_id: template.id,
            turma_id: turma.id
          }
        }
      }.not_to raise_error
    end
  end

  describe "GET #edit" do
    it "não quebra ao abrir a edição de formulário" do
      expect { get :edit, params: { id: formulario.id } }.not_to raise_error
    end
  end

  describe "PATCH #update" do
    it "não quebra ao atualizar um formulário" do
      expect {
        patch :update, params: {
          id: formulario.id,
          formulario: { titulo: "Avaliação Atualizada" }
        }
      }.not_to raise_error
    end
  end

  describe "DELETE #destroy" do
    it "não quebra ao remover um formulário" do
      expect {
        delete :destroy, params: { id: formulario.id }
      }.not_to raise_error
    end
  end

  describe "GET #respostas" do
    it "não quebra ao exibir respostas agregadas" do
      expect {
        get :respostas, params: { id: formulario.id }
      }.not_to raise_error
    end
  end
end
