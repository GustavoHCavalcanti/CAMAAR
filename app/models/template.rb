# Define a estrutura de perguntas reutilizável para criação de `Formularios`.
class Template < ApplicationRecord
  belongs_to :criador, class_name: "User", optional: true

  has_many :questions, dependent: :destroy
  has_many :formularios, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank

  validates :nome, presence: true, uniqueness: true
end
