class AddStatusToModels < ActiveRecord::Migration
  def change
    add_column :charges, :status, :string, default: 'live'
    add_column :customers, :status, :string, default: 'live'
  end
end
