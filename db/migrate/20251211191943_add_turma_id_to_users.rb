class AddTurmaIdToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :turma_id, :integer
    add_index :users, :turma_id
    add_foreign_key :users, :turmas, on_delete: :nullify
  end
end
