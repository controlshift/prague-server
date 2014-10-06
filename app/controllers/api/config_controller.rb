class Api::ConfigController < Api::BaseController
  def show
    render json: current_resource_owner.to_json
  end
end