json.(@tag, :name)

json.charges_count @tag.charges_history(@days) do |day, charge_count|
  json.day day
  json.charge_count charge_count
end

json.raised_amount @tag.raised_history(@days) do |day, raised|
  json.day day
  json.amount raised
  json.presentation_amount Charge.presentation_amount(raised, @currency)
end