class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!

  def ssl_configured?
    Rails.env.production? || Rails.env.staging?
  end

  def after_sign_in_path_for(resource)
    return admin_dashboard_path if resource.is_a?(AdminUser)

    organization = current_user.organization
    stored_location = stored_location_for(resource)
    if stored_location && organization
      # There's somewhere we should redirect back to
      if organization.access_token.blank?
        # Before we go back there, we need to prompt the organization to connect to stripe.
        # Jot down that we should go back to that place after we've connected to stripe
        session['return_to'] = stored_location
        # Go to the org page, where we'll prompt them to connect to stripe
        organization_path(organization)
      end
    else
      # user doesn't have organization yet. Redirect him to a new organiztion page
      organization ? organization_path(organization) : new_organization_path
    end
  end

  protected

  def current_status
    current_user.organization.status.intern
  end

  def streaming_csv_export(export)
    filename = "#{export.name}-#{Time.now.strftime("%Y%m%d")}.csv"

    self.response.headers['Content-Type'] = 'text/csv'
    self.response.headers['Last-Modified'] = Time.now.ctime.to_s
    self.response.headers['Content-Disposition'] = "attachment; filename=#{filename}"
    self.response_body = export.as_csv_stream
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation) }
  end
end
