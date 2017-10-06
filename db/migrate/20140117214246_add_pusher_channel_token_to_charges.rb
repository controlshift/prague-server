class AddPusherChannelTokenToCharges < ActiveRecord::Migration[4.2]
  def change
    add_column :charges, :pusher_channel_token, :string
  end
end
