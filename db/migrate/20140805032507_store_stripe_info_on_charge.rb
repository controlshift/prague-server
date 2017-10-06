class StoreStripeInfoOnCharge < ActiveRecord::Migration[4.2]
  def change
    add_column :charges, :stripe_id, :string
    add_column :charges, :card, :hstore
  end
end
