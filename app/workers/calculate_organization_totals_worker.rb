class CalculateOrganizationTotalsWorker
  include Sidekiq::Worker

  def perform(organization_id)
    organization = Organization.find(organization_id)

    # recalculate all of the totals in redis.
    organization.tags.find_each do |tag|
      tag.reset_redis_keys!
    end

    organization.namespaces.find_each do |namespace|
      namespace.reset_redis_keys!
    end

    organization.charges.paid.find_each do |charge|
      charge.tags.find_each do |tag|
        tag.incrby(charge.converted_amount(organization.currency), charge.status)
      end
    end
  end
end
