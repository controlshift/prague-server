require 'spec_helper'

describe ApplicationPolicy do
  subject { described_class }

  let(:user) { build(:user_with_organization) }

  permissions :index? do
    it 'denies access' do
      expect(subject).not_to permit(user)
    end
  end

  permissions :show? do
    it 'denies access' do
      expect(subject).not_to permit(user)
    end
  end

  permissions :create? do
    it 'denies access' do
      expect(subject).not_to permit(user)
    end
  end

  permissions :new? do
    it 'denies access' do
      expect(subject).not_to permit(user)
    end
  end

  permissions :update? do
    it 'denies access' do
      expect(subject).not_to permit(user)
    end
  end

  permissions :edit? do
    it 'denies access' do
      expect(subject).not_to permit(user)
    end
  end

  permissions :destroy? do
    it 'denies access' do
      expect(subject).not_to permit(user)
    end
  end

end