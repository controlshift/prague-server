class StoreStripeInfoOnCharge < ActiveRecord::Migration
  def change
    add_column :charges, :stripe_id, :string
    add_column :charges, :card, :hstore
  end
end
