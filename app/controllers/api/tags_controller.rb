class Api::TagsController < Api::BaseController
  before_action :load_tag, only: [:show, :history]

  def index
    render json: current_resource_owner.tags.collect{|n| n.name }
  end

  def show
  end

  def history
    @days = params[:days].present? ? params[:days].to_i : 7
  end

  private

  def load_tag
    @tag = current_resource_owner.tags.where(name: params[:id]).first!
    @currency = current_resource_owner.currency
  end

end
