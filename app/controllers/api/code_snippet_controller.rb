class Api::CodeSnippetController < Api::BaseController
  def show
    render html: current_resource_owner.code_snippet.html_safe
  end
end
