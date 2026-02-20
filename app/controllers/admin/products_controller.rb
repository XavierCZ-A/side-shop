class Admin::ProductsController < ApplicationController
  before_action :set_product, only: %i[ edit update ]

  def index
    @products = Product.all
  end

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
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "Producto actualizado exitosamente." }
        format.html { redirect_to admin_root_path, notice: "Producto actualizado exitosamente." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.expect(product: [ :name, :price, :description, :active, :store_id, images: [] ])
    end
end
