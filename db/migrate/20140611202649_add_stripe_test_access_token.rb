class AddStripeTestAccessToken < ActiveRecord::Migration
  def change
    add_column :organizations, :stripe_test_access_token, :string
  end
end
