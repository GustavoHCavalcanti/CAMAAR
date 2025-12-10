class CreateResetTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :reset_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token, null: false
      t.datetime :expira_em

      t.timestamps
    end

    add_index :reset_tokens, :token, unique: true
  end
end