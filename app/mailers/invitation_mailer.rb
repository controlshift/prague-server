class InvitationMailer < ActionMailer::Base
  default from: "from@example.com"

  def invitation_email(invitation_id)
    @invitation = Invitation.includes(:sender, :organization).find(invitation_id)
    mail to: @invitation.recipient_email, subject: "You have been invited to join the #{@invitation.organization.name} on TakeCharge"
  end
end