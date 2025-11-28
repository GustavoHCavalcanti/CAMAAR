# lib/authenticator.rb

class User
  attr_reader :email, :matricula, :senha, :role

  def initialize(email:, matricula:, senha:, role:)
    @email = email
    @matricula = matricula
    @senha = senha
    @role = role # :respondente ou :admin
  end
end

class Authenticator
  class InvalidCredentials < StandardError; end

  def initialize
    # Por enquanto vamos deixar os usuários "hardcoded",
    # exatamente como no BDD da issue-104
    @users = [
      User.new(
        email: "usuario@unb.br",
        matricula: "202300000",
        senha: "SenhaValida123",
        role: :respondente
      ),
      User.new(
        email: "admin@unb.br",
        matricula: "ADM0001",
        senha: "SenhaAdmin123",
        role: :admin
      )
    ]
  end

  # identificador = email OU matrícula
  def login(identificador:, senha:)
    user = @users.find do |u|
      u.email == identificador || u.matricula == identificador
    end

    # se não achou usuário ou senha não confere → erro
    unless user && user.senha == senha
      raise InvalidCredentials, "Credenciais inválidas"
    end

    user
  end
end
