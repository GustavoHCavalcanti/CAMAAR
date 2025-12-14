# lib/criar_formulario_avaliacao.rb

# Serviço para criação de formulários de avaliação para múltiplas turmas com base em um template.
class FormularioAvaliacaoCreator
  # Estruturas esperadas:
  #
  # templates = [
  #   { id: 1, nome: "Template Avaliação Disciplina" },
  #   { id: 2, nome: "Template Outro" }
  # ]
  #
  # turmas = [
  #   { id: 10, codigo: "CIC101" },
  #   { id: 11, codigo: "CIC102" }
  # ]
  #
  # formularios = []  # será preenchido com os formulários criados
  #
  def initialize(templates, turmas, formularios)
    @templates   = templates || []
    @turmas      = turmas || []
    @formularios = formularios || []
  end

  # Cria um ou mais formulários de avaliação para as turmas escolhidas.
  #
  # Parâmetros:
  #   template_nome: nome do template selecionado (string)
  #   turma_codigos: array de códigos de turma (ex: ["CIC101", "CIC102"])
  #
  # Retorna:
  #   :created                 -> criação bem-sucedida
  #   :template_nao_selecionado -> nenhum template informado/encontrado
  #   :sem_turmas              -> nenhuma turma escolhida
  #
  def criar_formularios(template_nome:, turma_codigos:)
    template = @templates.find { |t| t[:nome] == template_nome }
    return :template_nao_selecionado if template.nil?

    return :sem_turmas if turma_codigos.nil? || turma_codigos.empty?

    turmas_selecionadas = @turmas.select { |t| turma_codigos.include?(t[:codigo]) }

    turmas_selecionadas.each do |turma|
      @formularios << {
        id: proximo_id,
        template_id: template[:id],
        template_nome: template[:nome],
        turma_id: turma[:id],
        turma_codigo: turma[:codigo],
        status: "Aberto" # por exemplo
      }
    end

    :created
  end

  private

  # Calcula o próximo id sequencial para novo formulário.
  # @return [Integer] 1 quando lista está vazia; maior id + 1 caso contrário
  def proximo_id
    return 1 if @formularios.empty?

    @formularios.map { |f| f[:id] }.max + 1
  end
end
