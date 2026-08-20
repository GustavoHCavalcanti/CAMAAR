# lib/criar_template_formulario.rb

# Serviço para criar templates a partir de nomes e listas de questões.
class TemplateCreator
  # templates: array de hashes, ex:
  # [
  #   { id: 1, nome: "Template A", questoes: ["Q1", "Q2"] }
  # ]
  # @param templates [Array<Hash>] coleção existente
  # @return [TemplateCreator]
  def initialize(templates)
    @templates = templates || []
  end

  # Retorna:
  #   :created          → criado com sucesso
  #   :no_questions     → lista de questões vazia
  #   :duplicate_name   → já existe template com esse nome
  # @param nome [String]
  # @param questoes [Array<String>]
  # @return [Symbol] :created, :no_questions ou :duplicate_name
  def create(nome, questoes)
    return :no_questions if questoes.nil? || questoes.empty?

    if nome_duplicado?(nome)
      return :duplicate_name
    end

    novo_template = {
      id: proximo_id,
      nome: nome,
      questoes: questoes
    }

    @templates << novo_template
    :created
  end

  private

  # Verifica duplicidade de nome de template.
  # @param nome [String]
  # @return [Boolean] true se já existir, false caso contrário
  def nome_duplicado?(nome)
    @templates.any? { |t| t[:nome] == nome }
  end

  # Calcula próximo id sequencial.
  # @return [Integer] 1 quando vazio; maior id + 1 caso contrário
  def proximo_id
    return 1 if @templates.empty?

    @templates.map { |t| t[:id] }.max + 1
  end
end
