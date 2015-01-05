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

  def breadcrumbs(paths)
    content_tag(:ol, class: 'breadcrumb') do
      paths.collect do |path|
        li_options = if paths.last == path
          {class: 'active'}
        else
          {}
        end

        content_tag(:li, li_options) do
          if path[1].present?
            link_to(path[0], path[1])
          else
            path[0]
          end
        end
      end.join(' ').html_safe
    end

  end

  def bootstrap_class_for flash_type
    case flash_type.try(:to_sym)
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

  def current_organization
    @organization ||= current_user.organization
  end

  private

  def title_for(page_title, options)
    organisation_name = yield
    content_for(:title, page_title.to_s + " | " + organisation_name)
    content_tag(:h1, page_title, options)
  end
end
