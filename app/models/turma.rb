class Turma < ApplicationRecord
  has_many :users
  has_many :formularios, dependent: :destroy

  validates :codigo, presence: true, uniqueness: true
  validates :departamento, presence: true
end