class AddTituloDescricaoAndFixStatusToFormularios < ActiveRecord::Migration[8.1]
  def change
    add_column :formularios, :titulo, :string, null: false, default: ""
    add_column :formularios, :descricao, :text

      # migrar status de string para integer compatível com enum
      change_column_default :formularios, :status, nil
      change_column :formularios, :status, :integer, using: "CASE WHEN status = 'fechado' THEN 1 ELSE 0 END"
      change_column_default :formularios, :status, 0
      change_column_null :formularios, :status, false, 0
  end
end
