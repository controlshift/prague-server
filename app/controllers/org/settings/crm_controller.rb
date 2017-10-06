class Org::Settings::CrmController < Org::OrgController
  before_action :load_crm

  def show
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @crm.update_attributes(crm_param)
      respond_to do |format|
        format.js  { render 'update_success' }
      end
    else
      respond_to do |format|
        format.js { render 'update_error' }
      end
    end
  end

  def new
    @crm = current_organization.build_crm(crm_param)
    respond_to do |format|
      format.js { render 'new'}
    end
  end

  def destroy
    @crm.destroy
    respond_to do |format|
      format.js { render 'destroy'}
    end
  end

  def create
    @crm = current_organization.build_crm(crm_param)
    if @crm.save
      respond_to do |format|
        format.js { render 'create_success' }
      end
    else
      respond_to do |format|
        format.js { render 'create_error' }
      end
    end
  end

  def test
    @test = CrmTest.new(crm: @crm)
    @test.test!

    respond_to do |format|
      if @test.errors.any?
        format.js { render 'test_error' }
      else
        format.js { render 'test_success' }
      end
    end
  end

  private

  def crm_param
    params.require(:crm).permit(:username, :password, :host, :donation_page_name, :platform, :default_currency)
  end

  def load_crm
    @crm = current_organization.crm
  end
end
