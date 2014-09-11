class Api::TagsController < Api::BaseController

  def show
   @tag = current_resource_owner.tags.where(name: params[:id]).first!

   render json: @tag.to_json
 end
end
