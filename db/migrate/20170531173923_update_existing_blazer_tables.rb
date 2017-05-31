class UpdateExistingBlazerTables < ActiveRecord::Migration
  def change
    add_column :blazer_queries, :data_source, :string
    add_column :blazer_audits, :data_source, :string
  end
end
