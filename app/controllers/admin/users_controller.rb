class Admin::UsersController < ApplicationController
  before_filter { authorize! :manage, :all }

  before_filter :load_user, only: [:send_confirmation_instructions]

  def index
    users_relation = if params[:admins].to_s == 'true'
      User.where(admin: true)
    else
      User.all
    end

    @users = users_relation.paginate(per_page: 20, page: params[:page])
  end

  def send_confirmation_instructions
    @user.send_confirmation_instructions
  end

  private

  def load_user
    @user = User.find(params[:id])
  end
end
