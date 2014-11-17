require 'spec_helper'

describe InvitationPolicy do
  subject { described_class }

  let(:user) { build(:user_with_organization) }
  let(:sender) { build(:user_with_organization) }
  let(:invitation) { build(:invitation, sender: sender, organization: sender.organization) }

  permissions :create? do
    it 'allows access for user with membership in the organization' do
      expect(subject).to permit(sender, invitation)
    end

    it 'denies access for user without membership in the organization' do
      expect(subject).not_to permit(user, invitation)
    end
  end
end