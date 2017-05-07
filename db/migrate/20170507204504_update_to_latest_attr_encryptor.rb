class UpdateToLatestAttrEncryptor < ActiveRecord::Migration
  def change
    add_column :crms, :encrypted_password_iv, :string
  end
end
