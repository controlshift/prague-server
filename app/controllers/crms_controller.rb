class CrmsController < ApplicationController
  before_filter :authenticate_organization!
  before_filter :check_if_organization_has_crm, only: [:create]

  def update
    @crm = current_organization.crm
    if @crm.update_attributes(crm_param)
      render json: @crm, status: :ok
    else
      render json: @crm, status: :bad_request
    end
  end

  def create
    @crm = current_organization.build_crm(crm_param)
    if @crm.save
      render :partial => 'organizations/crm_form', :content_type => 'text/html'
    else
      render json: @crm, status: :bad_request
    end
  end

  private

  def crm_param
    params.require(:crm).permit(:username, :password, :host, :donation_page_name)
  end

  def check_if_organization_has_crm
    unless current_organization.crm.nil? || current_organization.crm.new_record?
      @crm = current_organization.crm
      render :partial => 'organizations/crm_form', :content_type => 'text/html'
      return
    end
  end
end
