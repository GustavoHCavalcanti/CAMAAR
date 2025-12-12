# Usuário do sistema (participante ou administrador), com autenticação via senha.
class User < ApplicationRecord
  has_secure_password

  enum :role, { participante: "participante", administrador: "administrador" }, prefix: true

  has_many :turma_users, dependent: :destroy
  has_many :turmas, through: :turma_users
  has_many :respostas, dependent: :destroy
  has_many :formularios_respondidos, through: :respostas, source: :formulario

  validates :email, presence: true, uniqueness: true
  validates :matricula, presence: true
end
