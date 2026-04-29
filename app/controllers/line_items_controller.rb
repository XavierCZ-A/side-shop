class LineItemsController < StoreBaseController
  skip_before_action :check_onboarding_status
  allow_unauthenticated_access

  def create
    product = @current_store.products.find(params[:product_id])
    @line_item = @cart.add_product(product)

    if @line_item.save
      respond_to do |format|
        format.html { redirect_to store_root_path(store_slug: @current_store.slug) }
        format.turbo_stream { flash.now[:notice] = "Añadido al carrito test: #{product.name}" }
      end
    else
      redirect_to store_root_path(store_slug: @current_store.slug), alert: "No se pudo añadir al carrito"
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
        format.html { redirect_to cart_path }
        format.turbo_stream
      end
    else
      redirect_to cart_path, alert: "No se pudo actualizar el carrito"
    end
  end

  def destroy
    @line_item = @cart.line_items.find(params[:id])
    @line_item.destroy
    redirect_to cart_path, status: :see_other
  end
end
