class Org::TagsController < Org::OrgController
  before_action :load_tag, only: [:show]

  def index
    @tags = current_organization.tags.paginate(per_page: 100, page: params[:page])
  end

  def show
    @charges = @tag.charges.paginate(per_page: 100, page: params[:page])
  end

  private

  def load_tag
    @tag = current_organization.tags.where(name: params[:id]).first!
  end
end