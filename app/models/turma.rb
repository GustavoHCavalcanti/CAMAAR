# Representa uma turma acadêmica, agregando usuários e formulários associados.
class Turma < ApplicationRecord
  has_many :turma_users, dependent: :destroy
  has_many :users, through: :turma_users
  has_many :formularios, dependent: :destroy

  validates :codigo, presence: true, uniqueness: true
  validates :departamento, presence: true
end
