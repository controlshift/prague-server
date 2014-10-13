json.array! @charges do |charge|
  json.(charge, :id, :amount, :currency, :charged_back_at, :created_at, :updated_at, :config, :status, :paid, :stripe_url)
  json.display_amount charge.presentation_amount
  json.tags do
    json.array! charge.tags.collect { |t| t.name }
  end
end
