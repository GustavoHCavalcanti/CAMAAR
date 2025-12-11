# spec/gerenciamento_turmas_departamento_spec.rb
require_relative '../lib/turma_manager'

RSpec.describe TurmaManager do
  let(:admin) do
    { id: 1, nome: "Admin", departamento: "Computação" }
  end

  let(:turmas) do
    [
      {
        codigo: "CIC101 - Turma A",
        departamento: "Computação",
        desempenho: { media: 8.5 }
      },
      {
        codigo: "MAT001 - Turma B",
        departamento: "Matemática",
        desempenho: { media: 7.0 }
      }
    ]
  end

  describe "Listar apenas turmas do departamento do administrador" do
    it 'exibe apenas as turmas do departamento "Computação"' do
      manager = TurmaManager.new(turmas, admin)

      lista = manager.list_for_admin

      expect(lista.map { |t| t[:codigo] }).to include("CIC101 - Turma A")
      expect(lista.map { |t| t[:codigo] }).not_to include("MAT001 - Turma B")
    end
  end

  describe "Gerenciar turma do próprio departamento" do
    it 'permite visualizar desempenho e editar dados da turma' do
      manager = TurmaManager.new(turmas, admin)

      acesso = manager.acesso_turma("CIC101 - Turma A")

      expect(acesso[:status]).to eq(:success)
      expect(acesso[:turma][:codigo]).to eq("CIC101 - Turma A")
      expect(acesso[:pode_editar]).to be true
    end
  end

  describe "Tentativa de acesso a turma de outro departamento" do
    it 'bloqueia o acesso, exibe mensagem e redireciona' do
      manager = TurmaManager.new(turmas, admin)

      acesso = manager.acesso_turma("MAT001 - Turma B")

      expect(acesso[:status]).to eq(:forbidden)
      expect(acesso[:message]).to eq("A turma pertence a outro departamento")
      expect(acesso[:redirect]).to eq(:lista)
    end
  end
end
