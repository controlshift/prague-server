class AddPusherChannelTokenToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :pusher_channel_token, :string
  end
end
