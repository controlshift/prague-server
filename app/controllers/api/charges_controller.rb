class Api::ChargesController < Api::BaseController
  def index
    render json: current_resource_owner.charges.live.order('created_at DESC').paginate(per_page: 100, page: params[:page]).to_json
  end
end
