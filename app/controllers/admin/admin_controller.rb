class Admin::AdminController < ApplicationController
  before_action { authorize! :manage, :all }

  def index
  end
end
