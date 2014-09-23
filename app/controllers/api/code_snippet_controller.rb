class Api::CodeSnippetController < Api::BaseController
  def show
    tags = params[:tags]
    render html: current_resource_owner.code_snippet(tags: tags).html_safe
  end
end
