class Admin::DashboardsController < ApplicationController
  layout "dashboard_layout"
  def index
    @tab = %w[products orders].include?(params[:tab]) ? params[:tab] : "products"
    user_store = current_user.store

    if @tab == "products"
      @products = user_store.products.order(created_at: :desc)
    else
      @orders = []
    end
  end

  def edit
  end

  def update
    @store = current_user.store

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
end
