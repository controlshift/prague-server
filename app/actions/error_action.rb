class ErrorAction
  def initialize(charge, e, log_entry_message, pusher_entry_message = "Something went wrong, please try again.")
    @charge = charge
    @e = e
    @log_entry_message = log_entry_message
    @pusher_entry_message = pusher_entry_message
  end

  def call
    @charge.update_attributes(paid: false)
    LogEntry.create(charge: @charge, message: @log_entry_message)
    Pusher[@charge.pusher_channel_token].trigger('charge_completed', {
      status: 'failure',
      message: @pusher_entry_message
    })
    Rails.logger.debug("#{@e.class}: #{@e.message}")
  end
end
