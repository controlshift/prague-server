require 'spec_helper'

describe ChargeNotificationMailer do
  describe 'send_receipt' do
    subject { ActionMailer::Base.deliveries.last }

    let(:customer) { create(:customer) }
    let(:organization) { create(:organization, thank_you_text: "Thank yew") }
    let!(:charge) { create(:charge, customer: customer, organization: organization)}

    before do
      ChargeNotificationMailer.send_receipt(charge.id).deliver_now
    end

    it 'should send the email' do
      expect(subject.to).to eq([charge.customer.email] )
      expect(subject.from).to eq(['admin@localhost'])
      expect(subject.subject).to eq("Thanks for donating to #{charge.organization.name}")
    end

    it 'should give the thank you text and other useful info' do
      expect(subject.body).to have_content(charge.organization.thank_you_text)
      expect(subject.body).to have_content(charge.presentation_amount)
      expect(subject.subject).to have_content(charge.organization.name)
    end

    context 'with a contact_email' do
      let(:organization) { create(:organization, contact_email: 'foo@bar.com') }

      it 'should send from the contact email' do
        expect(subject.from).to eq(['foo@bar.com'] )
      end
    end
  end
end
