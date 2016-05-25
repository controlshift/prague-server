class Admin::OrganizationsController < ApplicationController
  before_filter { authorize! :manage, :all }

  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find_by_slug!(params[:id])
  end
end
