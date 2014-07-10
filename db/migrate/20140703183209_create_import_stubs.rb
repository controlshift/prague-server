class CreateImportStubs < ActiveRecord::Migration
  def change
    create_table :import_stubs do |t|
      t.belongs_to :crm, index: true
      t.string :payment_account
      t.string :donation_currency

      t.timestamps
    end
  end
end
