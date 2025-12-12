# lib/password_manager.rb

# Serviço de regras de definição e redefinição de senha.
class PasswordManager
  MIN_PASSWORD_LENGTH = 6

  # Representa a lógica de definição de senha (issue-105)
  # @param token_valido [Boolean] indica se o token é aceito
  # @param senha [String] nova senha
  # @param confirmacao [String] confirmação da senha
  # @return [Symbol] :sucesso, :token_invalido, :confirmacao_divergente ou :senha_fraca
  def definir_senha(token_valido:, senha:, confirmacao:)
    return :token_invalido unless token_valido
    return :confirmacao_divergente if senha != confirmacao
    return :senha_fraca unless senha_forte?(senha)

    :sucesso
  end

  # Para a nossa modelagem de domínio, redefinir senha
  # segue as mesmas regras da definição de senha (issue-107).
  # @param token_valido [Boolean]
  # @param senha [String]
  # @param confirmacao [String]
  # @return [Symbol] mesmo contrato de definir_senha
  def redefinir_senha(token_valido:, senha:, confirmacao:)
    definir_senha(token_valido: token_valido, senha: senha, confirmacao: confirmacao)
  end

  private

  # Verifica se a senha atende ao tamanho mínimo configurado.
  # @param senha [String]
  # @return [Boolean] true se forte, false caso contrário
  def senha_forte?(senha)
    senha.length >= MIN_PASSWORD_LENGTH
  end
end
