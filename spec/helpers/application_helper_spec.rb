require 'spec_helper'

describe ApplicationHelper do
  describe 'current_organization' do
    let(:organization) { double }
    it 'should use the value from the organization variable' do
      helper.instance_variable_set(:@organization, organization)
      expect(helper.current_organization).to eq(organization)
    end

    it 'should use the current user if organization not set' do
      user = double
      user.stub(:organization).and_return(organization)
      helper.stub(:current_user).and_return(user)
      expect(helper.current_organization).to eq(organization)
    end
  end
end