class UsersController < Devise::RegistrationsController

  # GET /resource/sign_up
  def new
    if params[:invitation_token]
      @invitation = Invitation.includes(:sender, :organization).find_by(token: params[:invitation_token])
      redirect_to new_user_registration_path, alert: 'Couldn\'t find invitation' and return if @invitation.nil?
    end

    build_resource({})
    resource.build_organization
    @validatable = devise_mapping.validatable?
    if @validatable
      @minimum_password_length = resource_class.password_length.min
    end
    respond_with self.resource
  end

  # POST /resource
  def create
    build_resource(sign_up_params.reject { |k, v| k == 'organization_attributes' && v['name'].blank? })

    if params[:invitation_token]
      @invitation = Invitation.includes(:sender, :organization).find_by(token: params[:invitation_token])
      resource.organization = @invitation.organization
      resource.email = @invitation.recipient_email
      resource.skip_confirmation!
      resource.confirm!
    end

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, t('devise.registrations.signed_up') if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, t('devise.registrations.signed_up_but_unconfirmed') if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      resource.build_organization unless resource.organization
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with(resource, invitation_token: @invitation.try(:token))
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, organization_attributes: [:name ])
  end
end