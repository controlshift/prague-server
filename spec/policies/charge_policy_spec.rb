require 'spec_helper'

describe ChargePolicy do
  subject { described_class }

  permissions :create? do
    it 'allows access' do
      pending('waiting for clarification')
    end

    it 'denies access' do
      pending('waiting for clarification')
    end
  end
end