class CreateTurmaUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :turma_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end

    add_index :turma_users, [ :user_id, :turma_id ], unique: true

    # Migrar dados existentes antes de remover a coluna
    reversible do |dir|
      dir.up do
        # Migrar dados existentes de users.turma_id para turma_users
        execute <<-SQL
          INSERT INTO turma_users (user_id, turma_id, created_at, updated_at)
          SELECT id, turma_id, NOW(), NOW()
          FROM users
          WHERE turma_id IS NOT NULL
        SQL
      end
    end

    # Remover a coluna turma_id antiga da tabela users
    remove_foreign_key :users, :turmas if foreign_key_exists?(:users, :turmas)
    remove_column :users, :turma_id, :integer
  end
end
