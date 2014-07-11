class AddDefaultCurrencyToCrms < ActiveRecord::Migration
  def change
    add_column :crms, :default_currency, :string
  end
end
