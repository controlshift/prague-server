class OrganizationsController < ApplicationController
  def create
  end

  def new
    @organization = Organization.new
  end
end
