namespace :redis do
  task :set_keys_expiration => :environment do
    stripe_status = ENV['STRIPE_STATUS'] || 'live'
    raise "Invalid STRIPE_STATUS. Only allowed values are: 'test' and 'live'" unless %w(test live).include?(stripe_status)

    # Expire organization aggregation keys
    Organization.find_each do |organization|
      puts "Expiring keys for organization #{organization.name}"
      expire_old_keys_for_stat(organization.total_raised_key)
      expire_old_keys_for_stat(organization.total_charges_count_key)
    end

    # Expire tag aggregation keys
    Tag.find_each do |tag|
      puts "Expiring keys for tag #{tag.name}"
      expire_old_keys_for_stat(tag.total_charges_count_key(stripe_status))
      expire_old_keys_for_stat(tag.total_raised_amount_key(stripe_status))
    end

    # Expire tag namespace aggregation keys
    TagNamespace.find_each do |tag_namespace|
      puts "Expiring keys for tag namespace #{tag_namespace.namespace}"
      expire_old_keys_for_stat(tag_namespace.total_charges_count_key(stripe_status))
      expire_old_keys_for_stat(tag_namespace.total_raised_amount_key(stripe_status))
    end
  end

  def expire_old_keys_for_stat(stat)
    redis = PragueServer::Application.redis
    matching_keys = redis.keys("#{stat}/year:*/month:*/day:*")
    puts "#{matching_keys.count} matching keys found for #{stat}/year:*/month:*/day:*"
    matching_keys.each do |matching_key|
      match_data = matching_key.match(/\/year:(?<year>\d+)\/month:(?<month>\d+)\/day:(?<day>\d+)/)
      key_date = DateTime.new(match_data[:year].to_i, match_data[:month].to_i, match_data[:day].to_i)
      expiration = key_date.to_i + DateAggregation::KEY_EXPIRATION_FOR_DAY_KEYS
      redis.expireat(matching_key, expiration)
    end
  end
end