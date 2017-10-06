class CreateCharges < ActiveRecord::Migration[4.2]
  def change
    create_table :charges do |t|
      t.string :amount
      t.string :currency
      t.belongs_to :customer, index: true
      t.belongs_to :organization, index: true
      t.datetime :charged_back_at

      t.timestamps
    end
  end
end
