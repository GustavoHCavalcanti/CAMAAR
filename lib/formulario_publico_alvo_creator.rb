# lib/criacao_formulario_publico_alvo.rb

# Serviço para criação de formulário direcionado ao público alvo (discentes/docentes) de uma turma.
class FormularioPublicoAlvoCreator
  # Estruturas esperadas:
  #
  # templates = [
  #   { id: 1, nome: "Avaliação de Disciplina" },
  #   { id: 2, nome: "Avaliação do Docente" }
  # ]
  #
  # turmas = [
  #   { id: 1, codigo: "CIC101" }
  # ]
  #
  # formularios = []  # será preenchido com formulários criados
  # notificacoes = [] # registros de notificação
  #
  def initialize(templates, turmas, formularios, notificacoes)
    @templates = templates || []
    @turmas = turmas || []
    @formularios = formularios || []
    @notificacoes = notificacoes || []
  end

  # publico_alvo: "Discentes" ou "Docentes" (string, como viria da UI)
  #
  # Retorna:
  #   :created              -> criado com sucesso
  #   :publico_nao_selecionado -> quando publico_alvo é nil/""/inválido
  #   :template_nao_encontrado  -> template inexistente
  #   :turma_nao_encontrada     -> turma inexistente
  #
  def criar_formulario(template_nome:, turma_codigo:, publico_alvo:)
    template = @templates.find { |t| t[:nome] == template_nome }
    return :template_nao_encontrado unless template

    turma = @turmas.find { |t| t[:codigo] == turma_codigo }
    return :turma_nao_encontrada unless turma

    tipo_publico = normalizar_publico(publico_alvo)
    return :publico_nao_selecionado if tipo_publico.nil?

    formulario = {
      id: proximo_id,
      nome: "Formulário - #{template[:nome]} - #{turma[:codigo]} - #{tipo_publico.to_s.capitalize}",
      template_id: template[:id],
      turma_id: turma[:id],
      turma_codigo: turma[:codigo],
      publico_alvo: tipo_publico, # :discentes ou :docentes
      disponivel: true
    }

    @formularios << formulario
    registrar_notificacao(turma[:codigo], tipo_publico, formulario[:id])

    :created
  end

  private

  # Normaliza o público alvo recebido da UI para símbolo.
  # @param publico_alvo [String]
  # @return [Symbol, nil] :discentes, :docentes ou nil quando inválido
  def normalizar_publico(publico_alvo)
    case publico_alvo.to_s.strip.downcase
    when 'discentes'
      :discentes
    when 'docentes'
      :docentes
    else
      nil
    end
  end

  # Calcula o próximo id sequencial de formulário.
  # @return [Integer] 1 quando vazio; maior id + 1 quando houver registros
  def proximo_id
    return 1 if @formularios.empty?

    @formularios.map { |f| f[:id] }.max + 1
  end

  # Registra notificação gerada para a turma/público informado.
  # @param codigo_turma [String]
  # @param tipo_publico [Symbol]
  # @param formulario_id [Integer]
  # @return [void]
  # @side_effect Insere hash em @notificacoes
  def registrar_notificacao(codigo_turma, tipo_publico, formulario_id)
    @notificacoes << {
      turma_codigo: codigo_turma,
      publico: tipo_publico,  # :discentes ou :docentes
      formulario_id: formulario_id
    }
  end
end
