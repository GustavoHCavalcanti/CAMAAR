# spec/criar_template_formulario_spec.rb
require_relative '../lib/criar_template_formulario'

RSpec.describe TemplateCreator do
  let(:templates) do
    [
      { id: 1, nome: "Template Existente", questoes: ["Q1"] }
    ]
  end

  describe "Criação de template com sucesso (feliz)" do
    it 'salva o template e o disponibiliza para uso em novos formulários' do
      creator = TemplateCreator.new(templates)

      resultado = creator.create("Template Avaliação Turma", ["Questão 1", "Questão 2"])

      expect(resultado).to eq(:created)
      novo = templates.find { |t| t[:nome] == "Template Avaliação Turma" }

      expect(novo).not_to be_nil
      expect(novo[:questoes]).to eq(["Questão 1", "Questão 2"])
      # continua existindo o template antigo também
      expect(templates.size).to eq(2)
    end
  end

  describe "Tentativa de criar template sem questões (triste)" do
    it 'impede a criação quando a lista de questões está vazia' do
      creator = TemplateCreator.new(templates)

      resultado = creator.create("Template Sem Questões", [])

      expect(resultado).to eq(:no_questions)
      # não altera a lista de templates
      expect(templates.size).to eq(1)
      expect(templates.any? { |t| t[:nome] == "Template Sem Questões" }).to be false
    end
  end

  describe "Tentativa de criar template com nome duplicado (triste)" do
    it 'rejeita a criação e não altera os templates existentes' do
      creator = TemplateCreator.new(templates)

      resultado = creator.create("Template Existente", ["Nova Questão"])

      expect(resultado).to eq(:duplicate_name)
      # continua existindo apenas o template original
      expect(templates.size).to eq(1)
      template = templates.find { |t| t[:nome] == "Template Existente" }
      expect(template[:questoes]).to eq(["Q1"])
    end
  end
end
