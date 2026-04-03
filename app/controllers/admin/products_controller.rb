class Admin::ProductsController < ApplicationController
  before_action :set_product, only: %i[ edit update toggle_active ]

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @store = current_user.store
    @product = @store.products.build(product_params)
    if @product.save
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "Producto creado exitosamente." }
        format.html { redirect_to admin_root_path, notice: "Producto creado exitosamente." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    if @product.update(product_params)
      # @product.images.attach(params[:product][:images]) if params[:product][:images].present?
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "Producto actualizado exitosamente." }
        format.html { redirect_to admin_root_path, notice: "Producto actualizado exitosamente." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_active
    @product.toggle_active!
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "Producto #{@product.active? ? 'activado' : 'desactivado'} exitosamente." }
      format.html { redirect_to admin_root_path, notice: "Producto #{@product.active? ? 'activado' : 'desactivado'} exitosamente." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = current_user.store.products.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.expect(product: [ :name, :price, :description, :active, images: [] ])
    end
end
