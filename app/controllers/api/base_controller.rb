class Api::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_before_action :authenticate_user!
  protect_from_forgery with: :null_session

  private

  # Find the user that owns the access token
  def current_resource_owner
    Organization.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end