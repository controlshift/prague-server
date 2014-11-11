require 'spec_helper'

describe OrganizationPolicy do
  subject { described_class }

  let(:user) { build(:user_with_organization) }
  let(:organization) { user.organization }

  permissions :show? do
    it 'grants access if user is member of the organization' do
      expect(subject).to permit(user, organization)
    end

    it 'denies access if user is not member of the organization' do
      expect(subject).not_to permit(user, Organization.new)
    end
  end

  permissions :new? do
    it 'grants access if user is not yet member of ANY organization' do
      expect(subject).to permit(User.new, Organization.new)
    end

    it 'denies access if user is already member of ANY organization' do
      expect(subject).not_to permit(user, organization)
    end
  end

  permissions :create? do
    it 'grants access if user is not yet member of ANY organization' do
      expect(subject).to permit(User.new, Organization.new)
    end

    it 'denies access if user is already member of ANY organization' do
      expect(subject).not_to permit(user, organization)
    end
  end

  permissions :update? do
    it 'grants access if user is member of the organization' do
      expect(subject).to permit(user, organization)
    end

    it 'denies access if user is not member of the organization' do
      expect(subject).not_to permit(user, Organization.new)
    end
  end

  permissions :toggle? do
    it 'grants access if user is member of the organization' do
      expect(subject).to permit(user, organization)
    end

    it 'denies access if user is not member of the organization' do
      expect(subject).not_to permit(user, Organization.new)
    end
  end

  permissions :deauthorize? do
    it 'grants access if user is member of the organization' do
      expect(subject).to permit(user, organization)
    end

    it 'denies access if user is not member of the organization' do
      expect(subject).not_to permit(user, Organization.new)
    end
  end

  permissions :omniauth_failure? do
    it 'grants access if user is member of the organization' do
      expect(subject).to permit(user, organization)
    end

    it 'denies access if user is not member of the organization' do
      expect(subject).not_to permit(user, Organization.new)
    end
  end
end