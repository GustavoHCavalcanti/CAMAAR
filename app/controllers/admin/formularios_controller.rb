class Admin::FormulariosController < ApplicationController
  layout "admin"
  before_action :require_login
  before_action :require_admin

  # Lista todas as avaliações disponíveis para administração.
  # @return [void]
  def index
    @formularios = Formulario.all
  end

  # Exibe detalhes de um formulário específico.
  # @return [void]
  def show
    @formulario = Formulario.find(params[:id])
  end

  # Inicializa um novo formulário com coleções auxiliares.
  # @return [void]
  def new
    @formulario = Formulario.new
    load_collections
  end

  # Cria um formulário e redireciona em caso de sucesso.
  # @return [void]
  # @side_effect Persiste Formulario; redireciona ou renderiza :new com status 422
  def create
    @formulario = Formulario.new(formulario_params)
    if @formulario.save
      redirect_to admin_formularios_path, notice: "Avaliação criada com sucesso!"
    else
      load_collections
      render :new, status: :unprocessable_entity
    end
  end

  # Carrega formulário para edição.
  # @return [void]
  def edit
    @formulario = Formulario.find(params[:id])
    load_collections
  end

  # Atualiza um formulário e redireciona em caso de sucesso.
  # @return [void]
  # @side_effect Persiste alterações; redireciona ou renderiza :edit com status 422
  def update
    @formulario = Formulario.find(params[:id])
    if @formulario.update(formulario_params)
      redirect_to admin_formularios_path, notice: "Avaliação atualizada!"
    else
      load_collections
      render :edit, status: :unprocessable_entity
    end
  end

  # Remove um formulário definitivamente.
  # @return [void]
  # @side_effect Destroi registro e redireciona
  def destroy
    @formulario = Formulario.find(params[:id])
    @formulario.destroy
    redirect_to admin_formularios_path, notice: "Avaliação removida."
  end

  # Consolida respostas de um formulário por pergunta, sem expor identidade dos respondentes.
  # @return [void]
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

  # Strong params do formulário administrado.
  # @return [ActionController::Parameters]
  def formulario_params
    params.require(:formulario).permit(:titulo, :descricao, :template_id, :turma_id)
  end

  # Carrega coleções auxiliares para views de formulário.
  # @return [void]
  def load_collections
    @templates = ::Template.all
    @turmas = ::Turma.all
  end

  # Restringe acesso a administradores.
  # @return [void]
  # @side_effect Redireciona com alerta quando não admin
  def require_admin
    redirect_to root_path, alert: "Acesso negado." unless current_user&.role_administrador?
  end
end
