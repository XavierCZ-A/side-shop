class StoreBaseController < ApplicationController
  include StoreScoped
  before_action :set_store_cart

  private

  def set_store_cart
    return unless @current_store
    session[:store_carts] ||= {}

    cart_id = session.dig(:store_carts, @current_store.id.to_s)

    @cart = @current_store.carts.find_by(id: cart_id) if cart_id

    if @cart.nil?
      @cart = @current_store.carts.create!
      session[:store_carts][@current_store.id.to_s] = @cart.id
    end
  end
end
