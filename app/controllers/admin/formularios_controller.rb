class Admin::FormulariosController < ApplicationController
  def index
    @formularios = Formulario.all
  end

  def show
    @formulario = Formulario.find(params[:id])
  end

  def new
    @formulario = Formulario.new
    load_collections
  end

  def create
    @formulario = Formulario.new(formulario_params)
    @formulario.template ||= default_template
    @formulario.turma ||= default_turma
    if @formulario.save
      redirect_to admin_formularios_path, notice: "Formulário criado com sucesso!"
    else
      load_collections
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @formulario = Formulario.find(params[:id])
    load_collections
  end

  def update
    @formulario = Formulario.find(params[:id])
    if @formulario.update(formulario_params)
      redirect_to admin_formularios_path, notice: "Formulário atualizado!"
    else
      load_collections
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @formulario = Formulario.find(params[:id])
    @formulario.destroy
    redirect_to admin_formularios_path, notice: "Formulário removido."
  end

  private

  def formulario_params
    params.require(:formulario).permit(:titulo, :descricao, :template_id, :turma_id)
  end

  def default_template
    ::Template.find_or_create_by!(nome: "Template padrão") do |template|
      template.descricao = "Gerado automaticamente"
    end
  end

  def default_turma
    ::Turma.find_or_create_by!(codigo: "TURMA-PADRAO") do |turma|
      turma.departamento = "Padrão"
      turma.semestre = ""
    end
  end

  def load_collections
    @templates = ::Template.all
    @turmas = ::Turma.all
  end
end
