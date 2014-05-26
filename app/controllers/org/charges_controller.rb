class Org::ChargesController < Org::OrgController
  def index
    respond_to do | format |
      format.html do
        @charges = current_organization.charges.order('created_at DESC').paginate(page: params[:page])
      end

      format.csv do
        # todo
      end
    end
  end
end