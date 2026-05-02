class Admin::StorefrontsController < ApplicationController
  layout "storefront_layout"
  before_action :set_store

  def edit
    @products = preview_products
  end

  def update
    if @store.update(design_params)
      head :no_content
    else
      render json: { errors: @store.errors.as_json }, status: :unprocessable_entity
    end
  end

  def share
    render layout: false if turbo_frame_request?
  end

  private

  def set_store
    @store = current_user.store
  end

  def design_params
    permitted = params.require(:store).permit(
      :vibe, :hero_layout, :border_radius, :aspect_ratio, :grain_enabled
    )
    permitted[:border_radius] = permitted[:border_radius].to_i if permitted.key?(:border_radius)
    permitted[:grain_enabled] = ActiveModel::Type::Boolean.new.cast(permitted[:grain_enabled]) if permitted.key?(:grain_enabled)
    permitted
  end

  def preview_products
    real = @store.products.with_attached_images.active.order(created_at: :desc).limit(4).to_a
    real.any? ? real : Storefront::SampleProducts.build
  end
end
