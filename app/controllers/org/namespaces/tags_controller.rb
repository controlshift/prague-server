class Org::Namespaces::TagsController < Org::OrgController
  before_action :load_namespace

  def index
    @tags = @namespace.tags.paginate(per_page: 100, page: params[:page])
  end

  def load_namespace
    @namespace = current_organization.namespaces.where(namespace: params[:namespace_id]).first!
  end
end
