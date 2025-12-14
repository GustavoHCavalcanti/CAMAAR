class CreateRespostas < ActiveRecord::Migration[7.1]
  def change
    create_table :respostas do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :question,   null: false, foreign_key: true
      t.references :user,       null: false, foreign_key: true

      t.text :valor

      t.timestamps
    end
  end
end
