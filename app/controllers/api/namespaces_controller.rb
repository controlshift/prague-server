class Api::NamespacesController < Api::BaseController
  before_filter :load_namespace, only: [:show, :raised]
  def index
    render json: current_resource_owner.namespaces.collect{|n| n.namespace}
  end

  def show
  end

  def raised
    render json: @namespace.most_raised
  end

  private

  def load_namespace
    @namespace = current_resource_owner.namespaces.where(namespace: params[:id]).first!
  end
end
