# spec/criacao_formulario_publico_alvo_spec.rb
require_relative '../lib/criacao_formulario_publico_alvo'

RSpec.describe FormularioPublicoAlvoCreator do
  let(:templates) do
    [
      { id: 1, nome: "Avaliação de Disciplina" },
      { id: 2, nome: "Avaliação do Docente" }
    ]
  end

  let(:turmas) do
    [
      { id: 1, codigo: "CIC101" }
    ]
  end

  let(:formularios)   { [] }
  let(:notificacoes)  { [] }

  describe "Criação de formulário para discentes (padrão)" do
    it 'cria o formulário para os discentes da turma e os notifica' do
      creator = FormularioPublicoAlvoCreator.new(templates, turmas, formularios, notificacoes)

      resultado = creator.criar_formulario(
        template_nome: "Avaliação de Disciplina",
        turma_codigo: "CIC101",
        publico_alvo: "Discentes"
      )

      expect(resultado).to eq(:created)
      expect(formularios.size).to eq(1)

      formulario = formularios.first
      expect(formulario[:template_id]).to eq(1)
      expect(formulario[:turma_codigo]).to eq("CIC101")
      expect(formulario[:publico_alvo]).to eq(:discentes)
      expect(formulario[:disponivel]).to be true

      # notificação para discentes de CIC101
      expect(notificacoes.size).to eq(1)
      notif = notificacoes.first
      expect(notif[:turma_codigo]).to eq("CIC101")
      expect(notif[:publico]).to eq(:discentes)
      expect(notif[:formulario_id]).to eq(formulario[:id])
    end
  end

  describe "Criação de formulário para docentes" do
    it 'cria o formulário para os docentes da turma e os notifica' do
      creator = FormularioPublicoAlvoCreator.new(templates, turmas, formularios, notificacoes)

      resultado = creator.criar_formulario(
        template_nome: "Avaliação do Docente",
        turma_codigo: "CIC101",
        publico_alvo: "Docentes"
      )

      expect(resultado).to eq(:created)
      expect(formularios.size).to eq(1)

      formulario = formularios.first
      expect(formulario[:template_id]).to eq(2)
      expect(formulario[:turma_codigo]).to eq("CIC101")
      expect(formulario[:publico_alvo]).to eq(:docentes)

      expect(notificacoes.size).to eq(1)
      notif = notificacoes.first
      expect(notif[:turma_codigo]).to eq("CIC101")
      expect(notif[:publico]).to eq(:docentes)
      expect(notif[:formulario_id]).to eq(formulario[:id])
    end
  end

  describe "Tentativa de criação sem seleção de público-alvo" do
    it 'impede a criação quando o público-alvo não é selecionado' do
      creator = FormularioPublicoAlvoCreator.new(templates, turmas, formularios, notificacoes)

      resultado = creator.criar_formulario(
        template_nome: "Avaliação de Disciplina",
        turma_codigo: "CIC101",
        publico_alvo: nil # omitido
      )

      expect(resultado).to eq(:publico_nao_selecionado)
      expect(formularios).to be_empty
      expect(notificacoes).to be_empty
    end
  end
end
