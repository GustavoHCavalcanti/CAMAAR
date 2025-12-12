# Estrutura simples (POJO) para representar usuário em cenários e testes.
class SimpleUser
  attr_accessor :email, :matricula, :senha, :role

  # Estrutura simples para representar usuário em cenários de teste.
  # @param email [String]
  # @param matricula [String]
  # @param senha [String]
  # @param role [String, Symbol]
  # @return [SimpleUser]
  def initialize(email:, matricula:, senha:, role:)
    @email = email
    @matricula = matricula
    @senha = senha
    @role = role
  end
end
