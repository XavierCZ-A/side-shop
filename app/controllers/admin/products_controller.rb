class Admin::ProductsController < Admin::AdminBaseController
  layout "dashboard_layout"
  before_action :set_product, only: %i[ edit update toggle_active ]

  # GET /products
  def index
    products = current_user.store.products.with_attached_images
    @all_products = products

    case params[:status]
    when "active"   then products = products.active
    when "inactive" then products = products.inactive
    end

    products = products.search_by_name(params[:query])
    products = products.sorted_by(params[:sort], params[:dir])

    @pagy, @products = pagy(:offset, products, limit: 6)
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
      redirect_to admin_products_path, notice: "Producto creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice: "Producto actualizado exitosamente."
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

  def search
    @query = params[:q].to_s.strip
    @products = @query.present? ? @store.products.active.where("name ILIKE ?", "%#{@query}%").limit(6) : []
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = current_user.store.products.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.expect(product: [ :name, :price, :stock, :description, :active, images: [] ])
    end
end
