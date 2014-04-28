module ApplicationHelper
  def error_messages_for resource
    resource.errors.collect do |attr,msg|
      "#{attr.capitalize} #{msg}"
    end.join("<br>").html_safe
  end
end
