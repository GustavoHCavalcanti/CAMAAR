class AddStatusAndDescricaoToImportLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :import_logs, :status, :integer
    add_column :import_logs, :descricao, :text
  end
end
