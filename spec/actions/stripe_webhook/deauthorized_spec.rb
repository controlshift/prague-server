require 'spec_helper'

describe StripeWebhook::Deauthorized do
  let!(:organization) { create(:organization, access_token: 'foo', stripe_user_id: 'acct_103hxd2J23YKkK7S') }

  let(:params) {
    {"id"=>"evt_1045tR2J23YKkK7S5vuZb1uR",
     "created"=>1400947578,
     "livemode"=>false,
     "type"=>"account.application.deauthorized",
     "data"=>
       {"object"=>
          {"id"=>"ca_45c3DJuRRqClLXnqv2NEOgzzUONebkE8",
           "name"=>"TakeCharge Staging",
           "object"=>"application"}},
     "object"=>"event",
     "pending_webhooks"=>1,
     "request"=>nil,
     "user_id"=>"acct_103hxd2J23YKkK7S",
     "controller"=>"stripe_event/webhook",
     "action"=>"event",
     "webhook"=>
       {"id"=>"evt_1045tR2J23YKkK7S5vuZb1uR",
        "created"=>1400947578,
        "livemode"=>false,
        "type"=>"account.application.deauthorized",
        "data"=>
          {"object"=>
             {"id"=>"ca_45c3DJuRRqClLXnqv2NEOgzzUONebkE8",
              "name"=>"TakeCharge Staging",
              "object"=>"application"}},
        "object"=>"event",
        "pending_webhooks"=>1,
        "request"=>nil,
        "user_id"=>"acct_103hxd2J23YKkK7S"}}
  }
  before(:each) do
    StripeWebhook::Deauthorized.new.call(params)
  end

  it 'should show an organization' do
    organization.reload.access_token.should be_nil
  end
end