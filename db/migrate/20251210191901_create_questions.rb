class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :template, null: false, foreign_key: true
      t.string :texto, null: false
      t.string :tipo, default: "texto"                # texto | escala | multipla | etc.

      t.timestamps
    end
  end
end