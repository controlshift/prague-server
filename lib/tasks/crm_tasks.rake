namespace :crm do
  task :resync_charges => :environment do
    raise ArgumentError.new('Missing ORGANIZATION_SLUG argument') unless ENV['ORGANIZATION_SLUG'].present?

    organization = Organization.find_by_slug(ENV['ORGANIZATION_SLUG'])
    raise ArgumentError.new("Organization with slug #{ENV['ORGANIZATION_SLUG']} not found.") if organization.nil?

    charges_to_resync = nil
    case organization.crm.platform
    when 'actionkit'
      charges_to_resync = organization.charges.paid.where(external_id: nil)
    when 'bluestate'
      charges_to_resync = organization.charges.paid.where("(SELECT COUNT(*) FROM log_entries WHERE log_entries.charge_id = charges.id AND log_entries.message = 'Synchronized to Blue State Digital') = 0")
    else
      raise "No notifier for #{organization.crm.platform}"
    end

    charges_to_resync.select(:id).each do |charge_to_resync|
      CrmNotificationWorker.perform_async(charge_to_resync.id)
    end
  end
end
