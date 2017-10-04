class Api::NamespacesController < Api::BaseController
  before_action :load_namespace, only: [:show, :raised, :history]

  def index
    render json: current_resource_owner.namespaces.collect{|n| n.namespace}
  end

  def show
  end

  def raised
    @most_raised = @namespace.most_raised
  end

  def history
    @days = params[:days].present? ? params[:days].to_i : 7
  end

  private

  def load_namespace
    @namespace = current_resource_owner.namespaces.where(namespace: params[:id]).first!
    @currency = current_resource_owner.currency
  end
end
