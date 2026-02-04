class StoresController < ApplicationController
  def show
    @store = Store.find_by!(slug: params[:store_slug])
    @products = @store.products
  end
end
