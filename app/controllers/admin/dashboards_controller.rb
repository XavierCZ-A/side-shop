class Admin::DashboardsController < ApplicationController
  layout "dashboard_layout"
  before_action :set_store

  def index
    @tab = %w[products orders].include?(params[:tab]) ? params[:tab] : "products"
    
    if @tab == "products"
      @products = @store.products.with_attached_images.order(created_at: :desc)
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
    params.require(:store).permit(:name, :description, :instagram, :facebook, :whatsapp, :primary_color)
  end

  def set_store
    @store = current_user.store
  end
end
