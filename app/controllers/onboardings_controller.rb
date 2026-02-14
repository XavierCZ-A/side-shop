class OnboardingsController < ApplicationController
  skip_before_action :check_onboarding_status
  before_action :redirect_if_already_completed

  def show
    @onboarding = Onboarding.new
  end

  def create
    @onboarding = Onboarding.new(onboarding_params)
    @onboarding.current_user = current_user

    # TODO aqui seria un redirect a dashboard si ya tiene tienda creada
    if @onboarding.save
      redirect_to admin_root_path, notice: "¡Tienda creada exitosamente! 🎉"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def onboarding_params
    params.expect(onboarding: [
      :name,
      :industry,
      :other_industry,
      :primary_color,
      :product_name,
      :price,
    ])
  end

  # TODO aqui seria un redirect a dashboard si ya tiene tienda creada
  def redirect_if_already_completed
    if current_user&.store&.onboarding_complete?
      redirect_to root_path
    end
  end
end
