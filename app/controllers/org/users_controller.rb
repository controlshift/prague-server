class Org::UsersController < Org::OrgController
  def index
    @users = current_organization.users.paginate(per_page: 100, page: params[:page])
  end
end