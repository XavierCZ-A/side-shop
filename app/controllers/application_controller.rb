class ApplicationController < ActionController::Base
  include Pagy::Method
  include Authentication
  before_action :check_onboarding_status
  before_action :current_plan
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def check_onboarding_status
    return unless current_user
    redirect_to onboardings_path unless current_user.store&.onboarding_complete?
  end

  def current_plan
    processor = current_user&.payment_processor
    subscription = processor&.subscriptions&.order(created_at: :desc)&.first
    @current_plan ||= subscription&.name || "Basico"
  end
end
