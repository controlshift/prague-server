class InvitationMailer < ActionMailer::Base
  default from: ENV['ADMIN_EMAIL']

  def invitation_email(invitation_id)
    @invitation = Invitation.includes(:sender, :organization).find(invitation_id)
    mail to: @invitation.recipient_email, subject: "You have been invited to join #{@invitation.organization.name} on TakeCharge"
  end
end