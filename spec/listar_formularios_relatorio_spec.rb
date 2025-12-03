# spec/listar_formularios_relatorio_spec.rb
require_relative '../lib/listar_formularios_relatorio'

RSpec.describe FormManager do
  let(:admin_id) { 1 }
  let(:other_id) { 2 }

  let(:forms) do
    [
      {
        id: 1,
        codigo: "F-CIC101",
        turma: "CIC101",
        owner_id: admin_id,
        status: "Fechado",
        respostas: 10
      },
      {
        id: 2,
        codigo: "F-MAT001",
        turma: "MAT001",
        owner_id: other_id,
        status: "Aberto",
        respostas: 5
      }
    ]
  end

  describe "Visualizar e filtrar formulários criados" do
    it 'exibe formulário com contagem de respostas' do
      manager = FormManager.new(forms)

      lista = manager.list_for(admin_id)

      cic101 = lista.find { |f| f[:codigo] == "F-CIC101" }

      expect(cic101[:respostas]).to eq(10)
      expect(cic101[:can_generate_report]).to be true
    end

    it 'permite filtrar por turma' do
      manager = FormManager.new(forms)

      filtrado = manager.list_for(admin_id, turma: "CIC101")

      expect(filtrado.size).to eq(1)
      expect(filtrado.first[:codigo]).to eq("F-CIC101")
    end

    it 'permite filtrar por status' do
      manager = FormManager.new(forms)

      filtrado = manager.list_for(admin_id, status: "Aberto")

      expect(filtrado.size).to eq(1)
      expect(filtrado.first[:codigo]).to eq("F-MAT001")
    end
  end

  describe "Acesso à geração de relatório" do
    it 'abre a tela de configuração quando o formulário tem respostas' do
      manager = FormManager.new(forms)

      resultado = manager.open_report("F-CIC101")

      expect(resultado).to eq(:open_report_config)
    end
  end

  describe "Formulário sem respostas" do
    it 'impede geração de relatório e retorna mensagem de erro' do
      forms << {
        id: 3,
        codigo: "F-MAT100",
        turma: "MAT100",
        owner_id: admin_id,
        status: "Fechado",
        respostas: 0
      }

      manager = FormManager.new(forms)

      resultado = manager.open_report("F-MAT100")

      expect(resultado).to eq(:no_responses)
    end
  end
end
