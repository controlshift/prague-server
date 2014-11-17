class OrganizationPolicy < ApplicationPolicy
  attr_reader :user, :organization

  def initialize(user, organization)
    @user = user
    @organization = organization
  end

  # Only a member of an organization can see it
  def show?
    user.organization == organization
  end

  # Only user without an organization can create new one
  def new?
    user.organization.nil?
  end

  # Only user without an organization can create new one
  def create?
    user.organization.nil?
  end

  # Only a member of organization can update it
  def update?
    user.organization == organization
  end

  # Only a member of organization can toggle it
  def toggle?
    user.organization == organization
  end

  # Only a member of organization can deauthorize it
  def deauthorize?
    user.organization == organization
  end

  # Only a member of organization can see omniauth failure
  def omniauth_failure?
    user.organization == organization
  end
end