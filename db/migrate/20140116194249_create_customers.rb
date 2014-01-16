class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :customer_token
      t.string :first_name
      t.string :last_name
      t.string :country
      t.string :zip
      t.string :email

      t.timestamps
    end
  end
end
