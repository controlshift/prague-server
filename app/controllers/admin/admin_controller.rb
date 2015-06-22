class Admin::AdminController < ApplicationController
  before_filter { authorize! :manage, :all }
  def index
  end

  def error
    raise "this is a test controller exception"
  end
end
