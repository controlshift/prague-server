class AddDefaultCurrencyToCrms < ActiveRecord::Migration[4.2]
  def change
    add_column :crms, :default_currency, :string
  end
end
