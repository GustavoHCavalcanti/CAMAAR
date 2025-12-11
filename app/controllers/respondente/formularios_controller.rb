class Respondente::FormulariosController < ApplicationController
  before_action :require_login
  layout "respondente"

  def index
    @formularios = Formulario.all
    # Para cada formulário, verificar se o usuário já respondeu
    @respondeu_hash = {}
    @formularios.each do |form|
      @respondeu_hash[form.id] = form.respostas.exists?(user_id: current_user.id)
    end
  end

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

  def submit
    @formulario = ::Formulario.find(params[:id])
    @perguntas = @formulario.template&.questions || []

    # Verificar se o usuário já respondeu
    if @formulario.respostas.exists?(user_id: current_user.id)
      redirect_to respondente_formulario_path(@formulario), alert: "Você já respondeu este formulário."
      return
    end

    if @perguntas.empty?
      redirect_to respondente_formulario_path(@formulario), alert: "Formulário sem perguntas."
      return
    end

    # Processar respostas
    success = true
    @perguntas.each do |pergunta|
      resposta_valor = params["question_#{pergunta.id}"].presence
      if resposta_valor.present?
        resposta = @formulario.respostas.build(
          user_id: current_user.id,
          question_id: pergunta.id,
          valor: resposta_valor
        )
        unless resposta.save
          success = false
          break
        end
      end
    end

    if success
      redirect_to respondente_formularios_path, notice: "Respostas enviadas com sucesso!"
    else
      redirect_to respondente_formulario_path(@formulario), alert: "Erro ao salvar respostas."
    end
  end
end
