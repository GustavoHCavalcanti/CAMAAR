# lib/authenticator.rb

class AuthUser
  attr_reader :email, :matricula, :senha, :role

  # Cria um usuário simples para autenticação estática.
  # @param email [String] email cadastrado
  # @param matricula [String] matrícula institucional
  # @param senha [String] senha em texto simples (mock)
  # @param role [Symbol] :respondente ou :admin
  # @return [AuthUser]
  def initialize(email:, matricula:, senha:, role:)
    @email = email
    @matricula = matricula
    @senha = senha
    @role = role # :respondente ou :admin
  end
end

class Authenticator
  class InvalidCredentials < StandardError; end

  # Inicializa o autenticador com usuários estáticos (mock).
  # @return [Authenticator]
  def initialize
    # Por enquanto vamos deixar os usuários "hardcoded",
    # exatamente como no BDD da issue-104
    @users = [
      AuthUser.new(
        email: "usuario@unb.br",
        matricula: "202300000",
        senha: "SenhaValida123",
        role: :respondente
      ),
      AuthUser.new(
        email: "admin@unb.br",
        matricula: "ADM0001",
        senha: "SenhaAdmin123",
        role: :admin
      )
    ]
  end

  # identificador = email OU matrícula
  # @param identificador [String] email ou matrícula
  # @param senha [String] senha informada
  # @return [AuthUser] usuário autenticado
  # @raise [InvalidCredentials] quando não encontra usuário ou senha diverge
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
