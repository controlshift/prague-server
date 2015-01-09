class AddColumnsToWebhook < ActiveRecord::Migration
  def change
    add_column :webhook_endpoints, :username, :string
    add_column :webhook_endpoints, :password, :string
  end
end
