class MigrateEncryptedPasswordToNewAttrEncryptedVersion < ActiveRecord::Migration
  def up
    rename_column :crms, :encrypted_password, :encrypted_password_old

    add_column :crms, :encrypted_password, :string
    add_column :crms, :encrypted_password_iv, :string

    Crm.reset_column_information

    Crm.find_each do |crm|
      crm.password = crm.password_old
      crm.save!
    end
  end

  def down
    remove_column :crms, :encrypted_password
    remove_column :crms, :encrypted_password_iv

    rename_column :crms, :encrypted_password_old, :encrypted_password
  end
end
