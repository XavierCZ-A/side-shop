class StoresController < ApplicationController
  allow_unauthenticated_access only: %i[ show ]
  skip_before_action :check_onboarding_status

  def show
    @products = @store.products.with_attached_images
  end
end
