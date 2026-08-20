class RenameSenhaDigestToPasswordDigest < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :senha_digest, :password_digest
  end
end
