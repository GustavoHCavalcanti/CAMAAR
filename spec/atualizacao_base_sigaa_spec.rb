# spec/atualizacao_base_sigaa_spec.rb
require_relative '../lib/atualizacao_base_sigaa'

RSpec.describe BaseAtualizadorSIGAA do
  let(:admin)  { { id: 1, tipo: :admin } }
  let(:comum)  { { id: 2, tipo: :comum } }

  let(:base_local) do
    {
      turmas:    [{ codigo: "CIC101" }],
      usuarios:  [{ matricula: "111" }],
      materias:  [{ codigo: "MAT001" }]
    }
  end

  describe "Atualização bem-sucedida" do
    it 'substitui a base local pelos dados do SIGAA' do
      sigaa_service = double("SIGAA")

      novos_dados = {
        turmas:    [{ codigo: "CIC202" }],
        usuarios:  [{ matricula: "222" }],
        materias:  [{ codigo: "FIS001" }]
      }

      allow(sigaa_service).to receive(:fetch_data).and_return(novos_dados)

      atualizador = BaseAtualizadorSIGAA.new(base_local, sigaa_service)

      resultado = atualizador.atualizar(admin)

      expect(resultado).to eq(:sucesso)
      expect(base_local[:turmas]).to eq([{ codigo: "CIC202" }])
      expect(base_local[:usuarios]).to eq([{ matricula: "222" }])
      expect(base_local[:materias]).to eq([{ codigo: "FIS001" }])
    end
  end

  describe "Falha na comunicação com o SIGAA" do
    it 'não altera a base e retorna mensagem de falha' do
      sigaa_service = double("SIGAA")
      allow(sigaa_service).to receive(:fetch_data).and_raise(SigaaCommunicationError)

      base_original = base_local.dup

      atualizador = BaseAtualizadorSIGAA.new(base_local, sigaa_service)

      resultado = atualizador.atualizar(admin)

      expect(resultado).to eq(:falha_comunicacao)
      expect(base_local).to eq(base_original)
    end
  end

  describe "Dados inconsistentes retornados pelo SIGAA" do
    it 'abort a atualização e retorna erro de inconsistência' do
      sigaa_service = double("SIGAA")
      allow(sigaa_service).to receive(:fetch_data).and_return(nil)

      base_original = base_local.dup
      atualizador = BaseAtualizadorSIGAA.new(base_local, sigaa_service)

      resultado = atualizador.atualizar(admin)

      expect(resultado).to eq(:dados_inconsistentes)
      expect(base_local).to eq(base_original)
    end
  end

  describe "Administrador tenta atualizar sem permissão" do
    it 'bloqueia o acesso e não altera os dados' do
      sigaa_service = double("SIGAA")

      base_original = base_local.dup
      atualizador = BaseAtualizadorSIGAA.new(base_local, sigaa_service)

      resultado = atualizador.atualizar(comum)

      expect(resultado).to eq(:acesso_negado)
      expect(base_local).to eq(base_original)
    end
  end
end
