class Admin::DashboardsController < Admin::AdminBaseController
  layout "dashboard_layout"

  TABS = %w[products orders].freeze
  PRODUCT_STATUSES = %w[active inactive].freeze

  def index
    @tab = TABS.include?(params[:tab]) ? params[:tab] : "products"

    if @tab == "products"
      @product_status = PRODUCT_STATUSES.include?(params[:status]) ? params[:status] : "active"
      @products = @store.products.with_attached_images.public_send(@product_status).order(created_at: :desc)
      @active_count = @store.products.active.count
      @inactive_count = @store.products.inactive.count
    else
      @orders = []
    end
  end

  def edit
  end

  def update
    if @store.update(store_params)
      redirect_to admin_root_path, notice: "Tienda actualizada correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def store_params
    params.expect(store: [ :name, :description, :instagram, :facebook, :whatsapp, :primary_color, :image ])
  end
end
