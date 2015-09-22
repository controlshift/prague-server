class Admin::OrganizationsController < ApplicationController
  before_filter { authorize! :manage, :all }

  def index
    @organizations = Organization.all
  end

end
