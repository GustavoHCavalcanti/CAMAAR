class ImportLog < ApplicationRecord
  enum status: { sucesso: 0, inconsistente: 1, falha: 2 }

  validates :descricao, presence: true
end