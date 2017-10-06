class DropOldAttrEncryptedColumns < ActiveRecord::Migration[4.2]
  def up
    remove_column :crms, :encrypted_password_old
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
