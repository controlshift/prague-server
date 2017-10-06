class AddRefreshToken < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :refresh_token, :string
    add_column :organizations, :stripe_live_mode, :boolean
  end
end
