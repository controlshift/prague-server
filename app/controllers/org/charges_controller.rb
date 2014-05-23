class Org::ChargesController < Org::OrgController
  def index
    respond_to do | format |
      format.html do
        @charges = current_organization.charges.paginate page: params[:page], order: 'created_at DESC'
      end

      format.csv do
        # todo
      end
    end
  end
end