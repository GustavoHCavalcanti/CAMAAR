# spec/criar_formulario_avaliacao_spec.rb
require_relative '../lib/formulario_avaliacao_creator'

RSpec.describe FormularioAvaliacaoCreator do
  let(:templates) do
    [
      { id: 1, nome: "Avaliação de Disciplina" }
    ]
  end

  let(:turmas) do
    [
      { id: 10, codigo: "CIC101" },
      { id: 11, codigo: "CIC102" }
    ]
  end

  let(:formularios) { [] }

  describe "Criação de formulário com sucesso (feliz)" do
    it 'cria um formulário associado à turma escolhida' do
      creator = FormularioAvaliacaoCreator.new(templates, turmas, formularios)

      resultado = creator.criar_formularios(
        template_nome: "Avaliação de Disciplina",
        turma_codigos: [ "CIC101" ]
      )

      expect(resultado).to eq(:created)
      expect(formularios.size).to eq(1)

      form = formularios.first
      expect(form[:template_id]).to eq(1)
      expect(form[:turma_codigo]).to eq("CIC101")
      expect(form[:status]).to eq("Aberto")
    end
  end

  describe "Criação de formulário para várias turmas (feliz)" do
    it 'cria um formulário independente para cada turma selecionada' do
      creator = FormularioAvaliacaoCreator.new(templates, turmas, formularios)

      resultado = creator.criar_formularios(
        template_nome: "Avaliação de Disciplina",
        turma_codigos: [ "CIC101", "CIC102" ]
      )

      expect(resultado).to eq(:created)
      expect(formularios.size).to eq(2)

      cic101 = formularios.find { |f| f[:turma_codigo] == "CIC101" }
      cic102 = formularios.find { |f| f[:turma_codigo] == "CIC102" }

      expect(cic101).not_to be_nil
      expect(cic102).not_to be_nil
      expect(cic101[:id]).not_to eq(cic102[:id]) # independentes
    end
  end

  describe "Tentativa de criação sem template selecionado (triste)" do
    it 'impede a criação quando nenhum template é selecionado' do
      creator = FormularioAvaliacaoCreator.new(templates, turmas, formularios)

      resultado = creator.criar_formularios(
        template_nome: nil,
        turma_codigos: [ "CIC101" ]
      )

      expect(resultado).to eq(:template_nao_selecionado)
      expect(formularios).to be_empty
    end
  end

  describe "Tentativa de criação sem turmas associadas (triste)" do
    it 'rejeita a criação quando nenhuma turma é escolhida' do
      creator = FormularioAvaliacaoCreator.new(templates, turmas, formularios)

      resultado = creator.criar_formularios(
        template_nome: "Avaliação de Disciplina",
        turma_codigos: []
      )

      expect(resultado).to eq(:sem_turmas)
      expect(formularios).to be_empty
    end
  end
end
