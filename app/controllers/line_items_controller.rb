class LineItemsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)
    @primary_color = product.store&.primary_color

    if @line_item.save
      flash.now[:notice] = "Añadido al carrito: #{product.name}"
      respond_to do |format|
        format.html { redirect_to admin_root_path, notice: "Añadido al carrito" }
        format.turbo_stream
      end
    else
      flash.now[:alert] = "No se pudo añadir al carrito"
      render :index, status: :unprocessable_entity
    end
  end
  
  def update
    @line_item = @cart.line_items.find(params[:id])
    
    if params[:operation] == "increment"
      @line_item.quantity += 1
    elsif params[:operation] == "decrement" && @line_item.quantity > 1
      @line_item.quantity -= 1
    end

    @line_item.save
    
    respond_to do |format|
      format.html { redirect_to cart_path(@cart) }
      format.turbo_stream
    end
  end

  def destroy
    @line_item = @cart.line_items.find(params[:id])
    @line_item.destroy
    redirect_to cart_path(@cart), status: :see_other
  end
end