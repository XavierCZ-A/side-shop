class ApplicationController < ActionController::Base
  include Authentication
  before_action :check_onboarding_status
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def check_onboarding_status
    return unless current_user
    redirect_to onboardings_path unless current_user.store&.onboarding_complete?
  end
end
