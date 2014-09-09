class Api::BaseController < ApplicationController
  doorkeeper_for :all

  private

  # Find the user that owns the access token
  def current_resource_owner
    Organization.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end