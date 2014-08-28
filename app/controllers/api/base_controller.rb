class Api::BaseController < ApplicationController
  before_action :doorkeeper_authorize! # Require access token for all actions

  private

  # Find the user that owns the access token
  def current_resource_owner
    Organization.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end