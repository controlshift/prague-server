class Org::OrgController < ApplicationController
  before_filter :load_and_authorize_organization

  def load_and_authorize_organization
    authorize! :manage, current_organization
  end
end
