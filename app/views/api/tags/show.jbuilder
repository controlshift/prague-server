json.(@tag, :name, :created_at, :updated_at, :total_raised, :total_charges_count, :average_charge_amount)

json.total_raised_display_amount Charge.presentation_amount(@tag.total_raised, @currency)
json.average_charge_display_amount Charge.presentation_amount(@tag.average_charge_amount, @currency)
