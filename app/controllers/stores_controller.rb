class StoresController < StoreBaseController
  allow_unauthenticated_access only: %i[ show ]
  skip_before_action :check_onboarding_status

  def show
    products = @current_store.products.with_attached_images.active
    @pagy, @products = pagy(:offset, products, limit: 8)
  end
end
