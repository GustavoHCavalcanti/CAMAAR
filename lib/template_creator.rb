# lib/criar_template_formulario.rb

class TemplateCreator
  # templates: array de hashes, ex:
  # [
  #   { id: 1, nome: "Template A", questoes: ["Q1", "Q2"] }
  # ]
  def initialize(templates)
    @templates = templates || []
  end

  # Retorna:
  #   :created          → criado com sucesso
  #   :no_questions     → lista de questões vazia
  #   :duplicate_name   → já existe template com esse nome
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

  def nome_duplicado?(nome)
    @templates.any? { |t| t[:nome] == nome }
  end

  def proximo_id
    return 1 if @templates.empty?

    @templates.map { |t| t[:id] }.max + 1
  end
end
