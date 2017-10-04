class Api::Namespaces::ChargesController < Api::BaseController
  before_action :load_namespace

  def index
    render json: @namespace.charges.live.paid.order('created_at DESC').paginate(per_page: 100, page: params[:page])
  end

  private

  def load_namespace
    @namespace = current_resource_owner.namespaces.where(namespace: params[:namespace_id]).first!
  end
end
