class Api::NamespacesController < Api::BaseController

  def index
    render json: current_resource_owner.namespaces.collect{|n| n.namespace}
  end

  def show
    @namespace = current_resource_owner.namespaces.where(namespace: params[:id]).first!
  end
end
