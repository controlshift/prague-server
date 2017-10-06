class AddStatusToModels < ActiveRecord::Migration[4.2]
  def change
    add_column :charges, :status, :string, default: 'live'
    add_column :customers, :status, :string, default: 'live'
  end
end
