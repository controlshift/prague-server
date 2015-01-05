class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?

  before_action :authenticate_user!

  def ssl_configured?
    Rails.env.production? || Rails.env.staging?
  end

  def after_sign_in_path_for(resource)
    return admin_dashboard_path if resource.admin?

    stored_location = stored_location_for(resource)
    if stored_location && current_organization
      # There's somewhere we should redirect back to
      if current_organization.access_token.blank?
        # Before we go back there, we need to prompt the organization to connect to stripe.
        # Jot down that we should go back to that place after we've connected to stripe
        session['return_to'] = stored_location
        # Go to the org page, where we'll prompt them to connect to stripe
        organization_path(current_organization)
      else
        stored_location
      end
    else
      # user doesn't have organization yet. Redirect them to a new organization page
      current_organization ? organization_path(current_organization) : new_organization_path
    end
  end

  def authenticate_admin_user!
    authenticate_user!
    authorize! :manage, :all
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.to_s
  end

  protected

  def current_organization
    current_user.organization if current_user
  end

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
end
