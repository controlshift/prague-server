if ENV['SEGMENT_WRITE_KEY'].present?
  require 'segment/analytics'

  Analytics = Segment::Analytics.new({
                                       write_key: ENV['SEGMENT_WRITE_KEY'],
                                       on_error: Proc.new { |status, msg| print msg }
                                     })
end