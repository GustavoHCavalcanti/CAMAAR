class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :nome
      t.string :email, null: false
      t.string :matricula
      t.string :senha_digest
      t.string :role, default: "aluno"                 # aluno | docente | admin

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :matricula, unique: true
  end
end
