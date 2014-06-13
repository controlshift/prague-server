class FixUniqueEmailIndex < ActiveRecord::Migration
  def change
    remove_index :customers, :email
    add_index :customers, [:email, :status], :unique => true
  end
end
