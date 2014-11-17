class ChargePolicy < ApplicationPolicy
  attr_reader :user, :charge

  def initialize(user, charge)
    @user = user
    @charge = charge
  end

  def create?
    true
  end
end