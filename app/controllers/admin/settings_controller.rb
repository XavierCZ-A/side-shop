class Admin::SettingsController < ApplicationController
  layout "dashboard_layout"

  def show
    processor = current_user.payment_processor

    @subscription   = processor&.subscriptions&.order(created_at: :desc)&.first
    @charges        = processor&.charges&.last(5)
    @plans          = PricingPlan.all
    @current_plan   = @subscription&.name || "Basico"
    @default_method = @charges.first

    if params[:success]
      flash.now[:notice] = "¡Suscripción activada! Bienvenido."
    end
  end
end
