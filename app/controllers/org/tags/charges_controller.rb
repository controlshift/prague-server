class Org::Tags::ChargesController < Org::OrgController
  before_action :load_tag

  def index
    respond_to do |format|
      format.csv do
        streaming_csv_export(Queries::ChargesForTagExport.new(tag: @tag))
      end
    end
  end

  def load_tag
    @tag = current_organization.tags.where(name: params[:tag_id]).first!
  end
end
