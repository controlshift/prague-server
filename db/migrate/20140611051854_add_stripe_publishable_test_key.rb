class AddStripePublishableTestKey < ActiveRecord::Migration
  def change
    add_column :organizations, :stripe_publishable_test_key, :string
  end
end
