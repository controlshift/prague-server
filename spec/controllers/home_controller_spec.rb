require 'spec_helper'

describe HomeController do
  describe 'index' do
    before(:each) do
      get :index
    end

    it 'should render success' do
      response.should be_success
    end
  end
end