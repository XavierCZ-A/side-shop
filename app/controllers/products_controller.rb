class ProductsController < StoreBaseController
  allow_unauthenticated_access only: %i[ index show search ]
  skip_before_action :check_onboarding_status

  def index
    products = @current_store.products.with_attached_images.active
    products = products.search_by_name(params[:q])
    @pagy, @products = pagy(:offset, products, limit: 24)
  end

  def show
    @product = @current_store.products.active.find(params[:id])
    @related_products = @current_store.products.active.where.not(id: @product.id).limit(4)
  end

  def search
    @query = params[:q].to_s.strip
    @products = @query.present? ? @current_store.products.active.search_by_name(@query).limit(6) : []
  end
end
