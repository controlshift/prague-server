class Api::CodeSnippetController < Api::BaseController
  def show
    tags = params.fetch(:tags, '').split(',')
    render html: current_resource_owner.code_snippet(tags: tags).to_html.html_safe
  end
end
