class Question < ApplicationRecord
  belongs_to :template

  validates :texto, presence: true
end