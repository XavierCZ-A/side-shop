class LineItemsController < ApplicationController
  skip_before_action :check_onboarding_status
  allow_unauthenticated_access

  def create
    product = @store.products.find(params[:product_id])
    @line_item = @cart.add_product(product)

    if @line_item.save
      flash.now[:notice] = "Añadido al carrito: #{product.name}"
      respond_to do |format|
        format.html { redirect_to store_path(store_slug: @store.slug), notice: "Añadido al carrito" }
        format.turbo_stream
      end
    else
      redirect_to store_path(store_slug: @store.slug), alert: "No se pudo añadir al carrito"
    end
  end
  
  def update
    @line_item = @cart.line_items.find(params[:id])
    
    if params[:operation] == "increment"
      @line_item.quantity += 1
    elsif params[:operation] == "decrement" && @line_item.quantity > 1
      @line_item.quantity -= 1
    end

    if @line_item.save
      respond_to do |format|
        format.html { redirect_to carts_path(@store.slug, @cart) }
        format.turbo_stream
      end
    else
      redirect_to carts_path(@store.slug, @cart), alert: "No se pudo actualizar el carrito"
    end
  end

  def destroy
    @line_item = @cart.line_items.find(params[:id])
    @line_item.destroy
    redirect_to carts_path(@store.slug, @cart), status: :see_other
  end
end