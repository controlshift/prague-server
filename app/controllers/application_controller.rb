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
    edit_user_registration_path
    # if resource.is_a?(AdminUser)
    #   admin_dashboard_path
    # else
    #   # The resource is an organization
    #   stored_loc = stored_location_for(resource)
    #   if stored_loc
    #     # There's somewhere we should redirect back to
    #     if current_organization.access_token.blank?
    #       # Before we go back there, we need to prompt the organization to connect to stripe.

    #       # Jot down that we should go back to that place after we've connected to stripe
    #       session['organization_return_to'] = stored_loc

    #       # Go to the org page, where we'll prompt them to connect to stripe
    #       organization_path(resource)
    #     else
    #       stored_loc
    #     end
    #   else
    #     # Nowhere to redirect to, so go to the organization dashboard
    #     organization_path(resource)
    #   end
    # end
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
