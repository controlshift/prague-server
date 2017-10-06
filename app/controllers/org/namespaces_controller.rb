class Org::NamespacesController < Org::OrgController
  before_action :load_namespace, only: [:show, :raised]

  def index
    @namespaces = current_organization.namespaces.paginate(per_page: 100, page: params[:page])
  end

  def show
  end

  def raised
  end

  private

  def load_namespace
    @namespace = current_organization.namespaces.where(namespace: params[:id]).first!
  end
end