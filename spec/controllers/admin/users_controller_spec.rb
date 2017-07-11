require 'spec_helper'

describe Admin::UsersController do
  let(:admin) { create(:confirmed_user, admin: true) }

  before :each do
    sign_in admin
  end

  describe '#index' do
    let!(:regular_users) { create_list(:user, 2, admin: false) }

    it 'should list all users including admins if no param present' do
      get :index

      expect(response.status).to eq 200
      expect(response).to render_template(:index)
      expect(assigns[:users]).not_to be_nil
      expect(assigns[:users]).to match_array(regular_users + [admin])
    end

    it 'should only list admins if param present' do
      get :index, admins: true

      expect(response.status).to eq 200
      expect(assigns[:users]).to match_array([admin])
    end
  end
end
