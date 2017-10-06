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
      get :index, params: { admins: true }

      expect(response.status).to eq 200
      expect(assigns[:users]).to match_array([admin])
    end
  end

  describe '#edit' do
    let(:user) { create(:user) }

    it 'should assign user and render edit template' do
      get :edit, params: { id: user }

      expect(response).to render_template(:edit)
      expect(assigns[:user]).to eq user
    end
  end

  describe '#update' do
    let(:user) { create(:user) }

    it 'should update user and redirect' do
      patch :update, params: { id: user, user: {admin: '1'} }

      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq 'User successfully updated'
      user.reload
      expect(user).to be_admin
    end
  end
end
