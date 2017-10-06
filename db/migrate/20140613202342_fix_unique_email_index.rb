class FixUniqueEmailIndex < ActiveRecord::Migration[4.2]
  def change
    remove_index :customers, :email
    add_index :customers, [:email, :status], :unique => true
  end
end
