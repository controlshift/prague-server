class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :manage, Organization, :id => user.organization_id

    if user.admin?
      can :manage, :all
    end

  end
end
