class Org::ChargesController < Org::OrgController
  def index
    respond_to do | format |
      format.html do
        @charges = if current_organization.testmode?
          current_organization.charges.test.order('created_at DESC').paginate(page: params[:page])
        else
          current_organization.charges.live.order('created_at DESC').paginate(page: params[:page])
        end
      end

      format.csv do
        streaming_csv_export(Queries::ChargesForOrganizationExport.new(organization: current_organization))
      end
    end
  end

  def show
    @charge = current_organization.charges.find(params[:id])
  end
end