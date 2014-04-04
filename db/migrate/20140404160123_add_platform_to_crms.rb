class AddPlatformToCrms < ActiveRecord::Migration
  def change
    add_column :crms, :platform, :string
  end
end
