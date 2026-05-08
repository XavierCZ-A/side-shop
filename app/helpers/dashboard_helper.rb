module DashboardHelper
  TAB_BASE_CLASSES = "px-6 py-2 rounded-full text-sm font-medium transition-all duration-200".freeze
  TAB_ACTIVE_CLASSES = "bg-white shadow-sm text-[#1A2B3C]".freeze
  TAB_INACTIVE_CLASSES = "text-[#4B5563] hover:text-[#1A2B3C]".freeze

  def dashboard_tab_button(label, tab_key, current_tab:)
    active = current_tab == tab_key

    render Buttons::Component.new(
      text: label,
      pill: true,
      variant: :ghost,
      classes: "#{TAB_BASE_CLASSES} #{active ? TAB_ACTIVE_CLASSES : TAB_INACTIVE_CLASSES}",
      href: admin_root_path(tab: tab_key),
      data: { turbo_frame: "dashboard_content" }
    )
  end
end
