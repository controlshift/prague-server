class RemoveFieldsFromOrganization < ActiveRecord::Migration
  def self.up
    remove_column :organizations, :email
    remove_column :organizations, :remember_created_at
    remove_column :organizations, :sign_in_count
    remove_column :organizations, :current_sign_in_at
    remove_column :organizations, :last_sign_in_at
    remove_column :organizations, :current_sign_in_ip
    remove_column :organizations, :last_sign_in_ip
    remove_column :organizations, :encrypted_password
    remove_column :organizations, :reset_password_token
    remove_column :organizations, :reset_password_sent_at
    remove_column :organizations, :confirmation_token
    remove_column :organizations, :confirmed_at
    remove_column :organizations, :confirmation_sent_at
    remove_column :organizations, :unconfirmed_email
  end

  def self.down
    add_column :organizations, :email, :string
    add_column :organizations, :remember_created_at, :datetime
    add_column :organizations, :sign_in_count, :integer, default: 0, null: false
    add_column :organizations, :current_sign_in_at, :datetime
    add_column :organizations, :last_sign_in_at, :datetime
    add_column :organizations, :current_sign_in_ip, :string
    add_column :organizations, :last_sign_in_ip, :string
    add_column :organizations, :encrypted_password, :string, default: '', null: false
    add_column :organizations, :reset_password_token, :string
    add_column :organizations, :reset_password_sent_at, :datetime
    add_column :organizations, :confirmation_token, :string
    add_column :organizations, :confirmed_at, :datetime
    add_column :organizations, :confirmation_sent_at, :datetime
    add_column :organizations, :unconfirmed_email, :string
  end
end
