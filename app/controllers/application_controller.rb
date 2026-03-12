class ApplicationController < ActionController::Base
  include Authentication
  before_action :check_onboarding_status
  before_action :set_public_store
  before_action :set_store_cart
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def check_onboarding_status
    return unless current_user
    redirect_to onboardings_path unless current_user.store&.onboarding_complete?
  end

  private

  def set_public_store
    return unless params[:store_slug].present?
    @store = Store.find_by!(slug: params[:store_slug])
  end

  def set_store_cart
    return unless @store
    session[:store_carts] ||= {}
    
    cart_id = session.dig(:store_carts, @store.id.to_s)
    
    @cart = @store.carts.find_by(id: cart_id) if cart_id

    if @cart.nil?
      @cart = @store.carts.create!
      session[:store_carts][@store.id.to_s] = @cart.id
    end
  end
end
