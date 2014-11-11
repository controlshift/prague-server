class OrganizationPolicy < ApplicationPolicy
  attr_reader :user, :organization

  def initialize(user, organization)
    @user = user
    @organization = organization
  end

  def show?
    # Only a member of an organization can see it
    user.organization == organization
  end

  def new?
    # Only user without an organization can create new one
    user.organization.nil?
  end

  def create?
    # Only user without an organization can create new one
    user.organization.nil?
  end

  def update?
    # Only a member of organization can update it
    user.organization == organization
  end

  def toggle?
    # Only a member of organization can toggle it
    user.organization == organization
  end

  def deauthorize?
    # Only a member of organization can deauthorize it
    user.organization == organization
  end

  def omniauth_failure?
    # Only a member of organization can see omniauth failure
    user.organization == organization
  end
end