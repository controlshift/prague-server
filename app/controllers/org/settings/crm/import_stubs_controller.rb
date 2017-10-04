class Org::Settings::Crm::ImportStubsController < Org::OrgController
  before_action :load_crm

  def new
    @stub = @crm.import_stubs.build
    respond_to do |format|
      format.js { render 'new'}
    end
  end

  def create
    @stub = @crm.import_stubs.build(import_stub_params)
    respond_to do |format|
      format.js do
        if @stub.save
          render 'create_success'
        else
          render 'create_error'
        end
      end
    end
  end

  def destroy
    @stub = @crm.import_stubs.find(params[:id])
    @stub.destroy
    respond_to do |format|
      format.js do
        render 'create_success'
      end
    end
  end

  private

  def import_stub_params
    params.require(:import_stub).permit(:donation_currency, :payment_account)
  end

  def load_crm
    @crm = current_organization.crm
  end
end
