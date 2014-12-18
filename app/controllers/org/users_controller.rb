class Org::UsersController < Org::OrgController
  def index
    @invitation = Invitation.new(organization: current_organization)
    @users = current_organization.users.paginate(per_page: 100, page: params[:page])
  end
end