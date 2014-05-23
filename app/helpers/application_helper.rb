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

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success" # Green
      when :error
        "alert-danger" # Red
      when :alert
        "alert-warning" # Yellow
      when :notice
        "alert-info" # Blue
      else
        flash_type.to_s
    end
  end


  private

  def title_for(page_title, options)
    organisation_name = yield
    content_for(:title, page_title.to_s + " | " + organisation_name)
    content_tag(:h1, page_title, options)
  end

end
