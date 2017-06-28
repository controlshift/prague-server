class CalculateOrganizationTotalsWorker
  include Sidekiq::Worker

  def perform(organization_id)
    organization = Organization.find(organization_id)

    # recalculate all of the totals in redis.
    # clear out the organization's DateAggregation total_raised_key and total_charges_count_key
    DateAggregation.new(organization.total_raised_key).delete_all_redis_keys!
    DateAggregation.new(organization.total_charges_count_key).delete_all_redis_keys!

    organization.tags.find_each do |tag|
      tag.reset_redis_keys!
    end

    organization.namespaces.find_each do |namespace|
      namespace.reset_redis_keys!
    end

    organization.charges.paid.find_each do |charge|
      # This mirrors the logic in Charge#update_aggregates
      amt = charge.converted_amount(organization.currency)

      DateAggregation.new(organization.total_raised_key).increment(amt, date: charge.created_at)
      DateAggregation.new(organization.total_charges_count_key).increment(date: charge.created_at)

      charge.tags.find_each do |tag|
        tag.incrby(amt, status: charge.status, charge_date: charge.created_at)
      end
    end
  end
end
