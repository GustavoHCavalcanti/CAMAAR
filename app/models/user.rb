class User < ApplicationRecord
  has_secure_password

  enum :role, { participante: "participante", administrador: "administrador" }, prefix: true

  belongs_to :turma, optional: true
  has_many :respostas, dependent: :destroy
  has_many :formularios_respondidos, through: :respostas, source: :formulario

  validates :email, presence: true, uniqueness: true
  validates :matricula, presence: true
end
