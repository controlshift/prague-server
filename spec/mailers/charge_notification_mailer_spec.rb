require 'spec_helper'
require 'rspec/its'

describe ChargeNotificationMailer do
  describe 'send_receipt' do
    subject{ ActionMailer::Base.deliveries.last }

    let(:customer) { create(:customer) }
    let(:organization) { create(:organization, thank_you_text: "Thank yew") }
    let!(:charge) { create(:charge, customer: customer, organization: organization)}

    before do
      ChargeNotificationMailer.send_receipt(charge.id).deliver_now
    end

    its(:to) { should == [charge.customer.email] }
    its(:from) { should == ['admin@localhost'] }
    its(:subject) { should == "Thanks for donating to #{charge.organization.name}"}

    it 'should give the thank you text and other useful info' do
      expect(subject.body).to have_content(charge.organization.thank_you_text)
      expect(subject.body).to have_content(charge.presentation_amount)
      expect(subject.subject).to have_content(charge.organization.name)
    end

    context 'with a contact_email' do
      let(:organization) { create(:organization, contact_email: 'foo@bar.com') }
      its(:from) { should == ['foo@bar.com'] }
    end
  end
end