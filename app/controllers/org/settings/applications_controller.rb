class Org::Settings::ApplicationsController < Org::OrgController
  def index
    @access_grants = Doorkeeper::AccessGrant.where(resource_owner_id: current_organization.id)
  end
end