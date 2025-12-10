class CreateFormularios < ActiveRecord::Migration[7.1]
  def change
    create_table :formularios do |t|
      t.references :template, null: false, foreign_key: true
      t.references :turma,     null: false, foreign_key: true
      t.string :publico_alvo                 # "docentes" | "discentes"
      t.string :status, default: "aberto"     # aberto | fechado

      t.timestamps
    end
  end
end