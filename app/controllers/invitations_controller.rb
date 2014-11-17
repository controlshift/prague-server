class InvitationsController < ApplicationController
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender = current_user
    @invitation.organization = current_user.organization

    authorize @invitation

    respond_to do |format|
      if @invitation.save
        format.json do
          InvitationMailer.invitation_email(@invitation.id).deliver
          render json: @invitation, status: :created
        end
      else
        format.json { render json: @invitation.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_email)
  end
end