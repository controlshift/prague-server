class AuthenticationPolicy < Struct.new(:user, :authentication)

  # only allow access if user has an organization
  def create?
    !user.organization.nil?
  end
end