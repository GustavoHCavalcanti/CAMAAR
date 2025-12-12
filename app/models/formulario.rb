# Representa um formulário de avaliação associado a um `Template` e a uma `Turma`.
# Responsável por agrupar perguntas e armazenar respostas dos participantes.
class Formulario < ApplicationRecord
  belongs_to :template
  belongs_to :turma
  belongs_to :criador, class_name: "User", optional: true

  has_many :respostas, dependent: :destroy

  enum :status, { aberto: 0, fechado: 1 }

  validates :titulo, presence: true
  validates :template_id, presence: true
  validates :turma_id, presence: true
end
