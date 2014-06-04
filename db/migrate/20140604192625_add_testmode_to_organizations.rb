class AddTestmodeToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :testmode, :boolean
  end
end
