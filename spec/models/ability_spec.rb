require 'spec_helper'
require "cancan/matchers"


describe "User" do
  describe "abilities" do
    subject(:ability){ Ability.new(user) }
    let(:user){ nil }
    let(:organization) { create(:organization) }
    let(:another_organization) { create(:organization) }

    it 'if anonymous, should not be able to manage an organization' do
      should_not be_able_to(:manage, organization)
    end

    context "when it belongs to an organization" do
      let(:user){ create(:user, organization: organization) }

      it { should be_able_to(:manage, organization) }
      it { should_not be_able_to(:manage, another_organization) }
    end
  end
end
