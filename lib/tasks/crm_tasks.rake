namespace :crm do
  task :resync_charges => :environment do
    raise ArgumentError.new('Missing ORGANIZATION_SLUG argument') unless ENV['ORGANIZATION_SLUG'].present?

    organization = Organization.find_by_slug(ENV['ORGANIZATION_SLUG'])
    raise ArgumentError.new("Organization with slug #{ENV['ORGANIZATION_SLUG']} not found.") if organization.nil?

    charges_scope = nil
    case organization.crm.platform
    when 'actionkit'
      charges_scope = organization.charges.paid.where('external_id IS NOT NULL')
    when 'bluestate'
      charges_scope = organization.charges.paid
    else
      raise "No notifier for #{organization.crm.platform}"
    end

    charges_to_resync = nil
    if ENV['FROM_DATE'].present?
      from_date = Time.parse(ENV['FROM_DATE'])
      charges_to_resync = charges_scope.where('created_at > ?', from_date)
    else
      charges_to_resync = charges_scope
    end

    charges_to_resync.select(:id).each do |charge_to_resync|
      CrmNotificationWorker.perform_async(charge_to_resync.id)
    end
  end
end
