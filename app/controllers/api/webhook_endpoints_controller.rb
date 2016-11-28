class Api::WebhookEndpointsController < Api::BaseController
  def index
    render json: current_resource_owner.webhook_endpoints
  end

  def create
    @webhook = current_resource_owner.webhook_endpoints.build(webhook_param)
    if @webhook.save
      render json: {'id' => @webhook.id}
    else
      render json: @webhook.errors.to_json
    end
  end

  def destroy
    @webhook = current_resource_owner.webhook_endpoints.find(params[:id])
    @webhook.destroy!
    render json: {'status' => 'success'}
  end

  private

  def webhook_param
    params.require(:webhook_endpoint).permit(:url, :name, :username, :password)
  end
end
