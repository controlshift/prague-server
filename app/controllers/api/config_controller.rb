class Api::ConfigController < Api::BaseController
  def index
    render json: current_resource_owner.to_json
  end
end