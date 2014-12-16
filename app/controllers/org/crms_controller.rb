class Org::CrmsController < ApplicationController
  before_filter :check_if_organization_has_crm, only: [:create]

  def update
    @crm = current_organization.crm
    if @crm.update_attributes(crm_param)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def create
    @crm = current_organization.build_crm(crm_param)
    if @crm.save
      respond_to do |format|
        format.js { render 'update' }
      end
    else
      respond_to do |format|
        format.js { render 'update' }
      end
    end
  end

  private

  def crm_param
    params.require(:crm).permit(:username, :password, :host, :donation_page_name, :platform, :default_currency, import_stubs_attributes: [ :donation_currency, :payment_account, :_destroy, :id ])
  end

  def check_if_organization_has_crm
    unless current_organization.crm.nil? || current_organization.crm.new_record?
      @crm = current_organization.crm
      render :partial => 'organizations/crm_form', :content_type => 'text/html'
      return
    end
  end
end
