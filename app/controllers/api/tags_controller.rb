class Api::TagsController < Api::BaseController
  def index
    render json: current_resource_owner.tags.collect{|n| n.name }
  end

  def show
    @tag = current_resource_owner.tags.where(name: params[:id]).first!
  end
end
