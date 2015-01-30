require 'spec_helper'

describe HomeController do
  describe 'index' do
    before(:each) do
      get :index
    end

    it 'should render success, even when not logged in' do
      expect(response).to be_success
    end
  end
end