class SimpleUser
  attr_accessor :email, :matricula, :senha, :role

  def initialize(email:, matricula:, senha:, role:)
    @email = email
    @matricula = matricula
    @senha = senha
    @role = role
  end
end
