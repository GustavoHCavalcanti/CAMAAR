# spec/cadastrar_usuarios_sistema_spec.rb
require_relative '../lib/cadastrar_usuarios_sistema'

RSpec.describe UserRegistrar do
  let(:users) do
    [
      { id: 1, matricula: "111", nome: "João", status: :ativo }
    ]
  end

  describe "Cadastro de novos participantes (feliz)" do
    it 'cria registros pendentes de definição de senha para usuários que não existem na base' do
      registrar = UserRegistrar.new(users)

      sigaa_users = [
        { matricula: "111", nome: "João" },   # já existe
        { matricula: "222", nome: "Maria" },  # novo
        { matricula: "333", nome: "Ana" }     # novo
      ]

      resultado = registrar.cadastrar(sigaa_users)

      expect(resultado).to eq(:created_some)

      # usuários antigos continuam
      expect(users.any? { |u| u[:matricula] == "111" }).to be true

      # novos usuários criados como pendentes
      maria = users.find { |u| u[:matricula] == "222" }
      ana   = users.find { |u| u[:matricula] == "333" }

      expect(maria).not_to be_nil
      expect(maria[:status]).to eq(:pendente_senha)

      expect(ana).not_to be_nil
      expect(ana[:status]).to eq(:pendente_senha)

      # total: 1 antigo + 2 novos
      expect(users.size).to eq(3)
    end
  end

  describe "Usuários já cadastrados (triste)" do
    it 'não cria registros duplicados quando todos já existem na base' do
      registrar = UserRegistrar.new(users)

      sigaa_users = [
        { matricula: "111", nome: "João" } # já existe
      ]

      resultado = registrar.cadastrar(sigaa_users)

      expect(resultado).to eq(:none_created)
      expect(users.size).to eq(1)

      # garante que não duplicou o mesmo usuário
      repetidos = users.select { |u| u[:matricula] == "111" }
      expect(repetidos.size).to eq(1)
    end
  end
end
