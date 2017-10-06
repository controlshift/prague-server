class UpdateExistingBlazerTables < ActiveRecord::Migration[4.2]
  def change
    add_column :blazer_queries, :data_source, :string
    add_column :blazer_audits, :data_source, :string
  end
end
