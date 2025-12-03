# lib/cadastrar_usuarios_sistema.rb

class UserRegistrar
  # Estrutura esperada:
  #
  # users = [
  #   { id: 1, matricula: "111", nome: "João", status: :ativo },
  #   { id: 2, matricula: "222", nome: "Maria", status: :pendente_senha }
  # ]
  #
  # sigaa_users = [
  #   { matricula: "333", nome: "Ana" },
  #   { matricula: "111", nome: "João" } # já existe
  # ]
  #
  def initialize(users)
    @users = users || []
  end

  # Cadastra usuários vindos do SIGAA.
  #
  # Retorna:
  #   :created_some  -> quando pelo menos um novo usuário foi criado
  #   :none_created  -> quando nenhum novo usuário foi criado (todos já existiam)
  #
  def cadastrar(sigaa_users)
    sigaa_users ||= []
    novos_criados = 0

    sigaa_users.each do |s_user|
      next if usuario_ja_existe?(s_user[:matricula])

      @users << {
        id: proximo_id,
        matricula: s_user[:matricula],
        nome: s_user[:nome],
        status: :pendente_senha # aguardando definição de senha
      }
      novos_criados += 1
    end

    return :none_created if novos_criados.zero?

    :created_some
  end

  private

  def usuario_ja_existe?(matricula)
    @users.any? { |u| u[:matricula] == matricula }
  end

  def proximo_id
    return 1 if @users.empty?

    @users.map { |u| u[:id] }.max + 1
  end
end
