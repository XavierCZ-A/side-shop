class Admin::BillingController < ApplicationController

  def show
    processor = current_user.payment_processor

    @subscription   = processor&.subscription
    @charges        = processor&.charges&.last(5)
    @plans          = PricingPlan.all
    @current_plan   = @subscription&.name
    @default_method = @charges.first

    if params[:success]
      flash.now[:notice] = "¡Suscripción activada! Bienvenido."
    end
  end

  def portal
    portal_session = current_user.payment_processor.billing_portal(
      return_url: admin_billing_url
    )
    redirect_to portal_session.url, allow_other_host: true

  rescue Stripe::AuthenticationError => e
    logger.error "Error al crear sesión del portal de facturación: #{e.message}"
    redirect_to admin_billing_url, alert: "Ocurrió un error al acceder al portal de facturación. Por favor, intenta nuevamente."
  end
end