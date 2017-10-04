class Org::OrgController < ApplicationController
  before_action :load_and_authorize_organization

  def load_and_authorize_organization
    authorize! :manage, current_organization
  end

  def current_organization
    @organization = Organization.where(slug: params[:organization_id]).first!
  end
end
