class AddDefaultValueToDefaultCurrency < ActiveRecord::Migration[4.2]
  def up
    change_column :crms, :default_currency, :string, default: "USD"
  end

  def down
    change_column :crms, :default_currency, :string, default: nil
  end
end
