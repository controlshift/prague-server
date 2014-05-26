class Org::ChargesController < Org::OrgController
  def index
    respond_to do | format |
      format.html do
        @charges = current_organization.charges.order('created_at DESC').paginate(page: params[:page])
      end

      format.csv do
        streaming_csv_export(Queries::ChargesForOrganizationExport.new(organization: current_organization))
      end
    end
  end
end