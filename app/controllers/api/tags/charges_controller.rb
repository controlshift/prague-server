class Api::Tags::ChargesController < Api::BaseController
  before_action :load_tag

  def index
    @charges = @tag.charges.live.paid.order('created_at DESC').paginate(per_page: 100, page: params[:page])
  end

  private

  def load_tag
    @tag = current_resource_owner.tags.where(name: params[:tag_id]).first!
  end
end
