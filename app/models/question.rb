# Representa uma pergunta de um `Template`, com opções para tipos como "radio".
class Question < ApplicationRecord
  belongs_to :template

  serialize :options, type: Array, coder: JSON

  validates :texto, presence: true
  validate :validate_options_for_radio

  private

  # Garante que perguntas do tipo radio tenham pelo menos uma opção.
  # @return [void]
  # @side_effect Adiciona erro em :options quando inválido
  def validate_options_for_radio
    if tipo == "radio" && (options.blank? || options.empty?)
      errors.add(:options, "deve ter pelo menos uma opção para tipo radio")
    end
  end
end
