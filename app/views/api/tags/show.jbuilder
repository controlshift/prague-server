json.(@tag, :name, :created_at, :updated_at, :total_raised, :total_charges_count)

json.total_raised_display_amount Charge.presentation_amount(@tag.total_raised, @currency)
