class AddRefreshToken < ActiveRecord::Migration
  def change
    add_column :organizations, :refresh_token, :string
    add_column :organizations, :stripe_live_mode, :boolean
  end
end
