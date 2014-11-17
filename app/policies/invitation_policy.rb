class InvitationPolicy < ApplicationPolicy
  attr_reader :user, :invitation

  def initialize(user, invitation)
    @user = user
    @invitation = invitation
  end

  # Only user which is member of the organization can invite new members
  def create?
    !user.organization.nil? &&
    user.organization == @invitation.organization
  end
end