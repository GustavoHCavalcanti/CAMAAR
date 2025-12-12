# Namespace `Respondente` para ações do participante/usuário comum.
class Respondente::FormulariosController < ApplicationController
  before_action :require_login
  layout "respondente"

  # Lista formulários disponíveis e marca quais já foram respondidos pelo usuário atual.
  # @return [void]
  def index
    # Buscar apenas formulários das turmas em que o usuário está matriculado
    turma_ids = current_user.turmas.pluck(:id)
    @formularios = Formulario.where(turma_id: turma_ids)
    
    # Para cada formulário, verificar se o usuário já respondeu
    @respondeu_hash = {}
    @formularios.each do |form|
      @respondeu_hash[form.id] = form.respostas.exists?(user_id: current_user.id)
    end
  end

  # Exibe um formulário para resposta e carrega respostas existentes do usuário, se houver.
  # @return [void]
  def show
    @formulario = ::Formulario.find(params[:id])
    @perguntas = @formulario.template&.questions || []

    # Verificar se o usuário já respondeu
    @ja_respondeu = @formulario.respostas.exists?(user_id: current_user.id)

    # Se já respondeu, carregar as respostas existentes
    if @ja_respondeu
      @respostas_user = @formulario.respostas.where(user_id: current_user.id).index_by(&:question_id)
    end
  end

  # Recebe e persiste respostas do usuário para um formulário.
  # @return [void]
  # @side_effect Cria registros de Resposta; redireciona com aviso em caso de duplicidade ou erro
  def submit
    @formulario = ::Formulario.find(params[:id])
    @perguntas = @formulario.template&.questions || []

    return redirect_to(respondente_formulario_path(@formulario), alert: "Você já respondeu este formulário.") if ja_respondeu?(@formulario)
    return redirect_to(respondente_formulario_path(@formulario), alert: "Formulário sem perguntas.") if @perguntas.empty?

    if salvar_respostas(@formulario, @perguntas)
      redirect_to respondente_formularios_path, notice: "Respostas enviadas com sucesso!"
    else
      redirect_to respondente_formulario_path(@formulario), alert: "Erro ao salvar respostas."
    end
  end

  private

  def ja_respondeu?(formulario)
    formulario.respostas.exists?(user_id: current_user.id)
  end

  def salvar_respostas(formulario, perguntas)
    perguntas.each do |pergunta|
      valor = params["question_#{pergunta.id}"].presence
      next unless valor.present?
      resposta = formulario.respostas.build(user_id: current_user.id, question_id: pergunta.id, valor: valor)
      return false unless resposta.save
    end
    true
  end
end
