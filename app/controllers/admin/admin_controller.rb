class Admin::AdminController < ApplicationController
  before_filter { authorize! :manage, :all }
  def index
  end
end
