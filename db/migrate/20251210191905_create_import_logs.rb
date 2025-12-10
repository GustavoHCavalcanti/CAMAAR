class CreateImportLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :import_logs do |t|
      t.string :arquivo
      t.integer :novos_registros
      t.integer :registros_existentes
      t.text :mensagem

      t.timestamps
    end
  end
end