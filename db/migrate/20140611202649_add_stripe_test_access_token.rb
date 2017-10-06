class AddStripeTestAccessToken < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :stripe_test_access_token, :string
  end
end
