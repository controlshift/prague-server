json.array! @most_raised do |most_raised_tag|
  json.tag most_raised_tag[:tag]
  json.raised most_raised_tag[:raised]
  json.raised_display_amount Charge.presentation_amount(most_raised_tag[:raised], @currency)
  json.currency @currency
end
