class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  force_ssl if: :ssl_configured?

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def ssl_configured?
    Rails.env.production? || Rails.env.staging?
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      admin_dashboard_path
    else
      organization_path(resource)
    end
  end

  protected

  def current_status
    current_organization.status.intern
  end

  def streaming_csv_export(export)
    filename = "#{export.name}-#{Time.now.strftime("%Y%m%d")}.csv"

    self.response.headers['Content-Type'] = 'text/csv'
    self.response.headers['Last-Modified'] = Time.now.ctime.to_s
    self.response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
    self.response_body = export.as_csv_stream
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end
end
