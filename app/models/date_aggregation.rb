class DateAggregation
  attr_accessor :stat

  KEY_EXPIRATION_FOR_DAY_KEYS = 3.months.to_i

  def initialize(stat)
    self.stat = stat
  end

  def redis
    PragueServer::Application.redis
  end

  def last_7_days
   history(7)
  end

  def history(days_to_display = 7)
    stats = {}
    ((days_to_display-1).days.ago.to_date..Time.zone.today).each do |day|
      stats[day] = redis.get(day_key(day.day, day.month, day.year)).to_i
    end
    stats
  end

  def increment(amount = 1, date:)
    redis.multi do
      keys(date).each do |key, expiration|
        redis.incrby(key, amount)
        if expiration.present?
          redis.expire(key, expiration)
        end
      end
    end
  end

  def today
    redis.get(day_key).to_i
  end

  def month
    redis.get(month_key).to_i
  end

  def year
    redis.get(year_key).to_i
  end

  def delete_all_redis_keys!
    # Find and delete all redis keys that belong to DateAggregations on this stat
    keys = redis.keys(year_key(''))
    redis.del(*keys) unless keys.empty?
  end

  private

  def year_key(year = Time.zone.now.year)
    "#{stat}/year:#{year}"
  end

  def month_key(month = Time.zone.now.month, year = Time.zone.now.year)
    "#{year_key(year)}/month:#{month}"
  end

  def day_key(day = Time.zone.now.day, month = Time.zone.now.month, year = Time.zone.now.year)
    "#{month_key(month, year)}/day:#{day}"
  end

  def keys(date)
    [
      [year_key(date.year), nil],
      [month_key(date.month, date.year), nil],
      [day_key(date.day, date.month, date.year), KEY_EXPIRATION_FOR_DAY_KEYS]
    ]
  end
end
