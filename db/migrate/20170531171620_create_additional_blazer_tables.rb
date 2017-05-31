class CreateAdditionalBlazerTables < ActiveRecord::Migration
  def change
    create_table :blazer_dashboards do |t|
      t.text :name
      t.timestamps
    end

    create_table :blazer_dashboard_queries do |t|
      t.references :dashboard
      t.references :query
      t.integer :position
      t.timestamps
    end

    create_table :blazer_checks do |t|
      t.references :query
      t.string :state
      t.text :emails
      t.timestamps
    end
  end
end
