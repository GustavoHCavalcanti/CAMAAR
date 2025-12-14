class CreateTurmas < ActiveRecord::Migration[7.1]
  def change
    create_table :turmas do |t|
      t.string :codigo, null: false                    # ex: "CIC101 - A"
      t.string :departamento, null: false              # ex: "Computação"
      t.string :semestre                               # ex: "2025/1"

      t.timestamps
    end
  end
end
