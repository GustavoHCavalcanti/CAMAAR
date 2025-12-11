class Template < ApplicationRecord
  belongs_to :criador, class_name: "User", optional: true

  has_many :questions, dependent: :destroy
  has_many :formularios

  validates :nome, presence: true, uniqueness: true
end
