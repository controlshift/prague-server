class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  force_ssl if: :ssl_configured?

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def ssl_configured?
    Rails.env.production?
  end

  def after_sign_in_path_for(organization)
    organization_path(organization)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end
end
