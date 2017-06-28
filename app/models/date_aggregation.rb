class DateAggregation
  attr_accessor :stat

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
    redis.multi { keys(date).each { |key| redis.incrby key, amount }}
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
    [year_key(date.year),
     month_key(date.month, date.year),
     day_key(date.day, date.month, date.year)]
  end
end
