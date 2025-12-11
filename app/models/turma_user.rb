class TurmaUser < ApplicationRecord
  belongs_to :user
  belongs_to :turma

  validates :user_id, uniqueness: { scope: :turma_id, message: "já está matriculado nesta turma" }
end
