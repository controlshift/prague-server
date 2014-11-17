require 'spec_helper'

describe ConfigPolicy do
  subject { described_class }

  permissions :index? do
    it 'allows access' do
      pending('waiting for clarification')
    end

    it 'denies access' do
      pending('waiting for clarification')
    end
  end
end