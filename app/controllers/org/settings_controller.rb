class Org::SettingsController < Org::OrgController
  def show
    @organization = current_organization
    @crm = @organization.crm || @organization.build_crm
  end
end
