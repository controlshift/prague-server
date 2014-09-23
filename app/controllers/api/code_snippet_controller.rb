class Api::CodeSnippetController < Api::BaseController
  def show
    tags = params[:tags].split(',')
    render html: current_resource_owner.code_snippet(tags: tags).html_safe
  end
end
