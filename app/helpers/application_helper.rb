module ApplicationHelper
  def render_svg(name, styles: "w-6 h-6")
    file_path = Rails.root.join("app/assets/images", name)
    return unless File.exist?(file_path)

    file = File.read(file_path)
    doc = Nokogiri::HTML::DocumentFragment.parse(file)
    svg = doc.at_css("svg")
    svg["class"] = styles
    doc.to_html.html_safe
  end

  def display_field_errors(resource, field)
    return unless resource&.errors&.key?(field)

    error_messages = resource.errors.full_messages_for(field)

    content_tag(:div, data: { controller: "form-errors", form_errors_timeout_value: 3000 }, class: "text-red-500 text-sm rounded-md transition-all duration-500 ease-in-out origin-top") do
      error_messages.first.html_safe
    end
  end
end
