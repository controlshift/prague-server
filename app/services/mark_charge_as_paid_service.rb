# Marek charge as paied, insert new entry and push notification to the user

class MarkChargeAsPaidService
  def initialize(charge, stripe_charge)
    @charge = charge
    @stripe_charge = stripe_charge
  end

  def call
    @charge.update_attributes(paid: true, stripe_id: @stripe_charge[:id], card: @stripe_charge[:card].to_hash )
    LogEntry.create(charge: @charge, message: 'Successful charge.')
    Pusher[@charge.pusher_channel_token].trigger('charge_completed', {
      status: 'success'
    })
  end
end
