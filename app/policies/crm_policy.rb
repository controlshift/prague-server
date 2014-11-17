class CrmPolicy < ApplicationPolicy
  attr_reader :user, :crm

  def initialize(user, crm)
    @user = user
    @crm = crm
  end

  def update?
    !user.organization.nil?
  end

  def create?
    !user.organization.nil?
  end
end