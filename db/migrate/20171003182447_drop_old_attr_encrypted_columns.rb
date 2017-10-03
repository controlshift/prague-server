class DropOldAttrEncryptedColumns < ActiveRecord::Migration
  def up
    remove_column :crms, :encrypted_password_old
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
