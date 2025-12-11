class Admin::FormulariosController < ApplicationController
  layout "admin"
  before_action :require_login
  before_action :require_admin

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
    if @formulario.save
      redirect_to admin_formularios_path, notice: "Avaliação criada com sucesso!"
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
      redirect_to admin_formularios_path, notice: "Avaliação atualizada!"
    else
      load_collections
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @formulario = Formulario.find(params[:id])
    @formulario.destroy
    redirect_to admin_formularios_path, notice: "Avaliação removida."
  end

  def respostas
    @formulario = Formulario.find(params[:id])
    @perguntas = @formulario.template&.questions || []
    # Agrupar respostas por pergunta, sem informar o aluno
    @respostas_por_pergunta = {}
    @perguntas.each do |pergunta|
      @respostas_por_pergunta[pergunta.id] = @formulario.respostas.where(question_id: pergunta.id).pluck(:valor)
    end
    # Contar total de respondentes
    @total_respondentes = @formulario.respostas.select(:user_id).distinct.count
  end

  private

  def formulario_params
    params.require(:formulario).permit(:titulo, :descricao, :template_id, :turma_id)
  end

  def load_collections
    @templates = ::Template.all
    @turmas = ::Turma.all
  end

  def require_admin
    redirect_to root_path, alert: "Acesso negado." unless current_user&.role_administrador?
  end
end
