json.(@namespace, :namespace)

json.charges_count @namespace.charges_history(@days) do |day, charge_count|
  json.day day
  json.charge_count charge_count
end

json.raised_amount @namespace.raised_history(@days) do |day, raised|
  json.day day
  json.amount raised
  json.presentation_amount Charge.presentation_amount(raised, @currency)
end