class Resposta < ApplicationRecord
  belongs_to :formulario
  belongs_to :user
  belongs_to :question

  validates :valor, presence: true
end