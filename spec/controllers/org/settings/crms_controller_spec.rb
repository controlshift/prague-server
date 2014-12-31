require 'spec_helper'

describe Org::Settings::CrmController do
  let(:organization) { create(:organization)}
  let(:user) { create(:confirmed_user, organization: organization)}

  before(:each) do
    controller.stub(:current_organization).and_return( organization )
    sign_in user
  end

  describe 'create' do


  end
end