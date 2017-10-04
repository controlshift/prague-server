class Admin::UsersController < ApplicationController
  before_action { authorize! :manage, :all }
  before_action :load_user, except: [:index]

  def index
    users_relation = if params[:admins].to_s == 'true'
      User.where(admin: true)
    else
      User.all
    end

    @users = users_relation.paginate(per_page: 20, page: params[:page])
  end

  def edit
  end

  def update
    @user.assign_attributes(user_params)
    if @user.save
      redirect_to admin_users_path, notice: 'User successfully updated'
    else
      flash[:alert] = 'User not updated'
      render :edit
    end
  end

  def send_confirmation_instructions
    @user.send_confirmation_instructions
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:admin)
  end
end
