class StoresController < ApplicationController
  before_action :set_store

  def show
    @products = @store.products.with_attached_images
  end

  private

  def set_store
    @store = Store.find_by(slug: params[:store_slug])

    unless @store
      render 'errors/store_not_found', status: :not_found
    end
  end
end
