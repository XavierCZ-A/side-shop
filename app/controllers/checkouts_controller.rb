class CheckoutsController < StoreBaseController
  allow_unauthenticated_access only: %i[ show ]

  def show
    redirect_to store_root_path, notice: "Tu carrito está vacío" and return if @cart.line_items.empty?

    @line_items = @cart.line_items.includes(:product)
  end
end
