class FixUserTable < ActiveRecord::Migration[8.1]
  def change
    # Renomear coluna senha_digest para password_digest (padrão do has_secure_password)
    rename_column :users, :senha_digest, :password_digest

    # Mudar role de string para integer para suportar enum
    change_column :users, :role, :integer, default: 0
  end
end
