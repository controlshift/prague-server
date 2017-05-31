# == Schema Information
#
# Table name: invitations
#
#  id                     :integer          not null, primary key
#  sender_id              :integer          not null
#  recipient_id           :integer
#  recipient_email        :string           not null
#  organization_id        :integer          not null
#  token                  :string
#  created_at             :datetime
#  updated_at             :datetime
#  invitation_accepted_at :datetime
#

require 'spec_helper'

describe Invitation do
  let(:organization) { create(:organization) }
  let(:user) { create(:confirmed_user, organization: organization) }

  it { should validate_presence_of :sender }
  it { should validate_presence_of :organization }
  it { should validate_presence_of :recipient_email }

  describe '#token' do
    it 'should not be nil after validation' do
      expect(subject.token).to be_nil
      subject.valid?
      expect(subject.token).to be_present
    end


    context 'with a token' do
      let!(:invitation) { create(:invitation, token: 'foo', organization: organization, sender: user) }

      it 'should not change once set' do
        invitation.valid? # trigger callback
        expect(invitation.token).to eq('foo')
      end

      it 'should not allow a second invitation with the same token' do
        inv = build(:invitation, token: 'foo', organization: organization, sender: user)
        inv.valid?
        expect(inv.errors.messages[:token]).to be_present
      end
    end
  end

  describe "email addresses" do
    it { should allow_value('george@washington.com').for(:recipient_email) }
    it { should allow_value('george@ul.we.you.us').for(:recipient_email) }
    it { should_not allow_value('fooooooo bar bar gooooof   fooooof fofofofoosd fooooooo bar bar gooooof   fooooof fofofofoosd fooooooo bar bar gooooof   fooooof fofofofoosd fooooooo bar bar gooooof   fooooof fofofofoosd').for(:recipient_email) }
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
    let(:sender) { create(:confirmed_user, organization: organization) }

    it 'should add an error when sender is in another organization' do
      invitation = build(:invitation, organization: create(:organization), sender: sender)
      invitation.send(:sender_is_member)
      expect(invitation.errors.messages[:sender_id]).to be_present
    end

    context 'sender is admin' do
      let(:sender) {  create(:confirmed_user, organization: organization, admin: true) }

      it 'should not add an error when sender is in the same organization' do
        invitation = build(:invitation, sender: sender)
        invitation.send(:sender_is_member)
        expect(invitation.errors.messages[:sender_id]).to_not be_present
      end
    end

    it 'should not add an error when sender is in the same organization' do
      invitation = build(:invitation, organization: organization, sender: sender)
      invitation.send(:sender_is_member)
      expect(invitation.errors.messages[:sender_id]).to_not be_present
    end
  end
end
