class AddTestmodeToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :testmode, :boolean
  end
end
