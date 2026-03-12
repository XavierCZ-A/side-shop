class CartsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  allow_unauthenticated_access only: %i[ show destroy ]

  def show
    @products = @cart.line_items.includes(:product)
  end

  def destroy
    @cart.destroy if @cart.id == session[:store_carts][@store.id]
    session[:store_carts][@store.id] = nil
    redirect_to store_path(store_slug: @store.slug), notice: 'Tu carrito se vació'
  end

  private

  def invalid_cart
    logger.error "Attempt to access invalid cart #{params[:id]}"
    redirect_to store_path(@store.slug), notice: "El carrito no existe"
  end
end
