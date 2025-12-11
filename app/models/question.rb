class Question < ApplicationRecord
  belongs_to :template

  serialize :options, type: Array, coder: JSON

  validates :texto, presence: true
  validate :validate_options_for_radio

  private

  def validate_options_for_radio
    if tipo == "radio" && (options.blank? || options.empty?)
      errors.add(:options, "deve ter pelo menos uma opção para tipo radio")
    end
  end
end
