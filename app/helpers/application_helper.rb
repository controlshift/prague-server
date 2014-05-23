module ApplicationHelper
  def error_messages_for resource
    resource.errors.collect do |attr,msg|
      "#{attr.capitalize} #{msg}"
    end.join("<br>").html_safe
  end

  def title(page_title, options = {})
    title_for(page_title, options) do
      current_organization.name
    end
  end

  private

  def title_for(page_title, options)
    organisation_name = yield
    content_for(:title, page_title.to_s + " | " + organisation_name)
    content_tag(:h1, page_title, options)
  end

end
