class Resposta < ApplicationRecord
  self.table_name = "respostas"

  belongs_to :formulario
  belongs_to :user
  belongs_to :question

  validates :valor, presence: true
end
