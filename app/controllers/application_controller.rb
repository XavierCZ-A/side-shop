class ApplicationController < ActionController::Base
  include Authentication
  before_action :check_onboarding_status
  before_action :set_cart
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def check_onboarding_status
    redirect_to onboardings_path unless current_user.store&.onboarding_complete?
  end

  private

  def set_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end
