class AddStripePublishableTestKey < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :stripe_publishable_test_key, :string
  end
end
