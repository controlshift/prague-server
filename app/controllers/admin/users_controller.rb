class Admin::UsersController < ApplicationController
  before_filter { authorize! :manage, :all }

  before_filter :load_user

  def send_confirmation_instructions
    @user.send_confirmation_instructions
  end

  private

  def load_user
    @user = User.find(params[:id])
  end
end
