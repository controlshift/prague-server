class AddPlatformToCrms < ActiveRecord::Migration[4.2]
  def change
    add_column :crms, :platform, :string
  end
end
