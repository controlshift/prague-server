class ConfirmationsController < Devise::ConfirmationsController
  skip_after_action :verify_authorized

  private

  def after_confirmation_path_for resource_name, resource
    sign_in resource
    organization_path(resource)
  end
end