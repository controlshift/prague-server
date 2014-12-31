class Org::UsersController < Org::OrgController
  def index
    @invitation = Invitation.new(organization: current_organization)
    @users = current_organization.users.paginate(per_page: 100, page: params[:page])
  end

  def destroy
    @user = current_organization.users.find(params[:id])

    if @user == current_user
      redirect_to organization_users_path(current_organization), alert: 'May not delete current user.'
    else
      @user.destroy
      redirect_to organization_users_path(current_organization), notice: "#{@user.email} removed."
    end
  end
end