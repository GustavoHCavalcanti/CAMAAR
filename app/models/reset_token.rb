# Token temporário para operações de redefinição de senha de `User`.
class ResetToken < ApplicationRecord
  belongs_to :user

  before_create :generate_token

  # Indica se o token expirou pelo limite de 2 horas.
  # @return [Boolean] true quando criado há mais de 2 horas, false caso contrário
  def expired?
    created_at < 2.hours.ago
  end

  private

  # Gera um token hexadecimal aleatório antes de criar o registro.
  # @return [void]
  # @side_effect Define self.token com valor único
  def generate_token
    self.token = SecureRandom.hex(20)
  end
end
