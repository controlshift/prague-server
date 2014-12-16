require 'spec_helper'

describe Invitation do
  let(:organization) { create(:organization) }

  it { should validate_presence_of :sender }
  it { should validate_presence_of :organization }
  it { should validate_presence_of :recipient_email }

  describe '#token' do
    it 'should not be nil after validation' do
      expect(subject.token).to be_nil
      subject.valid?
      expect(subject.token).to be_present
    end
  end

  describe '#recipient_is_not_member' do
    let(:invitation) { build(:invitation) }
    let(:user) { create(:confirmed_user, email: invitation.recipient_email, organization: organization)}

    it 'should not add an error without another organization' do
      invitation.send(:recipient_is_not_member)
      expect(invitation.errors.messages[:recipient_email]).to be_nil
    end

    context 'with an organization' do
      let(:invitation) { build(:invitation, organization: organization) }
      before(:each) { user }

      it 'should add an error without another organization' do
        invitation.send(:recipient_is_not_member)
        expect(invitation.errors.messages[:recipient_email]).to be_present
      end
    end
  end

  describe '#sender_is_member' do
    let(:sender) {  create(:confirmed_user, organization: organization) }

    it 'should add an error when sender is in another organization' do
      invitation = build(:invitation)
      invitation.send(:sender_is_member)
      expect(invitation.errors.messages[:sender_id]).to be_present
    end

    it 'should not add an error when sender is in the same organization' do
      invitation = build(:invitation, organization: organization)
      invitation.send(:sender_is_member)
      expect(invitation.errors.messages[:sender_id]).to be_present
    end
  end
end