require 'spec_helper'

describe CrmPolicy do
  subject { described_class }

  let(:user_without_organization) { build(:user) }
  let(:user_with_organization) { build(:user_with_organization) }

  permissions :update? do
    it 'allows access to user with organization' do
      expect(subject).to permit(user_with_organization)
    end

    it 'denies access to user without organization' do
      expect(subject).not_to permit(user_without_organization)
    end
  end

  permissions :create? do
    it 'allows access to user with organization' do
      expect(subject).to permit(user_with_organization)
    end

    it 'denies access to user without organization' do
      expect(subject).not_to permit(user_without_organization)
    end
  end
end