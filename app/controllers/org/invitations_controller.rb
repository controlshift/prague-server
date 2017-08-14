class Org::InvitationsController < Org::OrgController
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender = current_user
    @invitation.organization = current_organization

    respond_to do |format|
      if @invitation.save
        format.js do
          InvitationMailer.invitation_email(@invitation.id).deliver
          render :create_success
        end
      else
        format.js do
          render :create_error
        end
      end
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_email)
  end
end
