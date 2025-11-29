# lib/password_manager.rb

class PasswordManager
  MIN_PASSWORD_LENGTH = 6

  # Representa a lógica de definição de senha (issue-105)
  def definir_senha(token_valido:, senha:, confirmacao:)
    return :token_invalido unless token_valido
    return :confirmacao_divergente if senha != confirmacao
    return :senha_fraca unless senha_forte?(senha)

    :sucesso
  end

  # Para a nossa modelagem de domínio, redefinir senha
  # segue as mesmas regras da definição de senha (issue-107).
  def redefinir_senha(token_valido:, senha:, confirmacao:)
    definir_senha(token_valido: token_valido, senha: senha, confirmacao: confirmacao)
  end

  private

  def senha_forte?(senha)
    senha.length >= MIN_PASSWORD_LENGTH
  end
end
