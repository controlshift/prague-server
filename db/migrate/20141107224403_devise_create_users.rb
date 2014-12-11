class DeviseCreateUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
    attr_accessor :email, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :reset_password_token,
                  :reset_password_sent_at, :encrypted_password
  end

  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      # Associated with organization
      t.integer :organization_id

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :organization_id
    # add_index :users, :unlock_token,         unique: true

    execute "INSERT into users (email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at,
                                sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, confirmation_token,
                                confirmed_at, confirmation_sent_at, unconfirmed_email, organization_id)
             (SELECT email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count,
                     current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, id
              FROM organizations);"

  end
end
